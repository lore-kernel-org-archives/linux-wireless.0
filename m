Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DB17C64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 21:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E26822084D
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 21:53:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E26822084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbeJEEsr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 00:48:47 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38186 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbeJEEsp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 00:48:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id a13-v6so11479524wrt.5
        for <linux-wireless@vger.kernel.org>; Thu, 04 Oct 2018 14:53:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rmQ4NvzbyG5umJDxg6tFpDxpK8DUQgGZ5rJPWMhfqWM=;
        b=a2+ZTNDe7Azyt7TmRTJQnkuXeiZa219qXzw7GuGY4i36mdilBd3m1/vtfjV9A7IeK0
         PL+GRUeFVQCBQWJHp6zvjCGHU58PbkTNf9NTkKuG98cMVYN+mBFG/VZFqIneOCAXZbco
         69hqC5kf5gCvMxFHC1aVk4u6UIIt+imfrYbJq3Uv/lv7Q1HUiE0GM49s0SUurwiyVIBg
         Dtqj19Q4okzh0CSwYUmXHZkCS9KPc2c/oPmn56jbklawu0OB1NsKgwIxnAXM6nIVoiV3
         FD9WLoZ9d9VeVtBMt+k/diX53TTeUZte5vXTyMzew9NfbEFn7PqaS/qca8/CF6ohwda4
         B8jA==
X-Gm-Message-State: ABuFfoiZvzu+4ZiAuTCUZEk4XZTyrEpK8PPOmmPBQj+KAN9PuW2jJ8SX
        yQ0Io5QEelTtx5aRJTGz1S6u/Q==
X-Google-Smtp-Source: ACcGV60Fv/c3QrEDFWSWyk/9Vu6N0m9n48uXRqAIVDp2QuZanz2SDOwGJTI3FhOQ/abPueGpePANtQ==
X-Received: by 2002:adf:81b5:: with SMTP id 50-v6mr5734590wra.10.1538690004066;
        Thu, 04 Oct 2018 14:53:24 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id e6-v6sm5696189wrc.70.2018.10.04.14.53.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Oct 2018 14:53:23 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 02/10] mt76: move mt76x02_rx_get_sta and mt76x02_rx_get_sta_wcid in mt76x02_util.h
Date:   Thu,  4 Oct 2018 23:53:04 +0200
Message-Id: <20181004215312.3094-3-lorenzo.bianconi@redhat.com>
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
 .../net/wireless/mediatek/mt76/mt76x02_util.h | 29 +++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x2/mac.c   | 32 ++-----------------
 2 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index 54cec0cbf645..f78526fcf423 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -18,6 +18,8 @@
 #ifndef __MT76X02_UTIL_H
 #define __MT76X02_UTIL_H
 
+#include "mt76x02_mac.h"
+
 extern struct ieee80211_rate mt76x02_rates[12];
 
 void mt76x02_configure_filter(struct ieee80211_hw *hw,
@@ -77,4 +79,31 @@ mt76x02_wait_for_txrx_idle(struct mt76_dev *dev)
 				0, 100);
 }
 
+static inline struct mt76x02_sta *
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
+
+static inline struct mt76_wcid *
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
+
 #endif
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

