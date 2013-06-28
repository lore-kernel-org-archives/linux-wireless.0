Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37154 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab3F1W0s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 18:26:48 -0400
Received: by mail-we0-f174.google.com with SMTP id q58so1642899wes.19
        for <linux-wireless@vger.kernel.org>; Fri, 28 Jun 2013 15:26:47 -0700 (PDT)
Message-ID: <51CE0DA4.7090608@gmail.com> (sfid-20130629_002702_697280_C1D55286)
Date: Sat, 29 Jun 2013 00:26:44 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Gabor Juhos <juhosg@openwrt.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 19/19] rt2x00: rt2800usb: add USB device ID for Linksys
 AE3000
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos wrote:

> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index c24c1fd..6136871 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -1183,6 +1183,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
>  	{ USB_DEVICE(0x04bb, 0x0944) },
>  	/* Linksys */
>  	{ USB_DEVICE(0x13b1, 0x002f) },
> +	{ USB_DEVICE(0x13b1, 0x003b) },
>  	{ USB_DEVICE(0x1737, 0x0079) },
>  	/* Ralink */
>  	{ USB_DEVICE(0x148f, 0x3572) },
> -- 

You should separate RT3573 and RT3572 devices.
Rename CONFIG_RT2800USB_RT35XX to CONFIG_RT2800USB_RT3572
and do a new CONFIG_RT2800USB_RT3573 section.


And also you can add safely this usb-ids. All of them
are RT3573 devices:

0x1b75, 0x7733 AirLive 450Mbps Wireless-N Dual Band USB Adapter
0x0b05, 0x17bc ASUS USB-N66 450Mbps Dual Band USB Adapter
0x0b05, 0x17ad ASUS USB-N66 Dual Band N Network Adapter
0x050d, 0x1103 Belkin Wireless Adapter
0x148f, 0xf301 Cameo Ralink3573 3x3 single band USB dongle
0x7392, 0x7733 Edimax
0x0e66, 0x0020 Hawking HD45U Dual Band USB Wireless-N Adapter
0x0e66, 0x0021 Hawking HD45U Dual Band Wls-450N Adapter
0x04bb, 0x094e I-O DATA WN-AG450U Wireless LAN Adapter
0x0789, 0x016b Logitec LAN-W450AN/U2
0x0846, 0x9012 NETGEAR WNDA4100 N900 Wireless Dual Band USB Adapter
0x0846, 0x9019 NETGEAR WNDA4200D Wireless Dual Band USB Adapter
0x2019, 0xed19 Planex GW-USDual450
0x148f, 0x3573 Ralink 802.11n USB Wireless LAN Card
0x0df6, 0x0067 Sitecom Wireless Dualband Network Adapter N750 X6
0x0df6, 0x006a Sitecom Wireless Dualband Network Adapter N900 X7
0x0586, 0x3421 ZyXEL Dual-Band Wireless N450 USB Adapter

-thank you-
