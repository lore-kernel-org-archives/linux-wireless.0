Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:38052 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaGAOeH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 10:34:07 -0400
Received: by mail-we0-f169.google.com with SMTP id t60so9912942wes.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2014 07:34:05 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: add more bcma cores
Date: Tue,  1 Jul 2014 16:33:57 +0200
Message-Id: <1404225237-28817-1-git-send-email-zajec5@gmail.com> (sfid-20140701_163411_321164_0D8985B4)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds some cores with 0x2057 radio which will be supported soon as
well as core 40 that I missed in the earlier firmware patch.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 0b1aac4..4d7b38c 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -122,7 +122,11 @@ static const struct bcma_device_id b43_bcma_tbl[] = {
 	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x11, BCMA_ANY_CLASS),
 	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x17, BCMA_ANY_CLASS),
 	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x18, BCMA_ANY_CLASS),
+	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x1C, BCMA_ANY_CLASS),
 	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x1D, BCMA_ANY_CLASS),
+	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x1E, BCMA_ANY_CLASS),
+	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x28, BCMA_ANY_CLASS),
+	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x2A, BCMA_ANY_CLASS),
 	BCMA_CORETABLE_END
 };
 MODULE_DEVICE_TABLE(bcma, b43_bcma_tbl);
@@ -2218,6 +2222,10 @@ static int b43_try_request_fw(struct b43_request_fw_context *ctx)
 		if (phy->type == B43_PHYTYPE_AC)
 			filename = "ucode42";
 		break;
+	case 40:
+		if (phy->type == B43_PHYTYPE_AC)
+			filename = "ucode40";
+		break;
 	case 33:
 		if (phy->type == B43_PHYTYPE_LCN40)
 			filename = "ucode33_lcn40";
@@ -2343,6 +2351,8 @@ static int b43_try_request_fw(struct b43_request_fw_context *ctx)
 	case B43_PHYTYPE_AC:
 		if (rev == 42)
 			filename = "ac1initvals42";
+		else if (rev == 40)
+			filename = "ac0initvals40";
 		break;
 	}
 	if (!filename)
@@ -2401,6 +2411,8 @@ static int b43_try_request_fw(struct b43_request_fw_context *ctx)
 	case B43_PHYTYPE_AC:
 		if (rev == 42)
 			filename = "ac1bsinitvals42";
+		else if (rev == 40)
+			filename = "ac0bsinitvals40";
 		break;
 	}
 	if (!filename)
-- 
1.8.4.5

