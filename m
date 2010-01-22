Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35680 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab0AVAxi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 19:53:38 -0500
Received: by ewy19 with SMTP id 19so747111ewy.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2010 16:53:35 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/5] b43: N-PHY: implement overriding RF control
Date: Fri, 22 Jan 2010 01:53:13 +0100
Message-Id: <1264121596-9616-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1264121596-9616-1-git-send-email-zajec5@gmail.com>
References: <1264121596-9616-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c       |   82 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/b43/tables_nphy.c |   37 ++++++++++++++
 drivers/net/wireless/b43/tables_nphy.h |   21 ++++++++
 3 files changed, 137 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 2cdf32e..d3c9783 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -912,6 +912,82 @@ ok:
 	b43_phy_write(dev, B43_NPHY_RFSEQMODE, seq_mode);
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RFCtrlOverride */
+static void b43_nphy_rf_control_override(struct b43_wldev *dev, u16 field,
+						u16 value, u8 core, bool off)
+{
+	int i;
+	u8 index = fls(field);
+	u8 addr, en_addr, val_addr;
+	/* we expect only one bit set */
+	B43_WARN_ON(field & (~(1 << index)));
+
+	if (dev->phy.rev >= 3) {
+		const struct nphy_rf_control_override_rev3 *rf_ctrl;
+		for (i = 0; i < 2; i++) {
+			if (index == 0 || index == 16) {
+				b43err(dev->wl,
+					"Unsupported RF Ctrl Override call\n");
+				return;
+			}
+
+			rf_ctrl = &tbl_rf_control_override_rev3[index - 1];
+			en_addr = B43_PHY_N((i == 0) ?
+				rf_ctrl->en_addr0 : rf_ctrl->en_addr1);
+			val_addr = B43_PHY_N((i == 0) ?
+				rf_ctrl->val_addr0 : rf_ctrl->val_addr1);
+
+			if (off) {
+				b43_phy_mask(dev, en_addr, ~(field));
+				b43_phy_mask(dev, val_addr,
+						~(rf_ctrl->val_mask));
+			} else {
+				if (core == 0 || ((1 << core) & i) != 0) {
+					b43_phy_set(dev, en_addr, field);
+					b43_phy_maskset(dev, val_addr,
+						~(rf_ctrl->val_mask),
+						(value << rf_ctrl->val_shift));
+				}
+			}
+		}
+	} else {
+		const struct nphy_rf_control_override_rev2 *rf_ctrl;
+		if (off) {
+			b43_phy_mask(dev, B43_NPHY_RFCTL_OVER, ~(field));
+			value = 0;
+		} else {
+			b43_phy_set(dev, B43_NPHY_RFCTL_OVER, field);
+		}
+
+		for (i = 0; i < 2; i++) {
+			if (index <= 1 || index == 16) {
+				b43err(dev->wl,
+					"Unsupported RF Ctrl Override call\n");
+				return;
+			}
+
+			if (index == 2 || index == 10 ||
+			    (index >= 13 && index <= 15)) {
+				core = 1;
+			}
+
+			rf_ctrl = &tbl_rf_control_override_rev2[index - 2];
+			addr = B43_PHY_N((i == 0) ?
+				rf_ctrl->addr0 : rf_ctrl->addr1);
+
+			if ((core & (1 << i)) != 0)
+				b43_phy_maskset(dev, addr, ~(rf_ctrl->bmask),
+						(value << rf_ctrl->shift));
+
+			b43_phy_set(dev, B43_NPHY_RFCTL_OVER, 0x1);
+			b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
+					B43_NPHY_RFCTL_CMD_START);
+			udelay(1);
+			b43_phy_mask(dev, B43_NPHY_RFCTL_OVER, 0xFFFE);
+		}
+	}
+}
+
 static void b43_nphy_bphy_init(struct b43_wldev *dev)
 {
 	unsigned int i;
@@ -2075,8 +2151,8 @@ static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
 
 			tmp[0] = ((cur_hpf2 << 8) | (cur_hpf1 << 4) |
 					(cur_lna << 2));
-			/* TODO:Call N PHY RF Ctrl Override with 0x400, tmp[0],
-				3, 0 as arguments */
+			b43_nphy_rf_control_override(dev, 0x400, tmp[0], 3,
+									false);
 			b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
 			b43_nphy_stop_playback(dev);
 
@@ -2124,7 +2200,7 @@ static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
 			break;
 	}
 
-	/* TODO: Call N PHY RF Ctrl Override with 0x400, 0, 3, 1 as arguments*/
+	b43_nphy_rf_control_override(dev, 0x400, 0, 3, true);
 	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
 	b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x110), 2, gain_save);
 
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index b8c9fc6..dd9687d 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2883,6 +2883,43 @@ const u16 tbl_tx_iqlo_cal_cmds_fullcal_nphyrev3[] = {
 	0x9084, 0x9267, 0x9056, 0x9234
 };
 
