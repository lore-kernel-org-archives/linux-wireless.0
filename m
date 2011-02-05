Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dspam.koyote.com ([204.11.31.20]:3869 "EHLO vopmail.neato.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab1BEXoI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Feb 2011 18:44:08 -0500
Subject: Re: [PATCH] mac80211: as a 4-addr station, do not receive packets
 for other stations
From: Steve Brown <sbrown@cortland.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
In-Reply-To: <1296946117-23329-1-git-send-email-nbd@openwrt.org>
References: <1296946117-23329-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Feb 2011 16:44:00 -0700
Message-ID: <1296949440.27336.32.camel@nm.ewol.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-02-05 at 23:48 +0100, Felix Fietkau wrote:
> Since 4-addr frames completely override the source address which will
> make it into the converted 802.3 frames, receiving frames for other
> 4-addr stations will confuse the bridging code.
> 
> To be able to handle traffic for all connected devices, the bridge
> code will automatically turn on promiscuous mode, which triggers
> this problem.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Reported-by: Steve Brown <sbrown@cortland.com>
> ---
>  net/mac80211/rx.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index b5f59ed..50c2c88 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -2646,7 +2646,8 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
>  			return 0;
>  		if (!multicast &&
>  		    compare_ether_addr(sdata->vif.addr, hdr->addr1) != 0) {
> -			if (!(sdata->dev->flags & IFF_PROMISC))
> +			if (!(sdata->dev->flags & IFF_PROMISC) ||
> +			    sdata->u.mgd.use_4addr)
>  				return 0;
>  			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
>  		}
Tested:

computer1->sta1->ap->sta2->computer2

Thanks,

Steve


