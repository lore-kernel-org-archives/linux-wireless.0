Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB67FC43381
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 14:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7497A2084F
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 14:20:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Y32XyOyq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388345AbfCAOU2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:20:28 -0500
Received: from nbd.name ([46.4.11.11]:50346 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388322AbfCAOU1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 09:20:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9A5JfXsL3lRy432E2FYQ8x4VYUtaDFxKyw3ne67/ywo=; b=Y32XyOyqGTvXyRnrqsOYyebjr1
        7EOLc4ksDxaq1oT5OpDs8e+cFd8ZPRjM93kCEc9MjuNqchvBD/2iTDFnzu86In9cwRHaFxFwQgkQL
        0MoUNhEK+67GeoADxeJOpsetP1NLCrdvzriX/JpsrpgBv/+uKrJWQ2RpVNe4CNq7Ti30=;
Received: by maeck.lan (Postfix, from userid 501)
        id 0D95050B002A; Fri,  1 Mar 2019 15:20:23 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] mt76: mt76x2: implement full device restart on watchdog reset
Date:   Fri,  1 Mar 2019 15:20:23 +0100
Message-Id: <20190301142023.18179-3-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190301142023.18179-1-nbd@nbd.name>
References: <20190301142023.18179-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Restart the firmware and re-initialize the MAC to be able to recover
from more kinds of hang states

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     |  1 +
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 26 ++++++
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  2 +
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 81 +++++++++++++++++--
 .../net/wireless/mediatek/mt76/mt76x02_util.c |  4 +
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  1 +
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_mcu.c   | 21 +++++
 drivers/net/wireless/mediatek/mt76/tx.c       |  3 +
 9 files changed, 132 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 1dcbddec6621..477027bb9aaf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -144,6 +144,7 @@ struct mt76_mcu_ops {
 			 const struct mt76_reg_pair *rp, int len);
 	int (*mcu_rd_rp)(struct mt76_dev *dev, u32 base,
 			 struct mt76_reg_pair *rp, int len);
