Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0084.outbound.protection.outlook.com ([104.47.32.84]:28030
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751374AbeCZNg4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 09:36:56 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>,
        Dmitry Lebed <lebed.dmitry@gmail.com>
Subject: [PATCH 3/3] qtnfmac: add DFS offload support
Date: Mon, 26 Mar 2018 16:36:33 +0300
Message-Id: <20180326133633.8771-4-sergey.matyukevich.os@quantenna.com> (sfid-20180326_153702_007190_5CF7F0AE)
In-Reply-To: <20180326133633.8771-1-sergey.matyukevich.os@quantenna.com>
References: <20180326133633.8771-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dmitry Lebed <dlebed@quantenna.com>

DFS offload support implemented:
- DFS_OFFLOAD feature is advertised depending on HW capabilities
- CAC_STARTED event forwarding from HW implemented
- start_radar_detection() callback now returning -ENOTSUPP
  if DFS_OFFLOAD is enabled

Signed-off-by: Dmitry Lebed <dlebed@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c |  9 +++++++++
 drivers/net/wireless/quantenna/qtnfmac/event.c    | 11 +++++++++++
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    |  7 +++++--
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 0398bece5782..5122dc798064 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -813,6 +813,9 @@ static int qtnf_start_radar_detection(struct wiphy *wiphy,
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(ndev);
 	int ret;
 
+	if (wiphy_ext_feature_isset(wiphy, NL80211_EXT_FEATURE_DFS_OFFLOAD))
+		return -ENOTSUPP;
+
 	ret = qtnf_cmd_start_cac(vif, chandef, cac_time_ms);
 	if (ret)
 		pr_err("%s: failed to start CAC ret=%d\n", ndev->name, ret);
@@ -909,6 +912,9 @@ struct wiphy *qtnf_wiphy_allocate(struct qtnf_bus *bus)
 {
 	struct wiphy *wiphy;
 
+	if (bus->hw_info.hw_capab & QLINK_HW_CAPAB_DFS_OFFLOAD)
+		qtn_cfg80211_ops.start_radar_detection = NULL;
+
 	wiphy = wiphy_new(&qtn_cfg80211_ops, sizeof(struct qtnf_wmac));
 	if (!wiphy)
 		return NULL;
@@ -982,6 +988,9 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 			WIPHY_FLAG_AP_UAPSD |
 			WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 
+	if (hw_info->hw_capab & QLINK_HW_CAPAB_DFS_OFFLOAD)
+		wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_DFS_OFFLOAD);
+
 	wiphy->probe_resp_offload = NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
 				    NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2;
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index bcd415f96412..cb2a6c12f870 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -443,6 +443,17 @@ static int qtnf_event_handle_radar(struct qtnf_vif *vif,
 		cfg80211_cac_event(vif->netdev, &chandef,
 				   NL80211_RADAR_CAC_ABORTED, GFP_KERNEL);
 		break;
+	case QLINK_RADAR_CAC_STARTED:
+		if (vif->wdev.cac_started)
+			break;
+
+		if (!wiphy_ext_feature_isset(wiphy,
+					     NL80211_EXT_FEATURE_DFS_OFFLOAD))
+			break;
+
+		cfg80211_cac_event(vif->netdev, &chandef,
+				   NL80211_RADAR_CAC_STARTED, GFP_KERNEL);
+		break;
 	default:
 		pr_warn("%s: unhandled radar event %u\n",
 			vif->netdev->name, ev->event);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 9bf3ae4d1b3b..9ab27e158023 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -68,10 +68,12 @@ struct qlink_msg_header {
  * @QLINK_HW_CAPAB_STA_INACT_TIMEOUT: device implements a logic to kick-out
  *	associated STAs due to inactivity. Inactivity timeout period is taken
  *	from QLINK_CMD_START_AP parameters.
+ * @QLINK_HW_CAPAB_DFS_OFFLOAD: device implements DFS offload functionality
  */
 enum qlink_hw_capab {
-	QLINK_HW_CAPAB_REG_UPDATE = BIT(0),
-	QLINK_HW_CAPAB_STA_INACT_TIMEOUT = BIT(1),
+	QLINK_HW_CAPAB_REG_UPDATE		= BIT(0),
+	QLINK_HW_CAPAB_STA_INACT_TIMEOUT	= BIT(1),
+	QLINK_HW_CAPAB_DFS_OFFLOAD		= BIT(2),
 };
 
 enum qlink_iface_type {
@@ -1031,6 +1033,7 @@ enum qlink_radar_event {
 	QLINK_RADAR_CAC_ABORTED,
 	QLINK_RADAR_NOP_FINISHED,
 	QLINK_RADAR_PRE_CAC_EXPIRED,
+	QLINK_RADAR_CAC_STARTED,
 };
 
 /**
-- 
2.11.0
