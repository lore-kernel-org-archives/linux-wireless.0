Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:63433 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbcBPKs0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 05:48:26 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/2] mac80211: move MU_MIMO_OWNER flag to ieee80211_vif
Date: Tue, 16 Feb 2016 12:48:18 +0200
Message-Id: <1455619698-9768-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160216_114851_967228_B5E8ECEE)
In-Reply-To: <1455619698-9768-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1455619698-9768-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Drivers may need to track which vif is using VHT MU-MIMO.
Move the flag indicationg the ownership of MU_MIMO to
ieee80211_vif.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h     |  2 ++
 net/mac80211/ieee80211_i.h |  2 --
 net/mac80211/mlme.c        | 11 ++++++-----
 net/mac80211/util.c        |  2 +-
 net/mac80211/vht.c         |  7 +++----
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6ca23e3..9cf92d0 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1385,6 +1385,7 @@ enum ieee80211_vif_flags {
  * @csa_active: marks whether a channel switch is going on. Internally it is
  *	write-protected by sdata_lock and local->mtx so holding either is fine
  *	for read access.
+ * @mu_mimo_owner: indicates interface owns MU-MIMO capability
  * @driver_flags: flags/capabilities the driver has for this interface,
  *	these need to be set (or cleared) when the interface is added
  *	or, if supported by the driver, the interface type is changed
@@ -1411,6 +1412,7 @@ struct ieee80211_vif {
 	u8 addr[ETH_ALEN];
 	bool p2p;
 	bool csa_active;
+	bool mu_mimo_owner;
 
 	u8 cab_queue;
 	u8 hw_queue[IEEE80211_NUM_ACS];
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a49c103..1630975 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -716,7 +716,6 @@ struct ieee80211_if_mesh {
  *	back to wireless media and to the local net stack.
  * @IEEE80211_SDATA_DISCONNECT_RESUME: Disconnect after resume.
  * @IEEE80211_SDATA_IN_DRIVER: indicates interface was added to driver
- * @IEEE80211_SDATA_MU_MIMO_OWNER: indicates interface owns MU-MIMO capability
  */
 enum ieee80211_sub_if_data_flags {
 	IEEE80211_SDATA_ALLMULTI		= BIT(0),
@@ -724,7 +723,6 @@ enum ieee80211_sub_if_data_flags {
 	IEEE80211_SDATA_DONT_BRIDGE_PACKETS	= BIT(3),
 	IEEE80211_SDATA_DISCONNECT_RESUME	= BIT(4),
 	IEEE80211_SDATA_IN_DRIVER		= BIT(5),
-	IEEE80211_SDATA_MU_MIMO_OWNER		= BIT(6),
 };
 
 /**
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 857089d..f41625b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6,7 +6,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright (C) 2015 Intel Deutschland GmbH
+ * Copyright (C) 2015 - 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -559,7 +559,7 @@ static void ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
 		struct ieee80211_sub_if_data *other;
 
 		list_for_each_entry_rcu(other, &local->interfaces, list) {
-			if (other->flags & IEEE80211_SDATA_MU_MIMO_OWNER) {
+			if (other->vif.mu_mimo_owner) {
 				disable_mu_mimo = true;
 				break;
 			}
@@ -567,7 +567,7 @@ static void ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
 		if (disable_mu_mimo)
 			cap &= ~IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE;
 		else
-			sdata->flags |= IEEE80211_SDATA_MU_MIMO_OWNER;
+			sdata->vif.mu_mimo_owner = true;
 	}
 
 	mask = IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
@@ -2052,7 +2052,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	memset(sdata->vif.bss_conf.mu_group.position, 0,
 	       sizeof(sdata->vif.bss_conf.mu_group.position));
 	changed |= BSS_CHANGED_MU_GROUPS;
-	sdata->flags &= ~IEEE80211_SDATA_MU_MIMO_OWNER;
+	sdata->vif.mu_mimo_owner = false;
 
 	sdata->ap_power_level = IEEE80211_UNSET_POWER_LEVEL;
 
@@ -2509,7 +2509,8 @@ static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
 		eth_zero_addr(sdata->u.mgd.bssid);
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
 		sdata->u.mgd.flags = 0;
-		sdata->flags &= ~IEEE80211_SDATA_MU_MIMO_OWNER;
+		sdata->vif.mu_mimo_owner = false;
+
 		mutex_lock(&sdata->local->mtx);
 		ieee80211_vif_release_channel(sdata);
 		mutex_unlock(&sdata->local->mtx);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 52766f7..743265a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1928,7 +1928,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			  BSS_CHANGED_IDLE |
 			  BSS_CHANGED_TXPOWER;
 
-		if (sdata->flags & IEEE80211_SDATA_MU_MIMO_OWNER)
+		if (sdata->vif.mu_mimo_owner)
 			changed |= BSS_CHANGED_MU_GROUPS;
 
 		switch (sdata->vif.type) {
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index f8f1611..89e04d5 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -450,7 +450,7 @@ void ieee80211_process_mu_groups(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 
-	if (!(sdata->flags & IEEE80211_SDATA_MU_MIMO_OWNER))
+	if (!sdata->vif.mu_mimo_owner)
 		return;
 
 	if (!memcmp(mgmt->u.action.u.vht_group_notif.position,
@@ -472,10 +472,9 @@ void ieee80211_process_mu_groups(struct ieee80211_sub_if_data *sdata,
 void ieee80211_update_mu_groups(struct ieee80211_vif *vif,
 				const u8 *membership, const u8 *position)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 
-	if (WARN_ON_ONCE(!(sdata->flags & IEEE80211_SDATA_MU_MIMO_OWNER)))
+	if (WARN_ON_ONCE(!vif->mu_mimo_owner))
 		return;
 
 	memcpy(bss_conf->mu_group.membership, membership, WLAN_MEMBERSHIP_LEN);
-- 
2.5.0

