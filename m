Return-Path: <SRS0=h0Fo=ML=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D33C43143
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 17:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C64520879
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 17:26:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C64520879
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbeI2X4D (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 29 Sep 2018 19:56:03 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38651 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728364AbeI2X4D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Sep 2018 19:56:03 -0400
Received: by mail-wr1-f68.google.com with SMTP id j8-v6so9508276wrw.5
        for <linux-wireless@vger.kernel.org>; Sat, 29 Sep 2018 10:26:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZhV7oJr/QCGvifp9jnuK2Wpv5xUHBK7xH0mo6oDaa4c=;
        b=iEm+2daL9zp48fbLv00JaIVlmC6VnWCeSN1UtVwYKqrhzrOQ5xEwFchV6Z5ivYwz5s
         6HW5iVYFVN7rw+wc1+BbuEOrRL3g6DMATs5+y7qhJqqet/VtbUBnVxeRB93hopdwfB5a
         ww2Y92D0dPCjluM1JjCoYJHKXphAYaaqDMQRqybE1CyMQHWyeTcg5hjPo+986Ks2SwQL
         UMQqyN4/s2BApZq3IugEl+y0B4zC6o5Fqt0P+MwopP/1ouGRk6gEPVCZY0rYgn9Hr+XA
         Pp3Ff+JPIlF+djSZ6ZzbtCJlQEA4oPGOEeqegyBhZkYcAz2TqwcHmjch3CLcfCrDFcok
         CVIw==
X-Gm-Message-State: ABuFfojiN/+6HB0nnEwtTuua+Xp0PxMT4mm/JBOLYgFNa2gb3XlHuojv
        LQr+d2bNhshOFCwe88Hm7FGkD8sQXfo=
X-Google-Smtp-Source: ACcGV62Ivi9P+1P4m02ClQZPAqnGP10VxA8inDEM9YB1oiLwbNrZTR5W4C+T51e7lQhqAPwoTYwiuQ==
X-Received: by 2002:a5d:6492:: with SMTP id r18-v6mr2200793wru.99.1538242007939;
        Sat, 29 Sep 2018 10:26:47 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id t13-v6sm6148851wrn.54.2018.09.29.10.26.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Sep 2018 10:26:47 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: pci: add mt76x0e_cleanup routine
Date:   Sat, 29 Sep 2018 19:26:41 +0200
Message-Id: <20180929172641.32440-1-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add mt76x0e_cleanup routine to tidy up the device
during netdevice removal

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   | 30 +++++++++++++++----
 .../net/wireless/mediatek/mt76/mt76x02_regs.h |  3 ++
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 876291dd3c1e..8cf9cabcbe2f 100644
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
 
@@ -160,12 +163,27 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ret;
 }
 
+static void mt76x0e_cleanup(struct mt76x0_dev *dev)
+{
+	clear_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
+	mt76x0_chip_onoff(dev, false, false);
+	mt76x0e_stop_hw(dev);
+
+	mt76_wr(dev, MT_H2M_MAILBOX_CID, ~0);
+	mt76_wr(dev, MT_H2M_MAILBOX_STATUS, ~0);
+
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
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
index 24d1e6d747dd..f8003ee03a89 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
@@ -622,6 +622,9 @@
 
 #define MT_SRAM_BASE			0x4000
 
+#define MT_H2M_MAILBOX_CID		0x7014
+#define MT_H2M_MAILBOX_STATUS		0x701c
+
 #define MT_WCID_KEY_BASE		0x8000
 #define MT_WCID_KEY(_n)			(MT_WCID_KEY_BASE + (_n) * 32)
 
-- 
2.19.0

