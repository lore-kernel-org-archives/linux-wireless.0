Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23006 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964890AbbLHOGZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 09:06:25 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/9] mac80211: process and save VHT MU-MIMO group frame
Date: Tue,  8 Dec 2015 16:04:31 +0200
Message-Id: <1449583479-26658-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151208_150634_958499_1FE3735E)
In-Reply-To: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The Group ID Management frame is an Action frame of
category VHT. It is transmitted by the AP to assign
or change the user position of a STA for one or more
group IDs.
Process and save the group membership data. Notify
underlying driver of changes.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/linux/ieee80211.h  |  7 +++++++
 include/net/mac80211.h     | 17 +++++++++++++++++
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/iface.c       | 10 ++++++++++
 net/mac80211/mlme.c        |  7 +++++++
 net/mac80211/rx.c          |  5 +++++
 net/mac80211/util.c        |  3 +++
 net/mac80211/vht.c         | 25 +++++++++++++++++++++++++
 8 files changed, 76 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 452c0b0..d9ddb89 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -843,6 +843,8 @@ enum ieee80211_vht_opmode_bits {
 };
 
 #define WLAN_SA_QUERY_TR_ID_LEN 2
+#define WLAN_MEMBERSHIP_LEN 8
+#define WLAN_USER_POSITION_LEN 16
 
 /**
  * struct ieee80211_tpc_report_ie
@@ -991,6 +993,11 @@ struct ieee80211_mgmt {
 				} __packed vht_opmode_notif;
 				struct {
 					u8 action_code;
+					u8 membership[WLAN_MEMBERSHIP_LEN];
+					u8 position[WLAN_USER_POSITION_LEN];
+				} __packed vht_group_notif;
+				struct {
+					u8 action_code;
 					u8 dialog_token;
 					u8 tpc_elem_id;
 					u8 tpc_elem_length;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7c30faf..8da483b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -298,6 +298,7 @@ struct ieee80211_vif_chanctx_switch {
  *	note that this is only called when it changes after the channel
  *	context had been assigned.
  * @BSS_CHANGED_OCB: OCB join status changed
+ * @BSS_CHANGED_MU_GROUPS: VHT MU-MIMO group id or user position changed
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -323,6 +324,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_BEACON_INFO		= 1<<20,
 	BSS_CHANGED_BANDWIDTH		= 1<<21,
 	BSS_CHANGED_OCB                 = 1<<22,
+	BSS_CHANGED_MU_GROUPS		= 1<<23,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
@@ -436,6 +438,19 @@ struct ieee80211_event {
 };
 
 /**
+ * struct ieee80211_mu_group_data - STA's VHT MU-MIMO group data
+ *
+ * This structure describes the group id data of VHT MU-MIMO
+ *
+ * @membership: 64 bits array - a bit is set if station is member of the group
+ * @position: 2 bits per group id indicating the position in the group
+ */
+struct ieee80211_mu_group_data {
+	u8 membership[WLAN_MEMBERSHIP_LEN];
+	u8 position[WLAN_USER_POSITION_LEN];
+};
+
+/**
  * struct ieee80211_bss_conf - holds the BSS's changing parameters
  *
  * This structure keeps information about a BSS (and an association
@@ -477,6 +492,7 @@ struct ieee80211_event {
  * @enable_beacon: whether beaconing should be enabled or not
  * @chandef: Channel definition for this BSS -- the hardware might be
  *	configured a higher bandwidth than this BSS uses, for example.
+ * @mu_group: VHT MU-MIMO group membership data
  * @ht_operation_mode: HT operation mode like in &struct ieee80211_ht_operation.
  *	This field is only valid when the channel is a wide HT/VHT channel.
  *	Note that with TDLS this can be the case (channel is HT, protection must
@@ -535,6 +551,7 @@ struct ieee80211_bss_conf {
 	s32 cqm_rssi_thold;
 	u32 cqm_rssi_hyst;
 	struct cfg80211_chan_def chandef;
+	struct ieee80211_mu_group_data mu_group;
 	__be32 arp_addr_list[IEEE80211_BSS_ARP_ADDR_LIST_LEN];
 	int arp_addr_cnt;
 	bool qos;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c30b684..582ea86 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1714,6 +1714,8 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 enum ieee80211_sta_rx_bandwidth ieee80211_sta_cap_rx_bw(struct sta_info *sta);
 enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta);
 void ieee80211_sta_set_rx_nss(struct sta_info *sta);
+void ieee80211_process_mu_groups(struct ieee80211_sub_if_data *sdata,
+				 struct ieee80211_mgmt *mgmt);
 u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
                                   struct sta_info *sta, u8 opmode,
                                   enum ieee80211_band band, bool nss_only);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index c9e325d..33ae3c8 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1271,6 +1271,16 @@ static void ieee80211_iface_work(struct work_struct *work)
 				}
 			}
 			mutex_unlock(&local->sta_mtx);
+		} else if (ieee80211_is_action(mgmt->frame_control) &&
+			   mgmt->u.action.category == WLAN_CATEGORY_VHT) {
+			switch (mgmt->u.action.u.vht_group_notif.action_code) {
+			case WLAN_VHT_ACTION_GROUPID_MGMT:
+				ieee80211_process_mu_groups(sdata, mgmt);
+				break;
+			default:
+				WARN_ON(1);
+				break;
+			}
 		} else if (ieee80211_is_data_qos(mgmt->frame_control)) {
 			struct ieee80211_hdr *hdr = (void *)mgmt;
 			/*
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 123b26d..1e6b337 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2074,6 +2074,13 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	memset(&ifmgd->ht_capa_mask, 0, sizeof(ifmgd->ht_capa_mask));
 	memset(&ifmgd->vht_capa, 0, sizeof(ifmgd->vht_capa));
 	memset(&ifmgd->vht_capa_mask, 0, sizeof(ifmgd->vht_capa_mask));
+
+	/* reset MU-MIMO ownership and group data */
+	memset(sdata->vif.bss_conf.mu_group.membership, 0,
+	       sizeof(sdata->vif.bss_conf.mu_group.membership));
+	memset(sdata->vif.bss_conf.mu_group.position, 0,
+	       sizeof(sdata->vif.bss_conf.mu_group.position));
+	changed |= BSS_CHANGED_MU_GROUPS;
 	sdata->flags &= ~IEEE80211_SDATA_MU_MIMO_OWNER;
 
 	sdata->ap_power_level = IEEE80211_UNSET_POWER_LEVEL;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1f82753..c4198d48 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2739,6 +2739,11 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 						    false);
 			goto handled;
 		}
