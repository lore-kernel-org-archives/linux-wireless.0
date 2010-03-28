Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:39343 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab0C1WxS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Mar 2010 18:53:18 -0400
Received: by mail-fx0-f223.google.com with SMTP id 23so424568fxm.21
        for <linux-wireless@vger.kernel.org>; Sun, 28 Mar 2010 15:53:17 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/5] b43: N-PHY: use b43_phy_n_sfo_cfg rather than duplicating same fields
Date: Mon, 29 Mar 2010 00:53:13 +0200
Message-Id: <1269816796-26820-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1269816796-26820-2-git-send-email-zajec5@gmail.com>
References: <1269816796-26820-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c       |    6 +++---
 drivers/net/wireless/b43/tables_nphy.c |   12 ++++++------
 drivers/net/wireless/b43/tables_nphy.h |   15 +++++----------
 3 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 0586667..052119b 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -141,7 +141,7 @@ static void b43_chantab_radio_upload(struct b43_wldev *dev,
 }
 
 static void b43_chantab_phy_upload(struct b43_wldev *dev,
-				   const struct b43_nphy_channeltab_entry *e)
+				   const struct b43_phy_n_sfo_cfg *e)
 {
 	b43_phy_write(dev, B43_NPHY_BW1A, e->phy_bw1a);
 	b43_phy_write(dev, B43_NPHY_BW2, e->phy_bw2);
@@ -3270,7 +3270,7 @@ int b43_phy_initn(struct b43_wldev *dev)
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ChanspecSetup */
 static void b43_nphy_chanspec_setup(struct b43_wldev *dev,
-				const struct b43_nphy_channeltab_entry *e,
+				const struct b43_phy_n_sfo_cfg *e,
 				struct b43_chanspec chanspec)
 {
 	struct b43_phy *phy = &dev->phy;
@@ -3373,7 +3373,7 @@ static int b43_nphy_set_chanspec(struct b43_wldev *dev,
 		tmp = (chanspec.b_freq == 1) ? 0x0020 : 0x0050;
 		b43_radio_maskset(dev, B2055_MASTER1, 0xFF8F, tmp);
 		b43_radio_2055_setup(dev, tabent);
-		b43_nphy_chanspec_setup(dev, tabent, chanspec);
+		b43_nphy_chanspec_setup(dev, &(tabent->phy_regs), chanspec);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index a00d509..237426d 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -318,12 +318,12 @@ void b2055_upload_inittab(struct b43_wldev *dev,
 	.radio_c2_tx_mxbgtrim	= r21
 
 #define PHYREGS(r0, r1, r2, r3, r4, r5)	\
-	.phy_bw1a	= r0,		\
-	.phy_bw2	= r1,		\
-	.phy_bw3	= r2,		\
-	.phy_bw4	= r3,		\
-	.phy_bw5	= r4,		\
-	.phy_bw6	= r5
+	.phy_regs.phy_bw1a	= r0,	\
+	.phy_regs.phy_bw2	= r1,	\
+	.phy_regs.phy_bw3	= r2,	\
+	.phy_regs.phy_bw4	= r3,	\
+	.phy_regs.phy_bw5	= r4,	\
+	.phy_regs.phy_bw6	= r5
 
 static const struct b43_nphy_channeltab_entry b43_nphy_channeltab[] = {
   {	.channel		= 184,
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index b23036f..84dea35 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -16,6 +16,10 @@ struct b43_phy_n_sfo_cfg {
 struct b43_nphy_channeltab_entry {
 	/* The channel number */
 	u8 channel;
+	/* The channel frequency in MHz */
+	u16 freq;
+	/* An unknown value */
+	u16 unk2;
 	/* Radio register values on channelswitch */
 	u8 radio_pll_ref;
 	u8 radio_rf_pllmod0;
@@ -40,16 +44,7 @@ struct b43_nphy_channeltab_entry {
 	u8 radio_c2_tx_pgapadtn;
 	u8 radio_c2_tx_mxbgtrim;
 	/* PHY register values on channelswitch */
-	u16 phy_bw1a;
-	u16 phy_bw2;
-	u16 phy_bw3;
-	u16 phy_bw4;
-	u16 phy_bw5;
-	u16 phy_bw6;
-	/* The channel frequency in MHz */
-	u16 freq;
-	/* An unknown value */
-	u16 unk2;
+	struct b43_phy_n_sfo_cfg phy_regs;
 };
 
 
-- 
1.6.4.2

