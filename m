Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:39343 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab0C1Wxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Mar 2010 18:53:32 -0400
Received: by mail-fx0-f223.google.com with SMTP id 23so424568fxm.21
        for <linux-wireless@vger.kernel.org>; Sun, 28 Mar 2010 15:53:31 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/5] b43: N-PHY: prepare for rev3+ channel tables
Date: Mon, 29 Mar 2010 00:53:15 +0200
Message-Id: <1269816796-26820-5-git-send-email-zajec5@gmail.com>
In-Reply-To: <1269816796-26820-2-git-send-email-zajec5@gmail.com>
References: <1269816796-26820-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c       |   22 +++++++++++++---------
 drivers/net/wireless/b43/tables_nphy.c |    8 ++++----
 drivers/net/wireless/b43/tables_nphy.h |   17 ++++++++++++++---
 3 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index d9e47ba..34f80c4 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -104,7 +104,7 @@ static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
 }
 
 static void b43_chantab_radio_upload(struct b43_wldev *dev,
-				     const struct b43_nphy_channeltab_entry *e)
+				const struct b43_nphy_channeltab_entry_rev2 *e)
 {
 	b43_radio_write(dev, B2055_PLL_REF, e->radio_pll_ref);
 	b43_radio_write(dev, B2055_RF_PLLMOD0, e->radio_rf_pllmod0);
@@ -159,7 +159,7 @@ static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/Radio/2055Setup */
 static void b43_radio_2055_setup(struct b43_wldev *dev,
-				const struct b43_nphy_channeltab_entry *e)
+				const struct b43_nphy_channeltab_entry_rev2 *e)
 {
 	B43_WARN_ON(dev->phy.rev >= 3);
 
@@ -3336,16 +3336,20 @@ static int b43_nphy_set_chanspec(struct b43_wldev *dev,
 {
 	struct b43_phy_n *nphy = dev->phy.n;
 
-	const struct b43_nphy_channeltab_entry *tabent;
+	const struct b43_nphy_channeltab_entry_rev2 *tabent_r2;
+	const struct b43_nphy_channeltab_entry_rev3 *tabent_r3;
 
 	u8 tmp;
 	u8 channel = chanspec.channel;
 
 	if (dev->phy.rev >= 3) {
 		/* TODO */
+		tabent_r3 = NULL;
+		if (!tabent_r3)
+			return -ESRCH;
 	} else {
-		tabent = b43_nphy_get_chantabent(dev, channel);
-		if (!tabent)
+		tabent_r2 = b43_nphy_get_chantabent_rev2(dev, channel);
+		if (!tabent_r2)
 			return -ESRCH;
 	}
 
@@ -3367,13 +3371,13 @@ static int b43_nphy_set_chanspec(struct b43_wldev *dev,
 	if (dev->phy.rev >= 3) {
 		tmp = (chanspec.b_freq == 1) ? 4 : 0;
 		b43_radio_maskset(dev, 0x08, 0xFFFB, tmp);
-		/* TODO: PHY Radio2056 Setup (chan_info_ptr[i]) */
-		/* TODO: N PHY Chanspec Setup (chan_info_ptr[i]) */
+		/* TODO: PHY Radio2056 Setup (dev, tabent_r3); */
+		b43_nphy_chanspec_setup(dev, &(tabent_r3->phy_regs), chanspec);
 	} else {
 		tmp = (chanspec.b_freq == 1) ? 0x0020 : 0x0050;
 		b43_radio_maskset(dev, B2055_MASTER1, 0xFF8F, tmp);
-		b43_radio_2055_setup(dev, tabent);
-		b43_nphy_chanspec_setup(dev, &(tabent->phy_regs), chanspec);
+		b43_radio_2055_setup(dev, tabent_r2);
+		b43_nphy_chanspec_setup(dev, &(tabent_r2->phy_regs), chanspec);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index 237426d..d96e870 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -325,7 +325,7 @@ void b2055_upload_inittab(struct b43_wldev *dev,
 	.phy_regs.phy_bw5	= r4,	\
 	.phy_regs.phy_bw6	= r5
 
-static const struct b43_nphy_channeltab_entry b43_nphy_channeltab[] = {
+static const struct b43_nphy_channeltab_entry_rev2 b43_nphy_channeltab[] = {
   {	.channel		= 184,
 	.freq			= 4920, /* MHz */
 	.unk2			= 3280,
@@ -1320,10 +1320,10 @@ static const struct b43_nphy_channeltab_entry b43_nphy_channeltab[] = {
   },
 };
 
-const struct b43_nphy_channeltab_entry *
-b43_nphy_get_chantabent(struct b43_wldev *dev, u8 channel)
+const struct b43_nphy_channeltab_entry_rev2 *
+b43_nphy_get_chantabent_rev2(struct b43_wldev *dev, u8 channel)
 {
-	const struct b43_nphy_channeltab_entry *e;
+	const struct b43_nphy_channeltab_entry_rev2 *e;
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(b43_nphy_channeltab); i++) {
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index 84dea35..8fc1da9 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -13,7 +13,7 @@ struct b43_phy_n_sfo_cfg {
 	u16 phy_bw6;
 };
 
-struct b43_nphy_channeltab_entry {
+struct b43_nphy_channeltab_entry_rev2 {
 	/* The channel number */
 	u8 channel;
 	/* The channel frequency in MHz */
@@ -47,6 +47,17 @@ struct b43_nphy_channeltab_entry {
 	struct b43_phy_n_sfo_cfg phy_regs;
 };
 
+struct b43_nphy_channeltab_entry_rev3 {
+	/* The channel number */
+	u8 channel;
+	/* The channel frequency in MHz */
+	u16 freq;
+	/* Radio register values on channelswitch */
+	/* TODO */
+	/* PHY register values on channelswitch */
+	struct b43_phy_n_sfo_cfg phy_regs;
+};
+
 
 struct b43_wldev;
 
@@ -81,8 +92,8 @@ void b2055_upload_inittab(struct b43_wldev *dev,
 
 /* Get the NPHY Channel Switch Table entry for a channel number.
  * Returns NULL on failure to find an entry. */
-const struct b43_nphy_channeltab_entry *
-b43_nphy_get_chantabent(struct b43_wldev *dev, u8 channel);
+const struct b43_nphy_channeltab_entry_rev2 *
+b43_nphy_get_chantabent_rev2(struct b43_wldev *dev, u8 channel);
 
 
 /* The N-PHY tables. */
-- 
1.6.4.2