+/* addr0,  addr1,  bmask,  shift */
+const struct nphy_rf_control_override_rev2 tbl_rf_control_override_rev2[] = {
+	{ 0x78, 0x78, 0x0038,  3 }, /* for field == 0x0002 (fls == 2) */
+	{ 0x7A, 0x7D, 0x0001,  0 }, /* for field == 0x0004 (fls == 3) */
+	{ 0x7A, 0x7D, 0x0002,  1 }, /* for field == 0x0008 (fls == 4) */
+	{ 0x7A, 0x7D, 0x0004,  2 }, /* for field == 0x0010 (fls == 5) */
+	{ 0x7A, 0x7D, 0x0030,  4 }, /* for field == 0x0020 (fls == 6) */
+	{ 0x7A, 0x7D, 0x00C0,  6 }, /* for field == 0x0040 (fls == 7) */
+	{ 0x7A, 0x7D, 0x0100,  8 }, /* for field == 0x0080 (fls == 8) */
+	{ 0x7A, 0x7D, 0x0200,  9 }, /* for field == 0x0100 (fls == 9) */
+	{ 0x78, 0x78, 0x0004,  2 }, /* for field == 0x0200 (fls == 10) */
+	{ 0x7B, 0x7E, 0x01FF,  0 }, /* for field == 0x0400 (fls == 11) */
+	{ 0x7C, 0x7F, 0x01FF,  0 }, /* for field == 0x0800 (fls == 12) */
+	{ 0x78, 0x78, 0x0100,  8 }, /* for field == 0x1000 (fls == 13) */
+	{ 0x78, 0x78, 0x0200,  9 }, /* for field == 0x2000 (fls == 14) */
+	{ 0x78, 0x78, 0xF000, 12 }  /* for field == 0x4000 (fls == 15) */
+};
+
+/* val_mask, val_shift, en_addr0, val_addr0, en_addr1, val_addr1 */
+const struct nphy_rf_control_override_rev3 tbl_rf_control_override_rev3[] = {
+	{ 0x8000, 15, 0xE5, 0xF9, 0xE6, 0xFB }, /* field == 0x0001 (fls 1) */
+	{ 0x0001,  0, 0xE7, 0x7A, 0xEC, 0x7D }, /* field == 0x0002 (fls 2) */
+	{ 0x0002,  1, 0xE7, 0x7A, 0xEC, 0x7D }, /* field == 0x0004 (fls 3) */
+	{ 0x0004,  2, 0xE7, 0x7A, 0xEC, 0x7D }, /* field == 0x0008 (fls 4) */
+	{ 0x0016,  4, 0xE7, 0x7A, 0xEC, 0x7D }, /* field == 0x0010 (fls 5) */
+	{ 0x0020,  5, 0xE7, 0x7A, 0xEC, 0x7D }, /* field == 0x0020 (fls 6) */
+	{ 0x0040,  6, 0xE7, 0x7A, 0xEC, 0x7D }, /* field == 0x0040 (fls 7) */
+	{ 0x0080,  6, 0xE7, 0x7A, 0xEC, 0x7D }, /* field == 0x0080 (fls 8) */
+	{ 0x0100,  7, 0xE7, 0x7A, 0xEC, 0x7D }, /* field == 0x0100 (fls 9) */
+	{ 0x0007,  0, 0xE7, 0xF8, 0xEC, 0xFA }, /* field == 0x0200 (fls 10) */
+	{ 0x0070,  4, 0xE7, 0xF8, 0xEC, 0xFA }, /* field == 0x0400 (fls 11) */
+	{ 0xE000, 13, 0xE7, 0x7A, 0xEC, 0x7D }, /* field == 0x0800 (fls 12) */
+	{ 0xFFFF,  0, 0xE7, 0x7B, 0xEC, 0x7E }, /* field == 0x1000 (fls 13) */
+	{ 0xFFFF,  0, 0xE7, 0x7C, 0xEC, 0x7F }, /* field == 0x2000 (fls 14) */
+	{ 0x00C0,  6, 0xE7, 0xF9, 0xEC, 0xFB }  /* field == 0x4000 (fls 15) */
+};
+
 static inline void assert_ntab_array_sizes(void)
 {
 #undef check
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index 6bbef89..5d38172 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -51,6 +51,22 @@ struct nphy_txiqcal_ladder {
 	u8 g_env;
 };
 
+struct nphy_rf_control_override_rev2 {
+	u8 addr0;
+	u8 addr1;
+	u16 bmask;
+	u8 shift;
+};
+
+struct nphy_rf_control_override_rev3 {
+	u16 val_mask;
+	u8 val_shift;
+	u8 en_addr0;
+	u8 val_addr0;
+	u8 en_addr1;
+	u8 val_addr1;
+};
+
 /* Upload the default register value table.
  * If "ghz5" is true, we upload the 5Ghz table. Otherwise the 2.4Ghz
  * table is uploaded. If "ignore_uploadflag" is true, we upload any value
@@ -178,4 +194,9 @@ extern const u16 tbl_tx_iqlo_cal_cmds_recal[];
 extern const u16 tbl_tx_iqlo_cal_cmds_fullcal[];
 extern const u16 tbl_tx_iqlo_cal_cmds_fullcal_nphyrev3[];
 
+extern const struct nphy_rf_control_override_rev2
+	tbl_rf_control_override_rev2[];
+extern const struct nphy_rf_control_override_rev3
+	tbl_rf_control_override_rev3[];
+
 #endif /* B43_TABLES_NPHY_H_ */
-- 
1.6.4.2

