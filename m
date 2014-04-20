Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:52237 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbaDTLGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2014 07:06:06 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so2868019eek.25
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 04:06:05 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/9] b43: N-PHY: drop second noise variance table
Date: Sun, 20 Apr 2014 13:05:43 +0200
Message-Id: <1397991951-13478-2-git-send-email-zajec5@gmail.com> (sfid-20140420_130645_939309_6920CA3A)
In-Reply-To: <1397991951-13478-1-git-send-email-zajec5@gmail.com>
References: <1397991951-13478-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New Broadcom drivers don't upload it anymore. It was probably a copy & paste
mistake in early N-PHY rev 3+ days.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/tables_nphy.c | 72 +---------------------------------
 drivers/net/wireless/b43/tables_nphy.h |  3 +-
 2 files changed, 3 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index 94c755f..50d03ff 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -1627,74 +1627,7 @@ static const u32 b43_ntab_tdtrn_r3[] = {
 	0xfa58fc00, 0x0b64fc7e, 0x0800f7b6, 0x00f006be,
 };
 
-static const u32 b43_ntab_noisevar0_r3[] = {
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
-};
-
-static const u32 b43_ntab_noisevar1_r3[] = {
+static const u32 b43_ntab_noisevar_r3[] = {
 	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
 	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
 	0x02110211, 0x0000014d, 0x02110211, 0x0000014d,
@@ -3114,8 +3047,7 @@ static void b43_nphy_tables_init_rev3(struct b43_wldev *dev)
 	ntab_upload(dev, B43_NTAB_TMAP_R3, b43_ntab_tmap_r3);
 	ntab_upload(dev, B43_NTAB_INTLEVEL_R3, b43_ntab_intlevel_r3);
 	ntab_upload(dev, B43_NTAB_TDTRN_R3, b43_ntab_tdtrn_r3);
-	ntab_upload(dev, B43_NTAB_NOISEVAR0_R3, b43_ntab_noisevar0_r3);
-	ntab_upload(dev, B43_NTAB_NOISEVAR1_R3, b43_ntab_noisevar1_r3);
+	ntab_upload(dev, B43_NTAB_NOISEVAR_R3, b43_ntab_noisevar_r3);
 	ntab_upload(dev, B43_NTAB_MCS_R3, b43_ntab_mcs_r3);
 	ntab_upload(dev, B43_NTAB_TDI20A0_R3, b43_ntab_tdi20a0_r3);
 	ntab_upload(dev, B43_NTAB_TDI20A1_R3, b43_ntab_tdi20a1_r3);
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index 9ff33ad..3a58aee 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -143,8 +143,7 @@ struct nphy_gain_ctl_workaround_entry *b43_nphy_get_gain_ctl_workaround_ent(
 #define B43_NTAB_TMAP_R3		B43_NTAB32(12,   0) /* TM AP  */
 #define B43_NTAB_INTLEVEL_R3		B43_NTAB32(13,   0) /* INT LV  */
 #define B43_NTAB_TDTRN_R3		B43_NTAB32(14,   0) /* TD TRN  */
-#define B43_NTAB_NOISEVAR0_R3		B43_NTAB32(16,   0) /* noise variance 0  */
-#define B43_NTAB_NOISEVAR1_R3		B43_NTAB32(16, 128) /* noise variance 1  */
+#define B43_NTAB_NOISEVAR_R3		B43_NTAB32(16,   0) /* noise variance */
 #define B43_NTAB_MCS_R3			B43_NTAB16(18,   0) /* MCS  */
 #define B43_NTAB_TDI20A0_R3		B43_NTAB32(19, 128) /* TDI 20/0  */
 #define B43_NTAB_TDI20A1_R3		B43_NTAB32(19, 256) /* TDI 20/1  */
-- 
1.8.4.5

