Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:50713 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbYKDNuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 08:50:39 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [RFC/RFT PATCH v2 1/2] rtl8187: implement conf_tx callback to configure tx queues
Date: Tue,  4 Nov 2008 08:50:48 -0500
Message-Id: <1225806649-10050-2-git-send-email-herton@mandriva.com.br> (sfid-20081104_145046_951891_ED1D6A34)
In-Reply-To: <1225806649-10050-1-git-send-email-herton@mandriva.com.br>
References: <1225806649-10050-1-git-send-email-herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add conf_tx callback and use it to configure tx queues of 8187L/8187B.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 v2: just rediff against latest wireless-testing from latest posted version.

 drivers/net/wireless/rtl8187.h         |    2 +
 drivers/net/wireless/rtl8187_dev.c     |   75 +++++++++++++++++++++++++++++---
 drivers/net/wireless/rtl8187_rtl8225.c |    6 ---
 3 files changed, 70 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rtl8187.h b/drivers/net/wireless/rtl8187.h
index 33725d0..f09872e 100644
--- a/drivers/net/wireless/rtl8187.h
+++ b/drivers/net/wireless/rtl8187.h
@@ -111,6 +111,8 @@ struct rtl8187_priv {
 	u8 signal;
 	u8 quality;
 	u8 noise;
+	u8 slot_time;
+	u8 aifsn[4];
 };
 
 void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data);
diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index d49f2a7..a84bff9 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -701,6 +701,13 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 
 	rtl818x_iowrite16_idx(priv, (__le16 *)0xFFEC, 0x0800, 1);
 
+	priv->slot_time = 0x9;
+	priv->aifsn[0] = 2; /* AIFSN[AC_VO] */
+	priv->aifsn[1] = 2; /* AIFSN[AC_VI] */
+	priv->aifsn[2] = 7; /* AIFSN[AC_BK] */
+	priv->aifsn[3] = 3; /* AIFSN[AC_BE] */
+	rtl818x_iowrite8(priv, &priv->map->ACM_CONTROL, 0);
+
 	return 0;
 }
 
@@ -908,24 +915,38 @@ static int rtl8187_config_interface(struct ieee80211_hw *dev,
 	return 0;
 }
 
