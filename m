Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0084.outbound.protection.outlook.com ([104.47.37.84]:11360
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753196AbdIRMaF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 08:30:05 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2 2/2] qtnfmac: cancel scans on wireless interface changes
Date: Mon, 18 Sep 2017 15:29:50 +0300
Message-Id: <20170918122950.32612-3-sergey.matyukevich.os@quantenna.com> (sfid-20170918_143012_182451_2B8C24F5)
In-Reply-To: <20170918122950.32612-1-sergey.matyukevich.os@quantenna.com>
References: <20170918122950.32612-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cancel active scans and deactivate firmware scan watchdog timer
when wireless interface configuration is changed. The usecases
include wireless interface mode change, interface down,
AP stop, virtual interface removal.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 9 ++++++---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.h | 3 +++
 drivers/net/wireless/quantenna/qtnfmac/event.c    | 2 --
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 856fa6e8327e..a450bc6bc774 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -115,6 +115,8 @@ int qtnf_del_virtual_intf(struct wiphy *wiphy, struct wireless_dev *wdev)
 
 	vif = qtnf_netdev_get_priv(wdev->netdev);
 
+	qtnf_scan_done(vif->mac, true);
+
 	if (qtnf_cmd_send_del_intf(vif))
 		pr_err("VIF%u.%u: failed to delete VIF\n", vif->mac->macid,
 		       vif->vifid);
@@ -335,6 +337,8 @@ static int qtnf_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
 	int ret;
 
+	qtnf_scan_done(vif->mac, true);
+
 	ret = qtnf_cmd_send_stop_ap(vif);
 	if (ret) {
 		pr_err("VIF%u.%u: failed to stop AP operation in FW\n",
@@ -570,8 +574,6 @@ qtnf_del_station(struct wiphy *wiphy, struct net_device *dev,
 	    !qtnf_sta_list_lookup(&vif->sta_list, params->mac))
 		return 0;
 
-	qtnf_scan_done(vif->mac, true);
-
 	ret = qtnf_cmd_send_del_sta(vif, params);
 	if (ret)
 		pr_err("VIF%u.%u: failed to delete STA %pM\n",
@@ -1134,8 +1136,9 @@ void qtnf_virtual_intf_cleanup(struct net_device *ndev)
 		}
 
 		vif->sta_state = QTNF_STA_DISCONNECTED;
-		qtnf_scan_done(mac, true);
 	}
+
+	qtnf_scan_done(mac, true);
 }
 
 void qtnf_cfg80211_vif_reset(struct qtnf_vif *vif)
diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
index 6a4af52522b8..66db26613b1f 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.h
@@ -34,6 +34,9 @@ static inline void qtnf_scan_done(struct qtnf_wmac *mac, bool aborted)
 		.aborted = aborted,
 	};
 
+	if (timer_pending(&mac->scan_timeout))
+		del_timer_sync(&mac->scan_timeout);
+
 	mutex_lock(&mac->mac_lock);
 
 	if (mac->scan_req) {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index 0fc2814eafad..43d2e7fd6e02 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -345,8 +345,6 @@ qtnf_event_handle_scan_complete(struct qtnf_wmac *mac,
 		return -EINVAL;
 	}
 
-	if (timer_pending(&mac->scan_timeout))
-		del_timer_sync(&mac->scan_timeout);
 	qtnf_scan_done(mac, le32_to_cpu(status->flags) & QLINK_SCAN_ABORTED);
 
 	return 0;
-- 
2.11.0
