Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F8D5C46463
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FF302085B
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3FF302085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbeJKQSq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 12:18:46 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40890 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbeJKQSp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 12:18:45 -0400
Received: by mail-wm1-f67.google.com with SMTP id z204-v6so8510824wmc.5
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2018 01:52:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D/YmYOAVr/RO6b56NB6/u7RzOApU4JVjt8zBK+ZR/Lo=;
        b=aj8n1d/7esO6bZBurYmHcCvHpdyRY3g7EcL61jjyFPoyYe4kH0KgFgSPol+R4BbNV9
         yrBId5ZvuDd23DdrRsoYpFrhRUGhTyV+eqiHsbOEVk9rTkp+0J1bmYSAUmwaX0tjdJpk
         2JHiWmDtD1A1o7uNK3rcR1dc1oNnMDS59On0L05wkovzQe7/5VfjWbXrUY/EN23YeKe1
         As/TaEJNs71kRB+KtzT7Sol5PSz4zGbRI2N8v9V8Cc+J9RhRDb9zXAdpXdL5bgc8Kp5C
         bSFet5n+5VreKwD+V+MKc4TCC0JhDHrAGHVT9gQHCG6muDUOE9ZDag2X6QFVzOiLIHK0
         nbzw==
X-Gm-Message-State: ABuFfojqPMv+Jq4LptTR8MrKONEJP/Ucgm9Kw3EXTSKqBb3F6gAItGeI
        wgE9qu1f5tLLdAL3jdp8D+w5nA==
X-Google-Smtp-Source: ACcGV61Dj0KGyt3H8NB6je5TAG7QYUWtX88/lAId9QFbNHbnUrezmdetmot7NMwzfnQbFbFx8oWxdA==
X-Received: by 2002:a1c:6783:: with SMTP id b125-v6mr890225wmc.142.1539247945503;
        Thu, 11 Oct 2018 01:52:25 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id v184-v6sm950839wme.3.2018.10.11.01.52.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 01:52:24 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 03/12] mt76x0: pci: rename mt76x0_phy_calibrate
Date:   Thu, 11 Oct 2018 10:52:00 +0200
Message-Id: <e9c09f3bb47da9cff85487d99fe47cbb7bdd65d5.1539247493.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539247493.git.lorenzo.bianconi@redhat.com>
References: <cover.1539247493.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rename mt76x0_phy_calibrate routine in mt76x0_phy_calibration_work
in order to not collide with calibration routine for mt76x0e

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 638a2bca5cff..9a8e1fcee26b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -787,7 +787,7 @@ static void mt76x0_dynamic_vga_tuning(struct mt76x02_dev *dev)
 	mt76_wr(dev, MT_BBP(AGC,8), val);
 }
 
-static void mt76x0_phy_calibrate(struct work_struct *work)
+static void mt76x0_phy_calibration_work(struct work_struct *work)
 {
 	struct mt76x02_dev *dev = container_of(work, struct mt76x02_dev,
 					       cal_work.work);
@@ -854,7 +854,7 @@ static void mt76x0_rf_init(struct mt76x02_dev *dev)
 
 void mt76x0_phy_init(struct mt76x02_dev *dev)
 {
-	INIT_DELAYED_WORK(&dev->cal_work, mt76x0_phy_calibrate);
+	INIT_DELAYED_WORK(&dev->cal_work, mt76x0_phy_calibration_work);
 
 	mt76x0_rf_init(dev);
 	mt76x02_phy_set_rxpath(dev);
-- 
2.17.2

