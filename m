Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06655C04AA5
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 12:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF0DC2083C
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 12:18:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF0DC2083C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbeJOUD3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Oct 2018 16:03:29 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37514 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbeJOUD2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Oct 2018 16:03:28 -0400
Received: by mail-wm1-f68.google.com with SMTP id 185-v6so19472932wmt.2
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2018 05:18:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xJ6VvgsSuMqNmK8zWTsi6lxsVT/YnWSoKj5eA7rvDAg=;
        b=X/U2fvz++kT91dxPB0GBRY3oX/iQRFCnc62ZrK55BBK7aO5giT6GSrnOvLgkEuihUk
         vhvQrGG61LQ2gm2T6wN1CnQIGNvcNuIq/G8NjmnG+Q3KyUqec77u59d4NQQQNDPIWbQs
         0fTw0VOuHlgzm2cZreCrSAK7jr5qHoK4hPLSYEu4EVoRRn666l+/cbYL5h4jgn38NlzR
         4BE423RWzzP3W+HqhmZGML+ks+IV7pG6f8yeKsyGAvDA53v8S7urtuFLuPdIh1vLK+fv
         qYMkuelIqJ9qTGEnjEvoW2N8hyqCCsT2B6UGX6XXZ9Is9JBMABsZEZQzmwL5x8Uf9mjg
         15CA==
X-Gm-Message-State: ABuFfoiEuwz+kPB2k0X0atvB6t6HhJcTMKiCATjFzhzI4oZf6+Pg0imG
        ohSrv7uTeslLGKOqPHZpeXGEV6bafnw=
X-Google-Smtp-Source: ACcGV62UATEvhJo4zv1l8591DrRjB91obwT3wwZD6V2n8oVGS8wSKj/oaR6ampYl/eDyLe0n24rqow==
X-Received: by 2002:a1c:2dc5:: with SMTP id t188-v6mr12332571wmt.94.1539605903802;
        Mon, 15 Oct 2018 05:18:23 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r16-v6sm9665210wrv.21.2018.10.15.05.18.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Oct 2018 05:18:23 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: phy: unify calibration between mt76x0u and mt76x0e
Date:   Mon, 15 Oct 2018 14:18:05 +0200
Message-Id: <1a6c35a4ade74f3643955f70ea4953fde56b9396.1539605745.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539605745.git.lorenzo.bianconi@redhat.com>
References: <cover.1539605745.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Align phy calibration logic between mt76x0u and mt76x0e drivers
This patch improves connection stability with low SNR

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/main.c  |  3 -
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  1 -
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 83 +------------------
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |  1 +
 4 files changed, 4 insertions(+), 84 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index e9fbbabbe7e0..fdffbdf90e59 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -121,9 +121,6 @@ void mt76x0_bss_info_changed(struct ieee80211_hw *hw,
 			       MT_BKOFF_SLOT_CFG_SLOTTIME, slottime);
 	}
 
-	if (changed & BSS_CHANGED_ASSOC)
-		mt76x0_phy_recalibrate_after_assoc(dev);
-
 	mutex_unlock(&dev->mt76.mutex);
 }
 EXPORT_SYMBOL_GPL(mt76x0_bss_info_changed);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 85de821483cd..17ad3fa0858b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -64,7 +64,6 @@ void mt76x0_phy_init(struct mt76x02_dev *dev);
 int mt76x0_phy_wait_bbp_ready(struct mt76x02_dev *dev);
 int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 			    struct cfg80211_chan_def *chandef);
-void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev);
 void mt76x0_phy_set_txpower(struct mt76x02_dev *dev);
 void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 53927547cf12..dbb92586b6e1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -212,44 +212,6 @@ int mt76x0_phy_wait_bbp_ready(struct mt76x02_dev *dev)
 	return 0;
 }
 
