Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AE14C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 22:19:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10A872089A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 22:19:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10A872089A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbeJBE7W (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 00:59:22 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39324 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbeJBE7W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 00:59:22 -0400
Received: by mail-wm1-f68.google.com with SMTP id q8-v6so293545wmq.4
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 15:19:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sofizYZQ6Af/hLUTeE7SkjM6HylHzM4jAb3lPSawhVk=;
        b=lvsbMMrb4x+nn2ICUqDJ2sgMj2ktZmVfJAYDUb2poMhX/gSUD5zIwawAGRYw/ere+E
         9WzbZvhOJ2LlcdMjDR1idxt16LS1dhdoAWFF3s6vVPiaT5W0JNIl+JL+d0Q754Vd2Rjw
         bV+QA0Fw5fq6ROyZc1jNPjJiLjPuRgq67qfL3gkyF3f3xluhUlylG7TG0x32UPSZMIgP
         v3PtgPnRLr6y0M9R335muPI8TJ0+zrArv/+10iT+IqOKkQMFi1IRyzmI7lFyv1BqUqrH
         c51uYcmUKyNaEJdrzmIdFmpEJK4bTT+vBuIlcM5Bg+shqobceW5/yVwtXrf9+ihTLffJ
         Qs+A==
X-Gm-Message-State: ABuFfohU6i/QmMvhGLrNq5y2EZXnlloCu5gcPv2OnhwO2oLanoJL4NsM
        IjwNMRmZhMJdIWupfMFeSFNTc934pmM=
X-Google-Smtp-Source: ACcGV61jW4kqgZJpK278bDWxK9xCsaD68wr79SHkPq/fw7ONBCzEdCy3mdFfdd9ZgEo8U1ekP4PXlw==
X-Received: by 2002:a1c:af07:: with SMTP id y7-v6mr30529wme.12.1538432362742;
        Mon, 01 Oct 2018 15:19:22 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id t4-v6sm9203420wrb.45.2018.10.01.15.19.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Oct 2018 15:19:22 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 01/10] mt76: move mt76x02_phy_get_min_avg_rssi in mt76x02_phy.c
Date:   Tue,  2 Oct 2018 00:18:59 +0200
Message-Id: <20181001221908.16005-2-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_phy_get_min_avg_rssi in mt76x02-lib module since
it will be used by mt76x0 driver in order to unify rxwi parsing

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x02_phy.c  | 48 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_phy.h  |  1 +
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  1 -
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   |  3 +-
 .../net/wireless/mediatek/mt76/mt76x2/phy.c   | 47 ------------------
 .../wireless/mediatek/mt76/mt76x2/usb_phy.c   |  3 +-
 6 files changed, 53 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
index e29914d78b72..d31ce1d7b689 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
@@ -19,6 +19,7 @@
 
 #include "mt76.h"
 #include "mt76x02_phy.h"
+#include "mt76x02_mac.h"
 
 void mt76x02_phy_set_rxpath(struct mt76_dev *dev)
 {
@@ -133,3 +134,50 @@ void mt76x02_phy_set_txpower(struct mt76_dev *dev, int txp_0, int txp_1)
 		  mt76x02_tx_power_mask(t->ht[7], 0, t->stbc[8], t->stbc[9]));
 }
 EXPORT_SYMBOL_GPL(mt76x02_phy_set_txpower);
+
+int mt76x02_phy_get_min_avg_rssi(struct mt76_dev *dev)
+{
+	struct mt76x02_sta *sta;
+	struct mt76_wcid *wcid;
+	int i, j, min_rssi = 0;
+	s8 cur_rssi;
+
+	local_bh_disable();
+	rcu_read_lock();
+
+	for (i = 0; i < ARRAY_SIZE(dev->wcid_mask); i++) {
+		unsigned long mask = dev->wcid_mask[i];
+
+		if (!mask)
+			continue;
+
+		for (j = i * BITS_PER_LONG; mask; j++, mask >>= 1) {
+			if (!(mask & 1))
+				continue;
+
+			wcid = rcu_dereference(dev->wcid[j]);
+			if (!wcid)
+				continue;
+
+			sta = container_of(wcid, struct mt76x02_sta, wcid);
+			spin_lock(&dev->rx_lock);
+			if (sta->inactive_count++ < 5)
+				cur_rssi = ewma_signal_read(&sta->rssi);
+			else
+				cur_rssi = 0;
+			spin_unlock(&dev->rx_lock);
+
+			if (cur_rssi < min_rssi)
+				min_rssi = cur_rssi;
+		}
+	}
+
+	rcu_read_unlock();
+	local_bh_enable();
+
+	if (!min_rssi)
+		return -75;
+
+	return min_rssi;
+}
+EXPORT_SYMBOL_GPL(mt76x02_phy_get_min_avg_rssi);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
index df69f8fade75..e70ea6eeb077 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
@@ -25,5 +25,6 @@ void mt76x02_limit_rate_power(struct mt76_rate_power *r, int limit);
 int mt76x02_get_max_rate_power(struct mt76_rate_power *r);
 void mt76x02_phy_set_rxpath(struct mt76_dev *dev);
 void mt76x02_phy_set_txdac(struct mt76_dev *dev);
