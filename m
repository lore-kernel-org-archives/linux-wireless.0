Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E1DC004D5
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEE8A2156B
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEE8A2156B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbeI0PTa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:19:30 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40623 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbeI0PTa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:19:30 -0400
Received: by mail-wm1-f68.google.com with SMTP id o2-v6so5105570wmh.5
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:02:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mc5PylOLLOTRNMAvATNFmxZA26bSkjNftQl2lypJK6w=;
        b=KGy1oFwrM2jaaTLgCt0sETBBAUjhc+VD3iP0yU3Cfx/FE8x5qMa2bCVY1MGaymM+an
         JSmEK9qrbVfxxcwXaXNLInW/9wA00HnAuOBCIEPGhdcabJdqIHj0FqCQYsCt5A5TsNwi
         YTTw89DGBRrUe8KXyMW3DfnSbBbDq47O3PsWMCqRk2fKQhQDWlbmz5EfZv6rL0RNL4xi
         zZ+vzoBGEZ0YPpva73JNNY9lCLMXUPGYrM9yjPBsNbwOTxjotAa5FwG8oby128/LL8cy
         SHpNXLb6JrSY1kAmYseQDp/JWdxcocRDXpDHdnbAUbcAS3F1aBsNFirgHRuU2Z2OwWHh
         /VOw==
X-Gm-Message-State: ABuFfoi/1Q1Kpooun6SJbRshkKA/7KEIeGAwLZXjCXoapzCk9QD+4aIx
        52ZULWILlAleoHFjBtAOywgJDQ==
X-Google-Smtp-Source: ACcGV62HeuRVJpV2Ac9ek1FgF0p4n4/w2leKtWlVcb/w7vp/XmzTLnZv5asVRavKNXoNAEy53HfsVg==
X-Received: by 2002:a1c:908b:: with SMTP id s133-v6mr6780081wmd.69.1538038936481;
        Thu, 27 Sep 2018 02:02:16 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a17-v6sm1802382wme.40.2018.09.27.02.02.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 02:02:15 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 15/26] mt76x0: init: reset beacon offset during bootstrap
Date:   Thu, 27 Sep 2018 11:01:44 +0200
Message-Id: <758cdeb9c4ab95c01a79dfc44e53f50b631948a2.1538036134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add beacon offset reset in mt76x0e_init_hardware routine

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 03211fd0db33..6600ee046800 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -345,7 +345,7 @@ EXPORT_SYMBOL_GPL(mt76x0_mac_stop);
 
 int mt76x0_init_hardware(struct mt76x0_dev *dev)
 {
-	int ret;
+	int ret, i, j, beacon_len;
 
 	if (!mt76x02_wait_for_wpdma(&dev->mt76, 1000))
 		return -EIO;
@@ -385,6 +385,12 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 					     MT_BEACON_TIME_CFG_TBTT_EN |
 					     MT_BEACON_TIME_CFG_BEACON_TX));
 
+	beacon_len = mt76x02_beacon_offsets[1] - mt76x02_beacon_offsets[0];
+	for (i = 0; i < 8; i++) {
+		for (j = 0; j < beacon_len; j += 4)
+			mt76_wr(dev, mt76x02_beacon_offsets[i] + j, 0);
+	}
+
 	mt76x0_reset_counters(dev);
 
 	mt76_rmw(dev, MT_US_CYC_CFG, MT_US_CYC_CNT, 0x1e);
-- 
2.17.1

