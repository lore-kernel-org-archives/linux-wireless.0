Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B57395266
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 14:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785596027; cv=none; b=uyHo87Fob5CJaU+xlhbhKkjPEE+dl8n0rxQtaLeaKA9BUxRSWo3Rz4mtyz0iZjrRSmHCxET/0GlLg4tuk8Xy19GqijJdV7z2TcAjQ+wZlZh9rxl+eOHBaxHoS8JFHa3gQGB6HaqDbV8i2ypSIiJ1lBKG/J5uvon7DfqGxRczcR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785596027; c=relaxed/simple;
	bh=700/B1eS0PnlTNaX/cxGbwLDd5mh8XbQDqYaMjds4cY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=oo2BsSh513PRZuFxCVWDizpRBw6ECRPlzSiUFNxxZA6K0FTLE0qVNon31YTEJwqA7Mt48bIBaFEnSQGfULaXCE+misxS7klclxWzgWV5kPBQHq5G3xsvuugV8+y3OR3+Y1keAJAshWNUi4s/n7qegx0inENg4O6HWqNv11nqklE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=Xa7e67FS; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Xa7e67FS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=L2z/MCF3poQvQEoxZPmcqBNXTtKtXDB7y0TPx5ENIqU=; b=Xa7e67FSz5rzUAaKJb6bzHUCJ8
	3K+wbzQ9Lq1GM/2gfGPorOcINXtZBeANL42e6bXM8eIIPlUbQHUL5rXc9gFkVmbsl3e5DbntM2dUI
	3rqQHUqSd2SUbZDGGlwW3dM+7pkweUtwQ2YTOdjtoSslmBRHlaDPNhlWiwhMcP0crZFo=;
Received: from p200300cadf14d100000000000000085c.dip0.t-ipconnect.de ([2003:ca:df14:d100::85c] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wqB5l-009znC-10
	for linux-wireless@vger.kernel.org;
	Sat, 01 Aug 2026 16:53:37 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 01/10] wifi: mt76: add PS buffering support for HW-managed TIM drivers
Date: Sat,  1 Aug 2026 14:53:25 +0000
Message-ID: <20260801145334.1166751-1-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add MT_DRV_HW_PS_BUFFERING flag for drivers where firmware controls
the TIM bit based on buffered frames. Instead of blocking all TX to
PS stations (which starves firmware and prevents TIM from being set),
allow limited frame delivery using AQL pending airtime as the
throttle. Replenish the firmware buffer on TX completion.

