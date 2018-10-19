Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81770ECDE43
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 10:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37F1C21479
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 10:47:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37F1C21479
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbeJSSxN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 14:53:13 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34426 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbeJSSxN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 14:53:13 -0400
Received: by mail-wm1-f68.google.com with SMTP id z25-v6so3798413wmf.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Oct 2018 03:47:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=m01p4PabOsNtFW0+i0Y4rGyvbucQsq86b+4edd8VvGU=;
        b=TSHoIE0ecc5ULApYvK+EvgSUm1eBKwQl0tVvQOkPFVbCY8NMjnCaM4UeSZjJ4y7aZG
         9aZUrKR6cJJOLDidbIGhYmjcT2vhxNs/SmpuRJ59vAPZh/X5wLmFEzzHwTHA/CRJ5V9Q
         nBxi6h8nsRs6m0qQVgqztkbBzVNGqwQw78yVXlm9klwIX+8PnDpfd24wpWZLqFCT2z9S
         VhSfjcAfWHyQ+fx7oEN1U7fCND2wVl9VLlt9GR65u7B20qh8EsJN6FmATMo5MKBLHn5V
         D2LAYvwe0f+MCpcW2P9ZMCVxUhB8hbzfLQ0ZZa+QjR2J5s5EEetcEI/4hyEGaQFxDJgS
         ZK3g==
X-Gm-Message-State: ABuFfojVf8oyI9q+XYEV9dD4wb0B27pB/AI6Cq8Mw+Wj4EYuxWACJ3MD
        nFv/t23K8QDiFTguwd4yHpJxAMEgqfA=
X-Google-Smtp-Source: ACcGV63d2WzPzeUSJD0fA2N/iEzkgpjvGHrrqywy6dIQsAPr1i9yYXTC8YaVxQr//hm9m7ZsTm+Hsg==
X-Received: by 2002:a1c:8085:: with SMTP id b127-v6mr4330792wmd.146.1539946060065;
        Fri, 19 Oct 2018 03:47:40 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id t194-v6sm2877847wmd.48.2018.10.19.03.47.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Oct 2018 03:47:39 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: mac: remove mt76x0_mac_set_ampdu_factor
Date:   Fri, 19 Oct 2018 12:47:35 +0200
Message-Id: <5c4f9d8ba71af1fc1a3eef5a78650c6e6e0e7f96.1539945926.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539945926.git.lorenzo.bianconi@redhat.com>
References: <cover.1539945926.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove no longer used mt76x0_mac_set_ampdu_factor routine

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/mac.c   | 25 -------------------
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  1 -
 2 files changed, 26 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 8cbdeb6d3dbe..57e15c8ced7e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -103,28 +103,3 @@ void mt76x0_mac_config_tsf(struct mt76x02_dev *dev, bool enable, int interval)
 		MT_BEACON_TIME_CFG_SYNC_MODE |
 		MT_BEACON_TIME_CFG_TBTT_EN;
 }
-
-void mt76x0_mac_set_ampdu_factor(struct mt76x02_dev *dev)
-{
-	struct ieee80211_sta *sta;
-	struct mt76_wcid *wcid;
-	void *msta;
-	u8 min_factor = 3;
-	int i;
-
-	rcu_read_lock();
-	for (i = 0; i < ARRAY_SIZE(dev->mt76.wcid); i++) {
-		wcid = rcu_dereference(dev->mt76.wcid[i]);
-		if (!wcid)
-			continue;
-
-		msta = container_of(wcid, struct mt76x02_sta, wcid);
-		sta = container_of(msta, struct ieee80211_sta, drv_priv);
-
-		min_factor = min(min_factor, sta->ht_cap.ampdu_factor);
-	}
-	rcu_read_unlock();
-
-	mt76_wr(dev, MT_MAX_LEN_CFG, 0xa0fff |
-		   FIELD_PREP(MT_MAX_LEN_CFG_AMPDU, min_factor));
-}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 1871ec98aefb..282814cbcc12 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -84,6 +84,5 @@ void mt76x0_mac_set_protection(struct mt76x02_dev *dev, bool legacy_prot,
 				int ht_mode);
 void mt76x0_mac_set_short_preamble(struct mt76x02_dev *dev, bool short_preamb);
 void mt76x0_mac_config_tsf(struct mt76x02_dev *dev, bool enable, int interval);
-void mt76x0_mac_set_ampdu_factor(struct mt76x02_dev *dev);
 
 #endif
-- 
2.17.2

