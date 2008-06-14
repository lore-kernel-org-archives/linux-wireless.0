Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:60115 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbYFNNyG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2008 09:54:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: b43 open-firmware new snapshot
Date: Sat, 14 Jun 2008 15:53:42 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200806141553.42420.mb@bu3sch.de> (sfid-20080614_155433_815163_88621D31)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here comes another snapshot of the Opensource firmware for
the b43 wireless core.
http://bu3sch.de/b43/openfw/b43-openfw-20080614.tar.bz2

The firmware does _ONLY_ work in monitor mode. The TX path is not implemented,
so it can not associate or whatever. It can only receive packets.

This firmware does _only_ work on wireless core revisions 5, 6, 7, 8 or 10.
You can see the core revision by turning on SSB debugging.
It will print something like:
ssb: Core X found: IEEE 802.11 (cc 0x812, rev 0x05, vendor 0x4243)
As you can see there's the revision number in hex.

If you want to test this, first get latest wireless-testing.git kernel driver.
Then get the firmware tarball and extract it.
The tarball contains the full sourcecode and a set of prebuilt binaries.
(If you want to rebuild the stuff, you need to get the assembler toolchain
from http://git.bu3sch.de/git/b43-tools.git).
There are binaries with debugging code (in bin-debug subdir) and without
debugging code (in bin subdir). You want to start with the non-debugging
version for testing. You might want to check the debugging version, if
you see any problems. It might print some useful hints in the kernel
driver for what is going wrong.

Simply get the *.fw files from bin/rev5/ in the tarball and copy them
into /lib/firmware/b43-open.
Then load b43 from latest wireless-testing.git with the module
parameter fwpostfix=-open

-- 
Greetings Michael.
