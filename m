Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D6DC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70B0520868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 70B0520868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbeJLRsi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 13:48:38 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52367 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728457AbeJLRsh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 13:48:37 -0400
Received: by mail-wm1-f67.google.com with SMTP id 189-v6so11769475wmw.2
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 03:16:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kZxyi2P2T3uYGSMsGiGwHxzqrWPRNEx5ThQrzVMbffw=;
        b=HvJ6duAZOZQwwTRcf9uYka2A2qEYtmMmKlKTngIJr9h6X/MeKYBz109UY4mxJzr1gT
         8517U+MDYwY8eWvykA73lv2e1eiiyh/eAum2ADRs7p2kojZ6xjAXw/II8hnf6sq2U6E7
         ejDz2tcz+xg/6E7dhRqMSnB56Jh073y5CEOE/KIDoLHF1zFsMLTeRVrdKPDl4B+RZ0dD
         /yFPf+eqr6cLm8XexIQhvu89XcZpIfBPIyJn62xgALknq9n8A+rBzMsLPUU6LIQOI6pU
         2/UZOm306cc7dpr8YyqEjxIIff7IDPNvtLT9AJrsFZhrmyFJDRZV+30hbbMoSL7iKdIK
         0LLg==
X-Gm-Message-State: ABuFfohaBS8+OgDeGV1cMsMP7WIKU+9jDg5CbfD8Ay9QOVX6+HNaXKIC
        snVRK35oTAUOyM+E6T+88VSvqQ==
X-Google-Smtp-Source: ACcGV61i10jyU0hPlXtkn89/VO8+SEDe8tSvD+QLqvEh8nFZ4qdO2hoZBlz1TIL0hX6S7vjQfwfCVQ==
X-Received: by 2002:a1c:448a:: with SMTP id r132-v6mr4792430wma.132.1539339413942;
        Fri, 12 Oct 2018 03:16:53 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r2-v6sm473179wrq.1.2018.10.12.03.16.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 03:16:53 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 12/13] mt76x0: phy: do not run calibration during channel switch
Date:   Fri, 12 Oct 2018 12:16:28 +0200
Message-Id: <adbb31aad18331d356b4abd135611e3158f1a8ef.1539338611.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
References: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Do not perform phy/vga calibration during channel switch.
Moreover remove mt76x0_agc_save and mt76x0_agc_restore routines
since they are no longer necessary. Furthermore run mt76_set_channel
in order to check if there are pending frames during channel switch

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/main.c  | 22 ++++++++++++------
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  2 --
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 23 +++++++------------
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  2 --
 4 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index c9cd0254a979..9273d2d2764a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -16,6 +16,20 @@
 #include <linux/etherdevice.h>
 #include "mt76x0.h"
 
+static int
+mt76x0_set_channel(struct mt76x02_dev *dev, struct cfg80211_chan_def *chandef)
+{
+	int ret;
+
+	cancel_delayed_work_sync(&dev->cal_work);
+
+	mt76_set_channel(&dev->mt76);
+	ret = mt76x0_phy_set_channel(dev, chandef);
+	mt76_txq_schedule_all(&dev->mt76);
+
+	return ret;
+}
+
 int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct mt76x02_dev *dev = hw->priv;
@@ -25,7 +39,7 @@ int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		ieee80211_stop_queues(hw);
-		ret = mt76x0_phy_set_channel(dev, &hw->conf.chandef);
+		ret = mt76x0_set_channel(dev, &hw->conf.chandef);
 		ieee80211_wake_queues(hw);
 	}
 
@@ -114,8 +128,6 @@ void mt76x0_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 {
 	struct mt76x02_dev *dev = hw->priv;
 
-	cancel_delayed_work_sync(&dev->cal_work);
-	mt76x0_agc_save(dev);
 	set_bit(MT76_SCANNING, &dev->mt76.state);
 }
 EXPORT_SYMBOL_GPL(mt76x0_sw_scan);
@@ -125,11 +137,7 @@ void mt76x0_sw_scan_complete(struct ieee80211_hw *hw,
 {
 	struct mt76x02_dev *dev = hw->priv;
 
-	mt76x0_agc_restore(dev);
 	clear_bit(MT76_SCANNING, &dev->mt76.state);
-
-	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
-				     MT_CALIBRATE_INTERVAL);
 }
 EXPORT_SYMBOL_GPL(mt76x0_sw_scan_complete);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 6717d83e0ff6..2187bafaf2e9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -66,8 +66,6 @@ int mt76x0_set_rts_threshold(struct ieee80211_hw *hw, u32 value);
 /* PHY */
 void mt76x0_phy_init(struct mt76x02_dev *dev);
 int mt76x0_wait_bbp_ready(struct mt76x02_dev *dev);
-void mt76x0_agc_save(struct mt76x02_dev *dev);
-void mt76x0_agc_restore(struct mt76x02_dev *dev);
 int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 			    struct cfg80211_chan_def *chandef);
 void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 3d0fcf8c34b4..cf024950e0ed 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -723,17 +723,21 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 
 	if (mt76_is_usb(dev)) {
 		mt76x0_vco_cal(dev, channel);
-		if (scan)
-			mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1,
-					      false);
 	} else {
 		/* enable vco */
 		rf_set(dev, MT_RF(0, 4), BIT(7));
-		mt76x0_phy_calibrate(dev, false);
 	}
 
+	if (scan)
+		return 0;
+
+	if (mt76_is_mmio(dev))
+		mt76x0_phy_calibrate(dev, false);
 	mt76x0_phy_set_txpower(dev);
 
+	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
+				     MT_CALIBRATE_INTERVAL);
+
 	return 0;
 }
 
@@ -770,17 +774,6 @@ void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev)
 	mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1, false);
 }
 
-void mt76x0_agc_save(struct mt76x02_dev *dev)
-{
-	/* Only one RX path */
-	dev->agc_save = FIELD_GET(MT_BBP_AGC_GAIN, mt76_rr(dev, MT_BBP(AGC, 8)));
-}
-
-void mt76x0_agc_restore(struct mt76x02_dev *dev)
-{
-	mt76_rmw_field(dev, MT_BBP(AGC, 8), MT_BBP_AGC_GAIN, dev->agc_save);
-}
-
 static void mt76x0_temp_sensor(struct mt76x02_dev *dev)
 {
 	u8 rf_b7_73, rf_b0_66, rf_b0_67;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index f375fdcbd2bf..47c42c607964 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -102,8 +102,6 @@ struct mt76x02_dev {
 
 	bool no_2ghz;
 
-	u8 agc_save;
-
 	u8 coverage_class;
 	u8 slottime;
 
-- 
2.17.2

