Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56308 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203Ab3FFK0Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 06:26:24 -0400
Message-ID: <51B063C7.5040509@openwrt.org> (sfid-20130606_122627_557234_C2B57338)
Date: Thu, 06 Jun 2013 12:26:15 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, mickflemm@gmail.com,
	mcgrof@qca.qualcomm.com, rmanohar@qca.qualcomm.com,
	adrian@freebsd.org, ath5k-devel@lists.ath5k.org,
	bvahl@net.t-labs.tu-berlin.de
Subject: Re: [PATCH] ath5k: make use of the new rate control API
References: <1370509492-24293-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1370509492-24293-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-06-06 11:04 AM, Thomas Huehn wrote:
> This patch enabels ath5k to use the new rate table to lookup each
> mrr rate and retry information per packet.
> 
> Signed-off-by: Benjamin Vahl <bvahl@net.t-labs.tu-berlin.de>
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
This patch is missing changes in the tx status path. At tx completion,
info->status.rates needs to be filled with the contents of bf->rates
before filling in retry counts.

> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
>  static int
>  ath5k_txbuf_setup(struct ath5k_hw *ah, struct ath5k_buf *bf,
> -		  struct ath5k_txq *txq, int padsize)
> +		  struct ath5k_txq *txq, int padsize,
> +		  struct ieee80211_tx_control *control)
>  {
>  	struct ath5k_desc *ds = bf->desc;
>  	struct sk_buff *skb = bf->skb;
>  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>  	unsigned int pktlen, flags, keyidx = AR5K_TXKEYIX_INVALID;
>  	struct ieee80211_rate *rate;
> +	struct ieee80211_tx_rate txrate;
>  	unsigned int mrr_rate[3], mrr_tries[3];
>  	int i, ret;
>  	u16 hw_rate;
> @@ -722,12 +765,15 @@ ath5k_txbuf_setup(struct ath5k_hw *ah, struct ath5k_buf *bf,
>  		duration = le16_to_cpu(ieee80211_ctstoself_duration(ah->hw,
>  			info->control.vif, pktlen, info));
>  	}
> +
> +	txrate.count = bf->rates[0].count;
> +
>  	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
>  		ieee80211_get_hdrlen_from_skb(skb), padsize,
>  		get_hw_packet_type(skb),
>  		(ah->ah_txpower.txp_requested * 2),
>  		hw_rate,
> -		info->control.rates[0].count, keyidx, ah->ah_tx_ant, flags,
> +		txrate.count, keyidx, ah->ah_tx_ant, flags,
>  		cts_rate, duration);
>  	if (ret)
>  		goto err_unmap;
The txrate variable is pointless, you only use txrate.count where you
could also just use bf->rates[0].count directly.

- Felix
