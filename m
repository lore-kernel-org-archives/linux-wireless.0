Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56347 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab2GZHlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 03:41:03 -0400
Received: by eeil10 with SMTP id l10so266980eei.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2012 00:41:02 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: N-PHY: add overriding RF control for rev7+
Date: Thu, 26 Jul 2012 10:25:09 +0200
Message-Id: <1343291109-9224-1-git-send-email-zajec5@gmail.com> (sfid-20120726_094108_377056_53434F17)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
This depends on
b43: N-PHY: add PHY rev7+ workarounds
---
 drivers/net/wireless/b43/phy_n.c       |   48 +++++++++++++++++++--
 drivers/net/wireless/b43/tables_nphy.c |   75 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/tables_nphy.h |   10 ++++
 3 files changed, 129 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 113d5ca..5c90741 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -127,6 +127,46 @@ ok:
 	b43_phy_write(dev, B43_NPHY_RFSEQMODE, seq_mode);
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RFCtrlOverrideRev7 */
+static void b43_nphy_rf_control_override_rev7(struct b43_wldev *dev, u16 field,
+					      u16 value, u8 core, bool off,
+					      u8 override)
+{
+	const struct nphy_rf_control_override_rev7 *e;
+	u16 en_addrs[3][2] = {
+		{ 0x0E7, 0x0EC }, { 0x342, 0x343 }, { 0x346, 0x347 }
+	};
+	u16 en_addr;
+	u16 en_mask = field;
+	u16 val_addr;
+	u8 i;
+
+	/* Remember: we can get NULL! */
+	e = b43_nphy_get_rf_ctl_over_rev7(dev, field, override);
+
+	for (i = 0; i < 2; i++) {
+		if (override >= ARRAY_SIZE(en_addrs)) {
+			b43err(dev->wl, "Invalid override value %d\n", override);
+			return;
+		}
+		en_addr = en_addrs[override][i];
+
+		val_addr = (i == 0) ? e->val_addr_core0 : e->val_addr_core1;
+
+		if (off) {
+			b43_phy_mask(dev, en_addr, ~en_mask);
+			if (e) /* Do it safer, better than wl */
+				b43_phy_mask(dev, val_addr, ~e->val_mask);
+		} else {
+			if (!core || (core & (1 << i))) {
+				b43_phy_set(dev, en_addr, en_mask);
+				if (e)
+					b43_phy_maskset(dev, val_addr, ~e->val_mask, (value << e->val_shift));
+			}
+		}
+	}
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RFCtrlOverride */
 static void b43_nphy_rf_control_override(struct b43_wldev *dev, u16 field,
 						u16 value, u8 core, bool off)
@@ -2219,11 +2259,11 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 			b43_ntab_write(dev, B43_NTAB16(7, 0x159 + core * 16),
 				       rx2tx_lut_40_11n);
 		}
-		/* b43_nphy_rf_control_override_rev7(dev, 16, 1, 3, 0, 2); */
+		b43_nphy_rf_control_override_rev7(dev, 16, 1, 3, false, 2);
 	}
 	b43_phy_write(dev, 0x32F, 0x3);
 	if (phy->radio_rev == 4 || phy->radio_rev == 6)
