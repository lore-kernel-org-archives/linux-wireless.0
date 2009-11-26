Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:42079 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759054AbZKZM2f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 07:28:35 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: move scan-related code into scan.c
Date: Thu, 26 Nov 2009 13:28:28 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911261328.28811.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As libertas + cfg80211 will have it's own scan code, it's nicer
when scan-related code piece don't remain in main.c.

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>


--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -174,11 +174,6 @@ int lbs_update_hw_spec(struct lbs_privat
 	if (priv->mesh_dev)
 		memcpy(priv->mesh_dev->dev_addr, priv->current_addr, ETH_ALEN);
 
-	if (lbs_set_regiontable(priv)) {
-		ret = -1;
-		goto out;
-	}
-
 out:
 	lbs_deb_leave(LBS_DEB_CMD);
 	return ret;
--- linux-wl.orig/drivers/net/wireless/libertas/scan.c
+++ linux-wl/drivers/net/wireless/libertas/scan.c
@@ -648,7 +648,7 @@ out:
 	return ret;
 }
 
-void lbs_scan_worker(struct work_struct *work)
+static void lbs_scan_worker(struct work_struct *work)
 {
 	struct lbs_private *priv =
 		container_of(work, struct lbs_private, scan_work.work);
@@ -1354,3 +1354,74 @@ done:
 	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
 	return ret;
 }
