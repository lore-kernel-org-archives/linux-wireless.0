Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:48058 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab2EJGpK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 02:45:10 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/7] mac80211: introduce ieee80211_oper_channel_type
Date: Thu, 10 May 2012 08:44:39 +0200
Message-ID: <1336632282-2278-5-git-send-email-michal.kazior@tieto.com> (sfid-20120510_084518_555193_41F9F567)
In-Reply-To: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
References: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prepares for _oper_channel_type removal.

Change-Id: I161842005dd195ad0935b6f4ba14740724ab9846
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/chan.c        |   14 +++++++++++---
 net/mac80211/ieee80211_i.h |    3 +++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 3234ad1..8513f70 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -66,14 +66,15 @@ ieee80211_get_channel_mode(struct ieee80211_local *local,
 
 static enum nl80211_channel_type
 ieee80211_get_superchan(struct ieee80211_local *local,
-			struct ieee80211_sub_if_data *sdata)
+			struct ieee80211_sub_if_data *sdata,
+			bool ignore_self)
 {
 	struct ieee80211_sub_if_data *tmp;
 	enum nl80211_channel_type superchan = NL80211_CHAN_NO_HT;
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(tmp, &local->interfaces, list) {
-		if (tmp == sdata)
+		if (ignore_self && tmp == sdata)
 			continue;
 
 		if (!ieee80211_sdata_running(tmp))
@@ -135,13 +136,20 @@ static bool ieee80211_channel_types_are_compatible(
 	return result;
 }
 
+enum nl80211_channel_type
+ieee80211_oper_channel_type(struct ieee80211_local *local,
+			    struct ieee80211_sub_if_data *sdata)
+{
+	return ieee80211_get_superchan(local, sdata, 0);
+}
+
 bool ieee80211_set_channel_type(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata,
 				enum nl80211_channel_type chantype)
 {
 	enum nl80211_channel_type superchan;
 
-	superchan = ieee80211_get_superchan(local, sdata);
+	superchan = ieee80211_get_superchan(local, sdata, 1);
 	if (!ieee80211_channel_types_are_compatible(superchan, chantype))
 		return false;
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 122717f..e40cd06 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1527,6 +1527,9 @@ enum ieee80211_chan_mode {
 enum ieee80211_chan_mode
 ieee80211_get_channel_mode(struct ieee80211_local *local,
 			   struct ieee80211_sub_if_data *ignore);
+enum nl80211_channel_type
+ieee80211_oper_channel_type(struct ieee80211_local *local,
+			    struct ieee80211_sub_if_data *sdata);
 bool ieee80211_set_channel_type(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata,
 				enum nl80211_channel_type chantype);
-- 
1.7.0.4

