Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42083 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab2KTVoy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 16:44:54 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 09/10] wireless: add definitions for VHT MCS support
Date: Tue, 20 Nov 2012 22:45:15 +0100
Message-Id: <1353447916-17304-10-git-send-email-johannes@sipsolutions.net> (sfid-20121120_224514_309933_69921F95)
In-Reply-To: <1353447916-17304-1-git-send-email-johannes@sipsolutions.net>
References: <1353447916-17304-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add definitions for the VHT MCS support values that
are used to indicate, for each number of streams
(1 through 8) which MCSes are supported.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index d687909..76bfb3e 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1148,11 +1148,13 @@ struct ieee80211_ht_operation {
  *	STA can receive. Rate expressed in units of 1 Mbps.
  *	If this field is 0 this value should not be used to
  *	consider the highest RX data rate supported.
+ *	The top 3 bits of this field are reserved.
  * @tx_mcs_map: TX MCS map 2 bits for each stream, total 8 streams
  * @tx_highest: Indicates highest long GI VHT PPDU data rate
  *	STA can transmit. Rate expressed in units of 1 Mbps.
  *	If this field is 0 this value should not be used to
  *	consider the highest TX data rate supported.
+ *	The top 3 bits of this field are reserved.
  */
 struct ieee80211_vht_mcs_info {
 	__le16 rx_mcs_map;
@@ -1162,6 +1164,27 @@ struct ieee80211_vht_mcs_info {
 } __packed;
 
 /**
+ * enum ieee80211_vht_mcs_support - VHT MCS support definitions
+ * @IEEE80211_VHT_MCS_SUPPORT_0_7: MCSes 0-7 are supported for the
+ *	number of streams
+ * @IEEE80211_VHT_MCS_SUPPORT_0_8: MCSes 0-8 are supported
+ * @IEEE80211_VHT_MCS_SUPPORT_0_9: MCSes 0-9 are supported
+ * @IEEE80211_VHT_MCS_NOT_SUPPORTED: This number of streams isn't supported
+ *
+ * These definitions are used in each 2-bit subfield of the @rx_mcs_map
+ * and @tx_mcs_map fields of &struct ieee80211_vht_mcs_info, which are
+ * both split into 8 subfields by number of streams. These values indicate
+ * which MCSes are supported for the number of streams the value appears
+ * for.
+ */
+enum ieee80211_vht_mcs_support {
+	IEEE80211_VHT_MCS_SUPPORT_0_7	= 0,
+	IEEE80211_VHT_MCS_SUPPORT_0_8	= 1,
+	IEEE80211_VHT_MCS_SUPPORT_0_9	= 2,
+	IEEE80211_VHT_MCS_NOT_SUPPORTED	= 3,
+};
+
+/**
  * struct ieee80211_vht_cap - VHT capabilities
  *
  * This structure is the "VHT capabilities element" as
-- 
1.8.0

