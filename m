Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51730 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934109Ab3BMPIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 10:08:42 -0500
Message-ID: <1360768118.8868.26.camel@jlt4.sipsolutions.net> (sfid-20130213_160845_746549_9A2EBAAC)
Subject: Re: [RFCv5 1/2] mac80211: free ps->bc_buf skbs on vlan device stop
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	projekt-wlan@fem.tu-ilmenau.de
Date: Wed, 13 Feb 2013 16:08:38 +0100
In-Reply-To: <1360759880-5669-2-git-send-email-michael-dev@fami-braun.de> (sfid-20130213_155055_526044_F505A9C5)
References: <1360759880-5669-1-git-send-email-michael-dev@fami-braun.de>
	 <1360759880-5669-2-git-send-email-michael-dev@fami-braun.de>
	 (sfid-20130213_155055_526044_F505A9C5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-13 at 13:51 +0100, Michael Braun wrote:
> When the vlan device is removed, ps->bc_buf processing can no longer
> send its frames.
> 
> Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
> ---
> V4: Add this patch.
> V5: add spin_lock, switch order of patches
>  net/mac80211/iface.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index 40ff030..bb1cdc6 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -680,6 +680,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>  	struct sk_buff *skb, *tmp;
>  	u32 hw_reconf_flags = 0;
>  	int i, flushed;
> +	struct ps_data *ps;
>  
>  	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
>  
> @@ -758,6 +759,19 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>  					 u.vlan.list)
>  			dev_close(vlan->dev);
>  		WARN_ON(!list_empty(&sdata->u.ap.vlans));
> +	} else if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
> +		/* remove all packets in parent bc_buf pointing to this dev */
> +		ps = &sdata->bss->ps;
> +
> +	        spin_lock_irqsave(&ps->bc_buf.lock, flags);
> +		skb_queue_walk_safe(&ps->bc_buf, skb, tmp) {
> +			if (skb->dev == sdata->dev) {
> +				__skb_unlink(skb, &ps->bc_buf);
> +				local->total_ps_buffered--;
> +				kfree_skb(skb);

Ok actually I guess I spoke too soon -- please also change kfree_skb()
to ieee80211_free_txskb()

johannes

