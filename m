Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:31550 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbZHSL3I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 07:29:08 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1042762fga.17
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 04:29:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A8BBB02.4020203@huijgen.tk>
References: <69e28c910908181329r4b6b7cc8w3c9c0d79dda3730c@mail.gmail.com>
	<4A8BBB02.4020203@huijgen.tk>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 19 Aug 2009 13:28:47 +0200
Message-ID: <69e28c910908190428s46f3d25dnb2f2d8591f99618f@mail.gmail.com>
Subject: Re: [ANN] b43 LP-PHY support (BCM4310/4312/4315) now ready for
	testing!
To: Mark Huijgen <mark.sf.net@huijgen.tk>
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/19 Mark Huijgen <mark.sf.net@huijgen.tk>:
> Gábor Stefanik wrote:
>> Hello World!
>>
>> Great news for Broadcom BCM4310/4312/4315 (PCI 14e4:4315) users:
>> LP-PHY support is now at the point where it can be tested for functionality!
>>
>> So, go ahead, give it a try, and let's rock!
>>
> Patches applied, well manually, cause I wasn't able to extract a working
> version from the emails or the weblink provided. Whats the recommended
> method to apply these git patches on mailinglists?
>
> Here goes:
>
> # modprobe b43 verbose=3
> [ 1596.228088] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x16, vendor
> 0x4243)
> [ 1596.228100] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0F,
> vendor 0x4243)
> [ 1596.228110] ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x0A, vendor 0x4243)
> [ 1596.228120] ssb: Core 3 found: PCI-E (cc 0x820, rev 0x09, vendor 0x4243)
> [ 1596.248050] ssb: Found rev 1 PMU (capabilities 0x02A62F01)
> [ 1596.256780] ssb: SPROM revision 8 detected.
> [ 1596.276093] ssb: Sonics Silicon Backplane found on PCI device
> 0000:10:00.0
> [ 1596.281108] b43-phy2: Broadcom 4312 WLAN found (core revision 15)
> [ 1596.324046] b43-phy2 debug: Found PHY: Analog 6, Type 5, Revision 1
> [ 1596.324060] b43-phy2 debug: Found Radio: Manuf 0x17F, Version 0x2062,
> Revision 2
> [ 1596.348233] phy2: Selected rate control algorithm 'minstrel'
> [ 1596.348349] Broadcom 43xx driver loaded [ Features: PL, Firmware-ID:
> FW13 ]
>
> # ifconfig wlan0 up
> SIOCSIFFLAGS: Input/output error
>
> [ 1689.356055] b43 ssb0:0: firmware: requesting b43/ucode15.fw
> [ 1689.703918] b43 ssb0:0: firmware: requesting b43/lp0initvals15.fw
> [ 1689.710418] b43 ssb0:0: firmware: requesting b43/lp0bsinitvals15.fw
> [ 1689.852058] b43-phy2: Loading firmware version 410.2160 (2007-05-26
> 15:32:10)
> [ 1689.854963] b43-phy2 debug: b2062: Using crystal tab entry 19200 kHz.
> [ 1689.855468] b43-phy2 debug: RC calib: Failed to switch to channel 7,
> error = -5
> [ 1689.860016] b43-phy2 debug: Switch to init channel failed, error = -5.

Hmm, error -5 is EIO, which in the channel switch code is used to
represent "PLL charge pump out of range". This is specifically the
error I was trying to fix... could you try without the 2 extra
patches? Maybe I did something wrong. (Without the 2 patches, channels
1..6 and 9..11 (12...14 not tested) throw this error, but channels 7
and 8 work.)

Also try extracting firmware from
ftp://downloads.netgear.com/files/GPL/WNDR3300-V1.0.29_gpl_src.zip's
wl_apsta.o file (newer than the one on mirror.openwrt.org - you may
need to add the extraction defines to fwcutter first; there is a
script in the fwcutter git tree, probably also in tarballs, that
generates extraction lists.) This is the firmware the specs are
written for; it's possible that the current firmware is simply not
good for LP-PHY (or maybe it needs code based on older specs).

> [ 1689.860543] b43-phy2 ERROR: PHY init: Channel switch to default failed
>
> Interface is not coming up, so cannot scan:
> # iwlist wlan0 scan
> wlan0     Interface doesn't support scanning : Network is down

When testing mac80211 drivers, always use "iw dev wlan0 scan", not
"iwlist wlan0 scan". (Though this shouldn't affect your results in
this case.)

Try bringing up the interface in monitor mode.
Also, try changing get_default_chan to return 7 instead of 1.

>
>
> # iwconfig wlan0
> wlan0     IEEE 802.11bg  Mode:Managed  Access Point: Not-Associated
>          Tx-Power=0 dBm
>          Retry  long limit:7   RTS thr:off   Fragment thr:off
>          Encryption key:off
>          Power Management:off
>
> # iw dev wlan0 info
> Interface wlan0
>        ifindex 5
>        type managed
>
> # iw phy phy2 info
> Wiphy phy2
>        Band 1:
>                Frequencies:
>                        * 2412 MHz [1] (27.0 dBm)
>                        * 2417 MHz [2] (27.0 dBm)
>                        * 2422 MHz [3] (27.0 dBm)
>                        * 2427 MHz [4] (27.0 dBm)
>                        * 2432 MHz [5] (27.0 dBm)
>                        * 2437 MHz [6] (27.0 dBm)
>                        * 2442 MHz [7] (27.0 dBm)
>                        * 2447 MHz [8] (27.0 dBm)
>                        * 2452 MHz [9] (27.0 dBm)
>                        * 2457 MHz [10] (27.0 dBm)
>                        * 2462 MHz [11] (27.0 dBm)
>                        * 2467 MHz [12] (disabled)
>                        * 2472 MHz [13] (disabled)
>                        * 2484 MHz [14] (disabled)
>                Bitrates (non-HT):
>                        * 1.0 Mbps
>                        * 2.0 Mbps (short preamble supported)
>                        * 5.5 Mbps (short preamble supported)
>                        * 11.0 Mbps (short preamble supported)
>                        * 6.0 Mbps
>                        * 9.0 Mbps
>                        * 12.0 Mbps
>                        * 18.0 Mbps
>                        * 24.0 Mbps
>                        * 36.0 Mbps
>                        * 48.0 Mbps
>                        * 54.0 Mbps
>        max # scan SSIDs: 4
>        Supported interface modes:
>                 * IBSS
>                 * managed
>                 * AP
>                 * AP/VLAN
>                 * WDS
>                 * monitor
>                 * mesh point
>
>
>
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
