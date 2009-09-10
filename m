Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f194.google.com ([209.85.216.194]:39273 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbZIJFjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 01:39:04 -0400
Received: by pxi32 with SMTP id 32so1558429pxi.4
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2009 22:39:07 -0700 (PDT)
Message-ID: <4AA890F9.90604@gmail.com>
Date: Wed, 09 Sep 2009 22:39:05 -0700
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>,
	Dave Young <hidave.darkstar@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: b43 dma error
References: <20090908134732.GA1936@darkstar> <200909081638.36897.mb@bu3sch.de> 	<4AA67009.4020400@lwfinger.net> <4AA69961.9010808@gmail.com> <69e28c910909081106p413b70d8u83a48a63943f123e@mail.gmail.com>
In-Reply-To: <69e28c910909081106p413b70d8u83a48a63943f123e@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080801030301060701010200"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080801030301060701010200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

On 09/08/2009 11:06 AM, Gábor Stefanik wrote:
> On Tue, Sep 8, 2009 at 7:50 PM, John Daiker<daikerjohn@gmail.com>  wrote:
>> On 09/08/2009 07:54 AM, Larry Finger wrote:
>>>
>>> Michael Buesch wrote:
>>>>
>>>> On Tuesday 08 September 2009 15:47:32 Dave Young wrote:
>>>>>
>>>>> I tested wireless-testing b43 driver, but got "Fatal DMA error"
>>>>> then the controller keep restarting...
>>>>>
>>>>> Please tell what I can provide or test, Thanks.
>>>>
>>>> Is this a regression? If so, please bisect.
>>>
>>> It is something specific to his system as I don't see anything like
>>> this. In addition, there are some users on the openSUSE forums that
>>> have implemented the latest compat-wireless and switched away from
>>> Broadcom wl to b43 on their LP PHY devices. So far, no complaints from
>>> them.
>>>
>>> Please reboot so that we see the ssb output as well. Use the command
>>>
>>> dmesg | egrep "ssb|b43"
>>>
>>> That way we will be able to see exactly what kind of device you have
>>> and what revisions are in it. AFAIK, the testing to date has been
>>> limited to Rev 1 PHYs and Rev 2 radios.
>>>
>>> Larry
>>>
>>
>> I can confirm the same issue.  I have a HP Mini 1116NR with a Broadcom 4312.
>>   Looks to be a PHY 1, Radio 2:
>>
>> --snip--
>> [  456.165296] b43-phy0 debug: Found PHY: Analog 6, Type 5, Revision 1
>> [  456.165364] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2062,
>> Revision 2
>> --snip--
>>
>> I've attached the output of 'dmesg | egrep "ssb|b43"', my kernel config, and
>> lspci -vv and lspci -nn
>>
>> Note: With the dmesg output, I had unloaded the b43 module previous
>> 'modprobe -r b43' and then loaded it again with debug output: 'modprobe b43
>> verbose=3'
>>
>> John Daiker
>>
>
> Again, please test with v478 or v5xx firmware.
>

I've tried with the v478 firmware (was using 410.2160 earlier).  I do 
not see the 'Fatal DMA error' messages anymore.

On another note, however, I can't connect to a network.  The device 
seems to alternate between being idle, and scanning for APs.

--snip--
[   73.273722] phy0: device no longer idle - scanning
[   74.561178] phy0: device now idle
[   79.545776] phy0: device no longer idle - scanning
[   80.828232] phy0: device now idle
[   85.817930] phy0: device no longer idle - scanning
[   87.100240] phy0: device now idle
[   92.090713] phy0: device no longer idle - scanning
[   93.372367] phy0: device now idle
[   98.362829] phy0: device no longer idle - scanning
[   99.644362] phy0: device now idle
--snip--

I've attached the relevant portion of my dmesg output for your review.

Where would I got about finding the v5xx firmware?

JD

--------------080801030301060701010200
Content-Type: text/plain;
 name="dmesg4.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg4.out"

[    2.757126] ata1.00: 32014080 sectors, multi 0: LBA 
[    2.760697] ata1.00: configured for UDMA/66
[    2.764095] scsi 0:0:0:0: Direct-Access     ATA      SanDisk pSSD 16G SSD  PQ: 0 ANSI: 5
[    2.767539] sd 0:0:0:0: [sda] 32014080 512-byte logical blocks: (16.3 GB/15.2 GiB)
[    2.770945] sd 0:0:0:0: [sda] Write Protect is off
[    2.774063] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.774130] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.777645]  sda: sda1 sda2 < sda5 >
[    2.783573] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.805784] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.884226] usb 2-4: new high speed USB device using ehci_hcd and address 2
[    3.021207] usb 2-4: configuration #1 chosen from 1 choice
[    3.031363] PM: Starting manual resume from disk
[    3.034864] PM: Resume from partition 8:5
[    3.034870] PM: Checking hibernation image.
[    3.035379] PM: Resume from disk failed.
[    3.050990] kjournald starting.  Commit interval 5 seconds
[    3.054614] EXT3-fs: mounted filesystem with writeback data mode.
[    5.133366] udev: starting version 141
[    5.288161] rtc_cmos 00:03: RTC can wake from S4
[    5.296623] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    5.301658] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    5.408379] b43-pci-bridge 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.412941] b43-pci-bridge 0000:01:00.0: setting latency timer to 64
[    5.415969] intel_rng: FWH not detected
[    5.484223] ssb: Sonics Silicon Backplane found on PCI device 0000:01:00.0
[    5.919876] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.924500]   alloc irq_desc for 27 on node -1
[    5.924510]   alloc kstat_irqs on node -1
[    5.924538] HDA Intel 0000:00:1b.0: irq 27 for MSI/MSI-X
[    5.924601] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    6.065608] cfg80211: Calling CRDA to update world regulatory domain
[    6.135544] cfg80211: World regulatory domain updated:
[    6.140053] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    6.144677] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    6.149242] 	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    6.153577] 	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    6.157648] 	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    6.161316] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    6.164837] b43-phy0: Broadcom 4312 WLAN found (core revision 15)
[    6.196723] Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04711/0xa00000
[    6.217255] b43-phy0 debug: Found PHY: Analog 6, Type 5, Revision 1
[    6.217323] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2062, Revision 2
[    6.236154] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input6
[    6.253094] phy0: Selected rate control algorithm 'minstrel'
[    6.254037] Broadcom 43xx driver loaded [ Features: P, Firmware-ID: FW13 ]
[    6.524646] Adding 714852k swap on /dev/sda5.  Priority:-1 extents:1 across:714852k 
[    6.655873] EXT3 FS on sda1, internal journal
[    7.594436] RPC: Registered udp transport module.
[    7.594446] RPC: Registered tcp transport module.
[    7.707497] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   16.004269] sky2 eth0: enabling interface
[   16.048220] b43 ssb0:0: firmware: requesting b43/ucode15.fw
[   16.077797] b43 ssb0:0: firmware: requesting b43/lp0initvals15.fw
[   16.093394] b43 ssb0:0: firmware: requesting b43/lp0bsinitvals15.fw
[   16.260549] b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
[   16.262985] b43-phy0 debug: b2062: Using crystal tab entry 19200 kHz.
[   16.528117] b43-phy0 debug: Chip initialized
[   16.528356] b43-phy0 debug: 64-bit DMA initialized
[   16.528488] b43-phy0 debug: QoS enabled
[   16.552302] b43-phy0 debug: Wireless interface started
[   16.552387] b43-phy0 debug: Adding Interface type 2
[   16.565100] phy0: device now idle
[   16.726639] phy0: device no longer idle - scanning
[   18.021167] phy0: device now idle
[   22.278870] CPU0 attaching NULL sched-domain.
[   22.278883] CPU1 attaching NULL sched-domain.
[   22.293140] CPU0 attaching sched-domain:
[   22.293150]  domain 0: span 0-1 level SIBLING
[   22.293159]   groups: 0 1
[   22.293172] CPU1 attaching sched-domain:
[   22.293179]  domain 0: span 0-1 level SIBLING
[   22.293185]   groups: 1 0
[   24.988037] Clocksource tsc unstable (delta = -127524381 ns)
[   37.001487] phy0: device no longer idle - scanning
[   38.284344] phy0: device now idle
[   67.002945] phy0: device no longer idle - scanning
[   68.284208] phy0: device now idle
[   73.273722] phy0: device no longer idle - scanning
[   74.561178] phy0: device now idle
[   79.545776] phy0: device no longer idle - scanning
[   80.828232] phy0: device now idle
[   85.817930] phy0: device no longer idle - scanning
[   87.100240] phy0: device now idle
[   92.090713] phy0: device no longer idle - scanning
[   93.372367] phy0: device now idle
[   98.362829] phy0: device no longer idle - scanning
[   99.644362] phy0: device now idle
[  104.634101] phy0: device no longer idle - scanning
[  105.916364] phy0: device now idle
[  110.906370] phy0: device no longer idle - scanning
[  112.188368] phy0: device now idle
[  117.178654] phy0: device no longer idle - scanning
[  118.460356] phy0: device now idle
[  123.449877] phy0: device no longer idle - scanning
[  124.733330] phy0: device now idle
[  129.723029] phy0: device no longer idle - scanning
[  131.005131] phy0: device now idle
[  157.003343] phy0: device no longer idle - scanning
[  158.285317] phy0: device now idle

--------------080801030301060701010200--
