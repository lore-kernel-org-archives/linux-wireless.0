Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 403AAC64EBC
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1049421473
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:07:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1049421473
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbeJDTAB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 15:00:01 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37993 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbeJDTAB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 15:00:01 -0400
Received: by mail-wr1-f67.google.com with SMTP id a13-v6so9629523wrt.5
        for <linux-wireless@vger.kernel.org>; Thu, 04 Oct 2018 05:07:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RE4lLDCyjxliiY4cUvvB5uog5LQZEeOC7lPjnkUrcRg=;
        b=O1Rm8APG4T1VJW5z3whlsv3V5Dr0IP2kBMzRhrwsha38qYM3fhs8JuTF/BIwO0k7pY
         bghQyMNVUI1JqK73KxziV+bVG0/lOMejD4TF4GRGNFU6RWzc1zGagwpPtR1Qwf4qtSRP
         OTiEcWDmcmTsdOKCpHi04XuMeuqQkCwE8IMs/pFETPHJm7/e2uJ5hzjAFdMvtPehvCfO
         yzHOahfw7colN4f6BnkRa/XYHxMKpCa9U/ikO9w/pW0wIDMpIBESwgGEIoptYLMIgvUL
         JzbHGKopAVyCXVOx3015FDr+3Lv6xLQMK6T6xyhDsSAbusf/AgTV8R/qRkP8dk64ZkGs
         RhYg==
X-Gm-Message-State: ABuFfojJ78D0gY8iIM+FM+ssr9Ro496f8gWq2a3KhP37q4QHKo4nL4i3
        c2BnPixETzOsfZE8qoMwla4IqA==
X-Google-Smtp-Source: ACcGV620v9dLD/K5f8CK3S/CsAnyV7yJmJXjOCl6VuZpt5Im4tpbS2WXfQpnQBIDQzGSUmGv8+EIdQ==
X-Received: by 2002:adf:ade3:: with SMTP id w90-v6mr4523855wrc.73.1538654819184;
        Thu, 04 Oct 2018 05:06:59 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id j2-v6sm4991195wrw.29.2018.10.04.05.06.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Oct 2018 05:06:58 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 2/7] mt76: use mt76x02_dev instead of mt76_dev in mt76x02_phy.c
Date:   Thu,  4 Oct 2018 14:06:45 +0200
Message-Id: <cb676884b1fddae0563f075a869514fade759446.1538654389.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538654389.git.lorenzo.bianconi@redhat.com>
References: <cover.1538654389.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76x02_dev data structure as reference in mt76x02_phy.c
instead of mt76_dev

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  8 +-
 .../net/wireless/mediatek/mt76/mt76x02_phy.c  | 89 +++++++++----------
 .../net/wireless/mediatek/mt76/mt76x02_phy.h  |  8 +-
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2/phy.c   |  2 +-
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |  4 +-
 .../wireless/mediatek/mt76/mt76x2/usb_phy.c   |  2 +-
 7 files changed, 56 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index a59e2dcd83f7..376f2dbf013d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -603,7 +603,7 @@ void mt76x0_phy_set_txpower(struct mt76x02_dev *dev)
 	dev->mt76.txpower_cur = mt76x02_get_max_rate_power(t);
 	mt76x02_add_rate_power_offset(t, -info[0]);
 
-	mt76x02_phy_set_txpower(&dev->mt76, info[0], info[1]);
+	mt76x02_phy_set_txpower(dev, info[0], info[1]);
 }
 
 int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
@@ -800,7 +800,7 @@ static void mt76x0_dynamic_vga_tuning(struct mt76x02_dev *dev)
 	int avg_rssi;
 
 	init_vga = chandef->chan->band == NL80211_BAND_5GHZ ? 0x54 : 0x4E;
-	avg_rssi = mt76x02_phy_get_min_avg_rssi(&dev->mt76);
+	avg_rssi = mt76x02_phy_get_min_avg_rssi(dev);
 	if (avg_rssi > -60)
 		init_vga -= 0x20;
 	else if (avg_rssi > -70)
