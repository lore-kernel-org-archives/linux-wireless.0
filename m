Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:50164 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147AbaGAOTY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 10:19:24 -0400
Received: by mail-wi0-f179.google.com with SMTP id cc10so7837978wib.12
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2014 07:19:23 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: N-PHY: complete generic support for 0x2057 radio
Date: Tue,  1 Jul 2014 16:19:08 +0200
Message-Id: <1404224348-28010-2-git-send-email-zajec5@gmail.com> (sfid-20140701_161930_530194_833EA840)
In-Reply-To: <1404224348-28010-1-git-send-email-zajec5@gmail.com>
References: <1404224348-28010-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't include any device (radio revision) specific code yet, so it
isn't really usable. As the commit says, it's just some generic code.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c      | 132 +++++++++++++++++++++++++++++++---
 drivers/net/wireless/b43/radio_2057.c | 104 +++++++++++++++++++++++----
 drivers/net/wireless/b43/radio_2057.h |  66 +++++++++++++++++
 3 files changed, 282 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 8369a08..0a6f04b 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -590,6 +590,100 @@ static void b43_nphy_set_rf_sequence(struct b43_wldev *dev, u8 cmd,
  * Radio 0x2057
  **************************************************/
 
+static void b43_radio_2057_chantab_upload(struct b43_wldev *dev,
+					  const struct b43_nphy_chantabent_rev7 *e_r7,
+					  const struct b43_nphy_chantabent_rev7_2g *e_r7_2g)
+{
+	if (e_r7_2g) {
+		b43_radio_write(dev, R2057_VCOCAL_COUNTVAL0, e_r7_2g->radio_vcocal_countval0);
+		b43_radio_write(dev, R2057_VCOCAL_COUNTVAL1, e_r7_2g->radio_vcocal_countval1);
+		b43_radio_write(dev, R2057_RFPLL_REFMASTER_SPAREXTALSIZE, e_r7_2g->radio_rfpll_refmaster_sparextalsize);
+		b43_radio_write(dev, R2057_RFPLL_LOOPFILTER_R1, e_r7_2g->radio_rfpll_loopfilter_r1);
+		b43_radio_write(dev, R2057_RFPLL_LOOPFILTER_C2, e_r7_2g->radio_rfpll_loopfilter_c2);
+		b43_radio_write(dev, R2057_RFPLL_LOOPFILTER_C1, e_r7_2g->radio_rfpll_loopfilter_c1);
+		b43_radio_write(dev, R2057_CP_KPD_IDAC, e_r7_2g->radio_cp_kpd_idac);
+		b43_radio_write(dev, R2057_RFPLL_MMD0, e_r7_2g->radio_rfpll_mmd0);
+		b43_radio_write(dev, R2057_RFPLL_MMD1, e_r7_2g->radio_rfpll_mmd1);
+		b43_radio_write(dev, R2057_VCOBUF_TUNE, e_r7_2g->radio_vcobuf_tune);
+		b43_radio_write(dev, R2057_LOGEN_MX2G_TUNE, e_r7_2g->radio_logen_mx2g_tune);
+		b43_radio_write(dev, R2057_LOGEN_INDBUF2G_TUNE, e_r7_2g->radio_logen_indbuf2g_tune);
+		b43_radio_write(dev, R2057_TXMIX2G_TUNE_BOOST_PU_CORE0, e_r7_2g->radio_txmix2g_tune_boost_pu_core0);
+		b43_radio_write(dev, R2057_PAD2G_TUNE_PUS_CORE0, e_r7_2g->radio_pad2g_tune_pus_core0);
+		b43_radio_write(dev, R2057_LNA2G_TUNE_CORE0, e_r7_2g->radio_lna2g_tune_core0);
+		b43_radio_write(dev, R2057_TXMIX2G_TUNE_BOOST_PU_CORE1, e_r7_2g->radio_txmix2g_tune_boost_pu_core1);
+		b43_radio_write(dev, R2057_PAD2G_TUNE_PUS_CORE1, e_r7_2g->radio_pad2g_tune_pus_core1);
+		b43_radio_write(dev, R2057_LNA2G_TUNE_CORE1, e_r7_2g->radio_lna2g_tune_core1);
+
+	} else {
+		b43_radio_write(dev, R2057_VCOCAL_COUNTVAL0, e_r7->radio_vcocal_countval0);
+		b43_radio_write(dev, R2057_VCOCAL_COUNTVAL1, e_r7->radio_vcocal_countval1);
+		b43_radio_write(dev, R2057_RFPLL_REFMASTER_SPAREXTALSIZE, e_r7->radio_rfpll_refmaster_sparextalsize);
+		b43_radio_write(dev, R2057_RFPLL_LOOPFILTER_R1, e_r7->radio_rfpll_loopfilter_r1);
+		b43_radio_write(dev, R2057_RFPLL_LOOPFILTER_C2, e_r7->radio_rfpll_loopfilter_c2);
+		b43_radio_write(dev, R2057_RFPLL_LOOPFILTER_C1, e_r7->radio_rfpll_loopfilter_c1);
+		b43_radio_write(dev, R2057_CP_KPD_IDAC, e_r7->radio_cp_kpd_idac);
+		b43_radio_write(dev, R2057_RFPLL_MMD0, e_r7->radio_rfpll_mmd0);
+		b43_radio_write(dev, R2057_RFPLL_MMD1, e_r7->radio_rfpll_mmd1);
+		b43_radio_write(dev, R2057_VCOBUF_TUNE, e_r7->radio_vcobuf_tune);
+		b43_radio_write(dev, R2057_LOGEN_MX2G_TUNE, e_r7->radio_logen_mx2g_tune);
+		b43_radio_write(dev, R2057_LOGEN_MX5G_TUNE, e_r7->radio_logen_mx5g_tune);
+		b43_radio_write(dev, R2057_LOGEN_INDBUF2G_TUNE, e_r7->radio_logen_indbuf2g_tune);
+		b43_radio_write(dev, R2057_LOGEN_INDBUF5G_TUNE, e_r7->radio_logen_indbuf5g_tune);
+		b43_radio_write(dev, R2057_TXMIX2G_TUNE_BOOST_PU_CORE0, e_r7->radio_txmix2g_tune_boost_pu_core0);
+		b43_radio_write(dev, R2057_PAD2G_TUNE_PUS_CORE0, e_r7->radio_pad2g_tune_pus_core0);
+		b43_radio_write(dev, R2057_PGA_BOOST_TUNE_CORE0, e_r7->radio_pga_boost_tune_core0);
+		b43_radio_write(dev, R2057_TXMIX5G_BOOST_TUNE_CORE0, e_r7->radio_txmix5g_boost_tune_core0);
+		b43_radio_write(dev, R2057_PAD5G_TUNE_MISC_PUS_CORE0, e_r7->radio_pad5g_tune_misc_pus_core0);
+		b43_radio_write(dev, R2057_LNA2G_TUNE_CORE0, e_r7->radio_lna2g_tune_core0);
+		b43_radio_write(dev, R2057_LNA5G_TUNE_CORE0, e_r7->radio_lna5g_tune_core0);
+		b43_radio_write(dev, R2057_TXMIX2G_TUNE_BOOST_PU_CORE1, e_r7->radio_txmix2g_tune_boost_pu_core1);
+		b43_radio_write(dev, R2057_PAD2G_TUNE_PUS_CORE1, e_r7->radio_pad2g_tune_pus_core1);
+		b43_radio_write(dev, R2057_PGA_BOOST_TUNE_CORE1, e_r7->radio_pga_boost_tune_core1);
+		b43_radio_write(dev, R2057_TXMIX5G_BOOST_TUNE_CORE1, e_r7->radio_txmix5g_boost_tune_core1);
+		b43_radio_write(dev, R2057_PAD5G_TUNE_MISC_PUS_CORE1, e_r7->radio_pad5g_tune_misc_pus_core1);
+		b43_radio_write(dev, R2057_LNA2G_TUNE_CORE1, e_r7->radio_lna2g_tune_core1);
+		b43_radio_write(dev, R2057_LNA5G_TUNE_CORE1, e_r7->radio_lna5g_tune_core1);
+	}
+}
+
+static void b43_radio_2057_setup(struct b43_wldev *dev,
+				 const struct b43_nphy_chantabent_rev7 *tabent_r7,
+				 const struct b43_nphy_chantabent_rev7_2g *tabent_r7_2g)
+{
+	struct b43_phy *phy = &dev->phy;
+
+	b43_radio_2057_chantab_upload(dev, tabent_r7, tabent_r7_2g);
+
+	switch (phy->radio_rev) {
+	case 0 ... 4:
+	case 6:
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+			b43_radio_write(dev, R2057_RFPLL_LOOPFILTER_R1, 0x3f);
+			b43_radio_write(dev, R2057_CP_KPD_IDAC, 0x3f);
+			b43_radio_write(dev, R2057_RFPLL_LOOPFILTER_C1, 0x8);
+			b43_radio_write(dev, R2057_RFPLL_LOOPFILTER_C2, 0x8);
+		} else {
+			b43_radio_write(dev, R2057_RFPLL_LOOPFILTER_R1, 0x1f);
+			b43_radio_write(dev, R2057_CP_KPD_IDAC, 0x3f);
+			b43_radio_write(dev, R2057_RFPLL_LOOPFILTER_C1, 0x8);
+			b43_radio_write(dev, R2057_RFPLL_LOOPFILTER_C2, 0x8);
+		}
+		break;
+	/* TODO */
+	}
+
+	/* TODO */
+
+	usleep_range(50, 100);
+
+	/* VCO calibration */
+	b43_radio_mask(dev, R2057_RFPLL_MISC_EN, ~0x01);
+	b43_radio_mask(dev, R2057_RFPLL_MISC_CAL_RESETN, ~0x04);
+	b43_radio_set(dev, R2057_RFPLL_MISC_CAL_RESETN, 0x4);
+	b43_radio_set(dev, R2057_RFPLL_MISC_EN, 0x01);
+	usleep_range(300, 600);
+}
+
 /* Calibrate resistors in LPF of PLL?
  * http://bcm-v4.sipsolutions.net/PHY/radio205x_rcal
  */
