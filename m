Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-5.exch022.serverdata.net ([206.225.164.188]:9794 "EHLO
	HUB022-nj-5.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926Ab2JJLZl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 07:25:41 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Rename VHT cap struct
Date: Wed, 10 Oct 2012 11:25:40 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCFB334@mbx022-e1-nj-10.exch022.domain.local> (sfid-20121010_132544_904074_C3D4C699)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mahesh Palivela <maheshp@posedge.com>

Renamed struct ieee80211_vht_capabilities to ieee80211_vht_cap
And renamed member vht_capabilities_info to vht_cap_info

Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
---
 include/linux/ieee80211.h |   45 +++++++++++++++++++++++++++++++--------------
 net/mac80211/main.c       |    2 +-
 net/mac80211/mlme.c       |    4 ++--
 net/mac80211/util.c       |    4 ++--
 4 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 2385119..8c803f0 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1107,20 +1107,6 @@ struct ieee80211_ht_operation {
 #define WLAN_HT_SMPS_CONTROL_STATIC	1
 #define WLAN_HT_SMPS_CONTROL_DYNAMIC	3
 
-#define VHT_MCS_SUPPORTED_SET_SIZE      8
-
-struct ieee80211_vht_capabilities {
-	__le32 vht_capabilities_info;
-	u8 vht_supported_mcs_set[VHT_MCS_SUPPORTED_SET_SIZE];
-} __packed;
-
-struct ieee80211_vht_operation {
-	u8 vht_op_info_chwidth;
-	u8 vht_op_info_chan_center_freq_seg1_idx;
-	u8 vht_op_info_chan_center_freq_seg2_idx;
-	__le16 vht_basic_mcs_set;
-} __packed;
-
 /**
  * struct ieee80211_vht_mcs_info - VHT MCS information
  * @rx_mcs_map: RX MCS map 2 bits for each stream, total 8 streams
@@ -1141,6 +1127,37 @@ struct ieee80211_vht_mcs_info {
 	__le16 tx_highest;
 } __packed;
 
+/**
+ * struct ieee80211_vht_cap - VHT capabilities
+ *
+ * This structure is the "VHT capabilities element" as
+ * described in 802.11ac D3.0 8.4.2.160
+ * @vht_cap_info: VHT capability info
+ * @supp_mcs: VHT MCS supported rates
+ */
+struct ieee80211_vht_cap {
+	__le32 vht_cap_info;
+	struct ieee80211_vht_mcs_info supp_mcs;
+} __packed;
+
+/**
+ * struct ieee80211_vht_operation - VHT operation IE
+ *
+ * This structure is the "VHT operation element" as
+ * described in 802.11ac D3.0 8.4.2.161
+ * @chan_width: Operating channel width
+ * @center_freq_seg1_idx: center freq segment 1 index
+ * @center_freq_seg2_idx: center freq segment 2 index
+ * @basic_mcs_set: VHT Basic MCS rate set
+ */
+struct ieee80211_vht_operation {
+	u8 chan_width;
+	u8 center_freq_seg1_idx;
+	u8 center_freq_seg2_idx;
+	__le16 basic_mcs_set;
+} __packed;
+
+
 #define IEEE80211_VHT_MCS_ZERO_TO_SEVEN_SUPPORT 0
 #define IEEE80211_VHT_MCS_ZERO_TO_EIGHT_SUPPORT 1
 #define IEEE80211_VHT_MCS_ZERO_TO_NINE_SUPPORT  2
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 473b755..620f427 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -876,7 +876,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	if (supp_vht)
 		local->scan_ies_len +=
-			2 + sizeof(struct ieee80211_vht_capabilities);
+			2 + sizeof(struct ieee80211_vht_cap);
 
 	if (!local->ops->hw_scan) {
 		/* For hw_scan, driver needs to set these up. */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8cefc18..80615c6 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -353,7 +353,7 @@ static void ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
 	cap = vht_cap.cap;
 
 	/* reserve and fill IE */
-	pos = skb_put(skb, sizeof(struct ieee80211_vht_capabilities) + 2);
+	pos = skb_put(skb, sizeof(struct ieee80211_vht_cap) + 2);
 	ieee80211_ie_build_vht_cap(pos, &vht_cap, cap);
 }
 
@@ -412,7 +412,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 			4 + /* power capability */
 			2 + 2 * sband->n_channels + /* supported channels */
 			2 + sizeof(struct ieee80211_ht_cap) + /* HT */
-			2 + sizeof(struct ieee80211_vht_capabilities) + /* VHT */
+			2 + sizeof(struct ieee80211_vht_cap) + /* VHT */
 			assoc_data->ie_len + /* extra IEs */
 			9, /* WMM */
 			GFP_KERNEL);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3b35356..ea94f6a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1772,8 +1772,8 @@ u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 	__le32 tmp;
 
 	*pos++ = WLAN_EID_VHT_CAPABILITY;
-	*pos++ = sizeof(struct ieee80211_vht_capabilities);
-	memset(pos, 0, sizeof(struct ieee80211_vht_capabilities));
+	*pos++ = sizeof(struct ieee80211_vht_cap);
+	memset(pos, 0, sizeof(struct ieee80211_vht_cap));
 
 	/* capability flags */
 	tmp = cpu_to_le32(cap);