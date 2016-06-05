Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:49813 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbcFEJRI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2016 05:17:08 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Robert Dolca <robert.dolca@intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v2] NFC: fdp: Detect errors from fdp_nci_create_conn()
Date: Sun,  5 Jun 2016 11:17:10 +0200
Message-Id: <1465118230-30233-1-git-send-email-geert@linux-m68k.org> (sfid-20160605_111740_473859_460239D5)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/nfc/fdp/fdp.c: In function ‘fdp_nci_patch_otp’:
drivers/nfc/fdp/fdp.c:373: warning: comparison is always false due to limited range of data type
drivers/nfc/fdp/fdp.c: In function ‘fdp_nci_patch_ram’:
drivers/nfc/fdp/fdp.c:444: warning: comparison is always false due to limited range of data type

fdp_nci_create_conn() may return a negative error code, which is
silently ignored by assigning it to a u8.

Change conn_id from u8 to int to fix this.

Fixes: a06347c04c13e380 ("NFC: Add Intel Fields Peak NFC solution driver")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
fdp_nci_patch_otp() and fdp_nci_patch_ram() are almost identical.
Please merge them, or create a common helper.

v2:
  - Rebased, updated, reworded.
---
 drivers/nfc/fdp/fdp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index e44a7a2f4061a10a..16427420b1a2aa25 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -353,7 +353,7 @@ static int fdp_nci_patch_otp(struct nci_dev *ndev)
 {
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
 	struct device *dev = &info->phy->i2c_dev->dev;
-	u8 conn_id;
+	int conn_id;
 	int r = 0;
 
 	if (info->otp_version >= info->otp_patch_version)
@@ -424,7 +424,7 @@ static int fdp_nci_patch_ram(struct nci_dev *ndev)
 {
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
 	struct device *dev = &info->phy->i2c_dev->dev;
-	u8 conn_id;
+	int conn_id;
 	int r = 0;
 
 	if (info->ram_version >= info->ram_patch_version)
-- 
1.9.1

