Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6A00C65BA7
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CDC220835
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:52:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CDC220835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbeJCRkj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 13:40:39 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37678 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726544AbeJCRkj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 13:40:39 -0400
Received: by mail-wm1-f66.google.com with SMTP id 185-v6so5168569wmt.2
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 03:52:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wll6P2h9sxl8LMKiwvb5DQelkbRPuFgjlIQkJ2BrnGc=;
        b=WRJz58ECIZs2aHVzQCBp+zwZS6Y9+XOSi8f7VVKEh9fMi3SguyxJlSO7vlWTs+CWTj
         578tDr66wpVcFQ8koiRXQ5KDiUVRN/olgE5aK67IsPBShpSg1w9H7kgthitOGxtEoNx+
         5hB1p6GjGenfqFqHNyx4rOmunJlsuIT061MTlhk6p0VsjakE5VhSDq7ou41eq7TiPqW8
         F7dccQD6XeoeYEWLb8dI5g1PilLltX09uyPRBrwt5S8lnf8BDgv8qwao1ktoXugKq1e2
         gicqBtyBmr/cEF++ImXVLHLx8GuAu9RBa0brQn4Dy1Zny3dxZgeFmjD6RqJPkJUG4nh1
         ZLkg==
X-Gm-Message-State: ABuFfojA2tl8t511YuYPuzP65iM90l2/ohFcItaGQnictz3BGQdhnqh/
        +Ku5o+/s0p4TMWheobgiP5olxUgi9vA=
X-Google-Smtp-Source: ACcGV60Du+wKLtaTzJElFGifXyEeHHq62My1sSHM2sFzh+0kybnV4CB2YyNToyg8zoYzoAZDzlbZiQ==
X-Received: by 2002:a7b:c017:: with SMTP id c23-v6mr1094435wmb.136.1538563966692;
        Wed, 03 Oct 2018 03:52:46 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id e67-v6sm1782486wmd.41.2018.10.03.03.52.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Oct 2018 03:52:46 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] mt76x0: usb: stop cal/mac workqueues at hw stop
Date:   Wed,  3 Oct 2018 12:52:26 +0200
Message-Id: <ea57d94db2c35de80d115a427a5bbeb2c4c16d6e.1538563675.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538563675.git.lorenzo.bianconi@redhat.com>
References: <cover.1538563675.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stop mac and calibration work stopping the hw even if the
device has been removed

Fixes: b11e19694dc9 ("mt76x0: add ieee80211_ops ops pointer to
mt76x0_alloc_device signature")

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index dd437e77009f..57862cacf22a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -86,14 +86,14 @@ static void mt76x0u_cleanup(struct mt76x0_dev *dev)
 
 static void mt76x0u_mac_stop(struct mt76x0_dev *dev)
 {
-	if (test_bit(MT76_REMOVED, &dev->mt76.state))
-		return;
-
 	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
 	cancel_delayed_work_sync(&dev->cal_work);
 	cancel_delayed_work_sync(&dev->mac_work);
 	mt76u_stop_stat_wk(&dev->mt76);
 
+	if (test_bit(MT76_REMOVED, &dev->mt76.state))
+		return;
+
 	mt76_clear(dev, MT_BEACON_TIME_CFG, MT_BEACON_TIME_CFG_TIMER_EN |
 		   MT_BEACON_TIME_CFG_SYNC_MODE | MT_BEACON_TIME_CFG_TBTT_EN |
 		   MT_BEACON_TIME_CFG_BEACON_TX);
-- 
2.17.1

