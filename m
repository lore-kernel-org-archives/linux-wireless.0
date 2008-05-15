Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3327 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbYEOTUx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 15:20:53 -0400
Date: Thu, 15 May 2008 14:57:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-usb@vger.kernel.org, Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andreamrl@tiscali.it>
Subject: Re: [patch] resource leak in error case in rtl8187
Message-ID: <20080515185724.GA17690@tuxdriver.com> (sfid-20080515_212101_447777_FAA87E18)
References: <200805151617.37968.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200805151617.37968.oliver@neukum.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 15, 2008 at 04:17:36PM +0200, Oliver Neukum wrote:
> Hi,
> 
> this fixes a resource leak in the error case of the write code path.
> 
> 	Regards
> 		Oliver
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.de>
> 
> ---
> 
> --- linux-2.6.26-rc1/drivers/net/wireless/rtl8187_dev.c.alt	2008-05-15 15:53:58.000000000 +0200
> +++ linux-2.6.26-rc1/drivers/net/wireless/rtl8187_dev.c	2008-05-15 15:57:35.000000000 +0200
> @@ -169,6 +169,7 @@ static int rtl8187_tx(struct ieee80211_h
>  	struct urb *urb;
>  	__le16 rts_dur = 0;
>  	u32 flags;
> +	int rv;
>  
>  	urb = usb_alloc_urb(0, GFP_ATOMIC);
>  	if (!urb) {
> @@ -208,7 +209,11 @@ static int rtl8187_tx(struct ieee80211_h
>  	info->dev = dev;
>  	usb_fill_bulk_urb(urb, priv->udev, usb_sndbulkpipe(priv->udev, 2),
>  			  hdr, skb->len, rtl8187_tx_cb, skb);
> -	usb_submit_urb(urb, GFP_ATOMIC);
> +	rv = usb_submit_urb(urb, GFP_ATOMIC);
> +	if (rv < 0) {
> +		usb_free_urb(urb);
> +		kfree_skb(skb);
> +	}
>  
>  	return 0;
>  }

Don't we need the same type of fix applied to rtl8187_iowrite_async
as well?  Would you like to resubmit (or submit a second patch)
with that fix included?

Also, a nit: I would prefer "rc" instead of "rv" just for idiomatic
purposes.

John
-- 
John W. Linville
linville@tuxdriver.com
