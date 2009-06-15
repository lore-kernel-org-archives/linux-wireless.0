Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:26305 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752553AbZFOT5w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 15:57:52 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [PATCH 04/11 v2][2.6.31 and w-t] iwmc3200wifi: add a mutex to protect iwm_reset_worker
Date: Mon, 15 Jun 2009 21:59:49 +0200
Message-Id: <e72e3c0d6b16655fdf4da5dcabc6349be7b5c0a2.1245091931.git.samuel@sortiz.org>
In-Reply-To: <7413d2605b449b8e43bcfe61719ee30fccb592b7.1245091931.git.samuel@sortiz.org>
References: <cover.1245091931.git.samuel@sortiz.org>
 <7413d2605b449b8e43bcfe61719ee30fccb592b7.1245091931.git.samuel@sortiz.org>
In-Reply-To: <cover.1245091931.git.samuel@sortiz.org>
References: <cover.1245091931.git.samuel@sortiz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

The patch adds a mutex to protect the iwm_reset_worker against netdev
ndo_open and ndo_stop because all of them call iwm_up and iwm_down in
the implementation. Note the latter two are already protected by
rtnl. So if iwm_reset_worker is not required in the future, the mutex
can also be removed.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/iwm.h  |    1 +
 drivers/net/wireless/iwmc3200wifi/main.c |   54 ++++++++++++++++++++++++++---
 2 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index 4aa0ad1..77c339f 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -288,6 +288,7 @@ struct iwm_priv {
 	u8 *eeprom;
 	struct timer_list watchdog;
 	struct work_struct reset_worker;
+	struct mutex mutex;
 	struct rfkill *rfkill;
 
 	char private[0] __attribute__((__aligned__(NETDEV_ALIGN)));
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index 4d3c423..8be206d 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -112,6 +112,9 @@ static void iwm_statistics_request(struct work_struct *work)
 	iwm_send_umac_stats_req(iwm, 0);
 }
 
+int __iwm_up(struct iwm_priv *iwm);
+int __iwm_down(struct iwm_priv *iwm);
+
 static void iwm_reset_worker(struct work_struct *work)
 {
 	struct iwm_priv *iwm;
@@ -120,6 +123,19 @@ static void iwm_reset_worker(struct work_struct *work)
 
 	iwm = container_of(work, struct iwm_priv, reset_worker);
 
+	/*
+	 * XXX: The iwm->mutex is introduced purely for this reset work,
+	 * because the other users for iwm_up and iwm_down are only netdev
+	 * ndo_open and ndo_stop which are already protected by rtnl.
+	 * Please remove iwm->mutex together if iwm_reset_worker() is not
+	 * required in the future.
+	 */
+	if (!mutex_trylock(&iwm->mutex)) {
+		IWM_WARN(iwm, "We are in the middle of interface bringing "
+			 "UP/DOWN. Skip driver resetting.\n");
+		return;
+	}
+
 	if (iwm->umac_profile_active) {
 		profile = kmalloc(sizeof(struct iwm_umac_profile), GFP_KERNEL);
 		if (profile)
@@ -128,10 +144,10 @@ static void iwm_reset_worker(struct work_struct *work)
 			IWM_ERR(iwm, "Couldn't alloc memory for profile\n");
 	}
 
-	iwm_down(iwm);
+	__iwm_down(iwm);
 
 	while (retry++ < 3) {
-		ret = iwm_up(iwm);
+		ret = __iwm_up(iwm);
 		if (!ret)
 			break;
 
@@ -142,7 +158,7 @@ static void iwm_reset_worker(struct work_struct *work)
 		IWM_WARN(iwm, "iwm_up() failed: %d\n", ret);
 
 		kfree(profile);
-		return;
+		goto out;
 	}
 
 	if (profile) {
@@ -151,6 +167,9 @@ static void iwm_reset_worker(struct work_struct *work)
 		iwm_send_mlme_profile(iwm);
 		kfree(profile);
 	}
+
+ out:
+	mutex_unlock(&iwm->mutex);
 }
 
 static void iwm_watchdog(unsigned long data)
@@ -215,6 +234,7 @@ int iwm_priv_init(struct iwm_priv *iwm)
 	init_timer(&iwm->watchdog);
 	iwm->watchdog.function = iwm_watchdog;
 	iwm->watchdog.data = (unsigned long)iwm;
+	mutex_init(&iwm->mutex);
 
 	return 0;
 }
@@ -476,7 +496,7 @@ void iwm_link_off(struct iwm_priv *iwm)
 
 	iwm_rx_free(iwm);
 
-	cancel_delayed_work(&iwm->stats_request);
+	cancel_delayed_work_sync(&iwm->stats_request);
 	memset(wstats, 0, sizeof(struct iw_statistics));
 	wstats->qual.updated = IW_QUAL_ALL_INVALID;
 
@@ -521,7 +541,7 @@ static int iwm_channels_init(struct iwm_priv *iwm)
 	return 0;
 }
 
-int iwm_up(struct iwm_priv *iwm)
+int __iwm_up(struct iwm_priv *iwm)
 {
 	int ret;
 	struct iwm_notif *notif_reboot, *notif_ack = NULL;
@@ -657,7 +677,18 @@ int iwm_up(struct iwm_priv *iwm)
 	return -EIO;
 }
 
-int iwm_down(struct iwm_priv *iwm)
+int iwm_up(struct iwm_priv *iwm)
+{
+	int ret;
+
+	mutex_lock(&iwm->mutex);
+	ret = __iwm_up(iwm);
+	mutex_unlock(&iwm->mutex);
+
+	return ret;
+}
+
+int __iwm_down(struct iwm_priv *iwm)
 {
 	int ret;
 
@@ -688,3 +719,14 @@ int iwm_down(struct iwm_priv *iwm)
 
 	return 0;
 }
+
+int iwm_down(struct iwm_priv *iwm)
+{
+	int ret;
+
+	mutex_lock(&iwm->mutex);
+	ret = __iwm_down(iwm);
+	mutex_unlock(&iwm->mutex);
+
+	return ret;
+}
-- 
1.6.3.1

