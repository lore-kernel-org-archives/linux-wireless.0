Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54331 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab2KWXb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 18:31:57 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Felix.Liao@watchguard.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.7] mac80211: fix remain-on-channel (non-)cancelling
Date: Sat, 24 Nov 2012 00:32:19 +0100
Message-Id: <1353713539-8094-1-git-send-email-johannes@sipsolutions.net> (sfid-20121124_003200_783757_97E6C453)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Felix Liao reported that when an interface is set DOWN
while another interface is executing a ROC, the warning
in ieee80211_start_next_roc() (about the first item on
the list having started already) triggers.

This is because ieee80211_roc_purge() calls it even if
it never actually changed the list of ROC items. To fix
this, simply remove the function call. If it is needed
then it will be done by the ieee80211_sw_roc_work()
function when the ROC item that is being removed while
active is cleaned up.

Cc: stable@vger.kernel.org
Reported-by: Felix Liao <Felix.Liao@watchguard.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/offchannel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 83608ac..2c84185 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -458,8 +458,6 @@ void ieee80211_roc_purge(struct ieee80211_sub_if_data *sdata)
 		list_move_tail(&roc->list, &tmp_list);
 		roc->abort = true;
 	}
-
-	ieee80211_start_next_roc(local);
 	mutex_unlock(&local->mtx);
 
 	list_for_each_entry_safe(roc, tmp, &tmp_list, list) {
-- 
1.8.0

