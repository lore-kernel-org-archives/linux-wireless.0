Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15427 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbcC2Kxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 06:53:50 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] cfg80211: Add option to specify previous BSSID for Connect command
Date: Tue, 29 Mar 2016 13:53:27 +0300
Message-ID: <1459248808-16412-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20160329_125354_068745_0D2F178B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This extends NL80211_CMD_CONNECT to allow the NL80211_ATTR_PREV_BSSID
attribute to be used similarly to way this was already allowed with
NL80211_CMD_ASSOCIATE. This allows user space to request reassociation
(instead of association) when already connected to an AP. This provides
an option to reassociate within an ESS without having to disconnect and
associate with the AP.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h | 2 ++
 net/wireless/nl80211.c | 4 ++++
 net/wireless/trace.h   | 6 ++++--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0bbfbf3..5fbb14d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1923,6 +1923,7 @@ struct cfg80211_bss_selection {
  * @pbss: if set, connect to a PCP instead of AP. Valid for DMG
  *	networks.
  * @bss_select: criteria to be used for BSS selection.
+ * @prev_bssid: previous BSSID, if not %NULL use reassociate frame
  */
 struct cfg80211_connect_params {
 	struct ieee80211_channel *channel;
@@ -1947,6 +1948,7 @@ struct cfg80211_connect_params {
 	struct ieee80211_vht_cap vht_capa_mask;
 	bool pbss;
 	struct cfg80211_bss_selection bss_select;
+	const u8 *prev_bssid;
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d6c6449..a98665a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8024,6 +8024,10 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 		connect.mfp = NL80211_MFP_NO;
 	}
 
+	if (info->attrs[NL80211_ATTR_PREV_BSSID])
+		connect.prev_bssid =
+			nla_data(info->attrs[NL80211_ATTR_PREV_BSSID]);
+
 	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
 		connect.channel = nl80211_get_valid_chan(
 			wiphy, info->attrs[NL80211_ATTR_WIPHY_FREQ]);
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 09b242b..8da1fae 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1259,6 +1259,7 @@ TRACE_EVENT(rdev_connect,
 		__field(bool, privacy)
 		__field(u32, wpa_versions)
 		__field(u32, flags)
+		MAC_ENTRY(prev_bssid)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
@@ -1270,13 +1271,14 @@ TRACE_EVENT(rdev_connect,
 		__entry->privacy = sme->privacy;
 		__entry->wpa_versions = sme->crypto.wpa_versions;
 		__entry->flags = sme->flags;
+		MAC_ASSIGN(prev_bssid, sme->prev_bssid);
 	),
 	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", bssid: " MAC_PR_FMT
 		  ", ssid: %s, auth type: %d, privacy: %s, wpa versions: %u, "
-		  "flags: %u",
+		  "flags: %u, previous bssid: " MAC_PR_FMT,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(bssid), __entry->ssid,
 		  __entry->auth_type, BOOL_TO_STR(__entry->privacy),
-		  __entry->wpa_versions, __entry->flags)
+		  __entry->wpa_versions, __entry->flags, MAC_PR_ARG(prev_bssid))
 );
 
 TRACE_EVENT(rdev_set_cqm_rssi_config,
-- 
1.9.1

