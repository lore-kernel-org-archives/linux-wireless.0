Return-Path: <SRS0=9HFQ=MT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36A3DC677F5
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 09:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D313020882
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 09:45:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D313020882
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbeJGQwT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Oct 2018 12:52:19 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45280 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbeJGQwT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Oct 2018 12:52:19 -0400
Received: by mail-wr1-f65.google.com with SMTP id q5-v6so17609418wrw.12
        for <linux-wireless@vger.kernel.org>; Sun, 07 Oct 2018 02:45:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xx8/oS/z0wfyycsuzK8KcqtOuVZG6cICFD5WMrQdLdk=;
        b=buaqeX2gGQ9RI8X/Vdn5SZ44uvVc7hpRM3Oqpxexl4ACRWrDEWdEPJa/SFdZuBAJGN
         PY+mVOqfqHedkbSnPSzLsSO3eOvFo7NVPTOVOObFwqGuxfUH931QClZzbL+zAzYjfCzL
         HShGUA/uWQ4EdjaRFRleQZcXDNuJ6YIzYkMbCAjHuIQUCcVppypBpdNzovG/eKOQf2Wx
         eAwCsQvu8mAafXpkI+LAe/NHwJYBAyS2ZhwjxlPIoYmBjb+1IY3OWjagaJTebJTsl+qA
         eh6GFcYUbaXQCf3F9WLMMx5RLMfQc8dpOez4pnzQyhKzpAbdleuddiaqirkYI7hvwVW0
         l81w==
X-Gm-Message-State: ABuFfoieugE5o1QIlgeGvtFfpy46alXS3bF9QL8z+mryO1ztZ6/Tj8VW
        n4lnY8boSMXYZOU1q7hHzPeCpw==
X-Google-Smtp-Source: ACcGV63CyYTxofP/zraHo1uZvXPLVJNFtN45wXJK6LHnZ1y+0rYhPD7Pa1AvCA25tXuFP4OzH9ul0A==
X-Received: by 2002:adf:cd0c:: with SMTP id w12-v6mr13719049wrm.67.1538905533209;
        Sun, 07 Oct 2018 02:45:33 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id q135-v6sm6149599wmd.4.2018.10.07.02.45.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Oct 2018 02:45:32 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 3/7] mt76: use mt76x02_dev instead of mt76_dev in mt76x02_util.c
Date:   Sun,  7 Oct 2018 11:45:20 +0200
Message-Id: <20181007094524.12656-4-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76x02_dev data structure as reference in mt76x02_util.c
instead of mt76_dev

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |   6 +-
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 138 +++++++++---------
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |   2 +-
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  |   2 +-
 5 files changed, 77 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index abd8313f22e7..578f1b34f0f1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -138,7 +138,7 @@ static void mt76x0_init_mac_registers(struct mt76x02_dev *dev)
 
 	RANDOM_WRITE(dev, common_mac_reg_table);
 
-	mt76x02_set_beacon_offsets(&dev->mt76);
+	mt76x02_set_beacon_offsets(dev);
 
 	/* Enable PBF and MAC clock SYS_CTRL[11:10] = 0x3 */
 	RANDOM_WRITE(dev, mt76x0_mac_reg_table);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 65174817ebc4..724c46b137e8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -119,8 +119,8 @@ int mt76x02_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		      struct ieee80211_sta *sta);
 
-void mt76x02_vif_init(struct mt76_dev *dev, struct ieee80211_vif *vif,
-		     unsigned int idx);
+void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
+		      unsigned int idx);
 int mt76x02_add_interface(struct ieee80211_hw *hw,
 			 struct ieee80211_vif *vif);
 void mt76x02_remove_interface(struct ieee80211_hw *hw,
@@ -156,7 +156,7 @@ int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
 			   u32 *tx_info);
 
 extern const u16 mt76x02_beacon_offsets[16];
