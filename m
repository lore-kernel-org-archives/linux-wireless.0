Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51075C10F03
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 08:38:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E91C2208E4
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 08:38:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="kcnKiMtT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729901AbfDYIiv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 04:38:51 -0400
Received: from nbd.name ([46.4.11.11]:59702 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729860AbfDYIir (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 04:38:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NkdOelf9akP4uiK2/OvTAi2fqME8agkmj1LEGDnmXs4=; b=kcnKiMtT6uynqON30nvD9vDQhJ
        5W3Nniqy+1EjEtqQk1wBeMG1Mm3p/X5KwECGMunTXua8f77YXXKBKp1RPSAoKbeBubbXryhxJpLyf
        vw7eiz4WeWUrg0Bee8PWWbfzZB13dJyVAbCJ3c7rfMbkZvLLg+mDlQSyO9nzOjp1eDHM=;
Received: from p54ae9e78.dip0.t-ipconnect.de ([84.174.158.120] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1hJZu1-0002Bo-MT
        for linux-wireless@vger.kernel.org; Thu, 25 Apr 2019 10:38:45 +0200
Received: by maeck-2.local (Postfix, from userid 501)
        id 0DDC759A3379; Thu, 25 Apr 2019 10:38:44 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH v2 3/5] mt76: store wcid tx rate info in one u32 reduce locking
Date:   Thu, 25 Apr 2019 10:38:42 +0200
Message-Id: <20190425083844.14186-3-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190425083844.14186-1-nbd@nbd.name>
References: <20190425083844.14186-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     | 10 ++++---
 .../net/wireless/mediatek/mt76/mt7603/mac.c   |  4 +--
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 26 ++++++++++++-------
 .../net/wireless/mediatek/mt76/mt76x02_util.c |  1 -
 drivers/net/wireless/mediatek/mt76/tx.c       |  4 +--
 5 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index e68834ee8393..176faaac8748 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -188,6 +188,11 @@ enum mt76_wcid_flags {
 
 DECLARE_EWMA(signal, 10, 8);
 
+#define MT_WCID_TX_INFO_RATE		GENMASK(15, 0)
+#define MT_WCID_TX_INFO_NSS		GENMASK(17, 16)
+#define MT_WCID_TX_INFO_TXPWR_ADJ	GENMASK(25, 18)
+#define MT_WCID_TX_INFO_SET		BIT(31)
+
 struct mt76_wcid {
 	struct mt76_rx_tid __rcu *aggr[IEEE80211_NUM_TIDS];
 
@@ -206,10 +211,7 @@ struct mt76_wcid {
 	u8 rx_check_pn;
 	u8 rx_key_pn[IEEE80211_NUM_TIDS][6];
 
-	__le16 tx_rate;
-	bool tx_rate_set;
-	u8 tx_rate_nss;
-	s8 max_txpwr_adj;
+	u32 tx_info;
 	bool sw_iv;
 
 	u8 packet_id;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index 2d090dacb788..47f5005ea48a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -717,11 +717,11 @@ void mt7603_wtbl_set_rates(struct mt7603_dev *dev, struct mt7603_sta *sta,
 		MT_WTBL_UPDATE_RATE_UPDATE |
 		MT_WTBL_UPDATE_TX_COUNT_CLEAR);
 
-	if (!sta->wcid.tx_rate_set)
+	if (!(sta->wcid.tx_info & MT_WCID_TX_INFO_SET))
 		mt76_poll(dev, MT_WTBL_UPDATE, MT_WTBL_UPDATE_BUSY, 0, 5000);
 
 	sta->rate_count = 2 * MT7603_RATE_RETRY * n_rates;
-	sta->wcid.tx_rate_set = true;
+	sta->wcid.tx_info |= MT_WCID_TX_INFO_SET;
 }
 
 static enum mt7603_cipher_type
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 4a77d509a86b..b81b71ba0930 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -218,10 +218,17 @@ mt76x02_mac_tx_rate_val(struct mt76x02_dev *dev,
 void mt76x02_mac_wcid_set_rate(struct mt76x02_dev *dev, struct mt76_wcid *wcid,
 			       const struct ieee80211_tx_rate *rate)
 {
-	spin_lock_bh(&dev->mt76.lock);
-	wcid->tx_rate = mt76x02_mac_tx_rate_val(dev, rate, &wcid->tx_rate_nss);
-	wcid->tx_rate_set = true;
-	spin_unlock_bh(&dev->mt76.lock);
+	s8 max_txpwr_adj = mt76x02_tx_get_max_txpwr_adj(dev, rate);
+	__le16 rateval;
+	u32 tx_info;
+	s8 nss;
+
+	rateval = mt76x02_mac_tx_rate_val(dev, rate, &nss);
+	tx_info = FIELD_PREP(MT_WCID_TX_INFO_RATE, rateval) |
+		  FIELD_PREP(MT_WCID_TX_INFO_NSS, nss) |
+		  FIELD_PREP(MT_WCID_TX_INFO_TXPWR_ADJ, max_txpwr_adj) |
+		  MT_WCID_TX_INFO_SET;
+	wcid->tx_info = tx_info;
 }
 
 void mt76x02_mac_set_short_preamble(struct mt76x02_dev *dev, bool enable)
@@ -323,6 +330,7 @@ void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *rate = &info->control.rates[0];
 	struct ieee80211_key_conf *key = info->control.hw_key;
+	u32 wcid_tx_info;
 	u16 rate_ht_mask = FIELD_PREP(MT_RXWI_RATE_PHY, BIT(1) | BIT(2));
 	u16 txwi_flags = 0;
 	u8 nss;
@@ -357,16 +365,16 @@ void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
 		txwi->eiv = *((__le32 *)&ccmp_pn[4]);
 	}
 
-	spin_lock_bh(&dev->mt76.lock);
 	if (wcid && (rate->idx < 0 || !rate->count)) {
-		txwi->rate = wcid->tx_rate;
-		max_txpwr_adj = wcid->max_txpwr_adj;
-		nss = wcid->tx_rate_nss;
+		wcid_tx_info = wcid->tx_info;
+		txwi->rate = FIELD_GET(MT_WCID_TX_INFO_RATE, wcid_tx_info);
+		max_txpwr_adj = FIELD_GET(MT_WCID_TX_INFO_TXPWR_ADJ,
+					  wcid_tx_info);
+		nss = FIELD_GET(MT_WCID_TX_INFO_NSS, wcid_tx_info);
 	} else {
 		txwi->rate = mt76x02_mac_tx_rate_val(dev, rate, &nss);
 		max_txpwr_adj = mt76x02_tx_get_max_txpwr_adj(dev, rate);
 	}
-	spin_unlock_bh(&dev->mt76.lock);
 
 	txpwr_adj = mt76x02_tx_get_txpwr_adj(dev, dev->mt76.txpower_conf,
 					     max_txpwr_adj);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 284dae65cdf1..f3558c108b17 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -572,7 +572,6 @@ void mt76x02_sta_rate_tbl_update(struct ieee80211_hw *hw,
 	rate.idx = rates->rate[0].idx;
 	rate.flags = rates->rate[0].flags;
 	mt76x02_mac_wcid_set_rate(dev, &msta->wcid, &rate);
-	msta->wcid.max_txpwr_adj = mt76x02_tx_get_max_txpwr_adj(dev, &rate);
 }
 EXPORT_SYMBOL_GPL(mt76x02_sta_rate_tbl_update);
 
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 48f588726b3f..dd0c583ab5b1 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -266,7 +266,7 @@ mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 		skb_set_queue_mapping(skb, qid);
 	}
 
-	if (!wcid->tx_rate_set)
+	if (!(wcid->tx_info & MT_WCID_TX_INFO_SET))
 		ieee80211_get_tx_rates(info->control.vif, sta, skb,
 				       info->control.rates, 1);
 
@@ -412,7 +412,7 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_sw_queue *sq,
 	}
 
 	info = IEEE80211_SKB_CB(skb);
-	if (!wcid->tx_rate_set)
+	if (!(wcid->tx_info & MT_WCID_TX_INFO_SET))
 		ieee80211_get_tx_rates(txq->vif, txq->sta, skb,
 				       info->control.rates, 1);
 	tx_rate = info->control.rates[0];
-- 
2.17.0