@@ -882,6 +882,6 @@ void mt76x0_phy_init(struct mt76x02_dev *dev)
 	INIT_DELAYED_WORK(&dev->cal_work, mt76x0_phy_calibrate);
 
 	mt76x0_rf_init(dev);
-	mt76x02_phy_set_rxpath(&dev->mt76);
-	mt76x02_phy_set_txdac(&dev->mt76);
+	mt76x02_phy_set_rxpath(dev);
+	mt76x02_phy_set_txdac(dev);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
index d31ce1d7b689..c398471b6376 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
@@ -17,18 +17,17 @@
 
 #include <linux/kernel.h>
 
-#include "mt76.h"
+#include "mt76x02.h"
 #include "mt76x02_phy.h"
-#include "mt76x02_mac.h"
 
-void mt76x02_phy_set_rxpath(struct mt76_dev *dev)
+void mt76x02_phy_set_rxpath(struct mt76x02_dev *dev)
 {
 	u32 val;
 
-	val = __mt76_rr(dev, MT_BBP(AGC, 0));
+	val = mt76_rr(dev, MT_BBP(AGC, 0));
 	val &= ~BIT(4);
 
-	switch (dev->chainmask & 0xf) {
+	switch (dev->mt76.chainmask & 0xf) {
 	case 2:
 		val |= BIT(3);
 		break;
@@ -37,23 +36,23 @@ void mt76x02_phy_set_rxpath(struct mt76_dev *dev)
 		break;
 	}
 
-	__mt76_wr(dev, MT_BBP(AGC, 0), val);
+	mt76_wr(dev, MT_BBP(AGC, 0), val);
 	mb();
-	val = __mt76_rr(dev, MT_BBP(AGC, 0));
+	val = mt76_rr(dev, MT_BBP(AGC, 0));
 }
 EXPORT_SYMBOL_GPL(mt76x02_phy_set_rxpath);
 
-void mt76x02_phy_set_txdac(struct mt76_dev *dev)
+void mt76x02_phy_set_txdac(struct mt76x02_dev *dev)
 {
 	int txpath;
 
-	txpath = (dev->chainmask >> 8) & 0xf;
+	txpath = (dev->mt76.chainmask >> 8) & 0xf;
 	switch (txpath) {
 	case 2:
-		__mt76_set(dev, MT_BBP(TXBE, 5), 0x3);
+		mt76_set(dev, MT_BBP(TXBE, 5), 0x3);
 		break;
 	default:
-		__mt76_clear(dev, MT_BBP(TXBE, 5), 0x3);
+		mt76_clear(dev, MT_BBP(TXBE, 5), 0x3);
 		break;
 	}
 }
@@ -102,40 +101,38 @@ void mt76x02_add_rate_power_offset(struct mt76_rate_power *r, int offset)
 }
 EXPORT_SYMBOL_GPL(mt76x02_add_rate_power_offset);
 