+/*
+ * With 8187B, AC_*_PARAM clashes with FEMR definition in struct rtl818x_csr for
+ * example. Thus we have to use raw values for AC_*_PARAM register addresses.
+ */
+static __le32 *rtl8187b_ac_addr[4] = {
+	(__le32 *) 0xFFF0, /* AC_VO */
+	(__le32 *) 0xFFF4, /* AC_VI */
+	(__le32 *) 0xFFFC, /* AC_BK */
+	(__le32 *) 0xFFF8, /* AC_BE */
+};
+
+#define SIFS_TIME 0xa
+
 static void rtl8187_conf_erp(struct rtl8187_priv *priv, bool use_short_slot,
 			     bool use_short_preamble)
 {
 	if (priv->is_rtl8187b) {
-		u8 difs, eifs, slot_time;
+		u8 difs, eifs;
 		u16 ack_timeout;
+		int queue;
 
 		if (use_short_slot) {
-			slot_time = 0x9;
+			priv->slot_time = 0x9;
 			difs = 0x1c;
 			eifs = 0x53;
 		} else {
-			slot_time = 0x14;
+			priv->slot_time = 0x14;
 			difs = 0x32;
 			eifs = 0x5b;
 		}
-		rtl818x_iowrite8(priv, &priv->map->SIFS, 0xa);
-		rtl818x_iowrite8(priv, &priv->map->SLOT, slot_time);
+		rtl818x_iowrite8(priv, &priv->map->SIFS, SIFS_TIME);
+		rtl818x_iowrite8(priv, &priv->map->SLOT, priv->slot_time);
 		rtl818x_iowrite8(priv, &priv->map->DIFS, difs);
 
 		/*
@@ -946,18 +967,21 @@ static void rtl8187_conf_erp(struct rtl8187_priv *priv, bool use_short_slot,
 			ack_timeout += 144;
 		rtl818x_iowrite8(priv, &priv->map->CARRIER_SENSE_COUNTER,
 				 DIV_ROUND_UP(ack_timeout, 4));
+
+		for (queue = 0; queue < 4; queue++)
+			rtl818x_iowrite8(priv, (u8 *) rtl8187b_ac_addr[queue],
+					 priv->aifsn[queue] * priv->slot_time +
+					 SIFS_TIME);
 	} else {
 		rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
 		if (use_short_slot) {
 			rtl818x_iowrite8(priv, &priv->map->SLOT, 0x9);
 			rtl818x_iowrite8(priv, &priv->map->DIFS, 0x14);
 			rtl818x_iowrite8(priv, &priv->map->EIFS, 91 - 0x14);
-			rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0x73);
 		} else {
 			rtl818x_iowrite8(priv, &priv->map->SLOT, 0x14);
 			rtl818x_iowrite8(priv, &priv->map->DIFS, 0x24);
 			rtl818x_iowrite8(priv, &priv->map->EIFS, 91 - 0x24);
-			rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0xa5);
 		}
 	}
 }
@@ -1006,6 +1030,42 @@ static void rtl8187_configure_filter(struct ieee80211_hw *dev,
 	rtl818x_iowrite32_async(priv, &priv->map->RX_CONF, priv->rx_conf);
 }
 
+static int rtl8187_conf_tx(struct ieee80211_hw *dev, u16 queue,
+			   const struct ieee80211_tx_queue_params *params)
+{
+	struct rtl8187_priv *priv = dev->priv;
+	u8 cw_min, cw_max;
+
+	if (queue > 3)
+		return -EINVAL;
+
+	cw_min = fls(params->cw_min);
+	cw_max = fls(params->cw_max);
+
+	if (priv->is_rtl8187b) {
+		priv->aifsn[queue] = params->aifs;
+
+		/*
+		 * This is the structure of AC_*_PARAM registers in 8187B:
+		 * - TXOP limit field, bit offset = 16
+		 * - ECWmax, bit offset = 12
+		 * - ECWmin, bit offset = 8
+		 * - AIFS, bit offset = 0
+		 */
+		rtl818x_iowrite32(priv, rtl8187b_ac_addr[queue],
+				  (params->txop << 16) | (cw_max << 12) |
+				  (cw_min << 8) | (params->aifs *
+				  priv->slot_time + SIFS_TIME));
+	} else {
+		if (queue != 0)
+			return -EINVAL;
+
+		rtl818x_iowrite8(priv, &priv->map->CW_VAL,
+				 cw_min | (cw_max << 4));
+	}
+	return 0;
+}
+
 static const struct ieee80211_ops rtl8187_ops = {
 	.tx			= rtl8187_tx,
 	.start			= rtl8187_start,
@@ -1016,6 +1076,7 @@ static const struct ieee80211_ops rtl8187_ops = {
 	.config_interface	= rtl8187_config_interface,
 	.bss_info_changed	= rtl8187_bss_info_changed,
 	.configure_filter	= rtl8187_configure_filter,
+	.conf_tx		= rtl8187_conf_tx
 };
 
 static void rtl8187_eeprom_register_read(struct eeprom_93cx6 *eeprom)
diff --git a/drivers/net/wireless/rtl8187_rtl8225.c b/drivers/net/wireless/rtl8187_rtl8225.c
index 69030be..4e75e8e 100644
--- a/drivers/net/wireless/rtl8187_rtl8225.c
+++ b/drivers/net/wireless/rtl8187_rtl8225.c
@@ -878,12 +878,6 @@ static void rtl8225z2_b_rf_init(struct ieee80211_hw *dev)
 	for (i = 0; i < ARRAY_SIZE(rtl8225z2_ofdm); i++)
 		rtl8225_write_phy_ofdm(dev, i, rtl8225z2_ofdm[i]);
 
-	rtl818x_iowrite32(priv, (__le32 *)0xFFF0, (7 << 12) | (3 << 8) | 28);
-	rtl818x_iowrite32(priv, (__le32 *)0xFFF4, (7 << 12) | (3 << 8) | 28);
-	rtl818x_iowrite32(priv, (__le32 *)0xFFF8, (7 << 12) | (3 << 8) | 28);
-	rtl818x_iowrite32(priv, (__le32 *)0xFFFC, (7 << 12) | (3 << 8) | 28);
-	rtl818x_iowrite8(priv, &priv->map->ACM_CONTROL, 0);
-
 	rtl8225_write_phy_ofdm(dev, 0x97, 0x46);
 	rtl8225_write_phy_ofdm(dev, 0xa4, 0xb6);
 	rtl8225_write_phy_ofdm(dev, 0x85, 0xfc);
-- 
1.6.0.2