Add mt76_sta_ps_transition() helper for drivers to call from MCU
PS sync events.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     |  3 +
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |  1 +
 drivers/net/wireless/mediatek/mt76/tx.c       | 77 +++++++++++++++++--
 3 files changed, 75 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 640061276d76..dc160d9ae537 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -539,6 +539,7 @@ struct mt76_hw_cap {
 #define MT_DRV_HW_MGMT_TXQ		BIT(4)
 #define MT_DRV_AMSDU_OFFLOAD		BIT(5)
 #define MT_DRV_IGNORE_TXS_FAILED	BIT(6)
+#define MT_DRV_HW_PS_BUFFERING		BIT(7)
 
 struct mt76_driver_ops {
 	u32 drv_flags;
@@ -1541,6 +1542,8 @@ void mt76_release_buffered_frames(struct ieee80211_hw *hw,
 				  u16 tids, int nframes,
 				  enum ieee80211_frame_release_type reason,
 				  bool more_data);
+void mt76_sta_ps_transition(struct mt76_dev *dev, struct mt76_wcid *wcid,
+			    bool ps);
 bool mt76_has_tx_pending(struct mt76_phy *phy);
 int mt76_update_channel(struct mt76_phy *phy);
 void mt76_update_survey(struct mt76_phy *phy);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 51380849d24e..0ededa569e9a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1094,6 +1094,7 @@ enum {
 	MCU_UNI_EVENT_IE_COUNTDOWN = 0x09,
 	MCU_UNI_EVENT_COREDUMP = 0x0a,
 	MCU_UNI_EVENT_BSS_BEACON_LOSS = 0x0c,
+	MCU_UNI_EVENT_PS_SYNC = 0x0d,
 	MCU_UNI_EVENT_SCAN_DONE = 0x0e,
 	MCU_UNI_EVENT_RDD_REPORT = 0x11,
 	MCU_UNI_EVENT_ROC = 0x27,
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index b03be0eb4712..12c615b1294b 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -267,6 +267,21 @@ void __mt76_tx_complete_skb(struct mt76_dev *dev, u16 wcid_idx, struct sk_buff *
 	wcid = __mt76_wcid_ptr(dev, wcid_idx);
 	mt76_tx_check_non_aql(dev, wcid, skb);
 
+	if (wcid && (dev->drv->drv_flags & MT_DRV_HW_PS_BUFFERING) &&
+	    test_bit(MT_WCID_FLAG_PS, &wcid->flags)) {
+		struct ieee80211_sta *sta = wcid_to_sta(wcid);
+
+		if (sta) {
+			struct ieee80211_hw *hw = mt76_phy_hw(dev, wcid->phy_idx);
+			int i;
+
+			for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
+				if (sta->txq[i])
+					ieee80211_schedule_txq(hw, sta->txq[i]);
+			mt76_worker_schedule(&dev->tx_worker);
+		}
+	}
+
 #ifdef CONFIG_NL80211_TESTMODE
 	if (mt76_is_testmode_skb(dev, skb, &hw)) {
 		struct mt76_phy *phy = hw->priv;
@@ -476,8 +491,12 @@ mt76_txq_send_burst(struct mt76_phy *phy, struct mt76_queue *q,
 	bool stop = false;
 	int idx;
 
-	if (test_bit(MT_WCID_FLAG_PS, &wcid->flags))
-		return 0;
+	if (test_bit(MT_WCID_FLAG_PS, &wcid->flags)) {
+		if (!(dev->drv->drv_flags & MT_DRV_HW_PS_BUFFERING))
+			return 0;
+		if (ieee80211_txq_aql_pending(phy->hw, txq))
+			return 0;
+	}
 
 	if (atomic_read(&wcid->non_aql_packets) >= MT_MAX_NON_AQL_PKT)
 		return 0;
@@ -497,6 +516,9 @@ mt76_txq_send_burst(struct mt76_phy *phy, struct mt76_queue *q,
 	if (idx < 0)
 		return idx;
 
+	if (test_bit(MT_WCID_FLAG_PS, &wcid->flags))
+		goto out;
+
 	do {
 		if (test_bit(MT76_RESET, &phy->state) || phy->offchannel)
 			break;
@@ -522,6 +544,7 @@ mt76_txq_send_burst(struct mt76_phy *phy, struct mt76_queue *q,
 		n_frames++;
 	} while (1);
 
+out:
 	spin_lock(&q->lock);
 	dev->queue_ops->kick(dev, q);
 	spin_unlock(&q->lock);
@@ -548,10 +571,7 @@ mt76_txq_schedule_list(struct mt76_phy *phy, enum mt76_txq_id qid)
 
 		mtxq = (struct mt76_txq *)txq->drv_priv;
 		wcid = __mt76_wcid_ptr(dev, mtxq->wcid);
-		if (!wcid || test_bit(MT_WCID_FLAG_PS, &wcid->flags))
-			continue;
-
-		if (atomic_read(&wcid->non_aql_packets) >= MT_MAX_NON_AQL_PKT)
+		if (!wcid)
 			continue;
 
 		phy = mt76_dev_phy(dev, wcid->phy_idx);
@@ -559,6 +579,24 @@ mt76_txq_schedule_list(struct mt76_phy *phy, enum mt76_txq_id qid)
 			continue;
 
 		q = phy->q_tx[qid];
+
+		if (test_bit(MT_WCID_FLAG_PS, &wcid->flags)) {
+			if (!(dev->drv->drv_flags & MT_DRV_HW_PS_BUFFERING))
+				continue;
+
+			if (!mt76_txq_stopped(q))
+				n_frames = mt76_txq_send_burst(phy, q, mtxq, wcid);
+
+			ieee80211_return_txq(phy->hw, txq, false);
+
+			if (unlikely(n_frames < 0))
+				return n_frames;
+			ret += n_frames;
+			continue;
+		}
+
+		if (atomic_read(&wcid->non_aql_packets) >= MT_MAX_NON_AQL_PKT)
+			continue;
 		if (dev->queue_ops->tx_cleanup &&
 		    q->queued + 2 * MT_TXQ_FREE_THR >= q->ndesc) {
 			dev->queue_ops->tx_cleanup(dev, q, false);
@@ -765,6 +803,33 @@ void mt76_stop_tx_queues(struct mt76_phy *phy, struct ieee80211_sta *sta,
 }
 EXPORT_SYMBOL_GPL(mt76_stop_tx_queues);
 
+void mt76_sta_ps_transition(struct mt76_dev *dev, struct mt76_wcid *wcid,
+			    bool ps)
+{
+	struct ieee80211_sta *sta;
+	struct ieee80211_hw *hw;
+	int i;
+
+	if (ps) {
+		set_bit(MT_WCID_FLAG_PS, &wcid->flags);
+		mt76_worker_schedule(&dev->tx_worker);
+		return;
+	}
+
+	clear_bit(MT_WCID_FLAG_PS, &wcid->flags);
+
+	sta = wcid_to_sta(wcid);
+	if (!sta)
+		return;
+
+	hw = mt76_phy_hw(dev, wcid->phy_idx);
+	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
+		if (sta->txq[i])
+			ieee80211_schedule_txq(hw, sta->txq[i]);
+	mt76_worker_schedule(&dev->tx_worker);
+}
+EXPORT_SYMBOL_GPL(mt76_sta_ps_transition);
+
 void mt76_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
 {
 	struct mt76_phy *phy = hw->priv;
-- 
2.53.0

