Return-Path: <SRS0=9HFQ=MT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0113C65C30
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 09:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9915E20882
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 09:45:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9915E20882
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727371AbeJGQwW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Oct 2018 12:52:22 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53130 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbeJGQwW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Oct 2018 12:52:22 -0400
Received: by mail-wm1-f65.google.com with SMTP id 189-v6so5392003wmw.2
        for <linux-wireless@vger.kernel.org>; Sun, 07 Oct 2018 02:45:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hp0nG0QiYI1rjtM/2l4O+XyC1nks2O/ez5QhdFykHF8=;
        b=YEENOzP35fzUY/AeTYPX1phecTE7nCwMmt3hqaGEpzIApBz6Z+yrXLgkSw0fwn0gfD
         DeeXlYjnHa1oEzmDCbvN/KRlWq54yFoFmbRTj1cPZwwPHzQfNRvZXNfrFlYrrhPlsWb1
         uHrI/C90uyfl84taT1yUpm5zwEyLL41MCu6/FkM3/0eXH0oJPwgNmw+VK71ZT3FRQHh8
         II/x4h1AWEHtPdqbNLb2I3h4vYjNog1P2HLIbnwpCYwGFYWSQgnqE0FuXuYimIMkSF5n
         SDb+HnODpakAKW1SEn3jfTeWorpPvgWVMAAIkC37cD+s0Q4FKxvqUuBuaNew5iz4Cwh0
         jgzg==
X-Gm-Message-State: ABuFfogaKTHeJCeuhES9KXteEb+sjCnc0JweCMDmLOkbEzglmzadyYwh
        zVTtSKom0E1uX9yVcx4qwzrJTA==
X-Google-Smtp-Source: ACcGV628EqpiLlCCuqjGvtbVQXDpCnj6aJZ4p+nzcCHMJw8rqmTziUXZP9x/EHzRiMymiyVmOGfJCg==
X-Received: by 2002:a1c:ce02:: with SMTP id e2-v6mr11907895wmg.85.1538905536944;
        Sun, 07 Oct 2018 02:45:36 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id q135-v6sm6149599wmd.4.2018.10.07.02.45.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Oct 2018 02:45:36 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 6/7] mt76: use mt76x02_dev instead of mt76_dev in mt76x02_txrx.c
Date:   Sun,  7 Oct 2018 11:45:23 +0200
Message-Id: <20181007094524.12656-7-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76x02_dev data structure as reference in mt76x02_txrx.c
instead of mt76_dev

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  5 +++--
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  |  5 ++---
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c | 22 +++++++++----------
 .../net/wireless/mediatek/mt76/mt76x02_util.c |  2 +-
 4 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 30a9790793d3..e78708d55baf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -136,9 +136,10 @@ int mt76x02_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 void mt76x02_sta_rate_tbl_update(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ieee80211_sta *sta);
-s8 mt76x02_tx_get_max_txpwr_adj(struct mt76_dev *dev,
+s8 mt76x02_tx_get_max_txpwr_adj(struct mt76x02_dev *dev,
 				const struct ieee80211_tx_rate *rate);
-s8 mt76x02_tx_get_txpwr_adj(struct mt76_dev *mdev, s8 txpwr, s8 max_txpwr_adj);
+s8 mt76x02_tx_get_txpwr_adj(struct mt76x02_dev *dev, s8 txpwr,
+			    s8 max_txpwr_adj);
 void mt76x02_tx_set_txpwr_auto(struct mt76x02_dev *dev, s8 txpwr);
 int mt76x02_insert_hdr_pad(struct sk_buff *skb);
 void mt76x02_remove_hdr_pad(struct sk_buff *skb, int len);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index e217dcec28d9..69132b971c30 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -382,12 +382,11 @@ void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
 		nss = wcid->tx_rate_nss;
 	} else {
 		txwi->rate = mt76x02_mac_tx_rate_val(dev, rate, &nss);
-		max_txpwr_adj = mt76x02_tx_get_max_txpwr_adj(&dev->mt76, rate);
+		max_txpwr_adj = mt76x02_tx_get_max_txpwr_adj(dev, rate);
 	}
 	spin_unlock_bh(&dev->mt76.lock);
 
-	txpwr_adj = mt76x02_tx_get_txpwr_adj(&dev->mt76,
-					     dev->mt76.txpower_conf,
+	txpwr_adj = mt76x02_tx_get_txpwr_adj(dev, dev->mt76.txpower_conf,
 					     max_txpwr_adj);
 	txwi->ctl2 = FIELD_PREP(MT_TX_PWR_ADJ, txpwr_adj);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
index 865fa1b84086..d3de08872d6e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -71,7 +71,7 @@ void mt76x02_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 }
 EXPORT_SYMBOL_GPL(mt76x02_queue_rx_skb);
 
