Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD01C65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 12:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B8B82075C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 12:40:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B8B82075C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbeJHTwV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 15:52:21 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43553 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbeJHTwV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 15:52:21 -0400
Received: by mail-wr1-f65.google.com with SMTP id n1-v6so20659109wrt.10
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2018 05:40:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=t3bht0Ilo+ZRwLnjk8UIXXy1z9gbC2orYCNe3TFCYJg=;
        b=nIEj6QRNryOV18BAJEegSWBQ7s3ohFZby8fHX40r9Jz+cvuDGmu6g0Kw8rJriTEbHM
         N9KV0aglpZXKmvAH4NBu0p6GQ003LG8zkW2e4y7z4MHVqkj9e3wGt4e7vlYxtvqrsJnn
         M5m5uNMlpN6XgXUWcmre0y8/fvtKZhCcxzqG/GTIBmALUtJlxLWd+NHfLFEFfyIxxDyT
         P5Hx2mPcAl9OEAdsF4AgOZZZINug8w53fmHhBZy4VRlphzLFWSrV+JRIk2rkIIiuhn6b
         0tTDYCT7/+sht7YiJLYGH4QTMpeakPpvzOpUAX9DYP6e3Qt7rEoGthwsc0dnLnbaLzAc
         h4ZA==
X-Gm-Message-State: ABuFfog9aJ/rvmGpQoypH5OwJ2Qt2y5/Mqy4quDJClyfM2JO8CrQNAqW
        VfC+nk/OwygfJoEk2SbUXTKk7g==
X-Google-Smtp-Source: ACcGV62ou/dZ5IKYVvg/lahsn8o5WQ7CqvMuPMOFKKwo+MzZBTpMbrXJCbrvcc0ZvnPB35HJiqXcQQ==
X-Received: by 2002:a5d:548e:: with SMTP id h14-v6mr16562854wrv.316.1539002447849;
        Mon, 08 Oct 2018 05:40:47 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id o63-v6sm13598671wmd.3.2018.10.08.05.40.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Oct 2018 05:40:46 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: phy: fix restore phase in mt76x0_phy_recalibrate_after_assoc
Date:   Mon,  8 Oct 2018 14:40:31 +0200
Message-Id: <ff6672828b7e970124a425304ad734d58133a6ff.1539001391.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1539001391.git.lorenzo.bianconi@redhat.com>
References: <cover.1539001391.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix restore value configured in 0x2124 register in
mt76x0_phy_recalibrate_after_assoc routine.

Fixes: 10de7a8b4ab9 ("mt76x0: phy files")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 99e0a91a2f99..d18942e54048 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -734,8 +734,7 @@ void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev)
 	usleep_range(500, 700);
 
 	reg_val = mt76_rr(dev, 0x2124);
-	reg_val &= 0xffffff7e;
-	mt76_wr(dev, 0x2124, reg_val);
+	mt76_wr(dev, 0x2124, 0xffffff7e);
 
 	mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 0, false);
 
-- 
2.17.1

