Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46737 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbbFQIlT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:41:19 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 03/14] mac80211: remove sta_info.gtk_idx
Date: Wed, 17 Jun 2015 10:41:04 +0200
Message-Id: <1434530475-3553-4-git-send-email-johannes@sipsolutions.net> (sfid-20150617_104131_273312_FF174ED8)
In-Reply-To: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
References: <1434530475-3553-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This struct member is only assigned, never used otherwise;
remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c      | 1 -
 net/mac80211/sta_info.h | 2 --
 2 files changed, 3 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 8abc31ebcf61..bde049e128db 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -329,7 +329,6 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 			ieee80211_check_fast_xmit(sta);
 		} else {
 			rcu_assign_pointer(sta->gtk[idx], new);
-			sta->gtk_idx = idx;
 		}
 	} else {
 		defunikey = old &&
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 226f8ca47ad6..147464dbc455 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -283,7 +283,6 @@ struct ieee80211_fast_tx {
  * @ptk: peer keys negotiated with this station, if any
  * @ptk_idx: last installed peer key index
  * @gtk: group keys negotiated with this station, if any
- * @gtk_idx: last installed group key index
  * @rate_ctrl: rate control algorithm reference
  * @rate_ctrl_lock: spinlock used to protect rate control data
  *	(data inside the algorithm, so serializes calls there)
@@ -381,7 +380,6 @@ struct sta_info {
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_key __rcu *gtk[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
 	struct ieee80211_key __rcu *ptk[NUM_DEFAULT_KEYS];
-	u8 gtk_idx;
 	u8 ptk_idx;
 	struct rate_control_ref *rate_ctrl;
 	void *rate_ctrl_priv;
-- 
2.1.4

