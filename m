Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38253 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbeGLI6u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jul 2018 04:58:50 -0400
Received: by mail-wr1-f65.google.com with SMTP id m1-v6so8106161wrg.5
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jul 2018 01:50:12 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2: fix CCK protection control frame rate
Date: Thu, 12 Jul 2018 10:50:01 +0200
Message-Id: <cd663daf364d7967b3a8d9fd7f213139c959d0c1.1531385150.git.lorenzo.bianconi@redhat.com> (sfid-20180712_105015_615015_83AB59B4)
In-Reply-To: <cover.1531385150.git.lorenzo.bianconi@redhat.com>
References: <cover.1531385150.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use 11M as tx rate for CCK protection control frames

Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 79ab93613e06..8ab9788464e8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -84,7 +84,13 @@ mt76x2_write_reg_pairs(struct mt76x2_dev *dev,
 static void
 mt76_write_mac_initvals(struct mt76x2_dev *dev)
 {
-#define DEFAULT_PROT_CFG				\
+#define DEFAULT_PROT_CFG_CCK				\
+	(FIELD_PREP(MT_PROT_CFG_RATE, 0x3) |		\
+	 FIELD_PREP(MT_PROT_CFG_NAV, 1) |		\
+	 FIELD_PREP(MT_PROT_CFG_TXOP_ALLOW, 0x3f) |	\
+	 MT_PROT_CFG_RTS_THRESH)
+
+#define DEFAULT_PROT_CFG_OFDM				\
 	(FIELD_PREP(MT_PROT_CFG_RATE, 0x2004) |		\
 	 FIELD_PREP(MT_PROT_CFG_NAV, 1) |			\
 	 FIELD_PREP(MT_PROT_CFG_TXOP_ALLOW, 0x3f) |	\
@@ -159,8 +165,8 @@ mt76_write_mac_initvals(struct mt76x2_dev *dev)
 		{ MT_HT_CTRL_CFG,		0x000001ff },
 	};
 	struct mt76x2_reg_pair prot_vals[] = {
-		{ MT_CCK_PROT_CFG,		DEFAULT_PROT_CFG },
-		{ MT_OFDM_PROT_CFG,		DEFAULT_PROT_CFG },
+		{ MT_CCK_PROT_CFG,		DEFAULT_PROT_CFG_CCK },
+		{ MT_OFDM_PROT_CFG,		DEFAULT_PROT_CFG_OFDM },
 		{ MT_MM20_PROT_CFG,		DEFAULT_PROT_CFG_20 },
 		{ MT_MM40_PROT_CFG,		DEFAULT_PROT_CFG_40 },
 		{ MT_GF20_PROT_CFG,		DEFAULT_PROT_CFG_20 },
-- 
2.17.1