-void mt76x02_phy_set_txpower(struct mt76_dev *dev, int txp_0, int txp_1)
+void mt76x02_phy_set_txpower(struct mt76x02_dev *dev, int txp_0, int txp_1)
 {
-	struct mt76_rate_power *t = &dev->rate_power;
-
-	__mt76_rmw_field(dev, MT_TX_ALC_CFG_0, MT_TX_ALC_CFG_0_CH_INIT_0,
-			 txp_0);
-	__mt76_rmw_field(dev, MT_TX_ALC_CFG_0, MT_TX_ALC_CFG_0_CH_INIT_1,
-			 txp_1);
-
-	__mt76_wr(dev, MT_TX_PWR_CFG_0,
-		  mt76x02_tx_power_mask(t->cck[0], t->cck[2], t->ofdm[0],
-					t->ofdm[2]));
-	__mt76_wr(dev, MT_TX_PWR_CFG_1,
-		  mt76x02_tx_power_mask(t->ofdm[4], t->ofdm[6], t->ht[0],
-					t->ht[2]));
-	__mt76_wr(dev, MT_TX_PWR_CFG_2,
-		  mt76x02_tx_power_mask(t->ht[4], t->ht[6], t->ht[8],
-					t->ht[10]));
-	__mt76_wr(dev, MT_TX_PWR_CFG_3,
-		  mt76x02_tx_power_mask(t->ht[12], t->ht[14], t->stbc[0],
-					t->stbc[2]));
-	__mt76_wr(dev, MT_TX_PWR_CFG_4,
-		  mt76x02_tx_power_mask(t->stbc[4], t->stbc[6], 0, 0));
-	__mt76_wr(dev, MT_TX_PWR_CFG_7,
-		  mt76x02_tx_power_mask(t->ofdm[7], t->vht[8], t->ht[7],
-					t->vht[9]));
-	__mt76_wr(dev, MT_TX_PWR_CFG_8,
-		  mt76x02_tx_power_mask(t->ht[14], 0, t->vht[8], t->vht[9]));
-	__mt76_wr(dev, MT_TX_PWR_CFG_9,
-		  mt76x02_tx_power_mask(t->ht[7], 0, t->stbc[8], t->stbc[9]));
+	struct mt76_rate_power *t = &dev->mt76.rate_power;
+
+	mt76_rmw_field(dev, MT_TX_ALC_CFG_0, MT_TX_ALC_CFG_0_CH_INIT_0, txp_0);
+	mt76_rmw_field(dev, MT_TX_ALC_CFG_0, MT_TX_ALC_CFG_0_CH_INIT_1, txp_1);
+
+	mt76_wr(dev, MT_TX_PWR_CFG_0,
+		mt76x02_tx_power_mask(t->cck[0], t->cck[2], t->ofdm[0],
+				      t->ofdm[2]));
+	mt76_wr(dev, MT_TX_PWR_CFG_1,
+		mt76x02_tx_power_mask(t->ofdm[4], t->ofdm[6], t->ht[0],
+				      t->ht[2]));
+	mt76_wr(dev, MT_TX_PWR_CFG_2,
+		mt76x02_tx_power_mask(t->ht[4], t->ht[6], t->ht[8],
+				      t->ht[10]));
+	mt76_wr(dev, MT_TX_PWR_CFG_3,
+		mt76x02_tx_power_mask(t->ht[12], t->ht[14], t->stbc[0],
+				      t->stbc[2]));
+	mt76_wr(dev, MT_TX_PWR_CFG_4,
+		mt76x02_tx_power_mask(t->stbc[4], t->stbc[6], 0, 0));
+	mt76_wr(dev, MT_TX_PWR_CFG_7,
+		mt76x02_tx_power_mask(t->ofdm[7], t->vht[8], t->ht[7],
+				      t->vht[9]));
+	mt76_wr(dev, MT_TX_PWR_CFG_8,
+		mt76x02_tx_power_mask(t->ht[14], 0, t->vht[8], t->vht[9]));
+	mt76_wr(dev, MT_TX_PWR_CFG_9,
+		mt76x02_tx_power_mask(t->ht[7], 0, t->stbc[8], t->stbc[9]));
 }
 EXPORT_SYMBOL_GPL(mt76x02_phy_set_txpower);
 
