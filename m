Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30993 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbcCBV2o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 16:28:44 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/3] mac80211: TDLS: always downgrade invalid chandefs
Date: Wed,  2 Mar 2016 23:28:31 +0200
Message-Id: <1456954113-4682-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_222847_707935_10C7D14A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Even if the current chandef width is equal to the station's max-BW, it
doesn't mean it's a valid width for TDLS. Make sure to always check
regulatory constraints in these cases.

Fixes: dde4002 ("mac80211: upgrade BW of TDLS peers when possible")
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/tdls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index c9eeb3f..43f13abe 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -332,7 +332,7 @@ ieee80211_tdls_chandef_vht_upgrade(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	/* proceed to downgrade the chandef until usable or the same */
-	while (uc.width > max_width &&
+	while (uc.width > max_width ||
 	       !cfg80211_reg_can_beacon_relax(sdata->local->hw.wiphy, &uc,
 					      sdata->wdev.iftype))
 		ieee80211_chandef_downgrade(&uc);
-- 
2.5.0

