Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:33497 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbbD1JI4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 05:08:56 -0400
From: Valentin Rothberg <valentinrothberg@gmail.com>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, clement.perrochaud@effinnov.com,
	charles.gorand@effinnov.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pebolle@tiscali.nl, rupran@einserver.de, stefan.hengelein@fau.de,
	Valentin Rothberg <valentinrothberg@gmail.com>
Subject: [PATCH] drivers/nfc: remove obsolete setting of DEBUG
Date: Tue, 28 Apr 2015 11:08:47 +0200
Message-Id: <1430212127-5841-1-git-send-email-valentinrothberg@gmail.com> (sfid-20150428_110916_827458_D8687D61)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The CPP identifier 'DEBUG' is not used in the source code of nfc at all,
so we can safely remove setting it in both Makefiles.

Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
---
I detected this issue with ./scripts/checkkconfigsymbols.py since
CONFIG_NFC_DEBUG is not defined in Kconfig.
---
 drivers/nfc/Makefile         | 2 --
 drivers/nfc/nxp-nci/Makefile | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/nfc/Makefile b/drivers/nfc/Makefile
index a4292d790f9b..13b648baf175 100644
--- a/drivers/nfc/Makefile
+++ b/drivers/nfc/Makefile
@@ -14,5 +14,3 @@ obj-$(CONFIG_NFC_TRF7970A)	+= trf7970a.o
 obj-$(CONFIG_NFC_ST21NFCA)  	+= st21nfca/
 obj-$(CONFIG_NFC_ST21NFCB)	+= st21nfcb/
 obj-$(CONFIG_NFC_NXP_NCI)	+= nxp-nci/
-
-ccflags-$(CONFIG_NFC_DEBUG) := -DDEBUG
diff --git a/drivers/nfc/nxp-nci/Makefile b/drivers/nfc/nxp-nci/Makefile
index c008be30bb18..c9ec7869dbd2 100644
--- a/drivers/nfc/nxp-nci/Makefile
+++ b/drivers/nfc/nxp-nci/Makefile
@@ -7,5 +7,3 @@ nxp-nci_i2c-objs = i2c.o
 
 obj-$(CONFIG_NFC_NXP_NCI) += nxp-nci.o
 obj-$(CONFIG_NFC_NXP_NCI_I2C) += nxp-nci_i2c.o
-
-ccflags-$(CONFIG_NFC_DEBUG) := -DDEBUG
-- 
2.1.4

