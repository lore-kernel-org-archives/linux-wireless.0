Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F5AC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 22:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B350D2089A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 22:19:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B350D2089A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbeJBE7d (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 00:59:33 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41741 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbeJBE7d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 00:59:33 -0400
Received: by mail-wr1-f68.google.com with SMTP id x12-v6so999432wru.8
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 15:19:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jSqW/WWMd3mMPOct3nssPrepKLJ2fmMv3vSyEdCwU6g=;
        b=saZivT02hra+I5YCvmPDN4gAAbWcIc2XUG3CqNkHkAyzcws9sYglN+Nes7DnOobtKE
         g3/gN0tWoNzevG4j2kL1TADjXaU3jmQEE24t/RBsuu8TQQ1smGGOnNV3f+iLBtKOD3pS
         Ry/q3a4oxS6Sn72lYduQ9h+cGjv8VEarVqbhlR6Fh+oY7dS0Wv0WuX8mZT0nu1+CscMx
         nBKJegVxaofZ1NMwzelBwd6KY0yqqRYTP6g4kXWO5KFAZAPjquUEgjgGj17c18hNCn8Q
         jZtYAKGO3rKJItYjRDGZJOOS0yAIhbYpa/dHiCWLpXbXBvaxx7OVo44jzyz48xDiWnsL
         witQ==
X-Gm-Message-State: ABuFfog973iaG5h2sfJVHcp9J1+rhGz80glxZEVQTN1w3INmB4vCSwwO
        6XHB8b/Qe0157Vn2F7jK4y2kwg==
X-Google-Smtp-Source: ACcGV63opUGXsQZ2cH1mavn/EBovO4iavv00m2qg4wis3wDXSogmfN4vwAddCHxT9kWKOh3ULfXLvA==
X-Received: by 2002:adf:e403:: with SMTP id g3-v6mr8062206wrm.96.1538432372855;
        Mon, 01 Oct 2018 15:19:32 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id t4-v6sm9203420wrb.45.2018.10.01.15.19.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Oct 2018 15:19:32 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 08/10] mt76: move mt76x02_mac_process_rx in mt76x02-lib module
