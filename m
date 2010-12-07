Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:64157 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab0LGXLr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 18:11:47 -0500
Received: by ewy10 with SMTP id 10so495400ewy.4
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 15:11:45 -0800 (PST)
Message-ID: <4CFEBF3C.7030205@lwfinger.net>
Date: Tue, 07 Dec 2010 17:11:56 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 0/4] Make N-PHY support experimental
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com> <AANLkTikp9ErFopLZVmXMjN3tXF2L62SwEEcujKeOBLYC@mail.gmail.com>
In-Reply-To: <AANLkTikp9ErFopLZVmXMjN3tXF2L62SwEEcujKeOBLYC@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/07/2010 04:57 PM, Gábor Stefanik wrote:
> 2010/12/7 Rafał Miłecki <zajec5@gmail.com>:
>> Finally, thanks for Larry and Francesco I got b43 working with BCM4328 chipset!
> 
> Do you mean BCM4321 (14e4:4328)? BCM4328 is AFAIK handled by brcmfmac.
> 
>>
>> It's not perfectly stable yet, but scanning and associating to open network
>> works! It has to be tested, improved, there are some PHY errors from time to
>> time, but generally it works :)

With my device:

04:00.0 Network controller [0280]: Broadcom Corporation BCM4321 802.11a/b/g/n
[14e4:4328] (rev 03)
        Subsystem: Hewlett-Packard Company BCM4321 802.11a/b/g/n Wireless LAN
Controller [103c:1366]
        Kernel driver in use: b43-pci-bridge

Excerpt of log:

[ 1184.780924] b43-pci-bridge 0000:04:00.0: PCI INT A -> Link[LK4E] -> GSI 20
(level, low) -> IRQ 20
[ 1184.780945] b43-pci-bridge 0000:04:00.0: setting latency timer to 64
[ 1184.800166] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x13, vendor 0x4243)
[ 1184.800176] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0C, vendor 0x4243)
[ 1184.800184] ssb: Core 2 found: PCI-E (cc 0x820, rev 0x04, vendor 0x4243)
[ 1184.800192] ssb: Core 3 found: PCI (cc 0x804, rev 0x0D, vendor 0x4243)
[ 1184.800200] ssb: Core 4 found: USB 1.1 Host (cc 0x817, rev 0x04, vendor 0x4243)
[ 1184.820062] ssb: Switching to ChipCommon core, index 0
[ 1184.820202] ssb: chipcommon status is 0x0
[ 1184.820211] ssb: SPROM offset is 0x1000
[ 1184.828653] ssb: SPROM revision 5 detected.
[ 1184.848037] ssb: Switching to PCI-E core, index 2
[ 1184.848659] ssb: Sonics Silicon Backplane found on PCI device 0000:04:00.0
[ 1184.897825] b43-phy0: Broadcom 4321 WLAN found (core revision 12)
[ 1184.916062] ssb: Switching to IEEE 802.11 core, index 1
[ 1184.940038] b43-phy0 debug: Found PHY: Analog 5, Type 4, Revision 2
[ 1184.940064] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2055, Revision 4
[ 1184.975224] Registered led device: b43-phy0::tx
[ 1184.978455] Registered led device: b43-phy0::rx
[ 1184.980387] Registered led device: b43-phy0::radio
[ 1185.256050] b43-phy0: Loading firmware version 508.1107 (2009-06-26 19:16:02)
[ 1185.256059] ssb: Switching to ChipCommon core, index 0
[ 1185.256123] ssb: Switching to IEEE 802.11 core, index 1
[ 1185.332045] b43-phy0 debug: Chip initialized
[ 1185.333522] b43-phy0 debug: 64-bit DMA initialized
[ 1185.333570] b43-phy0 debug: QoS enabled
[ 1185.353497] b43-phy0 debug: Wireless interface started
[ 1185.353512] b43-phy0 debug: Adding Interface type 2
[ 1188.041790] b43-phy0 debug: Using hardware based encryption for keyidx: 0,
mac: c0:3f:0e:be:2b:45
[ 1191.134922] b43-phy0 debug: Disabling hardware based encryption for keyidx:
0, mac: c0:3f:0e:be:2b:45
[ 1192.823490] b43-phy0 debug: Using hardware based encryption for keyidx: 0,
mac: ff:ff:ff:ff:ff:ff
[ 1192.824306] b43-phy0 debug: Using hardware based encryption for keyidx: 1,
mac: ff:ff:ff:ff:ff:ff
[ 1192.824630] b43-phy0 debug: Using hardware based encryption for keyidx: 2,
mac: ff:ff:ff:ff:ff:ff
[ 1192.824989] b43-phy0 debug: Using hardware based encryption for keyidx: 3,
mac: ff:ff:ff:ff:ff:ff
[ 1194.896063] b43-phy0 ERROR: PHY transmission error

It connects and authenticates with WEP, but not with WPA2. It appears to be
limited to CCK rates. Setting a rate above 11Mb/s results in complete failure.

Transmit rate is 4.6 Mb/s at 11M. All in all, not bad for first life.

Larry