+
+
+
+/*
+ * called at lbs_add_card() time
+ *
+ * At this time no firmware command execution has been done, nor is command
+ * execution already possible.
+ *
+ */
+int lbs_scan_alloc(struct lbs_private *priv)
+{
+	int i, ret = 0;
+	size_t bufsize;
+
+	lbs_deb_enter(LBS_DEB_SCAN);
+
+	INIT_DELAYED_WORK(&priv->scan_work, lbs_scan_worker);
+
+	/* Allocate buffer to store the BSSID list */
+	bufsize = MAX_NETWORK_COUNT * sizeof(struct bss_descriptor);
+	priv->networks = kzalloc(bufsize, GFP_KERNEL);
+	if (!priv->networks) {
+		lbs_pr_err("Out of memory allocating beacons\n");
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	/* Initialize scan result lists */
+	INIT_LIST_HEAD(&priv->network_free_list);
+	INIT_LIST_HEAD(&priv->network_list);
+	for (i = 0; i < MAX_NETWORK_COUNT; i++) {
+		list_add_tail(&priv->networks[i].list,
+			      &priv->network_free_list);
+	}
+done:
+	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
+	return ret;
+}
+
+
+/*
+ * called via lbs_start_card(), after lbs_set_regiontable() has been run
+ */
+int lbs_scan_init(struct lbs_private *priv)
+{
+	int ret;
+
+	lbs_deb_enter(LBS_DEB_SCAN);
+
+	ret = lbs_set_regiontable(priv);
+
+	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);
+	return ret;
+}
+
+
+/*
+ * Called at lbs_stop_card() / lbs_remove_card() time.
+ */
+void lbs_scan_deinit(struct lbs_private *priv)
+{
+	lbs_deb_enter(LBS_DEB_SCAN);
+
+	cancel_delayed_work_sync(&priv->scan_work);
+
+	kfree(priv->networks);
+	priv->networks = NULL;
+
+	lbs_deb_leave(LBS_DEB_SCAN);
+}
--- linux-wl.orig/drivers/net/wireless/libertas/scan.h
+++ linux-wl/drivers/net/wireless/libertas/scan.h
@@ -58,6 +58,8 @@ int lbs_set_scan(struct net_device *dev,
 
 int lbs_scan_networks(struct lbs_private *priv, int full_scan);
 
-void lbs_scan_worker(struct work_struct *work);
+int lbs_scan_alloc(struct lbs_private *priv);
+int lbs_scan_init(struct lbs_private *priv);
+void lbs_scan_deinit(struct lbs_private *priv);
 
 #endif
--- linux-wl.orig/drivers/net/wireless/libertas/main.c
+++ linux-wl/drivers/net/wireless/libertas/main.c
@@ -808,27 +808,13 @@ int lbs_exit_auto_deep_sleep(struct lbs_
 
 static int lbs_init_adapter(struct lbs_private *priv)
 {
-	size_t bufsize;
-	int i, ret = 0;
+	int ret;
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
-	/* Allocate buffer to store the BSSID list */
-	bufsize = MAX_NETWORK_COUNT * sizeof(struct bss_descriptor);
-	priv->networks = kzalloc(bufsize, GFP_KERNEL);
-	if (!priv->networks) {
-		lbs_pr_err("Out of memory allocating beacons\n");
-		ret = -1;
+	ret = lbs_scan_alloc(priv);
+	if (ret)
 		goto out;
-	}
-
-	/* Initialize scan result lists */
-	INIT_LIST_HEAD(&priv->network_free_list);
-	INIT_LIST_HEAD(&priv->network_list);
-	for (i = 0; i < MAX_NETWORK_COUNT; i++) {
-		list_add_tail(&priv->networks[i].list,
-			      &priv->network_free_list);
-	}
 
 	memset(priv->current_addr, 0xff, ETH_ALEN);
 
@@ -891,8 +877,6 @@ static void lbs_free_adapter(struct lbs_
 		kfifo_free(priv->event_fifo);
 	del_timer(&priv->command_timer);
 	del_timer(&priv->auto_deepsleep_timer);
-	kfree(priv->networks);
-	priv->networks = NULL;
 
 	lbs_deb_leave(LBS_DEB_MAIN);
 }
@@ -981,7 +965,6 @@ struct lbs_private *lbs_add_card(void *c
 
 	priv->work_thread = create_singlethread_workqueue("lbs_worker");
 	INIT_DELAYED_WORK(&priv->assoc_work, lbs_association_worker);
-	INIT_DELAYED_WORK(&priv->scan_work, lbs_scan_worker);
 	INIT_WORK(&priv->mcast_work, lbs_set_mcast_worker);
 
 	priv->wol_criteria = 0xffffffff;
@@ -1015,10 +998,10 @@ void lbs_remove_card(struct lbs_private 
 
 	lbs_remove_mesh(priv);
 	lbs_remove_rtap(priv);
+	lbs_scan_deinit(priv);
 
 	dev = priv->dev;
 
-	cancel_delayed_work_sync(&priv->scan_work);
 	cancel_delayed_work_sync(&priv->assoc_work);
 	cancel_work_sync(&priv->mcast_work);
 
@@ -1084,6 +1067,10 @@ int lbs_start_card(struct lbs_private *p
 		goto done;
 	}
 
+	ret = lbs_scan_init(priv);
+	if (ret)
+		goto done;
+
 	lbs_update_channel(priv);
 
 	lbs_init_mesh(priv);
--- linux-wl.orig/drivers/net/wireless/libertas/cfg.h
+++ linux-wl/drivers/net/wireless/libertas/cfg.h
@@ -10,7 +10,6 @@ void lbs_cfg_free(struct lbs_private *pr
 int lbs_send_specific_ssid_scan(struct lbs_private *priv, u8 *ssid,
 	u8 ssid_len);
 int lbs_scan_networks(struct lbs_private *priv, int full_scan);
-void lbs_cfg_scan_worker(struct work_struct *work);
 
 
 #endif
--- linux-wl.orig/drivers/net/wireless/libertas/dev.h
+++ linux-wl/drivers/net/wireless/libertas/dev.h
@@ -161,6 +161,9 @@ struct lbs_private {
 
 	/** Scanning */
 	struct delayed_work scan_work;
+	struct list_head network_list;
+	struct list_head network_free_list;
+	struct bss_descriptor *networks;
 	int scan_channel;
 	/* remember which channel was scanned last, != 0 if currently scanning */
 	u8 scan_ssid[IEEE80211_MAX_SSID_LEN + 1];
@@ -170,11 +173,8 @@ struct lbs_private {
 	struct delayed_work assoc_work;
 	struct current_bss_params curbssparams;
 	u8 mode;
-	struct list_head network_list;
-	struct list_head network_free_list;
-	struct bss_descriptor *networks;
-	struct assoc_request * pending_assoc_req;
-	struct assoc_request * in_progress_assoc_req;
+	struct assoc_request *pending_assoc_req;
+	struct assoc_request *in_progress_assoc_req;
 	uint16_t enablehwauto;
 
 	/* ADHOC */

-- 
http://www.holgerschurig.de
