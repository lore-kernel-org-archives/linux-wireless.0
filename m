Return-Path: <SRS0=EPmr=NA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8002DC67863
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4092D2150F
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:14:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4092D2150F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbeJTSXz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Oct 2018 14:23:55 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38697 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727470AbeJTSXz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Oct 2018 14:23:55 -0400
Received: by mail-wr1-f68.google.com with SMTP id d10-v6so277542wrs.5
        for <linux-wireless@vger.kernel.org>; Sat, 20 Oct 2018 03:13:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EW68ByyM/JVyFIaw/goiKQXPdN5+ftiZvtuKuch0iww=;
        b=kZgLp2ihRIGQvuLFP5Io/sV8RVawCNJebb57fhv+ZvlAfj63FLaZG25RBJ3KF9M0LG
         AsoyYoocW5KxENDn2InBbdTBzwt+3+d+XsErOF3VxuDD1yvk8f1DOgvSyz0H34nZ6Hah
         2JCi6caJE3ZkYn5PRUqDAba/KNdC5v5DUJrkNtFsPLx7Nboq9ySiZiKiOSQSHLMsYUlF
         TX1jbLPyemxgGbkIkvX/NqRVG14SztUVGYdBF9IeSFQmDYj+kuBpQJ6jgTdDl7kk6+yg
         DiNAnqbVVjTViRMkM/AXLZmtzJ82b1soKaWnBJiTinfmfzdPM6CaLcr7vPpjeyV4O3ga
         HbPw==
X-Gm-Message-State: AGRZ1gK2g/YRMfQ/t7tdAB0jZk4BsU8hKCdGnyIzyUOUEhHXKqq+lZ7i
        7O4lecfq9CK7GJetreXwwHHrFw==
X-Google-Smtp-Source: AJdET5decBy6IzQ5Q+bHAZD7oJmqXbnyl5F7ZJ6Zg3q5+vy0ChsKHvcQsJEr+cpGM0DQVqr9k+Xq7A==
X-Received: by 2002:adf:f0cf:: with SMTP id x15-v6mr4515647wro.118.1540030438745;
        Sat, 20 Oct 2018 03:13:58 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id c2-v6sm19548631wrt.77.2018.10.20.03.13.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Oct 2018 03:13:58 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/9] mt76: move mac beacon routines in mt76x02-lib module
