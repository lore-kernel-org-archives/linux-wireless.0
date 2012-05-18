Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:43986 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030220Ab2ERMDW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 08:03:22 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 5/6] mac80211: refactor set_channel_type
Date: Fri, 18 May 2012 14:03:08 +0200
Message-ID: <1337342589-10617-6-git-send-email-michal.kazior@tieto.com> (sfid-20120518_140330_940453_2438FA90)
In-Reply-To: <1337342589-10617-1-git-send-email-michal.kazior@tieto.com>
References: <1337342589-10617-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split functionality for further reuse.

Will prevent code duplication when channel context
channel_type merging is introduced.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c |   57 ++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 32b7088..030d44e 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -65,16 +65,14 @@ ieee80211_get_channel_mode(struct ieee80211_local *local,
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
@@ -100,41 +98,62 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
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
+	switch (chantype1) {
 	case NL80211_CHAN_NO_HT:
 	case NL80211_CHAN_HT20:
 		/*
 		 * allow any change that doesn't go to no-HT
 		 * (if it already is no-HT no change is needed)
 		 */
-		if (chantype == NL80211_CHAN_NO_HT)
+		if (chantype2 == NL80211_CHAN_NO_HT)
 			break;
-		superchan = chantype;
+		*compat = chantype2;
 		break;
 	case NL80211_CHAN_HT40PLUS:
 	case NL80211_CHAN_HT40MINUS:
+		*compat = chantype1;
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
 
 static struct ieee80211_channel_context *
-- 
1.7.0.4

