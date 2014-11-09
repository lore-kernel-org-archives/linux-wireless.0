Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:37262 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaKIQum (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2014 11:50:42 -0500
Received: by mail-wg0-f53.google.com with SMTP id b13so7092009wgh.40
        for <linux-wireless@vger.kernel.org>; Sun, 09 Nov 2014 08:50:41 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 12/16] mac80211: add parsing of TDLS specific IEs
Date: Sun,  9 Nov 2014 18:50:18 +0200
Message-Id: <1415551822-20121-12-git-send-email-arik@wizery.com> (sfid-20141109_175047_298828_12C4453B)
In-Reply-To: <1415551822-20121-1-git-send-email-arik@wizery.com>
References: <1415551822-20121-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are used in TDLS channel switching code.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/linux/ieee80211.h  | 15 +++++++++++++++
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/util.c        | 16 ++++++++++++++++
 3 files changed, 33 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index fbb02d2..4f4eea8 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1067,6 +1067,12 @@ struct ieee80211_pspoll {
 
 /* TDLS */
 
+/* Channel switch timing */
+struct ieee80211_ch_switch_timing {
+	__le16 switch_time;
+	__le16 switch_timeout;
+} __packed;
+
 /* Link-id information element */
 struct ieee80211_tdls_lnkie {
 	u8 ie_type; /* Link Identifier IE */
@@ -1108,6 +1114,15 @@ struct ieee80211_tdls_data {
 			u8 dialog_token;
 			u8 variable[0];
 		} __packed discover_req;
+		struct {
+			u8 target_channel;
+			u8 oper_class;
+			u8 variable[0];
+		} __packed chan_switch_req;
+		struct {
+			__le16 status_code;
+			u8 variable[0];
+		} __packed chan_switch_resp;
 	} u;
 } __packed;
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4b3a7e7..e786ab6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1400,6 +1400,8 @@ struct ieee802_11_elems {
 	size_t total_len;
 
 	/* pointers to IEs */
+	const struct ieee80211_tdls_lnkie *lnk_id;
+	const struct ieee80211_ch_switch_timing *ch_sw_timing;
 	const u8 *ext_capab;
 	const u8 *ssid;
 	const u8 *supp_rates;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3ca0c2e..9e5bfd6 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -832,6 +832,8 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 		case WLAN_EID_WIDE_BW_CHANNEL_SWITCH:
 		case WLAN_EID_CHAN_SWITCH_PARAM:
 		case WLAN_EID_EXT_CAPABILITY:
+		case WLAN_EID_CHAN_SWITCH_TIMING:
+		case WLAN_EID_LINK_ID:
 		/*
 		 * not listing WLAN_EID_CHANNEL_SWITCH_WRAPPER -- it seems possible
 		 * that if the content gets bigger it might be needed more than once
@@ -851,6 +853,20 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 		elem_parse_failed = false;
 
 		switch (id) {
+		case WLAN_EID_LINK_ID:
+			if (elen + 2 != sizeof(struct ieee80211_tdls_lnkie)) {
+				elem_parse_failed = true;
+				break;
+			}
+			elems->lnk_id = (void *)(pos - 2);
+			break;
+		case WLAN_EID_CHAN_SWITCH_TIMING:
+			if (elen != sizeof(struct ieee80211_ch_switch_timing)) {
+				elem_parse_failed = true;
+				break;
+			}
+			elems->ch_sw_timing = (void *)pos;
+			break;
 		case WLAN_EID_EXT_CAPABILITY:
 			elems->ext_capab = pos;
 			elems->ext_capab_len = elen;
-- 
1.9.1

