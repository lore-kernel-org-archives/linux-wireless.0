Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73E4EC7112C
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 09:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35F7D205C9
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 09:33:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35F7D205C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbeJORSX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Oct 2018 13:18:23 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41152 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbeJORSX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Oct 2018 13:18:23 -0400
Received: by mail-wr1-f65.google.com with SMTP id x12-v6so20441326wru.8
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2018 02:33:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X5HwcKnQS2DqD2hnASQSeo+bBqP6nkXPP8vESIIvaR8=;
        b=XCoaFAFuiGsDt1/KFM+u3IsAKkqDxuxoxEj8jb1BXJBKrUP5ydSOorPSK4BaY05GwR
         HTO3ITqJtLdQj2gbPXsHDUw8JUtBBQdOJY+0Gm7dA1elSZ1rxhhtbqVm/XX89hVOnPJX
         kh3+5lTZFJJ9g+Uoh7CNhiRhgK5f4D+w+6Xm9q9gpqaKzk0yi5rJsU+wDX52enviODt1
         76qjRwiOI3VQouv3+lOz+BDU/iA6Gjpujzg3bp3SK0sR4G2Cm2h5dbq1LYa4RpYOGOaj
         3TX4XBq3VdPYpL+KT3imANcjESxfGJUBzEZ6zwQhDkmw9p2IlEnDdqlqSSe+e2dO0SK2
         mUKw==
X-Gm-Message-State: ABuFfojmrTiL/HP/7g2ebnWVbZcAipOeiuIfh4fcfstV077SgyPOLbRD
        3em/Ym1ZuS7ohOWuG42p2eSLeg==
X-Google-Smtp-Source: ACcGV627oyTQ7XDb0DlVW+KqQTuAknBYiXFOtVA0/QoV96qeGdt3PmC/Wl1TvYNWm04IeVm4HDN0vQ==
X-Received: by 2002:a5d:4cc3:: with SMTP id c3-v6mr14363502wrt.75.1539596033742;
        Mon, 15 Oct 2018 02:33:53 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id w11-v6sm17102507wrn.65.2018.10.15.02.33.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Oct 2018 02:33:53 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 5/6] mt76x0: use mt76x02_mac_work as stats handler
Date:   Mon, 15 Oct 2018 11:33:15 +0200
Message-Id: <f1c7ba156c6fb8a13142692cf99212e80ffa85f4.1539595605.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <cover.1539595605.git.lorenzo.bianconi@redhat.com>
References: <cover.1539595605.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76x02_mac_work utility routine as stats workqueue handler
and remove duplicated code. Moreover run mac stuck check in
mt76x02_mac_work for client interfaces.
Remove no longer used avg_ampdu_len and mt76x02_mac_stats data
structure in mt76x02_dev

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |  3 +-
 .../net/wireless/mediatek/mt76/mt76x0/mac.c   | 68 -------------------
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  1 -
 drivers/net/wireless/mediatek/mt76/mt76x02.h  | 10 ---
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 19 ++++++
 5 files changed, 20 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index f90ef4d803d5..f5c7db9ca02a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -339,7 +339,6 @@ mt76x0_alloc_device(struct device *pdev,
 
 	dev = container_of(mdev, struct mt76x02_dev, mt76);
 	mutex_init(&dev->phy_mutex);
-	atomic_set(&dev->avg_ampdu_len, 1);
 
 	return dev;
 }
@@ -378,7 +377,7 @@ int mt76x0_register_device(struct mt76x02_dev *dev)
 
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 
-	INIT_DELAYED_WORK(&dev->mac_work, mt76x0_mac_work);
+	INIT_DELAYED_WORK(&dev->mac_work, mt76x02_mac_work);
 
 	ret = mt76_register_device(mdev, true, mt76x02_rates,
 				   ARRAY_SIZE(mt76x02_rates));
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 9cabe8ebf5da..98d4a97f0a72 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -105,74 +105,6 @@ void mt76x0_mac_config_tsf(struct mt76x02_dev *dev, bool enable, int interval)
 		MT_BEACON_TIME_CFG_TBTT_EN;
 }
 
