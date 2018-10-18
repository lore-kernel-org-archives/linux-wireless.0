Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF62C5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 08:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9A06208E4
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 08:07:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9A06208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbeJRQHc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 12:07:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39784 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726031AbeJRQHc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 12:07:32 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5567530F8C14;
        Thu, 18 Oct 2018 08:07:44 +0000 (UTC)
Received: from localhost (unknown [10.43.2.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAC705B6AD;
        Thu, 18 Oct 2018 08:07:41 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH] mt76x0: antenna select corrections
Date:   Thu, 18 Oct 2018 10:07:39 +0200
Message-Id: <1539850059-11886-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 18 Oct 2018 08:07:44 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Update mt76x0_phy_ant_select() to conform vendor driver, most notably
add dual antenna mode support, read configuration from EEPROM and
move ant select out of channel config to init phase. Plus small MT7630E
quirk for MT_CMB_CTRL register which vendor driver dedicated to this
chip do.

This make MT7630E workable with mt76x0e driver and do not cause any
problems on MT7610U for me.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    | 52 ++++++++++++++++------
 .../net/wireless/mediatek/mt76/mt76x02_eeprom.h    | 10 ++---
 2 files changed, 44 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 37e1ead1dc85..143cbe6d7899 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -431,21 +431,47 @@ int mt76x0_phy_wait_bbp_ready(struct mt76x02_dev *dev)
 
 static void mt76x0_phy_ant_select(struct mt76x02_dev *dev)
 {
-	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
-
-	/* single antenna mode */
-	if (chan->band == NL80211_BAND_2GHZ) {
-		mt76_rmw(dev, MT_COEXCFG3,
-			 BIT(5) | BIT(4) | BIT(3) | BIT(2), BIT(1));
-		mt76_rmw(dev, MT_WLAN_FUN_CTRL, BIT(5), BIT(6));
+	u16 ee_ant = mt76x02_eeprom_get(dev, MT_EE_ANTENNA);
+	u16 nic_conf2 = mt76x02_eeprom_get(dev, MT_EE_NIC_CONF_2);
+	u32 wlan, coex3, cmb;
+	bool ant_div;
+
+	wlan = mt76_rr(dev, MT_WLAN_FUN_CTRL);
+	cmb = mt76_rr(dev, MT_CMB_CTRL);
+	coex3 = mt76_rr(dev, MT_COEXCFG3);
+
+	cmb   &= ~(BIT(15) | BIT(12));
+	wlan  &= ~(BIT(6) | BIT(5));
+	coex3 &= ~GENMASK(5, 1);
+
+	if (ee_ant & MT_EE_ANTENNA_DUAL) {
+		/* dual antenna mode */
+		ant_div = !(nic_conf2 & MT_EE_NIC_CONF_2_ANT_OPT) &&
+			  (nic_conf2 & MT_EE_NIC_CONF_2_ANT_DIV);
+		if (ant_div)
+			cmb |= BIT(12);
+		else
+			coex3 |= BIT(4);
+		coex3 |= BIT(3);
+		if (dev->mt76.cap.has_2ghz)
+			wlan |= BIT(6);
 	} else {
-		mt76_rmw(dev, MT_COEXCFG3, BIT(5) | BIT(2),
-			 BIT(4) | BIT(3));
-		mt76_clear(dev, MT_WLAN_FUN_CTRL,
-			   BIT(6) | BIT(5));
+		/* sigle antenna mode */
+		if (dev->mt76.cap.has_5ghz) {
+			coex3 |= BIT(3) | BIT(4);
+		} else {
+			wlan |= BIT(6);
+			coex3 |= BIT(1);
+		}
 	}
-	mt76_clear(dev, MT_CMB_CTRL, BIT(14) | BIT(12));
+
+	if (is_mt7630(dev))
+		cmb |= BIT(14) | BIT(11);
+
+	mt76_wr(dev, MT_WLAN_FUN_CTRL, wlan);
+	mt76_wr(dev, MT_CMB_CTRL, cmb);
 	mt76_clear(dev, MT_COEXCFG0, BIT(2));
+	mt76_wr(dev, MT_COEXCFG3, coex3);
 }
 
 static void
@@ -612,7 +638,6 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 	mt76x02_phy_set_bw(dev, chandef->width, ch_group_index);
 	mt76x02_phy_set_band(dev, chandef->chan->band,
 			     ch_group_index & 1);
-	mt76x0_phy_ant_select(dev);
 
 	mt76_rmw(dev, MT_EXT_CCA_CFG,
 		 (MT_EXT_CCA_CFG_CCA0 |
@@ -795,6 +820,7 @@ void mt76x0_phy_init(struct mt76x02_dev *dev)
 {
 	INIT_DELAYED_WORK(&dev->cal_work, mt76x0_phy_calibration_work);
 
+	mt76x0_phy_ant_select(dev);
 	mt76x0_phy_rf_init(dev);
 	mt76x02_phy_set_rxpath(dev);
 	mt76x02_phy_set_txdac(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
index b3ec74835d10..1de041590050 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
@@ -25,6 +25,7 @@ enum mt76x02_eeprom_field {
 	MT_EE_VERSION =				0x002,
 	MT_EE_MAC_ADDR =			0x004,
 	MT_EE_PCI_ID =				0x00A,
+	MT_EE_ANTENNA =				0x022,
 	MT_EE_NIC_CONF_0 =			0x034,
 	MT_EE_NIC_CONF_1 =			0x036,
 	MT_EE_COUNTRY_REGION_5GHZ =		0x038,
@@ -104,6 +105,8 @@ enum mt76x02_eeprom_field {
 	__MT_EE_MAX
 };
 
+#define MT_EE_ANTENNA_DUAL			BIT(15)
+
 #define MT_EE_NIC_CONF_0_RX_PATH		GENMASK(3, 0)
 #define MT_EE_NIC_CONF_0_TX_PATH		GENMASK(7, 4)
 #define MT_EE_NIC_CONF_0_PA_TYPE		GENMASK(9, 8)
@@ -118,12 +121,9 @@ enum mt76x02_eeprom_field {
 #define MT_EE_NIC_CONF_1_LNA_EXT_5G		BIT(3)
 #define MT_EE_NIC_CONF_1_TX_ALC_EN		BIT(13)
 
-#define MT_EE_NIC_CONF_2_RX_STREAM		GENMASK(3, 0)
-#define MT_EE_NIC_CONF_2_TX_STREAM		GENMASK(7, 4)
-#define MT_EE_NIC_CONF_2_HW_ANTDIV		BIT(8)
+#define MT_EE_NIC_CONF_2_ANT_OPT		BIT(3)
+#define MT_EE_NIC_CONF_2_ANT_DIV		BIT(4)
 #define MT_EE_NIC_CONF_2_XTAL_OPTION		GENMASK(10, 9)
-#define MT_EE_NIC_CONF_2_TEMP_DISABLE		BIT(11)
-#define MT_EE_NIC_CONF_2_COEX_METHOD		GENMASK(15, 13)
 
 #define MT_EFUSE_USAGE_MAP_SIZE			(MT_EE_USAGE_MAP_END - \
 						 MT_EE_USAGE_MAP_START + 1)
-- 
1.9.3