Date:   Tue,  2 Oct 2018 00:19:06 +0200
Message-Id: <20181001221908.16005-9-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_mac_process_rx utility routine in mt76x02-lib
in order to by reused by mt76x0 driver for rxwi parsing.
Add stream number check in mt76x02_mac_process_rx since mt76x0
chipsets are 1x1:1

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 105 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |   4 +
 .../wireless/mediatek/mt76/mt76x2/common.c    |   2 +-
 .../net/wireless/mediatek/mt76/mt76x2/mac.c   |  96 ----------------
 .../net/wireless/mediatek/mt76/mt76x2/mac.h   |   3 -
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |   1 -
 6 files changed, 110 insertions(+), 101 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index a02e97665463..859b6c5c4117 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -582,3 +582,108 @@ void mt76x02_mac_setaddr(struct mt76_dev *dev, u8 *addr)
 		  FIELD_PREP(MT_MAC_ADDR_DW1_U2ME_MASK, 0xff));
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_setaddr);
+
+static int
+mt76x02_mac_get_rssi(struct mt76x02_dev *dev, s8 rssi, int chain)
+{
+	struct mt76x02_rx_freq_cal *cal = &dev->cal.rx;
+
+	rssi += cal->rssi_offset[chain];
+	rssi -= cal->lna_gain;
+
+	return rssi;
+}
+
+int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
+			   void *rxi)
+{
+	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
+	struct mt76x02_rxwi *rxwi = rxi;
+	struct mt76x02_sta *sta;
+	u32 rxinfo = le32_to_cpu(rxwi->rxinfo);
+	u32 ctl = le32_to_cpu(rxwi->ctl);
+	u16 rate = le16_to_cpu(rxwi->rate);
+	u16 tid_sn = le16_to_cpu(rxwi->tid_sn);
+	bool unicast = rxwi->rxinfo & cpu_to_le32(MT_RXINFO_UNICAST);
+	int i, pad_len = 0, nstreams = dev->mt76.chainmask & 0xf;
+	s8 signal;
+	u8 pn_len;
+	u8 wcid;
+	int len;
+
+	if (!test_bit(MT76_STATE_RUNNING, &dev->mt76.state))
+		return -EINVAL;
+
+	if (rxinfo & MT_RXINFO_L2PAD)
+		pad_len += 2;
+
+	if (rxinfo & MT_RXINFO_DECRYPT) {
+		status->flag |= RX_FLAG_DECRYPTED;
+		status->flag |= RX_FLAG_MMIC_STRIPPED;
+		status->flag |= RX_FLAG_MIC_STRIPPED;
+		status->flag |= RX_FLAG_IV_STRIPPED;
+	}
+
+	wcid = FIELD_GET(MT_RXWI_CTL_WCID, ctl);
+	sta = mt76x02_rx_get_sta(&dev->mt76, wcid);
+	status->wcid = mt76x02_rx_get_sta_wcid(sta, unicast);
+
+	len = FIELD_GET(MT_RXWI_CTL_MPDU_LEN, ctl);
+	pn_len = FIELD_GET(MT_RXINFO_PN_LEN, rxinfo);
+	if (pn_len) {
+		int offset = ieee80211_get_hdrlen_from_skb(skb) + pad_len;
+		u8 *data = skb->data + offset;
+
+		status->iv[0] = data[7];
+		status->iv[1] = data[6];
+		status->iv[2] = data[5];
+		status->iv[3] = data[4];
+		status->iv[4] = data[1];
+		status->iv[5] = data[0];
+
+		/*
+		 * Driver CCMP validation can't deal with fragments.
+		 * Let mac80211 take care of it.
+		 */
+		if (rxinfo & MT_RXINFO_FRAG) {
+			status->flag &= ~RX_FLAG_IV_STRIPPED;
+		} else {
+			pad_len += pn_len << 2;
+			len -= pn_len << 2;
+		}
+	}
+
+	mt76x02_remove_hdr_pad(skb, pad_len);
+
+	if ((rxinfo & MT_RXINFO_BA) && !(rxinfo & MT_RXINFO_NULL))
+		status->aggr = true;
+
+	if (WARN_ON_ONCE(len > skb->len))
+		return -EINVAL;
+
+	pskb_trim(skb, len);
+
+	status->chains = BIT(0);
+	signal = mt76x02_mac_get_rssi(dev, rxwi->rssi[0], 0);
+	for (i = 1; i < nstreams; i++) {
+		status->chains |= BIT(i);
+		status->chain_signal[i] = mt76x02_mac_get_rssi(dev,
+							       rxwi->rssi[i],
+							       i);
+		signal = max_t(s8, signal, status->chain_signal[i]);
+	}
+	status->signal = signal;
+	status->freq = dev->mt76.chandef.chan->center_freq;
+	status->band = dev->mt76.chandef.chan->band;
+
+	status->tid = FIELD_GET(MT_RXWI_TID, tid_sn);
+	status->seqno = FIELD_GET(MT_RXWI_SN, tid_sn);
+
+	if (sta) {
+		ewma_signal_add(&sta->rssi, status->signal);
+		sta->inactive_count = 0;
+	}
+
+	return mt76x02_mac_process_rate(status, rate);
+}
+EXPORT_SYMBOL_GPL(mt76x02_mac_process_rx);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 8788c54c6c3d..857ab2308e8b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -20,6 +20,8 @@
 
 #include <linux/average.h>
 
+struct mt76x02_dev;
+
 struct mt76x02_tx_status {
 	u8 valid:1;
 	u8 success:1;
@@ -195,6 +197,8 @@ bool mt76x02_mac_load_tx_status(struct mt76_dev *dev,
 			       struct mt76x02_tx_status *stat);
 void mt76x02_send_tx_status(struct mt76_dev *dev,
 			   struct mt76x02_tx_status *stat, u8 *update);
+int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
+			   void *rxi);
 int
 mt76x02_mac_process_rate(struct mt76_rx_status *status, u16 rate);
 void mt76x02_mac_setaddr(struct mt76_dev *dev, u8 *addr);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/common.c b/drivers/net/wireless/mediatek/mt76/mt76x2/common.c
index eb9861f89e1a..d953c65cac80 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/common.c
@@ -32,7 +32,7 @@ void mt76x2_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 	}
 
 	skb_pull(skb, sizeof(struct mt76x02_rxwi));
