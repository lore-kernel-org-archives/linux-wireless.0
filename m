Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07984C64EBD
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADA6620684
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:07:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADA6620684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbeJDTAF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 15:00:05 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35895 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbeJDTAE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 15:00:04 -0400
Received: by mail-wr1-f65.google.com with SMTP id y16so9647713wrw.3
        for <linux-wireless@vger.kernel.org>; Thu, 04 Oct 2018 05:07:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uIZQYnMbime0877uhMAVH8CJYfLkbLUyes5DPiag+LA=;
        b=kX8p/SBNVmsRsIZW0fEdGpQIGDPwkqkXmH1R5PHKJMFVDcaWzH0UJQbvfbI3tNEreE
         gRERqRV1ZnuTtZqKbaxigoxXAHx34t0srgsGaUiSnPST6TgqRELlAs7Yld7Yf9BtrW0g
         91mPF/3Qexkox96ch8Rm6n+0kcl/ndieTfU1PKz1OHqpehxjy/N6RTvTgHDxUI1M7X5x
         bPpu14DayPf2PoqyfhztS1MOcVuaygWutYW8YkXgU2LbX3RpyJKWTe/UNRzIOcch0y0p
         ByD/2A/jkkgxoZOYglMT8R4maILtLcJwE12OPHyjs8B677wij7p6jtjTeIoDjdP9Q3M9
         SyUg==
X-Gm-Message-State: ABuFfoiw9a4fXbnY92V/W2v4u42uWMkOoTCrU5mwO98tDnEgYWkzpCfX
        lwLp1d40X9ImTZQDelvRCFLiDQ==
X-Google-Smtp-Source: ACcGV63V9+Ihe08gtyBPp3tG4/VJjzKOPRTBOzquqMoLJ/3XLoATWp0U6hr2BK9SrhmEe4ffdTyIwQ==
X-Received: by 2002:a5d:5701:: with SMTP id a1-v6mr4836238wrv.289.1538654822646;
        Thu, 04 Oct 2018 05:07:02 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id j2-v6sm4991195wrw.29.2018.10.04.05.07.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Oct 2018 05:07:02 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 5/7] mt76: use mt76x02_dev instead of mt76_dev in mt76x02_mac.c
Date:   Thu,  4 Oct 2018 14:06:48 +0200
Message-Id: <6e87c430a12e7d3a9d0cbfee7a0fe02fc9c3fadc.1538654389.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538654389.git.lorenzo.bianconi@redhat.com>
References: <cover.1538654389.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76x02_dev data structure as reference in mt76x02_mac.c
instead of mt76_dev

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |   2 +-
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 124 +++++++++---------
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  24 ++--
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c |   2 +-
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c |   7 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb.h  |   2 +-
 .../wireless/mediatek/mt76/mt76x02_usb_core.c |   3 +-
 .../net/wireless/mediatek/mt76/mt76x02_util.c |  24 ++--
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |   6 +-
 .../wireless/mediatek/mt76/mt76x2/pci_mac.c   |   2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  |   2 +-
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |   3 +-
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  |   2 +-
 14 files changed, 103 insertions(+), 103 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 5735038c0e2d..bea1af7ffa73 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -337,8 +337,7 @@ int mt76x0_eeprom_init(struct mt76x02_dev *dev)
 	dev_info(dev->mt76.dev, "EEPROM ver:%02hhx fae:%02hhx\n",
 		 version, fae);
 
-	mt76x02_mac_setaddr(&dev->mt76,
-			    dev->mt76.eeprom.data + MT_EE_MAC_ADDR);
+	mt76x02_mac_setaddr(dev, dev->mt76.eeprom.data + MT_EE_MAC_ADDR);
 	mt76x0_set_chip_cap(dev);
 	mt76x0_set_freq_offset(dev);
 	mt76x0_set_temp_offset(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 408b2516f6fa..17958be68b32 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -143,7 +143,7 @@ void mt76x02_tx_set_txpwr_auto(struct mt76x02_dev *dev, s8 txpwr);
 int mt76x02_insert_hdr_pad(struct sk_buff *skb);
 void mt76x02_remove_hdr_pad(struct sk_buff *skb, int len);
 void mt76x02_tx_complete(struct mt76_dev *dev, struct sk_buff *skb);
-bool mt76x02_tx_status_data(struct mt76_dev *dev, u8 *update);
+bool mt76x02_tx_status_data(struct mt76_dev *mdev, u8 *update);
 void mt76x02_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			  struct sk_buff *skb);
 void mt76x02_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 244245418ebb..155106de2e17 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -45,7 +45,7 @@ mt76x02_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data)
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_get_key_info);
 
