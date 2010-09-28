Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:38038 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752811Ab0I1XEP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 19:04:15 -0400
Date: Tue, 28 Sep 2010 16:02:11 -0700
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
Cc: linville@tuxdriver.com, stable@kernel.org,
	linux-wireless@vger.kernel.org, Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@Atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Vasanthakumar Thiagarajan <vasanth@Atheros.com>
Subject: Re: [PATCH] mac80211: fix rate_control_send_low warnings for delbas
Message-ID: <20100928230211.GA9844@jm.kir.nu>
References: <20100928222945.GB10932@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100928222945.GB10932@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 28, 2010 at 03:29:45PM -0700, Luis R. Rodriguez wrote:

> Added support for cfg80211/mac80211 to cleanly roam between two BSSes
> on an ESS by allowing the station to reassociate to an old AP and
> only when that is done drop the old association. What we forgot to
> take into consideration is that when we disassociate with the older
> AP we may need to transmit frames to that AP and those frames may
> actually be intended to go under a different channel and even sometimes
> a completely separate band than the new APs.

which frames are you talking about here? When reassociating to a new BSS
in an ESS, there should be no need to transmit frames to the old AP
anymore, i.e., we are never associated with more than one BSS (when
talking about a single vif). We could just drop any potential TX frame
to the old AP after the moment the new AP is marked associated.


> + * @channel: the channel this sta belongs to

>  struct ieee80211_sta {
> +	struct ieee80211_channel *channel;
>  	u32 supp_rates[IEEE80211_NUM_BANDS];
>  	u8 addr[ETH_ALEN];
>  	u16 aid;

> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c

> @@ -1213,6 +1217,12 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
>  	if (!tx->sta)
>  		tx->sta = sta_info_get(sdata, hdr->addr1);
>  
> +	if (tx->sta && tx->sta->sta.channel &&
> +	    tx->sta->sta.channel->center_freq != tx->channel->center_freq) {
> +		I802_DEBUG_INC(local->tx_handlers_drop_wrong_channel);
> +		return TX_DROP;
> +	}

Could this drop some off-channel frames should we happen to have a STA
entry for the destination? I'm not sure about all implications of this,
but I could not convince myself that this would be safe for all P2P use
cases (e.g., frame exchange on non-operating  channel with a device that
happens to be in group with us).

 
-- 
Jouni Malinen                                            PGP id EFC895FA
