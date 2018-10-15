Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9BF6C7112A
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 09:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9CDB20853
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 09:33:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9CDB20853
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbeJORSI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Oct 2018 13:18:08 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42447 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbeJORSH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Oct 2018 13:18:07 -0400
Received: by mail-wr1-f68.google.com with SMTP id g15-v6so20444964wru.9
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2018 02:33:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CPpXGlS7O716ILrDD3/HkOe4NTmeXNS+a0oCeA48bls=;
        b=sGbAVpnMTrqpC7TYYFRAeIbrh+jb7xForJIU1M/I1X07W5Kcnm1eNHk5gb0odx1YLR
         Rg4mjPqn/N3lNrBIrvuS2UNqYQboyI4KLSXF8iY68SLl5s7RXXn7DC2fKUnY5tGu3Awa
         FGlimg7aVo8x40Xpk3grWELoncDtH/Upbrm9c6ar3ZliXp/VQR6PyC2z1Oj4pxFtg3SL
         wT7h6At222OwDSKFFyss+bB2Leen75yF9V2BD8vXyVn/VubQgYNSyq2keh9Qw1FCKrwU
         xPjRubw8kQWohV4ArtnS6mRpeYDLhPEqYpsmc6jlGcR6xpncHU0lKxWzADwSzFGLPHoZ
         2xhw==
X-Gm-Message-State: ABuFfohvvKeugVKOnTSrwAmWiTI60U5z1sdaZkYe14IriL8TX3GeGV4S
        MHDU0UULSincmeA98m7K9RGWnw==
X-Google-Smtp-Source: ACcGV63SlfPTWCC+64UEncWBPfVdFT64/t54TMXbmHzE4ylkOgap12oCqcZWmKcUjqtrSNZt+h9A3w==
X-Received: by 2002:adf:9e8f:: with SMTP id a15-v6mr13110454wrf.70.1539596018020;
        Mon, 15 Oct 2018 02:33:38 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id w11-v6sm17102507wrn.65.2018.10.15.02.33.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Oct 2018 02:33:37 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/6] mt76x0: pci: add get_survey support
Date:   Mon, 15 Oct 2018 11:33:11 +0200
Message-Id: <93466e46d49c30b7837e2cb6c01975c91641f5ab.1539595605.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <cover.1539595605.git.lorenzo.bianconi@redhat.com>
References: <cover.1539595605.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_update_channel routine in mt76x02-lib module in
order to be reused by mt76x0 driver adding get_survey support

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/mac.c   |  2 ++
 .../net/wireless/mediatek/mt76/mt76x0/main.c  |  5 +++++
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  2 ++
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 18 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  1 +
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  2 --
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_mac.c   | 19 +------------------
 8 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 7a422c590211..9cabe8ebf5da 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -137,6 +137,8 @@ void mt76x0_mac_work(struct work_struct *work)
 	u32 sum, n;
 	int i, j, k;
 
+	mt76x02_update_channel(&dev->mt76);
+
 	/* Note: using MCU_RANDOM_READ is actually slower then reading all the
 	 *	 registers by hand.  MCU takes ca. 20ms to complete read of 24
 	 *	 registers while reading them one by one will takes roughly
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 9273d2d2764a..e9fbbabbe7e0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -25,6 +25,11 @@ mt76x0_set_channel(struct mt76x02_dev *dev, struct cfg80211_chan_def *chandef)
 
 	mt76_set_channel(&dev->mt76);
 	ret = mt76x0_phy_set_channel(dev, chandef);
+
+	/* channel cycle counters read-and-clear */
+	mt76_rr(dev, MT_CH_IDLE);
+	mt76_rr(dev, MT_CH_BUSY);
+
 	mt76_txq_schedule_all(&dev->mt76);
 
 	return ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 522c86059bcb..3277e6b07a46 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -85,6 +85,7 @@ static const struct ieee80211_ops mt76x0e_ops = {
 	.ampdu_action = mt76x02_ampdu_action,
 	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
 	.wake_tx_queue = mt76_wake_tx_queue,
+	.get_survey = mt76_get_survey,
 };
 
 static int mt76x0e_register_device(struct mt76x02_dev *dev)
