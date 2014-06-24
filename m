Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:37356 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaFXIuv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 04:50:51 -0400
Received: by mail-wg0-f46.google.com with SMTP id y10so7561367wgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 01:50:50 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: update list and code making a selection of firmware files
Date: Tue, 24 Jun 2014 10:50:41 +0200
Message-Id: <1403599841-12868-1-git-send-email-zajec5@gmail.com> (sfid-20140624_105057_452882_DDF136F7)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clean ucode selection, fix choice of firmware for LCN, drop some goto-s,
add new devices.
Tested on 14e4:4312, 14e4:4315, 14e4:4328, 14e4:432b, 14e4:4353.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c | 224 ++++++++++++++++++++++------------------
 1 file changed, 125 insertions(+), 99 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index beb4deb..3e4333c 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2201,52 +2201,78 @@ err_format:
 	return -EPROTO;
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/Init/Firmware */
 static int b43_try_request_fw(struct b43_request_fw_context *ctx)
 {
 	struct b43_wldev *dev = ctx->dev;
 	struct b43_firmware *fw = &ctx->dev->fw;
+	struct b43_phy *phy = &dev->phy;
 	const u8 rev = ctx->dev->dev->core_rev;
 	const char *filename;
-	u32 tmshigh;
 	int err;
 
-	/* Files for HT and LCN were found by trying one by one */
-
 	/* Get microcode */
-	if ((rev >= 5) && (rev <= 10)) {
-		filename = "ucode5";
-	} else if ((rev >= 11) && (rev <= 12)) {
-		filename = "ucode11";
-	} else if (rev == 13) {
-		filename = "ucode13";
-	} else if (rev == 14) {
-		filename = "ucode14";
-	} else if (rev == 15) {
+	filename = NULL;
+	switch (rev) {
+	case 42:
+		if (phy->type == B43_PHYTYPE_AC)
+			filename = "ucode42";
+		break;
+	case 33:
+		if (phy->type == B43_PHYTYPE_LCN40)
+			filename = "ucode33_lcn40";
+		break;
+	case 30:
+		if (phy->type == B43_PHYTYPE_N)
+			filename = "ucode30_mimo";
+		break;
+	case 29:
+		if (phy->type == B43_PHYTYPE_HT)
+			filename = "ucode29_mimo";
+		break;
+	case 26:
+		if (phy->type == B43_PHYTYPE_HT)
+			filename = "ucode26_mimo";
+		break;
+	case 28:
+	case 25:
+		if (phy->type == B43_PHYTYPE_N)
+			filename = "ucode25_mimo";
+		else if (phy->type == B43_PHYTYPE_LCN)
+			filename = "ucode25_lcn";
+		break;
+	case 24:
+		if (phy->type == B43_PHYTYPE_LCN)
+			filename = "ucode24_lcn";
+		break;
+	case 23:
+		if (phy->type == B43_PHYTYPE_N)
+			filename = "ucode16_mimo";
+		break;
+	case 16 ... 19:
+		if (phy->type == B43_PHYTYPE_N)
+			filename = "ucode16_mimo";
+		else if (phy->type == B43_PHYTYPE_LP)
+			filename = "ucode16_lp";
+		break;
+	case 15:
 		filename = "ucode15";
-	} else {
-		switch (dev->phy.type) {
-		case B43_PHYTYPE_N:
-			if (rev >= 16)
-				filename = "ucode16_mimo";
-			else
-				goto err_no_ucode;
-			break;
-		case B43_PHYTYPE_HT:
-			if (rev == 29)
-				filename = "ucode29_mimo";
-			else
-				goto err_no_ucode;
-			break;
-		case B43_PHYTYPE_LCN:
-			if (rev == 24)
-				filename = "ucode24_mimo";
-			else
-				goto err_no_ucode;
-			break;
-		default:
-			goto err_no_ucode;
-		}
+		break;
+	case 14:
+		filename = "ucode14";
+		break;
+	case 13:
+		filename = "ucode13";
+		break;
+	case 11 ... 12:
+		filename = "ucode11";
+		break;
+	case 5 ... 10:
+		filename = "ucode5";
+		break;
 	}
+	if (!filename)
+		goto err_no_ucode;
 	err = b43_do_request_fw(ctx, filename, &fw->ucode, true);
 	if (err)
 		goto err_load;
@@ -2268,117 +2294,117 @@ static int b43_try_request_fw(struct b43_request_fw_context *ctx)
 		goto err_load;
 
 	/* Get initvals */
+	filename = NULL;
 	switch (dev->phy.type) {
-	case B43_PHYTYPE_A:
-		if ((rev >= 5) && (rev <= 10)) {
-			tmshigh = ssb_read32(dev->dev->sdev, SSB_TMSHIGH);
-			if (tmshigh & B43_TMSHIGH_HAVE_2GHZ_PHY)
-				filename = "a0g1initvals5";
-			else
-				filename = "a0g0initvals5";
-		} else
-			goto err_no_initvals;
-		break;
 	case B43_PHYTYPE_G:
-		if ((rev >= 5) && (rev <= 10))
-			filename = "b0g0initvals5";
-		else if (rev >= 13)
+		if (rev == 13)
 			filename = "b0g0initvals13";
-		else
-			goto err_no_initvals;
+		else if (rev >= 5 && rev <= 10)
+			filename = "b0g0initvals5";
 		break;
 	case B43_PHYTYPE_N:
-		if (rev >= 16)
+		if (rev == 30)
+			filename = "n16initvals30";
+		else if (rev == 28 || rev == 25)
+			filename = "n0initvals25";
+		else if (rev == 24)
+			filename = "n0initvals24";
+		else if (rev == 23)
+			filename = "n0initvals16"; /* What about n0initvals22? */
+		else if (rev >= 16 && rev <= 18)
 			filename = "n0initvals16";
-		else if ((rev >= 11) && (rev <= 12))
+		else if (rev >= 11 && rev <= 12)
 			filename = "n0initvals11";
-		else
-			goto err_no_initvals;
 		break;
 	case B43_PHYTYPE_LP:
-		if (rev == 13)
-			filename = "lp0initvals13";
+		if (rev >= 16 && rev <= 18)
+			filename = "lp0initvals16";
+		else if (rev == 15)
+			filename = "lp0initvals15";
 		else if (rev == 14)
 			filename = "lp0initvals14";
-		else if (rev >= 15)
-			filename = "lp0initvals15";
-		else
-			goto err_no_initvals;
+		else if (rev == 13)
+			filename = "lp0initvals13";
 		break;
 	case B43_PHYTYPE_HT:
 		if (rev == 29)
 			filename = "ht0initvals29";
-		else
-			goto err_no_initvals;
+		else if (rev == 26)
+			filename = "ht0initvals26";
 		break;
 	case B43_PHYTYPE_LCN:
 		if (rev == 24)
 			filename = "lcn0initvals24";
-		else
-			goto err_no_initvals;
 		break;
-	default:
-		goto err_no_initvals;
+	case B43_PHYTYPE_LCN40:
+		if (rev == 33)
+			filename = "lcn400initvals33";
+		break;
+	case B43_PHYTYPE_AC:
+		if (rev == 42)
+			filename = "ac1initvals42";
+		break;
 	}
+	if (!filename)
+		goto err_no_initvals;
 	err = b43_do_request_fw(ctx, filename, &fw->initvals, false);
 	if (err)
 		goto err_load;
 
 	/* Get bandswitch initvals */
+	filename = NULL;
 	switch (dev->phy.type) {
-	case B43_PHYTYPE_A:
-		if ((rev >= 5) && (rev <= 10)) {
-			tmshigh = ssb_read32(dev->dev->sdev, SSB_TMSHIGH);
-			if (tmshigh & B43_TMSHIGH_HAVE_2GHZ_PHY)
-				filename = "a0g1bsinitvals5";
-			else
-				filename = "a0g0bsinitvals5";
-		} else if (rev >= 11)
-			filename = NULL;
-		else
-			goto err_no_initvals;
-		break;
 	case B43_PHYTYPE_G:
-		if ((rev >= 5) && (rev <= 10))
+		if (rev == 13)
+			filename = "b0g0bsinitvals13";
+		else if (rev >= 5 && rev <= 10)
 			filename = "b0g0bsinitvals5";
-		else if (rev >= 11)
-			filename = NULL;
-		else
-			goto err_no_initvals;
 		break;
 	case B43_PHYTYPE_N:
-		if (rev >= 16)
+		if (rev == 30)
+			filename = "n16bsinitvals30";
+		else if (rev == 28 || rev == 25)
+			filename = "n0bsinitvals25";
+		else if (rev == 24)
+			filename = "n0bsinitvals24";
+		else if (rev == 23)
+			filename = "n0bsinitvals16"; /* What about n0bsinitvals22? */
+		else if (rev >= 16 && rev <= 18)
 			filename = "n0bsinitvals16";
-		else if ((rev >= 11) && (rev <= 12))
+		else if (rev >= 11 && rev <= 12)
 			filename = "n0bsinitvals11";
-		else
-			goto err_no_initvals;
 		break;
 	case B43_PHYTYPE_LP:
-		if (rev == 13)
-			filename = "lp0bsinitvals13";
+		if (rev >= 16 && rev <= 18)
+			filename = "lp0bsinitvals16";
+		else if (rev == 15)
+			filename = "lp0bsinitvals15";
 		else if (rev == 14)
 			filename = "lp0bsinitvals14";
-		else if (rev >= 15)
-			filename = "lp0bsinitvals15";
-		else
-			goto err_no_initvals;
+		else if (rev == 13)
+			filename = "lp0bsinitvals13";
 		break;
 	case B43_PHYTYPE_HT:
 		if (rev == 29)
 			filename = "ht0bsinitvals29";
-		else
-			goto err_no_initvals;
+		else if (rev == 26)
+			filename = "ht0bsinitvals26";
 		break;
 	case B43_PHYTYPE_LCN:
 		if (rev == 24)
 			filename = "lcn0bsinitvals24";
-		else
-			goto err_no_initvals;
 		break;
-	default:
-		goto err_no_initvals;
+	case B43_PHYTYPE_LCN40:
+		if (rev == 33)
+			filename = "lcn400bsinitvals33";
+		break;
+	case B43_PHYTYPE_AC:
+		if (rev == 42)
+			filename = "ac1bsinitvals42";
+		break;
 	}
+	if (!filename)
+		goto err_no_initvals;
 	err = b43_do_request_fw(ctx, filename, &fw->initvals_band, false);
 	if (err)
 		goto err_load;
-- 
1.8.4.5

