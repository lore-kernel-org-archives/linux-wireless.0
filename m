Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39405 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3C0NkH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 09:40:07 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/4] mac80211: parse Timeout Interval Element using a struct
Date: Wed, 27 Mar 2013 14:39:57 +0100
Message-Id: <1364391597-3977-5-git-send-email-johannes@sipsolutions.net> (sfid-20130327_144019_626778_F27AFF7F)
In-Reply-To: <1364391597-3977-1-git-send-email-johannes@sipsolutions.net>
References: <1364391597-3977-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of open-coding the accesses and length check do
the length check in the IE parser and assign a struct
pointer for use in the remaining code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h  | 10 ++++++++++
 net/mac80211/ieee80211_i.h |  3 +--
 net/mac80211/mlme.c        |  6 +++---
 net/mac80211/util.c        |  6 ++++--
 4 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index db1b3a6..b25c987 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1991,6 +1991,16 @@ enum ieee80211_timeout_interval_type {
 	WLAN_TIMEOUT_ASSOC_COMEBACK = 3 /* 802.11w */,
 };
 
+/**
+ * struct ieee80211_timeout_interval_ie - Timeout Interval element
+ * @type: type, see &enum ieee80211_timeout_interval_type
+ * @value: timeout interval value
+ */
+struct ieee80211_timeout_interval_ie {
+	u8 type;
+	__le32 value;
+} __packed;
+
 /* BACK action code */
 enum ieee80211_back_actioncode {
 	WLAN_ACTION_ADDBA_REQ = 0,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index eb364f3..71fb97d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1182,7 +1182,7 @@ struct ieee802_11_elems {
 	const struct ieee80211_wide_bw_chansw_ie *wide_bw_chansw_ie;
 	const u8 *country_elem;
 	const u8 *pwr_constr_elem;
-	const u8 *timeout_int;
+	const struct ieee80211_timeout_interval_ie *timeout_int;
 	const u8 *opmode_notif;
 	const struct ieee80211_sec_chan_offs_ie *sec_chan_offs;
 
@@ -1201,7 +1201,6 @@ struct ieee802_11_elems {
 	u8 prep_len;
 	u8 perr_len;
 	u8 country_elem_len;
-	u8 timeout_int_len;
 
 	/* whether a parse error occurred while retrieving these elements */
 	bool parse_error;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c6d87bc4..00cee31 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2696,10 +2696,10 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
 
 	if (status_code == WLAN_STATUS_ASSOC_REJECTED_TEMPORARILY &&
-	    elems.timeout_int && elems.timeout_int_len == 5 &&
-	    elems.timeout_int[0] == WLAN_TIMEOUT_ASSOC_COMEBACK) {
+	    elems.timeout_int &&
+	    elems.timeout_int->type == WLAN_TIMEOUT_ASSOC_COMEBACK) {
 		u32 tu, ms;
-		tu = get_unaligned_le32(elems.timeout_int + 1);
+		tu = le32_to_cpu(elems.timeout_int->value);
 		ms = tu * 1024 / 1000;
 		sdata_info(sdata,
 			   "%pM rejected association temporarily; comeback duration %u TU (%u ms)\n",
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 739ae33..e9107d9 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -897,8 +897,10 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			elems->pwr_constr_elem = pos;
 			break;
 		case WLAN_EID_TIMEOUT_INTERVAL:
-			elems->timeout_int = pos;
-			elems->timeout_int_len = elen;
+			if (elen >= sizeof(struct ieee80211_timeout_interval_ie))
+				elems->timeout_int = (void *)pos;
+			else
+				elem_parse_failed = true;
 			break;
 		default:
 			break;
-- 
1.8.0

