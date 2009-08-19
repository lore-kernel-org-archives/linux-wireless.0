Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coruscant.huijgen.tk ([84.245.31.19]:13812 "EHLO
	coruscant.huijgen.tk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbZHSInc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 04:43:32 -0400
Message-ID: <4A8BBB02.4020203@huijgen.tk>
Date: Wed, 19 Aug 2009 10:42:42 +0200
From: Mark Huijgen <mark.sf.net@huijgen.tk>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ANN] b43 LP-PHY support (BCM4310/4312/4315) now ready for testing!
References: <69e28c910908181329r4b6b7cc8w3c9c0d79dda3730c@mail.gmail.com>
In-Reply-To: <69e28c910908181329r4b6b7cc8w3c9c0d79dda3730c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor Stefanik wrote:
> Hello World!
>
> Great news for Broadcom BCM4310/4312/4315 (PCI 14e4:4315) users:
> LP-PHY support is now at the point where it can be tested for functionality!
>
> So, go ahead, give it a try, and let's rock!
>   
Patches applied, well manually, cause I wasn't able to extract a working
version from the emails or the weblink provided. Whats the recommended
method to apply these git patches on mailinglists?

Here goes:

# modprobe b43 verbose=3
[ 1596.228088] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x16, vendor
0x4243)
[ 1596.228100] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0F,
vendor 0x4243)
[ 1596.228110] ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x0A, vendor 0x4243)
[ 1596.228120] ssb: Core 3 found: PCI-E (cc 0x820, rev 0x09, vendor 0x4243)
[ 1596.248050] ssb: Found rev 1 PMU (capabilities 0x02A62F01)
[ 1596.256780] ssb: SPROM revision 8 detected.
[ 1596.276093] ssb: Sonics Silicon Backplane found on PCI device
0000:10:00.0
[ 1596.281108] b43-phy2: Broadcom 4312 WLAN found (core revision 15)
[ 1596.324046] b43-phy2 debug: Found PHY: Analog 6, Type 5, Revision 1
[ 1596.324060] b43-phy2 debug: Found Radio: Manuf 0x17F, Version 0x2062,
Revision 2
[ 1596.348233] phy2: Selected rate control algorithm 'minstrel'
[ 1596.348349] Broadcom 43xx driver loaded [ Features: PL, Firmware-ID:
FW13 ]

# ifconfig wlan0 up
SIOCSIFFLAGS: Input/output error

[ 1689.356055] b43 ssb0:0: firmware: requesting b43/ucode15.fw
[ 1689.703918] b43 ssb0:0: firmware: requesting b43/lp0initvals15.fw
[ 1689.710418] b43 ssb0:0: firmware: requesting b43/lp0bsinitvals15.fw
[ 1689.852058] b43-phy2: Loading firmware version 410.2160 (2007-05-26
15:32:10)
[ 1689.854963] b43-phy2 debug: b2062: Using crystal tab entry 19200 kHz.
[ 1689.855468] b43-phy2 debug: RC calib: Failed to switch to channel 7,
error = -5
[ 1689.860016] b43-phy2 debug: Switch to init channel failed, error = -5.
[ 1689.860543] b43-phy2 ERROR: PHY init: Channel switch to default failed

Interface is not coming up, so cannot scan:
# iwlist wlan0 scan
wlan0     Interface doesn't support scanning : Network is down


# iwconfig wlan0
wlan0     IEEE 802.11bg  Mode:Managed  Access Point: Not-Associated
          Tx-Power=0 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off

# iw dev wlan0 info
Interface wlan0
        ifindex 5
        type managed

# iw phy phy2 info
Wiphy phy2
        Band 1:
                Frequencies:
                        * 2412 MHz [1] (27.0 dBm)
                        * 2417 MHz [2] (27.0 dBm)
                        * 2422 MHz [3] (27.0 dBm)
                        * 2427 MHz [4] (27.0 dBm)
                        * 2432 MHz [5] (27.0 dBm)
                        * 2437 MHz [6] (27.0 dBm)
                        * 2442 MHz [7] (27.0 dBm)
                        * 2447 MHz [8] (27.0 dBm)
                        * 2452 MHz [9] (27.0 dBm)
                        * 2457 MHz [10] (27.0 dBm)
                        * 2462 MHz [11] (27.0 dBm)
                        * 2467 MHz [12] (disabled)
                        * 2472 MHz [13] (disabled)
                        * 2484 MHz [14] (disabled)
                Bitrates (non-HT):
                        * 1.0 Mbps
                        * 2.0 Mbps (short preamble supported)
                        * 5.5 Mbps (short preamble supported)
                        * 11.0 Mbps (short preamble supported)
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        max # scan SSIDs: 4
        Supported interface modes:
                 * IBSS
                 * managed
                 * AP
                 * AP/VLAN
                 * WDS
                 * monitor
                 * mesh point



