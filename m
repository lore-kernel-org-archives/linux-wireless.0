Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:35618 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab1CGCN3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 21:13:29 -0500
Received: by mail-yi0-f46.google.com with SMTP id 27so1454482yia.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 18:13:28 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19828.16191.789238.409233@gargle.gargle.HOWL>
Date: Mon, 7 Mar 2011 07:43:19 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC 07/34] ath9k_htc: Fix beacon miss under heavy load
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Transmission of beacons becomes erratic when TX load
is high, since the latency involved in the generation
of a SWBA interrupt on the target to the actual sending
of a beacon is quite high for USB devices.

Fix this by adjusting the beacon response time.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h            |    7 ++++
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   41 +++++++++++++++++++---
 2 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index ffc19e4..7cc5cf3 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -358,6 +358,13 @@ struct ath_led {
 
 #define BSTUCK_THRESHOLD 10
 
+/*
+ * Adjust these when the max. no of beaconing interfaces is
+ * increased.
+ */
+#define DEFAULT_SWBA_RESPONSE 40 /* in TUs */
+#define MIN_SWBA_RESPONSE     10 /* in TUs */
+
 struct htc_beacon_config {
 	struct ieee80211_vif *bslot[ATH9K_HTC_MAX_BCN_VIF];
 	u16 beacon_interval;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index f5976e3..1cd9dd2 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -198,6 +198,15 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
 	intval /= ATH9K_HTC_MAX_BCN_VIF;
 	nexttbtt = intval;
 
+	/*
+	 * To reduce beacon misses under heavy TX load,
+	 * set the beacon response time to a larger value.
+	 */
+	if (intval > DEFAULT_SWBA_RESPONSE)
+		priv->ah->config.sw_beacon_response_time = DEFAULT_SWBA_RESPONSE;
+	else
+		priv->ah->config.sw_beacon_response_time = MIN_SWBA_RESPONSE;
+
 	if (priv->op_flags & OP_TSF_RESET) {
 		intval |= ATH9K_BEACON_RESET_TSF;
 		priv->op_flags &= ~OP_TSF_RESET;
@@ -218,10 +227,11 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
 		imask |= ATH9K_INT_SWBA;
 
 	ath_dbg(common, ATH_DBG_CONFIG,
-		"AP Beacon config, intval: %d, nexttbtt: %u "
+		"AP Beacon config, intval: %d, nexttbtt: %u, resp_time: %d "
 		"imask: 0x%x, tsf_reset: %d\n",
-		bss_conf->beacon_interval, nexttbtt, imask,
-		!!(intval & ATH9K_BEACON_RESET_TSF));
+		bss_conf->beacon_interval, nexttbtt,
+		priv->ah->config.sw_beacon_response_time,
+		imask, !!(intval & ATH9K_BEACON_RESET_TSF));
 
 	ath9k_htc_beaconq_config(priv);
 
@@ -255,13 +265,23 @@ static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
 		nexttbtt += intval;
 	} while (nexttbtt < tsftu);
 
+	/*
+	 * Only one IBSS interfce is allowed.
+	 */
+	if (intval > DEFAULT_SWBA_RESPONSE)
+		priv->ah->config.sw_beacon_response_time = DEFAULT_SWBA_RESPONSE;
+	else
+		priv->ah->config.sw_beacon_response_time = MIN_SWBA_RESPONSE;
+
 	intval |= ATH9K_BEACON_ENA;
 	if (priv->op_flags & OP_ENABLE_BEACON)
 		imask |= ATH9K_INT_SWBA;
 
 	ath_dbg(common, ATH_DBG_CONFIG,
-		"IBSS Beacon config, intval: %d, nexttbtt: %u, imask: 0x%x\n",
-		bss_conf->beacon_interval, nexttbtt, imask);
+		"IBSS Beacon config, intval: %d, nexttbtt: %u, "
+		"resp_time: %d, imask: 0x%x\n",
+		bss_conf->beacon_interval, nexttbtt,
+		priv->ah->config.sw_beacon_response_time, imask);
 
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
 	ath9k_hw_beaconinit(priv->ah, nexttbtt, intval);
@@ -321,6 +341,7 @@ static void ath9k_htc_send_buffered(struct ath9k_htc_priv *priv,
 static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
 				  int slot)
 {
+	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ieee80211_vif *vif;
 	struct ath9k_htc_vif *avp;
 	struct tx_beacon_header beacon_hdr;
@@ -329,6 +350,7 @@ static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
 	struct ieee80211_mgmt *mgmt;
 	struct sk_buff *beacon;
 	u8 *tx_fhdr;
+	int ret;
 
 	memset(&beacon_hdr, 0, sizeof(struct tx_beacon_header));
 	memset(&tx_ctl, 0, sizeof(struct ath9k_htc_tx_ctl));
@@ -371,7 +393,14 @@ static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
 	tx_fhdr = skb_push(beacon, sizeof(beacon_hdr));
 	memcpy(tx_fhdr, (u8 *) &beacon_hdr, sizeof(beacon_hdr));
 
-	htc_send(priv->htc, beacon, priv->beacon_ep, &tx_ctl);
+	ret = htc_send(priv->htc, beacon, priv->beacon_ep, &tx_ctl);
+	if (ret != 0) {
+		if (ret == -ENOMEM) {
+			ath_dbg(common, ATH_DBG_BSTUCK,
+				"Failed to send beacon, no free TX buffer\n");
+		}
+		dev_kfree_skb_any(beacon);
+	}
 
 	spin_unlock_bh(&priv->beacon_lock);
 }
-- 
1.7.4.1

