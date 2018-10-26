Return-Path: <SRS0=rthY=NG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86208ECDE46
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 12:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42AF52084D
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 12:00:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42AF52084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbeJZUhs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 16:37:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36054 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727469AbeJZUhs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 16:37:48 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 59A6830C9EF2;
        Fri, 26 Oct 2018 12:00:58 +0000 (UTC)
Received: from localhost (unknown [10.40.205.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1404648A3;
        Fri, 26 Oct 2018 12:00:57 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] mt76: remove wait argument from mt76x02_mcu_calibrate
Date:   Fri, 26 Oct 2018 14:00:27 +0200
Message-Id: <1540555229-28582-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1540555229-28582-1-git-send-email-sgruszka@redhat.com>
References: <1540555229-28582-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 26 Oct 2018 12:00:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

We always wait for CMD_CALIBRATION_OP mcu message, but wait argument is used
for do additioanl MT_MCU_COM_REG0 register operations, which are needed
for MMIO devices and we can use mt76_is_mmio() check instead of wait argument.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    | 14 ++++++--------
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c   |  7 +++----
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h   |  3 +--
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_phy.c    | 22 +++++++++++-----------
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c    |  4 ++--
 .../net/wireless/mediatek/mt76/mt76x2/usb_phy.c    | 20 ++++++++++----------
 7 files changed, 34 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index ca24b5716b58..42351179c3cc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -529,9 +529,8 @@ void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on)
 		return;
 
 	if (power_on) {
-		mt76x02_mcu_calibrate(dev, MCU_CAL_R, 0, false);
-		mt76x02_mcu_calibrate(dev, MCU_CAL_VCO, chan->hw_value,
-				      false);
+		mt76x02_mcu_calibrate(dev, MCU_CAL_R, 0);
+		mt76x02_mcu_calibrate(dev, MCU_CAL_VCO, chan->hw_value);
 		usleep_range(10, 20);
 		/* XXX: tssi */
 	}
@@ -554,14 +553,14 @@ void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on)
 		val = 0x600;
 	}
 
-	mt76x02_mcu_calibrate(dev, MCU_CAL_FULL, val, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_FULL, val);
 	msleep(350);
-	mt76x02_mcu_calibrate(dev, MCU_CAL_LC, is_5ghz, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_LC, is_5ghz);
 	usleep_range(15000, 20000);
 
 	mt76_wr(dev, MT_BBP(IBI, 9), reg_val);
 	mt76_wr(dev, MT_TX_ALC_CFG_0, tx_alc);
-	mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1);
 }
 EXPORT_SYMBOL_GPL(mt76x0_phy_calibrate);
 
@@ -698,8 +697,7 @@ static void mt76x0_phy_temp_sensor(struct mt76x02_dev *dev)
 
 	if (abs(val - dev->cal.temp_vco) > 20) {
 		mt76x02_mcu_calibrate(dev, MCU_CAL_VCO,
-				      dev->mt76.chandef.chan->hw_value,
-				      false);
+				      dev->mt76.chandef.chan->hw_value);
 		dev->cal.temp_vco = val;
 	}
 	if (abs(val - dev->cal.temp) > 30) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
index 550e73f81438..254bf3d22d94 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
@@ -165,8 +165,7 @@ int mt76x02_mcu_set_radio_state(struct mt76x02_dev *dev, bool on,
 }
 EXPORT_SYMBOL_GPL(mt76x02_mcu_set_radio_state);
 