Date:   Sat, 20 Oct 2018 12:13:25 +0200
Message-Id: <2e4c376bc8022ff23aca49d094d2f0ebc356e70f.1540029458.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1540029458.git.lorenzo.bianconi@redhat.com>
References: <cover.1540029458.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_beacon mac routines in mt76x02_mac.c in
order to be reused by mt76x0 driver adding AP support

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 123 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |   6 +
 .../net/wireless/mediatek/mt76/mt76x2/mac.h   |   5 -
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |   4 +-
 .../wireless/mediatek/mt76/mt76x2/pci_mac.c   | 118 -----------------
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  |   6 +-
 .../wireless/mediatek/mt76/mt76x2/pci_tx.c    |   2 +-
 7 files changed, 135 insertions(+), 129 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index f21bf0af8937..d9d7f3e609fc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -794,3 +794,126 @@ void mt76x02_mac_work(struct work_struct *work)
 				     MT_CALIBRATE_INTERVAL);
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_work);
+
+void mt76x02_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr)
+{
+	idx &= 7;
+	mt76_wr(dev, MT_MAC_APC_BSSID_L(idx), get_unaligned_le32(addr));
+	mt76_rmw_field(dev, MT_MAC_APC_BSSID_H(idx), MT_MAC_APC_BSSID_H_ADDR,
+		       get_unaligned_le16(addr + 4));
+}
+EXPORT_SYMBOL_GPL(mt76x02_mac_set_bssid);
+
+static int
+mt76x02_write_beacon(struct mt76x02_dev *dev, int offset, struct sk_buff *skb)
+{
+	int beacon_len = mt76x02_beacon_offsets[1] - mt76x02_beacon_offsets[0];
+	struct mt76x02_txwi txwi;
+
+	if (WARN_ON_ONCE(beacon_len < skb->len + sizeof(struct mt76x02_txwi)))
+		return -ENOSPC;
+
+	mt76x02_mac_write_txwi(dev, &txwi, skb, NULL, NULL, skb->len);
+
+	mt76_wr_copy(dev, offset, &txwi, sizeof(txwi));
+	offset += sizeof(txwi);
+
+	mt76_wr_copy(dev, offset, skb->data, skb->len);
+	return 0;
+}
+
+static int
+__mt76x02_mac_set_beacon(struct mt76x02_dev *dev, u8 bcn_idx,
+			 struct sk_buff *skb)
+{
+	int beacon_len = mt76x02_beacon_offsets[1] - mt76x02_beacon_offsets[0];
+	int beacon_addr = mt76x02_beacon_offsets[bcn_idx];
+	int ret = 0;
+	int i;
+
+	/* Prevent corrupt transmissions during update */
+	mt76_set(dev, MT_BCN_BYPASS_MASK, BIT(bcn_idx));
+
+	if (skb) {
+		ret = mt76x02_write_beacon(dev, beacon_addr, skb);
+		if (!ret)
+			dev->beacon_data_mask |= BIT(bcn_idx);
+	} else {
+		dev->beacon_data_mask &= ~BIT(bcn_idx);
+		for (i = 0; i < beacon_len; i += 4)
+			mt76_wr(dev, beacon_addr + i, 0);
+	}
+
+	mt76_wr(dev, MT_BCN_BYPASS_MASK, 0xff00 | ~dev->beacon_data_mask);
+
+	return ret;
+}
+
+int mt76x02_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
+			   struct sk_buff *skb)
+{
+	bool force_update = false;
+	int bcn_idx = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dev->beacons); i++) {
+		if (vif_idx == i) {
+			force_update = !!dev->beacons[i] ^ !!skb;
+
+			if (dev->beacons[i])
+				dev_kfree_skb(dev->beacons[i]);
+
+			dev->beacons[i] = skb;
+			__mt76x02_mac_set_beacon(dev, bcn_idx, skb);
+		} else if (force_update && dev->beacons[i]) {
+			__mt76x02_mac_set_beacon(dev, bcn_idx,
+						 dev->beacons[i]);
+		}
+
+		bcn_idx += !!dev->beacons[i];
+	}
+
+	for (i = bcn_idx; i < ARRAY_SIZE(dev->beacons); i++) {
+		if (!(dev->beacon_data_mask & BIT(i)))
+			break;
+
+		__mt76x02_mac_set_beacon(dev, i, NULL);
+	}
+
+	mt76_rmw_field(dev, MT_MAC_BSSID_DW1, MT_MAC_BSSID_DW1_MBEACON_N,
+		       bcn_idx - 1);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76x02_mac_set_beacon);
+
+void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev,
+				   u8 vif_idx, bool val)
+{
+	u8 old_mask = dev->beacon_mask;
+	bool en;
+	u32 reg;
+
+	if (val) {
+		dev->beacon_mask |= BIT(vif_idx);
+	} else {
+		dev->beacon_mask &= ~BIT(vif_idx);
+		mt76x02_mac_set_beacon(dev, vif_idx, NULL);
+	}
+
+	if (!!old_mask == !!dev->beacon_mask)
+		return;
+
+	en = dev->beacon_mask;
+
+	mt76_rmw_field(dev, MT_INT_TIMER_EN, MT_INT_TIMER_EN_PRE_TBTT_EN, en);
+	reg = MT_BEACON_TIME_CFG_BEACON_TX |
+	      MT_BEACON_TIME_CFG_TBTT_EN |
+	      MT_BEACON_TIME_CFG_TIMER_EN;
+	mt76_rmw(dev, MT_BEACON_TIME_CFG, reg, reg * en);
+
+	if (en)
+		mt76x02_irq_enable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
+	else
+		mt76x02_irq_disable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
+}
+EXPORT_SYMBOL_GPL(mt76x02_mac_set_beacon_enable);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 55b3a49ba77a..350cb0fed980 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -227,4 +227,10 @@ void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 			     struct mt76_queue_entry *e, bool flush);
 void mt76x02_update_channel(struct mt76_dev *mdev);
 void mt76x02_mac_work(struct work_struct *work);
