Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:56663 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759734AbZJHS6q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 14:58:46 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 15/20] wl1271: Multicast filtering configuration
Date: Thu,  8 Oct 2009 21:56:31 +0300
Message-Id: <1255028196-6565-16-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
References: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Enable multicast filtering. This way by default no multicast frames will
reach the host, and when needed, only required multicast frames can be
passed from the WLAN chipset to the host.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    7 +-
 drivers/net/wireless/wl12xx/wl1271_acx.c  |    9 +-
 drivers/net/wireless/wl12xx/wl1271_acx.h  |    8 +-
 drivers/net/wireless/wl12xx/wl1271_init.c |    2 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |  121 +++++++++++++++++++++++++----
 5 files changed, 120 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 0b4744d..34a52b3 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -97,7 +97,8 @@ enum {
 	} while (0)
 
 #define WL1271_DEFAULT_RX_CONFIG (CFG_UNI_FILTER_EN |	\
-				  CFG_BSSID_FILTER_EN)
+				  CFG_BSSID_FILTER_EN | \
+				  CFG_MC_FILTER_EN)
 
 #define WL1271_DEFAULT_RX_FILTER (CFG_RX_RCTS_ACK | CFG_RX_PRSP_EN |  \
 				  CFG_RX_MGMT_EN | CFG_RX_DATA_EN |   \
