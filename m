Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37994 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab2JVNNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 09:13:46 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so1420892wey.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2012 06:13:45 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 22 Oct 2012 15:13:45 +0200
Message-ID: <CAF1_xX2uo0Q7mNSEENA2uH61itMxjoJ8ejcS9MeW5puibXpeeQ@mail.gmail.com> (sfid-20121022_151350_348128_51F9AA58)
Subject: [regression][bisected] Handling of channel contexts causes wireless
 to fail (i.e. no wlan* devices)
From: Ronald <ronald645@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following commit causes wireless interfaces to not show up (i.e.
wlan* is non existant):

fe57d9f: mac80211: track whether to use channel contexts

Reverting this commit on top of current wireless-testing resulted in
undefined references to chanctx.

I have observed this behaviour on two chipsets on two seperate systems
(desktop and laptop):

- rt2860pci
05:08.0 Network controller: Ralink corp. RT2800 802.11n PCI
	Subsystem: SiteCom Europe BV Device 0016
	Flags: bus master, slow devsel, latency 32, IRQ 18
05:08.0 0280: 1814:0601
	Subsystem: 182d:0016
- b43
03:00.0 Network controller: Broadcom Corporation BCM4311 802.11b/g WLAN (rev 01)
	Subsystem: Hewlett-Packard Company BCM4311 802.11b/g Wireless LAN Controller
03:00.0 0280: 14e4:4311 (rev 01)
	Subsystem: 103c:1364

[    0.190034] ssb: Found chip with id 0x4311, rev 0x01 and package 0x00
[    0.190039] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x11, vendor 0x4243)
[    0.190044] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0A,
vendor 0x4243)
[    0.190049] ssb: Core 2 found: USB 1.1 Host (cc 0x817, rev 0x03,
vendor 0x4243)
[    0.190054] ssb: Core 3 found: PCI-E (cc 0x820, rev 0x01, vendor 0x4243)
[    0.330087] ssb: Sonics Silicon Backplane found on PCI device 0000:03:00.0
[    5.810937] b43-phy0: Broadcom 4311 WLAN found (core revision 10)
[    5.910007] b43-phy0: Found PHY: Analog 4, Type 2 (G), Revision 8

This e-mail is a last resort as I was not able to find this issue
mentioned in the last 3 days on the mailing list archives from marc.

          Ronald
