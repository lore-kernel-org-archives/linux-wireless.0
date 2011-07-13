Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46382 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab1GMMYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 08:24:30 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC 1/3] mac80211: Add 20/40 BSS coexistence management frame format
Date: Wed, 13 Jul 2011 17:54:31 +0530
Message-ID: <1310559873-10314-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110713_142434_262323_C456F32D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add 20/40 BSS coexistence and intolerant channel report IEs.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 include/linux/ieee80211.h |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index a26108e..af6f57f 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -634,6 +634,34 @@ struct ieee80211_rann_ie {
 
 #define WLAN_SA_QUERY_TR_ID_LEN 2
 
+/**
+ * struct ieee80211_2040_bss_coex_ie
+ *
+ * This structure refers to "20/40 BSS Coexistence information element"
+ */
+struct ieee80211_2040_bss_coex_ie {
+	u8 element_id;
+	u8 length;
+#define IEEE80211_2040_BC_INFO_REQ		0x01
+#define IEEE80211_2040_BC_40MHZ_INTOL		0x02
+#define IEEE80211_2040_BC_20MHZ_WIDTH_REQ	0x04
+#define IEEE80211_2040_BC_OBSS_SCAN_EXMPT_REQ	0x08
+#define IEEE80211_2040_BC_OBSS_SCAN_EXMPT_GRNT	0x10
+	u8 coex_param;
+} __packed;
+
+/**
+ * struct ieee80211_2040_intol_chan_report
+ *
+ * This structure refers to "20/40 BSS Intolerant Channel Report"
+ */
+struct ieee80211_2040_intol_chan_report {
+	u8 element_id;
+	u8 length;
+	u8 reg_class;
+	u8 variable[0];
+} __packed;
+
 struct ieee80211_mgmt {
 	__le16 frame_control;
 	__le16 duration;
@@ -761,6 +789,13 @@ struct ieee80211_mgmt {
 					u8 action;
 					u8 smps_control;
 				} __attribute__ ((packed)) ht_smps;
+				struct {
+					u8 action_code;
+					struct ieee80211_2040_bss_coex_ie
+						bc_elem;
+					struct ieee80211_2040_intol_chan_report
+						ic_report;
+				} __packed bss_coex;
 			} u;
 		} __attribute__ ((packed)) action;
 	} u;
@@ -1253,6 +1288,7 @@ enum ieee80211_eid {
 	WLAN_EID_RRM_ENABLED_CAPABILITIES = 70,
 	WLAN_EID_MULTIPLE_BSSID = 71,
 	WLAN_EID_BSS_COEX_2040 = 72,
+	WLAN_EID_BSS_2040_INTOL_CHAN_REPORT = 73,
 	WLAN_EID_OVERLAP_BSS_SCAN_PARAM = 74,
 	WLAN_EID_EXT_CAPABILITY = 127,
 
-- 
1.7.6