-void mt76x02_set_beacon_offsets(struct mt76_dev *dev);
+void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev);
 void mt76x02_set_irq_mask(struct mt76x02_dev *dev, u32 clear, u32 set);
 void mt76x02_mac_start(struct mt76x02_dev *dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 5851ab6b7e26..8263b785df5c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -48,21 +48,21 @@ struct ieee80211_rate mt76x02_rates[] = {
 EXPORT_SYMBOL_GPL(mt76x02_rates);
 
 void mt76x02_configure_filter(struct ieee80211_hw *hw,
-			     unsigned int changed_flags,
-			     unsigned int *total_flags, u64 multicast)
+			      unsigned int changed_flags,
+			      unsigned int *total_flags, u64 multicast)
 {
-	struct mt76_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 	u32 flags = 0;
 
 #define MT76_FILTER(_flag, _hw) do { \
 		flags |= *total_flags & FIF_##_flag;			\
-		dev->rxfilter &= ~(_hw);				\
-		dev->rxfilter |= !(flags & FIF_##_flag) * (_hw);	\
+		dev->mt76.rxfilter &= ~(_hw);				\
+		dev->mt76.rxfilter |= !(flags & FIF_##_flag) * (_hw);	\
 	} while (0)
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 
-	dev->rxfilter &= ~MT_RX_FILTR_CFG_OTHER_BSS;
+	dev->mt76.rxfilter &= ~MT_RX_FILTR_CFG_OTHER_BSS;
 
 	MT76_FILTER(FCSFAIL, MT_RX_FILTR_CFG_CRC_ERR);
 	MT76_FILTER(PLCPFAIL, MT_RX_FILTR_CFG_PHY_ERR);
@@ -75,25 +75,25 @@ void mt76x02_configure_filter(struct ieee80211_hw *hw,
 	MT76_FILTER(PSPOLL, MT_RX_FILTR_CFG_PSPOLL);
 
 	*total_flags = flags;
-	dev->bus->wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
+	mt76_wr(dev, MT_RX_FILTR_CFG, dev->mt76.rxfilter);
 
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 }
 EXPORT_SYMBOL_GPL(mt76x02_configure_filter);
 
 int mt76x02_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		   struct ieee80211_sta *sta)
+		    struct ieee80211_sta *sta)
 {
-	struct mt76_dev *dev = hw->priv;
-	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
-	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
+	struct mt76x02_dev *dev = hw->priv;
+	struct mt76x02_sta *msta = (struct mt76x02_sta *)sta->drv_priv;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
 	int ret = 0;
 	int idx = 0;
 	int i;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 
-	idx = mt76_wcid_alloc(dev->wcid_mask, ARRAY_SIZE(dev->wcid));
+	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, ARRAY_SIZE(dev->mt76.wcid));
 	if (idx < 0) {
 		ret = -ENOSPC;
 		goto out;
@@ -103,66 +103,66 @@ int mt76x02_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	msta->wcid.sta = 1;
 	msta->wcid.idx = idx;
 	msta->wcid.hw_key_idx = -1;
-	mt76x02_mac_wcid_setup(dev, idx, mvif->idx, sta->addr);
-	mt76x02_mac_wcid_set_drop(dev, idx, false);
+	mt76x02_mac_wcid_setup(&dev->mt76, idx, mvif->idx, sta->addr);
+	mt76x02_mac_wcid_set_drop(&dev->mt76, idx, false);
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
-		mt76x02_txq_init(dev, sta->txq[i]);
+		mt76x02_txq_init(&dev->mt76, sta->txq[i]);
 
 	if (vif->type == NL80211_IFTYPE_AP)
 		set_bit(MT_WCID_FLAG_CHECK_PS, &msta->wcid.flags);
 
 	ewma_signal_init(&msta->rssi);
 
-	rcu_assign_pointer(dev->wcid[idx], &msta->wcid);
+	rcu_assign_pointer(dev->mt76.wcid[idx], &msta->wcid);
 
 out:
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mt76x02_sta_add);
 
 int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		      struct ieee80211_sta *sta)
+		       struct ieee80211_sta *sta)
 {
-	struct mt76_dev *dev = hw->priv;
-	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
+	struct mt76x02_dev *dev = hw->priv;
+	struct mt76x02_sta *msta = (struct mt76x02_sta *)sta->drv_priv;
 	int idx = msta->wcid.idx;
 	int i;
 
-	mutex_lock(&dev->mutex);
-	rcu_assign_pointer(dev->wcid[idx], NULL);
+	mutex_lock(&dev->mt76.mutex);
+	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
-		mt76_txq_remove(dev, sta->txq[i]);
-	mt76x02_mac_wcid_set_drop(dev, idx, true);
-	mt76_wcid_free(dev->wcid_mask, idx);
-	mt76x02_mac_wcid_setup(dev, idx, 0, NULL);
-	mutex_unlock(&dev->mutex);
+		mt76_txq_remove(&dev->mt76, sta->txq[i]);
+	mt76x02_mac_wcid_set_drop(&dev->mt76, idx, true);
+	mt76_wcid_free(dev->mt76.wcid_mask, idx);
+	mt76x02_mac_wcid_setup(&dev->mt76, idx, 0, NULL);
+	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76x02_sta_remove);
 
