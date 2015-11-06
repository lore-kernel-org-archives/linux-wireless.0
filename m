Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:36662 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031997AbbKFLYf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 06:24:35 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Robert Dolca <robert.dolca@intel.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] NFC: fdp: Detect errors from fdp_nci_patch_otp()
Date: Fri,  6 Nov 2015 12:24:40 +0100
Message-Id: <1446809080-25823-1-git-send-email-geert@linux-m68k.org> (sfid-20151106_122438_286000_F2E2553E)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/nfc/fdp/fdp.c: In function ‘fdp_nci_patch_otp’:
drivers/nfc/fdp/fdp.c:372: warning: comparison is always false due to limited range of data type
drivers/nfc/fdp/fdp.c: In function ‘fdp_nci_patch_ram’:
drivers/nfc/fdp/fdp.c:443: warning: comparison is always false due to limited range of data type

fdp_nci_patch_otp() may return a negative error, which is silently
ignored by assigning it to a u8.

Change conn_id from u8 to int to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
fdp_nci_patch_otp() and fdp_nci_patch_ram() are almost identical.
Please merge them, or create a common helper.
---
 drivers/nfc/fdp/fdp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index ccb07a1b153db27f..23e53780728beb76 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -352,7 +352,7 @@ static int fdp_nci_patch_otp(struct nci_dev *ndev)
 {
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
 	struct device *dev = &info->phy->i2c_dev->dev;
-	u8 conn_id;
+	int conn_id;
 	int r = 0;
 
 	if (info->otp_version >= info->otp_patch_version)
@@ -423,7 +423,7 @@ static int fdp_nci_patch_ram(struct nci_dev *ndev)
 {
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
 	struct device *dev = &info->phy->i2c_dev->dev;
-	u8 conn_id;
+	int conn_id;
 	int r = 0;
 
 	if (info->ram_version >= info->ram_patch_version)
-- 
1.9.1

