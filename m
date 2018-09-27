Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F8D5C04E87
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7EB921580
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7EB921580
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbeI0PTY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:19:24 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45270 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727340AbeI0PTX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:19:23 -0400
Received: by mail-wr1-f68.google.com with SMTP id m16so1664762wrx.12
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:02:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uGxc7hsYVDcpYntF8gjLizJaOtsNZgb8lTo0SW3TY1o=;
        b=HZRJf88TgX9qYC7o+S4D5EDIG9rrDCex/G3VmdT8oe4U8/J03tTJgOu36GzRgoexLU
         mp1CvsG1X4dHRS9uRl8jqe+CEqOmNele5j34/05kZNWzM6Oi2CnFwYBqYbLlwsmnUGa9
         8egH7ksRoIV9t1o/AFo9pfaBHu+kiVUVOdvvP0Ins1tcRxz0E6UMS3oa/CL+7v6TEwvw
         bjxHHCUKEWyoEqdUOyqPxHGYuCXHz99lJIbZqnQ3nRoXXUZd+x8OVL/TbRLHglxQAETI
         hCUWScNeu0CWdIe8PuQY+USShL6ytxzBoXtRSEbnTDNciCA9evpZnb84VlG5IGiW8ZtO
         wh4Q==
X-Gm-Message-State: ABuFfojO/QmLbe05nsg3TCQOcUVl4Tj1MTe7uXTOYvQ/g6/z+ZJ9xt4Y
        jkMdunZCiVAqWp70Y4WKt48N0g==
X-Google-Smtp-Source: ACcGV62CfH7qJSyL0yaRWHs7f34zHorMIjs21ix5m/JKU6Pt0aLJHdB1qtI/1TW+kIM3G9EQ4yVuNg==
X-Received: by 2002:adf:f681:: with SMTP id v1-v6mr7981496wrp.201.1538038929683;
        Thu, 27 Sep 2018 02:02:09 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a17-v6sm1802382wme.40.2018.09.27.02.02.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 02:02:09 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 08/26] mt76: move mt76x2_wait_for_bbp in mt76x02-lib module
Date:   Thu, 27 Sep 2018 11:01:37 +0200
Message-Id: <abcc5b975da9d834067c45420397db4e3ff11e3b.1538036134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x2_wait_for_bbp utility routine in mt76x02_util.h
in order to be resued by mt76x0 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h | 7 +++++++
 drivers/net/wireless/mediatek/mt76/mt76x2.h       | 7 -------
 drivers/net/wireless/mediatek/mt76/mt76x2u_init.c | 2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index 479e7ffcc951..7ea77db99c01 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -66,4 +66,11 @@ static inline void mt76x02_irq_disable(struct mt76_dev *dev, u32 mask)
 	mt76x02_set_irq_mask(dev, mask, 0);
 }
 
+static inline bool mt76x02_wait_for_bbp(struct mt76_dev *dev)
+{
+	return __mt76_poll_msec(dev, MT_MAC_STATUS,
+				MT_MAC_STATUS_TX | MT_MAC_STATUS_RX,
+				0, 100);
+}
+
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index c51d6e2a64ce..9bf8be5ea1cd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -124,13 +124,6 @@ static inline bool mt76x2_channel_silent(struct mt76x2_dev *dev)
 		chan->dfs_state != NL80211_DFS_AVAILABLE);
 }
 
-static inline bool mt76x2_wait_for_bbp(struct mt76x2_dev *dev)
-{
-	return mt76_poll_msec(dev, MT_MAC_STATUS,
-			      MT_MAC_STATUS_TX | MT_MAC_STATUS_RX,
-			      0, 100);
-}
-
 extern const struct ieee80211_ops mt76x2_ops;
 
 struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
index 4eb3fe657bd2..57669c7999ce 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
@@ -209,7 +209,7 @@ int mt76x2u_init_hardware(struct mt76x2_dev *dev)
 
 	mt76x2u_init_beacon_offsets(dev);
 
-	if (!mt76x2_wait_for_bbp(dev))
+	if (!mt76x02_wait_for_bbp(&dev->mt76))
 		return -ETIMEDOUT;
 
 	/* reset wcid table */
-- 
2.17.1

