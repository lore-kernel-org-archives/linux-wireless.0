Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:39183 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935727AbeF2LlF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 07:41:05 -0400
Received: by mail-wr0-f195.google.com with SMTP id b8-v6so8537705wro.6
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jun 2018 04:41:05 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: [PATCH v2 1/4] mt76: introduce mt76_{incr,decr} utility routines
Date: Fri, 29 Jun 2018 13:40:52 +0200
Message-Id: <2a49ca8370e2b582941b073f00438066f7ffa212.1530260731.git.lorenzo.bianconi@redhat.com> (sfid-20180629_134110_356010_5CF0404B)
In-Reply-To: <cover.1530260731.git.lorenzo.bianconi@redhat.com>
References: <cover.1530260731.git.lorenzo.bianconi@redhat.com>
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
