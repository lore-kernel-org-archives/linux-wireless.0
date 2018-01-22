Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0084.outbound.protection.outlook.com ([104.47.38.84]:56768
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751156AbeAVMrM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 07:47:12 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: [PATCH 09/11] qtnfmac: do not use mutexes in timer context
Date: Mon, 22 Jan 2018 15:46:32 +0300
Message-Id: <20180122124634.8430-10-sergey.matyukevich.os@quantenna.com> (sfid-20180122_134718_804294_A9134CA3)
In-Reply-To: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
References: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

The function qtnf_scan_done makes use of mutexes which is wrong
since it may be called from timer context. Move scan timeout
handler from timer to deferred work.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 15 +++--------
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.h | 19 -------------
 drivers/net/wireless/quantenna/qtnfmac/core.c     | 33 ++++++++++++++++++++++-
 drivers/net/wireless/quantenna/qtnfmac/core.h     |  3 ++-
 4 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index edebf23e8eae..0398bece5782 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -595,19 +595,13 @@ qtnf_del_station(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
-static void qtnf_scan_timeout(struct timer_list *t)
-{
-	struct qtnf_wmac *mac = from_timer(mac, t, scan_timeout);
-
-	pr_warn("mac%d scan timed out\n", mac->macid);
-	qtnf_scan_done(mac, true);
-}
-
 static int
 qtnf_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
 	struct qtnf_wmac *mac = wiphy_priv(wiphy);
 
+	cancel_delayed_work_sync(&mac->scan_timeout);
+
 	mac->scan_req = request;
 
 	if (qtnf_cmd_send_scan(mac)) {
@@ -616,9 +610,8 @@ qtnf_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 		return -EFAULT;
 	}
 
-	mac->scan_timeout.function = qtnf_scan_timeout;
-	mod_timer(&mac->scan_timeout,
-		  jiffies + QTNF_SCAN_TIMEOUT_SEC * HZ);
+	queue_delayed_work(mac->bus->workqueue, &mac->scan_timeout,
+			   QTNF_SCAN_TIMEOUT_SEC * HZ);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
index 66db26613b1f..b73425122a10 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
@@ -28,23 +28,4 @@ void qtnf_band_init_rates(struct ieee80211_supported_band *band);
 void qtnf_band_setup_htvht_caps(struct qtnf_mac_info *macinfo,
 				struct ieee80211_supported_band *band);
 
-static inline void qtnf_scan_done(struct qtnf_wmac *mac, bool aborted)
-{
-	struct cfg80211_scan_info info = {
-		.aborted = aborted,
-	};
-
-	if (timer_pending(&mac->scan_timeout))
-		del_timer_sync(&mac->scan_timeout);
-
-	mutex_lock(&mac->mac_lock);
-
-	if (mac->scan_req) {
-		cfg80211_scan_done(mac->scan_req, &info);
-		mac->scan_req = NULL;
-	}
-
-	mutex_unlock(&mac->mac_lock);
-}
-
 #endif /* _QTN_FMAC_CFG80211_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index b1344d0731d7..cf26c15a84f8 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -311,6 +311,37 @@ static void qtnf_mac_init_primary_intf(struct qtnf_wmac *mac)
 	vif->cons_tx_timeout_cnt = 0;
 }
 
+static void qtnf_mac_scan_finish(struct qtnf_wmac *mac, bool aborted)
+{
+	struct cfg80211_scan_info info = {
+		.aborted = aborted,
+	};
+
+	mutex_lock(&mac->mac_lock);
+
+	if (mac->scan_req) {
+		cfg80211_scan_done(mac->scan_req, &info);
+		mac->scan_req = NULL;
+	}
+
+	mutex_unlock(&mac->mac_lock);
+}
+
+void qtnf_scan_done(struct qtnf_wmac *mac, bool aborted)
+{
+	cancel_delayed_work_sync(&mac->scan_timeout);
+	qtnf_mac_scan_finish(mac, aborted);
+}
+
+static void qtnf_mac_scan_timeout(struct work_struct *work)
+{
+	struct qtnf_wmac *mac =
+		container_of(work, struct qtnf_wmac, scan_timeout.work);
+
+	pr_warn("MAC%d: scan timed out\n", mac->macid);
+	qtnf_mac_scan_finish(mac, true);
+}
+
 static struct qtnf_wmac *qtnf_core_mac_alloc(struct qtnf_bus *bus,
 					     unsigned int macid)
 {
@@ -334,7 +365,7 @@ static struct qtnf_wmac *qtnf_core_mac_alloc(struct qtnf_bus *bus,
 		mac->iflist[i].vifid = i;
 		qtnf_sta_list_init(&mac->iflist[i].sta_list);
 		mutex_init(&mac->mac_lock);
-		timer_setup(&mac->scan_timeout, NULL, 0);
+		INIT_DELAYED_WORK(&mac->scan_timeout, qtnf_mac_scan_timeout);
 		mac->iflist[i].stats64 =
 			netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
 		if (!mac->iflist[i].stats64)
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 29f38bd3b491..3b884c80b6ab 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -133,7 +133,7 @@ struct qtnf_wmac {
 	struct qtnf_vif iflist[QTNF_MAX_INTF];
 	struct cfg80211_scan_request *scan_req;
 	struct mutex mac_lock;	/* lock during wmac speicific ops */
-	struct timer_list scan_timeout;
+	struct delayed_work scan_timeout;
 };
 
 struct qtnf_hw_info {
@@ -168,6 +168,7 @@ void qtnf_update_tx_stats(struct net_device *ndev, const struct sk_buff *skb);
 void qtnf_virtual_intf_cleanup(struct net_device *ndev);
 
 void qtnf_netdev_updown(struct net_device *ndev, bool up);
+void qtnf_scan_done(struct qtnf_wmac *mac, bool aborted);
 
 static inline struct qtnf_vif *qtnf_netdev_get_priv(struct net_device *dev)
 {
-- 
2.11.0