@@ -135,6 +136,7 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct mt76_driver_ops drv_ops = {
 		.txwi_size = sizeof(struct mt76x02_txwi),
+		.update_survey = mt76x02_update_channel,
 		.tx_prepare_skb = mt76x02_tx_prepare_skb,
 		.tx_complete_skb = mt76x02_tx_complete_skb,
 		.rx_skb = mt76x02_queue_rx_skb,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 10578e4cb269..e6d6ddaa5a07 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -735,3 +735,21 @@ void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 		dev_kfree_skb_any(e->skb);
 }
 EXPORT_SYMBOL_GPL(mt76x02_tx_complete_skb);
+
+void mt76x02_update_channel(struct mt76_dev *mdev)
+{
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
+	struct mt76_channel_state *state;
+	u32 active, busy;
+
+	state = mt76_channel_state(&dev->mt76, dev->mt76.chandef.chan);
+
+	busy = mt76_rr(dev, MT_CH_BUSY);
+	active = busy + mt76_rr(dev, MT_CH_IDLE);
+
+	spin_lock_bh(&dev->mt76.cc_lock);
+	state->cc_busy += busy;
+	state->cc_active += active;
+	spin_unlock_bh(&dev->mt76.cc_lock);
+}
+EXPORT_SYMBOL_GPL(mt76x02_update_channel);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index d99c18743969..6bce18bcbf36 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -226,4 +226,5 @@ void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
 void mt76x02_mac_poll_tx_status(struct mt76x02_dev *dev, bool irq);
 void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 			     struct mt76_queue_entry *e, bool flush);
+void mt76x02_update_channel(struct mt76_dev *mdev);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index be0ae24d310a..72c365040be1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -85,8 +85,6 @@ void mt76x2_pre_tbtt_tasklet(unsigned long arg);
 
 void mt76x2_sta_ps(struct mt76_dev *dev, struct ieee80211_sta *sta, bool ps);
 
-void mt76x2_update_channel(struct mt76_dev *mdev);
-
 void mt76x2_reset_wlan(struct mt76x02_dev *dev, bool enable);
 void mt76x2_init_txpower(struct mt76x02_dev *dev,
 			 struct ieee80211_supported_band *sband);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 3824290b219d..279edc612119 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -354,7 +354,7 @@ struct mt76x02_dev *mt76x2_alloc_device(struct device *pdev)
 {
 	static const struct mt76_driver_ops drv_ops = {
 		.txwi_size = sizeof(struct mt76x02_txwi),
-		.update_survey = mt76x2_update_channel,
+		.update_survey = mt76x02_update_channel,
 		.tx_prepare_skb = mt76x02_tx_prepare_skb,
 		.tx_complete_skb = mt76x02_tx_complete_skb,
 		.rx_skb = mt76x02_queue_rx_skb,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
index 4b331ed14bb2..15620d4d425e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
@@ -137,30 +137,13 @@ void mt76x2_mac_set_beacon_enable(struct mt76x02_dev *dev,
 		mt76x02_irq_disable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
 }
 
-void mt76x2_update_channel(struct mt76_dev *mdev)
-{
-	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
-	struct mt76_channel_state *state;
-	u32 active, busy;
-
-	state = mt76_channel_state(&dev->mt76, dev->mt76.chandef.chan);
-
-	busy = mt76_rr(dev, MT_CH_BUSY);
-	active = busy + mt76_rr(dev, MT_CH_IDLE);
-
-	spin_lock_bh(&dev->mt76.cc_lock);
-	state->cc_busy += busy;
-	state->cc_active += active;
-	spin_unlock_bh(&dev->mt76.cc_lock);
-}
-
 void mt76x2_mac_work(struct work_struct *work)
 {
 	struct mt76x02_dev *dev = container_of(work, struct mt76x02_dev,
 					       mac_work.work);
 	int i, idx;
 
-	mt76x2_update_channel(&dev->mt76);
+	mt76x02_update_channel(&dev->mt76);
 	for (i = 0, idx = 0; i < 16; i++) {
 		u32 val = mt76_rr(dev, MT_TX_AGG_CNT(i));
 
-- 
2.19.0

