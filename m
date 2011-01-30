Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:60211 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab1A3TLb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 14:11:31 -0500
Message-ID: <4D45B7D1.5030005@davizone.at>
Date: Sun, 30 Jan 2011 20:11:13 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: [PATCH 13/18] wl1251: rework configure_filter() callback
References: <4D45A5EE.6040108@davizone.at>
In-Reply-To: <4D45A5EE.6040108@davizone.at>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The configure_filter() callback function no longer needs to be atomic.
Remove the scheduled work structure and call firmware functions directly.
Add filter support for monitor mode and fix flag mapping for
FIF_PROMISC_IN_BSS and FIF_OTHER_BSS.
Fix BSSID filter config for changed BSSID handling since commit 9cef8737
"mac80211: fix managed mode BSSID handling" and remove workaround.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
Sorry for the partly broken patches, I thought I configured my client the
right way. I tried to stop the mails at my mailserver, but it was mostly
already too late.
---
 drivers/net/wireless/wl1251/cmd.c    |    9 ----
 drivers/net/wireless/wl1251/main.c   |   88 ++++++++++++++++++----------------
 drivers/net/wireless/wl1251/wl1251.h |    5 +--
 3 files changed, 48 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/wl1251/cmd.c b/drivers/net/wireless/wl1251/cmd.c
index 886da13..e70ec79 100644
--- a/drivers/net/wireless/wl1251/cmd.c
+++ b/drivers/net/wireless/wl1251/cmd.c
@@ -300,15 +300,6 @@ int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u8 channel,
 	join->rx_config_options = wl->rx_config;
 	join->rx_filter_options = wl->rx_filter;
 
-	/*
-	 * FIXME: disable temporarily all filters because after commit
-	 * 9cef8737 "mac80211: fix managed mode BSSID handling" broke
-	 * association. The filter logic needs to be implemented properly
-	 * and once that is done, this hack can be removed.
-	 */
-	join->rx_config_options = 0;
-	join->rx_filter_options = WL1251_DEFAULT_RX_FILTER;
-
 	join->basic_rate_set = RATE_MASK_1MBPS | RATE_MASK_2MBPS |
 		RATE_MASK_5_5MBPS | RATE_MASK_11MBPS;
 
diff --git a/drivers/net/wireless/wl1251/main.c b/drivers/net/wireless/wl1251/main.c
index 5078705..cc49e2b 100644
--- a/drivers/net/wireless/wl1251/main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -349,33 +349,6 @@ out:
 	return ret;
 }
 
-static void wl1251_filter_work(struct work_struct *work)
-{
-	struct wl1251 *wl =
-		container_of(work, struct wl1251, filter_work);
-	int ret;
-
-	mutex_lock(&wl->mutex);
-
-	if (wl->state == WL1251_STATE_OFF)
-		goto out;
-
-	ret = wl1251_ps_elp_wakeup(wl);
-	if (ret < 0)
-		goto out;
-
-	ret = wl1251_join(wl, wl->bss_type, wl->channel, wl->beacon_int,
-			  wl->dtim_period);
-	if (ret < 0)
-		goto out_sleep;
-
-out_sleep:
-	wl1251_ps_elp_sleep(wl);
-
-out:
-	mutex_unlock(&wl->mutex);
-}
-
 static int wl1251_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct wl1251 *wl = hw->priv;
@@ -481,7 +454,6 @@ static void wl1251_op_stop(struct ieee80211_hw *hw)
 
 	cancel_work_sync(&wl->irq_work);
 	cancel_work_sync(&wl->tx_work);
-	cancel_work_sync(&wl->filter_work);
 
 	mutex_lock(&wl->mutex);
 
@@ -622,6 +594,16 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 		ret = wl1251_acx_feature_cfg(wl, mode);
 		if (ret < 0)
 			goto out_sleep;
