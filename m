Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:24582 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933268Ab3HNXHB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Aug 2013 19:07:01 -0400
Date: Thu, 15 Aug 2013 01:04:48 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux NFC <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [GIT] [3.12] NFC updates
Message-ID: <20130814230448.GB11055@zurbaran> (sfid-20130815_010724_592460_F3A331A7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the first NFC pull request for the 3.12 release.

With this one we have:

- A few pn533 improvements and minor fixes. Testing our pn533 driver
  against Google's NCI stack triggered a few issues that we fixed now.
  We also added Tx fragmentation support to this driver.

- More NFC secure element handling. We added a GET_SE netlink command
  for getting all the discovered secure elements, and we defined 2
  additional secure element netlink event (transaction and connectivity).
  We also fixed a couple of typos and copy-paste bugs from the secure
  element handling code.

- Firmware download support for the pn544 driver. This chipset can enter a
  special mode where it's waiting for firmware blobs to replace the
  already flashed one. We now support that mode.

The following changes since commit d1e2586f484dfc36eee2b2d3a6c6c77be67ca492:

  mwifiex: fix build error when CONFIG_PM is not set (2013-08-12 14:36:55 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.12-1

for you to fetch changes up to 39525ee1dc78ca1f5f2fb1f764f7a141005fe440:

  NFC: Update secure element state (2013-08-14 01:13:40 +0200)

----------------------------------------------------------------
Arron Wang (2):
      NFC: Fix secure element state check
      NFC: Update secure element state

Dan Carpenter (1):
      NFC: hci: Fix enable/disable confusion

Eric Lapuyade (5):
      NFC: Move nfc_fw_download_done() definition from private to public
      NFC: pn544: i2c: Add firmware download mode power-on support
      NFC: netlink: Add result of firmware operation to completion event
      NFC: pn544: Add firmware operations hci ops
      NFC: pn544: i2c: Add firmware download implementation for pn544

Olivier Guiter (3):
      NFC: pn533: Add extended information frame decoding support
      NFC: pn533: Split large Tx frames in chunks
      NFC: pn533: Store the correct frame size (normal vs ext)

Samuel Ortiz (12):
      MAINTAINERS: Change the NFC subsystem status to Supported
      NFC: Document secure element addition/removal netlink events
      NFC: Define secure element connectivity and transaction events
      NFC: pn533: Fix hardware busy loop when establishing the LLCP link
      NFC: pn533: Fix the pn533 polling loop
      NFC: pn533: Request System code from SENSF_REQ
      NFC: pn533: Unconditionaly select the highest p2p bit rate
      NFC: pn533: Enable AUTO RFCA
      NFC: Fix SE discovery failure warning condition
      NFC: Add a GET_SE netlink API
      NFC: pn533: Add delay between each poll frame
      NFC: pn533: Add some polling entropy

Thierry Escande (1):
      NFC: Fix missing static declarations

 MAINTAINERS               |    2 +-
 drivers/nfc/nfcsim.c      |    6 +-
 drivers/nfc/pn533.c       |  389 +++++++++++++++++++++++++++++++++++----------
 drivers/nfc/pn544/i2c.c   |  360 +++++++++++++++++++++++++++++++++++++++--
 drivers/nfc/pn544/mei.c   |    2 +-
 drivers/nfc/pn544/pn544.c |   20 ++-
 drivers/nfc/pn544/pn544.h |    7 +-
 include/net/nfc/nfc.h     |    3 +
 include/uapi/linux/nfc.h  |   20 +++
 net/nfc/core.c            |   22 ++-
 net/nfc/hci/core.c        |    2 +-
 net/nfc/netlink.c         |   95 ++++++++++-
 net/nfc/nfc.h             |    5 +-
 13 files changed, 810 insertions(+), 123 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
