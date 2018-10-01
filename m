Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB26CC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 16:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B457F2082A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 16:58:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B457F2082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbeJAXhL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 19:37:11 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37460 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbeJAXhL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 19:37:11 -0400
Received: by mail-wr1-f66.google.com with SMTP id u12-v6so14766346wrr.4
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 09:58:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TG7IyBbGlUvJyy0rAYAnFIMIncAO/6tRc0GYjBLDvEg=;
        b=DIDf4bX1HeMsvKAG9waxy9qAaZy5OWRKM4gP17etWI+MyvmU34VtgerSXa7qoGCGB6
         X2wPzd6xv9jyw0F/MB/HPsFwo9m/FOd4f9oRejAoDDk797u7cnq6U9MVBydNR2R2ys/y
         PfzxK+8nzNeBmlD4d6T5KzzudKpW6/50htTawnFqF+vPGYVHDeEVbmTqd5NGGQAWuOtk
         al9RDdhRaEVz2Wmn5dZaegIInMnOmJUIZZHdPnwtwgL+PVvyIhvx6fbcmCiFtGCljgUF
         yxbkZKc4VR1KFyo+3pGBmm5y+GkQkIjGcMEIkrqVxcBo0gRf2OK0qNf3JXSx683XByEM
         cG5A==
X-Gm-Message-State: ABuFfohbFBcE3qkuHKi6PIyy1D611qhv5Qp6jXW7SCBlTdVMg3wySCSm
        +JSF/Iw586B0G3g4rolb8gsvFg==
X-Google-Smtp-Source: ACcGV63I+bCxhT7TT0csdzH2O7xGw4h55EEuoAjcQZY4z2BmqGAt0yYpP/LrfSwssj66qrlOfo7/gA==
X-Received: by 2002:adf:fa4e:: with SMTP id y14-v6mr7939734wrr.155.1538413105777;
        Mon, 01 Oct 2018 09:58:25 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id b2-v6sm5057600wru.51.2018.10.01.09.58.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Oct 2018 09:58:24 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] mt76: move mt76x02_tx_get_max_txpwr_adj in mt76x02_util.c
Date:   Mon,  1 Oct 2018 18:58:17 +0200
Message-Id: <ce6414cbee0fbb6d407c64e1d4ee32f35cd3c66b.1538411693.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538411693.git.lorenzo.bianconi@redhat.com>
References: <cover.1538411693.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_tx_get_max_txpwr_adj routine in mt76x02-lib module
since now both mt76x0 and mt76x2 drivers read rate tx power gain from
rate_power data structure. Moreover remove get_max_txpwr_adj function
pointer from mt76_driver_ops data structure

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     |  2 -
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 45 +++++++++++++++++--
 .../net/wireless/mediatek/mt76/mt76x02_util.h |  2 +
 .../net/wireless/mediatek/mt76/mt76x2/mac.c   |  2 +-
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  2 -
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  1 -
 .../net/wireless/mediatek/mt76/mt76x2/tx.c    | 42 -----------------
 7 files changed, 45 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index f2dd4d87e355..c47ad67ce2ff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -262,8 +262,6 @@ struct mt76_driver_ops {
 
 	void (*sta_ps)(struct mt76_dev *dev, struct ieee80211_sta *sta,
 		       bool ps);
-	s8 (*get_max_txpwr_adj)(struct mt76_dev *dev,
-				const struct ieee80211_tx_rate *rate);
 };
 
 struct mt76_channel_state {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index ec422c3980e8..b12db0a108d3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -358,6 +358,47 @@ int mt76x02_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL_GPL(mt76x02_conf_tx);
 
+s8 mt76x02_tx_get_max_txpwr_adj(struct mt76_dev *dev,
+				const struct ieee80211_tx_rate *rate)
+{
+	s8 max_txpwr;
+
+	if (rate->flags & IEEE80211_TX_RC_VHT_MCS) {
+		u8 mcs = ieee80211_rate_get_vht_mcs(rate);
+
+		if (mcs == 8 || mcs == 9) {
+			max_txpwr = dev->rate_power.vht[8];
+		} else {
+			u8 nss, idx;
+
+			nss = ieee80211_rate_get_vht_nss(rate);
+			idx = ((nss - 1) << 3) + mcs;
+			max_txpwr = dev->rate_power.ht[idx & 0xf];
+		}
+	} else if (rate->flags & IEEE80211_TX_RC_MCS) {
+		max_txpwr = dev->rate_power.ht[rate->idx & 0xf];
+	} else {
+		enum nl80211_band band = dev->chandef.chan->band;
+
+		if (band == NL80211_BAND_2GHZ) {
+			const struct ieee80211_rate *r;
+			struct wiphy *wiphy = dev->hw->wiphy;
+			struct mt76_rate_power *rp = &dev->rate_power;
+
+			r = &wiphy->bands[band]->bitrates[rate->idx];
+			if (r->flags & IEEE80211_RATE_SHORT_PREAMBLE)
+				max_txpwr = rp->cck[r->hw_value & 0x3];
+			else
+				max_txpwr = rp->ofdm[r->hw_value & 0x7];
+		} else {
+			max_txpwr = dev->rate_power.ofdm[rate->idx & 0x7];
+		}
+	}
+
+	return max_txpwr;
+}
+EXPORT_SYMBOL_GPL(mt76x02_tx_get_max_txpwr_adj);
+
 void mt76x02_sta_rate_tbl_update(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ieee80211_sta *sta)
@@ -373,9 +414,7 @@ void mt76x02_sta_rate_tbl_update(struct ieee80211_hw *hw,
 	rate.idx = rates->rate[0].idx;
 	rate.flags = rates->rate[0].flags;
 	mt76x02_mac_wcid_set_rate(dev, &msta->wcid, &rate);
-
-	if (dev->drv && dev->drv->get_max_txpwr_adj)
-		msta->wcid.max_txpwr_adj = dev->drv->get_max_txpwr_adj(dev, &rate);
+	msta->wcid.max_txpwr_adj = mt76x02_tx_get_max_txpwr_adj(dev, &rate);
 }
 EXPORT_SYMBOL_GPL(mt76x02_sta_rate_tbl_update);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index ff4cab5ca038..54cec0cbf645 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -45,6 +45,8 @@ int mt76x02_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 void mt76x02_sta_rate_tbl_update(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ieee80211_sta *sta);
+s8 mt76x02_tx_get_max_txpwr_adj(struct mt76_dev *dev,
+				const struct ieee80211_tx_rate *rate);
 int mt76x02_insert_hdr_pad(struct sk_buff *skb);
 void mt76x02_remove_hdr_pad(struct sk_buff *skb, int len);
 void mt76x02_tx_complete(struct mt76_dev *dev, struct sk_buff *skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
index 568bac76097c..a396a56dcfe0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
@@ -96,7 +96,7 @@ void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x02_txwi *txwi,
 		nss = wcid->tx_rate_nss;
 	} else {
 		txwi->rate = mt76x02_mac_tx_rate_val(&dev->mt76, rate, &nss);
-		max_txpwr_adj = mt76x2_tx_get_max_txpwr_adj(&dev->mt76, rate);
+		max_txpwr_adj = mt76x02_tx_get_max_txpwr_adj(&dev->mt76, rate);
 	}
 	spin_unlock_bh(&dev->mt76.lock);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index ecbb9e4ab888..50490c75a1e2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -176,8 +176,6 @@ void mt76x2_sta_ps(struct mt76_dev *dev, struct ieee80211_sta *sta, bool ps);
 
 void mt76x2_update_channel(struct mt76_dev *mdev);
 
-s8 mt76x2_tx_get_max_txpwr_adj(struct mt76_dev *dev,
-			       const struct ieee80211_tx_rate *rate);
 s8 mt76x2_tx_get_txpwr_adj(struct mt76x2_dev *dev, s8 txpwr, s8 max_txpwr_adj);
 void mt76x2_tx_set_txpwr_auto(struct mt76x2_dev *dev, s8 txpwr);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 7036f4cbc836..d9fb06e34dbf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -362,7 +362,6 @@ struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev)
 		.rx_skb = mt76x2_queue_rx_skb,
 		.rx_poll_complete = mt76x2_rx_poll_complete,
 		.sta_ps = mt76x2_sta_ps,
