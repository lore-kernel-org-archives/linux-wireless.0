Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coruscant.huijgen.tk ([84.245.31.19]:15965 "EHLO
	coruscant.huijgen.tk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbZHSMn7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 08:43:59 -0400
Message-ID: <4A8BF35E.1090507@huijgen.tk>
Date: Wed, 19 Aug 2009 14:43:10 +0200
From: Mark Huijgen <mark.sf.net@huijgen.tk>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ANN] b43 LP-PHY support (BCM4310/4312/4315) working (partially)!
References: <69e28c910908181329r4b6b7cc8w3c9c0d79dda3730c@mail.gmail.com> 	<4A8BBB02.4020203@huijgen.tk> <69e28c910908190428s46f3d25dnb2f2d8591f99618f@mail.gmail.com>
In-Reply-To: <69e28c910908190428s46f3d25dnb2f2d8591f99618f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> 2009/8/19 Mark Huijgen <mark.sf.net@huijgen.tk>:
>   
>> Gábor Stefanik wrote:
>>     
>>> Hello World!
>>>
>>> Great news for Broadcom BCM4310/4312/4315 (PCI 14e4:4315) users:
>>> LP-PHY support is now at the point where it can be tested for functionality!
>>>
>>> So, go ahead, give it a try, and let's rock!
>>>
>>>       
>> Patches applied, well manually, cause I wasn't able to extract a working
>> version from the emails or the weblink provided. Whats the recommended
>> method to apply these git patches on mailinglists?
>>
>> Here goes:
>>
>> # modprobe b43 verbose=3
>> [ 1596.228088] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x16, vendor
>> 0x4243)
>> [ 1596.228100] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0F,
>> vendor 0x4243)
>> [ 1596.228110] ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x0A, vendor 0x4243)
>> [ 1596.228120] ssb: Core 3 found: PCI-E (cc 0x820, rev 0x09, vendor 0x4243)
>> [ 1596.248050] ssb: Found rev 1 PMU (capabilities 0x02A62F01)
>> [ 1596.256780] ssb: SPROM revision 8 detected.
>> [ 1596.276093] ssb: Sonics Silicon Backplane found on PCI device
>> 0000:10:00.0
>> [ 1596.281108] b43-phy2: Broadcom 4312 WLAN found (core revision 15)
>> [ 1596.324046] b43-phy2 debug: Found PHY: Analog 6, Type 5, Revision 1
>> [ 1596.324060] b43-phy2 debug: Found Radio: Manuf 0x17F, Version 0x2062,
>> Revision 2
>> [ 1596.348233] phy2: Selected rate control algorithm 'minstrel'
>> [ 1596.348349] Broadcom 43xx driver loaded [ Features: PL, Firmware-ID:
>> FW13 ]
>>
>> # ifconfig wlan0 up
>> SIOCSIFFLAGS: Input/output error
>>
>> [ 1689.356055] b43 ssb0:0: firmware: requesting b43/ucode15.fw
>> [ 1689.703918] b43 ssb0:0: firmware: requesting b43/lp0initvals15.fw
>> [ 1689.710418] b43 ssb0:0: firmware: requesting b43/lp0bsinitvals15.fw
>> [ 1689.852058] b43-phy2: Loading firmware version 410.2160 (2007-05-26
>> 15:32:10)
>> [ 1689.854963] b43-phy2 debug: b2062: Using crystal tab entry 19200 kHz.
>> [ 1689.855468] b43-phy2 debug: RC calib: Failed to switch to channel 7,
>> error = -5
>> [ 1689.860016] b43-phy2 debug: Switch to init channel failed, error = -5.
>>     
>
> Hmm, error -5 is EIO, which in the channel switch code is used to
> represent "PLL charge pump out of range". This is specifically the
> error I was trying to fix... could you try without the 2 extra
> patches? Maybe I did something wrong. (Without the 2 patches, channels
> 1..6 and 9..11 (12...14 not tested) throw this error, but channels 7
> and 8 work.)
>   
Same error without the patches, but 1 less error in dmesg. The 'RC
calib: Failed to switch to channel 7, error = -5' is gone now.
> Also try extracting firmware from
> ftp://downloads.netgear.com/files/GPL/WNDR3300-V1.0.29_gpl_src.zip's
> wl_apsta.o file (newer than the one on mirror.openwrt.org - you may
> need to add the extraction defines to fwcutter first; there is a
> script in the fwcutter git tree, probably also in tarballs, that
> generates extraction lists.) This is the firmware the specs are
> written for; it's possible that the current firmware is simply not
> good for LP-PHY (or maybe it needs code based on older specs).
>   
After running the included python script, patching the cutter and
extracting firmware, I now get ucode version 478.104 in dmesg. Next test
is also without the 2 patches. Following log is from modprobe+ifconfig
wlan0 up:

