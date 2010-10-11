Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50007 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915Ab0JKPVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 11:21:18 -0400
Received: by mail-fx0-f46.google.com with SMTP id 4so482439fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Oct 2010 08:21:17 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/3] b43: N-PHY: add 2055 radio regs
Date: Mon, 11 Oct 2010 17:20:35 +0200
Message-Id: <1286810435-10820-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1286810435-10820-1-git-send-email-zajec5@gmail.com>
References: <1286810435-10820-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
I'm not too happy with presented numbering but:
1) We can not just use regiser number, because we use same registers few times
2) Using just order numbering (00 - 36) would make registers writing less clean

This way I decided to use both: order numbering and register numbering.
---
 drivers/net/wireless/b43/tables_nphy.c |   42 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/tables_nphy.h |   40 ++++++++++++++++++++++++++++--
 2 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index e74b8eb..0cedb9a 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -317,6 +317,48 @@ void b2055_upload_inittab(struct b43_wldev *dev,
 	.radio_c2_tx_pgapadtn	= r20,	\
 	.radio_c2_tx_mxbgtrim	= r21
 
+#define RADIOREGS3(r00, r01, r02, r03, r04, r05, r06, r07, r08, r09, \
+		   r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, \
+		   r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, \
+		   r30, r31, r32, r33, r34, r35, r36) \
+	.radio_reg_00_56	= r00,	\
+	.radio_reg_01_56	= r01,	\
+	.radio_reg_02_46	= r02,	\
+	.radio_reg_03_51	= r03,	\
+	.radio_reg_04_50	= r04,	\
+	.radio_reg_05_4b	= r05,	\
+	.radio_reg_06_4c	= r06,	\
+	.radio_reg_07_4d	= r07,	\
+	.radio_reg_08_4e	= r08,	\
+	.radio_reg_09_4f	= r09,	\
+	.radio_reg_10_1b	= r10,	\
+	.radio_reg_11_1c	= r11,	\
+	.radio_reg_12_1d	= r12,	\
+	.radio_reg_13_70	= r13,	\
+	.radio_reg_14_72	= r14,	\
+	.radio_reg_15_75	= r15,	\
+	.radio_reg_16_76	= r16,	\
+	.radio_reg_17_2d	= r17,	\
+	.radio_reg_18_34	= r18,	\
+	.radio_reg_19_37	= r19,	\
+	.radio_reg_20_41	= r20,	\
+	.radio_reg_21_4d	= r21,	\
+	.radio_reg_22_53	= r22,	\
+	.radio_reg_23_58	= r23,	\
+	.radio_reg_24_5e	= r24,	\
+	.radio_reg_25_62	= r25,	\
+	.radio_reg_26_64	= r26,	\
+	.radio_reg_27_2d	= r27,	\
+	.radio_reg_28_34	= r28,	\
+	.radio_reg_29_37	= r29,	\
+	.radio_reg_30_41	= r30,	\
+	.radio_reg_31_4d	= r31,	\
+	.radio_reg_32_53	= r32,	\
+	.radio_reg_33_58	= r33,	\
+	.radio_reg_34_5e	= r34,	\
+	.radio_reg_35_62	= r35,	\
+	.radio_reg_36_64	= r36
+
 #define PHYREGS(r0, r1, r2, r3, r4, r5)	\
 	.phy_regs.phy_bw1a	= r0,	\
 	.phy_regs.phy_bw2	= r1,	\
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index 3eedb86..07b2c22 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -48,12 +48,46 @@ struct b43_nphy_channeltab_entry_rev2 {
 };
 
 struct b43_nphy_channeltab_entry_rev3 {
-	/* The channel number */
-	u8 channel;
 	/* The channel frequency in MHz */
 	u16 freq;
 	/* Radio register values on channelswitch */
-	/* TODO */
+	u8 radio_reg_00_56;
+	u8 radio_reg_01_56;
+	u8 radio_reg_02_46;
+	u8 radio_reg_03_51;
+	u8 radio_reg_04_50;
+	u8 radio_reg_05_4b;
+	u8 radio_reg_06_4c;
+	u8 radio_reg_07_4d;
+	u8 radio_reg_08_4e;
+	u8 radio_reg_09_4f;
+	u8 radio_reg_10_1b;
+	u8 radio_reg_11_1c;
+	u8 radio_reg_12_1d;
+	u8 radio_reg_13_70;
+	u8 radio_reg_14_72;
+	u8 radio_reg_15_75;
+	u8 radio_reg_16_76;
+	u8 radio_reg_17_2d;
+	u8 radio_reg_18_34;
+	u8 radio_reg_19_37;
+	u8 radio_reg_20_41;
+	u8 radio_reg_21_4d;
+	u8 radio_reg_22_53;
+	u8 radio_reg_23_58;
+	u8 radio_reg_24_5e;
+	u8 radio_reg_25_62;
+	u8 radio_reg_26_64;
+	u8 radio_reg_27_2d;
+	u8 radio_reg_28_34;
+	u8 radio_reg_29_37;
+	u8 radio_reg_30_41;
+	u8 radio_reg_31_4d;
+	u8 radio_reg_32_53;
+	u8 radio_reg_33_58;
+	u8 radio_reg_34_5e;
+	u8 radio_reg_35_62;
+	u8 radio_reg_36_64;
 	/* PHY register values on channelswitch */
 	struct b43_phy_n_sfo_cfg phy_regs;
 };
-- 
1.7.1