-int mt76x02_mcu_calibrate(struct mt76x02_dev *dev, int type,
-			  u32 param, bool wait)
+int mt76x02_mcu_calibrate(struct mt76x02_dev *dev, int type, u32 param)
 {
 	struct {
 		__le32 id;
@@ -177,7 +176,7 @@ int mt76x02_mcu_calibrate(struct mt76x02_dev *dev, int type,
 	};
 	int ret;
 
-	if (wait)
+	if (mt76_is_mmio(dev))
 		mt76_rmw(dev, MT_MCU_COM_REG0, BIT(31), 0);
 
 	ret = mt76_mcu_send_msg(dev, CMD_CALIBRATION_OP, &msg, sizeof(msg),
@@ -185,7 +184,7 @@ int mt76x02_mcu_calibrate(struct mt76x02_dev *dev, int type,
 	if (ret)
 		return ret;
 
-	if (wait &&
+	if (mt76_is_mmio(dev) &&
 	    WARN_ON(!mt76_poll_msec(dev, MT_MCU_COM_REG0,
 				    BIT(31), BIT(31), 100)))
 		return -ETIMEDOUT;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
index a3aee579d42c..605cdb44961a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
@@ -97,8 +97,7 @@ struct mt76x02_patch_header {
 };
 
 int mt76x02_mcu_cleanup(struct mt76x02_dev *dev);
-int mt76x02_mcu_calibrate(struct mt76x02_dev *dev, int type,
-			  u32 param, bool wait);
+int mt76x02_mcu_calibrate(struct mt76x02_dev *dev, int type, u32 param);
 int mt76x02_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
 			 int len, bool wait_resp);
 int mt76x02_mcu_function_select(struct mt76x02_dev *dev,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index e5846a85d6ab..b259e4b50f1e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -78,7 +78,7 @@ void mt76x2_init_txpower(struct mt76x02_dev *dev,
 			 struct ieee80211_supported_band *sband);
 void mt76_write_mac_initvals(struct mt76x02_dev *dev);
 
-void mt76x2_phy_tssi_compensate(struct mt76x02_dev *dev, bool wait);
+void mt76x2_phy_tssi_compensate(struct mt76x02_dev *dev);
 void mt76x2_phy_set_txpower_regs(struct mt76x02_dev *dev,
 				 enum nl80211_band band);
 void mt76x2_configure_tx_delay(struct mt76x02_dev *dev,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
index 16ff6c376373..59ef7931df50 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
@@ -38,7 +38,7 @@ mt76x2_phy_tssi_init_cal(struct mt76x02_dev *dev)
 	if (mt76x02_ext_pa_enabled(dev, chan->band))
 		flag |= BIT(8);
 
-	mt76x02_mcu_calibrate(dev, MCU_CAL_TSSI, flag, true);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_TSSI, flag);
 	dev->cal.tssi_cal_done = true;
 	return true;
 }
@@ -62,13 +62,13 @@ mt76x2_phy_channel_calibrate(struct mt76x02_dev *dev, bool mac_stopped)
 		mt76x2_mac_stop(dev, false);
 
 	if (is_5ghz)
-		mt76x02_mcu_calibrate(dev, MCU_CAL_LC, 0, true);
+		mt76x02_mcu_calibrate(dev, MCU_CAL_LC, 0);
 
-	mt76x02_mcu_calibrate(dev, MCU_CAL_TX_LOFT, is_5ghz, true);
-	mt76x02_mcu_calibrate(dev, MCU_CAL_TXIQ, is_5ghz, true);
-	mt76x02_mcu_calibrate(dev, MCU_CAL_RXIQC_FI, is_5ghz, true);
-	mt76x02_mcu_calibrate(dev, MCU_CAL_TEMP_SENSOR, 0, true);
-	mt76x02_mcu_calibrate(dev, MCU_CAL_TX_SHAPING, 0, true);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_TX_LOFT, is_5ghz);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_TXIQ, is_5ghz);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_RXIQC_FI, is_5ghz);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_TEMP_SENSOR, 0);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_TX_SHAPING, 0);
 
 	if (!mac_stopped)
 		mt76x2_mac_resume(dev);
@@ -223,14 +223,14 @@ int mt76x2_phy_set_channel(struct mt76x02_dev *dev,
 		u8 val = mt76x02_eeprom_get(dev, MT_EE_BT_RCAL_RESULT);
 
 		if (val != 0xff)
-			mt76x02_mcu_calibrate(dev, MCU_CAL_R, 0, true);
+			mt76x02_mcu_calibrate(dev, MCU_CAL_R, 0);
 	}
 
-	mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, channel, true);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, channel);
 
 	/* Rx LPF calibration */
 	if (!dev->cal.init_cal_done)
-		mt76x02_mcu_calibrate(dev, MCU_CAL_RC, 0, true);
+		mt76x02_mcu_calibrate(dev, MCU_CAL_RC, 0);
 
 	dev->cal.init_cal_done = true;
 
@@ -294,7 +294,7 @@ void mt76x2_phy_calibrate(struct work_struct *work)
 
 	dev = container_of(work, struct mt76x02_dev, cal_work.work);
 	mt76x2_phy_channel_calibrate(dev, false);
