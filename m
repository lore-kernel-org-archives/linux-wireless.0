Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48192 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764315AbXGaSdz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:33:55 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121179ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:33:53 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Please pull 'upstream' branch of rt2x00
Date: Tue, 31 Jul 2007 20:36:48 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312036.49060.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is a new release of rt2x00: 2.0.5
Don't let the 25 patches fool you, there are 2 _very_ big patches among them. ;)
The 2 biggest are (as announced earlier) the results of a Lindent run,
and the result of a code cleanup. After those 2 patches the code is hopefully
clean enough to be accepted upstream when rt2x00 is a bit more stable.
In any case further code cleanup patches won't/shouldn't be so big anymore.

Some interesting features in this release:
 - rt73usb no longer crashes in adhoc mode (But neither does it work)
 - rf registers can now be read/written through debugfs
 - Monitor interfaces should now capture everything
 - Signal reporting
 - Correct suspend/resume handling

Ivo

---

The following changes since commit 6e46e62d22ed4b5282d3b9592483e901a9f2643f:
  Zhu Yi (1):
        iwlwifi: update version stamp to 0.1.5

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ivd/rt2x00.git/ upstream

Ivo van Doorn (25):
      rt2x00: Remove rt73usb_get_tsf
      rt2x00: Put rf register value detection in function
      rt2x00: Don't toggle tuner bit for non-RF2523 chips
      rt2x00: Add reset_tuner handler
      rt2x00: rt2500usb needs to reset BBP 24, 25 and 61
      rt2x00: Cleanup RF register reading/writing
      rt2x00: Add RF register contents to Debugfs
      rt2x00: Fix invalid RF array reading
      rt2x00: Increase RF_SIZE
      rt2x00: rt2x00pci should use rf_size
      rt2x00: Correctly handle RF 0 writing
      rt2x00: Rename init_hw -> probe_hw
      rt2x00: Move interface init/deinit into rt2x00dev
      rt2x00: Fix interface opening/closing on suspend/resume
      rt2x00: Lindent
      rt2x00: Call all configure handlers during resume
      rt2x00: Big rt2x00 cleanup
      rt2x00: Add Multicast/Broadcast filtering
      rt2x00: Include <linux/delay.h>
      rt2x00: Periodically read statistics
      rt2x00: Don't check for preamble in RXdone
      rt2x00: Configure type during add_interface
      rt2x00: Add Signal reporting
      rt2x00: rt2x00 2.0.5
      Merge branch 'wireless-dev'

 drivers/net/wireless/Makefile         |    2 +-
 drivers/net/wireless/rt2400pci.c      |  620 +++++++++++----------
 drivers/net/wireless/rt2400pci.h      |    3 +-
 drivers/net/wireless/rt2500pci.c      |  695 +++++++++++++-----------
 drivers/net/wireless/rt2500pci.h      |    2 +
 drivers/net/wireless/rt2500usb.c      |  686 +++++++++++++-----------
 drivers/net/wireless/rt2500usb.h      |   35 +-
 drivers/net/wireless/rt2x00.h         |  861 +++++++++---------------------
 drivers/net/wireless/rt2x00config.c   |  177 ++++++
 drivers/net/wireless/rt2x00debug.c    |  101 +++--
 drivers/net/wireless/rt2x00debug.h    |   32 +-
 drivers/net/wireless/rt2x00dev.c      |  470 +++++++++++------
 drivers/net/wireless/rt2x00dev.h      |   59 --
 drivers/net/wireless/rt2x00firmware.c |   45 +-
 drivers/net/wireless/rt2x00firmware.h |   43 --
 drivers/net/wireless/rt2x00lib.h      |  137 +++---
 drivers/net/wireless/rt2x00mac.c      |  283 +++++-----
 drivers/net/wireless/rt2x00pci.c      |  140 +++--
 drivers/net/wireless/rt2x00pci.h      |   38 +-
 drivers/net/wireless/rt2x00reg.h      |  270 +++++++++
 drivers/net/wireless/rt2x00rfkill.c   |   41 +-
 drivers/net/wireless/rt2x00rfkill.h   |   58 --
 drivers/net/wireless/rt2x00ring.h     |  242 ++++++++
 drivers/net/wireless/rt2x00usb.c      |  177 ++++---
 drivers/net/wireless/rt2x00usb.h      |   40 +-
 drivers/net/wireless/rt61pci.c        |  966 +++++++++++++++++----------------
 drivers/net/wireless/rt61pci.h        |    3 +-
 drivers/net/wireless/rt73usb.c        |  870 ++++++++++++++++--------------
 drivers/net/wireless/rt73usb.h        |    3 +-
 29 files changed, 3870 insertions(+), 3229 deletions(-)
 create mode 100644 drivers/net/wireless/rt2x00config.c
 delete mode 100644 drivers/net/wireless/rt2x00dev.h
 delete mode 100644 drivers/net/wireless/rt2x00firmware.h
 create mode 100644 drivers/net/wireless/rt2x00reg.h
 delete mode 100644 drivers/net/wireless/rt2x00rfkill.h
 create mode 100644 drivers/net/wireless/rt2x00ring.h
