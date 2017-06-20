Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0062.outbound.protection.outlook.com ([104.47.40.62]:63680
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752117AbdFTT4Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Jun 2017 15:56:16 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 8/8] qtnfmac: implement scan timeout
Date: Tue, 20 Jun 2017 22:55:17 +0300
Message-Id: <20170620195517.18373-9-sergey.matyukevich.os@quantenna.com> (sfid-20170620_215620_876991_6B5404CF)
In-Reply-To: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Userspace tools may hang on scan in the case when scan completion event
is not returned by firmware. This patch implements the scan timeout
to avoid such situation.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 22 ++++++++++++++++++----
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.h |  4 ++++
 drivers/net/wireless/quantenna/qtnfmac/core.c     |  2 ++
 drivers/net/wireless/quantenna/qtnfmac/core.h     | 13 +++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/event.c    |  2 ++
 5 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 097f29189339..a0ab7d289684 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -741,19 +741,33 @@ qtnf_del_station(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
+static void qtnf_scan_timeout(unsigned long data)
+{
+	struct qtnf_wmac *mac = (struct qtnf_wmac *)data;
+
+	pr_warn("mac%d scan timed out\n", mac->macid);
+	qtnf_scan_done(mac, true);
+}
+
 static int
 qtnf_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
 	struct qtnf_wmac *mac = wiphy_priv(wiphy);
-	int ret;
 
 	mac->scan_req = request;
 
-	ret = qtnf_cmd_send_scan(mac);
-	if (ret)
+	if (qtnf_cmd_send_scan(mac)) {
 		pr_err("MAC%u: failed to start scan\n", mac->macid);
+		mac->scan_req = NULL;
+		return -EFAULT;
+	}
 
-	return ret;
+	mac->scan_timeout.data = (unsigned long)mac;
+	mac->scan_timeout.function = qtnf_scan_timeout;
+	mod_timer(&mac->scan_timeout,
+		  jiffies + QTNF_SCAN_TIMEOUT_SEC * HZ);
+
+	return 0;
 }
 
 static int
diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
index 5bd33124a7c8..eddd040b8869 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
@@ -34,10 +34,14 @@ static inline void qtnf_scan_done(struct qtnf_wmac *mac, bool aborted)
 		.aborted = aborted,
 	};
 
+	qtnf_wmac_lock(mac);
+
 	if (mac->scan_req) {
 		cfg80211_scan_done(mac->scan_req, &info);
 		mac->scan_req = NULL;
 	}
+
+	qtnf_wmac_unlock(mac);
 }
 
 #endif /* _QTN_FMAC_CFG80211_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index 3d9b217790ed..8ce9c370dc94 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -336,6 +336,8 @@ static struct qtnf_wmac *qtnf_core_mac_alloc(struct qtnf_bus *bus,
 		mac->iflist[i].vifid = i;
 		qtnf_list_init(&mac->iflist[i].sta_list);
 		qtnf_list_init(&mac->iflist[i].vlan_list);
+		mutex_init(&mac->mac_lock);
+		init_timer(&mac->scan_timeout);
 	}
 
 	qtnf_mac_init_primary_intf(mac);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index efe078a6d1d3..883b052ccb01 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -46,6 +46,7 @@
 #define QTNF_MAX_EVENT_QUEUE_LEN	255
 #define QTNF_DEFAULT_BG_SCAN_PERIOD	300
 #define QTNF_MAX_BG_SCAN_PERIOD		0xffff
+#define QTNF_SCAN_TIMEOUT_SEC		15
 
 #define QTNF_DEF_BSS_PRIORITY		0
 #define QTNF_DEF_WDOG_TIMEOUT		5
@@ -161,6 +162,8 @@ struct qtnf_wmac {
 	struct cfg80211_scan_request *scan_req;
 	struct cfg80211_chan_def chandef;
 	struct cfg80211_chan_def csa_chandef;
+	struct mutex mac_lock;	/* lock during wmac speicific ops */
+	struct timer_list scan_timeout;
 };
 
 struct qtnf_hw_info {
@@ -197,4 +200,14 @@ static inline struct qtnf_vif *qtnf_netdev_get_priv(struct net_device *dev)
 	return *((void **)netdev_priv(dev));
 }
 
+static __always_inline void qtnf_wmac_lock(struct qtnf_wmac *mac)
+{
+	mutex_lock(&mac->mac_lock);
+}
+
+static __always_inline void qtnf_wmac_unlock(struct qtnf_wmac *mac)
+{
+	mutex_unlock(&mac->mac_lock);
+}
+
 #endif /* _QTN_FMAC_CORE_H_ */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index b48d9e8b6935..2c0d6095544f 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -345,6 +345,8 @@ qtnf_event_handle_scan_complete(struct qtnf_wmac *mac,
 		return -EINVAL;
 	}
 
+	if (timer_pending(&mac->scan_timeout))
+		del_timer_sync(&mac->scan_timeout);
 	qtnf_scan_done(mac, le32_to_cpu(status->flags) & QLINK_SCAN_ABORTED);
 
 	return 0;
-- 
2.11.0
