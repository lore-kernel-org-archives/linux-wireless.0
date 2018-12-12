Return-Path: <SRS0=wq86=OV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB81C65BAF
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 21:52:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23FCC20851
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 21:52:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23FCC20851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbeLLVwM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Dec 2018 16:52:12 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51183 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbeLLVwM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Dec 2018 16:52:12 -0500
Received: by mail-wm1-f67.google.com with SMTP id n190so379134wmd.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2018 13:52:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4qqcngdWlwcJ6W3ETxUjmk3BJzjsO0ODId/Rl2ul3Yg=;
        b=rPUKvw1GqNolOGBq+G/qgOPQbVqcb92RbKYJebGL99WA5MbeQ+HGkfe43f62f6nqaY
         0KL2xr7Joj6BFwfAEBdLmAN7OCsVfHJm6pNq/W/2Doh/qL1fLm0eWby0NldjsJpC1qb/
         CfHN23fjyY8ZgE1vWVxY39KtAfJ4HBZ3BEP96QrXYZgXeE29BQFv7p5sMifnUtj6B3/9
         2Xx4oio186raixKSDjy6QFbs4azaB0Qgn70mU4cTUIZcesdd1fIZDQQoWy5gtiSY8qH/
         sRnwapVUdbZ6PosxjjV0E3IEsrzUC6IXDeUtNRt69tHzdHubITQzlh2KdZPvJP16Y6MT
         naIw==
X-Gm-Message-State: AA+aEWYaJ97NvqzrxhCWMpEt5QoiKcT28CZLcoOJ4RiaqB1g1gI0Btd5
        A+7JRT2QGDcv8GglcQVsAAJCZw==
X-Google-Smtp-Source: AFSGD/VhViU1D80lktsr8rj7CIN/zrRscLPXtIS75extMbbaXDNTrRyUUVEypCj65HDMCPoSR6kcOQ==
X-Received: by 2002:a7b:c34c:: with SMTP id l12mr7860461wmj.147.1544651528976;
        Wed, 12 Dec 2018 13:52:08 -0800 (PST)
Received: from localhost.localdomain ([151.66.36.11])
        by smtp.gmail.com with ESMTPSA id o17sm225615wmg.35.2018.12.12.13.52.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Dec 2018 13:52:08 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 3/3] mt76: add energy detect CCA support to mt76x{0,2}e drivers
Date:   Wed, 12 Dec 2018 22:51:55 +0100
Message-Id: <d6dacfe3e5fe4ae4de966fc394569d8e20e82ecb.1544568618.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <cover.1544568618.git.lorenzo.bianconi@redhat.com>
References: <cover.1544568618.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ported from the reference driver. Should fix compliance with ETSI
regulatories on preventing transmission while energy detect values
are above the threshold.
The code has been tested using an ath9k device running tx99 as
noise generator

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  1 +
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  2 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  6 ++
 .../net/wireless/mediatek/mt76/mt76x02_dfs.c  |  4 +
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 85 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  2 +
 .../net/wireless/mediatek/mt76/mt76x02_regs.h |  8 ++
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  1 +
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   |  2 +
 9 files changed, 111 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 1906cc62690f..720b05e325a5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -147,6 +147,7 @@ static int mt76x0e_register_device(struct mt76x02_dev *dev)
 		MT_CH_TIME_CFG_RX_AS_BUSY |
 		MT_CH_TIME_CFG_NAV_AS_BUSY |
 		MT_CH_TIME_CFG_EIFS_AS_BUSY |
+		MT_CH_CCA_RC_EN |
 		FIELD_PREP(MT_CH_TIME_CFG_CH_TIMER_CLR, 1));
 
 	err = mt76x0_register_device(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 1eb1a802ed20..b2b38b9fcac7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -1013,6 +1013,8 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 	mt76x0_phy_calibrate(dev, false);
 	mt76x0_phy_set_txpower(dev);
 
+	mt76x02_edcca_init(dev);
+
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
 				     MT_CALIBRATE_INTERVAL);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index b1d83dd34204..5f5831d18af5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -102,6 +102,12 @@ struct mt76x02_dev {
 	u8 slottime;
 
 	struct mt76x02_dfs_pattern_detector dfs_pd;
+
+	/* edcca monitor */
+	bool ed_tx_blocked;
+	bool ed_monitor;
+	u8 ed_trigger;
+	u8 ed_silent;
 };
 
 extern struct ieee80211_rate mt76x02_rates[12];
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
index 5bd523b091b6..19fdcab746a0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
@@ -884,6 +884,10 @@ mt76x02_dfs_set_domain(struct mt76x02_dev *dev,
 	mutex_lock(&dev->mt76.mutex);
 	if (dfs_pd->region != region) {
 		tasklet_disable(&dfs_pd->dfs_tasklet);
+
+		dev->ed_monitor = region == NL80211_DFS_ETSI;
+		mt76x02_edcca_init(dev);
+
 		dfs_pd->region = region;
 		mt76x02_dfs_init_params(dev);
 		tasklet_enable(&dfs_pd->dfs_tasklet);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 64841f40cdcf..aed108e8761f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -778,6 +778,88 @@ static void mt76x02_check_mac_err(struct mt76x02_dev *dev)
 		MT_MAC_SYS_CTRL_ENABLE_TX | MT_MAC_SYS_CTRL_ENABLE_RX);
 }
 
