Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29662 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbbHOTk0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2015 15:40:26 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/9] mac80211: TDLS: check reg with IR-relax on chandef upgrade
Date: Sat, 15 Aug 2015 22:39:48 +0300
Message-Id: <1439667594-13632-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150815_214030_168718_599945FA)
In-Reply-To: <1439667594-13632-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1439667594-13632-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

When checking if a TDLS chandef can be upgraded, IR-relaxation can be
taken into account to allow more channels.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/tdls.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index b45cf99..8d656d3 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -333,8 +333,8 @@ ieee80211_tdls_chandef_vht_upgrade(struct ieee80211_sub_if_data *sdata,
 
 	/* proceed to downgrade the chandef until usable or the same */
 	while (uc.width > max_width &&
-	       !cfg80211_reg_can_beacon(sdata->local->hw.wiphy,
-					&uc, sdata->wdev.iftype))
+	       !cfg80211_reg_can_beacon_relax(sdata->local->hw.wiphy, &uc,
+					      sdata->wdev.iftype))
 		ieee80211_chandef_downgrade(&uc);
 
 	if (!cfg80211_chandef_identical(&uc, &sta->tdls_chandef)) {
-- 
2.1.4

