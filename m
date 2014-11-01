Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:45684 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbaKABPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 21:15:11 -0400
Received: by mail-pa0-f54.google.com with SMTP id rd3so8780862pab.13
        for <linux-wireless@vger.kernel.org>; Fri, 31 Oct 2014 18:15:10 -0700 (PDT)
Received: from duncan-laptop (121-74-214-149.telstraclear.net. [121.74.214.149])
        by mx.google.com with ESMTPSA id fn4sm11048422pab.39.2014.10.31.18.15.08
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Oct 2014 18:15:09 -0700 (PDT)
Message-ID: <1414804501.1032.1.camel@gmail.com> (sfid-20141101_021517_350776_C21E7D19)
Subject: BCM43228 wireless card broken in kernel update [b43]
From: Duncan de Wet <duncandewet@gmail.com>
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Nov 2014 14:15:01 +1300
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the kernel update to 3.17.1-1-ARCH, I can view a list of wireless
networks but not connect to any. Both GNOME network manager and wicd-gtk
say "Connecting..." then without an error message change to "Not
Connected".

Here is the dmesg output that occurs when trying to connect to a
wireless network, with my router hardware address redacted:

[ 1363.980448] wlp4s0: authenticate with [redacted]
[ 1364.066378] wlp4s0: send auth to [redacted] (try 1/3)
[ 1364.068641] wlp4s0: authenticated
[ 1364.069358] wlp4s0: associate with [redacted] (try 1/3)
[ 1364.073798] wlp4s0: RX AssocResp from [redacted] (capab=0x411
status=0 aid=2)
[ 1364.073869] wlp4s0: associated
[ 1364.073927] IPv6: ADDRCONF(NETDEV_CHANGE): wlp4s0: link becomes ready
[ 1364.074029] cfg80211: Calling CRDA to update world regulatory domain
[ 1369.624786] wlp4s0: deauthenticating from [redacted] by local choice
(Reason: 3=DEAUTH_LEAVING)

Here is the exact model of the card, and other information from lspci if
it is helpful:

04:00.0 Network controller [0280]: Broadcom Corporation BCM43228
802.11a/b/g/n [14e4:4359]
        Subsystem: Broadcom Corporation Device [14e4:0607]
        Flags: bus master, fast devsel, latency 0, IRQ 17
        Memory at f2500000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
        Capabilities: [58] Vendor Specific Information: Len=78 <?>
        Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [d0] Express Endpoint, MSI 00
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [13c] Virtual Channel
        Capabilities: [160] Device Serial Number [redacted]
        Capabilities: [16c] Power Budgeting <?>
        Kernel driver in use: bcma-pci-bridge
        Kernel modules: bcma, wl

I do not know why "wl" is listed as an available module because I
uninstalled broadcom-wl already.

I am using the b43 driver, along with b43-firmware from Arch Linux AUR,
but broadcom-wl does not work either (same issue where I can view
networks but not connect). Everything worked before I updated my kernel.

It also may be interesting that on startup, I get this dmesg output:

Broadcom BCM4359 802.11 Hybrid Wireless Controller 6.30.223.248
(r487574)

however my card is BCM43228 not BCM4359.

Here is the output of `lsmod | grep b43`:

b43                   410153  0 
mac80211              604456  1 b43
ssb                    65506  1 b43
rng_core               12808  1 b43
pcmcia                 53108  2 b43,ssb
cfg80211              445286  2 b43,mac80211
led_class              12859  2 b43,thinkpad_acpi
bcma                   45915  1 b43
mmc_core              110434  3 b43,ssb,rtsx_pci_sdmmc

I am connected by Ethernet right now but would prefer to use wireless.
My distribution is Arch Linux.

Thank you for any help.

-- 
Duncan de Wet