-		.get_max_txpwr_adj = mt76x2_tx_get_max_txpwr_adj,
 	};
 	struct mt76x2_dev *dev;
 	struct mt76_dev *mdev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c
index aea142600042..0c878c9eb33d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c
@@ -47,48 +47,6 @@ void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 }
 EXPORT_SYMBOL_GPL(mt76x2_tx);
 
-s8 mt76x2_tx_get_max_txpwr_adj(struct mt76_dev *mdev,
-			       const struct ieee80211_tx_rate *rate)
-{
-	struct mt76x2_dev *dev = (struct mt76x2_dev *) mdev;
-	s8 max_txpwr;
-
-	if (rate->flags & IEEE80211_TX_RC_VHT_MCS) {
-		u8 mcs = ieee80211_rate_get_vht_mcs(rate);
-
-		if (mcs == 8 || mcs == 9) {
-			max_txpwr = mdev->rate_power.vht[8];
-		} else {
-			u8 nss, idx;
-
-			nss = ieee80211_rate_get_vht_nss(rate);
-			idx = ((nss - 1) << 3) + mcs;
-			max_txpwr = mdev->rate_power.ht[idx & 0xf];
-		}
-	} else if (rate->flags & IEEE80211_TX_RC_MCS) {
-		max_txpwr = mdev->rate_power.ht[rate->idx & 0xf];
-	} else {
-		enum nl80211_band band = dev->mt76.chandef.chan->band;
-
-		if (band == NL80211_BAND_2GHZ) {
-			const struct ieee80211_rate *r;
-			struct wiphy *wiphy = mt76_hw(dev)->wiphy;
-			struct mt76_rate_power *rp = &mdev->rate_power;
-
-			r = &wiphy->bands[band]->bitrates[rate->idx];
-			if (r->flags & IEEE80211_RATE_SHORT_PREAMBLE)
-				max_txpwr = rp->cck[r->hw_value & 0x3];
-			else
-				max_txpwr = rp->ofdm[r->hw_value & 0x7];
-		} else {
-			max_txpwr = mdev->rate_power.ofdm[rate->idx & 0x7];
-		}
-	}
-
-	return max_txpwr;
-}
-EXPORT_SYMBOL_GPL(mt76x2_tx_get_max_txpwr_adj);
-
 s8 mt76x2_tx_get_txpwr_adj(struct mt76x2_dev *dev, s8 txpwr, s8 max_txpwr_adj)
 {
 	txpwr = min_t(s8, txpwr, dev->mt76.txpower_conf);
-- 
2.17.1