-static void mt76x0_check_mac_err(struct mt76x02_dev *dev)
-{
-	u32 val = mt76_rr(dev, 0x10f4);
-
-	if (!(val & BIT(29)) || !(val & (BIT(7) | BIT(5))))
-		return;
-
-	dev_err(dev->mt76.dev, "Error: MAC specific condition occurred\n");
-
-	mt76_set(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_RESET_CSR);
-	udelay(10);
-	mt76_clear(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_RESET_CSR);
-}
-void mt76x0_mac_work(struct work_struct *work)
-{
-	struct mt76x02_dev *dev = container_of(work, struct mt76x02_dev,
-					       mac_work.work);
-	struct {
-		u32 addr_base;
-		u32 span;
-		u64 *stat_base;
-	} spans[] = {
-		{ MT_RX_STAT_0,	3,	dev->stats.rx_stat },
-		{ MT_TX_STA_0,	3,	dev->stats.tx_stat },
-		{ MT_TX_AGG_STAT,	1,	dev->stats.aggr_stat },
-		{ MT_MPDU_DENSITY_CNT,	1,	dev->stats.zero_len_del },
-		{ MT_TX_AGG_CNT_BASE0,	8,	&dev->stats.aggr_n[0] },
-		{ MT_TX_AGG_CNT_BASE1,	8,	&dev->stats.aggr_n[16] },
-	};
-	u32 sum, n;
-	int i, j, k;
-
-	mt76x02_update_channel(&dev->mt76);
-
-	/* Note: using MCU_RANDOM_READ is actually slower then reading all the
-	 *	 registers by hand.  MCU takes ca. 20ms to complete read of 24
-	 *	 registers while reading them one by one will takes roughly
-	 *	 24*200us =~ 5ms.
-	 */
-
-	k = 0;
-	n = 0;
-	sum = 0;
-	for (i = 0; i < ARRAY_SIZE(spans); i++)
-		for (j = 0; j < spans[i].span; j++) {
-			u32 val = mt76_rr(dev, spans[i].addr_base + j * 4);
-
-			spans[i].stat_base[j * 2] += val & 0xffff;
-			spans[i].stat_base[j * 2 + 1] += val >> 16;
-
-			/* Calculate average AMPDU length */
-			if (spans[i].addr_base != MT_TX_AGG_CNT_BASE0 &&
-			    spans[i].addr_base != MT_TX_AGG_CNT_BASE1)
-				continue;
-
-			n += (val >> 16) + (val & 0xffff);
-			sum += (val & 0xffff) * (1 + k * 2) +
-				(val >> 16) * (2 + k * 2);
-			k++;
-		}
-
-	atomic_set(&dev->avg_ampdu_len, n ? DIV_ROUND_CLOSEST(sum, n) : 1);
-
-	mt76x0_check_mac_err(dev);
-
-	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->mac_work, 10 * HZ);
-}
-
 void mt76x0_mac_set_ampdu_factor(struct mt76x02_dev *dev)
 {
 	struct ieee80211_sta *sta;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index b9743b575099..85de821483cd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -69,7 +69,6 @@ void mt76x0_phy_set_txpower(struct mt76x02_dev *dev);
 void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on);
 
 /* MAC */
-void mt76x0_mac_work(struct work_struct *work);
 void mt76x0_mac_set_protection(struct mt76x02_dev *dev, bool legacy_prot,
 				int ht_mode);
 void mt76x0_mac_set_short_preamble(struct mt76x02_dev *dev, bool short_preamb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 58721307d917..bdbe4bbf7a59 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -28,14 +28,6 @@
 
 #define MT_CALIBRATE_INTERVAL	HZ
 
-struct mt76x02_mac_stats {
-	u64 rx_stat[6];
-	u64 tx_stat[6];
-	u64 aggr_stat[2];
-	u64 aggr_n[32];
-	u64 zero_len_del[2];
-};
-
 #define MT_MAX_CHAINS		2
 struct mt76x02_rx_freq_cal {
 	s8 high_gain[MT_MAX_CHAINS];
@@ -85,8 +77,6 @@ struct mt76x02_dev {
 	struct delayed_work cal_work;
 	struct delayed_work mac_work;
 
-	struct mt76x02_mac_stats stats;
-	atomic_t avg_ampdu_len;
 	u32 aggr_stats[32];
 
 	struct sk_buff *beacons[8];
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index c7666f4c432f..3896da690b83 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -754,6 +754,21 @@ void mt76x02_update_channel(struct mt76_dev *mdev)
 }
 EXPORT_SYMBOL_GPL(mt76x02_update_channel);
 
+static void mt76x02_check_mac_err(struct mt76x02_dev *dev)
+{
+	u32 val = mt76_rr(dev, 0x10f4);
+
+	if (!(val & BIT(29)) || !(val & (BIT(7) | BIT(5))))
+		return;
+
+	dev_err(dev->mt76.dev, "mac specific condition occurred\n");
+
+	mt76_set(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_RESET_CSR);
+	udelay(10);
+	mt76_clear(dev, MT_MAC_SYS_CTRL,
+		   MT_MAC_SYS_CTRL_ENABLE_TX | MT_MAC_SYS_CTRL_ENABLE_RX);
+}
+
 void mt76x02_mac_work(struct work_struct *work)
 {
 	struct mt76x02_dev *dev = container_of(work, struct mt76x02_dev,
@@ -768,6 +783,10 @@ void mt76x02_mac_work(struct work_struct *work)
 		dev->aggr_stats[idx++] += val >> 16;
 	}
 
+	/* XXX: check beacon stuck for ap mode */
+	if (!dev->beacon_mask)
+		mt76x02_check_mac_err(dev);
+
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
 				     MT_CALIBRATE_INTERVAL);
 }
-- 
2.19.0