-	if (mt76x2_mac_process_rx(dev, skb, rxwi)) {
+	if (mt76x02_mac_process_rx(dev, skb, rxwi)) {
 		dev_kfree_skb(skb);
 		return;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
index 7aefe72fc506..9ebb219d63ae 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
@@ -53,99 +53,3 @@ void mt76x2_mac_stop(struct mt76x02_dev *dev, bool force)
 	mt76_wr(dev, MT_TX_RTS_CFG, rts_cfg);
 }
 EXPORT_SYMBOL_GPL(mt76x2_mac_stop);
-
-int mt76x2_mac_get_rssi(struct mt76x02_dev *dev, s8 rssi, int chain)
-{
-	struct mt76x02_rx_freq_cal *cal = &dev->cal.rx;
-
-	rssi += cal->rssi_offset[chain];
-	rssi -= cal->lna_gain;
-
-	return rssi;
-}
-
-int mt76x2_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
-			  void *rxi)
-{
-	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
-	struct mt76x02_rxwi *rxwi = rxi;
-	struct mt76x02_sta *sta;
-	u32 rxinfo = le32_to_cpu(rxwi->rxinfo);
-	u32 ctl = le32_to_cpu(rxwi->ctl);
-	u16 rate = le16_to_cpu(rxwi->rate);
-	u16 tid_sn = le16_to_cpu(rxwi->tid_sn);
-	bool unicast = rxwi->rxinfo & cpu_to_le32(MT_RXINFO_UNICAST);
-	int pad_len = 0;
-	u8 pn_len;
-	u8 wcid;
-	int len;
-
-	if (!test_bit(MT76_STATE_RUNNING, &dev->mt76.state))
-		return -EINVAL;
-
-	if (rxinfo & MT_RXINFO_L2PAD)
-		pad_len += 2;
-
-	if (rxinfo & MT_RXINFO_DECRYPT) {
-		status->flag |= RX_FLAG_DECRYPTED;
-		status->flag |= RX_FLAG_MMIC_STRIPPED;
-		status->flag |= RX_FLAG_MIC_STRIPPED;
-		status->flag |= RX_FLAG_IV_STRIPPED;
-	}
-
-	wcid = FIELD_GET(MT_RXWI_CTL_WCID, ctl);
-	sta = mt76x02_rx_get_sta(&dev->mt76, wcid);
-	status->wcid = mt76x02_rx_get_sta_wcid(sta, unicast);
-
-	len = FIELD_GET(MT_RXWI_CTL_MPDU_LEN, ctl);
-	pn_len = FIELD_GET(MT_RXINFO_PN_LEN, rxinfo);
-	if (pn_len) {
-		int offset = ieee80211_get_hdrlen_from_skb(skb) + pad_len;
-		u8 *data = skb->data + offset;
-
-		status->iv[0] = data[7];
-		status->iv[1] = data[6];
-		status->iv[2] = data[5];
-		status->iv[3] = data[4];
-		status->iv[4] = data[1];
-		status->iv[5] = data[0];
-
-		/*
-		 * Driver CCMP validation can't deal with fragments.
-		 * Let mac80211 take care of it.
-		 */
-		if (rxinfo & MT_RXINFO_FRAG) {
-			status->flag &= ~RX_FLAG_IV_STRIPPED;
-		} else {
-			pad_len += pn_len << 2;
-			len -= pn_len << 2;
-		}
-	}
-
-	mt76x02_remove_hdr_pad(skb, pad_len);
-
-	if ((rxinfo & MT_RXINFO_BA) && !(rxinfo & MT_RXINFO_NULL))
-		status->aggr = true;
-
-	if (WARN_ON_ONCE(len > skb->len))
-		return -EINVAL;
-
-	pskb_trim(skb, len);
-	status->chains = BIT(0) | BIT(1);
-	status->chain_signal[0] = mt76x2_mac_get_rssi(dev, rxwi->rssi[0], 0);
-	status->chain_signal[1] = mt76x2_mac_get_rssi(dev, rxwi->rssi[1], 1);
-	status->signal = max(status->chain_signal[0], status->chain_signal[1]);
-	status->freq = dev->mt76.chandef.chan->center_freq;
-	status->band = dev->mt76.chandef.chan->band;
-
-	status->tid = FIELD_GET(MT_RXWI_TID, tid_sn);
-	status->seqno = FIELD_GET(MT_RXWI_SN, tid_sn);
-
-	if (sta) {
-		ewma_signal_add(&sta->rssi, status->signal);
-		sta->inactive_count = 0;
-	}
-
-	return mt76x02_mac_process_rate(status, rate);
-}
-EXPORT_SYMBOL_GPL(mt76x2_mac_process_rx);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
index db36232277cd..f1077f96a8a4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
@@ -46,9 +46,6 @@ void mt76x2_mac_stop(struct mt76x02_dev *dev, bool force);
 void mt76x2_mac_resume(struct mt76x02_dev *dev);
 void mt76x2_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr);
 
-int mt76x2_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
-			  void *rxi);
-
 int mt76x2_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
 			  struct sk_buff *skb);
 void mt76x2_mac_set_beacon_enable(struct mt76x02_dev *dev, u8 vif_idx, bool val);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index b4de10b7b31e..238cbf1eb14c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -74,7 +74,6 @@ void mt76x2_phy_set_antenna(struct mt76x02_dev *dev);
 int mt76x2_phy_start(struct mt76x02_dev *dev);
 int mt76x2_phy_set_channel(struct mt76x02_dev *dev,
 			   struct cfg80211_chan_def *chandef);
-int mt76x2_mac_get_rssi(struct mt76x02_dev *dev, s8 rssi, int chain);
 void mt76x2_phy_calibrate(struct work_struct *work);
 void mt76x2_phy_set_txpower(struct mt76x02_dev *dev);
 
-- 
2.19.0

