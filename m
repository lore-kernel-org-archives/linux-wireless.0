Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ACC8C64EAD
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 08:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE92720652
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 08:56:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE92720652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbeJAPdJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 11:33:09 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40305 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728808AbeJAPdH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 11:33:07 -0400
Received: by mail-wr1-f67.google.com with SMTP id y8-v6so12955880wrh.7
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 01:56:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xGlBhlfY0Z/YCQHhlOQQPdpSu7nnBvMeUA6onOeBNMQ=;
        b=cmaztZBS1ZCHBIJRZNYuamPmts2iQrrTtUx+YvWq+8OK8CG2P9/un5RKKXLpKub0tv
         ADBb8O/+BZzJOIrgc04glDoVNTKU8Y4jj83/Q/GXzCcjZslg+g+S9ohUR1NZebYL9M9h
         FALKOHoJlURiadmtZoO4JVSNuHtVX591N/GJoxy/F6zDn+ODaH5HMbgCqSJUkIUVt4hc
         nRuUxWMDzn0SqtSaYLpijpA3YRkrlnQrmvQTybw0cPjAinY0vcuPqVxRj/oibAPuBauH
         /AnW30TF1RtY7R9BRTy/sRUSz9ntt9EJk+G5Jm+8ZT1SOXyvRdyNMK/UeggEzIGVMtP5
         4utA==
X-Gm-Message-State: ABuFfoiuz1AFYOxsWe5KTfeNooQwYlthlSVypdoGiDemhwSbBHm+mKqH
        +TvyNmVozmbqzLeLMbKv55+gcbIeSno=
X-Google-Smtp-Source: ACcGV60LGaoL4kBe0VuwrsO8hbQi42aJeDy+fGlkRgPlZHnHrfYA60paCtN9BebxHvSl278zFKQ5qQ==
X-Received: by 2002:a5d:5210:: with SMTP id j16-v6mr5886299wrv.290.1538384184534;
        Mon, 01 Oct 2018 01:56:24 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id t2-v6sm7696454wrr.7.2018.10.01.01.56.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Oct 2018 01:56:23 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2] mt76x0: pci: add mt76x0e_cleanup routine
Date:   Mon,  1 Oct 2018 10:55:54 +0200
Message-Id: <de07f6bb2754c23f00ad4979783f106a510ef6cf.1538383762.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538383762.git.lorenzo.bianconi@redhat.com>
References: <cover.1538383762.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add mt76x0e_cleanup routine to tidy up the device
during device removal

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
Changes since v1:
- remove H2M_MAILBOX_* configurations
---
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   | 26 ++++++++++++++-----
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 876291dd3c1e..97bf8634b06d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -41,13 +41,8 @@ static int mt76x0e_start(struct ieee80211_hw *hw)
 	return 0;
 }
 
-static void mt76x0e_stop(struct ieee80211_hw *hw)
+static void mt76x0e_stop_hw(struct mt76x0_dev *dev)
 {
-	struct mt76x0_dev *dev = hw->priv;
-
-	mutex_lock(&dev->mt76.mutex);
-
-	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
 	cancel_delayed_work_sync(&dev->cal_work);
 	cancel_delayed_work_sync(&dev->mac_work);
 
@@ -62,7 +57,15 @@ static void mt76x0e_stop(struct ieee80211_hw *hw)
 		       0, 1000))
 		dev_warn(dev->mt76.dev, "TX DMA did not stop\n");
 	mt76_clear(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_RX_DMA_EN);
+}
+
+static void mt76x0e_stop(struct ieee80211_hw *hw)
+{
+	struct mt76x0_dev *dev = hw->priv;
 
+	mutex_lock(&dev->mt76.mutex);
+	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
+	mt76x0e_stop_hw(dev);
 	mutex_unlock(&dev->mt76.mutex);
 }
 
@@ -160,12 +163,23 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ret;
 }
 
+static void mt76x0e_cleanup(struct mt76x0_dev *dev)
+{
+	clear_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
+	mt76x0_chip_onoff(dev, false, false);
+	mt76x0e_stop_hw(dev);
+	mt76_dma_cleanup(&dev->mt76);
+	mt76x02_mcu_cleanup(&dev->mt76);
+}
+
 static void
 mt76x0e_remove(struct pci_dev *pdev)
 {
 	struct mt76_dev *mdev = pci_get_drvdata(pdev);
+	struct mt76x0_dev *dev = container_of(mdev, struct mt76x0_dev, mt76);
 
 	mt76_unregister_device(mdev);
+	mt76x0e_cleanup(dev);
 	ieee80211_free_hw(mdev->hw);
 }
 
-- 
2.17.1

