Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:54258 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524Ab2FZMha (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 08:37:30 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Kazior Michal <Michal.Kazior@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC v3 6/7] mac80211: refactor set_channel_type
Date: Tue, 26 Jun 2012 14:37:21 +0200
Message-ID: <1340714242-20032-7-git-send-email-michal.kazior@tieto.com> (sfid-20120626_143734_731336_AFABBE17)
In-Reply-To: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kazior Michal <Michal.Kazior@tieto.com>

Split functionality for further reuse.

Will prevent code duplication when channel context
channel_type merging is introduced.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c |   57 ++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 1aa553d..fe1ea01 100644
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
@@ -104,41 +102,62 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
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
 
 static struct ieee80211_chanctx *
-- 
1.7.0.4

