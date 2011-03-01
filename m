Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45880 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab1CAUff (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 15:35:35 -0500
Received: by mail-ey0-f174.google.com with SMTP id 24so1813358eyx.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 12:35:35 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] b43: N-PHY: rev3+: add tables with gain ctl workarounds
Date: Tue,  1 Mar 2011 21:40:40 +0100
Message-Id: <1299012041-7937-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1299012041-7937-1-git-send-email-zajec5@gmail.com>
References: <1299012041-7937-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/tables_nphy.c |  103 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/tables_nphy.h |   25 ++++++++
 2 files changed, 128 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index c42b2ac..2de483b 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2709,6 +2709,79 @@ const struct nphy_rf_control_override_rev3 tbl_rf_control_override_rev3[] = {
 	{ 0x00C0,  6, 0xE7, 0xF9, 0xEC, 0xFB }  /* field == 0x4000 (fls 15) */
 };
 
+struct nphy_gain_ctl_workaround_entry nphy_gain_ctl_workaround[2][3] = {
+	{ /* 2GHz */
+		{ /* PHY rev 3 */
+			{ 7, 11, 16, 23 },
+			{ -5, 6, 10, 14 },
+			{ 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA },
+			{ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3 },
+			0x627E,
+			{ 0x613F, 0x613F, 0x613F, 0x613F },
+			0x107E, 0x0066, 0x0074,
+			0x18, 0x18, 0x18,
+			0x020D, 0x5,
+		},
+		{ /* PHY rev 4 */
+			{ 8, 12, 17, 25 },
+			{ -5, 6, 10, 14 },
+			{ 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA },
+			{ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3 },
+			0x527E,
+			{ 0x513F, 0x513F, 0x513F, 0x513F },
+			0x007E, 0x0066, 0x0074,
+			0x18, 0x18, 0x18,
+			0x01A1, 0x5,
+		},
+		{ /* PHY rev 5+ */
+			{ 9, 13, 18, 26 },
+			{ -3, 7, 11, 16 },
+			{ 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA },
+			{ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3 },
+			0x427E, /* invalid for external LNA! */
+			{ 0x413F, 0x413F, 0x413F, 0x413F }, /* invalid for external LNA! */
+			0x1076, 0x0066, 0x106A,
+			0xC, 0xC, 0xC,
+			0x01D0, 0x5,
+		},
+	},
+	{ /* 5GHz */
+		{ /* PHY rev 3 */
+			{ 7, 11, 17, 23 },
+			{ -6, 2, 6, 10 },
+			{ 0x13, 0x13, 0x13, 0x13, 0x13, 0x13, 0x13, 0x13, 0x13, 0x13 },
+			{ 6, 6, 6, 6, 6, 6, 6, 6, 6, 6 },
+			0x52DE,
+			{ 0x516F, 0x516F, 0x516F, 0x516F },
+			0x00DE, 0x00CA, 0x00CC,
+			0x1E, 0x1E, 0x1E,
+			0x01A1, 25,
+		},
+		{ /* PHY rev 4 */
+			{ 8, 12, 18, 23 },
+			{ -5, 2, 6, 10 },
+			{ 0xD, 0xD, 0xD, 0xD, 0xD, 0xD, 0xD, 0xD, 0xD, 0xD },
+			{ 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 },
+			0x629E,
+			{ 0x614F, 0x614F, 0x614F, 0x614F },
+			0x029E, 0x1084, 0x0086,
+			0x24, 0x24, 0x24,
+			0x0107, 25,
+		},
+		{ /* PHY rev 5+ */
+			{ 6, 10, 16, 21 },
+			{ -7, 0, 4, 8 },
+			{ 0xD, 0xD, 0xD, 0xD, 0xD, 0xD, 0xD, 0xD, 0xD, 0xD },
+			{ 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 },
+			0x729E,
+			{ 0x714F, 0x714F, 0x714F, 0x714F },
+			0x029E, 0x2084, 0x2086,
+			0x24, 0x24, 0x24,
+			0x00A9, 25,
+		},
+	},
+};
+
 static inline void assert_ntab_array_sizes(void)
 {
 #undef check
@@ -2957,3 +3030,33 @@ void b43_nphy_rev3plus_tables_init(struct b43_wldev *dev)
 	/* Volatile tables */
 	/* TODO */
 }
+
+struct nphy_gain_ctl_workaround_entry *b43_nphy_get_gain_ctl_workaround_ent(
+	struct b43_wldev *dev, bool ghz5, bool ext_lna)
+{
+	struct nphy_gain_ctl_workaround_entry *e;
+	u8 phy_idx;
+
+	B43_WARN_ON(dev->phy.rev < 3);
+	if (dev->phy.rev >= 5)
+		phy_idx = 2;
+	else if (dev->phy.rev == 4)
+		phy_idx = 1;
+	else
+		phy_idx = 0;
+
+	e = &nphy_gain_ctl_workaround[ghz5][phy_idx];
+
+	/* Only one entry differs for external LNA, so instead making whole
+	 * table 2 times bigger, hack is here
+	 */
+	if (!ghz5 && dev->phy.rev >= 5 && ext_lna) {
+		e->rfseq_init[0] &= 0x0FFF;
+		e->rfseq_init[1] &= 0x0FFF;
+		e->rfseq_init[2] &= 0x0FFF;
+		e->rfseq_init[3] &= 0x0FFF;
+		e->init_gain &= 0x0FFF;
+	}
+
+	return e;
+}
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index 016a480..1856936 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -35,6 +35,31 @@ struct nphy_rf_control_override_rev3 {
 	u8 val_addr1;
 };
 
+struct nphy_gain_ctl_workaround_entry {
+	s8 lna1_gain[4];
+	s8 lna2_gain[4];
+	u8 gain_db[10];
+	u8 gain_bits[10];
+
+	u16 init_gain;
+	u16 rfseq_init[4];
+
+	u16 cliphi_gain;
+	u16 clipmd_gain;
+	u16 cliplo_gain;
+
+	u16 crsmin;
+	u16 crsminl;
+	u16 crsminu;
+
+	u16 nbclip;
+	u16 wlclip;
+};
+
+/* Get entry with workaround values for gain ctl. Does not return NULL. */
+struct nphy_gain_ctl_workaround_entry *b43_nphy_get_gain_ctl_workaround_ent(
+	struct b43_wldev *dev, bool ghz5, bool ext_lna);
+
 /* Get the NPHY Channel Switch Table entry for a channel.
  * Returns NULL on failure to find an entry. */
 const struct b43_nphy_channeltab_entry_rev2 *
-- 
1.7.3.4