+
+		if (wl->monitor_present)
+			wl->rx_config |= CFG_RX_ALL_GOOD;
+		else
+			wl->rx_config &= ~CFG_RX_ALL_GOOD;
+
+		/* update filters immediately */
+		ret = wl1251_acx_rx_config(wl, wl->rx_config, wl->rx_filter);
+		if (ret < 0)
+			goto out_sleep;
 	}
 
 	if (channel != wl->channel) {
@@ -691,6 +673,7 @@ static void wl1251_op_configure_filter(struct ieee80211_hw *hw,
 				       unsigned int *total,u64 multicast)
 {
 	struct wl1251 *wl = hw->priv;
+	int ret;
 
 	wl1251_debug(DEBUG_MAC80211, "mac80211 configure filter");
 
@@ -701,15 +684,22 @@ static void wl1251_op_configure_filter(struct ieee80211_hw *hw,
 		/* no filters which we support changed */
 		return;
 
-	/* FIXME: wl->rx_config and wl->rx_filter are not protected */
+	mutex_lock(&wl->mutex);
+
+	if (wl->state == WL1251_STATE_OFF)
+		goto out;
+
+	ret = wl1251_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
 
 	wl->rx_config = WL1251_DEFAULT_RX_CONFIG;
 	wl->rx_filter = WL1251_DEFAULT_RX_FILTER;
 
-	if (*total & FIF_PROMISC_IN_BSS) {
+	if (!is_zero_ether_addr(wl->bssid))
 		wl->rx_config |= CFG_BSSID_FILTER_EN;
-		wl->rx_config |= CFG_RX_ALL_GOOD;
-	}
+	if (*total & FIF_PROMISC_IN_BSS)
+		wl->rx_config &= ~CFG_UNI_FILTER_EN;
 	if (*total & FIF_ALLMULTI)
 		/*
 		 * CFG_MC_FILTER_EN in rx_config needs to be 0 to receive
@@ -724,15 +714,27 @@ static void wl1251_op_configure_filter(struct ieee80211_hw *hw,
 	}
 	if (*total & FIF_CONTROL)
 		wl->rx_filter |= CFG_RX_CTL_EN;
-	if (*total & FIF_OTHER_BSS)
-		wl->rx_filter &= ~CFG_BSSID_FILTER_EN;
+	if (*total & FIF_OTHER_BSS) {
+		wl->rx_config &= ~CFG_BSSID_FILTER_EN;
+		wl->rx_config &= ~CFG_SSID_FILTER_EN;
+	}
+	if (wl->monitor_present)
+		wl->rx_config |= CFG_RX_ALL_GOOD;
 
-	/*
-	 * FIXME: workqueues need to be properly cancelled on stop(), for
-	 * now let's just disable changing the filter settings. They will
-	 * be updated any on config().
-	 */
-	/* schedule_work(&wl->filter_work); */
+	wl1251_debug(DEBUG_MAC80211, "mac80211 filter total 0x%02x"
+		     " changed 0x%02x rx_config 0x%02x rx_filter 0x%02x",
+		     *total, changed, wl->rx_config, wl->rx_filter);
+
+	/* apply configured filters */
+	ret = wl1251_acx_rx_config(wl, wl->rx_config, wl->rx_filter);
+	if (ret < 0)
+		goto out_sleep;
+
+out_sleep:
+	wl1251_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
 }
 
 /* HW encryption */
@@ -999,6 +1001,11 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_BSSID) {
 		memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
 
+		if (is_zero_ether_addr(wl->bssid))
+			wl->rx_config &= ~CFG_BSSID_FILTER_EN;
+		else
+			wl->rx_config |= CFG_BSSID_FILTER_EN;
+
 		skb = ieee80211_nullfunc_get(wl->hw, wl->vif);
 		if (!skb)
 			goto out_sleep;
@@ -1513,7 +1520,6 @@ struct ieee80211_hw *wl1251_alloc_hw(void)
 
 	skb_queue_head_init(&wl->tx_queue);
 
-	INIT_WORK(&wl->filter_work, wl1251_filter_work);
 	INIT_DELAYED_WORK(&wl->elp_work, wl1251_elp_work);
 	wl->channel = WL1251_DEFAULT_CHANNEL;
 	wl->monitor_present = false;
diff --git a/drivers/net/wireless/wl1251/wl1251.h b/drivers/net/wireless/wl1251/wl1251.h
index 875c1bf..1f9579c 100644
--- a/drivers/net/wireless/wl1251/wl1251.h
+++ b/drivers/net/wireless/wl1251/wl1251.h
@@ -92,13 +92,11 @@ enum {
 				       true);				\
 	} while (0)
 
-#define WL1251_DEFAULT_RX_CONFIG (CFG_UNI_FILTER_EN |	\
-				  CFG_BSSID_FILTER_EN)
+#define WL1251_DEFAULT_RX_CONFIG (CFG_UNI_FILTER_EN)
 
 #define WL1251_DEFAULT_RX_FILTER (CFG_RX_PRSP_EN |  \
 				  CFG_RX_MGMT_EN |  \
 				  CFG_RX_DATA_EN |  \
-				  CFG_RX_CTL_EN |   \
 				  CFG_RX_BCN_EN |   \
 				  CFG_RX_AUTH_EN |  \
 				  CFG_RX_ASSOC_EN)
@@ -316,7 +314,6 @@ struct wl1251 {
 	bool tx_queue_stopped;
 
 	struct work_struct tx_work;
-	struct work_struct filter_work;
 
 	/* Pending TX frames */
 	struct sk_buff *tx_frames[16];
-- 
1.7.0.4


