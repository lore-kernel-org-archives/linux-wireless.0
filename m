Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from forward12.mail.yandex.net ([95.108.130.94]:49209 "EHLO
	forward12.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3JEDjc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 23:39:32 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, linville@tuxdriver.com,
	ivdoorn@gmail.com, gwingerde@gmail.com, helmut.schaa@googlemail.com
Subject: [regression] [bisected] rt2800pci doesn't work after 9483f40d8d01918b399b4e24d0c1111db0afffeb
MIME-Version: 1.0
Message-Id: <39871380943748@web17j.yandex.ru> (sfid-20131005_053935_382055_477937FF)
Date: Sat, 05 Oct 2013 07:29:08 +0400
Content-Type: text/plain; charset=koi8-r
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, everyone!

I've just moved from v3.10 to v3.11 and found that my rt2800pci doesn't work:

[ š705.761252] ieee80211 phy3: rt2x00queue_flush_queue: Warning - Queue 0 failed to flush
[ š705.871194] ieee80211 phy3: rt2x00queue_flush_queue: Warning - Queue 2 failed to flush
[ š710.757696] ieee80211 phy3: rt2x00queue_flush_queue: Warning - Queue 0 failed to flush
[ š710.867637] ieee80211 phy3: rt2x00queue_flush_queue: Warning - Queue 2 failed to flush
[ š710.977581] ieee80211 phy3: rt2x00queue_flush_queue: Warning - Queue 0 failed to flush
[ š711.087516] ieee80211 phy3: rt2x00queue_flush_queue: Warning - Queue 2 failed to flush
[ š711.119530] ieee80211 phy3: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 0
[ š712.219961] ieee80211 phy3: rt2x00queue_flush_queue: Warning - Queue 0 failed to flush
[ š712.329900] ieee80211 phy3: rt2x00queue_flush_queue: Warning - Queue 2 failed to flush
[ š714.233932] ieee80211 phy3: rt2x00queue_flush_queue: Warning - Queue 0 failed to flush
[ š714.343872] ieee80211 phy3: rt2x00queue_flush_queue: Warning - Queue 2 failed to flush
[ š721.135366] rt2800pci 0000:01:00.0: irq 45 for MSI/MSI-X
[ š721.135467] ieee80211 phy4: rt2x00_set_rt: Info - RT chipset 3290, rev 0015 detected
[ š721.137440] ieee80211 phy4: rt2x00_set_rf: Info - RF chipset 3290 detected


GIt bisect says the first bad commit is 9483f40d8d01918b399b4e24d0c1111db0afffeb:

ššššššššAuthor: Jakub Kicinski <kubakici@wp.pl>
ššššššššDate: ššTue May 7 00:28:50 2013 +0200

ššššššššššššrt2x00pci: Use PCI MSIs whenever possible

ššššššššššššAll PCIe devices must support MSIs, make use of them.

With reverted commit everything is ok.

$ cat /sys/bus/pci/devices/*/msi_bus
1
1
1

$ cat /proc/interrupts
45:         97          0          0          0   PCI-MSI-edge      0000:01:00.0

PCI IDS: 1814:3298

Any ideas?

Kirill
