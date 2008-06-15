Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60373 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757692AbYFOPXh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2008 11:23:37 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>
Subject: [PATCH 1/2] mac80211: 11h Infrastructure - Parsing
Date: Sun, 15 Jun 2008 18:23:29 +0300
Message-Id: <1213543410-30890-1-git-send-email-tomas.winkler@intel.com> (sfid-20080615_172403_123383_45B0B775)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

This patch introduces parsing of 11h and 11d related elements from incoming
management frames.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/linux/ieee80211.h  |   54 +++++++++++++++++++++++++++++++++++++++++--
 net/mac80211/ieee80211_i.h |    9 +++++++
 net/mac80211/mlme.c        |   19 +++++++++++++++
 3 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 2998e3b..8546f09 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -469,6 +469,40 @@ struct ieee80211s_hdr {
 	u8 eaddr3[6];
 } __attribute__ ((packed));
 
+/**
+ * struct ieee80211_quiet_ie
+ *
+ * This structure refers to "Quiet information element"
+ */
+struct ieee80211_quiet_ie {
+	u8 count;
+	u8 period;
+	__le16 duration;
+	__le16 offset;
+} __attribute__ ((packed));
+
+/**
+ * struct ieee80211_msrment_ie
+ *
+ * This structure refers to "Measurement Request/Report information element"
+ */
+struct ieee80211_msrment_ie {
+	u8 token;
+	u8 mode;
+	u8 type;
+	u8 request[0];
+} __attribute__ ((packed));
+
+/**
+ * struct ieee80211_channel_sw_ie
+ *
+ * This structure refers to "Channel Switch Announcement information element"
+ */
+struct ieee80211_channel_sw_ie {
+	u8 mode;
+	u8 new_ch_num;
+	u8 count;
+} __attribute__ ((packed));
 
 struct ieee80211_mgmt {
 	__le16 frame_control;
@@ -544,13 +578,18 @@ struct ieee80211_mgmt {
 					u8 action_code;
 					u8 element_id;
 					u8 length;
-					u8 switch_mode;
-					u8 new_chan;
-					u8 switch_count;
+					struct ieee80211_channel_sw_ie sw_elem;
 				} __attribute__((packed)) chan_switch;
 				struct{
 					u8 action_code;
 					u8 dialog_token;
+					u8 element_id;
+					u8 length;
+					struct ieee80211_msrment_ie msr_elem;
+				} __attribute__((packed)) measurement;
+				struct{
+					u8 action_code;
+					u8 dialog_token;
 					__le16 capab;
 					__le16 timeout;
 					__le16 start_seq_num;
@@ -875,6 +914,15 @@ enum ieee80211_category {
 	WLAN_CATEGORY_WMM = 17,
 };
 
+/* SPECTRUM_MGMT action code */
+enum ieee80211_spectrum_mgmt_actioncode {
+	WLAN_ACTION_SPCT_MSR_REQ = 0,
+	WLAN_ACTION_SPCT_MSR_RPRT = 1,
+	WLAN_ACTION_SPCT_TPC_REQ = 2,
+	WLAN_ACTION_SPCT_TPC_RPRT = 3,
+	WLAN_ACTION_SPCT_CHL_SWITCH = 4,
+};
+
 /* BACK action code */
 enum ieee80211_back_actioncode {
 	WLAN_ACTION_ADDBA_REQ = 0,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4160982..defcc4d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -790,6 +790,10 @@ struct ieee802_11_elems {
 	u8 *preq;
 	u8 *prep;
 	u8 *perr;
+	u8 *ch_switch_elem;
+	u8 *country_elem;
+	u8 *pwr_constr_elem;
+	u8 *quiet_elem; 	/* first quite element */
 
 	/* length of them, respectively */
 	u8 ssid_len;
@@ -814,6 +818,11 @@ struct ieee802_11_elems {
 	u8 preq_len;
 	u8 prep_len;
 	u8 perr_len;
+	u8 ch_switch_elem_len;
+	u8 country_elem_len;
+	u8 pwr_constr_elem_len;
+	u8 quiet_elem_len;
+	u8 num_of_quiet_elem;	/* can be more the one */
 };
 
 static inline struct ieee80211_local *hw_to_local(
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 55659a7..866eaa0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -204,6 +204,25 @@ void ieee802_11_parse_elems(u8 *start, size_t len,
 			elems->perr = pos;
 			elems->perr_len = elen;
 			break;
+		case WLAN_EID_CHANNEL_SWITCH:
+			elems->ch_switch_elem = pos;
+			elems->ch_switch_elem_len = elen;
+			break;
+		case WLAN_EID_QUIET:
+			if (!elems->quiet_elem) {
+				elems->quiet_elem = pos;
+				elems->quiet_elem_len = elen;
+			}
+			elems->num_of_quiet_elem++;
+			break;
+		case WLAN_EID_COUNTRY:
+			elems->country_elem = pos;
+			elems->country_elem_len = elen;
+			break;
+		case WLAN_EID_PWR_CONSTRAINT:
+			elems->pwr_constr_elem = pos;
+			elems->pwr_constr_elem_len = elen;
+			break;
 		default:
 			break;
 		}
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