@@ -5535,10 +5629,17 @@ static int b43_nphy_set_channel(struct b43_wldev *dev,
 
 	const struct b43_nphy_channeltab_entry_rev2 *tabent_r2 = NULL;
 	const struct b43_nphy_channeltab_entry_rev3 *tabent_r3 = NULL;
+	const struct b43_nphy_chantabent_rev7 *tabent_r7 = NULL;
+	const struct b43_nphy_chantabent_rev7_2g *tabent_r7_2g = NULL;
 
 	u8 tmp;
 
-	if (dev->phy.rev >= 3) {
+	if (phy->rev >= 7) {
+		r2057_get_chantabent_rev7(dev, channel->center_freq,
+					  &tabent_r7, &tabent_r7_2g);
+		if (!tabent_r7 && !tabent_r7_2g)
+			return -ESRCH;
+	} else if (phy->rev >= 3) {
 		tabent_r3 = b43_nphy_get_chantabent_rev3(dev,
 							channel->center_freq);
 		if (!tabent_r3)
@@ -5560,14 +5661,29 @@ static int b43_nphy_set_channel(struct b43_wldev *dev,
 		; /* TODO: BMAC BW Set (channel_type) */
 #endif
 
-	if (channel_type == NL80211_CHAN_HT40PLUS)
-		b43_phy_set(dev, B43_NPHY_RXCTL,
-				B43_NPHY_RXCTL_BSELU20);
-	else if (channel_type == NL80211_CHAN_HT40MINUS)
-		b43_phy_mask(dev, B43_NPHY_RXCTL,
-				~B43_NPHY_RXCTL_BSELU20);
+	if (channel_type == NL80211_CHAN_HT40PLUS) {
+		b43_phy_set(dev, B43_NPHY_RXCTL, B43_NPHY_RXCTL_BSELU20);
+		if (phy->rev >= 7)
+			b43_phy_set(dev, 0x310, 0x8000);
+	} else if (channel_type == NL80211_CHAN_HT40MINUS) {
+		b43_phy_mask(dev, B43_NPHY_RXCTL, ~B43_NPHY_RXCTL_BSELU20);
+		if (phy->rev >= 7)
+			b43_phy_mask(dev, 0x310, (u16)~0x8000);
+	}
 
-	if (dev->phy.rev >= 3) {
+	if (phy->rev >= 7) {
+		const struct b43_phy_n_sfo_cfg *phy_regs = tabent_r7 ?
+			&(tabent_r7->phy_regs) : &(tabent_r7_2g->phy_regs);
+
+		if (phy->radio_rev <= 4 || phy->radio_rev == 6) {
+			tmp = (channel->band == IEEE80211_BAND_5GHZ) ? 2 : 0;
+			b43_radio_maskset(dev, R2057_TIA_CONFIG_CORE0, ~2, tmp);
+			b43_radio_maskset(dev, R2057_TIA_CONFIG_CORE1, ~2, tmp);
+		}
+
+		b43_radio_2057_setup(dev, tabent_r7, tabent_r7_2g);
+		b43_nphy_channel_setup(dev, phy_regs, channel);
+	} else if (phy->rev >= 3) {
 		tmp = (channel->band == IEEE80211_BAND_5GHZ) ? 4 : 0;
 		b43_radio_maskset(dev, 0x08, 0xFFFB, tmp);
 		b43_radio_2056_setup(dev, tabent_r3);
diff --git a/drivers/net/wireless/b43/radio_2057.c b/drivers/net/wireless/b43/radio_2057.c
index 5e49440..df35745 100644
--- a/drivers/net/wireless/b43/radio_2057.c
+++ b/drivers/net/wireless/b43/radio_2057.c
@@ -86,6 +86,7 @@ static u16 r2057_rev7_init[][2] = {
 	{ 0x1B7, 0x05 }, { 0x1C2, 0xa0 },
 };
 
+/* TODO: Which devices should use it?
 static u16 r2057_rev8_init[][2] = {
 	{ 0x00, 0x08 }, { 0x01, 0x57 }, { 0x02, 0x20 }, { 0x31, 0x00 },
 	{ 0x32, 0x00 }, { 0x33, 0x00 }, { 0x51, 0x70 }, { 0x59, 0x88 },
@@ -102,6 +103,47 @@ static u16 r2057_rev8_init[][2] = {
 	{ 0x1A6, 0x00 }, { 0x1AA, 0x00 }, { 0x1AB, 0x00 }, { 0x1AC, 0x00 },
 	{ 0x1B7, 0x05 }, { 0x1C2, 0xa0 },
 };
+*/
+
+#define RADIOREGS7(r00, r01, r02, r03, r04, r05, r06, r07, r08, r09, \
+		   r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, \
+		   r20, r21, r22, r23, r24, r25, r26, r27) \
+	.radio_vcocal_countval0			= r00,	\
+	.radio_vcocal_countval1			= r01,	\
+	.radio_rfpll_refmaster_sparextalsize	= r02,	\
+	.radio_rfpll_loopfilter_r1		= r03,	\
+	.radio_rfpll_loopfilter_c2		= r04,	\
+	.radio_rfpll_loopfilter_c1		= r05,	\
+	.radio_cp_kpd_idac			= r06,	\
+	.radio_rfpll_mmd0			= r07,	\
+	.radio_rfpll_mmd1			= r08,	\
+	.radio_vcobuf_tune			= r09,	\
+	.radio_logen_mx2g_tune			= r10,	\
+	.radio_logen_mx5g_tune			= r11,	\
+	.radio_logen_indbuf2g_tune		= r12,	\
+	.radio_logen_indbuf5g_tune		= r13,	\
+	.radio_txmix2g_tune_boost_pu_core0	= r14,	\
+	.radio_pad2g_tune_pus_core0		= r15,	\
+	.radio_pga_boost_tune_core0		= r16,	\
+	.radio_txmix5g_boost_tune_core0		= r17,	\
+	.radio_pad5g_tune_misc_pus_core0	= r18,	\
+	.radio_lna2g_tune_core0			= r19,	\
+	.radio_lna5g_tune_core0			= r20,	\
+	.radio_txmix2g_tune_boost_pu_core1	= r21,	\
+	.radio_pad2g_tune_pus_core1		= r22,	\
+	.radio_pga_boost_tune_core1		= r23,	\
+	.radio_txmix5g_boost_tune_core1		= r24,	\
+	.radio_pad5g_tune_misc_pus_core1	= r25,	\
+	.radio_lna2g_tune_core1			= r26,	\
+	.radio_lna5g_tune_core1			= r27
+
+#define PHYREGS(r0, r1, r2, r3, r4, r5)	\
+	.phy_regs.phy_bw1a	= r0,	\
+	.phy_regs.phy_bw2	= r1,	\
+	.phy_regs.phy_bw3	= r2,	\
+	.phy_regs.phy_bw4	= r3,	\
+	.phy_regs.phy_bw5	= r4,	\
+	.phy_regs.phy_bw6	= r5
 
 void r2057_upload_inittabs(struct b43_wldev *dev)
 {
@@ -109,25 +151,26 @@ void r2057_upload_inittabs(struct b43_wldev *dev)
 	u16 *table = NULL;
 	u16 size, i;
 
-	if (phy->rev == 7) {
+	switch (phy->rev) {
+	case 7:
 		table = r2057_rev4_init[0];
 		size = ARRAY_SIZE(r2057_rev4_init);
-	} else if (phy->rev == 8 || phy->rev == 9) {
+		break;
+	case 8:
 		if (phy->radio_rev == 5) {
-			if (phy->radio_rev == 8) {
-				table = r2057_rev5_init[0];
-				size = ARRAY_SIZE(r2057_rev5_init);
-			} else {
-				table = r2057_rev5a_init[0];
-				size = ARRAY_SIZE(r2057_rev5a_init);
-			}
+			table = r2057_rev5_init[0];
+			size = ARRAY_SIZE(r2057_rev5_init);
 		} else if (phy->radio_rev == 7) {
 			table = r2057_rev7_init[0];
 			size = ARRAY_SIZE(r2057_rev7_init);
-		} else if (phy->radio_rev == 9) {
-			table = r2057_rev8_init[0];
-			size = ARRAY_SIZE(r2057_rev8_init);
 		}
+		break;
+	case 9:
+		if (phy->radio_rev == 5) {
+			table = r2057_rev5a_init[0];
+			size = ARRAY_SIZE(r2057_rev5a_init);
+		}
+		break;
 	}
 
 	B43_WARN_ON(!table);
@@ -137,3 +180,40 @@ void r2057_upload_inittabs(struct b43_wldev *dev)
 			b43_radio_write(dev, table[0], table[1]);
 	}
 }
+
+void r2057_get_chantabent_rev7(struct b43_wldev *dev, u16 freq,
+			       const struct b43_nphy_chantabent_rev7 **tabent_r7,
+			       const struct b43_nphy_chantabent_rev7_2g **tabent_r7_2g)
+{
+	struct b43_phy *phy = &dev->phy;
+	const struct b43_nphy_chantabent_rev7 *e_r7 = NULL;
+	const struct b43_nphy_chantabent_rev7_2g *e_r7_2g = NULL;
+	unsigned int len, i;
+
+	*tabent_r7 = NULL;
+	*tabent_r7_2g = NULL;
+
+	/* TODO */
+	switch (phy->rev) {
+	default:
+		break;
+	}
+
+	if (e_r7) {
+		for (i = 0; i < len; i++, e_r7++) {
+			if (e_r7->freq == freq) {
+				*tabent_r7 = e_r7;
+				return;
+			}
+		}
+	} else if (e_r7_2g) {
+		for (i = 0; i < len; i++, e_r7_2g++) {
+			if (e_r7_2g->freq == freq) {
+				*tabent_r7_2g = e_r7_2g;
+				return;
+			}
+		}
+	} else {
+		B43_WARN_ON(1);
+	}
+}
diff --git a/drivers/net/wireless/b43/radio_2057.h b/drivers/net/wireless/b43/radio_2057.h
index eeebd8f..675d1bb 100644
--- a/drivers/net/wireless/b43/radio_2057.h
+++ b/drivers/net/wireless/b43/radio_2057.h
@@ -425,6 +425,72 @@
 
 #define R2057_VCM_MASK				0x7
 
+struct b43_nphy_chantabent_rev7 {
+	/* The channel frequency in MHz */
+	u16 freq;
+	/* Radio regs values on channelswitch */
+	u8 radio_vcocal_countval0;
+	u8 radio_vcocal_countval1;
+	u8 radio_rfpll_refmaster_sparextalsize;
+	u8 radio_rfpll_loopfilter_r1;
+	u8 radio_rfpll_loopfilter_c2;
+	u8 radio_rfpll_loopfilter_c1;
+	u8 radio_cp_kpd_idac;
+	u8 radio_rfpll_mmd0;
+	u8 radio_rfpll_mmd1;
+	u8 radio_vcobuf_tune;
+	u8 radio_logen_mx2g_tune;
+	u8 radio_logen_mx5g_tune;
+	u8 radio_logen_indbuf2g_tune;
+	u8 radio_logen_indbuf5g_tune;
+	u8 radio_txmix2g_tune_boost_pu_core0;
+	u8 radio_pad2g_tune_pus_core0;
+	u8 radio_pga_boost_tune_core0;
+	u8 radio_txmix5g_boost_tune_core0;
+	u8 radio_pad5g_tune_misc_pus_core0;
+	u8 radio_lna2g_tune_core0;
+	u8 radio_lna5g_tune_core0;
+	u8 radio_txmix2g_tune_boost_pu_core1;
+	u8 radio_pad2g_tune_pus_core1;
+	u8 radio_pga_boost_tune_core1;
+	u8 radio_txmix5g_boost_tune_core1;
+	u8 radio_pad5g_tune_misc_pus_core1;
+	u8 radio_lna2g_tune_core1;
+	u8 radio_lna5g_tune_core1;
+	/* PHY res values on channelswitch */
+	struct b43_phy_n_sfo_cfg phy_regs;
+};
+
+struct b43_nphy_chantabent_rev7_2g {
+	/* The channel frequency in MHz */
+	u16 freq;
+	/* Radio regs values on channelswitch */
+	u8 radio_vcocal_countval0;
+	u8 radio_vcocal_countval1;
+	u8 radio_rfpll_refmaster_sparextalsize;
+	u8 radio_rfpll_loopfilter_r1;
+	u8 radio_rfpll_loopfilter_c2;
+	u8 radio_rfpll_loopfilter_c1;
+	u8 radio_cp_kpd_idac;
+	u8 radio_rfpll_mmd0;
+	u8 radio_rfpll_mmd1;
+	u8 radio_vcobuf_tune;
+	u8 radio_logen_mx2g_tune;
+	u8 radio_logen_indbuf2g_tune;
+	u8 radio_txmix2g_tune_boost_pu_core0;
+	u8 radio_pad2g_tune_pus_core0;
+	u8 radio_lna2g_tune_core0;
+	u8 radio_txmix2g_tune_boost_pu_core1;
+	u8 radio_pad2g_tune_pus_core1;
+	u8 radio_lna2g_tune_core1;
+	/* PHY regs values on channelswitch */
+	struct b43_phy_n_sfo_cfg phy_regs;
+};
+
 void r2057_upload_inittabs(struct b43_wldev *dev);
 
+void r2057_get_chantabent_rev7(struct b43_wldev *dev, u16 freq,
+			       const struct b43_nphy_chantabent_rev7 **tabent_r7,
+			       const struct b43_nphy_chantabent_rev7_2g **tabent_r7_2g);
+
 #endif /* B43_RADIO_2057_H_ */
-- 
1.8.4.5

