Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51169 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757999Ab2EJJP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:29 -0400
Received: by mail-wi0-f172.google.com with SMTP id hr2so244170wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:29 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 27/78] wl18xx: ipmlement ap_rate_mask hw op
Date: Thu, 10 May 2012 12:13:32 +0300
Message-Id: <1336641263-5761-28-git-send-email-arik@wizery.com> (sfid-20120510_112331_605181_AD024D20)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable wide-chan or MIMO rates when appropriate.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   18 ++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/tx.h   |    6 ++++++
 drivers/net/wireless/ti/wlcore/conf.h |    6 ++++++
 3 files changed, 30 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index fd7a803..77840dd 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -862,6 +862,23 @@ static void wl18xx_set_rx_csum(struct wl1271 *wl,
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 }
 
+static u32 wl18xx_sta_get_ap_rate_mask(struct wl1271 *wl,
+				       struct wl12xx_vif *wlvif)
+{
+	u32 hw_rate_set = wlvif->rate_set;
+
+	if (wlvif->channel_type == NL80211_CHAN_HT40MINUS ||
+	    wlvif->channel_type == NL80211_CHAN_HT40PLUS) {
+		wl1271_debug(DEBUG_ACX, "using wide channel rate mask");
+		hw_rate_set |= CONF_TX_RATE_USE_WIDE_CHAN;
+
+		/* we don't support MIMO in wide-channel mode */
+		hw_rate_set &= ~CONF_TX_MIMO_RATES;
+	}
+
+	return hw_rate_set;
+}
+
 static void wl18xx_conf_init(struct wl1271 *wl)
 {
 	struct wl18xx_priv *priv = wl->priv;
@@ -888,6 +905,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.hw_init	= wl18xx_hw_init,
 	.set_tx_desc_csum = wl18xx_set_tx_desc_csum,
 	.set_rx_csum = wl18xx_set_rx_csum,
+	.sta_get_ap_rate_mask = wl18xx_sta_get_ap_rate_mask,
 };
 
 int __devinit wl18xx_probe(struct platform_device *pdev)
diff --git a/drivers/net/wireless/ti/wl18xx/tx.h b/drivers/net/wireless/ti/wl18xx/tx.h
index a91eb10..2417262 100644
--- a/drivers/net/wireless/ti/wl18xx/tx.h
+++ b/drivers/net/wireless/ti/wl18xx/tx.h
@@ -31,6 +31,12 @@
 #define WL18XX_TX_STATUS_DESC_ID_MASK    0x7F
 #define WL18XX_TX_STATUS_STAT_BIT_IDX    7
 
+/*
+ * The FW uses a special bit to indicate a wide channel should be used in
+ * the rate policy.
+ */
+#define CONF_TX_RATE_USE_WIDE_CHAN BIT(31)
+
 void wl18xx_tx_immediate_complete(struct wl1271 *wl);
 
 #endif /* __WL12XX_TX_H__ */
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index 0798c1e..14dd361 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -443,6 +443,12 @@ struct conf_rx_settings {
 	CONF_HW_BIT_RATE_MCS_5 | CONF_HW_BIT_RATE_MCS_6 |        \
 	CONF_HW_BIT_RATE_MCS_7)
 
+#define CONF_TX_MIMO_RATES (CONF_HW_BIT_RATE_MCS_8 |             \
+	CONF_HW_BIT_RATE_MCS_9 | CONF_HW_BIT_RATE_MCS_10 |       \
+	CONF_HW_BIT_RATE_MCS_11 | CONF_HW_BIT_RATE_MCS_12 |      \
+	CONF_HW_BIT_RATE_MCS_13 | CONF_HW_BIT_RATE_MCS_14 |      \
+	CONF_HW_BIT_RATE_MCS_15)
+
 /*
  * Default rates for management traffic when operating in AP mode. This
  * should be configured according to the basic rate set of the AP
-- 
1.7.9.5

