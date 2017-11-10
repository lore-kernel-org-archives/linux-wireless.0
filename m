Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28552 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753960AbdKJXkb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Nov 2017 18:40:31 -0500
Date: Sat, 11 Nov 2017 00:40:26 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Linux NFC <linux-nfc@lists.01.org>
Subject: [GIT] [4.15] NFC update
Message-ID: <20171110234026.GA18424@zurbaran.ger.intel.com> (sfid-20171111_004038_513065_7A73AF54)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

This is the NFC pull request for 4.15. We have:

- A new netlink command for explicitly deactivating NFC targets
- i2c constification for all NFC drivers
- One NFC device allocation error path fix

The following changes since commit 2798b80b385384d51a81832556ee9ad25d175f9b:

  Merge branch 'eBPF-based-device-cgroup-controller' (2017-11-05 23:26:51 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-4.15-1

for you to fetch changes up to 4d63adfe12dd9cb61ed8badb4d798955399048c2:

  NFC: Add NFC_CMD_DEACTIVATE_TARGET support (2017-11-10 00:03:39 +0100)

----------------------------------------------------------------
Allen Pais (1):
      NFC: Convert timers to use timer_setup()

Arvind Yadav (8):
      nfc: microread: constify i2c_device_id
      nfc: nfcmrvl: constify i2c_device_id
      nfc: nxp-nci: constify i2c_device_id
      nfc: pn533: constify i2c_device_id
      nfc: pn544: constify i2c_device_id
      nfc: s3fwrn5: constify i2c_device_id
      nfc: st-nci: constify i2c_device_id
      nfc: st21nfca: constify i2c_device_id

Colin Ian King (2):
      nfc: s3fwrn5: make array match static const
      NFC: fdp: make struct nci_ops static

Johan Hovold (1):
      NFC: fix device-allocation error return

Mark Greer (2):
      NFC: digital: Abort cmd when deactivating target
      NFC: Add NFC_CMD_DEACTIVATE_TARGET support

 drivers/nfc/fdp/fdp.c          |  2 +-
 drivers/nfc/microread/i2c.c    |  2 +-
 drivers/nfc/nfcmrvl/i2c.c      |  2 +-
 drivers/nfc/nxp-nci/i2c.c      |  2 +-
 drivers/nfc/pn533/i2c.c        |  2 +-
 drivers/nfc/pn544/i2c.c        |  2 +-
 drivers/nfc/s3fwrn5/firmware.c |  2 +-
 drivers/nfc/s3fwrn5/i2c.c      |  2 +-
 drivers/nfc/st-nci/i2c.c       |  2 +-
 drivers/nfc/st21nfca/i2c.c     |  2 +-
 include/uapi/linux/nfc.h       |  2 ++
 net/nfc/core.c                 | 10 ++++------
 net/nfc/digital_core.c         |  1 +
 net/nfc/hci/core.c             |  7 +++----
 net/nfc/hci/llc_shdlc.c        | 23 +++++++++--------------
 net/nfc/llcp_core.c            | 14 ++++++--------
 net/nfc/netlink.c              | 29 +++++++++++++++++++++++++++++
 17 files changed, 64 insertions(+), 42 deletions(-)