-static void mt76x0_phy_vco_cal(struct mt76x02_dev *dev, u8 channel)
-{
-	u8 val;
-
-	val = mt76x0_rf_rr(dev, MT_RF(0, 4));
-	if ((val & 0x70) != 0x30)
-		return;
-
-	/* closed loop calibarion - B0.R06.[3:0]: 1001 */
-	mt76x0_rf_rmw(dev, MT_RF(0, 6), MT_RF_VCO_BP_CLOSE_LOOP_MASK,
-		      MT_RF_VCO_BP_CLOSE_LOOP | BIT(0));
-
-	/* open loop calibration - B0.R05.[7:0]: 0x0 */
-	mt76x0_rf_wr(dev, MT_RF(0, 5), 0x0);
-
-	/* caliration mask - B0.R04.[2:0]: 000 */
-	mt76x0_rf_clear(dev, MT_RF(0, 4), MT_RF_VCO_CAL_MASK);
-
-	/* startup time - B0.R03.[2:0] startup_time: 011 */
-	mt76x0_rf_rmw(dev, MT_RF(0, 3), MT_RF_START_TIME_MASK,
-		      MT_RF_START_TIME);
-
-	/* settle_time - B0.R03.[6:4] */
-	if (channel == 3 || channel == 4 || channel == 10)
-		val = 0x50;
-	else if (channel == 2 || channel == 5 || channel == 6 ||
-		 channel == 8 || channel == 11 || channel == 12)
-		val = 0x40;
-	else
-		val = 0x60;
-	mt76x0_rf_rmw(dev, MT_RF(0, 3), MT_RF_SETTLE_TIME_MASK, val);
-
-	/* enable vco */
-	mt76x0_rf_set(dev, MT_RF(0, 4), BIT(7));
-
-	msleep(2);
-}
-
 static void
 mt76x0_phy_set_band(struct mt76x02_dev *dev, enum nl80211_band band)
 {
@@ -670,18 +632,12 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 	mt76x0_phy_set_chan_bbp_params(dev, rf_bw_band);
 	mt76x02_init_agc_gain(dev);
 
-	if (mt76_is_usb(dev)) {
-		mt76x0_phy_vco_cal(dev, channel);
-	} else {
-		/* enable vco */
-		mt76x0_rf_set(dev, MT_RF(0, 4), BIT(7));
-	}
-
+	/* enable vco */
+	mt76x0_rf_set(dev, MT_RF(0, 4), BIT(7));
 	if (scan)
 		return 0;
 
-	if (mt76_is_mmio(dev))
-		mt76x0_phy_calibrate(dev, false);
+	mt76x0_phy_calibrate(dev, false);
 	mt76x0_phy_set_txpower(dev);
 
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
@@ -690,39 +646,6 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 	return 0;
 }
 
-void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev)
-{
-	u32 tx_alc, reg_val;
-	u8 channel = dev->mt76.chandef.chan->hw_value;
-	int is_5ghz = (dev->mt76.chandef.chan->band == NL80211_BAND_5GHZ) ? 1 : 0;
-
-	mt76x02_mcu_calibrate(dev, MCU_CAL_R, 0, false);
-
-	mt76x0_phy_vco_cal(dev, channel);
-
-	tx_alc = mt76_rr(dev, MT_TX_ALC_CFG_0);
-	mt76_wr(dev, MT_TX_ALC_CFG_0, 0);
-	usleep_range(500, 700);
-
-	reg_val = mt76_rr(dev, MT_BBP(IBI, 9));
-	mt76_wr(dev, MT_BBP(IBI, 9), 0xffffff7e);
-
-	mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 0, false);
-
-	mt76x02_mcu_calibrate(dev, MCU_CAL_LC, is_5ghz, false);
-	mt76x02_mcu_calibrate(dev, MCU_CAL_LOFT, is_5ghz, false);
-	mt76x02_mcu_calibrate(dev, MCU_CAL_TXIQ, is_5ghz, false);
-	mt76x02_mcu_calibrate(dev, MCU_CAL_TX_GROUP_DELAY, is_5ghz, false);
-	mt76x02_mcu_calibrate(dev, MCU_CAL_RXIQ, is_5ghz, false);
-	mt76x02_mcu_calibrate(dev, MCU_CAL_RX_GROUP_DELAY, is_5ghz, false);
-
-	mt76_wr(dev, MT_BBP(IBI, 9), reg_val);
-	mt76_wr(dev, MT_TX_ALC_CFG_0, tx_alc);
-	msleep(100);
-
-	mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1, false);
-}
-
 static void mt76x0_phy_temp_sensor(struct mt76x02_dev *dev)
 {
 	u8 rf_b7_73, rf_b0_66, rf_b0_67;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index a7fd36c2f633..ea517864186b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -117,6 +117,7 @@ static int mt76x0u_start(struct ieee80211_hw *hw)
 	if (ret)
 		goto out;
 
+	mt76x0_phy_calibrate(dev, true);
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->mac_work,
 				     MT_CALIBRATE_INTERVAL);
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
-- 
2.17.2

