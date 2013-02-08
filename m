Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56507 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945976Ab3BHNXj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 08:23:39 -0500
Date: Fri, 8 Feb 2013 14:23:35 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux NFC <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [GIT] [3.9] NFC pull request
Message-ID: <20130208132335.GB20996@sortiz-mobl> (sfid-20130208_142359_710370_05C30C2A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the second NFC pull request for 3.9.

We have:

- A few pn533 fixes on top of Waldemar refactorization of the driver, one of
  them fixes target mode.

- A new driver for Inside Secure microread chipset. It supports two
  physical layers: i2c and MEI. The MEI one depends on a patchset that's
  been sent to Greg Kroah-Hartman for inclusion into the 3.9 kernel [1]. The
  dependency is a KConfig one which means this code is not buildable as long
  as the MEI API is not usptream.

Thanks in advance for pulling them in.

[1] https://lkml.org/lkml/2013/2/8/165


The following changes since commit 9ebea3829fac7505e0cd2642fbd13cfa9c038831:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless (2013-01-28 13:54:03 -0500)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.9-2

for you to fetch changes up to 52f2eaeec11c16c219f0e99b8496fbba86889830:

  NFC: pn533: Fix target polling mode (2013-02-08 12:18:48 +0100)

----------------------------------------------------------------
This is the 2nd NFC pull request.

With this one we have a new NFC driver for Inside Secure microread and a few
pn533 fixes.
Microread is an HCI based NFC IP and the driver we're pushing supports tags
R/W, and NFC p2p. It's supported over the i2c and MEI busses.

----------------------------------------------------------------
Eric Lapuyade (1):
      NFC: Initial support for Inside Secure microread

Samuel Ortiz (2):
      NFC: microread: Add i2c physical layer
      NFC: microread: Add MEI physical layer

Thierry Escande (1):
      NFC: pn533: Fix target polling mode

Waldemar Rymarkiewicz (2):
      nfc: pn533: Use static poll_mod and std_frame_ops
      nfc: pn533: Remove unreachable code

 drivers/nfc/Kconfig                     |    1 +
 drivers/nfc/Makefile                    |    1 +
 drivers/nfc/microread/Kconfig           |   35 ++
 drivers/nfc/microread/Makefile          |   10 +
 drivers/nfc/microread/i2c.c             |  340 +++++++++++++++
 drivers/nfc/microread/mei.c             |  241 ++++++++++
 drivers/nfc/microread/microread.c       |  728 +++++++++++++++++++++++++++++++
 drivers/nfc/microread/microread.h       |   33 ++
 drivers/nfc/pn533.c                     |    8 +-
 include/linux/platform_data/microread.h |   35 ++
 10 files changed, 1427 insertions(+), 5 deletions(-)
 create mode 100644 drivers/nfc/microread/Kconfig
 create mode 100644 drivers/nfc/microread/Makefile
 create mode 100644 drivers/nfc/microread/i2c.c
 create mode 100644 drivers/nfc/microread/mei.c
 create mode 100644 drivers/nfc/microread/microread.c
 create mode 100644 drivers/nfc/microread/microread.h
 create mode 100644 include/linux/platform_data/microread.h

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
