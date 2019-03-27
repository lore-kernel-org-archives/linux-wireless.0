Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F7EFC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 11:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E53192146E
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 11:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553686877;
	bh=MVkTySNwt9cHzVBZGUzKFkjv8SQzBHOkBd7YNjQciao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=u8PL1MkTaXevd26V2RufEJ53wCkpm79aogoWR4JhKxQnri94wireLU/2VcDJAMeP3
	 iRag2NDqr9u5ExOYt1bYetWrOSzrdEvXHPFacwfgVFNiAgzXTzmcZI75yX477+Hwmq
	 /UIPpsdAbfoiSgs1lUJP1/eWhqarCjc2DoVLFwiU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbfC0LlQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 07:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbfC0LlQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 07:41:16 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15FA120700;
        Wed, 27 Mar 2019 11:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553686875;
        bh=MVkTySNwt9cHzVBZGUzKFkjv8SQzBHOkBd7YNjQciao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PwIoSvchkXsyyOPTKoQNIqwjQokf1T2WycHuCI5ba09T5D77Y8h2UOWpZNaQt/OTO
         a6jeOUuHTRDh2F4GuWaY/Ko5Ii5GmiL/x78an20yAPY/BVNOypDbSCy+VKa7c1FGbl
         HlRbBqk0TLNmzbXalZFH8lYp77J/OudlbSNtUJYQ=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sgruszka@redhat.com
Subject: [PATCH] mt76: introduce mt76_free_device routine
Date:   Wed, 27 Mar 2019 12:41:03 +0100
Message-Id: <aec149cae6ae7d83815aee349804ce32bc74192b.1553682658.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1553682658.git.lorenzo@kernel.org>
References: <cover.1553682658.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76_tx_free in mt76_free_device routine in order to
unmap all txwi descriptors at module unload

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c    | 8 +++++++-
 drivers/net/wireless/mediatek/mt76/mt76.h        | 1 +
 drivers/net/wireless/mediatek/mt76/mt7603/init.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c  | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c  | 2 +-
 5 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 15825e9a458f..f0d418b751ad 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -369,10 +369,16 @@ void mt76_unregister_device(struct mt76_dev *dev)
 
 	mt76_tx_status_check(dev, NULL, true);
 	ieee80211_unregister_hw(hw);
-	mt76_tx_free(dev);
 }
 EXPORT_SYMBOL_GPL(mt76_unregister_device);
 
+void mt76_free_device(struct mt76_dev *dev)
+{
+	mt76_tx_free(dev);
+	ieee80211_free_hw(dev->hw);
+}
+EXPORT_SYMBOL_GPL(mt76_free_device);
+
 void mt76_rx(struct mt76_dev *dev, enum mt76_rxq_id q, struct sk_buff *skb)
 {
 	if (!test_bit(MT76_STATE_RUNNING, &dev->state)) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index b432da3f55c7..f0d34901c825 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -605,6 +605,7 @@ struct mt76_dev *mt76_alloc_device(struct device *pdev, unsigned int size,
 int mt76_register_device(struct mt76_dev *dev, bool vht,
 			 struct ieee80211_rate *rates, int n_rates);
 void mt76_unregister_device(struct mt76_dev *dev);
+void mt76_free_device(struct mt76_dev *dev);
 
 struct dentry *mt76_register_debugfs(struct mt76_dev *dev);
 void mt76_seq_puts_array(struct seq_file *file, const char *str,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/init.c b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
index e17b6b89dfe2..a84b239887ca 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
@@ -574,5 +574,5 @@ void mt7603_unregister_device(struct mt7603_dev *dev)
 	mt76_unregister_device(&dev->mt76);
 	mt7603_mcu_exit(dev);
 	mt7603_dma_cleanup(dev);
-	ieee80211_free_hw(mt76_hw(dev));
+	mt76_free_device(&dev->mt76);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index a7ff7e32b9b3..156d3d064ba0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -234,7 +234,7 @@ mt76x0e_remove(struct pci_dev *pdev)
 
 	mt76_unregister_device(mdev);
 	mt76x0e_cleanup(dev);
-	ieee80211_free_hw(mdev->hw);
+	mt76_free_device(mdev);
 }
 
 static const struct pci_device_id mt76x0e_device_table[] = {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
index 4747f782417a..e84d5c5911ea 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
@@ -107,7 +107,7 @@ mt76pci_remove(struct pci_dev *pdev)
 
 	mt76_unregister_device(mdev);
 	mt76x2_cleanup(dev);
-	ieee80211_free_hw(mdev->hw);
+	mt76_free_device(mdev);
 }
 
 MODULE_DEVICE_TABLE(pci, mt76pci_device_table);
-- 
2.20.1