+static void
+mt76x02_edcca_tx_enable(struct mt76x02_dev *dev, bool enable)
+{
+	if (enable) {
+		u32 data;
+
+		mt76_set(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_ENABLE_TX);
+		mt76_set(dev, MT_AUTO_RSP_CFG, MT_AUTO_RSP_EN);
+		/* enable pa-lna */
+		data = mt76_rr(dev, MT_TX_PIN_CFG);
+		data |= MT_TX_PIN_CFG_TXANT |
+			MT_TX_PIN_CFG_RXANT |
+			MT_TX_PIN_RFTR_EN |
+			MT_TX_PIN_TRSW_EN;
+		mt76_wr(dev, MT_TX_PIN_CFG, data);
+	} else {
+		mt76_clear(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_ENABLE_TX);
+		mt76_clear(dev, MT_AUTO_RSP_CFG, MT_AUTO_RSP_EN);
+		/* disable pa-lna */
+		mt76_clear(dev, MT_TX_PIN_CFG, MT_TX_PIN_CFG_TXANT);
+		mt76_clear(dev, MT_TX_PIN_CFG, MT_TX_PIN_CFG_RXANT);
+	}
+	dev->ed_tx_blocked = !enable;
+}
+
+void mt76x02_edcca_init(struct mt76x02_dev *dev)
+{
+	dev->ed_trigger = 0;
+	dev->ed_silent = 0;
+
+	if (dev->ed_monitor) {
+		struct ieee80211_channel *chan = dev->mt76.chandef.chan;
+		u8 ed_th = chan->band == NL80211_BAND_5GHZ ? 0x0e : 0x20;
+
+		mt76_clear(dev, MT_TX_LINK_CFG, MT_TX_CFACK_EN);
+		mt76_set(dev, MT_TXOP_CTRL_CFG, MT_TXOP_ED_CCA_EN);
+		mt76_rmw(dev, MT_BBP(AGC, 2), GENMASK(15, 0),
+			 ed_th << 8 | ed_th);
+		if (!is_mt76x2(dev))
+			mt76_set(dev, MT_TXOP_HLDR_ET,
+				 MT_TXOP_HLDR_TX40M_BLK_EN);
+	} else {
+		mt76_set(dev, MT_TX_LINK_CFG, MT_TX_CFACK_EN);
+		mt76_clear(dev, MT_TXOP_CTRL_CFG, MT_TXOP_ED_CCA_EN);
+		if (is_mt76x2(dev)) {
+			mt76_wr(dev, MT_BBP(AGC, 2), 0x00007070);
+		} else {
+			mt76_wr(dev, MT_BBP(AGC, 2), 0x003a6464);
+			mt76_clear(dev, MT_TXOP_HLDR_ET,
+				   MT_TXOP_HLDR_TX40M_BLK_EN);
+		}
+	}
+	mt76x02_edcca_tx_enable(dev, true);
+}
+EXPORT_SYMBOL_GPL(mt76x02_edcca_init);
+
+#define MT_EDCCA_TH		90
+#define MT_EDCCA_BLOCK_TH	2
+static void mt76x02_edcca_check(struct mt76x02_dev *dev)
+{
+	u32 val, busy;
+
+	val = mt76_rr(dev, MT_ED_CCA_TIMER);
+	busy = (val * 100) / jiffies_to_usecs(MT_CALIBRATE_INTERVAL);
+	busy = min_t(u32, busy, 100);
+
+	if (busy > MT_EDCCA_TH) {
+		dev->ed_trigger++;
+		dev->ed_silent = 0;
+	} else {
+		dev->ed_silent++;
+		dev->ed_trigger = 0;
+	}
+
+	if (dev->ed_trigger > MT_EDCCA_BLOCK_TH &&
+	    !dev->ed_tx_blocked)
+		mt76x02_edcca_tx_enable(dev, false);
+	else if (dev->ed_silent > MT_EDCCA_BLOCK_TH &&
+		 dev->ed_tx_blocked)
+		mt76x02_edcca_tx_enable(dev, true);
+}
+
 void mt76x02_mac_work(struct work_struct *work)
 {
 	struct mt76x02_dev *dev = container_of(work, struct mt76x02_dev,
@@ -798,6 +880,9 @@ void mt76x02_mac_work(struct work_struct *work)
 	if (!dev->beacon_mask)
 		mt76x02_check_mac_err(dev);
 
+	if (dev->ed_monitor)
+		mt76x02_edcca_check(dev);
+
 	mutex_unlock(&dev->mt76.mutex);
 
 	mt76_tx_status_check(&dev->mt76, NULL, false);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 4e597004c445..0961db1e21b4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -210,4 +210,6 @@ int mt76x02_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
 			   struct sk_buff *skb);
 void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev, u8 vif_idx,
 				   bool val);
