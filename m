Return-Path: <SRS0=9HFQ=MT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE907C67876
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 09:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC40C20882
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 09:57:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC40C20882
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbeJGREO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Oct 2018 13:04:14 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39165 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbeJGREO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Oct 2018 13:04:14 -0400
Received: by mail-wm1-f68.google.com with SMTP id y144-v6so1064554wmd.4
        for <linux-wireless@vger.kernel.org>; Sun, 07 Oct 2018 02:57:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5oMb30wd8N/z83/1KiNirrMFTobl41k+RQduu09Iuk4=;
        b=ps0H6rKBG4sQj5s0eql9TKMq/kC7sOCnnCw4n4sCKtdZgCFMeWKV5bp8igr+QtghJh
         Y0ocQNCABHYRlLbqpbDUv8Lhob9B2gmvit/vVfkAoPgRPpza8Hk3/rYXxiowCgIYJoaO
         YX/VeYdW8s3sibXmbswzpcGuhe1IEQdCTwaWLpDq38NPxY7/d+ZXhgumGATTbFIhnJj4
         220/AWfF1PTO9K0tkYhdG3nrSQeGsFTb/4+5rbVmQ2Us29R7lY0vwgRWyGxbe6x4LSSW
         Pg7rwbJD089cznPnCEp1LeDiWrO56kJKFcPGzN7hGWrSLRLAbXbwFBuGU0Oq03WHX1RS
         +efQ==
X-Gm-Message-State: ABuFfoiS/pwUfrMnBJQoDfqcxxjJo5cWjVUDAXq+1GgcSzKXNrBuAfxJ
        ONmeCVrdnbzPpGSsLHpGk8ZHWg==
X-Google-Smtp-Source: ACcGV60AGVBOayjtyH7eGJiLNOKdvYxq7dQPEJsbttlyADAeWREIfdRNEJ9nxBcTcdyLc0QqCwf3mQ==
X-Received: by 2002:a1c:1c13:: with SMTP id c19-v6mr11607726wmc.85.1538906247139;
        Sun, 07 Oct 2018 02:57:27 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id a5-v6sm6404631wmh.8.2018.10.07.02.57.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Oct 2018 02:57:26 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] mt76: disable ldpc coding for mt76x0 devices
Date:   Sun,  7 Oct 2018 11:57:21 +0200
Message-Id: <20181007095722.13577-3-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Disable ldpc coding for mt76x0 devices. Morover remove
mt76x02_mac_fill_txwi routine since it is used just in
mt76x02_mac_write_txwi

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  7 ++
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 77 ++++++++-----------
 2 files changed, 41 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index e78708d55baf..fe731529144c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -161,6 +161,13 @@ void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev);
 void mt76x02_set_irq_mask(struct mt76x02_dev *dev, u32 clear, u32 set);
 void mt76x02_mac_start(struct mt76x02_dev *dev);
 
+static inline bool is_mt76x2(struct mt76x02_dev *dev)
+{
+	return mt76_chip(&dev->mt76) == 0x7612 ||
+	       mt76_chip(&dev->mt76) == 0x7662 ||
+	       mt76_chip(&dev->mt76) == 0x7602;
+}
+
 static inline void mt76x02_irq_enable(struct mt76x02_dev *dev, u32 mask)
 {
 	mt76x02_set_irq_mask(dev, 0, mask);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 69132b971c30..10578e4cb269 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -156,48 +156,6 @@ void mt76x02_txq_init(struct mt76x02_dev *dev, struct ieee80211_txq *txq)
 }
 EXPORT_SYMBOL_GPL(mt76x02_txq_init);
 
