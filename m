Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:44551 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab2JREzl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 00:55:41 -0400
From: Sujith Manoharan <c_manoha@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20607.35416.907913.623637@gargle.gargle.HOWL> (sfid-20121018_065553_279891_C636C8C8)
Date: Thu, 18 Oct 2012 10:19:28 +0530
To: <johannes.berg@intel.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: Disallow HT/WEP in IBSS mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, a user is allowed to choose a HT operating channel
with WEP when creating an IBSS network. WEP is not allowed
in HT configuration - this patch ensures that such requests
are denied.

Signed-off-by: Sujith Manoharan <c_manoha@qti.qualcomm.com>
---
 net/wireless/nl80211.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0418a6d..e1255e9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -690,7 +690,7 @@ static int nl80211_parse_key(struct genl_info *info, struct key_parse *k)
 
 static struct cfg80211_cached_keys *
 nl80211_parse_connkeys(struct cfg80211_registered_device *rdev,
-		       struct nlattr *keys)
+		       struct nlattr *keys, bool *no_ht)
 {
 	struct key_parse parse;
 	struct nlattr *key;
@@ -733,6 +733,12 @@ nl80211_parse_connkeys(struct cfg80211_registered_device *rdev,
 		result->params[parse.idx].key_len = parse.p.key_len;
 		result->params[parse.idx].key = result->data[parse.idx];
 		memcpy(result->data[parse.idx], parse.p.key, parse.p.key_len);
+
+		if (result->params[parse.idx].cipher == WLAN_CIPHER_SUITE_WEP40 ||
+		    result->params[parse.idx].cipher == WLAN_CIPHER_SUITE_WEP104) {
+			if (no_ht)
+				*no_ht = true;
+		}
 	}
 
 	return result;
@@ -5339,10 +5345,18 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	if (ibss.privacy && info->attrs[NL80211_ATTR_KEYS]) {
+		bool no_ht = false;
+
 		connkeys = nl80211_parse_connkeys(rdev,
-					info->attrs[NL80211_ATTR_KEYS]);
+					  info->attrs[NL80211_ATTR_KEYS],
+					  &no_ht);
 		if (IS_ERR(connkeys))
 			return PTR_ERR(connkeys);
+
+		if ((ibss.channel_type != NL80211_CHAN_NO_HT) && no_ht) {
+			kfree(connkeys);
+			return -EINVAL;
+		}
 	}
 
 	ibss.control_port =
@@ -5642,7 +5656,7 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 
 	if (connect.privacy && info->attrs[NL80211_ATTR_KEYS]) {
 		connkeys = nl80211_parse_connkeys(rdev,
-					info->attrs[NL80211_ATTR_KEYS]);
+					  info->attrs[NL80211_ATTR_KEYS], NULL);
 		if (IS_ERR(connkeys))
 			return PTR_ERR(connkeys);
 	}
-- 
1.7.12.3

