Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:38344 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbZLBQ35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 11:29:57 -0500
Received: by gxk26 with SMTP id 26so297913gxk.1
        for <linux-wireless@vger.kernel.org>; Wed, 02 Dec 2009 08:30:03 -0800 (PST)
Message-ID: <4B169608.3010902@lwfinger.net>
Date: Wed, 02 Dec 2009 10:30:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?QW50dGkgS2FpamFubcOka2k=?= <antti@kaijanmaki.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: New rtl8187 rfkill support blocks my wlan for good.
References: <1259756709.31590.62.camel@peura.elisa-laajakaista.fi>
In-Reply-To: <1259756709.31590.62.camel@peura.elisa-laajakaista.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/02/2009 06:25 AM, Antti Kaijanmäki wrote:
> Hello,
> 
> I wanted to give a try to your compat-wireless bleeding edge drivers. I
> have an RTL8187 based wlan chip on my laptop. After installing the
> driver I was not able to use the WiFi anymore as the driver reports that
> the kill switch is active no matter in what position I turn the switch
> on the side of the laptop.
> 
> Here's the dmesg output of the chip detection:
> 
> [   20.686680] phy0: Selected rate control algorithm 'minstrel'
> [   20.687554] phy0: hwaddr 00:1b:9e:eb:77:98, RTL8187BvE V0 + rtl8225z2
> [   20.710529] rtl8187: Customer ID is 0x04
> [   20.710588] Registered led device: rtl8187-phy0::tx
> [   20.710611] Registered led device: rtl8187-phy0::rx
> [   20.711393] rtl8187: wireless switch is off
> 
> I checked the driver and found the rtl8187_rfkill.c. I added some
> prink's to see what's happening and noticed that the physical switch did
> affect different bit than the one tested in the current driver. This
> change enables the correct behavior on my laptop:
> 
> --- rtl8187_rfkill.c.orig	2009-12-02 14:12:34.646597569 +0200
> +++ rtl8187_rfkill.c	2009-12-02 14:10:09.474593370 +0200
> @@ -28,7 +28,7 @@ static bool rtl8187_is_radio_enabled(str
>  	rtl818x_iowrite8(priv, &priv->map->GPIO0, gpio & ~0x02);
>  	gpio = rtl818x_ioread8(priv, &priv->map->GPIO1);
>  
> -	return gpio & 0x02;
> +	return gpio & 0x04;
>  }
> 
> 
> I tried to contact Realtek to provide me with some specs so that I can
> verify the register in question, but all I received was a reply with the
> realtek's reference driver attached. I haven't got any answer to my
> follow-up request for the specification. 
> 
> I looked through the reference driver but could not find anything
> informational. I didn't have time to do a full review, though.
> 
> Without the specification I can't tell how this can be fixed. People
> have reported success with the current driver, haven't they, so the bit
> is correct for them.
> 
> As soon as distributions start shipping the new rtl8187 driver there are
> people whose wlan stops working. I don't know if the killswitch with
> rtl8187 chipsets is suppose to be only created with software but at
> least in my laptop it didn't matter in which position the switch was
> with older drivers, the radio worked anyway. 
> 
> Any thoughts how to continue with this?

As wireless in Linux approaches the correct behavior with respect to
killing wireless, there will be some cases like yours. Having the
radio work no matter the switch position is just plain wrong. I hope
you understand that.

What laptop do you have? If the RTL8187 built in or externally
plugged? If built in, is there a WMI driver for it? Do you have it loaded?

Larry

