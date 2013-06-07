Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:39955 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab3FGRFu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 13:05:50 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 1/5] nl80211: use attributes to parse beacons
Date: Fri,  7 Jun 2013 19:05:41 +0200
Message-Id: <1370624745-2267-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130607_190555_840841_CF970700)
In-Reply-To: <1370624745-2267-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1370624745-2267-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

only the attributes are required and not the whole netlink info, as the
function accesses the attributes only anyway. This makes it easier to
parse nested beacon IEs later.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/wireless/nl80211.c |   53 +++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 88e820b..1623f22 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2879,61 +2879,58 @@ static int nl80211_set_mac_acl(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
-static int nl80211_parse_beacon(struct genl_info *info,
+static int nl80211_parse_beacon(struct nlattr *attrs[],
 				struct cfg80211_beacon_data *bcn)
 {
 	bool haveinfo = false;
 
-	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_BEACON_TAIL]) ||
-	    !is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]) ||
-	    !is_valid_ie_attr(info->attrs[NL80211_ATTR_IE_PROBE_RESP]) ||
-	    !is_valid_ie_attr(info->attrs[NL80211_ATTR_IE_ASSOC_RESP]))
+	if (!is_valid_ie_attr(attrs[NL80211_ATTR_BEACON_TAIL]) ||
+	    !is_valid_ie_attr(attrs[NL80211_ATTR_IE]) ||
+	    !is_valid_ie_attr(attrs[NL80211_ATTR_IE_PROBE_RESP]) ||
+	    !is_valid_ie_attr(attrs[NL80211_ATTR_IE_ASSOC_RESP]))
 		return -EINVAL;
 
 	memset(bcn, 0, sizeof(*bcn));
 
-	if (info->attrs[NL80211_ATTR_BEACON_HEAD]) {
-		bcn->head = nla_data(info->attrs[NL80211_ATTR_BEACON_HEAD]);
-		bcn->head_len = nla_len(info->attrs[NL80211_ATTR_BEACON_HEAD]);
+	if (attrs[NL80211_ATTR_BEACON_HEAD]) {
+		bcn->head = nla_data(attrs[NL80211_ATTR_BEACON_HEAD]);
+		bcn->head_len = nla_len(attrs[NL80211_ATTR_BEACON_HEAD]);
 		if (!bcn->head_len)
 			return -EINVAL;
 		haveinfo = true;
 	}
 
-	if (info->attrs[NL80211_ATTR_BEACON_TAIL]) {
-		bcn->tail = nla_data(info->attrs[NL80211_ATTR_BEACON_TAIL]);
-		bcn->tail_len =
-		    nla_len(info->attrs[NL80211_ATTR_BEACON_TAIL]);
+	if (attrs[NL80211_ATTR_BEACON_TAIL]) {
+		bcn->tail = nla_data(attrs[NL80211_ATTR_BEACON_TAIL]);
+		bcn->tail_len = nla_len(attrs[NL80211_ATTR_BEACON_TAIL]);
 		haveinfo = true;
 	}
 
 	if (!haveinfo)
 		return -EINVAL;
 
-	if (info->attrs[NL80211_ATTR_IE]) {
-		bcn->beacon_ies = nla_data(info->attrs[NL80211_ATTR_IE]);
-		bcn->beacon_ies_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+	if (attrs[NL80211_ATTR_IE]) {
+		bcn->beacon_ies = nla_data(attrs[NL80211_ATTR_IE]);
+		bcn->beacon_ies_len = nla_len(attrs[NL80211_ATTR_IE]);
 	}
 
-	if (info->attrs[NL80211_ATTR_IE_PROBE_RESP]) {
+	if (attrs[NL80211_ATTR_IE_PROBE_RESP]) {
 		bcn->proberesp_ies =
-			nla_data(info->attrs[NL80211_ATTR_IE_PROBE_RESP]);
+			nla_data(attrs[NL80211_ATTR_IE_PROBE_RESP]);
 		bcn->proberesp_ies_len =
-			nla_len(info->attrs[NL80211_ATTR_IE_PROBE_RESP]);
+			nla_len(attrs[NL80211_ATTR_IE_PROBE_RESP]);
 	}
 
-	if (info->attrs[NL80211_ATTR_IE_ASSOC_RESP]) {
+	if (attrs[NL80211_ATTR_IE_ASSOC_RESP]) {
 		bcn->assocresp_ies =
-			nla_data(info->attrs[NL80211_ATTR_IE_ASSOC_RESP]);
+			nla_data(attrs[NL80211_ATTR_IE_ASSOC_RESP]);
 		bcn->assocresp_ies_len =
-			nla_len(info->attrs[NL80211_ATTR_IE_ASSOC_RESP]);
+			nla_len(attrs[NL80211_ATTR_IE_ASSOC_RESP]);
 	}
 
-	if (info->attrs[NL80211_ATTR_PROBE_RESP]) {
-		bcn->probe_resp =
-			nla_data(info->attrs[NL80211_ATTR_PROBE_RESP]);
-		bcn->probe_resp_len =
-			nla_len(info->attrs[NL80211_ATTR_PROBE_RESP]);
+	if (attrs[NL80211_ATTR_PROBE_RESP]) {
+		bcn->probe_resp = nla_data(attrs[NL80211_ATTR_PROBE_RESP]);
+		bcn->probe_resp_len = nla_len(attrs[NL80211_ATTR_PROBE_RESP]);
 	}
 
 	return 0;
@@ -3012,7 +3009,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	    !info->attrs[NL80211_ATTR_BEACON_HEAD])
 		return -EINVAL;
 
-	err = nl80211_parse_beacon(info, &params.beacon);
+	err = nl80211_parse_beacon(info->attrs, &params.beacon);
 	if (err)
 		return err;
 
@@ -3164,7 +3161,7 @@ static int nl80211_set_beacon(struct sk_buff *skb, struct genl_info *info)
 	if (!wdev->beacon_interval)
 		return -EINVAL;
 
-	err = nl80211_parse_beacon(info, &params);
+	err = nl80211_parse_beacon(info->attrs, &params);
 	if (err)
 		return err;
 
-- 
1.7.10.4

