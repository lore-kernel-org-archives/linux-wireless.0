Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:29875 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbaLPOPw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2014 09:15:52 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: notify channel switch at the end of ieee80211_chswitch_post_beacon()
Date: Tue, 16 Dec 2014 16:01:39 +0200
Message-Id: <1418738499-4488-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141216_151558_539651_10F9C387)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The call to cfg80211_ch_switch_notify() should be at the end of the
ieee80211_chswitch_post_beacon() function, because it should only be
sent if everything succeeded.

Fixes: d04b5ac9e70b ("cfg80211/mac80211: allow any interface to send channel switch notifications")
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/mlme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 75a9bf5..0c6848e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1053,8 +1053,6 @@ static void ieee80211_chswitch_post_beacon(struct ieee80211_sub_if_data *sdata)
 		sdata->csa_block_tx = false;
 	}
 
-	cfg80211_ch_switch_notify(sdata->dev, &sdata->reserved_chandef);
-
 	sdata->vif.csa_active = false;
 	ifmgd->csa_waiting_bcn = false;
 
@@ -1066,6 +1064,8 @@ static void ieee80211_chswitch_post_beacon(struct ieee80211_sub_if_data *sdata)
 				     &ifmgd->csa_connection_drop_work);
 		return;
 	}
+
+	cfg80211_ch_switch_notify(sdata->dev, &sdata->reserved_chandef);
 }
 
 void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success)
-- 
1.9.1

