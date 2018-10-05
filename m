Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C8BC65BA9
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D53D20652
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:28:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D53D20652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbeJEP01 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:26:27 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34276 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbeJEP01 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 11:26:27 -0400
Received: by mail-wr1-f67.google.com with SMTP id z4-v6so12627810wrb.1
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2018 01:28:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gf3NnOy3zhv0zdLjKukT4kjkDGqN4hY6C+Oz7gbSTGk=;
        b=RviFM2GteFg73pdtlvalDRh08IqxoDlvPMQezEfth1cpBRfFEbaIBxEnrZDbO8XOlC
         sRf5AJi5K8hrM0T63UKOpKr+HGqJW0Lz2hYuXIDp7hqOvkToTmuiFryc/HSHJCCdOQQy
         wg74Uk7WZnNfuImrT5E6hAsvahoHK0kEnfbFkhjPwu2luL/rXx9JASl6l5xoT+q66Aw6
         zP1JL9sTE3pPfJQvGb9gYS2THzASTlcRQaukYawXCvto2NXAS+z5bOjAILMcmqgWj6u1
         9Ic566hhSAg98rOPhalnJkoYcbl3Kx64X3nQmdgmZgV/1JzYjYdLtl0xug0XyWP1jJVs
         ad4g==
X-Gm-Message-State: ABuFfohnAB92EoOWBTBZdVcem/EmvWzJrNIJkYsDH0IXvcN0YpP32TjZ
        2LnvYDSapLKLqT48QSHC+mLYGVk+oIU=
X-Google-Smtp-Source: ACcGV62P3ecVFnnuAjKj0OjKDtRbSN0QZCStriyZ/nuywrqInI5adtt3u0QWrJa9Y5tRkAD2+kL2Tw==
X-Received: by 2002:a5d:6551:: with SMTP id z17-v6mr7135559wrv.194.1538728126777;
        Fri, 05 Oct 2018 01:28:46 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 77-v6sm3630227wmv.6.2018.10.05.01.28.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Oct 2018 01:28:46 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/8] mt76: move mt76x02_tx_prepare_skb in mt76x02_txrx.c
Date:   Fri,  5 Oct 2018 10:28:32 +0200
Message-Id: <3f0c7b37beef55755f6d7cb6987a33e50b714858.1538726819.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538726819.git.lorenzo.bianconi@redhat.com>
References: <cover.1538726819.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_tx_prepare_skb routine in mt76x02-lib module in order
to be reused by mt76x0 driver in tx datapath

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  4 +++
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c | 32 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  4 ---
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_tx.c    | 31 ------------------
 5 files changed, 37 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index f7325ee10a1e..2905bd964dc2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -150,6 +150,10 @@ void mt76x02_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			  struct sk_buff *skb);
 void mt76x02_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		struct sk_buff *skb);
+int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
+			   struct sk_buff *skb, struct mt76_queue *q,
+			   struct mt76_wcid *wcid, struct ieee80211_sta *sta,
+			   u32 *tx_info);
 
 extern const u16 mt76x02_beacon_offsets[16];
 void mt76x02_set_beacon_offsets(struct mt76_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
index ebd61c0e40c5..ab7877a07b6c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
@@ -187,3 +187,35 @@ bool mt76x02_tx_status_data(struct mt76_dev *dev, u8 *update)
 	return true;
 }
 EXPORT_SYMBOL_GPL(mt76x02_tx_status_data);
+
+int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
+			   struct sk_buff *skb, struct mt76_queue *q,
+			   struct mt76_wcid *wcid, struct ieee80211_sta *sta,
+			   u32 *tx_info)
+{
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	int qsel = MT_QSEL_EDCA;
+	int ret;
+
+	if (q == &dev->mt76.q_tx[MT_TXQ_PSD] && wcid && wcid->idx < 128)
+		mt76x02_mac_wcid_set_drop(&dev->mt76, wcid->idx, false);
+
+	mt76x02_mac_write_txwi(mdev, txwi, skb, wcid, sta, skb->len);
+
+	ret = mt76x02_insert_hdr_pad(skb);
+	if (ret < 0)
+		return ret;
+
+	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
+		qsel = MT_QSEL_MGMT;
+
+	*tx_info = FIELD_PREP(MT_TXD_INFO_QSEL, qsel) |
+		   MT_TXD_INFO_80211;
+
+	if (!wcid || wcid->hw_key_idx == 0xff || wcid->sw_iv)
+		*tx_info |= MT_TXD_INFO_WIV;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76x02_tx_prepare_skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index 26c1a24c4a2d..e29ce8d23a4f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -86,10 +86,6 @@ void mt76x2_dma_cleanup(struct mt76x02_dev *dev);
 
 void mt76x2_cleanup(struct mt76x02_dev *dev);
 
-int mt76x2_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
-			  struct sk_buff *skb, struct mt76_queue *q,
-			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
-			  u32 *tx_info);
 void mt76x2_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 			    struct mt76_queue_entry *e, bool flush);
 void mt76x2_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 194181275611..055c90b1e522 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -355,7 +355,7 @@ struct mt76x02_dev *mt76x2_alloc_device(struct device *pdev)
 	static const struct mt76_driver_ops drv_ops = {
 		.txwi_size = sizeof(struct mt76x02_txwi),
 		.update_survey = mt76x2_update_channel,
-		.tx_prepare_skb = mt76x2_tx_prepare_skb,
+		.tx_prepare_skb = mt76x02_tx_prepare_skb,
 		.tx_complete_skb = mt76x2_tx_complete_skb,
 		.rx_skb = mt76x02_queue_rx_skb,
 		.rx_poll_complete = mt76x2_rx_poll_complete,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c
index cfc9d3d207df..3a2ec86d3e88 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c
@@ -22,37 +22,6 @@ struct beacon_bc_data {
 	struct sk_buff *tail[8];
 };
 
-int mt76x2_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
-			  struct sk_buff *skb, struct mt76_queue *q,
-			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
-			  u32 *tx_info)
-{
-	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int qsel = MT_QSEL_EDCA;
-	int ret;
-
-	if (q == &dev->mt76.q_tx[MT_TXQ_PSD] && wcid && wcid->idx < 128)
-		mt76x02_mac_wcid_set_drop(&dev->mt76, wcid->idx, false);
-
-	mt76x02_mac_write_txwi(mdev, txwi, skb, wcid, sta, skb->len);
-
-	ret = mt76x02_insert_hdr_pad(skb);
-	if (ret < 0)
-		return ret;
-
-	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
-		qsel = MT_QSEL_MGMT;
-
-	*tx_info = FIELD_PREP(MT_TXD_INFO_QSEL, qsel) |
-		   MT_TXD_INFO_80211;
-
-	if (!wcid || wcid->hw_key_idx == 0xff || wcid->sw_iv)
-		*tx_info |= MT_TXD_INFO_WIV;
-
-	return 0;
-}
-
 static void
 mt76x2_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 {
-- 
2.17.1