-int mt76x02_phy_get_min_avg_rssi(struct mt76_dev *dev)
+int mt76x02_phy_get_min_avg_rssi(struct mt76x02_dev *dev)
 {
 	struct mt76x02_sta *sta;
 	struct mt76_wcid *wcid;
@@ -145,8 +142,8 @@ int mt76x02_phy_get_min_avg_rssi(struct mt76_dev *dev)
 	local_bh_disable();
 	rcu_read_lock();
 
-	for (i = 0; i < ARRAY_SIZE(dev->wcid_mask); i++) {
-		unsigned long mask = dev->wcid_mask[i];
+	for (i = 0; i < ARRAY_SIZE(dev->mt76.wcid_mask); i++) {
+		unsigned long mask = dev->mt76.wcid_mask[i];
 
 		if (!mask)
 			continue;
@@ -155,17 +152,17 @@ int mt76x02_phy_get_min_avg_rssi(struct mt76_dev *dev)
 			if (!(mask & 1))
 				continue;
 
-			wcid = rcu_dereference(dev->wcid[j]);
+			wcid = rcu_dereference(dev->mt76.wcid[j]);
 			if (!wcid)
 				continue;
 
 			sta = container_of(wcid, struct mt76x02_sta, wcid);
-			spin_lock(&dev->rx_lock);
+			spin_lock(&dev->mt76.rx_lock);
 			if (sta->inactive_count++ < 5)
 				cur_rssi = ewma_signal_read(&sta->rssi);
 			else
 				cur_rssi = 0;
-			spin_unlock(&dev->rx_lock);
+			spin_unlock(&dev->mt76.rx_lock);
 
 			if (cur_rssi < min_rssi)
 				min_rssi = cur_rssi;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
index e70ea6eeb077..c370b4cc68ee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
@@ -20,11 +20,11 @@
 #include "mt76x02_regs.h"
 
 void mt76x02_add_rate_power_offset(struct mt76_rate_power *r, int offset);
-void mt76x02_phy_set_txpower(struct mt76_dev *dev, int txp_0, int txp_2);
+void mt76x02_phy_set_txpower(struct mt76x02_dev *dev, int txp_0, int txp_2);
 void mt76x02_limit_rate_power(struct mt76_rate_power *r, int limit);
 int mt76x02_get_max_rate_power(struct mt76_rate_power *r);
-void mt76x02_phy_set_rxpath(struct mt76_dev *dev);
-void mt76x02_phy_set_txdac(struct mt76_dev *dev);
-int mt76x02_phy_get_min_avg_rssi(struct mt76_dev *dev);
+void mt76x02_phy_set_rxpath(struct mt76x02_dev *dev);
+void mt76x02_phy_set_txdac(struct mt76x02_dev *dev);
+int mt76x02_phy_get_min_avg_rssi(struct mt76x02_dev *dev);
 
 #endif /* __MT76x02_PHY_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
index bdc6fba217b1..aff0363e0958 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
@@ -210,7 +210,7 @@ mt76x2_phy_update_channel_gain(struct mt76x02_dev *dev)
 	int low_gain;
 	u32 val;
 
-	dev->cal.avg_rssi_all = mt76x02_phy_get_min_avg_rssi(&dev->mt76);
+	dev->cal.avg_rssi_all = mt76x02_phy_get_min_avg_rssi(dev);
 
 	low_gain = (dev->cal.avg_rssi_all > mt76x2_get_rssi_gain_thresh(dev)) +
 		   (dev->cal.avg_rssi_all > mt76x2_get_low_rssi_gain_thresh(dev));
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
index 31bf0f891028..93bcab7cccfd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
@@ -187,7 +187,7 @@ void mt76x2_phy_set_txpower(struct mt76x02_dev *dev)
 	dev->target_power_delta[1] = txp_1 - txp.chain[0].target_power;
 	dev->mt76.rate_power = t;
 
-	mt76x02_phy_set_txpower(&dev->mt76, txp_0, txp_1);
+	mt76x02_phy_set_txpower(dev, txp_0, txp_1);
 }
 EXPORT_SYMBOL_GPL(mt76x2_phy_set_txpower);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index 7578c7dcd62a..6214781714c4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -237,8 +237,8 @@ int mt76x2u_init_hardware(struct mt76x02_dev *dev)
 	if (err < 0)
 		return err;
 
-	mt76x02_phy_set_rxpath(&dev->mt76);
-	mt76x02_phy_set_txdac(&dev->mt76);
+	mt76x02_phy_set_rxpath(dev);
+	mt76x02_phy_set_txdac(dev);
 
 	return mt76x2u_mac_stop(dev);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
index e0ffdd51dced..c4c437770fc9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
@@ -69,7 +69,7 @@ mt76x2u_phy_update_channel_gain(struct mt76x02_dev *dev)
 		break;
 	}
 
-	dev->cal.avg_rssi_all = mt76x02_phy_get_min_avg_rssi(&dev->mt76);
+	dev->cal.avg_rssi_all = mt76x02_phy_get_min_avg_rssi(dev);
 	false_cca = FIELD_GET(MT_RX_STAT_1_CCA_ERRORS,
 			      mt76_rr(dev, MT_RX_STAT_1));
 
-- 
2.17.1