-int mt76x02_mac_shared_key_setup(struct mt76_dev *dev, u8 vif_idx, u8 key_idx,
+int mt76x02_mac_shared_key_setup(struct mt76x02_dev *dev, u8 vif_idx, u8 key_idx,
 				struct ieee80211_key_conf *key)
 {
 	enum mt76x02_cipher_type cipher;
@@ -56,19 +56,19 @@ int mt76x02_mac_shared_key_setup(struct mt76_dev *dev, u8 vif_idx, u8 key_idx,
 	if (cipher == MT_CIPHER_NONE && key)
 		return -EOPNOTSUPP;
 
-	val = __mt76_rr(dev, MT_SKEY_MODE(vif_idx));
+	val = mt76_rr(dev, MT_SKEY_MODE(vif_idx));
 	val &= ~(MT_SKEY_MODE_MASK << MT_SKEY_MODE_SHIFT(vif_idx, key_idx));
 	val |= cipher << MT_SKEY_MODE_SHIFT(vif_idx, key_idx);
-	__mt76_wr(dev, MT_SKEY_MODE(vif_idx), val);
+	mt76_wr(dev, MT_SKEY_MODE(vif_idx), val);
 
-	__mt76_wr_copy(dev, MT_SKEY(vif_idx, key_idx), key_data,
-		       sizeof(key_data));
+	mt76_wr_copy(dev, MT_SKEY(vif_idx, key_idx), key_data,
+		     sizeof(key_data));
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_shared_key_setup);
 
-int mt76x02_mac_wcid_set_key(struct mt76_dev *dev, u8 idx,
+int mt76x02_mac_wcid_set_key(struct mt76x02_dev *dev, u8 idx,
 			    struct ieee80211_key_conf *key)
 {
 	enum mt76x02_cipher_type cipher;
@@ -79,25 +79,26 @@ int mt76x02_mac_wcid_set_key(struct mt76_dev *dev, u8 idx,
 	if (cipher == MT_CIPHER_NONE && key)
 		return -EOPNOTSUPP;
 
-	__mt76_wr_copy(dev, MT_WCID_KEY(idx), key_data, sizeof(key_data));
-	__mt76_rmw_field(dev, MT_WCID_ATTR(idx), MT_WCID_ATTR_PKEY_MODE, cipher);
+	mt76_wr_copy(dev, MT_WCID_KEY(idx), key_data, sizeof(key_data));
+	mt76_rmw_field(dev, MT_WCID_ATTR(idx), MT_WCID_ATTR_PKEY_MODE, cipher);
 
 	memset(iv_data, 0, sizeof(iv_data));
 	if (key) {
-		__mt76_rmw_field(dev, MT_WCID_ATTR(idx), MT_WCID_ATTR_PAIRWISE,
-				 !!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE));
+		mt76_rmw_field(dev, MT_WCID_ATTR(idx), MT_WCID_ATTR_PAIRWISE,
+			       !!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE));
 		iv_data[3] = key->keyidx << 6;
 		if (cipher >= MT_CIPHER_TKIP)
 			iv_data[3] |= 0x20;
 	}
 
-	__mt76_wr_copy(dev, MT_WCID_IV(idx), iv_data, sizeof(iv_data));
+	mt76_wr_copy(dev, MT_WCID_IV(idx), iv_data, sizeof(iv_data));
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_wcid_set_key);
 
-void mt76x02_mac_wcid_setup(struct mt76_dev *dev, u8 idx, u8 vif_idx, u8 *mac)
+void mt76x02_mac_wcid_setup(struct mt76x02_dev *dev, u8 idx,
+			    u8 vif_idx, u8 *mac)
 {
 	struct mt76_wcid_addr addr = {};
 	u32 attr;
@@ -105,10 +106,10 @@ void mt76x02_mac_wcid_setup(struct mt76_dev *dev, u8 idx, u8 vif_idx, u8 *mac)
 	attr = FIELD_PREP(MT_WCID_ATTR_BSS_IDX, vif_idx & 7) |
 	       FIELD_PREP(MT_WCID_ATTR_BSS_IDX_EXT, !!(vif_idx & 8));
 
-	__mt76_wr(dev, MT_WCID_ATTR(idx), attr);
+	mt76_wr(dev, MT_WCID_ATTR(idx), attr);
 
-	__mt76_wr(dev, MT_WCID_TX_RATE(idx), 0);
-	__mt76_wr(dev, MT_WCID_TX_RATE(idx) + 4, 0);
+	mt76_wr(dev, MT_WCID_TX_RATE(idx), 0);
+	mt76_wr(dev, MT_WCID_TX_RATE(idx) + 4, 0);
 
 	if (idx >= 128)
 		return;
@@ -116,22 +117,22 @@ void mt76x02_mac_wcid_setup(struct mt76_dev *dev, u8 idx, u8 vif_idx, u8 *mac)
 	if (mac)
 		memcpy(addr.macaddr, mac, ETH_ALEN);
 
-	__mt76_wr_copy(dev, MT_WCID_ADDR(idx), &addr, sizeof(addr));
+	mt76_wr_copy(dev, MT_WCID_ADDR(idx), &addr, sizeof(addr));
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_wcid_setup);
 
-void mt76x02_mac_wcid_set_drop(struct mt76_dev *dev, u8 idx, bool drop)
+void mt76x02_mac_wcid_set_drop(struct mt76x02_dev *dev, u8 idx, bool drop)
 {
-	u32 val = __mt76_rr(dev, MT_WCID_DROP(idx));
+	u32 val = mt76_rr(dev, MT_WCID_DROP(idx));
 	u32 bit = MT_WCID_DROP_MASK(idx);
 
 	/* prevent unnecessary writes */
 	if ((val & bit) != (bit * drop))
-		__mt76_wr(dev, MT_WCID_DROP(idx), (val & ~bit) | (bit * drop));
+		mt76_wr(dev, MT_WCID_DROP(idx), (val & ~bit) | (bit * drop));
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_wcid_set_drop);
 
-void mt76x02_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq)
+void mt76x02_txq_init(struct mt76x02_dev *dev, struct ieee80211_txq *txq)
 {
 	struct mt76_txq *mtxq;
 
@@ -151,7 +152,7 @@ void mt76x02_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq)
 		mtxq->wcid = &mvif->group_wcid;
 	}
 
