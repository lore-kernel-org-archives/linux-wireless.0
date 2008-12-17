Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49007 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbYLQSah (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 13:30:37 -0500
Subject: Re: [RFC] mac80211: Print unknown packet type
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <494944AD.7020204@lwfinger.net>
References: <494944AD.7020204@lwfinger.net>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 19:15:46 +0100
Message-Id: <1229537746.4268.13.camel@localhost> (sfid-20081217_193040_947464_0E0C32F4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-12-17 at 12:27 -0600, Larry Finger wrote:
> Johannes,
> 
> I'm trying to find a problem with p54usb that causes it to go belly-up under
> stress testing. In one of my runs, I hit the WARN_ON in
> ieee80211_tasklet_handler(). Unfortunately, I got no indication of what was in
> skb->pkt_type, just that it was not one of the expected types.

That really points to memory corruption somewhere.

> Do you think that adding the printk below would be worthwhile?
> 
> Thanks,
> 
> Larry
> ---
> 
> Index: wireless-testing/net/mac80211/main.c
> ===================================================================
> --- wireless-testing.orig/net/mac80211/main.c
> +++ wireless-testing/net/mac80211/main.c
> @@ -341,6 +341,8 @@ static void ieee80211_tasklet_handler(un
>  			dev_kfree_skb(skb);
>  			break ;
>  		default:
> +			printk(KERN_INFO "mac80211: Packet is of unknown type"
> +					 " %d\n", skb->pkt_type);
>  			WARN_ON(1);

Seems reasonable to me. I'd do

+	WARN(1, "mac80211: ...", skb->pkt_type);
-	WARN_ON(1);

instead.

johannes

