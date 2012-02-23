Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:25681 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab2BWBSZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 20:18:25 -0500
From: Jakub Kicinski <kubakici@wp.pl>
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH] mac80211: use proper sub_if_data on suspend path
Date: Thu, 23 Feb 2012 02:17:48 +0100
Message-Id: <1329959868-10989-1-git-send-email-kubakici@wp.pl> (sfid-20120223_021829_074192_F10A5DC7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use interface data from sta instead of invalid pointer
to list head in calls to drv_sta_state.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
 net/mac80211/pm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 2b53a53..ef8eba1 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -102,7 +102,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 			state = sta->sta_state;
 			for (; state > IEEE80211_STA_NOTEXIST; state--)
-				WARN_ON(drv_sta_state(local, sdata, sta,
+				WARN_ON(drv_sta_state(local, sta->sdata, sta,
 						      state, state - 1));
 		}
 
-- 
1.7.7.6

