Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 793F1C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4410821547
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4410821547
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbeI1SCs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 14:02:48 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33488 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729561AbeI1SCr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 14:02:47 -0400
Received: by mail-wm1-f68.google.com with SMTP id r1-v6so1654676wmh.0
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 04:39:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kdBuwh4yu5Y0OANoSxnkHMpwhwZo8F3wWuY4G0ZeVxI=;
        b=IG5NFxZWYrVVMYmWzUE271LH4119XxY6CDj9PBGhoSyxTFEVAWv+Dc9JLZNu5l23k5
         5z/Su754G+16FPu3s+/B/4cB00+qndUZBZwtYEMSSVxQLz9nFPpS6+XaIuyb1twNWXdD
         PnFnsE19hwT9jhWfX/PJqLBJJH682PMyRBpZKevlGf4UCmP3j5aUq2Q96LlTcDhvGKOI
         Q4mnSwHPjdU1EOLpk3rJ9TZ38jpglz6fiaAqdhm7JOVi/JatP4KY0PlX4DcZv92RloVp
         mozv9VLcwVW5IgKrOhc35SMLvyGlWUkjZTpEnPaFieWGtWhe0QbX7iA/N2Qbh5tMHd7d
         73ng==
X-Gm-Message-State: ABuFfoizHfczsW/ITsJLypNL3ln42tEszd8N/ZSdOywKTwYdo2U68ri5
        4DlKmhdHzFlZ9QkLQTZVkO2elQ==
X-Google-Smtp-Source: ACcGV60HmlLs+WZCU7TjWWvPaUAQzjbaq4a2NvygKRETaSBi89mgvHgzbD1DRaoOVfp3Pd2L0AzKEg==
X-Received: by 2002:a1c:790:: with SMTP id 138-v6mr491523wmh.122.1538134764351;
        Fri, 28 Sep 2018 04:39:24 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s10-v6sm2395655wmd.22.2018.09.28.04.39.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:39:23 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 08/24] mt76: move mt76x2_wait_for_bbp in mt76x02-lib module
Date:   Fri, 28 Sep 2018 13:38:51 +0200
Message-Id: <637c9eb21aff70081f0fd91a98c5cff05792de03.1538134522.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
References: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x2_wait_for_bbp utility routine in mt76x02_util.h
in order to be resued by mt76x0 driver. Morover rename it in
mt76x02_wait_for_txrx_idle

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h | 8 ++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2.h       | 7 -------
 drivers/net/wireless/mediatek/mt76/mt76x2u_init.c | 2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index 479e7ffcc951..cd9282194c97 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -66,4 +66,12 @@ static inline void mt76x02_irq_disable(struct mt76_dev *dev, u32 mask)
 	mt76x02_set_irq_mask(dev, mask, 0);
 }
 
+static inline bool
+mt76x02_wait_for_txrx_idle(struct mt76_dev *dev)
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
index 4eb3fe657bd2..788c36aa0f7d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
@@ -209,7 +209,7 @@ int mt76x2u_init_hardware(struct mt76x2_dev *dev)
 
 	mt76x2u_init_beacon_offsets(dev);
 
-	if (!mt76x2_wait_for_bbp(dev))
+	if (!mt76x02_wait_for_txrx_idle(&dev->mt76))
 		return -ETIMEDOUT;
 
 	/* reset wcid table */
-- 
2.17.1

