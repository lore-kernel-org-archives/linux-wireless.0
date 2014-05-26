Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ems.wolfvision.net ([213.33.91.163]:21131 "EHLO
	ems.wolfvision.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaEZPsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 11:48:00 -0400
From: Matthias Fend <Matthias.Fend@wolfvision.net>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: AW: rt2x00: Ralink RT5572 very high peak current consumption
Date: Mon, 26 May 2014 15:37:36 +0000
Message-ID: <CC2A85E271C1FB479D9C17305347F69A44D336@WOLFSERVER19.wolfvision-at.intra> (sfid-20140526_174804_548916_9629D48A)
References: <CC2A85E271C1FB479D9C17305347F69A4479A6@WOLFSERVER19.wolfvision-at.intra>
In-Reply-To: <CC2A85E271C1FB479D9C17305347F69A4479A6@WOLFSERVER19.wolfvision-at.intra>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Here are some updates concerning my current issues.

> -----Ursprüngliche Nachricht-----
> Von: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] Im Auftrag von Matthias Fend
> Gesendet: Freitag, 23. Mai 2014 14:25
> An: linux-wireless@vger.kernel.org
> Betreff: rt2x00: Ralink RT5572 very high peak current consumption
> 
> Hello Ralink experts,
> 
> I recognized spurious problems with Ralink RT5572 USB-dongles when using
> this dongles as access point in 5G band.
> The problems may appear as short usb disconnect-connect events or failed
> vendor request messages at different offsets with different error codes or
> will not appear for days ;) During error research I noticed that, most likely
> during the beacon send time (100ms interval), there are very high peak
> currents in the supply of the USB-dongle.
> 
> I tried it with two different dongles, the base current for all three is in the
> range of  ~200mA:
> Buffalo WI-U2-300D: Peak ~1A
> TP-Link TL-WDN3200: Peak ~1.2mA
> 
> We could reproduce this issue on two different machines (x86 and arm), did
> test with kernel versions 3.10.19, 3.13.0 and 3.14.4 tried hostapd-2.0 and
> hostapd-2.1 and loaded chip firmware version V0.29, V0.33 and V0.35.
> 
> As a comparison I also created an 5G access point setup with a windows7
> machine - all with the latest drivers from the manufacturer webpage.
> Buffalo WI-U2-300D: Peak 330mA
> TP-Link TL-WDN3200: Peak 330mA
> Which seems more legit than the values from the linux setups.
> 
> The access point functionality itself worked with every tested combination,
> but there is definitively something wrong.
> I also started to grab the usb communication of the windows driver to see if
> there is an obvious difference in some of the written registers.
> But this kind of reverse engineering is not as easy since the windows driver
> does not write the same registers as the linux drivers but write some others -
> and of course I have no datasheet/register description.
> 
> Until now the only interesting thing I found out is that the linux driver writes
> 0x00000082 to the TXOP_HLDR_ET (0x1608) register whereas the windows
> driver uses a value of 0x0000000a. Changing this register during runtime in a
> linux system reduces the current peaks to 50 percent of their previous value.
> But there is still something else wrong.
> 
> So, in my despair I try to get help in any form (hints, datasheets/manuals,
> ideas, experience, ...).

I found out that the discovered high current peaks are somehow related to invalidated beacons.
Usually I can see 1 block with a normal tx-condition current followed by 7 additional blocks with high current peaks.
For a test I copied the beacon data from HW_BEACON_BASE0 to HW_BEACON_BASE2 and then the first and the third beacon block have normal current values while the others still generate high current peaks

It seems that setting all five words of the TXWI at the beacon base does not complete disable the generation of this beacon.
If I modify the TXIW_W0 of the disabled beacons to 0x40000000 (set TXWI_W0_PHYMODE as in the really used beacon) then the current consumption does not exceed the usual value. But it seems that there is still a short activity for this beacon which, in my opinion, should not be the case.

So, currently I'm wondering about two things:
-)How do I completely turn off unused beacons (from the measurements with the windows setup I know that this should be somehow possible)?
-)Where is the real address of HW_BEACON_BASE6 and HW_BEACON_BASE7? Modifying registers at the address of the appropriate defines (0x5dc0, 0x5bc0) does not change anything at all.

Thanks,
 ~Matthias