-	mt76x2_phy_tssi_compensate(dev, true);
+	mt76x2_phy_tssi_compensate(dev);
 	mt76x2_phy_temp_compensate(dev);
 	mt76x2_phy_update_channel_gain(dev);
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->cal_work,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
index bbeff9c19997..3ac5dd0f0400 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
@@ -210,7 +210,7 @@ void mt76x2_configure_tx_delay(struct mt76x02_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mt76x2_configure_tx_delay);
 
-void mt76x2_phy_tssi_compensate(struct mt76x02_dev *dev, bool wait)
+void mt76x2_phy_tssi_compensate(struct mt76x02_dev *dev)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 	struct mt76x2_tx_power_info txp;
@@ -245,7 +245,7 @@ void mt76x2_phy_tssi_compensate(struct mt76x02_dev *dev, bool wait)
 			return;
 
 		usleep_range(10000, 20000);
-		mt76x02_mcu_calibrate(dev, MCU_CAL_DPD, chan->hw_value, wait);
+		mt76x02_mcu_calibrate(dev, MCU_CAL_DPD, chan->hw_value);
 		dev->cal.dpd_cal_done = true;
 	}
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
index 8011c261c658..2a2de7bee6b2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
@@ -29,12 +29,12 @@ void mt76x2u_phy_channel_calibrate(struct mt76x02_dev *dev)
 	mt76x2u_mac_stop(dev);
 
 	if (is_5ghz)
-		mt76x02_mcu_calibrate(dev, MCU_CAL_LC, 0, false);
+		mt76x02_mcu_calibrate(dev, MCU_CAL_LC, 0);
 
-	mt76x02_mcu_calibrate(dev, MCU_CAL_TX_LOFT, is_5ghz, false);
-	mt76x02_mcu_calibrate(dev, MCU_CAL_TXIQ, is_5ghz, false);
-	mt76x02_mcu_calibrate(dev, MCU_CAL_RXIQC_FI, is_5ghz, false);
-	mt76x02_mcu_calibrate(dev, MCU_CAL_TEMP_SENSOR, 0, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_TX_LOFT, is_5ghz);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_TXIQ, is_5ghz);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_RXIQC_FI, is_5ghz);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_TEMP_SENSOR, 0);
 
 	mt76x2u_mac_resume(dev);
 }
@@ -44,7 +44,7 @@ void mt76x2u_phy_calibrate(struct work_struct *work)
 	struct mt76x02_dev *dev;
 
 	dev = container_of(work, struct mt76x02_dev, cal_work.work);
-	mt76x2_phy_tssi_compensate(dev, false);
+	mt76x2_phy_tssi_compensate(dev);
 	mt76x2_phy_update_channel_gain(dev);
 
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->cal_work,
@@ -142,14 +142,14 @@ int mt76x2u_phy_set_channel(struct mt76x02_dev *dev,
 		u8 val = mt76x02_eeprom_get(dev, MT_EE_BT_RCAL_RESULT);
 
 		if (val != 0xff)
-			mt76x02_mcu_calibrate(dev, MCU_CAL_R, 0, false);
+			mt76x02_mcu_calibrate(dev, MCU_CAL_R, 0);
 	}
 
-	mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, channel, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, channel);
 
 	/* Rx LPF calibration */
 	if (!dev->cal.init_cal_done)
-		mt76x02_mcu_calibrate(dev, MCU_CAL_RC, 0, false);
+		mt76x02_mcu_calibrate(dev, MCU_CAL_RC, 0);
 	dev->cal.init_cal_done = true;
 
 	mt76_wr(dev, MT_BBP(AGC, 61), 0xff64a4e2);
@@ -182,7 +182,7 @@ int mt76x2u_phy_set_channel(struct mt76x02_dev *dev,
 				flag |= BIT(0);
 			if (mt76x02_ext_pa_enabled(dev, chan->band))
 				flag |= BIT(8);
-			mt76x02_mcu_calibrate(dev, MCU_CAL_TSSI, flag, false);
+			mt76x02_mcu_calibrate(dev, MCU_CAL_TSSI, flag);
 			dev->cal.tssi_cal_done = true;
 		}
 	}
-- 
2.7.5

