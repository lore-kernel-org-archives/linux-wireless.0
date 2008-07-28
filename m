Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:48924 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991AbYG1Wvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 18:51:54 -0400
Message-ID: <488E4D7E.6010003@lwfinger.net> (sfid-20080729_005158_605957_FCED97E0)
Date: Mon, 28 Jul 2008 17:51:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFC/RFT] b43: Rewrite TX power adjustment
References: <200807261726.53279.mb@bu3sch.de> <200807282017.04979.mb@bu3sch.de>
In-Reply-To: <200807282017.04979.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Saturday 26 July 2008 17:26:52 Michael Buesch wrote:
>> This is an experimental attempt for fixing the currently-not-so-good
>> TX power adjustment.
> 
> Hm, is anybody going to test this, or are there really no transmission
> problems left? :)

It seems to work here. The dmesg output for my BCM4312 is:

ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x11, vendor 0x4243)
ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0A, vendor 0x4243)
ssb: Core 2 found: USB 1.1 Host (cc 0x817, rev 0x03, vendor 0x4243)
ssb: Core 3 found: PCI-E (cc 0x820, rev 0x01, vendor 0x4243)
ssb: SPROM revision 2 detected.
ssb: Sonics Silicon Backplane found on PCI device 0000:04:00.0
b43-phy0: Broadcom 4311 WLAN found
b43-phy0 debug: Found PHY: Analog 4, Type 2, Revision 8
b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
phy0: Selected rate control algorithm 'pid'
Broadcom 43xx driver loaded [ Features: PLR, Firmware-ID: FW13 ]
udev: renamed network interface wlan0 to wlan1
input: b43-phy0 as /class/input/input9
firmware: requesting b43/ucode5.fw
firmware: requesting b43/pcm5.fw
firmware: requesting b43/b0g0initvals5.fw
firmware: requesting b43/b0g0bsinitvals5.fw
b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
b43-phy0 debug: Chip initialized
b43-phy0 debug: 32-bit DMA initialized
Registered led device: b43-phy0::tx
Registered led device: b43-phy0::rx
Registered led device: b43-phy0::radio
b43-phy0 debug: Wireless interface started
b43-phy0 debug: Adding Interface type 2
Adjusted power
wlan1: authenticate with AP 00:1a:70:46:ba:b1
wlan1: authenticated
wlan1: associate with AP 00:1a:70:46:ba:b1
wlan1: RX AssocResp from 00:1a:70:46:ba:b1 (capab=0x431 status=0 aid=3)
wlan1: associated
Average is 39
Adjusted power
Average is 17
Average is 18
Adjusted power
Average is 4
Adjusted power
Average is 4
Average is 4
Adjusted power
Average is 8
Adjusted power
Average is 6
Average is 12
Average is 11
Average is 12
Average is 11
Average is 12
Average is 10
Average is 12
Average is 11
Average is 12
Average is 12
Average is 11
Average is 12
Average is 11
Average is 12
Average is 12
Average is 11
Average is 13
Average is 13
Adjusted power
Average is 13
Adjusted power
Average is 11
Average is 13
Adjusted power
Average is 12
Average is 13
Adjusted power
Average is 13
Adjusted power
Average is 11
Average is 13
Adjusted power
Average is 11
Average is 13
Adjusted power
Average is 13
Adjusted power
Average is 8
Average is 9
Average is 13
Average is 12
Average is 13
Adjusted power
Average is 13
Adjusted power
Average is 12
Average is 13
Adjusted power
Average is 12
Average is 13
Adjusted power
Average is 12
Average is 13
Adjusted power
Average is 7
Average is 9
Average is 12
Average is 10
Average is 7
Average is 7
Adjusted power
Average is 9
Average is 13
Average is 13
Average is 13
Adjusted power
Average is 13
Adjusted power
Average is 8
Average is 8
Average is 13
Average is 12

Is this sufficient, or is there other output that you want to see?


> But please note that current wireless-testing tree seems to have some
> unrelated TX issues in mac80211 (see the discussions about the qdisc
> and skb->cb stuff.)

AFAIK, this particular bug is limited to mainline. At least wireless still works 
in wireless-testing, but fails completely in Linus's tree.

Larry

