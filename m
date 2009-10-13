Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:43446 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933753AbZJMJuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:50:08 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 22/22] wl1271: Fix filter configuration
Date: Tue, 13 Oct 2009 12:47:59 +0300
Message-Id: <1255427279-1224-23-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Fix the filter configuration to properly work with the two phase filter
configuration (prepare_multicast/configure_filter.)

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    3 -
 drivers/net/wireless/wl12xx/wl1271_main.c |  157 +++++++++-------------------
 2 files changed, 51 insertions(+), 109 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index fca5968..1309b20 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -363,9 +363,6 @@ struct wl1271 {
 
 	struct work_struct tx_work;
 
-	struct work_struct filter_work;
-	struct wl1271_filter_params *filter_params;
-
 	/* Pending TX frames */
 	struct sk_buff *tx_frames[ACX_TX_DESCRIPTORS];
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 7b8d279..ee7ffaf 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -675,74 +675,6 @@ out:
 	return ret;
 }
 
-struct wl1271_filter_params {
-	unsigned int filters;
-	unsigned int changed;
-	int mc_list_length;
-	u8 mc_list[ACX_MC_ADDRESS_GROUP_MAX][ETH_ALEN];
-};
-
-#define WL1271_SUPPORTED_FILTERS (FIF_PROMISC_IN_BSS | \
-				  FIF_ALLMULTI | \
-				  FIF_FCSFAIL | \
-				  FIF_BCN_PRBRESP_PROMISC | \
-				  FIF_CONTROL | \
-				  FIF_OTHER_BSS)
-
-static void wl1271_filter_work(struct work_struct *work)
-{
-	struct wl1271 *wl =
-		container_of(work, struct wl1271, filter_work);
-	struct wl1271_filter_params *fp;
-	unsigned long flags;
-	bool enabled = true;
-	int ret;
-
-	/* first, get the filter parameters */
-	spin_lock_irqsave(&wl->wl_lock, flags);
-	fp = wl->filter_params;
-	wl->filter_params = NULL;
-	spin_unlock_irqrestore(&wl->wl_lock, flags);
-
-	if (!fp)
-		return;
-
-	/* then, lock the mutex without risk of lock-up */
-	mutex_lock(&wl->mutex);
-
-	if (wl->state == WL1271_STATE_OFF)
-		goto out;
-
-	ret = wl1271_ps_elp_wakeup(wl, false);
-	if (ret < 0)
-		goto out;
-
-	/* configure the mc filter regardless of the changed flags */
-	if (fp->filters & FIF_ALLMULTI)
-		enabled = false;
-
-	ret = wl1271_acx_group_address_tbl(wl, enabled,
-					   fp->mc_list, fp->mc_list_length);
-	if (ret < 0)
-		goto out_sleep;
-
-	/* determine, whether supported filter values have changed */
-	if (fp->changed == 0)
-		goto out;
-
-	/* apply configured filters */
-	ret = wl1271_acx_rx_config(wl, wl->rx_config, wl->rx_filter);
-	if (ret < 0)
-		goto out_sleep;
-
-out_sleep:
-	wl1271_ps_elp_sleep(wl);
-
-out:
-	mutex_unlock(&wl->mutex);
-	kfree(fp);
-}
-
 int wl1271_plt_start(struct wl1271 *wl)
 {
 	int ret;
@@ -993,20 +925,12 @@ out:
 static void wl1271_op_stop(struct ieee80211_hw *hw)
 {
 	struct wl1271 *wl = hw->priv;
-	unsigned long flags;
 	int i;
 
 	wl1271_info("down");
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 stop");
 
-	/* complete/cancel ongoing work */
-	cancel_work_sync(&wl->filter_work);
-	spin_lock_irqsave(&wl->wl_lock, flags);
-	kfree(wl->filter_params);
-	wl->filter_params = NULL;
-	spin_unlock_irqrestore(&wl->wl_lock, flags);
-
 	unregister_inetaddr_notifier(&wl1271_dev_notifier);
 	list_del(&wl->list);
 
@@ -1029,7 +953,6 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 
 	cancel_work_sync(&wl->irq_work);
 	cancel_work_sync(&wl->tx_work);
-	cancel_work_sync(&wl->filter_work);
 
 	mutex_lock(&wl->mutex);
 
@@ -1252,19 +1175,18 @@ out:
 	return ret;
 }
 
+struct wl1271_filter_params {
+	bool enabled;
+	int mc_list_length;
+	u8 mc_list[ACX_MC_ADDRESS_GROUP_MAX][ETH_ALEN];
+};
+
 static u64 wl1271_op_prepare_multicast(struct ieee80211_hw *hw, int mc_count,
 				       struct dev_addr_list *mc_list)
 {
-	struct wl1271 *wl = hw->priv;
 	struct wl1271_filter_params *fp;
-	unsigned long flags;
 	int i;
 
-	/*
-	 * FIXME: we should return a hash that will be passed to
-	 * configure_filter() instead of saving everything in the context.
-	 */
-
 	fp = kzalloc(sizeof(*fp), GFP_ATOMIC);
 	if (!fp) {
 		wl1271_error("Out of memory setting filters.");
@@ -1272,9 +1194,10 @@ static u64 wl1271_op_prepare_multicast(struct ieee80211_hw *hw, int mc_count,
 	}
 
 	/* update multicast filtering parameters */
+	fp->enabled = true;
 	if (mc_count > ACX_MC_ADDRESS_GROUP_MAX) {
 		mc_count = 0;
-		fp->filters |= FIF_ALLMULTI;
+		fp->enabled = false;
 	}
 
 	fp->mc_list_length = 0;
@@ -1288,42 +1211,65 @@ static u64 wl1271_op_prepare_multicast(struct ieee80211_hw *hw, int mc_count,
 		mc_list = mc_list->next;
 	}
 
-	/* FIXME: We still need to set our filters properly */
-
-	spin_lock_irqsave(&wl->wl_lock, flags);
-	kfree(wl->filter_params);
-	wl->filter_params = fp;
-	spin_unlock_irqrestore(&wl->wl_lock, flags);
-
-	return 1;
+	return (u64)(unsigned long)fp;
 }
 
+#define WL1271_SUPPORTED_FILTERS (FIF_PROMISC_IN_BSS | \
+				  FIF_ALLMULTI | \
+				  FIF_FCSFAIL | \
+				  FIF_BCN_PRBRESP_PROMISC | \
+				  FIF_CONTROL | \
+				  FIF_OTHER_BSS)
+
 static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
 				       unsigned int changed,
 				       unsigned int *total, u64 multicast)
 {
+	struct wl1271_filter_params *fp = (void *)(unsigned long)multicast;
 	struct wl1271 *wl = hw->priv;
+	int ret;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 configure filter");
 
+	mutex_lock(&wl->mutex);
+
+	if (wl->state == WL1271_STATE_OFF)
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out;
+
 	*total &= WL1271_SUPPORTED_FILTERS;
 	changed &= WL1271_SUPPORTED_FILTERS;
 
-	if (!multicast)
-		return;
+	if (*total & FIF_ALLMULTI)
+		ret = wl1271_acx_group_address_tbl(wl, false, NULL, 0);
+	else if (fp)
+		ret = wl1271_acx_group_address_tbl(wl, fp->enabled,
+						   fp->mc_list,
+						   fp->mc_list_length);
+	if (ret < 0)
+		goto out_sleep;
 
-	/*
-	 * FIXME: for now we are still using a workqueue for filter
-	 * configuration, but with the new mac80211, this is not needed,
-	 * since configure_filter can now sleep.  We now have
-	 * prepare_multicast, which needs to be atomic instead.
-	 */
+	kfree(fp);
+
+	/* FIXME: We still need to set our filters properly */
 
-	/* store current filter config */
-	wl->filter_params->filters = *total;
-	wl->filter_params->changed = changed;
+	/* determine, whether supported filter values have changed */
+	if (changed == 0)
+		goto out_sleep;
 
-	ieee80211_queue_work(wl->hw, &wl->filter_work);
+	/* apply configured filters */
+	ret = wl1271_acx_rx_config(wl, wl->rx_config, wl->rx_filter);
+	if (ret < 0)
+		goto out_sleep;
+
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
 }
 
 static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
@@ -1866,7 +1812,6 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 
 	skb_queue_head_init(&wl->tx_queue);
 
-	INIT_WORK(&wl->filter_work, wl1271_filter_work);
 	INIT_DELAYED_WORK(&wl->elp_work, wl1271_elp_work);
 	wl->channel = WL1271_DEFAULT_CHANNEL;
 	wl->scanning = false;
-- 
1.5.6.5