-		; /* b43_nphy_rf_control_override_rev7(dev, 4, 1, 3, 0, 0); */
+		b43_nphy_rf_control_override_rev7(dev, 4, 1, 3, false, 0);
 
 	if (phy->radio_rev == 3 || phy->radio_rev == 4 || phy->radio_rev == 6) {
 		if (sprom->revision &&
@@ -3083,7 +3123,7 @@ static void b43_nphy_tx_power_ctl_idle_tssi(struct b43_wldev *dev)
 		b43_nphy_ipa_internal_tssi_setup(dev);
 
 	if (phy->rev >= 7)
-		; /* TODO: Override Rev7 with 0x2000, 0, 3, 0, 0 as arguments */
+		b43_nphy_rf_control_override_rev7(dev, 0x2000, 0, 3, false, 0);
 	else if (phy->rev >= 3)
 		b43_nphy_rf_control_override(dev, 0x2000, 0, 3, false);
 
@@ -3095,7 +3135,7 @@ static void b43_nphy_tx_power_ctl_idle_tssi(struct b43_wldev *dev)
 	b43_nphy_rssi_select(dev, 0, 0);
 
 	if (phy->rev >= 7)
-		; /* TODO: Override Rev7 with 0x2000, 0, 3, 1, 0 as arguments */
+		b43_nphy_rf_control_override_rev7(dev, 0x2000, 0, 3, true, 0);
 	else if (phy->rev >= 3)
 		b43_nphy_rf_control_override(dev, 0x2000, 0, 3, true);
 
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index f0d8377..97d4e27 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2757,6 +2757,49 @@ const struct nphy_rf_control_override_rev3 tbl_rf_control_override_rev3[] = {
 	{ 0x00C0,  6, 0xE7, 0xF9, 0xEC, 0xFB }  /* field == 0x4000 (fls 15) */
 };
 
+/* field, val_addr_core0, val_addr_core1, val_mask, val_shift */
+static const struct nphy_rf_control_override_rev7
+			tbl_rf_control_override_rev7_over0[] = {
+	{ 0x0004, 0x07A, 0x07D, 0x0002, 1 },
+	{ 0x0008, 0x07A, 0x07D, 0x0004, 2 },
+	{ 0x0010, 0x07A, 0x07D, 0x0010, 4 },
+	{ 0x0020, 0x07A, 0x07D, 0x0020, 5 },
+	{ 0x0040, 0x07A, 0x07D, 0x0040, 6 },
+	{ 0x0080, 0x0F8, 0x0FA, 0x0080, 7 },
+	{ 0x0400, 0x0F8, 0x0FA, 0x0070, 4 },
+	{ 0x0800, 0x07B, 0x07E, 0xFFFF, 0 },
+	{ 0x1000, 0x07C, 0x07F, 0xFFFF, 0 },
+	{ 0x6000, 0x348, 0x349, 0xFFFF, 0 },
+	{ 0x2000, 0x348, 0x349, 0x000F, 0 },
+};
+
+/* field, val_addr_core0, val_addr_core1, val_mask, val_shift */
+static const struct nphy_rf_control_override_rev7
+			tbl_rf_control_override_rev7_over1[] = {
+	{ 0x0002, 0x340, 0x341, 0x0002, 1 },
+	{ 0x0008, 0x340, 0x341, 0x0008, 3 },
+	{ 0x0020, 0x340, 0x341, 0x0020, 5 },
+	{ 0x0010, 0x340, 0x341, 0x0010, 4 },
+	{ 0x0004, 0x340, 0x341, 0x0004, 2 },
+	{ 0x0080, 0x340, 0x341, 0x0700, 8 },
+	{ 0x0800, 0x340, 0x341, 0x4000, 14 },
+	{ 0x0400, 0x340, 0x341, 0x2000, 13 },
+	{ 0x0200, 0x340, 0x341, 0x0800, 12 },
+	{ 0x0100, 0x340, 0x341, 0x0100, 11 },
+	{ 0x0040, 0x340, 0x341, 0x0040, 6 },
+	{ 0x0001, 0x340, 0x341, 0x0001, 0 },
+};
+
+/* field, val_addr_core0, val_addr_core1, val_mask, val_shift */
+static const struct nphy_rf_control_override_rev7
+			tbl_rf_control_override_rev7_over2[] = {
+	{ 0x0008, 0x344, 0x345, 0x0008, 3 },
+	{ 0x0002, 0x344, 0x345, 0x0002, 1 },
+	{ 0x0001, 0x344, 0x345, 0x0001, 0 },
+	{ 0x0004, 0x344, 0x345, 0x0004, 2 },
+	{ 0x0010, 0x344, 0x345, 0x0010, 4 },
+};
+
 struct nphy_gain_ctl_workaround_entry nphy_gain_ctl_wa_phy6_radio11_ghz2 = {
 	{ 10, 14, 19, 27 },
 	{ -5, 6, 10, 15 },
@@ -3248,3 +3291,35 @@ struct nphy_gain_ctl_workaround_entry *b43_nphy_get_gain_ctl_workaround_ent(
 
 	return e;
 }
+
+const struct nphy_rf_control_override_rev7 *b43_nphy_get_rf_ctl_over_rev7(
+	struct b43_wldev *dev, u16 field, u8 override)
+{
+	const struct nphy_rf_control_override_rev7 *e;
+	u8 size, i;
+
+	switch (override) {
+	case 0:
+		e = tbl_rf_control_override_rev7_over0;
+		size = ARRAY_SIZE(tbl_rf_control_override_rev7_over0);
+		break;
+	case 1:
+		e = tbl_rf_control_override_rev7_over1;
+		size = ARRAY_SIZE(tbl_rf_control_override_rev7_over1);
+		break;
+	case 2:
+		e = tbl_rf_control_override_rev7_over2;
+		size = ARRAY_SIZE(tbl_rf_control_override_rev7_over2);
+		break;
+	default:
+		b43err(dev->wl, "Invalid override value %d\n", override);
+		return NULL;
+	}
+
+	for (i = 0; i < size; i++) {
+		if (e[i].field == field)
+			return &e[i];
+	}
+
+	return NULL;
+}
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index f348953..c600700 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -35,6 +35,14 @@ struct nphy_rf_control_override_rev3 {
 	u8 val_addr1;
 };
 
+struct nphy_rf_control_override_rev7 {
+	u16 field;
+	u16 val_addr_core0;
+	u16 val_addr_core1;
+	u16 val_mask;
+	u8 val_shift;
+};
+
 struct nphy_gain_ctl_workaround_entry {
 	s8 lna1_gain[4];
 	s8 lna2_gain[4];
@@ -202,5 +210,7 @@ extern const struct nphy_rf_control_override_rev2
 	tbl_rf_control_override_rev2[];
 extern const struct nphy_rf_control_override_rev3
 	tbl_rf_control_override_rev3[];
+const struct nphy_rf_control_override_rev7 *b43_nphy_get_rf_ctl_over_rev7(
+	struct b43_wldev *dev, u16 field, u8 override);
 
 #endif /* B43_TABLES_NPHY_H_ */
-- 
1.7.7

