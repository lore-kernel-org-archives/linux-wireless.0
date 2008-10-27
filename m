Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:56241 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464AbYJ0RIq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 13:08:46 -0400
Message-ID: <4905F59B.9030107@lwfinger.net> (sfid-20081027_180850_972377_D83F4099)
Date: Mon, 27 Oct 2008 10:08:43 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Piter PUNK <piterpk@terra.com.br>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8187B transmit problems
References: <49041DAE.1060206@terra.com.br> <49050BC7.1010609@lwfinger.net> <49051E0E.2030909@terra.com.br>
In-Reply-To: <49051E0E.2030909@terra.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Piter PUNK wrote:
> Larry Finger wrote:
>> What are the details of your device? Please post the output of 'dmesg
>> | grep -i
>> rtl'.
> 
> This is the built-in rtl8187b adapter:
> 
> usb 1-1: new high speed USB device using ehci_hcd and address 7
> usb 1-1: configuration #1 chosen from 1 choice
> usb 1-1: New USB device found, idVendor=0bda, idProduct=8189
> usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 1-1: Product: RTL8187B_WLAN_Adapter
> usb 1-1: Manufacturer: Manufacturer_Realtek
> usb 1-1: SerialNumber: 00e04c000001
> rtl8187: 8187B chip detected. Support is EXPERIMENTAL, and could damage
> your
>          hardware, use at your own risk
> phy3: Selected rate control algorithm 'pid'
> phy3: hwaddr 00:16:44:aa:df:bf, RTL8187BvE V0 + rtl8225z2
> 
> This is my external rtl8187b USB dongle:
> 
> usb 1-3: new high speed USB device using ehci_hcd and address 8
> usb 1-3: configuration #1 chosen from 1 choice
> rtl8187: 8187B chip detected. Support is EXPERIMENTAL, and could damage
> your
>          hardware, use at your own risk
> phy4: Selected rate control algorithm 'pid'
> phy4: hwaddr 00:18:e7:42:2c:23, RTL8187BvE V0 + rtl8225z2
> usb 1-3: New USB device found, idVendor=0bda, idProduct=8189
> usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 1-3: Product: RTL8187B_WLAN_Adapter
> usb 1-3: Manufacturer: Manufacturer_Realtek
> usb 1-3: SerialNumber: 00e04c000001
> 
> Both have the same "not-working" results. Using any of my other
> adapters the transmission works fine. (ok, it didn't work with
> USB Marvell dongle... but it isn't even detected)

My device is a little different that yours:

rtl8187: 8187B chip detected. Support is EXPERIMENTAL, and could damage your
         hardware, use at your own risk
rtl8187: inconsistency between id with OEM info!
phy1: Selected rate control algorithm 'pid'
phy1: hwaddr 00:11:6b:3e:c4:0a, RTL8187BvB(early) V0 + rtl8225z2

I'll review the code to look at the differences in paths for your device and
mine. Just in case there is a data dependency, please send me (privately) your
2048 byte file.

Thanks,

Larry
