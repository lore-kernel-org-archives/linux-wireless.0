Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39667 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbeHYOTi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Aug 2018 10:19:38 -0400
Received: by mail-wr1-f65.google.com with SMTP id o37-v6so9448039wrf.6
        for <linux-wireless@vger.kernel.org>; Sat, 25 Aug 2018 03:41:03 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 01/16] mt76: move mt76_reg_pair definition in mt76.h
Date: Sat, 25 Aug 2018 12:40:41 +0200
Message-Id: <20180825104056.9130-2-lorenzo.bianconi@redhat.com> (sfid-20180825_124111_037388_00F153A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move common definition of mt76_reg_pair in mt76.h
and remove duplicated code in mt76x2_init_common.c

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h             |  5 +++++
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h    |  5 -----
 .../net/wireless/mediatek/mt76/mt76x2_init_common.c   | 11 +++--------
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index b02b4191ef37..fc27260080af 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -53,6 +53,11 @@ enum mt76_txq_id {
 	__MT_TXQ_MAX
 };
 
+struct mt76_reg_pair {
+	u32 reg;
+	u32 value;
+};
+
 enum mt76_rxq_id {
 	MT_RXQ_MAIN,
 	MT_RXQ_MCU,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 12f3dd1cc405..a694cc46fac8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -219,11 +219,6 @@ struct mt76x0_wcid {
 	u8 tx_rate_nss;
 };
 
-struct mt76_reg_pair {
-	u32 reg;
-	u32 value;
-};
-
 struct mt76x0_rxwi;
 
 extern const struct ieee80211_ops mt76x0_ops;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
index 953effec8c1a..6af26350c177 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
@@ -47,11 +47,6 @@ struct ieee80211_rate mt76x2_rates[] = {
 };
 EXPORT_SYMBOL_GPL(mt76x2_rates);
 
-struct mt76x2_reg_pair {
-	u32 reg;
-	u32 value;
-};
-
 static void
 mt76x2_set_wlan_state(struct mt76x2_dev *dev, bool enable)
 {
@@ -93,7 +88,7 @@ EXPORT_SYMBOL_GPL(mt76x2_reset_wlan);
 
 static void
 mt76x2_write_reg_pairs(struct mt76x2_dev *dev,
-		       const struct mt76x2_reg_pair *data, int len)
+		       const struct mt76_reg_pair *data, int len)
 {
 	while (len > 0) {
 		mt76_wr(dev, data->reg, data->value);
@@ -128,7 +123,7 @@ void mt76_write_mac_initvals(struct mt76x2_dev *dev)
 	 FIELD_PREP(MT_PROT_CFG_NAV, 1) |			\
 	 FIELD_PREP(MT_PROT_CFG_TXOP_ALLOW, 0x3f))
 
-	static const struct mt76x2_reg_pair vals[] = {
+	static const struct mt76_reg_pair vals[] = {
 		/* Copied from MediaTek reference source */
 		{ MT_PBF_SYS_CTRL,		0x00080c00 },
 		{ MT_PBF_CFG,			0x1efebcff },
@@ -184,7 +179,7 @@ void mt76_write_mac_initvals(struct mt76x2_dev *dev)
 		{ MT_PROT_AUTO_TX_CFG,		0x00830083 },
 		{ MT_HT_CTRL_CFG,		0x000001ff },
 	};
-	struct mt76x2_reg_pair prot_vals[] = {
+	struct mt76_reg_pair prot_vals[] = {
 		{ MT_CCK_PROT_CFG,		DEFAULT_PROT_CFG_CCK },
 		{ MT_OFDM_PROT_CFG,		DEFAULT_PROT_CFG_OFDM },
 		{ MT_MM20_PROT_CFG,		DEFAULT_PROT_CFG_20 },
-- 
2.18.0