@@ -123,7 +124,7 @@ enum {
 #define WL1271_DEFAULT_BEACON_INT  100
 #define WL1271_DEFAULT_DTIM_PERIOD 1
 
-#define ACX_TX_DESCRIPTORS    32
+#define ACX_TX_DESCRIPTORS         32
 
 enum wl1271_state {
 	WL1271_STATE_OFF,
@@ -345,7 +346,9 @@ struct wl1271 {
 	bool tx_queue_stopped;
 
 	struct work_struct tx_work;
+
 	struct work_struct filter_work;
+	struct wl1271_filter_params *filter_params;
 
 	/* Pending TX frames */
 	struct sk_buff *tx_frames[ACX_TX_DESCRIPTORS];
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index 2ae1081..a457123 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -300,7 +300,8 @@ out:
 	return ret;
 }
 
-int wl1271_acx_group_address_tbl(struct wl1271 *wl)
+int wl1271_acx_group_address_tbl(struct wl1271 *wl, bool enable,
+				 void *mc_list, u32 mc_list_len)
 {
 	struct acx_dot11_grp_addr_tbl *acx;
 	int ret;
@@ -314,9 +315,9 @@ int wl1271_acx_group_address_tbl(struct wl1271 *wl)
 	}
 
 	/* MAC filtering */
-	acx->enabled = 0;
-	acx->num_groups = 0;
-	memset(acx->mac_table, 0, ADDRESS_GROUP_MAX_LEN);
+	acx->enabled = enable;
+	acx->num_groups = mc_list_len;
+	memcpy(acx->mac_table, mc_list, mc_list_len * ETH_ALEN);
 
 	ret = wl1271_cmd_configure(wl, DOT11_GROUP_ADDRESS_TBL,
 				   acx, sizeof(*acx));
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index c177345..dae1fed 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -301,8 +301,8 @@ struct acx_slot {
 } __attribute__ ((packed));
 
 
-#define ADDRESS_GROUP_MAX	(8)
-#define ADDRESS_GROUP_MAX_LEN	(ETH_ALEN * ADDRESS_GROUP_MAX)
+#define ACX_MC_ADDRESS_GROUP_MAX	(8)
+#define ADDRESS_GROUP_MAX_LEN	        (ETH_ALEN * ACX_MC_ADDRESS_GROUP_MAX)
 
 struct acx_dot11_grp_addr_tbl {
 	struct acx_header header;
@@ -313,7 +313,6 @@ struct acx_dot11_grp_addr_tbl {
 	u8 mac_table[ADDRESS_GROUP_MAX_LEN];
 } __attribute__ ((packed));
 
-
 #define  RX_TIMEOUT_PS_POLL_MIN    0
 #define  RX_TIMEOUT_PS_POLL_MAX    (200000)
 #define  RX_TIMEOUT_PS_POLL_DEF    (15)
@@ -1193,7 +1192,8 @@ int wl1271_acx_rx_msdu_life_time(struct wl1271 *wl, u32 life_time);
 int wl1271_acx_rx_config(struct wl1271 *wl, u32 config, u32 filter);
 int wl1271_acx_pd_threshold(struct wl1271 *wl);
 int wl1271_acx_slot(struct wl1271 *wl, enum acx_slot_type slot_time);
-int wl1271_acx_group_address_tbl(struct wl1271 *wl);
+int wl1271_acx_group_address_tbl(struct wl1271 *wl, bool enable,
+				 void *mc_list, u32 mc_list_len);
 int wl1271_acx_service_period_timeout(struct wl1271 *wl);
 int wl1271_acx_rts_threshold(struct wl1271 *wl, u16 rts_threshold);
 int wl1271_acx_beacon_filter_opt(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index eb6b91a..49ff407 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -117,7 +117,7 @@ static int wl1271_init_phy_config(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_acx_group_address_tbl(wl);
+	ret = wl1271_acx_group_address_tbl(wl, true, NULL, 0);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index d104230..09fe968 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -379,12 +379,39 @@ out:
 	return ret;
 }
 
+struct wl1271_filter_params {
+	unsigned int filters;
+	unsigned int changed;
+	int mc_list_length;
+	u8 mc_list[ACX_MC_ADDRESS_GROUP_MAX][ETH_ALEN];
+};
+
+#define WL1271_SUPPORTED_FILTERS (FIF_PROMISC_IN_BSS | \
+				  FIF_ALLMULTI | \
+				  FIF_FCSFAIL | \
+				  FIF_BCN_PRBRESP_PROMISC | \
+				  FIF_CONTROL | \
+				  FIF_OTHER_BSS)
+
 static void wl1271_filter_work(struct work_struct *work)
 {
 	struct wl1271 *wl =
 		container_of(work, struct wl1271, filter_work);
+	struct wl1271_filter_params *fp;
+	unsigned long flags;
+	bool enabled = true;
 	int ret;
 
+	/* first, get the filter parameters */
+	spin_lock_irqsave(&wl->wl_lock, flags);
+	fp = wl->filter_params;
+	wl->filter_params = NULL;
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+
+	if (!fp)
+		return;
+
+	/* then, lock the mutex without risk of lock-up */
 	mutex_lock(&wl->mutex);
 
 	if (wl->state == WL1271_STATE_OFF)
@@ -394,6 +421,20 @@ static void wl1271_filter_work(struct work_struct *work)
 	if (ret < 0)
 		goto out;
 
+	/* configure the mc filter regardless of the changed flags */
+	if (fp->filters & FIF_ALLMULTI)
+		enabled = false;
+
+	ret = wl1271_acx_group_address_tbl(wl, enabled,
+					   fp->mc_list, fp->mc_list_length);
+	if (ret < 0)
+		goto out_sleep;
+
+	/* determine, whether supported filter values have changed */
+	if (fp->changed == 0)
+		goto out;
+
+	/* apply configured filters */
 	ret = wl1271_cmd_join(wl);
 	if (ret < 0)
 		goto out_sleep;
@@ -403,6 +444,7 @@ out_sleep:
 
 out:
 	mutex_unlock(&wl->mutex);
+	kfree(fp);
 }
 
 int wl1271_plt_start(struct wl1271 *wl)
@@ -544,12 +586,20 @@ out:
 static void wl1271_op_stop(struct ieee80211_hw *hw)
 {
 	struct wl1271 *wl = hw->priv;
+	unsigned long flags;
 	int i;
 
 	wl1271_info("down");
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 stop");
 
+	/* complete/cancel ongoing work */
+	cancel_work_sync(&wl->filter_work);
+	spin_lock_irqsave(&wl->wl_lock, flags);
+	kfree(wl->filter_params);
+	wl->filter_params = NULL;
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+
 	mutex_lock(&wl->mutex);
 
 	WARN_ON(wl->state != WL1271_STATE_ON);
@@ -784,16 +834,52 @@ out:
 	return ret;
 }
 
-#define WL1271_SUPPORTED_FILTERS (FIF_PROMISC_IN_BSS | \
-				  FIF_ALLMULTI | \
-				  FIF_FCSFAIL | \
-				  FIF_BCN_PRBRESP_PROMISC | \
-				  FIF_CONTROL | \
-				  FIF_OTHER_BSS)
+static u64 wl1271_op_prepare_multicast(struct ieee80211_hw *hw, int mc_count,
+				       struct dev_addr_list *mc_list)
+{
+	struct wl1271 *wl = hw->priv;
+	struct wl1271_filter_params *fp;
+	unsigned long flags;
+	int i;
+
+	/*
+	 * FIXME: we should return a hash that will be passed to
+	 * configure_filter() instead of saving everything in the context.
+	 */
+
+	fp = kzalloc(sizeof(*fp), GFP_KERNEL);
+	if (!fp) {
+		wl1271_error("Out of memory setting filters.");
+		return 0;
+	}
+
+	/* update multicast filtering parameters */
+	if (mc_count > ACX_MC_ADDRESS_GROUP_MAX) {
+		mc_count = 0;
+		fp->filters |= FIF_ALLMULTI;
+	}
+
+	fp->mc_list_length = 0;
+	for (i = 0; i < mc_count; i++) {
+		if (mc_list->da_addrlen == ETH_ALEN) {
+			memcpy(fp->mc_list[fp->mc_list_length],
+			       mc_list->da_addr, ETH_ALEN);
+			fp->mc_list_length++;
+		} else
+			wl1271_warning("Unknown mc address length.");
+	}
+
+	spin_lock_irqsave(&wl->wl_lock, flags);
+	kfree(wl->filter_params);
+	wl->filter_params = fp;
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+
+	return 1;
+}
 
 static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
 				       unsigned int changed,
-				       unsigned int *total,u64 multicast)
+				       unsigned int *total, u64 multicast)
 {
 	struct wl1271 *wl = hw->priv;
 
@@ -802,19 +888,21 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
 	*total &= WL1271_SUPPORTED_FILTERS;
 	changed &= WL1271_SUPPORTED_FILTERS;
 
-	if (changed == 0)
+	if (!multicast)
 		return;
 
-	/* FIXME: wl->rx_config and wl->rx_filter are not protected */
-	wl->rx_config = WL1271_DEFAULT_RX_CONFIG;
-	wl->rx_filter = WL1271_DEFAULT_RX_FILTER;
-
 	/*
-	 * FIXME: workqueues need to be properly cancelled on stop(), for
-	 * now let's just disable changing the filter settings. They will
-	 * be updated any on config().
+	 * FIXME: for now we are still using a workqueue for filter
+	 * configuration, but with the new mac80211, this is not needed,
+	 * since configure_filter can now sleep.  We now have
+	 * prepare_multicast, which needs to be atomic instead.
 	 */
-	/* schedule_work(&wl->filter_work); */
+
+	/* store current filter config */
+	wl->filter_params->filters = *total;
+	wl->filter_params->changed = changed;
+
+	ieee80211_queue_work(wl->hw, &wl->filter_work);
 }
 
 static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
@@ -1177,6 +1265,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.remove_interface = wl1271_op_remove_interface,
 	.config = wl1271_op_config,
 /* 	.config_interface = wl1271_op_config_interface, */
+	.prepare_multicast = wl1271_op_prepare_multicast,
 	.configure_filter = wl1271_op_configure_filter,
 	.tx = wl1271_op_tx,
 	.set_key = wl1271_op_set_key,
-- 
1.5.6.5