+int mt76x02_phy_get_min_avg_rssi(struct mt76_dev *dev);
 
 #endif /* __MT76x02_PHY_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index 5c3425507adf..f9ca93ad91cd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -202,7 +202,6 @@ void mt76x2_configure_tx_delay(struct mt76x2_dev *dev,
 			       enum nl80211_band band, u8 bw);
 void mt76x2_phy_set_bw(struct mt76x2_dev *dev, int width, u8 ctrl);
 void mt76x2_phy_set_band(struct mt76x2_dev *dev, int band, bool primary_upper);
-int mt76x2_phy_get_min_avg_rssi(struct mt76x2_dev *dev);
 void mt76x2_apply_gain_adj(struct mt76x2_dev *dev);
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
index 392601310e39..2ac0cc6c7126 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
@@ -18,6 +18,7 @@
 #include "mt76x2.h"
 #include "mcu.h"
 #include "eeprom.h"
+#include "../mt76x02_phy.h"
 
 static bool
 mt76x2_phy_tssi_init_cal(struct mt76x2_dev *dev)
@@ -209,7 +210,7 @@ mt76x2_phy_update_channel_gain(struct mt76x2_dev *dev)
 	int low_gain;
 	u32 val;
 
-	dev->cal.avg_rssi_all = mt76x2_phy_get_min_avg_rssi(dev);
+	dev->cal.avg_rssi_all = mt76x02_phy_get_min_avg_rssi(&dev->mt76);
 
 	low_gain = (dev->cal.avg_rssi_all > mt76x2_get_rssi_gain_thresh(dev)) +
 		   (dev->cal.avg_rssi_all > mt76x2_get_low_rssi_gain_thresh(dev));
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
index b3ecb80340b5..06ef2c4a5c11 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
@@ -254,53 +254,6 @@ void mt76x2_phy_set_band(struct mt76x2_dev *dev, int band, bool primary_upper)
 }
 EXPORT_SYMBOL_GPL(mt76x2_phy_set_band);
 
-int mt76x2_phy_get_min_avg_rssi(struct mt76x2_dev *dev)
-{
-	struct mt76x02_sta *sta;
-	struct mt76_wcid *wcid;
-	int i, j, min_rssi = 0;
-	s8 cur_rssi;
-
-	local_bh_disable();
-	rcu_read_lock();
-
-	for (i = 0; i < ARRAY_SIZE(dev->mt76.wcid_mask); i++) {
-		unsigned long mask = dev->mt76.wcid_mask[i];
-
-		if (!mask)
-			continue;
-
-		for (j = i * BITS_PER_LONG; mask; j++, mask >>= 1) {
-			if (!(mask & 1))
-				continue;
-
-			wcid = rcu_dereference(dev->mt76.wcid[j]);
-			if (!wcid)
-				continue;
-
-			sta = container_of(wcid, struct mt76x02_sta, wcid);
-			spin_lock(&dev->mt76.rx_lock);
-			if (sta->inactive_count++ < 5)
-				cur_rssi = ewma_signal_read(&sta->rssi);
-			else
-				cur_rssi = 0;
-			spin_unlock(&dev->mt76.rx_lock);
-
-			if (cur_rssi < min_rssi)
-				min_rssi = cur_rssi;
-		}
-	}
-
-	rcu_read_unlock();
-	local_bh_enable();
-
-	if (!min_rssi)
-		return -75;
-
-	return min_rssi;
-}
-EXPORT_SYMBOL_GPL(mt76x2_phy_get_min_avg_rssi);
-
 void mt76x2_phy_tssi_compensate(struct mt76x2_dev *dev, bool wait)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
index 9dd1943a71bb..b14c073b0006 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
@@ -16,6 +16,7 @@
 
 #include "mt76x2u.h"
 #include "eeprom.h"
+#include "../mt76x02_phy.h"
 
 void mt76x2u_phy_channel_calibrate(struct mt76x2_dev *dev)
 {
@@ -68,7 +69,7 @@ mt76x2u_phy_update_channel_gain(struct mt76x2_dev *dev)
 		break;
 	}
 
-	dev->cal.avg_rssi_all = mt76x2_phy_get_min_avg_rssi(dev);
+	dev->cal.avg_rssi_all = mt76x02_phy_get_min_avg_rssi(&dev->mt76);
 	false_cca = FIELD_GET(MT_RX_STAT_1_CCA_ERRORS,
 			      mt76_rr(dev, MT_RX_STAT_1));
 
-- 
2.19.0