-static void
-mt76x02_mac_fill_txwi(struct mt76x02_txwi *txwi, struct sk_buff *skb,
-		      struct ieee80211_sta *sta, int len, u8 nss)
-{
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	u16 txwi_flags = 0;
-
-	if (info->flags & IEEE80211_TX_CTL_LDPC)
-		txwi->rate |= cpu_to_le16(MT_RXWI_RATE_LDPC);
-	if ((info->flags & IEEE80211_TX_CTL_STBC) && nss == 1)
-		txwi->rate |= cpu_to_le16(MT_RXWI_RATE_STBC);
-	if (nss > 1 && sta && sta->smps_mode == IEEE80211_SMPS_DYNAMIC)
-		txwi_flags |= MT_TXWI_FLAGS_MMPS;
-	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
-		txwi->ack_ctl |= MT_TXWI_ACK_CTL_REQ;
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
-		txwi->ack_ctl |= MT_TXWI_ACK_CTL_NSEQ;
-	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
-		txwi->pktid |= MT_TXWI_PKTID_PROBE;
-	if ((info->flags & IEEE80211_TX_CTL_AMPDU) && sta) {
-		u8 ba_size = IEEE80211_MIN_AMPDU_BUF;
-
-		ba_size <<= sta->ht_cap.ampdu_factor;
-		ba_size = min_t(int, 63, ba_size - 1);
-		if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
-			ba_size = 0;
-		txwi->ack_ctl |= FIELD_PREP(MT_TXWI_ACK_CTL_BA_WINDOW, ba_size);
-
-		txwi_flags |= MT_TXWI_FLAGS_AMPDU |
-			 FIELD_PREP(MT_TXWI_FLAGS_MPDU_DENSITY,
-				    sta->ht_cap.ampdu_density);
-	}
-
-	if (ieee80211_is_probe_resp(hdr->frame_control) ||
-	    ieee80211_is_beacon(hdr->frame_control))
-		txwi_flags |= MT_TXWI_FLAGS_TS;
-
-	txwi->flags |= cpu_to_le16(txwi_flags);
-	txwi->len_ctl = cpu_to_le16(len);
-}
-
 static __le16
 mt76x02_mac_tx_rate_val(struct mt76x02_dev *dev,
 			const struct ieee80211_tx_rate *rate, u8 *nss_val)
@@ -344,10 +302,12 @@ void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
 			    struct sk_buff *skb, struct mt76_wcid *wcid,
 			    struct ieee80211_sta *sta, int len)
 {
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *rate = &info->control.rates[0];
 	struct ieee80211_key_conf *key = info->control.hw_key;
 	u16 rate_ht_mask = FIELD_PREP(MT_RXWI_RATE_PHY, BIT(1) | BIT(2));
+	u16 txwi_flags = 0;
 	u8 nss;
 	s8 txpwr_adj, max_txpwr_adj;
 	u8 ccmp_pn[8], nstreams = dev->mt76.chainmask & 0xf;
@@ -396,7 +356,38 @@ void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
 		 !(txwi->rate & cpu_to_le16(rate_ht_mask)))
 		txwi->txstream = 0x93;
 
-	mt76x02_mac_fill_txwi(txwi, skb, sta, len, nss);
+	if (is_mt76x2(dev) && (info->flags & IEEE80211_TX_CTL_LDPC))
+		txwi->rate |= cpu_to_le16(MT_RXWI_RATE_LDPC);
+	if ((info->flags & IEEE80211_TX_CTL_STBC) && nss == 1)
+		txwi->rate |= cpu_to_le16(MT_RXWI_RATE_STBC);
+	if (nss > 1 && sta && sta->smps_mode == IEEE80211_SMPS_DYNAMIC)
+		txwi_flags |= MT_TXWI_FLAGS_MMPS;
+	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
+		txwi->ack_ctl |= MT_TXWI_ACK_CTL_REQ;
+	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+		txwi->ack_ctl |= MT_TXWI_ACK_CTL_NSEQ;
+	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
+		txwi->pktid |= MT_TXWI_PKTID_PROBE;
+	if ((info->flags & IEEE80211_TX_CTL_AMPDU) && sta) {
+		u8 ba_size = IEEE80211_MIN_AMPDU_BUF;
+
+		ba_size <<= sta->ht_cap.ampdu_factor;
+		ba_size = min_t(int, 63, ba_size - 1);
+		if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
+			ba_size = 0;
+		txwi->ack_ctl |= FIELD_PREP(MT_TXWI_ACK_CTL_BA_WINDOW, ba_size);
+
+		txwi_flags |= MT_TXWI_FLAGS_AMPDU |
+			 FIELD_PREP(MT_TXWI_FLAGS_MPDU_DENSITY,
+				    sta->ht_cap.ampdu_density);
+	}
+
+	if (ieee80211_is_probe_resp(hdr->frame_control) ||
+	    ieee80211_is_beacon(hdr->frame_control))
+		txwi_flags |= MT_TXWI_FLAGS_TS;
+
+	txwi->flags |= cpu_to_le16(txwi_flags);
+	txwi->len_ctl = cpu_to_le16(len);
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_write_txwi);
 
-- 
2.19.0

