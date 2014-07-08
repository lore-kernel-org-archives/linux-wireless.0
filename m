Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:44543 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbaGHNL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2014 09:11:29 -0400
Received: by mail-wi0-f182.google.com with SMTP id bs8so962319wib.3
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2014 06:11:28 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/7] b43: N-PHY: add TX gain tables for devices with specific EPA
Date: Tue,  8 Jul 2014 15:11:05 +0200
Message-Id: <1404825070-5243-2-git-send-email-zajec5@gmail.com> (sfid-20140708_151132_598260_00120E51)
In-Reply-To: <1404825070-5243-1-git-send-email-zajec5@gmail.com>
References: <1404825070-5243-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/tables_nphy.c | 74 +++++++++++++++++++++++++++++++++-
 1 file changed, 72 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index b28dce9..3a5cd90 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2408,6 +2408,41 @@ static const u32 b43_ntab_tx_gain_epa_rev3_2g[] = {
 	0x1041003c, 0x1041003b, 0x10410039, 0x10410037,
 };
 
+static const u32 b43_ntab_tx_gain_epa_rev3_hi_pwr_2g[] = {
+	0x0f410044, 0x0f410042, 0x0f410040, 0x0f41003e,
+	0x0f41003c, 0x0f41003b, 0x0f410039, 0x0f410037,
+	0x0e410044, 0x0e410042, 0x0e410040, 0x0e41003e,
+	0x0e41003c, 0x0e41003b, 0x0e410039, 0x0e410037,
+	0x0d410044, 0x0d410042, 0x0d410040, 0x0d41003e,
+	0x0d41003c, 0x0d41003b, 0x0d410039, 0x0d410037,
+	0x0c410044, 0x0c410042, 0x0c410040, 0x0c41003e,
+	0x0c41003c, 0x0c41003b, 0x0c410039, 0x0c410037,
+	0x0b410044, 0x0b410042, 0x0b410040, 0x0b41003e,
+	0x0b41003c, 0x0b41003b, 0x0b410039, 0x0b410037,
+	0x0a410044, 0x0a410042, 0x0a410040, 0x0a41003e,
+	0x0a41003c, 0x0a41003b, 0x0a410039, 0x0a410037,
+	0x09410044, 0x09410042, 0x09410040, 0x0941003e,
+	0x0941003c, 0x0941003b, 0x09410039, 0x09410037,
+	0x08410044, 0x08410042, 0x08410040, 0x0841003e,
+	0x0841003c, 0x0841003b, 0x08410039, 0x08410037,
+	0x07410044, 0x07410042, 0x07410040, 0x0741003e,
+	0x0741003c, 0x0741003b, 0x07410039, 0x07410037,
+	0x06410044, 0x06410042, 0x06410040, 0x0641003e,
+	0x0641003c, 0x0641003b, 0x06410039, 0x06410037,
+	0x05410044, 0x05410042, 0x05410040, 0x0541003e,
+	0x0541003c, 0x0541003b, 0x05410039, 0x05410037,
+	0x04410044, 0x04410042, 0x04410040, 0x0441003e,
+	0x0441003c, 0x0441003b, 0x04410039, 0x04410037,
+	0x03410044, 0x03410042, 0x03410040, 0x0341003e,
+	0x0341003c, 0x0341003b, 0x03410039, 0x03410037,
+	0x02410044, 0x02410042, 0x02410040, 0x0241003e,
+	0x0241003c, 0x0241003b, 0x02410039, 0x02410037,
+	0x01410044, 0x01410042, 0x01410040, 0x0141003e,
+	0x0141003c, 0x0141003b, 0x01410039, 0x01410037,
+	0x00410044, 0x00410042, 0x00410040, 0x0041003e,
+	0x0041003c, 0x0041003b, 0x00410039, 0x00410037
+};
+
 /* EPA 5 GHz */
 
 static const u32 b43_ntab_tx_gain_epa_rev3_5g[] = {
@@ -2480,6 +2515,41 @@ static const u32 b43_ntab_tx_gain_epa_rev4_5g[] = {
 	0x20d2003a, 0x20d20038, 0x20d20036, 0x20d20034,
 };
 
+static const u32 b43_ntab_tx_gain_epa_rev4_hi_pwr_5g[] = {
+	0x2ff10044, 0x2ff10042, 0x2ff10040, 0x2ff1003e,
+	0x2ff1003c, 0x2ff1003b, 0x2ff10039, 0x2ff10037,
+	0x2ef10044, 0x2ef10042, 0x2ef10040, 0x2ef1003e,
+	0x2ef1003c, 0x2ef1003b, 0x2ef10039, 0x2ef10037,
+	0x2df10044, 0x2df10042, 0x2df10040, 0x2df1003e,
+	0x2df1003c, 0x2df1003b, 0x2df10039, 0x2df10037,
+	0x2cf10044, 0x2cf10042, 0x2cf10040, 0x2cf1003e,
+	0x2cf1003c, 0x2cf1003b, 0x2cf10039, 0x2cf10037,
+	0x2bf10044, 0x2bf10042, 0x2bf10040, 0x2bf1003e,
+	0x2bf1003c, 0x2bf1003b, 0x2bf10039, 0x2bf10037,
+	0x2af10044, 0x2af10042, 0x2af10040, 0x2af1003e,
+	0x2af1003c, 0x2af1003b, 0x2af10039, 0x2af10037,
+	0x29f10044, 0x29f10042, 0x29f10040, 0x29f1003e,
+	0x29f1003c, 0x29f1003b, 0x29f10039, 0x29f10037,
+	0x28f10044, 0x28f10042, 0x28f10040, 0x28f1003e,
+	0x28f1003c, 0x28f1003b, 0x28f10039, 0x28f10037,
+	0x27f10044, 0x27f10042, 0x27f10040, 0x27f1003e,
+	0x27f1003c, 0x27f1003b, 0x27f10039, 0x27f10037,
+	0x26f10044, 0x26f10042, 0x26f10040, 0x26f1003e,
+	0x26f1003c, 0x26f1003b, 0x26f10039, 0x26f10037,
+	0x25f10044, 0x25f10042, 0x25f10040, 0x25f1003e,
+	0x25f1003c, 0x25f1003b, 0x25f10039, 0x25f10037,
+	0x24f10044, 0x24f10042, 0x24f10040, 0x24f1003e,
+	0x24f1003c, 0x24f1003b, 0x24f10039, 0x24f10038,
+	0x23f10041, 0x23f10040, 0x23f1003f, 0x23f1003e,
+	0x23f1003c, 0x23f1003b, 0x23f10039, 0x23f10037,
+	0x22f10044, 0x22f10042, 0x22f10040, 0x22f1003e,
+	0x22f1003c, 0x22f1003b, 0x22f10039, 0x22f10037,
+	0x21f10044, 0x21f10042, 0x21f10040, 0x21f1003e,
+	0x21f1003c, 0x21f1003b, 0x21f10039, 0x21f10037,
+	0x20d10043, 0x20d10041, 0x20d1003e, 0x20d1003c,
+	0x20d1003a, 0x20d10038, 0x20d10036, 0x20d10034
+};
+
 static const u32 b43_ntab_tx_gain_epa_rev5_5g[] = {
 	0x0f62004a, 0x0f620048, 0x0f620046, 0x0f620044,
 	0x0f620042, 0x0f620040, 0x0f62003e, 0x0f62003c,
@@ -3530,7 +3600,7 @@ const u32 *b43_nphy_get_tx_gain_table(struct b43_wldev *dev)
 		case 4:
 			return sprom->fem.ghz5.extpa_gain == 3 ?
 				b43_ntab_tx_gain_epa_rev4_5g :
-				b43_ntab_tx_gain_epa_rev4_5g; /* FIXME */
+				b43_ntab_tx_gain_epa_rev4_hi_pwr_5g;
 		case 3:
 			return b43_ntab_tx_gain_epa_rev3_5g;
 		default:
@@ -3543,7 +3613,7 @@ const u32 *b43_nphy_get_tx_gain_table(struct b43_wldev *dev)
 		case 6:
 		case 5:
 			if (sprom->fem.ghz5.extpa_gain == 3)
-				return b43_ntab_tx_gain_epa_rev3_2g; /* FIXME */
+				return b43_ntab_tx_gain_epa_rev3_hi_pwr_2g;
 			/* fall through */
 		case 4:
 		case 3:
-- 
1.8.4.5

