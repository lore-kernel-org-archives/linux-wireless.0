Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18619 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933047AbaGWVLN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 17:11:13 -0400
Date: Wed, 23 Jul 2014 23:11:07 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux NFC <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: [GIT] [3.17] NFC update
Message-ID: <20140723211107.GF455@zurbaran> (sfid-20140723_231116_246822_B5018DAB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is the NFC pull request for 3.17.
This is a rather quiet one, we have:

- A new driver from ST Microelectronics for their NCI ST21NFCB,
  including device tree  support.

- p2p support for the ST21NFCA driver

- A few fixes an enhancements for the NFC digital laye

Thanks in advance for pulling those in.

The following changes since commit 1d9e954e8b522ae37c7c0fdd791b5736321684a0:

  mwifiex: remove redundant timestamps in debug prints (2014-07-18 13:45:26 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.17-1

for you to fetch changes up to bf30a67c947ed57c1cf7c68a47dc24331458037e:

  NFC: digital: Add 'tg_listen_md' and 'tg_get_rf_tech' driver hooks (2014-07-23 01:17:31 +0200)

----------------------------------------------------------------
Christophe Ricard (10):
      NFC: st21nfcb: Add driver for STMicroelectronics ST21NFCB NFC chip
      NFC: dts: st21nfcb_i2c: Add DTS Documentation
      NFC: nci: Add T1T support notification
      NFC: st21nfcb: few code clean up
      NFC: st21nfca: Free buffer in case no data are retrieved.
      NFC: st21nfca: Improved start of frame detection
      NFC: st21nfca: Improve read length sequence for P2P mode.
      NFC: hci: Add stop_poll HCI operand.
      NFC: st21nfca: Implement stop_poll HCI hook
      NFC: st21nfca: Adding P2P support to st21nfca in Initiator & Target mode

Mark A. Greer (5):
      NFC: digital: Check for NFC-DEP before checking for Type 4 tag
      NFC: digital: Clear poll_tech_count before activating target
      NFC: digital: Add digital framing calls when in target mode
      NFC: digital: Remove extra blank line
      NFC: digital: Add 'tg_listen_md' and 'tg_get_rf_tech' driver hooks

 .../devicetree/bindings/net/nfc/st21nfcb.txt       |  33 +
 drivers/nfc/Kconfig                                |   2 +-
 drivers/nfc/Makefile                               |   3 +-
 drivers/nfc/st21nfca/Makefile                      |   2 +-
 drivers/nfc/st21nfca/i2c.c                         |   9 +-
 drivers/nfc/st21nfca/st21nfca.c                    | 272 ++++++++-
 drivers/nfc/st21nfca/st21nfca.h                    |  26 +-
 drivers/nfc/st21nfca/st21nfca_dep.c                | 661 +++++++++++++++++++++
 drivers/nfc/st21nfca/st21nfca_dep.h                |  43 ++
 drivers/nfc/st21nfcb/Kconfig                       |  22 +
 drivers/nfc/st21nfcb/Makefile                      |   8 +
 drivers/nfc/st21nfcb/i2c.c                         | 462 ++++++++++++++
 drivers/nfc/st21nfcb/ndlc.c                        | 298 ++++++++++
 drivers/nfc/st21nfcb/ndlc.h                        |  55 ++
 drivers/nfc/st21nfcb/st21nfcb.c                    | 129 ++++
 drivers/nfc/st21nfcb/st21nfcb.h                    |  38 ++
 include/linux/platform_data/st21nfcb.h             |  32 +
 include/net/nfc/digital.h                          |  13 +
 include/net/nfc/hci.h                              |   1 +
 net/nfc/digital.h                                  |   3 +
 net/nfc/digital_core.c                             |  27 +-
 net/nfc/digital_dep.c                              |  11 +-
 net/nfc/digital_technology.c                       |  96 ++-
 net/nfc/hci/core.c                                 |   7 +-
 net/nfc/nci/ntf.c                                  |   4 +-
 25 files changed, 2228 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/st21nfcb.txt
 create mode 100644 drivers/nfc/st21nfca/st21nfca_dep.c
 create mode 100644 drivers/nfc/st21nfca/st21nfca_dep.h
 create mode 100644 drivers/nfc/st21nfcb/Kconfig
 create mode 100644 drivers/nfc/st21nfcb/Makefile
 create mode 100644 drivers/nfc/st21nfcb/i2c.c
 create mode 100644 drivers/nfc/st21nfcb/ndlc.c
 create mode 100644 drivers/nfc/st21nfcb/ndlc.h
 create mode 100644 drivers/nfc/st21nfcb/st21nfcb.c
 create mode 100644 drivers/nfc/st21nfcb/st21nfcb.h
 create mode 100644 include/linux/platform_data/st21nfcb.h
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
