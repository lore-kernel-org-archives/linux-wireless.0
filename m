Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:48058 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756116Ab2EJGpJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 02:45:09 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/7] mac80211: refactor ieee80211_set_channel_type
Date: Thu, 10 May 2012 08:44:38 +0200
Message-ID: <1336632282-2278-4-git-send-email-michal.kazior@tieto.com> (sfid-20120510_084528_002899_E7AB7E66)
In-Reply-To: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
References: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Splits original functionality to:
 * ieee80211_get_superchan
 * ieee80211_channel_types_are_compatible

Prepares for _oper_channel_type_removal.

Change-Id: Ic1bd50ad4fde619eb4fdbffdd33c440289071c9a
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c |   40 ++++++++++++++++++++++++++++------------
 1 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index c76cf72..3234ad1 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -64,16 +64,14 @@ ieee80211_get_channel_mode(struct ieee80211_local *local,
 	return mode;
 }
 
-bool ieee80211_set_channel_type(struct ieee80211_local *local,
-				struct ieee80211_sub_if_data *sdata,
-				enum nl80211_channel_type chantype)
+static enum nl80211_channel_type
+ieee80211_get_superchan(struct ieee80211_local *local,
+			struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_sub_if_data *tmp;
 	enum nl80211_channel_type superchan = NL80211_CHAN_NO_HT;
-	bool result;
 
 	mutex_lock(&local->iflist_mtx);
-
 	list_for_each_entry(tmp, &local->interfaces, list) {
 		if (tmp == sdata)
 			continue;
@@ -99,6 +97,16 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 			break;
 		}
 	}
+	mutex_unlock(&local->iflist_mtx);
+
+	return superchan;
+}
+
+static bool ieee80211_channel_types_are_compatible(
+		enum nl80211_channel_type superchan,
+		enum nl80211_channel_type chantype)
+{
+	bool result = true;
 
 	switch (superchan) {
 	case NL80211_CHAN_NO_HT:
@@ -121,17 +129,25 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 		if (superchan == chantype)
 			break;
 		result = false;
-		goto out;
+		break;
 	}
 
-	local->_oper_channel_type = superchan;
+	return result;
+}
+
+bool ieee80211_set_channel_type(struct ieee80211_local *local,
+				struct ieee80211_sub_if_data *sdata,
+				enum nl80211_channel_type chantype)
+{
+	enum nl80211_channel_type superchan;
 
+	superchan = ieee80211_get_superchan(local, sdata);
+	if (!ieee80211_channel_types_are_compatible(superchan, chantype))
+		return false;
+
+	local->_oper_channel_type = superchan;
 	if (sdata)
 		sdata->vif.bss_conf.channel_type = chantype;
 
-	result = true;
- out:
-	mutex_unlock(&local->iflist_mtx);
-
-	return result;
+	return true;
 }
-- 
1.7.0.4

