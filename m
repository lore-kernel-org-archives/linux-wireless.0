Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:63433 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbcBPKsY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 05:48:24 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/2] mac80211: provide interface to driver to set VHT MU-MIMO data
Date: Tue, 16 Feb 2016 12:48:17 +0200
Message-Id: <1455619698-9768-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160216_114851_431653_8866DF4B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Provide an interface to the lower level driver to set the VHT
MU-MIMO data. This is needed for example when there is an update
of the group data during low power state, where the management
frame will not be passed to the host at all.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h | 15 +++++++++++++++
 net/mac80211/vht.c     | 16 +++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6aad965..6ca23e3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5448,6 +5448,21 @@ ieee80211_vif_type_p2p(struct ieee80211_vif *vif)
 	return ieee80211_iftype_p2p(vif->type, vif->p2p);
 }
 
+/**
+ * ieee80211_update_mu_groups - set the VHT MU-MIMO groud data
+ *
+ * @vif: the specified virtual interface
+ * @membership: 64 bits array - a bit is set if station is member of the group
+ * @position: 2 bits per group id indicating the position in the group
+ *
+ * Note: This function assumes that the given vif is valid and the position and
+ * membership data is of the correct size and are in the same byte order as the
+ * matching GroupId management frame.
+ * Calls to this function need to be serialized with RX path.
+ */
+void ieee80211_update_mu_groups(struct ieee80211_vif *vif,
+				const u8 *membership, const u8 *position);
+
 void ieee80211_enable_rssi_reports(struct ieee80211_vif *vif,
 				   int rssi_min_thold,
 				   int rssi_max_thold);
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 341d192..f8f1611 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -2,7 +2,7 @@
  * VHT handling
  *
  * Portions of this file
- * Copyright(c) 2015 Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -469,6 +469,20 @@ void ieee80211_process_mu_groups(struct ieee80211_sub_if_data *sdata,
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_MU_GROUPS);
 }
 
+void ieee80211_update_mu_groups(struct ieee80211_vif *vif,
+				const u8 *membership, const u8 *position)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
+
+	if (WARN_ON_ONCE(!(sdata->flags & IEEE80211_SDATA_MU_MIMO_OWNER)))
+		return;
+
+	memcpy(bss_conf->mu_group.membership, membership, WLAN_MEMBERSHIP_LEN);
+	memcpy(bss_conf->mu_group.position, position, WLAN_USER_POSITION_LEN);
+}
+EXPORT_SYMBOL_GPL(ieee80211_update_mu_groups);
+
 void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 				 struct sta_info *sta, u8 opmode,
 				 enum ieee80211_band band)
-- 
2.5.0

