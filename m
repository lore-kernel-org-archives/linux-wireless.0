Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95735C04E87
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69BBD21746
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69BBD21746
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbeI1NDF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:03:05 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33820 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbeI1NDF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:03:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id z4-v6so3700493wrb.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 23:40:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sung28HBv1lSZOZtn0AaJN8g+TQ+ciAqO3V3SETc2qI=;
        b=r7yibcjuMxSSZ/rNTptLbkE81AmHrTfr7I4a+lAuvZkkVTglyoSQocS60O1GgJOMIR
         LsJDWEnUNuZjpg6bI7p9RJ5cHHfIPZ+JUP1jdppA10l9ryVNd/cJF5H6WD5NQ9NENJNH
         9Wf8zyK0NkLMgTnX6Tn6hrlhj+FKrvAxsisrHWL4emttql0Dh1DbxwTvxVkXRZG/6z78
         Uq2drwWP9JwqokyLtAS7OJ3Jgj2dxHuLvUvkO7LZckftW25MZhUfnotTZ82Mrdwz75b5
         UFRjPUu0YZCl1BkPXze2Dc4OfgD2zursKLxFwKMh+E8ZPPPo8kLRMkeC49h9wANFtkxc
         yhhw==
X-Gm-Message-State: ABuFfohUgtqhk1dM4ksL67gkAzTJwfM6GeZ1tVfgEfDyZF6BQkZye6rf
        pK4Y34zfiN91bhl29X1xEqKYmQ==
X-Google-Smtp-Source: ACcGV60KL6wXx7ibxAJ7wLMM3MIpfQmrMjtSvDMKB/AKKUH4OcWT72ZGk3hGbGHaj8uyyXglsF82CA==
X-Received: by 2002:adf:e607:: with SMTP id p7-v6mr3544742wrm.254.1538116851166;
        Thu, 27 Sep 2018 23:40:51 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id y4-v6sm5605105wrd.25.2018.09.27.23.40.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 23:40:50 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 22/24] mt76x0: pci: add mt76x0e_{start/stop} callbacks
Date:   Fri, 28 Sep 2018 08:40:15 +0200
Message-Id: <20180928064017.26870-23-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
2.19.0