+	int (*mcu_restart)(struct mt76_dev *dev);
 };
 
 struct mt76_queue_ops {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 8109bac5aee6..e1e0c8da5a8c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -67,6 +67,32 @@ int mt76x02_mac_shared_key_setup(struct mt76x02_dev *dev, u8 vif_idx,
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_shared_key_setup);
 
+void mt76x02_mac_wcid_sync_pn(struct mt76x02_dev *dev, u8 idx,
+			      struct ieee80211_key_conf *key)
+{
+	enum mt76x02_cipher_type cipher;
+	u8 key_data[32];
+	u32 iv, eiv;
+	u64 pn;
+
+	cipher = mt76x02_mac_get_key_info(key, key_data);
+	iv = mt76_rr(dev, MT_WCID_IV(idx));
+	eiv = mt76_rr(dev, MT_WCID_IV(idx) + 4);
+
+	pn = (u64)eiv << 16;
+	if (cipher == MT_CIPHER_TKIP) {
+		pn |= (iv >> 16) & 0xff;
+		pn |= (iv & 0xff) << 8;
+	} else if (cipher >= MT_CIPHER_AES_CCMP) {
+		pn |= iv & 0xffff;
+	} else {
+		return;
+	}
+
+	atomic64_set(&key->tx_pn, pn);
+}
+
+
 int mt76x02_mac_wcid_set_key(struct mt76x02_dev *dev, u8 idx,
 			     struct ieee80211_key_conf *key)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 6b1f25d2f64c..caeeef96c42f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -177,6 +177,8 @@ int mt76x02_mac_shared_key_setup(struct mt76x02_dev *dev, u8 vif_idx,
 				 u8 key_idx, struct ieee80211_key_conf *key);
 int mt76x02_mac_wcid_set_key(struct mt76x02_dev *dev, u8 idx,
 			     struct ieee80211_key_conf *key);
+void mt76x02_mac_wcid_sync_pn(struct mt76x02_dev *dev, u8 idx,
+			      struct ieee80211_key_conf *key);
 void mt76x02_mac_wcid_setup(struct mt76x02_dev *dev, u8 idx, u8 vif_idx,
 			    u8 *mac);
 void mt76x02_mac_wcid_set_drop(struct mt76x02_dev *dev, u8 idx, bool drop);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 1a7926de1dec..6a34a6afcfe4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -19,6 +19,7 @@
 #include <linux/irq.h>
 
 #include "mt76x02.h"
+#include "mt76x02_mcu.h"
 #include "mt76x02_trace.h"
 
 struct beacon_bc_data {
@@ -400,9 +401,65 @@ static bool mt76x02_tx_hang(struct mt76x02_dev *dev)
 	return i < 4;
 }
 
+static void mt76x02_key_sync(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			     struct ieee80211_sta *sta,
+			     struct ieee80211_key_conf *key, void *data)
+{
+	struct mt76x02_dev *dev = hw->priv;
+	struct mt76_wcid *wcid;
+
+	if (!sta)
+	    return;
+
+	wcid = (struct mt76_wcid *) sta->drv_priv;
+
+	if (wcid->hw_key_idx != key->keyidx || wcid->sw_iv)
+	    return;
+
+	mt76x02_mac_wcid_sync_pn(dev, wcid->idx, key);
+}
+
+static void mt76x02_reset_state(struct mt76x02_dev *dev)
+{
+	int i;
+
+	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
+
+	rcu_read_lock();
+
+	ieee80211_iter_keys_rcu(dev->mt76.hw, NULL, mt76x02_key_sync, NULL);
+
+	for (i = 0; i < ARRAY_SIZE(dev->mt76.wcid); i++) {
+		struct mt76_wcid *wcid = rcu_dereference(dev->mt76.wcid[i]);
+		struct mt76x02_sta *msta;
+		struct ieee80211_sta *sta;
+		struct ieee80211_vif *vif;
+		void *priv;
+
+		if (!wcid)
+			continue;
+
+		priv = msta = container_of(wcid, struct mt76x02_sta, wcid);
+		sta = container_of(priv, struct ieee80211_sta, drv_priv);
+
+		priv = msta->vif;
+		vif = container_of(priv, struct ieee80211_vif, drv_priv);
+
+		mt76_sta_state(dev->mt76.hw, vif, sta,
+			       IEEE80211_STA_NONE, IEEE80211_STA_NOTEXIST);
+		memset(msta, 0, sizeof(*msta));
+	}
+
+	rcu_read_unlock();
+
+	dev->vif_mask = 0;
+	dev->beacon_mask = 0;
+}
+
 static void mt76x02_watchdog_reset(struct mt76x02_dev *dev)
 {
 	u32 mask = dev->mt76.mmio.irqmask;
+	bool restart = dev->mt76.mcu_ops->mcu_restart;
 	int i;
 
 	ieee80211_stop_queues(dev->mt76.hw);
@@ -414,6 +471,9 @@ static void mt76x02_watchdog_reset(struct mt76x02_dev *dev)
 	for (i = 0; i < ARRAY_SIZE(dev->mt76.napi); i++)
 		napi_disable(&dev->mt76.napi[i]);
 
+	if (restart)
+		mt76x02_reset_state(dev);
+
 	mutex_lock(&dev->mt76.mutex);
 
 	if (dev->beacon_mask)
@@ -434,20 +494,21 @@ static void mt76x02_watchdog_reset(struct mt76x02_dev *dev)
 	/* let fw reset DMA */
 	mt76_set(dev, 0x734, 0x3);
 
+	if (restart)
+		dev->mt76.mcu_ops->mcu_restart(&dev->mt76);
+
 	for (i = 0; i < ARRAY_SIZE(dev->mt76.q_tx); i++)
 		mt76_queue_tx_cleanup(dev, i, true);
 
 	for (i = 0; i < ARRAY_SIZE(dev->mt76.q_rx); i++)
 		mt76_queue_rx_reset(dev, i);
 
-	mt76_wr(dev, MT_MAC_SYS_CTRL,
-		MT_MAC_SYS_CTRL_ENABLE_TX | MT_MAC_SYS_CTRL_ENABLE_RX);
-	mt76_set(dev, MT_WPDMA_GLO_CFG,
-		 MT_WPDMA_GLO_CFG_TX_DMA_EN | MT_WPDMA_GLO_CFG_RX_DMA_EN);
+	mt76x02_mac_start(dev);
+
 	if (dev->ed_monitor)
 		mt76_set(dev, MT_TXOP_CTRL_CFG, MT_TXOP_ED_CCA_EN);
 
-	if (dev->beacon_mask)
+	if (dev->beacon_mask && !restart)
 		mt76_set(dev, MT_BEACON_TIME_CFG,
 			 MT_BEACON_TIME_CFG_BEACON_TX |
 			 MT_BEACON_TIME_CFG_TBTT_EN);
@@ -468,9 +529,13 @@ static void mt76x02_watchdog_reset(struct mt76x02_dev *dev)
 		napi_schedule(&dev->mt76.napi[i]);
 	}
 
-	ieee80211_wake_queues(dev->mt76.hw);
-
-	mt76_txq_schedule_all(&dev->mt76);
+	if (restart) {
+		mt76x02_mcu_function_select(dev, Q_SELECT, 1);
+		ieee80211_restart_hw(dev->mt76.hw);
+	} else {
+		ieee80211_wake_queues(dev->mt76.hw);
+		mt76_txq_schedule_all(&dev->mt76);
+	}
 }
 
 static void mt76x02_check_tx_hang(struct mt76x02_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index a48c261b0c63..28eccb3119d1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -237,6 +237,8 @@ int mt76x02_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
 	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
 	int idx = 0;
 
+	memset(msta, 0, sizeof(*msta));
+
 	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, ARRAY_SIZE(dev->mt76.wcid));
 	if (idx < 0)
 		return -ENOSPC;
