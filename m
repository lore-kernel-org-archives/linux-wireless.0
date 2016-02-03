Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44240 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbcBCTw1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 14:52:27 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: fix VHT MU-MIMO frame processing
Date: Wed,  3 Feb 2016 21:52:23 +0200
Message-Id: <1454529143-9299-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160203_205231_194829_031A29BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The source and destintation addresses in the memcpy arguments
are flipped. Fix that.

Fixes: 23a1f8d44c0b("mac80211: process and save VHT MU-MIMO group frame")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/vht.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 204cf9a..341d192 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -459,10 +459,12 @@ void ieee80211_process_mu_groups(struct ieee80211_sub_if_data *sdata,
 		    bss_conf->mu_group.membership, WLAN_MEMBERSHIP_LEN))
 		return;
 
-	memcpy(mgmt->u.action.u.vht_group_notif.membership,
-	       bss_conf->mu_group.membership, WLAN_MEMBERSHIP_LEN);
-	memcpy(mgmt->u.action.u.vht_group_notif.position,
-	       bss_conf->mu_group.position, WLAN_USER_POSITION_LEN);
+	memcpy(bss_conf->mu_group.membership,
+	       mgmt->u.action.u.vht_group_notif.membership,
+	       WLAN_MEMBERSHIP_LEN);
+	memcpy(bss_conf->mu_group.position,
+	       mgmt->u.action.u.vht_group_notif.position,
+	       WLAN_USER_POSITION_LEN);
 
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_MU_GROUPS);
 }
-- 
2.5.0

