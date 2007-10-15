Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from probity.mcc.ac.uk ([130.88.200.94]:65430 "EHLO
	probity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762AbXJOLFq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 07:05:46 -0400
Message-ID: <4713498E.8040305@gentoo.org> (sfid-20071015_120550_140444_EE1F314A)
Date: Mon, 15 Oct 2007 12:05:50 +0100
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: Marc Pignat <marc.pignat@hevs.ch>, linux-wireless@vger.kernel.org,
	kune@deine-taler.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zd1211rw, fix oops when ejecting install media
References: <200710150851.52995.marc.pignat@hevs.ch>
In-Reply-To: <200710150851.52995.marc.pignat@hevs.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marc Pignat wrote:
> The disconnect function can dereference the net_device structure before it is
> allocated. This is the case when ejecting the device installer.
> 
> Signed-off-by: Marc Pignat <marc.pignat@hevs.ch>

s/before it is allocated/when it is never allocated/

Acked-by: Daniel Drake <dsd@gentoo.org>

> ---
> 
> Hello!
> 
> Patch against 2.6.23.
> This patch fixes the bug I've submitted to linux-wireless friday in the
> "zd1211rw on 2.6.23 oops ejecting device" thread.
> 
> Regards
> 
> Marc
> 
> --- drivers/net/wireless/zd1211rw/zd_usb.c.orig	2007-10-15 08:29:16.000000000 +0200
> +++ drivers/net/wireless/zd1211rw/zd_usb.c	2007-10-15 08:29:32.000000000 +0200
> @@ -1041,14 +1041,17 @@ error:
>  static void disconnect(struct usb_interface *intf)
>  {
>  	struct net_device *netdev = zd_intf_to_netdev(intf);
> -	struct zd_mac *mac = zd_netdev_mac(netdev);
> -	struct zd_usb *usb = &mac->chip.usb;
> +	struct zd_mac *mac;
> +	struct zd_usb *usb;
>  
>  	/* Either something really bad happened, or we're just dealing with
>  	 * a DEVICE_INSTALLER. */
>  	if (netdev == NULL)
>  		return;
>  
> +	mac = zd_netdev_mac(netdev);
> +	usb = &mac->chip.usb;
> +
>  	dev_dbg_f(zd_usb_dev(usb), "\n");
>  
>  	zd_netdev_disconnect(netdev);
> 
> 

