Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53760 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab1AROzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 09:55:50 -0500
Subject: Re: [PATCH v2] mac80211: drop non-auth 3-addr data frames when
 running as a 4-addr station
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1295362128-2294-1-git-send-email-nbd@openwrt.org>
References: <1295362128-2294-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 15:55:47 +0100
Message-ID: <1295362547.3563.22.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-18 at 15:48 +0100, Felix Fietkau wrote:
> When running as a 4-addr station against an AP that has the 4-addr VLAN
> interface and the main 3-addr AP interface bridged together, sometimes
> frames originating from the station were looping back from the 3-addr AP
> interface, causing the bridge code to emit warnings about receiving frames
> with its own source address.
> I'm not sure why this is happening yet, but I think it's a good idea to
> drop all frames (except 802.1x/EAP frames) that do not match the configured
> addressing mode, including 4-address frames sent to a 3-address station.
> User test reports indicate that the problem goes away with this patch.

This looks better, thanks. But did they really test _this_ patch? :)

johannes

> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  net/mac80211/rx.c |   25 ++++++++++++++++++++++---
>  1 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index a6701ed..1236710 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1556,17 +1556,36 @@ __ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
>  {
>  	struct ieee80211_sub_if_data *sdata = rx->sdata;
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
> +	bool check_port_control = false;
> +	struct ethhdr *ehdr;
> +	int ret;
>  
>  	if (ieee80211_has_a4(hdr->frame_control) &&
>  	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN && !sdata->u.vlan.sta)
>  		return -1;
>  
> +	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
> +	    !!sdata->u.mgd.use_4addr != !!ieee80211_has_a4(hdr->frame_control)) {
> +
> +		if (!sdata->u.mgd.use_4addr)
> +			return -1;
> +		else
> +			check_port_control = true;
> +	}
> +
>  	if (is_multicast_ether_addr(hdr->addr1) &&
> -	    ((sdata->vif.type == NL80211_IFTYPE_AP_VLAN && sdata->u.vlan.sta) ||
> -	     (sdata->vif.type == NL80211_IFTYPE_STATION && sdata->u.mgd.use_4addr)))
> +	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN && sdata->u.vlan.sta)
>  		return -1;
>  
> -	return ieee80211_data_to_8023(rx->skb, sdata->vif.addr, sdata->vif.type);
> +	ret = ieee80211_data_to_8023(rx->skb, sdata->vif.addr, sdata->vif.type);
> +	if (ret < 0 || !check_port_control)
> +		return ret;
> +
> +	ehdr = (struct ethhdr *) rx->skb->data;
> +	if (ehdr->h_proto != rx->sdata->control_port_protocol)
> +		return -1;
> +
> +	return 0;
>  }
>  
>  /*