-s8 mt76x02_tx_get_max_txpwr_adj(struct mt76_dev *dev,
+s8 mt76x02_tx_get_max_txpwr_adj(struct mt76x02_dev *dev,
 				const struct ieee80211_tx_rate *rate)
 {
 	s8 max_txpwr;
@@ -80,23 +80,23 @@ s8 mt76x02_tx_get_max_txpwr_adj(struct mt76_dev *dev,
 		u8 mcs = ieee80211_rate_get_vht_mcs(rate);
 
 		if (mcs == 8 || mcs == 9) {
-			max_txpwr = dev->rate_power.vht[8];
+			max_txpwr = dev->mt76.rate_power.vht[8];
 		} else {
 			u8 nss, idx;
 
 			nss = ieee80211_rate_get_vht_nss(rate);
 			idx = ((nss - 1) << 3) + mcs;
-			max_txpwr = dev->rate_power.ht[idx & 0xf];
+			max_txpwr = dev->mt76.rate_power.ht[idx & 0xf];
 		}
 	} else if (rate->flags & IEEE80211_TX_RC_MCS) {
-		max_txpwr = dev->rate_power.ht[rate->idx & 0xf];
+		max_txpwr = dev->mt76.rate_power.ht[rate->idx & 0xf];
 	} else {
-		enum nl80211_band band = dev->chandef.chan->band;
+		enum nl80211_band band = dev->mt76.chandef.chan->band;
 
 		if (band == NL80211_BAND_2GHZ) {
 			const struct ieee80211_rate *r;
-			struct wiphy *wiphy = dev->hw->wiphy;
-			struct mt76_rate_power *rp = &dev->rate_power;
+			struct wiphy *wiphy = dev->mt76.hw->wiphy;
+			struct mt76_rate_power *rp = &dev->mt76.rate_power;
 
 			r = &wiphy->bands[band]->bitrates[rate->idx];
 			if (r->flags & IEEE80211_RATE_SHORT_PREAMBLE)
@@ -104,7 +104,7 @@ s8 mt76x02_tx_get_max_txpwr_adj(struct mt76_dev *dev,
 			else
 				max_txpwr = rp->ofdm[r->hw_value & 0x7];
 		} else {
-			max_txpwr = dev->rate_power.ofdm[rate->idx & 0x7];
+			max_txpwr = dev->mt76.rate_power.ofdm[rate->idx & 0x7];
 		}
 	}
 
@@ -112,10 +112,8 @@ s8 mt76x02_tx_get_max_txpwr_adj(struct mt76_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mt76x02_tx_get_max_txpwr_adj);
 
-s8 mt76x02_tx_get_txpwr_adj(struct mt76_dev *mdev, s8 txpwr, s8 max_txpwr_adj)
+s8 mt76x02_tx_get_txpwr_adj(struct mt76x02_dev *dev, s8 txpwr, s8 max_txpwr_adj)
 {
-	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
-
 	txpwr = min_t(s8, txpwr, dev->mt76.txpower_conf);
 	txpwr -= (dev->target_power + dev->target_power_delta[0]);
 	txpwr = min_t(s8, txpwr, max_txpwr_adj);
@@ -133,7 +131,7 @@ void mt76x02_tx_set_txpwr_auto(struct mt76x02_dev *dev, s8 txpwr)
 {
 	s8 txpwr_adj;
 
-	txpwr_adj = mt76x02_tx_get_txpwr_adj(&dev->mt76, txpwr,
+	txpwr_adj = mt76x02_tx_get_txpwr_adj(dev, txpwr,
 					     dev->mt76.rate_power.ofdm[4]);
 	mt76_rmw_field(dev, MT_PROT_AUTO_TX_CFG,
 		       MT_PROT_AUTO_TX_CFG_PROT_PADJ, txpwr_adj);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 3351e0c7a9f7..ca05332f81fc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -372,7 +372,7 @@ void mt76x02_sta_rate_tbl_update(struct ieee80211_hw *hw,
 	rate.idx = rates->rate[0].idx;
 	rate.flags = rates->rate[0].flags;
 	mt76x02_mac_wcid_set_rate(dev, &msta->wcid, &rate);
-	msta->wcid.max_txpwr_adj = mt76x02_tx_get_max_txpwr_adj(&dev->mt76, &rate);
+	msta->wcid.max_txpwr_adj = mt76x02_tx_get_max_txpwr_adj(dev, &rate);
 }
 EXPORT_SYMBOL_GPL(mt76x02_sta_rate_tbl_update);
 
-- 
2.19.0

