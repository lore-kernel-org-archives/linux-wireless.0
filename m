Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26652 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbaG3LkK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2014 07:40:10 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] ieee80211: Support parsing TPC report element in action frames
Date: Wed, 30 Jul 2014 14:36:18 +0300
Message-Id: <1406720178-6178-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140730_134015_222432_9BFF87A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

TPC report element is contained in spectrum management's tpc report
action frames and in radio measurement's link measurement report
action frames. Add a function which checks whether an action frame
contains this element. This may be needed by the drivers in order
to set the correct tx power value in these frames.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/linux/ieee80211.h | 65 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 37ffd9d..2875cf8 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -839,6 +839,16 @@ enum ieee80211_vht_opmode_bits {
 
 #define WLAN_SA_QUERY_TR_ID_LEN 2
 
+/**
+ * struct ieee80211_tpc_report_ie
+ *
+ * This structure refers to "TPC Report element"
+ */
+struct ieee80211_tpc_report_ie {
+	u8 tx_power;
+	u8 link_margin;
+} __packed;
+
 struct ieee80211_mgmt {
 	__le16 frame_control;
 	__le16 duration;
@@ -974,6 +984,13 @@ struct ieee80211_mgmt {
 					u8 action_code;
 					u8 operating_mode;
 				} __packed vht_opmode_notif;
+				struct {
+					u8 action_code;
+					u8 dialog_token;
+					u8 tpc_elem_id;
+					u8 tpc_elem_length;
+					struct ieee80211_tpc_report_ie tpc;
+				} __packed tpc_report;
 			} u;
 		} __packed action;
 	} u;
@@ -1865,6 +1882,7 @@ enum ieee80211_category {
 	WLAN_CATEGORY_DLS = 2,
 	WLAN_CATEGORY_BACK = 3,
 	WLAN_CATEGORY_PUBLIC = 4,
+	WLAN_CATEGORY_RADIO_MEASUREMENT = 5,
 	WLAN_CATEGORY_HT = 7,
 	WLAN_CATEGORY_SA_QUERY = 8,
 	WLAN_CATEGORY_PROTECTED_DUAL_OF_ACTION = 9,
@@ -2383,4 +2401,51 @@ static inline bool ieee80211_check_tim(const struct ieee80211_tim_ie *tim,
 #define TU_TO_JIFFIES(x)	(usecs_to_jiffies((x) * 1024))
 #define TU_TO_EXP_TIME(x)	(jiffies + TU_TO_JIFFIES(x))
 
+/**
+ * ieee80211_action_contains_tpc - checks if the frame contains TPC element
+ * @skb: the skb containing the frame, length will be checked
+ *
+ * This function checks if it's either TPC report action frame or Link
+ * Measurement report action frame as defined in IEEE Std. 802.11-2012 8.5.2.5
+ * and 8.5.7.5 accordingly.
+ */
+static inline bool ieee80211_action_contains_tpc(struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt = (void *)skb->data;
+
+	if (!ieee80211_is_action(mgmt->frame_control))
+		return false;
+
+	if (skb->len < IEEE80211_MIN_ACTION_SIZE +
+		       sizeof(mgmt->u.action.u.tpc_report))
+		return false;
+
+	/*
+	 * TPC report - check that:
+	 * category = 0 (Spectrum Management) or 5 (Radio Measurement)
+	 * spectrum management action = 3 (TPC/Link Measurement report)
+	 * TPC report EID = 35
+	 * TPC report element length = 2
+	 *
+	 * The spectrum management's tpc_report struct is used here both for
+	 * parsing tpc_report and radio measurement's link measurement report
+	 * frame, since the relevant part is identical in both frames.
+	 */
+	if (mgmt->u.action.category != WLAN_CATEGORY_SPECTRUM_MGMT &&
+	    mgmt->u.action.category != WLAN_CATEGORY_RADIO_MEASUREMENT)
+		return false;
+
+	/* both spectrum mgmt and link measurement have same action code */
+	if (mgmt->u.action.u.tpc_report.action_code !=
+	    WLAN_ACTION_SPCT_TPC_RPRT)
+		return false;
+
+	if (mgmt->u.action.u.tpc_report.tpc_elem_id != WLAN_EID_TPC_REPORT ||
+	    mgmt->u.action.u.tpc_report.tpc_elem_length !=
+	    sizeof(struct ieee80211_tpc_report_ie))
+		return false;
+
+	return true;
+}
+
 #endif /* LINUX_IEEE80211_H */
-- 
1.9.1

