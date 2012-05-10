Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40505 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962Ab2EJJPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:33 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1111470wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:33 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 29/78] wlcore/wl18xx: enable MIMO/wide-chan rates in AP-mode rate config
Date: Thu, 10 May 2012 12:13:34 +0300
Message-Id: <1336641263-5761-30-git-send-email-arik@wizery.com> (sfid-20120510_112347_795300_DF0B50E1)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a HW op to add extra enabled rates for AP-mode data-rates. Since
the rates might depend on channel properties, reconfigure AP-mode rates
when these change.

Implement the HW op for the 18xx family, where MIMO or wide-chan rates
can be added.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    1 +
 drivers/net/wireless/ti/wl18xx/main.c   |   14 ++++++++++++++
 drivers/net/wireless/ti/wlcore/hw_ops.h |   10 ++++++++++
 drivers/net/wireless/ti/wlcore/init.c   |    3 +++
 drivers/net/wireless/ti/wlcore/main.c   |    7 ++++++-
 drivers/net/wireless/ti/wlcore/wlcore.h |    2 ++
 6 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index a333653..ad760a3 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1315,6 +1315,7 @@ static struct wlcore_ops wl12xx_ops = {
 	.get_mac		= wl12xx_get_mac,
 	.set_tx_desc_csum	= wl12xx_set_tx_desc_csum,
 	.set_rx_csum		= NULL,
+	.ap_get_mimo_wide_rate_mask = NULL,
 };
 
 static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 77840dd..9da94e6 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -879,6 +879,19 @@ static u32 wl18xx_sta_get_ap_rate_mask(struct wl1271 *wl,
 	return hw_rate_set;
 }
 
+static u32 wl18xx_ap_get_mimo_wide_rate_mask(struct wl1271 *wl,
+					     struct wl12xx_vif *wlvif)
+{
+	if (wlvif->channel_type == NL80211_CHAN_HT40MINUS ||
+	    wlvif->channel_type == NL80211_CHAN_HT40PLUS) {
+		wl1271_debug(DEBUG_ACX, "using wide channel rate mask");
+		return CONF_TX_RATE_USE_WIDE_CHAN;
+	} else {
+		wl1271_debug(DEBUG_ACX, "using MIMO rate mask");
+		return CONF_TX_MIMO_RATES;
+	}
+}
+
 static void wl18xx_conf_init(struct wl1271 *wl)
 {
 	struct wl18xx_priv *priv = wl->priv;
@@ -906,6 +919,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.set_tx_desc_csum = wl18xx_set_tx_desc_csum,
 	.set_rx_csum = wl18xx_set_rx_csum,
 	.sta_get_ap_rate_mask = wl18xx_sta_get_ap_rate_mask,
+	.ap_get_mimo_wide_rate_mask = wl18xx_ap_get_mimo_wide_rate_mask,
 };
 
 int __devinit wl18xx_probe(struct platform_device *pdev)
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 80f3d75..6d3e378 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -139,4 +139,14 @@ wlcore_hw_set_rx_csum(struct wl1271 *wl,
 		wl->ops->set_rx_csum(wl, desc, skb);
 }
 
+static inline u32
+wlcore_hw_ap_get_mimo_wide_rate_mask(struct wl1271 *wl,
+				     struct wl12xx_vif *wlvif)
+{
+	if (wl->ops->ap_get_mimo_wide_rate_mask)
+		return wl->ops->ap_get_mimo_wide_rate_mask(wl, wlvif);
+
+	return 0;
+}
+
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/init.c b/drivers/net/wireless/ti/wlcore/init.c
index 9f89255..645abd4 100644
--- a/drivers/net/wireless/ti/wlcore/init.c
+++ b/drivers/net/wireless/ti/wlcore/init.c
@@ -460,6 +460,9 @@ int wl1271_init_ap_rates(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	/* unconditionally enable HT rates */
 	supported_rates |= CONF_TX_MCS_RATES;
 
+	/* get extra MIMO or wide-chan rates where the HW supports it */
+	supported_rates |= wlcore_hw_ap_get_mimo_wide_rate_mask(wl, wlvif);
+
 	/* configure unicast TX rate classes */
 	for (i = 0; i < wl->conf.tx.ac_conf_count; i++) {
 		rc.enabled_rates = supported_rates;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index f64aeb9..c98958f 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2478,7 +2478,12 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		wlvif->channel = channel;
 		wlvif->channel_type = conf->channel_type;
 
-		if (!is_ap) {
+		if (is_ap) {
+			ret = wl1271_init_ap_rates(wl, wlvif);
+			if (ret < 0)
+				wl1271_error("AP rate policy change failed %d",
+					     ret);
+		} else {
 			/*
 			 * FIXME: the mac80211 should really provide a fixed
 			 * rate to use here. for now, just use the smallest
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 83c43c9..f9ec84d 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -68,6 +68,8 @@ struct wlcore_ops {
 	void (*set_rx_csum)(struct wl1271 *wl,
 			    struct wl1271_rx_descriptor *desc,
 			    struct sk_buff *skb);
+	u32 (*ap_get_mimo_wide_rate_mask)(struct wl1271 *wl,
+					  struct wl12xx_vif *wlvif);
 };
 
 enum wlcore_partitions {
-- 
1.7.9.5