+
+void mt76x02_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr);
+int mt76x02_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
+			   struct sk_buff *skb);
+void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev, u8 vif_idx,
+				   bool val);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
index 2dc2b9d5dc8f..4c8e20bce920 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
@@ -26,10 +26,5 @@ struct mt76x02_vif;
 int mt76x2_mac_start(struct mt76x02_dev *dev);
 void mt76x2_mac_stop(struct mt76x02_dev *dev, bool force);
 void mt76x2_mac_resume(struct mt76x02_dev *dev);
-void mt76x2_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr);
-
-int mt76x2_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
-			  struct sk_buff *skb);
-void mt76x2_mac_set_beacon_enable(struct mt76x02_dev *dev, u8 vif_idx, bool val);
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index d0dbf6936c92..5c1531ae8b93 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -153,8 +153,8 @@ static int mt76x2_mac_reset(struct mt76x02_dev *dev, bool hard)
 			mt76x02_mac_shared_key_setup(dev, i, k, NULL);
 
 	for (i = 0; i < 8; i++) {
-		mt76x2_mac_set_bssid(dev, i, null_addr);
-		mt76x2_mac_set_beacon(dev, i, NULL);
+		mt76x02_mac_set_bssid(dev, i, null_addr);
+		mt76x02_mac_set_beacon(dev, i, NULL);
 	}
 
 	for (i = 0; i < 16; i++)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
index 97128ea6bd7a..31e1f5bd9050 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
@@ -19,124 +19,6 @@
 #include "mcu.h"
 #include "eeprom.h"
 
