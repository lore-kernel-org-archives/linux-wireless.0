Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:43604 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbbHTP0o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 11:26:44 -0400
From: Robert Baldyga <r.baldyga@samsung.com>
To: sameo@linux.intel.com, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
	m.szyprowski@samsung.com, pebolle@tiscali.nl,
	Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 0/3] nfc: Add driver for Samsung S3FWRN5 NFC Chip
Date: Thu, 20 Aug 2015 17:25:59 +0200
Message-id: <1440084362-27909-1-git-send-email-r.baldyga@samsung.com> (sfid-20150820_172800_659435_89F8C80A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

This patchset adds driver for NFC chip Samsung S3FWRN5. First two patches
are touching NCI core due to some non-standard chip behaviour.

The first one adds post_setup() handler, which is called after NCI_CORE_INIT
request. It's because we need to read current firmware version from 
ndev->manufact_specific_info.

The second one adds nci_core_reset() and nci_core_init() functions which
are needed to reinit NCI core after updating firmware in pose_setup()
callback.

Best regards,
Robert Baldyga

Changelog:

v3:
- Addressed comments from Samuel Ortiz:
  - Used nci_prop_cmd and nci_prop_ops to handle proprietary requests
  - Refactorized s3fwrn5_i2c_nci_read and s3fwrn5_i2c_fw_read
  - Miscellaneous minor fixes
- Added patch "NFC: nci: Add post_setup handler"
- Added patch "NFC: nci: export nci_core_reset and nci_core_init"

v2: http://www.spinics.net/lists/linux-wireless/msg139241.html
- Addressed comments from Paul Bolle

v1: http://www.spinics.net/lists/kernel/msg2044290.html

Robert Baldyga (3):
  NFC: nci: Add post_setup handler
  NFC: nci: export nci_core_reset and nci_core_init
  nfc: s3fwrn5: Add driver for Samsung S3FWRN5 NFC Chip

 .../devicetree/bindings/net/nfc/s3fwrn5.txt        |  27 ++
 MAINTAINERS                                        |   6 +
 drivers/nfc/Kconfig                                |   1 +
 drivers/nfc/Makefile                               |   1 +
 drivers/nfc/s3fwrn5/Kconfig                        |  19 +
 drivers/nfc/s3fwrn5/Makefile                       |  11 +
 drivers/nfc/s3fwrn5/core.c                         | 219 +++++++++
 drivers/nfc/s3fwrn5/firmware.c                     | 511 +++++++++++++++++++++
 drivers/nfc/s3fwrn5/firmware.h                     | 111 +++++
 drivers/nfc/s3fwrn5/i2c.c                          | 306 ++++++++++++
 drivers/nfc/s3fwrn5/nci.c                          | 165 +++++++
 drivers/nfc/s3fwrn5/nci.h                          |  89 ++++
 drivers/nfc/s3fwrn5/s3fwrn5.h                      |  99 ++++
 include/net/nfc/nci_core.h                         |   3 +
 net/nfc/nci/core.c                                 |  18 +
 15 files changed, 1586 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/s3fwrn5.txt
 create mode 100644 drivers/nfc/s3fwrn5/Kconfig
 create mode 100644 drivers/nfc/s3fwrn5/Makefile
 create mode 100644 drivers/nfc/s3fwrn5/core.c
 create mode 100644 drivers/nfc/s3fwrn5/firmware.c
 create mode 100644 drivers/nfc/s3fwrn5/firmware.h
 create mode 100644 drivers/nfc/s3fwrn5/i2c.c
 create mode 100644 drivers/nfc/s3fwrn5/nci.c
 create mode 100644 drivers/nfc/s3fwrn5/nci.h
 create mode 100644 drivers/nfc/s3fwrn5/s3fwrn5.h

-- 
1.9.1