+
+void mt76x02_edcca_init(struct mt76x02_dev *dev);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
index f7de77d09d28..607382644eb2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
@@ -318,6 +318,7 @@
 #define MT_CH_TIME_CFG_NAV_AS_BUSY	BIT(3)
 #define MT_CH_TIME_CFG_EIFS_AS_BUSY	BIT(4)
 #define MT_CH_TIME_CFG_MDRDY_CNT_EN	BIT(5)
+#define MT_CH_CCA_RC_EN			BIT(6)
 #define MT_CH_TIME_CFG_CH_TIMER_CLR	GENMASK(9, 8)
 #define MT_CH_TIME_CFG_MDRDY_CLR	GENMASK(11, 10)
 
@@ -378,6 +379,9 @@
 #define MT_TX_PWR_CFG_4			0x1324
 #define MT_TX_PIN_CFG			0x1328
 #define MT_TX_PIN_CFG_TXANT		GENMASK(3, 0)
+#define MT_TX_PIN_CFG_RXANT		GENMASK(11, 8)
+#define MT_TX_PIN_RFTR_EN		BIT(16)
+#define MT_TX_PIN_TRSW_EN		BIT(18)
 
 #define MT_TX_BAND_CFG			0x132c
 #define MT_TX_BAND_CFG_UPPER_40M	BIT(0)
@@ -398,6 +402,7 @@
 #define MT_TXOP_CTRL_CFG		0x1340
 #define MT_TXOP_TRUN_EN			GENMASK(5, 0)
 #define MT_TXOP_EXT_CCA_DLY		GENMASK(15, 8)
+#define MT_TXOP_ED_CCA_EN		BIT(20)
 
 #define MT_TX_RTS_CFG			0x1344
 #define MT_TX_RTS_CFG_RETRY_LIMIT	GENMASK(7, 0)
@@ -409,6 +414,7 @@
 
 #define MT_TX_RETRY_CFG			0x134c
 #define MT_TX_LINK_CFG			0x1350
+#define MT_TX_CFACK_EN			BIT(12)
 #define MT_VHT_HT_FBK_CFG0		0x1354
 #define MT_VHT_HT_FBK_CFG1		0x1358
 #define MT_LG_FBK_CFG0			0x135c
@@ -511,6 +517,7 @@
 #define MT_RX_FILTR_CFG_CTRL_RSV	BIT(16)
 
 #define MT_AUTO_RSP_CFG			0x1404
+#define MT_AUTO_RSP_EN			BIT(0)
 #define MT_AUTO_RSP_PREAMB_SHORT	BIT(4)
 #define MT_LEGACY_BASIC_RATE		0x1408
 #define MT_HT_BASIC_RATE		0x140c
@@ -532,6 +539,7 @@
 #define MT_PN_PAD_MODE			0x150c
 
 #define MT_TXOP_HLDR_ET			0x1608
+#define MT_TXOP_HLDR_TX40M_BLK_EN	BIT(1)
 
 #define MT_PROT_AUTO_TX_CFG		0x1648
 #define MT_PROT_AUTO_TX_CFG_PROT_PADJ	GENMASK(11, 8)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 41c60208f175..fc0a6fe5939b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -151,6 +151,7 @@ static int mt76x2_mac_reset(struct mt76x02_dev *dev, bool hard)
 		MT_CH_TIME_CFG_RX_AS_BUSY |
 		MT_CH_TIME_CFG_NAV_AS_BUSY |
 		MT_CH_TIME_CFG_EIFS_AS_BUSY |
+		MT_CH_CCA_RC_EN |
 		FIELD_PREP(MT_CH_TIME_CFG_CH_TIMER_CLR, 1));
 
 	mt76x02_set_tx_ackto(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
index da7cd40f56ff..65ed62229a5b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
@@ -254,6 +254,8 @@ int mt76x2_phy_set_channel(struct mt76x02_dev *dev,
 			       0x38);
 	}
 
+	mt76x02_edcca_init(dev);
+
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->cal_work,
 				     MT_CALIBRATE_INTERVAL);
 
-- 
2.19.2

