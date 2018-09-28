Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5575C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1F6321547
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1F6321547
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729619AbeI1SDE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 14:03:04 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44890 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729605AbeI1SDB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 14:03:01 -0400
Received: by mail-wr1-f67.google.com with SMTP id v16-v6so6004931wro.11
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 04:39:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+dabkHV/l4Ov5wCGLmto4adKjab05FRT0J/vq2PsDyM=;
        b=clhnnD9oBdJEuwV2VirzSHoUi8mESZMXaZTwBLwFeXZL3w57IcJWLPBOqjE9HcI+wg
         QjMoXVzaeNprvKd74UkG5drAMPbFqvAjST2PfVXpbAsiYXwigXMHye/uUFdZ+og5v8Ob
         3bnU0cxfm2AfccsmZLZrvcf+5cBLb+Kn49awkHiAh0Diu/+ke5x1Rb00HM7TyJTWJPLE
         FlEmBZgvXPrIdP98qHP1MIrnPZtIhX88Y8fd68SpGaOXan2zKUX4uzUumtSrglqAO5vN
         9Kpy4kBg1f3M16HraqsISu7ISRDvk4gzPgMzBNNMVkc3Ms8oKPgcG+axv8kqgu6gGLDr
         gDZQ==
X-Gm-Message-State: ABuFfojKgw0GqlxEwtZSFYsYQMOMExPZtsOpke/CWRnEQsH++rqsNvLH
        4iYitTerA6WiZULxnq47yZx/Ii2vv7U=
X-Google-Smtp-Source: ACcGV622VYnecSS11P0KDY1imzgZafxISGqmE47zP9wHoXG6gtbEqT5/UtkH1sLu6XweJloFlPn4dw==
X-Received: by 2002:adf:f1ce:: with SMTP id z14-v6mr2381758wro.214.1538134778431;
        Fri, 28 Sep 2018 04:39:38 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s10-v6sm2395655wmd.22.2018.09.28.04.39.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:39:37 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 22/24] mt76x0: pci: add mt76x0e_{start/stop} callbacks
Date:   Fri, 28 Sep 2018 13:39:05 +0200
Message-Id: <10f7d46687d8c7a1bffa5fd72ddc4a6b30a3dd40.1538134522.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
References: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce mt76x0e_start and mt76x0e_stop mac80211
callbacks to start/stop device mac opening/closing
the netdevice

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 8c020aaf1f0c..876291dd3c1e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -25,11 +25,45 @@
 
 static int mt76x0e_start(struct ieee80211_hw *hw)
 {
+	struct mt76x0_dev *dev = hw->priv;
+
+	mutex_lock(&dev->mt76.mutex);
+
+	mt76x02_mac_start(&dev->mt76);
+	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->mac_work,
+				     MT_CALIBRATE_INTERVAL);
+	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
+				     MT_CALIBRATE_INTERVAL);
+	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
+
+	mutex_unlock(&dev->mt76.mutex);
+
 	return 0;
 }
 
 static void mt76x0e_stop(struct ieee80211_hw *hw)
 {
+	struct mt76x0_dev *dev = hw->priv;
+
+	mutex_lock(&dev->mt76.mutex);
+
+	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
+	cancel_delayed_work_sync(&dev->cal_work);
+	cancel_delayed_work_sync(&dev->mac_work);
+
+	if (!mt76_poll(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_TX_DMA_BUSY,
+		       0, 1000))
+		dev_warn(dev->mt76.dev, "TX DMA did not stop\n");
+	mt76_clear(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_TX_DMA_EN);
+
+	mt76x0_mac_stop(dev);
+
+	if (!mt76_poll(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_RX_DMA_BUSY,
+		       0, 1000))
+		dev_warn(dev->mt76.dev, "TX DMA did not stop\n");
+	mt76_clear(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_RX_DMA_EN);
+
+	mutex_unlock(&dev->mt76.mutex);
 }
 
 static const struct ieee80211_ops mt76x0e_ops = {
-- 
2.17.1

