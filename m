Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45548 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab1LUK7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 05:59:17 -0500
Received: by qcqz2 with SMTP id z2so4306105qcq.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 02:59:16 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 21 Dec 2011 18:59:16 +0800
Message-ID: <CAG9cJm=YkvHY56LoBoUf3fuh=xb7m+c0GgUzMZX+QyG1+CBCMg@mail.gmail.com> (sfid-20111221_115921_384113_851F8A98)
Subject: bcm4331 firmware installer package
From: lina <lina.lastname@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Debian Lists <debian-user@lists.debian.org>,
	=?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I don't know which one (else) can be fit for bcm4331 802.11a/b/g/n (rev 02)

>From http://wiki.debian.org/bcm43xx#b43_and_b43legacy

I tried:

1] aptitude install firmware-b43-lpphy-installer

No chroot environment found. Starting normal installation
No supported card found.
Use proper b43 or b43legacy firmware.
Aborting.

2] # aptitude install firmware-b43-installer

No chroot environment found. Starting normal installation
Unsupported device(s) found: PCI id 14e4:4331
Aborting.

both of the listed are not working,

lspci showed:

03:00.0 Network controller: Broadcom Corporation BCM4331 802.11a/b/g/n (rev 02)

Thanks for providing some suggestions or links.

P.S extra info:

$ uname -a
Linux debian 3.2.0-rc6-3.2-mj-lina #1 SMP Sat Dec 17 13:14:26 SGT 2011
x86_64 GNU/Linux

# modprobe b43
# lsmod | grep -e b43 -e bcma
b43                   349208  0
mac80211              228257  1 b43
cfg80211              173366  2 b43,mac80211
ssb                    52359  1 b43
pcmcia                 40840  2 b43,ssb
rng_core               12614  1 b43
bcma                   23572  1 b43
mmc_core               84258  4 b43,ssb,sdhci_pci,sdhci

# dmesg
[29546.428354] b43-phy0: Broadcom 4331 WLAN found (core revision 29)
[29546.428389] bcma: Switched to core: 0x812
[29546.428819] b43-phy0 ERROR: FOUND UNSUPPORTED PHY (Analog 9, Type
7, Revision 1)
[29546.428837] b43: probe of bcma0:0 failed with error -95
[29546.428878] Broadcom 43xx driver loaded [ Features: PMNLS ]
[29683.101838] applesmc: F1Mn: write arg fail