-void mt76x02_vif_init(struct mt76_dev *dev, struct ieee80211_vif *vif,
-		     unsigned int idx)
+void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
+		      unsigned int idx)
 {
-	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
 
 	mvif->idx = idx;
 	mvif->group_wcid.idx = MT_VIF_WCID(idx);
 	mvif->group_wcid.hw_key_idx = -1;
-	mt76x02_txq_init(dev, vif->txq);
+	mt76x02_txq_init(&dev->mt76, vif->txq);
 }
 EXPORT_SYMBOL_GPL(mt76x02_vif_init);
 
 int
 mt76x02_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
-	struct mt76_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 	unsigned int idx = 0;
 
 	if (vif->addr[0] & BIT(1))
-		idx = 1 + (((dev->macaddr[0] ^ vif->addr[0]) >> 2) & 7);
+		idx = 1 + (((dev->mt76.macaddr[0] ^ vif->addr[0]) >> 2) & 7);
 
 	/*
 	 * Client mode typically only has one configurable BSSID register,
@@ -186,20 +186,20 @@ mt76x02_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 EXPORT_SYMBOL_GPL(mt76x02_add_interface);
 
 void mt76x02_remove_interface(struct ieee80211_hw *hw,
-			     struct ieee80211_vif *vif)
+			      struct ieee80211_vif *vif)
 {
-	struct mt76_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
-	mt76_txq_remove(dev, vif->txq);
+	mt76_txq_remove(&dev->mt76, vif->txq);
 }
 EXPORT_SYMBOL_GPL(mt76x02_remove_interface);
 
 int mt76x02_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			struct ieee80211_ampdu_params *params)
+			 struct ieee80211_ampdu_params *params)
 {
 	enum ieee80211_ampdu_mlme_action action = params->action;
 	struct ieee80211_sta *sta = params->sta;
-	struct mt76_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
 	struct ieee80211_txq *txq = sta->txq[params->tid];
 	u16 tid = params->tid;
@@ -213,12 +213,14 @@ int mt76x02_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
-		mt76_rx_aggr_start(dev, &msta->wcid, tid, *ssn, params->buf_size);
-		__mt76_set(dev, MT_WCID_ADDR(msta->wcid.idx) + 4, BIT(16 + tid));
+		mt76_rx_aggr_start(&dev->mt76, &msta->wcid, tid,
+				   *ssn, params->buf_size);
+		mt76_set(dev, MT_WCID_ADDR(msta->wcid.idx) + 4, BIT(16 + tid));
 		break;
 	case IEEE80211_AMPDU_RX_STOP:
-		mt76_rx_aggr_stop(dev, &msta->wcid, tid);
-		__mt76_clear(dev, MT_WCID_ADDR(msta->wcid.idx) + 4, BIT(16 + tid));
+		mt76_rx_aggr_stop(&dev->mt76, &msta->wcid, tid);
+		mt76_clear(dev, MT_WCID_ADDR(msta->wcid.idx) + 4,
+			   BIT(16 + tid));
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		mtxq->aggr = true;
@@ -245,11 +247,11 @@ int mt76x02_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 EXPORT_SYMBOL_GPL(mt76x02_ampdu_action);
 
 int mt76x02_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-		   struct ieee80211_vif *vif, struct ieee80211_sta *sta,
-		   struct ieee80211_key_conf *key)
+		    struct ieee80211_vif *vif, struct ieee80211_sta *sta,
+		    struct ieee80211_key_conf *key)
 {
-	struct mt76_dev *dev = hw->priv;
-	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
+	struct mt76x02_dev *dev = hw->priv;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
 	struct mt76x02_sta *msta;
 	struct mt76_wcid *wcid;
 	int idx = key->keyidx;
@@ -295,30 +297,32 @@ int mt76x02_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 		key = NULL;
 	}
-	mt76_wcid_key_setup(dev, wcid, key);
+	mt76_wcid_key_setup(&dev->mt76, wcid, key);
 
 	if (!msta) {
 		if (key || wcid->hw_key_idx == idx) {
-			ret = mt76x02_mac_wcid_set_key(dev, wcid->idx, key);
+			ret = mt76x02_mac_wcid_set_key(&dev->mt76,
+						       wcid->idx, key);
 			if (ret)
 				return ret;
 		}
 
-		return mt76x02_mac_shared_key_setup(dev, mvif->idx, idx, key);
+		return mt76x02_mac_shared_key_setup(&dev->mt76,
+						    mvif->idx, idx, key);
 	}
 
-	return mt76x02_mac_wcid_set_key(dev, msta->wcid.idx, key);
+	return mt76x02_mac_wcid_set_key(&dev->mt76, msta->wcid.idx, key);
 }
 EXPORT_SYMBOL_GPL(mt76x02_set_key);
 
 int mt76x02_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		   u16 queue, const struct ieee80211_tx_queue_params *params)
+		    u16 queue, const struct ieee80211_tx_queue_params *params)
 {
-	struct mt76_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 	u8 cw_min = 5, cw_max = 10, qid;
 	u32 val;
 
-	qid = dev->q_tx[queue].hw_idx;
+	qid = dev->mt76.q_tx[queue].hw_idx;
 
 	if (params->cw_min)
 		cw_min = fls(params->cw_min);
@@ -329,27 +333,27 @@ int mt76x02_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	      FIELD_PREP(MT_EDCA_CFG_AIFSN, params->aifs) |
 	      FIELD_PREP(MT_EDCA_CFG_CWMIN, cw_min) |
 	      FIELD_PREP(MT_EDCA_CFG_CWMAX, cw_max);
-	__mt76_wr(dev, MT_EDCA_CFG_AC(qid), val);
+	mt76_wr(dev, MT_EDCA_CFG_AC(qid), val);
 
-	val = __mt76_rr(dev, MT_WMM_TXOP(qid));
+	val = mt76_rr(dev, MT_WMM_TXOP(qid));
 	val &= ~(MT_WMM_TXOP_MASK << MT_WMM_TXOP_SHIFT(qid));
 	val |= params->txop << MT_WMM_TXOP_SHIFT(qid);
-	__mt76_wr(dev, MT_WMM_TXOP(qid), val);
+	mt76_wr(dev, MT_WMM_TXOP(qid), val);
 
-	val = __mt76_rr(dev, MT_WMM_AIFSN);
+	val = mt76_rr(dev, MT_WMM_AIFSN);
 	val &= ~(MT_WMM_AIFSN_MASK << MT_WMM_AIFSN_SHIFT(qid));
 	val |= params->aifs << MT_WMM_AIFSN_SHIFT(qid);
-	__mt76_wr(dev, MT_WMM_AIFSN, val);
+	mt76_wr(dev, MT_WMM_AIFSN, val);
 
-	val = __mt76_rr(dev, MT_WMM_CWMIN);
+	val = mt76_rr(dev, MT_WMM_CWMIN);
 	val &= ~(MT_WMM_CWMIN_MASK << MT_WMM_CWMIN_SHIFT(qid));
 	val |= cw_min << MT_WMM_CWMIN_SHIFT(qid);
-	__mt76_wr(dev, MT_WMM_CWMIN, val);
+	mt76_wr(dev, MT_WMM_CWMIN, val);
 
-	val = __mt76_rr(dev, MT_WMM_CWMAX);
+	val = mt76_rr(dev, MT_WMM_CWMAX);
 	val &= ~(MT_WMM_CWMAX_MASK << MT_WMM_CWMAX_SHIFT(qid));
 	val |= cw_max << MT_WMM_CWMAX_SHIFT(qid);
-	__mt76_wr(dev, MT_WMM_CWMAX, val);
+	mt76_wr(dev, MT_WMM_CWMAX, val);
 
 	return 0;
 }
@@ -425,7 +429,7 @@ const u16 mt76x02_beacon_offsets[16] = {
 };
 EXPORT_SYMBOL_GPL(mt76x02_beacon_offsets);
 
-void mt76x02_set_beacon_offsets(struct mt76_dev *dev)
+void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev)
 {
 	u16 val, base = MT_BEACON_BASE;
 	u32 regs[4] = {};
@@ -437,7 +441,7 @@ void mt76x02_set_beacon_offsets(struct mt76_dev *dev)
 	}
 
 	for (i = 0; i < 4; i++)
-		__mt76_wr(dev, MT_BCN_OFFSET(i), regs[i]);
+		mt76_wr(dev, MT_BCN_OFFSET(i), regs[i]);
 }
 EXPORT_SYMBOL_GPL(mt76x02_set_beacon_offsets);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 620a8c93c222..d98d1286f7c1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -168,7 +168,7 @@ static int mt76x2_mac_reset(struct mt76x02_dev *dev, bool hard)
 		MT_CH_TIME_CFG_EIFS_AS_BUSY |
 		FIELD_PREP(MT_CH_TIME_CFG_CH_TIMER_CLR, 1));
 
-	mt76x02_set_beacon_offsets(&dev->mt76);
+	mt76x02_set_beacon_offsets(dev);
 
 	mt76x2_set_tx_ackto(dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 224609d6915f..87941ed3fb7c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -52,7 +52,7 @@ static int mt76x2u_add_interface(struct ieee80211_hw *hw,
 	if (!ether_addr_equal(dev->mt76.macaddr, vif->addr))
 		mt76x02_mac_setaddr(&dev->mt76, vif->addr);
 
-	mt76x02_vif_init(&dev->mt76, vif, 0);
+	mt76x02_vif_init(dev, vif, 0);
 	return 0;
 }
 
-- 
2.19.0

