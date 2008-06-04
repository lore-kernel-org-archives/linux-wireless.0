Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:57328 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbYFDPRQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 11:17:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: b43 opensource firmware for monitor mode
Date: Wed, 4 Jun 2008 17:16:53 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200806041716.53771.mb@bu3sch.de> (sfid-20080604_171726_562511_0FEBC7C7)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Release early, release often.
Here's the first testing release of the b43 opensource firmware.
http://bu3sch.de/misc/b43-openfw-20080604.tar.bz2

Currently only the receive path is partially implemented. So that
means we can only run it in monitor mode for now. This firmware is
able to receive packets and push them without special handling (like
decrypting) to the driver.
There are lots of bugs, of course. Sometimes the PLCP header is corrupted.
That will result in a kernel driver warning in xmit.c.

This firmware does _only_ work on wireless core revisions 5, 6, 7, 8 or 10.
You can see the core revision by turning on SSB debugging.
It will print something like:
ssb: Core X found: IEEE 802.11 (cc 0x812, rev 0x05, vendor 0x4243)
As you can see there's the revision number in hex.

If you want to test this, please get the tarball and extract it.
The tarball contains the full sourcecode and a set of prebuilt binaries.
(If you want to rebuild the stuff, you need to get the assembler toolchain
from http://git.bu3sch.de/git/b43-tools.git).

Simply get the *.fw files from bin/rev5/ in the tarball and copy them
into /lib/firmware/b43-open.
Then load b43 from latest wireless-testing.git with the module
parameter fwpostfix=-open

Setup monitor mode and see packets coming in. Or not...

-- 
Greetings Michael.
