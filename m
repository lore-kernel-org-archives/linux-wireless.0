Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:7747 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749AbbGHMmC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 08:42:02 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/10] mac80211: Add support for declaring MU-MIMO capability
Date: Wed,  8 Jul 2015 15:41:43 +0300
Message-Id: <1436359312-26533-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150708_144209_658624_93D84247)
In-Reply-To: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Add support for declaring MU-MIMO beamformee capability for
relevant hardware.
When sending association request, the capability is included if both
hardware and the AP support it, and no other virtual interface
is using it.
This is in order to avoid multiple interfaces using MU-MIMO in parallel
which might lead to contradictions in the group-id mechanism.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/mlme.c        | 37 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 52930e9..90580e9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -721,6 +721,7 @@ struct ieee80211_if_mesh {
  *	back to wireless media and to the local net stack.
  * @IEEE80211_SDATA_DISCONNECT_RESUME: Disconnect after resume.
  * @IEEE80211_SDATA_IN_DRIVER: indicates interface was added to driver
+ * @IEEE80211_SDATA_MU_MIMO_OWNER: indicates interface owns MU-MIMO capability
  */
 enum ieee80211_sub_if_data_flags {
 	IEEE80211_SDATA_ALLMULTI		= BIT(0),
@@ -728,6 +729,7 @@ enum ieee80211_sub_if_data_flags {
 	IEEE80211_SDATA_DONT_BRIDGE_PACKETS	= BIT(3),
 	IEEE80211_SDATA_DISCONNECT_RESUME	= BIT(4),
 	IEEE80211_SDATA_IN_DRIVER		= BIT(5),
+	IEEE80211_SDATA_MU_MIMO_OWNER		= BIT(6),
 };
 
 /**
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6332ff7..705ef1d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6,6 +6,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright (C) 2015 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -538,11 +539,16 @@ static void ieee80211_add_ht_ie(struct ieee80211_sub_if_data *sdata,
 	ieee80211_ie_build_ht_cap(pos, &ht_cap, cap);
 }
 
+/* This function determines vht capability flags for the association
+ * and builds the IE.
+ * Note - the function may set the owner of the MU-MIMO capability
+ */
 static void ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
 				 struct sk_buff *skb,
 				 struct ieee80211_supported_band *sband,
 				 struct ieee80211_vht_cap *ap_vht_cap)
 {
+	struct ieee80211_local *local = sdata->local;
 	u8 *pos;
 	u32 cap;
 	struct ieee80211_sta_vht_cap vht_cap;
@@ -576,7 +582,34 @@ static void ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
 	 */
 	if (!(ap_vht_cap->vht_cap_info &
 			cpu_to_le32(IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE)))
-		cap &= ~IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE;
+		cap &= ~(IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
+			 IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE);
+	else if (!(ap_vht_cap->vht_cap_info &
+			cpu_to_le32(IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE)))
+		cap &= ~IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE;
+
+	/*
+	 * If some other vif is using the MU-MIMO capablity we cannot associate
+	 * using MU-MIMO - this will lead to contradictions in the group-id
+	 * mechanism.
+	 * Ownership is defined since association request, in order to avoid
+	 * simultaneous associations with MU-MIMO.
+	 */
+	if (cap & IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE) {
+		bool disable_mu_mimo = false;
+		struct ieee80211_sub_if_data *other;
+
+		list_for_each_entry_rcu(other, &local->interfaces, list) {
+			if (other->flags & IEEE80211_SDATA_MU_MIMO_OWNER) {
+				disable_mu_mimo = true;
+				break;
+			}
+		}
+		if (disable_mu_mimo)
+			cap &= ~IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE;
+		else
+			sdata->flags |= IEEE80211_SDATA_MU_MIMO_OWNER;
+	}
 
 	mask = IEEE80211_VHT_CAP_BEAMFORMEE_STS_MASK;
 
@@ -2058,6 +2091,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	memset(&ifmgd->ht_capa_mask, 0, sizeof(ifmgd->ht_capa_mask));
 	memset(&ifmgd->vht_capa, 0, sizeof(ifmgd->vht_capa));
 	memset(&ifmgd->vht_capa_mask, 0, sizeof(ifmgd->vht_capa_mask));
+	sdata->flags &= ~IEEE80211_SDATA_MU_MIMO_OWNER;
 
 	sdata->ap_power_level = IEEE80211_UNSET_POWER_LEVEL;
 
@@ -2520,6 +2554,7 @@ static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
 		eth_zero_addr(sdata->u.mgd.bssid);
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
 		sdata->u.mgd.flags = 0;
+		sdata->flags &= ~IEEE80211_SDATA_MU_MIMO_OWNER;
 		mutex_lock(&sdata->local->mtx);
 		ieee80211_vif_release_channel(sdata);
 		mutex_unlock(&sdata->local->mtx);
-- 
2.1.4