-void mt76x2_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr)
-{
-	idx &= 7;
-	mt76_wr(dev, MT_MAC_APC_BSSID_L(idx), get_unaligned_le32(addr));
-	mt76_rmw_field(dev, MT_MAC_APC_BSSID_H(idx), MT_MAC_APC_BSSID_H_ADDR,
-		       get_unaligned_le16(addr + 4));
-}
-
-static int
-mt76_write_beacon(struct mt76x02_dev *dev, int offset, struct sk_buff *skb)
-{
-	int beacon_len = mt76x02_beacon_offsets[1] - mt76x02_beacon_offsets[0];
-	struct mt76x02_txwi txwi;
-
-	if (WARN_ON_ONCE(beacon_len < skb->len + sizeof(struct mt76x02_txwi)))
-		return -ENOSPC;
-
-	mt76x02_mac_write_txwi(dev, &txwi, skb, NULL, NULL, skb->len);
-
-	mt76_wr_copy(dev, offset, &txwi, sizeof(txwi));
-	offset += sizeof(txwi);
-
-	mt76_wr_copy(dev, offset, skb->data, skb->len);
-	return 0;
-}
-
-static int
-__mt76x2_mac_set_beacon(struct mt76x02_dev *dev, u8 bcn_idx, struct sk_buff *skb)
-{
-	int beacon_len = mt76x02_beacon_offsets[1] - mt76x02_beacon_offsets[0];
-	int beacon_addr = mt76x02_beacon_offsets[bcn_idx];
-	int ret = 0;
-	int i;
-
-	/* Prevent corrupt transmissions during update */
-	mt76_set(dev, MT_BCN_BYPASS_MASK, BIT(bcn_idx));
-
-	if (skb) {
-		ret = mt76_write_beacon(dev, beacon_addr, skb);
-		if (!ret)
-			dev->beacon_data_mask |= BIT(bcn_idx);
-	} else {
-		dev->beacon_data_mask &= ~BIT(bcn_idx);
-		for (i = 0; i < beacon_len; i += 4)
-			mt76_wr(dev, beacon_addr + i, 0);
-	}
-
-	mt76_wr(dev, MT_BCN_BYPASS_MASK, 0xff00 | ~dev->beacon_data_mask);
-
-	return ret;
-}
-
-int mt76x2_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
-			  struct sk_buff *skb)
-{
-	bool force_update = false;
-	int bcn_idx = 0;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(dev->beacons); i++) {
-		if (vif_idx == i) {
-			force_update = !!dev->beacons[i] ^ !!skb;
-
-			if (dev->beacons[i])
-				dev_kfree_skb(dev->beacons[i]);
-
-			dev->beacons[i] = skb;
-			__mt76x2_mac_set_beacon(dev, bcn_idx, skb);
-		} else if (force_update && dev->beacons[i]) {
-			__mt76x2_mac_set_beacon(dev, bcn_idx, dev->beacons[i]);
-		}
-
-		bcn_idx += !!dev->beacons[i];
-	}
-
-	for (i = bcn_idx; i < ARRAY_SIZE(dev->beacons); i++) {
-		if (!(dev->beacon_data_mask & BIT(i)))
-			break;
-
-		__mt76x2_mac_set_beacon(dev, i, NULL);
-	}
-
-	mt76_rmw_field(dev, MT_MAC_BSSID_DW1, MT_MAC_BSSID_DW1_MBEACON_N,
-		       bcn_idx - 1);
-	return 0;
-}
-
-void mt76x2_mac_set_beacon_enable(struct mt76x02_dev *dev,
-				  u8 vif_idx, bool val)
-{
-	u8 old_mask = dev->beacon_mask;
-	bool en;
-	u32 reg;
-
-	if (val) {
-		dev->beacon_mask |= BIT(vif_idx);
-	} else {
-		dev->beacon_mask &= ~BIT(vif_idx);
-		mt76x2_mac_set_beacon(dev, vif_idx, NULL);
-	}
-
-	if (!!old_mask == !!dev->beacon_mask)
-		return;
-
-	en = dev->beacon_mask;
-
-	mt76_rmw_field(dev, MT_INT_TIMER_EN, MT_INT_TIMER_EN_PRE_TBTT_EN, en);
-	reg = MT_BEACON_TIME_CFG_BEACON_TX |
-	      MT_BEACON_TIME_CFG_TBTT_EN |
-	      MT_BEACON_TIME_CFG_TIMER_EN;
-	mt76_rmw(dev, MT_BEACON_TIME_CFG, reg, reg * en);
-
-	if (en)
-		mt76x02_irq_enable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
-	else
-		mt76x02_irq_disable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
-}
-
 void mt76x2_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val)
 {
 	u32 data = 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 034a06295668..1b3b9594c2a2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -137,7 +137,7 @@ mt76x2_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mutex_lock(&dev->mt76.mutex);
 
 	if (changed & BSS_CHANGED_BSSID)
-		mt76x2_mac_set_bssid(dev, mvif->idx, info->bssid);
+		mt76x02_mac_set_bssid(dev, mvif->idx, info->bssid);
 
 	if (changed & BSS_CHANGED_BEACON_INT) {
 		mt76_rmw_field(dev, MT_BEACON_TIME_CFG,
@@ -149,8 +149,8 @@ mt76x2_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
 		tasklet_disable(&dev->pre_tbtt_tasklet);
-		mt76x2_mac_set_beacon_enable(dev, mvif->idx,
-					     info->enable_beacon);
+		mt76x02_mac_set_beacon_enable(dev, mvif->idx,
+					      info->enable_beacon);
 		tasklet_enable(&dev->pre_tbtt_tasklet);
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c
index 3a2ec86d3e88..fac38cbaa41b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c
@@ -36,7 +36,7 @@ mt76x2_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 	if (!skb)
 		return;
 
-	mt76x2_mac_set_beacon(dev, mvif->idx, skb);
+	mt76x02_mac_set_beacon(dev, mvif->idx, skb);
 }
 
 static void
-- 
2.19.1

