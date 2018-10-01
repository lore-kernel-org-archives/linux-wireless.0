Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83CDC00449
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 22:19:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89973208AE
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 22:19:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89973208AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbeJBE7X (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 00:59:23 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38572 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbeJBE7X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 00:59:23 -0400
Received: by mail-wr1-f65.google.com with SMTP id a13-v6so4965508wrt.5
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 15:19:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KhhjvpUPh/h66QeDyWTaZLjR2x4hx2Lf8/v5m9kQ/as=;
        b=r72LaITApVdK7XEX5K7gGIh2gfjIts8TA/g94r+pxgMRTn80J7nBh23k3A+iShaOJo
         RUBQO2VF5eQGRo0Rg7sWKIpmD1Ml++X7ko6HSUJIu5MenMzn1rul9GvsqQ6v9xjhTDng
         V2FDF4fEpKQnEOMLROE0AXjQ08t5gJytmxf7ygIaTNu0xpjHilUwRQef6w8WAOzcQFYQ
         pLwskcy/MG+rfThazIc2AyDegFQw/rFhqP/Z2Qdb/Jsfq7xQ+wIn4ZtSYHykTkEV0sfb
         ad1ZyGsBJYyetna1JEwNoIJGb4bp/eoTe8X+BDNimgyk02b+Uilis4jvN1XTgd9mL3s7
         HAlw==
X-Gm-Message-State: ABuFfog+7NbKwNJB9YGDMlmMt7p296eeE+3sXIop2duC8ULFxP6/uQF8
        dO6XiH5VbF3F6GkMFXPIhRUQSA==
X-Google-Smtp-Source: ACcGV61yq0o2xqNMGeNsoKZzoMFSS+Um7+KqNBYGsib0sHrp0Kvds9yDFb1ePpC0XJtm30cr9HdgEA==
X-Received: by 2002:adf:80c7:: with SMTP id 65-v6mr3888346wrl.57.1538432363671;
        Mon, 01 Oct 2018 15:19:23 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id t4-v6sm9203420wrb.45.2018.10.01.15.19.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Oct 2018 15:19:23 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 02/10] mt76: move mt76x02_rx_get_sta and mt76x02_rx_get_sta_wcid in mt76x02_util.c
Date:   Tue,  2 Oct 2018 00:19:00 +0200
Message-Id: <20181001221908.16005-3-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_rx_get_sta and mt76x02_rx_get_sta_wcid utility routines in
mt76x02-lib module since it will be used by mt76x0 driver in order to
unify rxwi parsing

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 29 +++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_util.h |  3 ++
 .../net/wireless/mediatek/mt76/mt76x2/mac.c   | 32 ++-----------------
 3 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index b12db0a108d3..496be05e59a6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -531,4 +531,33 @@ void mt76x02_set_beacon_offsets(struct mt76_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76x02_set_beacon_offsets);
 
+struct mt76x02_sta *
+mt76x02_rx_get_sta(struct mt76_dev *dev, u8 idx)
+{
+	struct mt76_wcid *wcid;
+
+	if (idx >= ARRAY_SIZE(dev->wcid))
+		return NULL;
+
+	wcid = rcu_dereference(dev->wcid[idx]);
+	if (!wcid)
+		return NULL;
+
+	return container_of(wcid, struct mt76x02_sta, wcid);
+}
+EXPORT_SYMBOL_GPL(mt76x02_rx_get_sta);
+
+struct mt76_wcid *
+mt76x02_rx_get_sta_wcid(struct mt76x02_sta *sta, bool unicast)
+{
+	if (!sta)
+		return NULL;
+
+	if (unicast)
+		return &sta->wcid;
+	else
+		return &sta->vif->group_wcid;
+}
+EXPORT_SYMBOL_GPL(mt76x02_rx_get_sta_wcid);
+
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index 54cec0cbf645..5ad8f5c458c4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -53,6 +53,9 @@ void mt76x02_tx_complete(struct mt76_dev *dev, struct sk_buff *skb);
 void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 			    struct mt76_queue_entry *e, bool flush);
 bool mt76x02_tx_status_data(struct mt76_dev *dev, u8 *update);
+struct mt76x02_sta *mt76x02_rx_get_sta(struct mt76_dev *dev, u8 idx);
+struct mt76_wcid *
+mt76x02_rx_get_sta_wcid(struct mt76x02_sta *sta, bool unicast);
 
 extern const u16 mt76x02_beacon_offsets[16];
 void mt76x02_set_beacon_offsets(struct mt76_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
index c98ce1582aec..93bf8a9404b1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
@@ -64,34 +64,6 @@ int mt76x2_mac_get_rssi(struct mt76x2_dev *dev, s8 rssi, int chain)
 	return rssi;
 }
 
-static struct mt76x02_sta *
-mt76x2_rx_get_sta(struct mt76x2_dev *dev, u8 idx)
-{
-	struct mt76_wcid *wcid;
-
-	if (idx >= ARRAY_SIZE(dev->mt76.wcid))
-		return NULL;
-
-	wcid = rcu_dereference(dev->mt76.wcid[idx]);
-	if (!wcid)
-		return NULL;
-
-	return container_of(wcid, struct mt76x02_sta, wcid);
-}
-
-static struct mt76_wcid *
-mt76x2_rx_get_sta_wcid(struct mt76x2_dev *dev, struct mt76x02_sta *sta,
-		       bool unicast)
-{
-	if (!sta)
-		return NULL;
-
-	if (unicast)
-		return &sta->wcid;
-	else
-		return &sta->vif->group_wcid;
-}
-
 int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 			  void *rxi)
 {
@@ -122,8 +94,8 @@ int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 	}
 
 	wcid = FIELD_GET(MT_RXWI_CTL_WCID, ctl);
-	sta = mt76x2_rx_get_sta(dev, wcid);
-	status->wcid = mt76x2_rx_get_sta_wcid(dev, sta, unicast);
+	sta = mt76x02_rx_get_sta(&dev->mt76, wcid);
+	status->wcid = mt76x02_rx_get_sta_wcid(sta, unicast);
 
 	len = FIELD_GET(MT_RXWI_CTL_MPDU_LEN, ctl);
 	pn_len = FIELD_GET(MT_RXINFO_PN_LEN, rxinfo);
-- 
2.19.0

