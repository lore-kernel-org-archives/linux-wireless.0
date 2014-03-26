Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:55363 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbaCZUCb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 16:02:31 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so2058143eek.41
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2014 13:02:30 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: andrea.merello@gmail.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com
Subject: [PATCH 17/20] rtl8180: add WMM parameters configuration for rtl8187se
Date: Wed, 26 Mar 2014 21:03:40 +0100
Message-Id: <1395864220-5082-1-git-send-email-andrea.merello@gmail.com> (sfid-20140326_210233_884099_1065444B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce a new function to configure AC parameters for TX queues
on rtl8187se cards, and hook it onto mac80211 in order to enable
WMM support.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c     | 62 +++++++++++++++++++++++++-
 drivers/net/wireless/rtl818x/rtl8180/rtl8180.h |  1 +
 2 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index eb678da..a14dfd9 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -1090,6 +1090,7 @@ static int rtl8180_start(struct ieee80211_hw *dev)
 
 		/* CW is not on per-packet basis.
 		 * in rtl8185 the CW_VALUE reg is used.
+		 * in rtl8187se the AC param regs are used.
 		 */
 		reg &= ~RTL818X_CW_CONF_PERPACKET_CW;
 		/* retry limit IS on per-packet basis.
@@ -1279,6 +1280,49 @@ static int rtl8180_config(struct ieee80211_hw *dev, u32 changed)
 	return 0;
 }
 
+static void rtl8187se_conf_ac_parm(struct ieee80211_hw *dev, u8 queue)
+{
+	const struct ieee80211_tx_queue_params *params;
+	struct rtl8180_priv *priv = dev->priv;
+
+	/* hw value */
+	u32 ac_param;
+
+	u8 aifs;
+	u8 txop;
+	u8 cw_min, cw_max;
+
+	params = &priv->queue_param[queue];
+
+	cw_min = fls(params->cw_min);
+	cw_max = fls(params->cw_max);
+
+	aifs = 10 + params->aifs * priv->slot_time;
+
+	/* TODO: check if txop HW is in us (mult by 32) */
+	txop = params->txop;
+
+	ac_param = txop << AC_PARAM_TXOP_LIMIT_SHIFT |
+		cw_max << AC_PARAM_ECW_MAX_SHIFT |
+		cw_min << AC_PARAM_ECW_MIN_SHIFT |
+		aifs << AC_PARAM_AIFS_SHIFT;
+
+	switch (queue) {
+	case IEEE80211_AC_BK:
+		rtl818x_iowrite32(priv, &priv->map->AC_BK_PARAM, ac_param);
+		break;
+	case IEEE80211_AC_BE:
+		rtl818x_iowrite32(priv, &priv->map->AC_BE_PARAM, ac_param);
+		break;
+	case IEEE80211_AC_VI:
+		rtl818x_iowrite32(priv, &priv->map->AC_VI_PARAM, ac_param);
+		break;
+	case IEEE80211_AC_VO:
+		rtl818x_iowrite32(priv, &priv->map->AC_VO_PARAM, ac_param);
+		break;
+	}
+}
+
 static int rtl8180_conf_tx(struct ieee80211_hw *dev,
 			    struct ieee80211_vif *vif, u16 queue,
 			    const struct ieee80211_tx_queue_params *params)
@@ -1293,8 +1337,12 @@ static int rtl8180_conf_tx(struct ieee80211_hw *dev,
 	cw_min = fls(params->cw_min);
 	cw_max = fls(params->cw_max);
 
-	rtl818x_iowrite8(priv, &priv->map->CW_VAL, (cw_max << 4) | cw_min);
-
+	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
+		priv->queue_param[queue] = *params;
+		rtl8187se_conf_ac_parm(dev, queue);
+	} else
+		rtl818x_iowrite8(priv, &priv->map->CW_VAL,
+				 (cw_max << 4) | cw_min);
 	return 0;
 }
 
@@ -1396,6 +1444,16 @@ static void rtl8180_bss_info_changed(struct ieee80211_hw *dev,
 					&priv->rates[0])) - 10;
 
 		rtl8180_conf_erp(dev, info);
+
+		/* mac80211 supplies aifs_n to driver and calls
+		 * conf_tx callback whether aifs_n changes, NOT
+		 * when aifs changes.
+		 * Aifs should be recalculated if slot changes.
+		 */
+		if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
+			for (i = 0; i < 4; i++)
+				rtl8187se_conf_ac_parm(dev, i);
+		}
 	}
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED)
diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h b/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
index 0ef3fc7..291a559 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
+++ b/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
@@ -117,6 +117,7 @@ struct rtl8180_priv {
 	struct ieee80211_channel channels[14];
 	struct ieee80211_rate rates[12];
 	struct ieee80211_supported_band band;
+	struct ieee80211_tx_queue_params queue_param[4];
 	struct pci_dev *pdev;
 	u32 rx_conf;
 	u8 slot_time;
-- 
1.8.3.2

