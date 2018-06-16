Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:37337 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756879AbeFPP4e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Jun 2018 11:56:34 -0400
Received: by mail-wm0-f68.google.com with SMTP id r125-v6so8513568wmg.2
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jun 2018 08:56:33 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] mt76: introduce mt76_{incr,decr} utility routines
Date: Sat, 16 Jun 2018 17:56:18 +0200
Message-Id: <20180616155621.30539-2-lorenzo.bianconi@redhat.com> (sfid-20180616_175637_294703_202FD4C3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add mt76_{incr,decr} utility routines to increment/decrement a value
with wrap-around (they will be used by mt76x2 DFS sw detector)

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index d2166fbf50ff..96e9798bb8a0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -390,6 +390,18 @@ struct dentry *mt76_register_debugfs(struct mt76_dev *dev);
 int mt76_eeprom_init(struct mt76_dev *dev, int len);
 void mt76_eeprom_override(struct mt76_dev *dev);
 
+/* increment with wrap-around */
+static inline int mt76_incr(int val, int size)
+{
+	return (val + 1) & (size - 1);
+}
+
+/* decrement with wrap-around */
+static inline int mt76_decr(int val, int size)
+{
+	return (val - 1) & (size - 1);
+}
+
 static inline struct ieee80211_txq *
 mtxq_to_txq(struct mt76_txq *mtxq)
 {
-- 
2.17.1