@@ -274,6 +276,8 @@ mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
 	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
 	struct mt76_txq *mtxq;
 
+	memset(mvif, 0, sizeof(*mvif));
+
 	mvif->idx = idx;
 	mvif->group_wcid.idx = MT_VIF_WCID(idx);
 	mvif->group_wcid.hw_key_idx = -1;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index 6c619f1c65c9..d7abe3d73bad 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -71,6 +71,7 @@ int mt76x2_mcu_load_cr(struct mt76x02_dev *dev, u8 type, u8 temp_level,
 
 void mt76x2_cleanup(struct mt76x02_dev *dev);
 
+int mt76x2_mac_reset(struct mt76x02_dev *dev, bool hard);
 void mt76x2_reset_wlan(struct mt76x02_dev *dev, bool enable);
 void mt76x2_init_txpower(struct mt76x02_dev *dev,
 			 struct ieee80211_supported_band *sband);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 984d9c4c2e1a..d3927a13e92e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -77,7 +77,7 @@ mt76x2_fixup_xtal(struct mt76x02_dev *dev)
 	}
 }
 
-static int mt76x2_mac_reset(struct mt76x02_dev *dev, bool hard)
+int mt76x2_mac_reset(struct mt76x02_dev *dev, bool hard)
 {
 	const u8 *macaddr = dev->mt76.macaddr;
 	u32 val;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
index 03e24ae7f66c..605dc66ae83b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
@@ -165,9 +165,30 @@ mt76pci_load_firmware(struct mt76x02_dev *dev)
 	return -ENOENT;
 }
 
+static int
+mt76pci_mcu_restart(struct mt76_dev *mdev)
+{
+	struct mt76x02_dev *dev;
+	int ret;
+
+	dev = container_of(mdev, struct mt76x02_dev, mt76);
+
+	mt76x02_mcu_cleanup(dev);
+	mt76x2_mac_reset(dev, true);
+
+	ret = mt76pci_load_firmware(dev);
+	if (ret)
+		return ret;
+
+	mt76_wr(dev, MT_WPDMA_RST_IDX, ~0);
+
+	return 0;
+}
+
 int mt76x2_mcu_init(struct mt76x02_dev *dev)
 {
 	static const struct mt76_mcu_ops mt76x2_mcu_ops = {
+		.mcu_restart = mt76pci_mcu_restart,
 		.mcu_send_msg = mt76x02_mcu_msg_send,
 	};
 	int ret;
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 4d38a54014e8..fc7dffe066be 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -580,6 +580,9 @@ void mt76_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
 	struct mt76_txq *mtxq = (struct mt76_txq *) txq->drv_priv;
 	struct mt76_queue *hwq = mtxq->hwq;
 
+	if (!test_bit(MT76_STATE_RUNNING, &dev->state))
+		return;
+
 	spin_lock_bh(&hwq->lock);
 	if (list_empty(&mtxq->list))
 		list_add_tail(&mtxq->list, &hwq->swq);
-- 
2.17.0