[14600.712104] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x16, vendor
0x4243)
[14600.712116] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0F,
vendor 0x4243)
[14600.712126] ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x0A, vendor 0x4243)
[14600.712136] ssb: Core 3 found: PCI-E (cc 0x820, rev 0x09, vendor 0x4243)
[14600.732052] ssb: Found rev 1 PMU (capabilities 0x02A62F01)
[14600.740727] ssb: SPROM revision 8 detected.
[14600.760093] ssb: Sonics Silicon Backplane found on PCI device
0000:10:00.0
[14600.816481] b43-phy5: Broadcom 4312 WLAN found (core revision 15)
[14600.860044] b43-phy5 debug: Found PHY: Analog 6, Type 5, Revision 1
[14600.860058] b43-phy5 debug: Found Radio: Manuf 0x17F, Version 0x2062,
Revision 2
[14600.884250] phy5: Selected rate control algorithm 'minstrel'
[14600.884367] Broadcom 43xx driver loaded [ Features: PL, Firmware-ID:
FW13 ]
[14611.192054] b43 ssb0:0: firmware: requesting b43/ucode15.fw
[14611.206016] b43 ssb0:0: firmware: requesting b43/lp0initvals15.fw
[14611.211387] b43 ssb0:0: firmware: requesting b43/lp0bsinitvals15.fw
[14611.364058] b43-phy5: Loading firmware version 478.104 (2008-07-01
00:50:23)
[14611.367051] b43-phy5 debug: b2062: Using crystal tab entry 19200 kHz.
[14611.371875] b43-phy5 debug: Switch to init channel failed, error = -5.
[14611.372406] b43-phy5 ERROR: PHY init: Channel switch to default failed

Still the "SIOCSIFFLAGS: Input/output error" on ifconfig wlan0 up.


>   
>> [ 1689.860543] b43-phy2 ERROR: PHY init: Channel switch to default failed
>>
>> Interface is not coming up, so cannot scan:
>> # iwlist wlan0 scan
>> wlan0     Interface doesn't support scanning : Network is down
>>     
>
> When testing mac80211 drivers, always use "iw dev wlan0 scan", not
> "iwlist wlan0 scan". (Though this shouldn't affect your results in
> this case.)
>   
OK will do. Never used iw before your other mail about iw phy and friends :)
> Try bringing up the interface in monitor mode.
> Also, try changing get_default_chan to return 7 instead of 1.
>   
Tested default_chan 7, *with* the 2 patches and the interface comes up!
Scan results show a lot of the AP's around here, but only AP's of
channel 6 and higher.
The closest AP here is actually on channel 1 and is not showing. It
seems there is a problem with channel 1?

Dmesg for modprobe+ifconfig wlan0 up:
[  478.516094] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x16, vendor
0x4243)
[  478.516106] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0F,
vendor 0x4243)
[  478.516116] ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x0A, vendor 0x4243)
[  478.516125] ssb: Core 3 found: PCI-E (cc 0x820, rev 0x09, vendor 0x4243)
[  478.536053] ssb: Found rev 1 PMU (capabilities 0x02A62F01)
[  478.544729] ssb: SPROM revision 8 detected.
[  478.564094] ssb: Sonics Silicon Backplane found on PCI device
0000:10:00.0
[  478.569257] b43-phy3: Broadcom 4312 WLAN found (core revision 15)
[  478.612046] b43-phy3 debug: Found PHY: Analog 6, Type 5, Revision 1
[  478.612061] b43-phy3 debug: Found Radio: Manuf 0x17F, Version 0x2062,
Revision 2
[  478.636235] phy3: Selected rate control algorithm 'minstrel'
[  478.636347] Broadcom 43xx driver loaded [ Features: PL, Firmware-ID:
FW13 ]
[  483.116055] b43 ssb0:0: firmware: requesting b43/ucode15.fw
[  483.120545] b43 ssb0:0: firmware: requesting b43/lp0initvals15.fw
[  483.127002] b43 ssb0:0: firmware: requesting b43/lp0bsinitvals15.fw
[  483.280059] b43-phy3: Loading firmware version 478.104 (2008-07-01
00:50:23)
[  483.283053] b43-phy3 debug: b2062: Using crystal tab entry 19200 kHz.
[  483.296062] b43-phy3 debug: Chip initialized
[  483.296272] b43-phy3 debug: 64-bit DMA initialized
[  483.317545] Registered led device: b43-phy3::tx
[  483.317568] Registered led device: b43-phy3::rx
[  483.317589] Registered led device: b43-phy3::radio
[  483.317649] b43-phy3 debug: Wireless interface started
[  483.317669] b43-phy3 debug: Adding Interface type 2

# wpa_supplicant -Dwext -i wlan0 -c /etc/wpa_supplicant.conf
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 4 value 0x0 - Trying to associate with 00:30:f1:f9:10:45
(SSID='default' freq=2462 MHz)
Associated with 00:30:f1:f9:10:45
WPA: Key negotiation completed with 00:30:f1:f9:10:45 [PTK=TKIP GTK=TKIP]
CTRL-EVENT-CONNECTED - Connection to 00:30:f1:f9:10:45 completed (auth)
[id=0 id_str=]

Well, what do you know, it actually does WPA authentication already!
Means TX must be working too.
I am also able to get an IP address with a dhcp client.

dmesg from wpa_supplicant part:
[  618.820622] wlan0: direct probe to AP 00:30:f1:f9:10:45 (try 1)
[  618.824200] wlan0 direct probe responded
[  618.824204] wlan0: authenticate with AP 00:30:f1:f9:10:45 (try 1)
[  618.825886] wlan0: authenticated
[  618.825902] wlan0: associate with AP 00:30:f1:f9:10:45 (try 1)
[  618.828148] wlan0: RX AssocResp from 00:30:f1:f9:10:45 (capab=0x431
status=0 aid=10)
[  618.828151] wlan0: associated

This AP is on channel 11.

I don't have time for further testing today, but results are promising!

Mark
