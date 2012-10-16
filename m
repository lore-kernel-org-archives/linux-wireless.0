Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41924 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab2JPHRi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 03:17:38 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: unbind the vif from the channel context in suspend
Date: Tue, 16 Oct 2012 09:18:10 +0200
Message-Id: <1350371890-11488-1-git-send-email-johannes@sipsolutions.net> (sfid-20121016_091741_257784_F88E1821)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The channel was still bound to the channel context when it
was removed. Fix that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/pm.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 5c572e7..9f404ac 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -135,6 +135,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		ieee80211_bss_info_change_notify(sdata,
 			BSS_CHANGED_BEACON_ENABLED);
 
+		/* the interface is leaving the channel and is removed */
+		ieee80211_vif_release_channel(sdata);
 		drv_remove_interface(local, sdata);
 	}
 
-- 
1.7.10.4

