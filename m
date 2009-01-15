Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:58601 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbZAOS4h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 13:56:37 -0500
Received: by ug-out-1314.google.com with SMTP id 39so465155ugf.37
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 10:56:35 -0800 (PST)
Message-ID: <496F86E1.6010605@gmail.com> (sfid-20090115_195641_966726_7F1BFFE4)
Date: Thu, 15 Jan 2009 19:56:33 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Artur Skawina <art.08.09@gmail.com>
CC: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <200901131449.41189.chunkeey@web.de> <496CC514.3030307@gmail.com> <200901131906.13096.chunkeey@web.de> <496CE55F.2080506@gmail.com> <496D09F4.40209@gmail.com> <496D163B.5030307@gmail.com> <496F7887.8070203@gmail.com>
In-Reply-To: <496F7887.8070203@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Artur Skawina wrote:
> Artur Skawina wrote:
>> Artur Skawina wrote:
>>>>>> reboots, but locks up after only a few packets go over the hostap driven
>>>>>> p54usb device. I need the box to be up, that limits the number of tests i can
>>> after switching from SLUB to SLAB and enabling some debugging i finally caught this:
>> and slub debugging gave something a bit more useful:
>>
>> =============================================================================
>> BUG kmalloc-4096: Poison overwritten
> 
> tried reproducing (using the old w-t/pending pull) on different machine,
> but no oops or crash there...
> (similar connectivity issues though, such as connecting only works
> exactly once after starting hostapd, to reconnect i have to restart
> hostapd)
> 
> Upgraded to current wireless-testing/pending on the problematic box
> and almost immediately got [1]. No slab corruption this time (at least
> not yet). Will switch to GFP_ATOMIC and retry w/ the new fw.

Switching p54_set_tim to use GFP_ATOMIC seemed to help, a few
quick tests resulted in no crashes and oopses; unfortunately
ipv4 wasn't working all that well -- arp didn't work at all in
fact.

Tried the newer fw, but it does not seem to like my hw:

usb 1-1.1: new full speed USB device using uhci_hcd and address 6
usb 1-1.1: New USB device found, idVendor=0846, idProduct=4200
usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 1-1.1: configuration #1 chosen from 1 choice
usb 1-1.1: firmware: requesting isl3886usb
phy1: p54 detected a LM86 firmware
p54: rx_mtu reduced from 3240 to 2392
phy1: FW rev 2.13.24.0 - Softmac protocol 5.9
phy1: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
p54usb: probe of 1-1.1:1.0 failed with error -110

Last one working is:

usb 1-1.1: new full speed USB device using uhci_hcd and address 5
usb 1-1.1: New USB device found, idVendor=0846, idProduct=4200
usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 1-1.1: configuration #1 chosen from 1 choice
usb 1-1.1: firmware: requesting isl3886usb
phy0: p54 detected a LM86 firmware
p54: rx_mtu reduced from 3240 to 2392
phy0: FW rev 2.13.1.0 - Softmac protocol 5.5
phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
phy0: hwaddr 00:30:f1:b1:09:e6, MAC:isl3886 RF:Frisbee
wmaster0 (p54usb): not using net_device_ops yet
phy0: Selected rate control algorithm 'minstrel'
wlan0 (p54usb): not using net_device_ops yet
udev: renamed network interface wlan0 to ap0
mon.ap0 (p54usb): not using net_device_ops yet
cfg80211: Calling CRDA for country: US


Disconnecting/reconnecting the wireless client resulted in this:
> mac80211-phy0: failed to remove key (0, 00:1b:fb:12:34:56) from hardware (-12)
followed later, when killing hostapd, by:
> mac80211-phy0: failed to remove key (1, ff:ff:ff:ff:ff:ff) from hardware (-12)


artur
