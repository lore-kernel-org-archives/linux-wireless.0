Return-Path: <SRS0=a98u=MM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A16C64EB0
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 09:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51C412082A
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 09:57:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51C412082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbeI3Q3j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 30 Sep 2018 12:29:39 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39971 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbeI3Q3i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Sep 2018 12:29:38 -0400
Received: by mail-wm1-f67.google.com with SMTP id o2-v6so5848972wmh.5
        for <linux-wireless@vger.kernel.org>; Sun, 30 Sep 2018 02:57:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KhhjvpUPh/h66QeDyWTaZLjR2x4hx2Lf8/v5m9kQ/as=;
        b=Kfy5hHvf9N8EYhQlsd5SUxiI4p2LYwjG5VGz71tmIybZFWB9d3abqLUBQP2FVgcq00
         L6UWhlq1X7qKnrGuXJWnodUnBy99hwRLO7tEHxraZw2wWd7LnQI1M15HcoYn3Tb0lR+a
         ll2mE9yC6g5cgzMU10ASyVQKVJh9mnnHjVu7CloYx7S9NErxEk8sx8bZ7PIQ298FqO2p
         mK3r0yxZHjbw0bO59JK9Un4UZ/UZEtDDqpRWQqa9otFTTkujV5ryYMkCYnhmoCJ9Rc5c
         GYX69K/+4I6uU9BDjjR8LXnKQpwr0q1BKUkiSxSquEvyKyfuu31P/ml+yR8pDmmz1yWL
         X6RA==
X-Gm-Message-State: ABuFfoj9BG2ZUCx2UNOuM/jo7qVOGXRgoHUO71bZGbJ8MkTB5HHeQxgi
        cXn5tkoV2J4R3At2Bw50/7Xgx7MYSm4=
X-Google-Smtp-Source: ACcGV60qoPeSIlfQQxiGMTfzSF+Zx+05L+Ce/yIelFUKB/Y0XHdCcR+z+x0/gQ0nxFNxypwtodBOZA==
X-Received: by 2002:a1c:eb03:: with SMTP id j3-v6mr6081801wmh.150.1538301436705;
        Sun, 30 Sep 2018 02:57:16 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id 12-v6sm4898375wms.11.2018.09.30.02.57.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Sep 2018 02:57:16 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 02/10] mt76: move mt76x02_rx_get_sta and mt76x02_rx_get_sta_wcid in mt76x02_util.c
Date:   Sun, 30 Sep 2018 11:56:58 +0200
Message-Id: <20180930095706.28428-3-lorenzo.bianconi@redhat.com>
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

