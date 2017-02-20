Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50104 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753272AbdBTNYn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 08:24:43 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/6] mac80211: fix power saving clients handling in iwlwifi
Date: Mon, 20 Feb 2017 14:24:36 +0100
Message-Id: <20170220132439.16064-3-johannes@sipsolutions.net> (sfid-20170220_142500_197899_B5FD3F0D)
In-Reply-To: <20170220132439.16064-1-johannes@sipsolutions.net>
References: <20170220132439.16064-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

iwlwifi now supports RSS and can't let mac80211 track the
PS state based on the Rx frames since they can come out of
order. iwlwifi is now advertising AP_LINK_PS, and uses
explicit notifications to teach mac80211 about the PS state
of the stations and the PS poll / uAPSD trigger frames
coming our way from the peers.

Because of that, the TIM stopped being maintained in
mac80211. I tried to fix this in commit c68df2e7be0c
("mac80211: allow using AP_LINK_PS with mac80211-generated TIM IE")
but that was later reverted by Felix in commit 6c18a6b4e799
("Revert "mac80211: allow using AP_LINK_PS with mac80211-generated TIM IE")
since it broke drivers that do not implement set_tim.

Since none of the drivers that set AP_LINK_PS have the
set_tim() handler set besides iwlwifi, I can bail out in
__sta_info_recalc_tim if AP_LINK_PS AND .set_tim is not
implemented.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 4774e663a411..8bb99d299cda 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -688,7 +688,7 @@ static void __sta_info_recalc_tim(struct sta_info *sta, bool ignore_pending)
 	}
 
 	/* No need to do anything if the driver does all */
-	if (ieee80211_hw_check(&local->hw, AP_LINK_PS))
+	if (ieee80211_hw_check(&local->hw, AP_LINK_PS) && !local->ops->set_tim)
 		return;
 
 	if (sta->dead)
-- 
2.9.3