-	mt76_txq_init(dev, txq);
+	mt76_txq_init(&dev->mt76, txq);
 }
 EXPORT_SYMBOL_GPL(mt76x02_txq_init);
 
@@ -198,7 +199,7 @@ mt76x02_mac_fill_txwi(struct mt76x02_txwi *txwi, struct sk_buff *skb,
 }
 
 static __le16
-mt76x02_mac_tx_rate_val(struct mt76_dev *dev,
+mt76x02_mac_tx_rate_val(struct mt76x02_dev *dev,
 		       const struct ieee80211_tx_rate *rate, u8 *nss_val)
 {
 	u16 rateval;
@@ -224,10 +225,10 @@ mt76x02_mac_tx_rate_val(struct mt76_dev *dev,
 			bw = 1;
 	} else {
 		const struct ieee80211_rate *r;
-		int band = dev->chandef.chan->band;
+		int band = dev->mt76.chandef.chan->band;
 		u16 val;
 
-		r = &dev->hw->wiphy->bands[band]->bitrates[rate->idx];
+		r = &dev->mt76.hw->wiphy->bands[band]->bitrates[rate->idx];
 		if (rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
 			val = r->hw_value_short;
 		else
@@ -248,22 +249,22 @@ mt76x02_mac_tx_rate_val(struct mt76_dev *dev,
 	return cpu_to_le16(rateval);
 }
 
-void mt76x02_mac_wcid_set_rate(struct mt76_dev *dev, struct mt76_wcid *wcid,
+void mt76x02_mac_wcid_set_rate(struct mt76x02_dev *dev, struct mt76_wcid *wcid,
 			      const struct ieee80211_tx_rate *rate)
 {
-	spin_lock_bh(&dev->lock);
+	spin_lock_bh(&dev->mt76.lock);
 	wcid->tx_rate = mt76x02_mac_tx_rate_val(dev, rate, &wcid->tx_rate_nss);
 	wcid->tx_rate_set = true;
-	spin_unlock_bh(&dev->lock);
+	spin_unlock_bh(&dev->mt76.lock);
 }
 
-bool mt76x02_mac_load_tx_status(struct mt76_dev *dev,
-			       struct mt76x02_tx_status *stat)
+bool mt76x02_mac_load_tx_status(struct mt76x02_dev *dev,
+				struct mt76x02_tx_status *stat)
 {
 	u32 stat1, stat2;
 
-	stat2 = __mt76_rr(dev, MT_TX_STAT_FIFO_EXT);
-	stat1 = __mt76_rr(dev, MT_TX_STAT_FIFO);
+	stat2 = mt76_rr(dev, MT_TX_STAT_FIFO_EXT);
+	stat1 = mt76_rr(dev, MT_TX_STAT_FIFO);
 
 	stat->valid = !!(stat1 & MT_TX_STAT_FIFO_VALID);
 	if (!stat->valid)
@@ -339,7 +340,7 @@ mt76x02_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate,
 	return 0;
 }
 
-void mt76x02_mac_write_txwi(struct mt76_dev *dev, struct mt76x02_txwi *txwi,
+void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
 			    struct sk_buff *skb, struct mt76_wcid *wcid,
 			    struct ieee80211_sta *sta, int len)
 {
@@ -349,7 +350,7 @@ void mt76x02_mac_write_txwi(struct mt76_dev *dev, struct mt76x02_txwi *txwi,
 	u16 rate_ht_mask = FIELD_PREP(MT_RXWI_RATE_PHY, BIT(1) | BIT(2));
 	u8 nss;
 	s8 txpwr_adj, max_txpwr_adj;
-	u8 ccmp_pn[8], nstreams = dev->chainmask & 0xf;
+	u8 ccmp_pn[8], nstreams = dev->mt76.chainmask & 0xf;
 
 	memset(txwi, 0, sizeof(*txwi));
 
@@ -374,24 +375,25 @@ void mt76x02_mac_write_txwi(struct mt76_dev *dev, struct mt76x02_txwi *txwi,
 		txwi->eiv = *((__le32 *)&ccmp_pn[1]);
 	}
 
-	spin_lock_bh(&dev->lock);
+	spin_lock_bh(&dev->mt76.lock);
 	if (wcid && (rate->idx < 0 || !rate->count)) {
 		txwi->rate = wcid->tx_rate;
 		max_txpwr_adj = wcid->max_txpwr_adj;
 		nss = wcid->tx_rate_nss;
 	} else {
 		txwi->rate = mt76x02_mac_tx_rate_val(dev, rate, &nss);
-		max_txpwr_adj = mt76x02_tx_get_max_txpwr_adj(dev, rate);
+		max_txpwr_adj = mt76x02_tx_get_max_txpwr_adj(&dev->mt76, rate);
 	}
-	spin_unlock_bh(&dev->lock);
+	spin_unlock_bh(&dev->mt76.lock);
 
-	txpwr_adj = mt76x02_tx_get_txpwr_adj(dev, dev->txpower_conf,
+	txpwr_adj = mt76x02_tx_get_txpwr_adj(&dev->mt76,
+					     dev->mt76.txpower_conf,
 					     max_txpwr_adj);
 	txwi->ctl2 = FIELD_PREP(MT_TX_PWR_ADJ, txpwr_adj);
 
-	if (nstreams > 1 && mt76_rev(dev) >= MT76XX_REV_E4)
+	if (nstreams > 1 && mt76_rev(&dev->mt76) >= MT76XX_REV_E4)
 		txwi->txstream = 0x13;
-	else if (nstreams > 1 && mt76_rev(dev) >= MT76XX_REV_E3 &&
+	else if (nstreams > 1 && mt76_rev(&dev->mt76) >= MT76XX_REV_E3 &&
 		 !(txwi->rate & cpu_to_le16(rate_ht_mask)))
 		txwi->txstream = 0x93;
 
@@ -400,9 +402,9 @@ void mt76x02_mac_write_txwi(struct mt76_dev *dev, struct mt76x02_txwi *txwi,
 EXPORT_SYMBOL_GPL(mt76x02_mac_write_txwi);
 
 static void
-mt76x02_mac_fill_tx_status(struct mt76_dev *dev,
-			  struct ieee80211_tx_info *info,
-			  struct mt76x02_tx_status *st, int n_frames)
+mt76x02_mac_fill_tx_status(struct mt76x02_dev *dev,
+			   struct ieee80211_tx_info *info,
+			   struct mt76x02_tx_status *st, int n_frames)
 {
 	struct ieee80211_tx_rate *rate = info->status.rates;
 	int cur_idx, last_rate;
@@ -413,7 +415,7 @@ mt76x02_mac_fill_tx_status(struct mt76_dev *dev,
 
 	last_rate = min_t(int, st->retry, IEEE80211_TX_MAX_RATES - 1);
 	mt76x02_mac_process_tx_rate(&rate[last_rate], st->rate,
-				   dev->chandef.chan->band);
+				    dev->mt76.chandef.chan->band);
 	if (last_rate < IEEE80211_TX_MAX_RATES - 1)
 		rate[last_rate + 1].idx = -1;
 
@@ -441,8 +443,8 @@ mt76x02_mac_fill_tx_status(struct mt76_dev *dev,
 		info->flags |= IEEE80211_TX_STAT_ACK;
 }
 
-void mt76x02_send_tx_status(struct mt76_dev *dev,
-			   struct mt76x02_tx_status *stat, u8 *update)
+void mt76x02_send_tx_status(struct mt76x02_dev *dev,
+			    struct mt76x02_tx_status *stat, u8 *update)
 {
 	struct ieee80211_tx_info info = {};
 	struct ieee80211_sta *sta = NULL;
@@ -450,8 +452,8 @@ void mt76x02_send_tx_status(struct mt76_dev *dev,
 	struct mt76x02_sta *msta = NULL;
 
 	rcu_read_lock();
-	if (stat->wcid < ARRAY_SIZE(dev->wcid))
-		wcid = rcu_dereference(dev->wcid[stat->wcid]);
+	if (stat->wcid < ARRAY_SIZE(dev->mt76.wcid))
+		wcid = rcu_dereference(dev->mt76.wcid[stat->wcid]);
 
 	if (wcid) {
 		void *priv;
@@ -476,7 +478,7 @@ void mt76x02_send_tx_status(struct mt76_dev *dev,
 		}
 
 		mt76x02_mac_fill_tx_status(dev, &info, &msta->status,
-					  msta->n_frames);
+					   msta->n_frames);
 
 		msta->status = *stat;
 		msta->n_frames = 1;
@@ -486,7 +488,7 @@ void mt76x02_send_tx_status(struct mt76_dev *dev,
 		*update = 1;
 	}
 
-	ieee80211_tx_status_noskb(dev->hw, sta, &info);
+	ieee80211_tx_status_noskb(dev->mt76.hw, sta, &info);
 
 out:
 	rcu_read_unlock();
@@ -561,21 +563,21 @@ mt76x02_mac_process_rate(struct mt76_rx_status *status, u16 rate)
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_process_rate);
 
-void mt76x02_mac_setaddr(struct mt76_dev *dev, u8 *addr)
+void mt76x02_mac_setaddr(struct mt76x02_dev *dev, u8 *addr)
 {
-	ether_addr_copy(dev->macaddr, addr);
+	ether_addr_copy(dev->mt76.macaddr, addr);
 
-	if (!is_valid_ether_addr(dev->macaddr)) {
-		eth_random_addr(dev->macaddr);
-		dev_info(dev->dev,
+	if (!is_valid_ether_addr(dev->mt76.macaddr)) {
+		eth_random_addr(dev->mt76.macaddr);
+		dev_info(dev->mt76.dev,
 			 "Invalid MAC address, using random address %pM\n",
-			 dev->macaddr);
+			 dev->mt76.macaddr);
 	}
 
-	__mt76_wr(dev, MT_MAC_ADDR_DW0, get_unaligned_le32(dev->macaddr));
-	__mt76_wr(dev, MT_MAC_ADDR_DW1,
-		  get_unaligned_le16(dev->macaddr + 4) |
-		  FIELD_PREP(MT_MAC_ADDR_DW1_U2ME_MASK, 0xff));
+	mt76_wr(dev, MT_MAC_ADDR_DW0, get_unaligned_le32(dev->mt76.macaddr));
+	mt76_wr(dev, MT_MAC_ADDR_DW1,
+		get_unaligned_le16(dev->mt76.macaddr + 4) |
+		FIELD_PREP(MT_MAC_ADDR_DW1_U2ME_MASK, 0xff));
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_setaddr);
 
@@ -697,7 +699,7 @@ void mt76x02_mac_poll_tx_status(struct mt76x02_dev *dev, bool irq)
 
 	while (!irq || !kfifo_is_full(&dev->txstatus_fifo)) {
 		spin_lock_irqsave(&dev->mt76.mmio.irq_lock, flags);
-		ret = mt76x02_mac_load_tx_status(&dev->mt76, &stat);
+		ret = mt76x02_mac_load_tx_status(dev, &stat);
 		spin_unlock_irqrestore(&dev->mt76.mmio.irq_lock, flags);
 
 		if (!ret)
@@ -706,7 +708,7 @@ void mt76x02_mac_poll_tx_status(struct mt76x02_dev *dev, bool irq)
 		trace_mac_txstat_fetch(dev, &stat);
 
 		if (!irq) {
-			mt76x02_send_tx_status(&dev->mt76, &stat, &update);
+			mt76x02_send_tx_status(dev, &stat, &update);
 			continue;
 		}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 4f7ee4620ab5..f76aa3141595 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -198,28 +198,28 @@ mt76x02_skb_tx_info(struct sk_buff *skb)
 	return (void *)info->status.status_driver_data;
 }
 
-void mt76x02_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq);
+void mt76x02_txq_init(struct mt76x02_dev *dev, struct ieee80211_txq *txq);
 enum mt76x02_cipher_type
 mt76x02_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data);
 
-int mt76x02_mac_shared_key_setup(struct mt76_dev *dev, u8 vif_idx, u8 key_idx,
+int mt76x02_mac_shared_key_setup(struct mt76x02_dev *dev, u8 vif_idx, u8 key_idx,
 				struct ieee80211_key_conf *key);
-int mt76x02_mac_wcid_set_key(struct mt76_dev *dev, u8 idx,
+int mt76x02_mac_wcid_set_key(struct mt76x02_dev *dev, u8 idx,
 			    struct ieee80211_key_conf *key);
-void mt76x02_mac_wcid_setup(struct mt76_dev *dev, u8 idx, u8 vif_idx, u8 *mac);
-void mt76x02_mac_wcid_set_drop(struct mt76_dev *dev, u8 idx, bool drop);
-void mt76x02_mac_wcid_set_rate(struct mt76_dev *dev, struct mt76_wcid *wcid,
+void mt76x02_mac_wcid_setup(struct mt76x02_dev *dev, u8 idx, u8 vif_idx, u8 *mac);
+void mt76x02_mac_wcid_set_drop(struct mt76x02_dev *dev, u8 idx, bool drop);
+void mt76x02_mac_wcid_set_rate(struct mt76x02_dev *dev, struct mt76_wcid *wcid,
 			      const struct ieee80211_tx_rate *rate);
-bool mt76x02_mac_load_tx_status(struct mt76_dev *dev,
-			       struct mt76x02_tx_status *stat);
-void mt76x02_send_tx_status(struct mt76_dev *dev,
-			   struct mt76x02_tx_status *stat, u8 *update);
+bool mt76x02_mac_load_tx_status(struct mt76x02_dev *dev,
+				struct mt76x02_tx_status *stat);
+void mt76x02_send_tx_status(struct mt76x02_dev *dev,
+			    struct mt76x02_tx_status *stat, u8 *update);
 int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 			   void *rxi);
 int
 mt76x02_mac_process_rate(struct mt76_rx_status *status, u16 rate);
-void mt76x02_mac_setaddr(struct mt76_dev *dev, u8 *addr);
-void mt76x02_mac_write_txwi(struct mt76_dev *dev, struct mt76x02_txwi *txwi,
+void mt76x02_mac_setaddr(struct mt76x02_dev *dev, u8 *addr);
+void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
 			    struct sk_buff *skb, struct mt76_wcid *wcid,
 			    struct ieee80211_sta *sta, int len);
 void mt76x02_mac_poll_tx_status(struct mt76x02_dev *dev, bool irq);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 1b945079c802..39f092034240 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -65,7 +65,7 @@ static void mt76x02_process_tx_status_fifo(struct mt76x02_dev *dev)
 	u8 update = 1;
 
 	while (kfifo_get(&dev->txstatus_fifo, &stat))
-		mt76x02_send_tx_status(&dev->mt76, &stat, &update);
+		mt76x02_send_tx_status(dev, &stat, &update);
 }
 
 static void mt76x02_tx_tasklet(unsigned long data)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
index 830377221739..865fa1b84086 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -157,8 +157,9 @@ void mt76x02_tx_complete(struct mt76_dev *dev, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(mt76x02_tx_complete);
 
-bool mt76x02_tx_status_data(struct mt76_dev *dev, u8 *update)
+bool mt76x02_tx_status_data(struct mt76_dev *mdev, u8 *update)
 {
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 	struct mt76x02_tx_status stat;
 
 	if (!mt76x02_mac_load_tx_status(dev, &stat))
@@ -181,9 +182,9 @@ int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
 	int ret;
 
 	if (q == &dev->mt76.q_tx[MT_TXQ_PSD] && wcid && wcid->idx < 128)
-		mt76x02_mac_wcid_set_drop(&dev->mt76, wcid->idx, false);
+		mt76x02_mac_wcid_set_drop(dev, wcid->idx, false);
 
-	mt76x02_mac_write_txwi(mdev, txwi, skb, wcid, sta, skb->len);
+	mt76x02_mac_write_txwi(dev, txwi, skb, wcid, sta, skb->len);
 
 	ret = mt76x02_insert_hdr_pad(skb);
 	if (ret < 0)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
index 28aabcfd1195..0126e51d77ed 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
@@ -25,7 +25,7 @@ int mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, const void *data,
 			      int data_len, u32 max_payload, u32 offset);
 
 int mt76x02u_skb_dma_info(struct sk_buff *skb, int port, u32 flags);
-int mt76x02u_tx_prepare_skb(struct mt76_dev *dev, void *data,
+int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 			    struct sk_buff *skb, struct mt76_queue *q,
 			    struct mt76_wcid *wcid, struct ieee80211_sta *sta,
 			    u32 *tx_info);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index 7c6c973af386..e43c53e8e6be 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -99,11 +99,12 @@ mt76x02u_set_txinfo(struct sk_buff *skb, struct mt76_wcid *wcid, u8 ep)
 	return mt76x02u_skb_dma_info(skb, WLAN_PORT, flags);
 }
 
-int mt76x02u_tx_prepare_skb(struct mt76_dev *dev, void *data,
+int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 			    struct sk_buff *skb, struct mt76_queue *q,
 			    struct mt76_wcid *wcid, struct ieee80211_sta *sta,
 			    u32 *tx_info)
 {
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 	struct mt76x02_txwi *txwi;
 	int err, len = skb->len;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 04cf89412df3..edcf15fcfac9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -103,10 +103,10 @@ int mt76x02_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	msta->wcid.sta = 1;
 	msta->wcid.idx = idx;
 	msta->wcid.hw_key_idx = -1;
-	mt76x02_mac_wcid_setup(&dev->mt76, idx, mvif->idx, sta->addr);
-	mt76x02_mac_wcid_set_drop(&dev->mt76, idx, false);
+	mt76x02_mac_wcid_setup(dev, idx, mvif->idx, sta->addr);
+	mt76x02_mac_wcid_set_drop(dev, idx, false);
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
-		mt76x02_txq_init(&dev->mt76, sta->txq[i]);
+		mt76x02_txq_init(dev, sta->txq[i]);
 
 	if (vif->type == NL80211_IFTYPE_AP)
 		set_bit(MT_WCID_FLAG_CHECK_PS, &msta->wcid.flags);
@@ -134,9 +134,9 @@ int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
 		mt76_txq_remove(&dev->mt76, sta->txq[i]);
-	mt76x02_mac_wcid_set_drop(&dev->mt76, idx, true);
+	mt76x02_mac_wcid_set_drop(dev, idx, true);
 	mt76_wcid_free(dev->mt76.wcid_mask, idx);
-	mt76x02_mac_wcid_setup(&dev->mt76, idx, 0, NULL);
+	mt76x02_mac_wcid_setup(dev, idx, 0, NULL);
 	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
@@ -151,7 +151,7 @@ void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
 	mvif->idx = idx;
 	mvif->group_wcid.idx = MT_VIF_WCID(idx);
 	mvif->group_wcid.hw_key_idx = -1;
-	mt76x02_txq_init(&dev->mt76, vif->txq);
+	mt76x02_txq_init(dev, vif->txq);
 }
 EXPORT_SYMBOL_GPL(mt76x02_vif_init);
 
@@ -300,17 +300,15 @@ int mt76x02_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	if (!msta) {
 		if (key || wcid->hw_key_idx == idx) {
-			ret = mt76x02_mac_wcid_set_key(&dev->mt76,
-						       wcid->idx, key);
+			ret = mt76x02_mac_wcid_set_key(dev, wcid->idx, key);
 			if (ret)
 				return ret;
 		}
 
-		return mt76x02_mac_shared_key_setup(&dev->mt76,
-						    mvif->idx, idx, key);
+		return mt76x02_mac_shared_key_setup(dev, mvif->idx, idx, key);
 	}
 
-	return mt76x02_mac_wcid_set_key(&dev->mt76, msta->wcid.idx, key);
+	return mt76x02_mac_wcid_set_key(dev, msta->wcid.idx, key);
 }
 EXPORT_SYMBOL_GPL(mt76x02_set_key);
 
@@ -362,7 +360,7 @@ void mt76x02_sta_rate_tbl_update(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ieee80211_sta *sta)
 {
-	struct mt76_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
 	struct ieee80211_sta_rates *rates = rcu_dereference(sta->rates);
 	struct ieee80211_tx_rate rate = {};
@@ -373,7 +371,7 @@ void mt76x02_sta_rate_tbl_update(struct ieee80211_hw *hw,
 	rate.idx = rates->rate[0].idx;
 	rate.flags = rates->rate[0].flags;
 	mt76x02_mac_wcid_set_rate(dev, &msta->wcid, &rate);
-	msta->wcid.max_txpwr_adj = mt76x02_tx_get_max_txpwr_adj(dev, &rate);
+	msta->wcid.max_txpwr_adj = mt76x02_tx_get_max_txpwr_adj(&dev->mt76, &rate);
 }
 EXPORT_SYMBOL_GPL(mt76x02_sta_rate_tbl_update);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index d98d1286f7c1..4e920c71cee9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -143,14 +143,14 @@ static int mt76x2_mac_reset(struct mt76x02_dev *dev, bool hard)
 		mt76_wr(dev, MT_WCID_DROP_BASE + i * 4, 0);
 
 	for (i = 0; i < 256; i++)
-		mt76x02_mac_wcid_setup(&dev->mt76, i, 0, NULL);
+		mt76x02_mac_wcid_setup(dev, i, 0, NULL);
 
 	for (i = 0; i < MT_MAX_VIFS; i++)
-		mt76x02_mac_wcid_setup(&dev->mt76, MT_VIF_WCID(i), i, NULL);
+		mt76x02_mac_wcid_setup(dev, MT_VIF_WCID(i), i, NULL);
 
 	for (i = 0; i < 16; i++)
 		for (k = 0; k < 4; k++)
-			mt76x02_mac_shared_key_setup(&dev->mt76, i, k, NULL);
+			mt76x02_mac_shared_key_setup(dev, i, k, NULL);
 
 	for (i = 0; i < 8; i++) {
 		mt76x2_mac_set_bssid(dev, i, null_addr);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
index 08366c5988ea..4b331ed14bb2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
@@ -36,7 +36,7 @@ mt76_write_beacon(struct mt76x02_dev *dev, int offset, struct sk_buff *skb)
 	if (WARN_ON_ONCE(beacon_len < skb->len + sizeof(struct mt76x02_txwi)))
 		return -ENOSPC;
 
-	mt76x02_mac_write_txwi(&dev->mt76, &txwi, skb, NULL, NULL, skb->len);
+	mt76x02_mac_write_txwi(dev, &txwi, skb, NULL, NULL, skb->len);
 
 	mt76_wr_copy(dev, offset, &txwi, sizeof(txwi));
 	offset += sizeof(txwi);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 65fef082e7cc..034a06295668 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -172,7 +172,7 @@ mt76x2_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps)
 	int idx = msta->wcid.idx;
 
 	mt76_stop_tx_queues(&dev->mt76, sta, true);
-	mt76x02_mac_wcid_set_drop(&dev->mt76, idx, ps);
+	mt76x02_mac_wcid_set_drop(dev, idx, ps);
 }
 
 static void
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index 6214781714c4..51d3eabfa01b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -204,8 +204,7 @@ int mt76x2u_init_hardware(struct mt76x02_dev *dev)
 	if (err < 0)
 		return err;
 
-	mt76x02_mac_setaddr(&dev->mt76,
-			    dev->mt76.eeprom.data + MT_EE_MAC_ADDR);
+	mt76x02_mac_setaddr(dev, dev->mt76.eeprom.data + MT_EE_MAC_ADDR);
 	dev->mt76.rxfilter = mt76_rr(dev, MT_RX_FILTR_CFG);
 
 	mt76x2u_init_beacon_offsets(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 87941ed3fb7c..1971a1b00038 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -50,7 +50,7 @@ static int mt76x2u_add_interface(struct ieee80211_hw *hw,
 	struct mt76x02_dev *dev = hw->priv;
 
 	if (!ether_addr_equal(dev->mt76.macaddr, vif->addr))
-		mt76x02_mac_setaddr(&dev->mt76, vif->addr);
+		mt76x02_mac_setaddr(dev, vif->addr);
 
 	mt76x02_vif_init(dev, vif, 0);
 	return 0;
-- 
2.17.1