+		case WLAN_VHT_ACTION_GROUPID_MGMT: {
+			if (len < IEEE80211_MIN_ACTION_SIZE + 25)
+				goto invalid;
+			goto queue;
+		}
 		default:
 			break;
 		}
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 08af2b3..4d6130b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1905,6 +1905,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			  BSS_CHANGED_IDLE |
 			  BSS_CHANGED_TXPOWER;
 
+		if (sdata->flags & IEEE80211_SDATA_MU_MIMO_OWNER)
+			changed |= BSS_CHANGED_MU_GROUPS;
+
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_STATION:
 			changed |= BSS_CHANGED_ASSOC |
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index ff1c798..92c9843 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -1,6 +1,9 @@
 /*
  * VHT handling
  *
+ * Portions of this file
+ * Copyright(c) 2015 Intel Deutschland GmbH
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -428,6 +431,28 @@ u32 __ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 	return changed;
 }
 
+void ieee80211_process_mu_groups(struct ieee80211_sub_if_data *sdata,
+				 struct ieee80211_mgmt *mgmt)
+{
+	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
+
+	if (!(sdata->flags & IEEE80211_SDATA_MU_MIMO_OWNER))
+		return;
+
+	if (!memcmp(mgmt->u.action.u.vht_group_notif.position,
+		    bss_conf->mu_group.position, WLAN_USER_POSITION_LEN) &&
+	    !memcmp(mgmt->u.action.u.vht_group_notif.membership,
+		    bss_conf->mu_group.membership, WLAN_MEMBERSHIP_LEN))
+		return;
+
+	memcpy(mgmt->u.action.u.vht_group_notif.membership,
+	       bss_conf->mu_group.membership, WLAN_MEMBERSHIP_LEN);
+	memcpy(mgmt->u.action.u.vht_group_notif.position,
+	       bss_conf->mu_group.position, WLAN_USER_POSITION_LEN);
+
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_MU_GROUPS);
+}
+
 void ieee80211_vht_handle_opmode(struct ieee80211_sub_if_data *sdata,
 				 struct sta_info *sta, u8 opmode,
 				 enum ieee80211_band band, bool nss_only)
-- 
2.5.0

