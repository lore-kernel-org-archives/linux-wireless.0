Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51437 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab2G0LRD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:17:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 06/20] mac80211: refactor set_channel_type
Date: Fri, 27 Jul 2012 13:16:42 +0200
Message-Id: <1343387816-9414-7-git-send-email-johannes@sipsolutions.net> (sfid-20120727_131737_633247_CE27A20C)
In-Reply-To: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Split functionality for further reuse.

Will prevent code duplication when channel context
channel_type merging is introduced.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/chan.c |   67 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 48 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 8d77ad13..90fef15 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -69,16 +69,14 @@ ieee80211_get_channel_mode(struct ieee80211_local *local,
 	return mode;
 }
 
-bool ieee80211_set_channel_type(struct ieee80211_local *local,
-				struct ieee80211_sub_if_data *sdata,
-				enum nl80211_channel_type chantype)
+static enum nl80211_channel_type
+ieee80211_get_superchan(struct ieee80211_local *local,
+			struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_sub_if_data *tmp;
 	enum nl80211_channel_type superchan = NL80211_CHAN_NO_HT;
-	bool result;
+	struct ieee80211_sub_if_data *tmp;
 
 	mutex_lock(&local->iflist_mtx);
-
 	list_for_each_entry(tmp, &local->interfaces, list) {
 		if (tmp == sdata)
 			continue;
@@ -104,41 +102,72 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 			break;
 		}
 	}
+	mutex_unlock(&local->iflist_mtx);
+
+	return superchan;
+}
 
-	switch (superchan) {
+static bool
+ieee80211_channel_types_are_compatible(enum nl80211_channel_type chantype1,
+				       enum nl80211_channel_type chantype2,
+				       enum nl80211_channel_type *compat)
+{
+	/*
+	 * start out with chantype1 being the result,
+	 * overwriting later if needed
+	 */
+	if (compat)
+		*compat = chantype1;
+
+	switch (chantype1) {
 	case NL80211_CHAN_NO_HT:
+		if (compat)
+			*compat = chantype2;
+		break;
 	case NL80211_CHAN_HT20:
 		/*
 		 * allow any change that doesn't go to no-HT
 		 * (if it already is no-HT no change is needed)
 		 */
-		if (chantype == NL80211_CHAN_NO_HT)
+		if (chantype2 == NL80211_CHAN_NO_HT)
 			break;
-		superchan = chantype;
+		if (compat)
+			*compat = chantype2;
 		break;
 	case NL80211_CHAN_HT40PLUS:
 	case NL80211_CHAN_HT40MINUS:
 		/* allow smaller bandwidth and same */
-		if (chantype == NL80211_CHAN_NO_HT)
+		if (chantype2 == NL80211_CHAN_NO_HT)
 			break;
-		if (chantype == NL80211_CHAN_HT20)
+		if (chantype2 == NL80211_CHAN_HT20)
 			break;
-		if (superchan == chantype)
+		if (chantype2 == chantype1)
 			break;
-		result = false;
-		goto out;
+		return false;
 	}
 
-	local->_oper_channel_type = superchan;
+	return true;
+}
+
+bool ieee80211_set_channel_type(struct ieee80211_local *local,
+				struct ieee80211_sub_if_data *sdata,
+				enum nl80211_channel_type chantype)
+{
+	enum nl80211_channel_type superchan;
+	enum nl80211_channel_type compatchan = NL80211_CHAN_NO_HT;
+
+	superchan = ieee80211_get_superchan(local, sdata);
+	if (!ieee80211_channel_types_are_compatible(superchan, chantype,
+						    &compatchan))
+		return false;
+
+	local->_oper_channel_type = compatchan;
 
 	if (sdata)
 		sdata->vif.bss_conf.channel_type = chantype;
 
-	result = true;
- out:
-	mutex_unlock(&local->iflist_mtx);
+	return true;
 
-	return result;
 }
 
 static struct ieee80211_chanctx *
-- 
1.7.10.4

