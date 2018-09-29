Return-Path: <SRS0=h0Fo=ML=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5AB4C43143
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 17:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8D36206B8
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 17:45:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8D36206B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbeI3AOd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 29 Sep 2018 20:14:33 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40058 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728446AbeI3AOb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Sep 2018 20:14:31 -0400
Received: by mail-wm1-f65.google.com with SMTP id o2-v6so4939783wmh.5
        for <linux-wireless@vger.kernel.org>; Sat, 29 Sep 2018 10:45:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T5+qj6fGLjUlhdsGj3ZsHkrU9c6IVL7xzsTipcjjF80=;
        b=GPenOyDX+3cHngL0sNmaQH1EtqmZBcJUqRxBY+plkoQCLscmoCOnd55ahBcX2Lltv0
         1Yvj9sPAUHJJ57/boncigo8GuXPq+X5Wa1daOBnykNFjpGPIw+5qt7F1WQyC14jxx4a4
         483bDf1dLpU2Nepyc0ajvrbYyADe3vCQ36cATLhUoTcssBqOGPmKjyCfuhehfEr47L03
         xnrvBQc01Tb5FIwcWVwcO6W5ItsxgNCPceMxmi40qRXb8xPfBcbLLK5hHCCudtqgyRTR
         iJcY+YqnNIb5/bP0uGd4geZpmGMeByjGzIRyvDD07GOiDx+sVY2lab5dWXSfYXf44RMJ
         t07w==
X-Gm-Message-State: ABuFfohPwNARx2IuSzD43xuYnbrSEwY8VA7GjGsxoZyqABmT9j+AXeFb
        oXqiZHc/upefaMLEfjR2ri0Avw==
X-Google-Smtp-Source: ACcGV63UfqOhdI2ja2V9TFg0ELBSK8Q06DIWf3WiwL2psygkqLVNYp2a4A6wFJcmRHI9pHTB7vn5QQ==
X-Received: by 2002:a1c:2283:: with SMTP id i125-v6mr4889551wmi.28.1538243112644;
        Sat, 29 Sep 2018 10:45:12 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id e14-v6sm10845021wrs.69.2018.09.29.10.45.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Sep 2018 10:45:12 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 3/5] mt76: add get_tx_txpwr_adj function pointer to mt76_driver_ops
Date:   Sat, 29 Sep 2018 19:44:54 +0200
Message-Id: <20180929174456.995-4-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add get_tx_txpwr_adj function pointer to mt76_driver_ops data structure.
This is a preliminary patch unify txwi configuration between mt76x0 and
mt76x2 drivers since tpc is currently supported just by mt76x2 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h            | 2 ++
 drivers/net/wireless/mediatek/mt76/mt76x2/mac.c      | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h   | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x2/tx.c       | 6 ++++--
 5 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 5359273d8453..c2e7235c844d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -262,6 +262,8 @@ struct mt76_driver_ops {
 
 	void (*sta_ps)(struct mt76_dev *dev, struct ieee80211_sta *sta,
 		       bool ps);
+	s8 (*get_tx_txpwr_adj)(struct mt76_dev *dev, s8 txpwr,
+			       s8 max_txpwr_adj);
 };
 
 struct mt76_channel_state {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
index a396a56dcfe0..0791fa11875c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
@@ -100,7 +100,7 @@ void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x02_txwi *txwi,
 	}
 	spin_unlock_bh(&dev->mt76.lock);
 
-	txpwr_adj = mt76x2_tx_get_txpwr_adj(dev, dev->mt76.txpower_conf,
+	txpwr_adj = mt76x2_tx_get_txpwr_adj(&dev->mt76, dev->mt76.txpower_conf,
 					    max_txpwr_adj);
 	txwi->ctl2 = FIELD_PREP(MT_TX_PWR_ADJ, txpwr_adj);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index 11cc11665564..52706900d804 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -171,7 +171,7 @@ void mt76x2_sta_ps(struct mt76_dev *dev, struct ieee80211_sta *sta, bool ps);
 
 void mt76x2_update_channel(struct mt76_dev *mdev);
 
-s8 mt76x2_tx_get_txpwr_adj(struct mt76x2_dev *dev, s8 txpwr, s8 max_txpwr_adj);
+s8 mt76x2_tx_get_txpwr_adj(struct mt76_dev *mdev, s8 txpwr, s8 max_txpwr_adj);
 void mt76x2_tx_set_txpwr_auto(struct mt76x2_dev *dev, s8 txpwr);
 
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 58d5cad4c41d..b1d5dc2b7b81 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -362,6 +362,7 @@ struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev)
 		.rx_skb = mt76x2_queue_rx_skb,
 		.rx_poll_complete = mt76x2_rx_poll_complete,
 		.sta_ps = mt76x2_sta_ps,
+		.get_tx_txpwr_adj = mt76x2_tx_get_txpwr_adj,
 	};
 	struct mt76x2_dev *dev;
 	struct mt76_dev *mdev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c
index 0c878c9eb33d..c8203e49560c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c
@@ -47,8 +47,10 @@ void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 }
 EXPORT_SYMBOL_GPL(mt76x2_tx);
 
-s8 mt76x2_tx_get_txpwr_adj(struct mt76x2_dev *dev, s8 txpwr, s8 max_txpwr_adj)
+s8 mt76x2_tx_get_txpwr_adj(struct mt76_dev *mdev, s8 txpwr, s8 max_txpwr_adj)
 {
+	struct mt76x2_dev  *dev = container_of(mdev, struct mt76x2_dev, mt76);
+
 	txpwr = min_t(s8, txpwr, dev->mt76.txpower_conf);
 	txpwr -= (dev->target_power + dev->target_power_delta[0]);
 	txpwr = min_t(s8, txpwr, max_txpwr_adj);
@@ -66,7 +68,7 @@ void mt76x2_tx_set_txpwr_auto(struct mt76x2_dev *dev, s8 txpwr)
 {
 	s8 txpwr_adj;
 
-	txpwr_adj = mt76x2_tx_get_txpwr_adj(dev, txpwr,
+	txpwr_adj = mt76x2_tx_get_txpwr_adj(&dev->mt76, txpwr,
 					    dev->mt76.rate_power.ofdm[4]);
 	mt76_rmw_field(dev, MT_PROT_AUTO_TX_CFG,
 		       MT_PROT_AUTO_TX_CFG_PROT_PADJ, txpwr_adj);
-- 
2.19.0

