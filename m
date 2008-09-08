Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54514 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbYIHPqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 11:46:05 -0400
Message-Id: <20080908154443.899627000@sipsolutions.net> (sfid-20080908_174626_797473_E3058CA9)
References: <20080908154421.216772000@sipsolutions.net>
Date: Mon, 08 Sep 2008 17:44:28 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 7/8] mac80211: move some HT code out of mlme.c
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of the HT code in mlme.c is misplaced:
 * constants/definitions belong to the ieee80211.h header
 * code being used in other modes as well shouldn't be there

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/ieee80211.h |   18 ++
 net/mac80211/Makefile     |    1 
 net/mac80211/ht.c         |  328 ++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/mlme.c       |  321 ---------------------------------------------
 4 files changed, 347 insertions(+), 321 deletions(-)

--- everything.orig/include/linux/ieee80211.h	2008-09-08 16:05:28.000000000 +0200
+++ everything/include/linux/ieee80211.h	2008-09-08 16:05:29.000000000 +0200
@@ -643,6 +643,9 @@ struct ieee80211_mgmt {
 	} u;
 } __attribute__ ((packed));
 
+/* mgmt header + 1 byte category code */
+#define IEEE80211_MIN_ACTION_SIZE offsetof(struct ieee80211_mgmt, u.action.u)
+
 
 /* Control frames */
 struct ieee80211_rts {
@@ -737,6 +740,21 @@ struct ieee80211_ht_addt_info {
 #define IEEE80211_HT_IE_NON_GF_STA_PRSNT	0x0004
 #define IEEE80211_HT_IE_NON_HT_STA_PRSNT	0x0010
 
+/* block-ack parameters */
+#define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
+#define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
+#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFA0
+#define IEEE80211_DELBA_PARAM_TID_MASK 0xF000
+#define IEEE80211_DELBA_PARAM_INITIATOR_MASK 0x0800
+
+/*
+ * A-PMDU buffer sizes
+ * According to IEEE802.11n spec size varies from 8K to 64K (in powers of 2)
+ */
+#define IEEE80211_MIN_AMPDU_BUF 0x8
+#define IEEE80211_MAX_AMPDU_BUF 0x40
+
+
 /* Spatial Multiplexing Power Save Modes */
 #define WLAN_HT_CAP_SM_PS_STATIC	0
 #define WLAN_HT_CAP_SM_PS_DYNAMIC	1
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ everything/net/mac80211/ht.c	2008-09-08 16:10:05.000000000 +0200
@@ -0,0 +1,328 @@
+/*
+ * HT handling
+ *
+ * Copyright 2003, Jouni Malinen <jkmaline@cc.hut.fi>
+ * Copyright 2004, Instant802 Networks, Inc.
+ * Copyright 2005, Devicescape Software, Inc.
+ * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
+ * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
+ * Copyright 2007-2008, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/ieee80211.h>
+#include <net/wireless.h>
+#include <net/mac80211.h>
+#include "ieee80211_i.h"
+#include "sta_info.h"
+
+int ieee80211_ht_cap_ie_to_ht_info(struct ieee80211_ht_cap *ht_cap_ie,
+				   struct ieee80211_ht_info *ht_info)
+{
+
+	if (ht_info == NULL)
+		return -EINVAL;
+
+	memset(ht_info, 0, sizeof(*ht_info));
+
+	if (ht_cap_ie) {
+		u8 ampdu_info = ht_cap_ie->ampdu_params_info;
+
+		ht_info->ht_supported = 1;
+		ht_info->cap = le16_to_cpu(ht_cap_ie->cap_info);
+		ht_info->ampdu_factor =
+			ampdu_info & IEEE80211_HT_CAP_AMPDU_FACTOR;
+		ht_info->ampdu_density =
+			(ampdu_info & IEEE80211_HT_CAP_AMPDU_DENSITY) >> 2;
+		memcpy(ht_info->supp_mcs_set, ht_cap_ie->supp_mcs_set, 16);
+	} else
+		ht_info->ht_supported = 0;
+
+	return 0;
+}
+
+int ieee80211_ht_addt_info_ie_to_ht_bss_info(
+			struct ieee80211_ht_addt_info *ht_add_info_ie,
+			struct ieee80211_ht_bss_info *bss_info)
+{
+	if (bss_info == NULL)
+		return -EINVAL;
+
+	memset(bss_info, 0, sizeof(*bss_info));
+
+	if (ht_add_info_ie) {
+		u16 op_mode;
+		op_mode = le16_to_cpu(ht_add_info_ie->operation_mode);
+
+		bss_info->primary_channel = ht_add_info_ie->control_chan;
+		bss_info->bss_cap = ht_add_info_ie->ht_param;
+		bss_info->bss_op_mode = (u8)(op_mode & 0xff);
+	}
+
+	return 0;
+}
+
+void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata, const u8 *da,
+				u16 tid, u8 dialog_token, u16 start_seq_num,
+				u16 agg_size, u16 timeout)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+	u16 capab;
+
+	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom);
+
+	if (!skb) {
+		printk(KERN_ERR "%s: failed to allocate buffer "
+				"for addba request frame\n", sdata->dev->name);
+		return;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
+	memset(mgmt, 0, 24);
+	memcpy(mgmt->da, da, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	if (sdata->vif.type == IEEE80211_IF_TYPE_AP)
+		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
+	else
+		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_ACTION);
+
+	skb_put(skb, 1 + sizeof(mgmt->u.action.u.addba_req));
+
+	mgmt->u.action.category = WLAN_CATEGORY_BACK;
+	mgmt->u.action.u.addba_req.action_code = WLAN_ACTION_ADDBA_REQ;
+
+	mgmt->u.action.u.addba_req.dialog_token = dialog_token;
+	capab = (u16)(1 << 1);		/* bit 1 aggregation policy */
+	capab |= (u16)(tid << 2); 	/* bit 5:2 TID number */
+	capab |= (u16)(agg_size << 6);	/* bit 15:6 max size of aggergation */
+
+	mgmt->u.action.u.addba_req.capab = cpu_to_le16(capab);
+
+	mgmt->u.action.u.addba_req.timeout = cpu_to_le16(timeout);
+	mgmt->u.action.u.addba_req.start_seq_num =
+					cpu_to_le16(start_seq_num << 4);
+
+	ieee80211_sta_tx(sdata, skb, 0);
+}
+
+void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata, const u8 *da, u16 tid,
+			  u16 initiator, u16 reason_code)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+	u16 params;
+
+	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom);
+
+	if (!skb) {
+		printk(KERN_ERR "%s: failed to allocate buffer "
+					"for delba frame\n", sdata->dev->name);
+		return;
+	}
+
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
+	memset(mgmt, 0, 24);
+	memcpy(mgmt->da, da, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	if (sdata->vif.type == IEEE80211_IF_TYPE_AP)
+		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
+	else
+		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_ACTION);
+
+	skb_put(skb, 1 + sizeof(mgmt->u.action.u.delba));
+
+	mgmt->u.action.category = WLAN_CATEGORY_BACK;
+	mgmt->u.action.u.delba.action_code = WLAN_ACTION_DELBA;
+	params = (u16)(initiator << 11); 	/* bit 11 initiator */
+	params |= (u16)(tid << 12); 		/* bit 15:12 TID number */
+
+	mgmt->u.action.u.delba.params = cpu_to_le16(params);
+	mgmt->u.action.u.delba.reason_code = cpu_to_le16(reason_code);
+
+	ieee80211_sta_tx(sdata, skb, 0);
+}
+
+void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid, u16 ssn)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff *skb;
+	struct ieee80211_bar *bar;
+	u16 bar_control = 0;
+
+	skb = dev_alloc_skb(sizeof(*bar) + local->hw.extra_tx_headroom);
+	if (!skb) {
+		printk(KERN_ERR "%s: failed to allocate buffer for "
+			"bar frame\n", sdata->dev->name);
+		return;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	bar = (struct ieee80211_bar *)skb_put(skb, sizeof(*bar));
+	memset(bar, 0, sizeof(*bar));
+	bar->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL |
+					 IEEE80211_STYPE_BACK_REQ);
+	memcpy(bar->ra, ra, ETH_ALEN);
+	memcpy(bar->ta, sdata->dev->dev_addr, ETH_ALEN);
+	bar_control |= (u16)IEEE80211_BAR_CTRL_ACK_POLICY_NORMAL;
+	bar_control |= (u16)IEEE80211_BAR_CTRL_CBMTID_COMPRESSED_BA;
+	bar_control |= (u16)(tid << 12);
+	bar->control = cpu_to_le16(bar_control);
+	bar->start_seq_num = cpu_to_le16(ssn);
+
+	ieee80211_sta_tx(sdata, skb, 0);
+}
+
+void ieee80211_sta_stop_rx_ba_session(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid,
+					u16 initiator, u16 reason)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_hw *hw = &local->hw;
+	struct sta_info *sta;
+	int ret, i;
+	DECLARE_MAC_BUF(mac);
+
+	rcu_read_lock();
+
+	sta = sta_info_get(local, ra);
+	if (!sta) {
+		rcu_read_unlock();
+		return;
+	}
+
+	/* check if TID is in operational state */
+	spin_lock_bh(&sta->lock);
+	if (sta->ampdu_mlme.tid_state_rx[tid]
+				!= HT_AGG_STATE_OPERATIONAL) {
+		spin_unlock_bh(&sta->lock);
+		rcu_read_unlock();
+		return;
+	}
+	sta->ampdu_mlme.tid_state_rx[tid] =
+		HT_AGG_STATE_REQ_STOP_BA_MSK |
+		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
+	spin_unlock_bh(&sta->lock);
+
+	/* stop HW Rx aggregation. ampdu_action existence
+	 * already verified in session init so we add the BUG_ON */
+	BUG_ON(!local->ops->ampdu_action);
+
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "Rx BA session stop requested for %s tid %u\n",
+				print_mac(mac, ra), tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+
+	ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_STOP,
+					ra, tid, NULL);
+	if (ret)
+		printk(KERN_DEBUG "HW problem - can not stop rx "
+				"aggregation for tid %d\n", tid);
+
+	/* shutdown timer has not expired */
+	if (initiator != WLAN_BACK_TIMER)
+		del_timer_sync(&sta->ampdu_mlme.tid_rx[tid]->session_timer);
+
+	/* check if this is a self generated aggregation halt */
+	if (initiator == WLAN_BACK_RECIPIENT || initiator == WLAN_BACK_TIMER)
+		ieee80211_send_delba(sdata, ra, tid, 0, reason);
+
+	/* free the reordering buffer */
+	for (i = 0; i < sta->ampdu_mlme.tid_rx[tid]->buf_size; i++) {
+		if (sta->ampdu_mlme.tid_rx[tid]->reorder_buf[i]) {
+			/* release the reordered frames */
+			dev_kfree_skb(sta->ampdu_mlme.tid_rx[tid]->reorder_buf[i]);
+			sta->ampdu_mlme.tid_rx[tid]->stored_mpdu_num--;
+			sta->ampdu_mlme.tid_rx[tid]->reorder_buf[i] = NULL;
+		}
+	}
+	/* free resources */
+	kfree(sta->ampdu_mlme.tid_rx[tid]->reorder_buf);
+	kfree(sta->ampdu_mlme.tid_rx[tid]);
+	sta->ampdu_mlme.tid_rx[tid] = NULL;
+	sta->ampdu_mlme.tid_state_rx[tid] = HT_AGG_STATE_IDLE;
+
+	rcu_read_unlock();
+}
+
+
+/*
+ * After sending add Block Ack request we activated a timer until
+ * add Block Ack response will arrive from the recipient.
+ * If this timer expires sta_addba_resp_timer_expired will be executed.
+ */
+void sta_addba_resp_timer_expired(unsigned long data)
+{
+	/* not an elegant detour, but there is no choice as the timer passes
+	 * only one argument, and both sta_info and TID are needed, so init
+	 * flow in sta_info_create gives the TID as data, while the timer_to_id
+	 * array gives the sta through container_of */
+	u16 tid = *(u8 *)data;
+	struct sta_info *temp_sta = container_of((void *)data,
+		struct sta_info, timer_to_tid[tid]);
+
+	struct ieee80211_local *local = temp_sta->local;
+	struct ieee80211_hw *hw = &local->hw;
+	struct sta_info *sta;
+	u8 *state;
+
+	rcu_read_lock();
+
+	sta = sta_info_get(local, temp_sta->addr);
+	if (!sta) {
+		rcu_read_unlock();
+		return;
+	}
+
+	state = &sta->ampdu_mlme.tid_state_tx[tid];
+	/* check if the TID waits for addBA response */
+	spin_lock_bh(&sta->lock);
+	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
+		spin_unlock_bh(&sta->lock);
+		*state = HT_AGG_STATE_IDLE;
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "timer expired on tid %d but we are not "
+				"expecting addBA response there", tid);
+#endif
+		goto timer_expired_exit;
+	}
+
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "addBA response timer expired on tid %d\n", tid);
+#endif
+
+	/* go through the state check in stop_BA_session */
+	*state = HT_AGG_STATE_OPERATIONAL;
+	spin_unlock_bh(&sta->lock);
+	ieee80211_stop_tx_ba_session(hw, temp_sta->addr, tid,
+				     WLAN_BACK_INITIATOR);
+
+timer_expired_exit:
+	rcu_read_unlock();
+}
+
+void ieee80211_sta_tear_down_BA_sessions(struct ieee80211_sub_if_data *sdata, u8 *addr)
+{
+	struct ieee80211_local *local = sdata->local;
+	int i;
+
+	for (i = 0; i <  STA_TID_NUM; i++) {
+		ieee80211_stop_tx_ba_session(&local->hw, addr, i,
+					     WLAN_BACK_INITIATOR);
+		ieee80211_sta_stop_rx_ba_session(sdata, addr, i,
+						 WLAN_BACK_RECIPIENT,
+						 WLAN_REASON_QSTA_LEAVE_QBSS);
+	}
+}
+
--- everything.orig/net/mac80211/mlme.c	2008-09-08 16:05:28.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-08 16:07:05.000000000 +0200
@@ -48,20 +48,6 @@
 #define IEEE80211_IBSS_MAX_STA_ENTRIES 128
 
 
-/* mgmt header + 1 byte category code */
-#define IEEE80211_MIN_ACTION_SIZE (24 + 1)
-
-#define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
-#define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
-#define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFA0
-#define IEEE80211_DELBA_PARAM_TID_MASK 0xF000
-#define IEEE80211_DELBA_PARAM_INITIATOR_MASK 0x0800
-
-/* next values represent the buffer size for A-MPDU frame.
- * According to IEEE802.11n spec size varies from 8K to 64K (in powers of 2) */
-#define IEEE80211_MIN_AMPDU_BUF 0x8
-#define IEEE80211_MAX_AMPDU_BUF 0x40
-
 /* utils */
 static int ecw2cw(int ecw)
 {
@@ -389,52 +375,6 @@ static u32 ieee80211_handle_bss_capabili
 	return changed;
 }
 
-int ieee80211_ht_cap_ie_to_ht_info(struct ieee80211_ht_cap *ht_cap_ie,
-				   struct ieee80211_ht_info *ht_info)
-{
-
-	if (ht_info == NULL)
-		return -EINVAL;
-
-	memset(ht_info, 0, sizeof(*ht_info));
-
-	if (ht_cap_ie) {
-		u8 ampdu_info = ht_cap_ie->ampdu_params_info;
-
-		ht_info->ht_supported = 1;
-		ht_info->cap = le16_to_cpu(ht_cap_ie->cap_info);
-		ht_info->ampdu_factor =
-			ampdu_info & IEEE80211_HT_CAP_AMPDU_FACTOR;
-		ht_info->ampdu_density =
-			(ampdu_info & IEEE80211_HT_CAP_AMPDU_DENSITY) >> 2;
-		memcpy(ht_info->supp_mcs_set, ht_cap_ie->supp_mcs_set, 16);
-	} else
-		ht_info->ht_supported = 0;
-
-	return 0;
-}
-
-int ieee80211_ht_addt_info_ie_to_ht_bss_info(
-			struct ieee80211_ht_addt_info *ht_add_info_ie,
-			struct ieee80211_ht_bss_info *bss_info)
-{
-	if (bss_info == NULL)
-		return -EINVAL;
-
-	memset(bss_info, 0, sizeof(*bss_info));
-
-	if (ht_add_info_ie) {
-		u16 op_mode;
-		op_mode = le16_to_cpu(ht_add_info_ie->operation_mode);
-
-		bss_info->primary_channel = ht_add_info_ie->control_chan;
-		bss_info->bss_cap = ht_add_info_ie->ht_param;
-		bss_info->bss_op_mode = (u8)(op_mode & 0xff);
-	}
-
-	return 0;
-}
-
 static void ieee80211_sta_send_apinfo(struct ieee80211_sub_if_data *sdata,
 					struct ieee80211_if_sta *ifsta)
 {
@@ -1119,55 +1059,6 @@ static void ieee80211_send_addba_resp(st
 	return;
 }
 
-void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata, const u8 *da,
-				u16 tid, u8 dialog_token, u16 start_seq_num,
-				u16 agg_size, u16 timeout)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *mgmt;
-	u16 capab;
-
-	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom);
-
-	if (!skb) {
-		printk(KERN_ERR "%s: failed to allocate buffer "
-				"for addba request frame\n", sdata->dev->name);
-		return;
-	}
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
-	memset(mgmt, 0, 24);
-	memcpy(mgmt->da, da, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	if (sdata->vif.type == IEEE80211_IF_TYPE_AP)
-		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
-	else
-		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-
-	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-					  IEEE80211_STYPE_ACTION);
-
-	skb_put(skb, 1 + sizeof(mgmt->u.action.u.addba_req));
-
-	mgmt->u.action.category = WLAN_CATEGORY_BACK;
-	mgmt->u.action.u.addba_req.action_code = WLAN_ACTION_ADDBA_REQ;
-
-	mgmt->u.action.u.addba_req.dialog_token = dialog_token;
-	capab = (u16)(1 << 1);		/* bit 1 aggregation policy */
-	capab |= (u16)(tid << 2); 	/* bit 5:2 TID number */
-	capab |= (u16)(agg_size << 6);	/* bit 15:6 max size of aggergation */
-
-	mgmt->u.action.u.addba_req.capab = cpu_to_le16(capab);
-
-	mgmt->u.action.u.addba_req.timeout = cpu_to_le16(timeout);
-	mgmt->u.action.u.addba_req.start_seq_num =
-					cpu_to_le16(start_seq_num << 4);
-
-	ieee80211_sta_tx(sdata, skb, 0);
-}
-
 /*
  * After accepting the AddBA Request we activated a timer,
  * resetting it after each frame that arrives from the originator.
@@ -1397,149 +1288,6 @@ addba_resp_exit:
 	rcu_read_unlock();
 }
 
-void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata, const u8 *da, u16 tid,
-			  u16 initiator, u16 reason_code)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *mgmt;
-	u16 params;
-
-	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom);
-
-	if (!skb) {
-		printk(KERN_ERR "%s: failed to allocate buffer "
-					"for delba frame\n", sdata->dev->name);
-		return;
-	}
-
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
-	memset(mgmt, 0, 24);
-	memcpy(mgmt->da, da, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	if (sdata->vif.type == IEEE80211_IF_TYPE_AP)
-		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
-	else
-		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-					  IEEE80211_STYPE_ACTION);
-
-	skb_put(skb, 1 + sizeof(mgmt->u.action.u.delba));
-
-	mgmt->u.action.category = WLAN_CATEGORY_BACK;
-	mgmt->u.action.u.delba.action_code = WLAN_ACTION_DELBA;
-	params = (u16)(initiator << 11); 	/* bit 11 initiator */
-	params |= (u16)(tid << 12); 		/* bit 15:12 TID number */
-
-	mgmt->u.action.u.delba.params = cpu_to_le16(params);
-	mgmt->u.action.u.delba.reason_code = cpu_to_le16(reason_code);
-
-	ieee80211_sta_tx(sdata, skb, 0);
-}
-
-void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid, u16 ssn)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb;
-	struct ieee80211_bar *bar;
-	u16 bar_control = 0;
-
-	skb = dev_alloc_skb(sizeof(*bar) + local->hw.extra_tx_headroom);
-	if (!skb) {
-		printk(KERN_ERR "%s: failed to allocate buffer for "
-			"bar frame\n", sdata->dev->name);
-		return;
-	}
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-	bar = (struct ieee80211_bar *)skb_put(skb, sizeof(*bar));
-	memset(bar, 0, sizeof(*bar));
-	bar->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL |
-					 IEEE80211_STYPE_BACK_REQ);
-	memcpy(bar->ra, ra, ETH_ALEN);
-	memcpy(bar->ta, sdata->dev->dev_addr, ETH_ALEN);
-	bar_control |= (u16)IEEE80211_BAR_CTRL_ACK_POLICY_NORMAL;
-	bar_control |= (u16)IEEE80211_BAR_CTRL_CBMTID_COMPRESSED_BA;
-	bar_control |= (u16)(tid << 12);
-	bar->control = cpu_to_le16(bar_control);
-	bar->start_seq_num = cpu_to_le16(ssn);
-
-	ieee80211_sta_tx(sdata, skb, 0);
-}
-
-void ieee80211_sta_stop_rx_ba_session(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid,
-					u16 initiator, u16 reason)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_hw *hw = &local->hw;
-	struct sta_info *sta;
-	int ret, i;
-	DECLARE_MAC_BUF(mac);
-
-	rcu_read_lock();
-
-	sta = sta_info_get(local, ra);
-	if (!sta) {
-		rcu_read_unlock();
-		return;
-	}
-
-	/* check if TID is in operational state */
-	spin_lock_bh(&sta->lock);
-	if (sta->ampdu_mlme.tid_state_rx[tid]
-				!= HT_AGG_STATE_OPERATIONAL) {
-		spin_unlock_bh(&sta->lock);
-		rcu_read_unlock();
-		return;
-	}
-	sta->ampdu_mlme.tid_state_rx[tid] =
-		HT_AGG_STATE_REQ_STOP_BA_MSK |
-		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
-	spin_unlock_bh(&sta->lock);
-
-	/* stop HW Rx aggregation. ampdu_action existence
-	 * already verified in session init so we add the BUG_ON */
-	BUG_ON(!local->ops->ampdu_action);
-
-#ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "Rx BA session stop requested for %s tid %u\n",
-				print_mac(mac, ra), tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-
-	ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_STOP,
-					ra, tid, NULL);
-	if (ret)
-		printk(KERN_DEBUG "HW problem - can not stop rx "
-				"aggregation for tid %d\n", tid);
-
-	/* shutdown timer has not expired */
-	if (initiator != WLAN_BACK_TIMER)
-		del_timer_sync(&sta->ampdu_mlme.tid_rx[tid]->session_timer);
-
-	/* check if this is a self generated aggregation halt */
-	if (initiator == WLAN_BACK_RECIPIENT || initiator == WLAN_BACK_TIMER)
-		ieee80211_send_delba(sdata, ra, tid, 0, reason);
-
-	/* free the reordering buffer */
-	for (i = 0; i < sta->ampdu_mlme.tid_rx[tid]->buf_size; i++) {
-		if (sta->ampdu_mlme.tid_rx[tid]->reorder_buf[i]) {
-			/* release the reordered frames */
-			dev_kfree_skb(sta->ampdu_mlme.tid_rx[tid]->reorder_buf[i]);
-			sta->ampdu_mlme.tid_rx[tid]->stored_mpdu_num--;
-			sta->ampdu_mlme.tid_rx[tid]->reorder_buf[i] = NULL;
-		}
-	}
-	/* free resources */
-	kfree(sta->ampdu_mlme.tid_rx[tid]->reorder_buf);
-	kfree(sta->ampdu_mlme.tid_rx[tid]);
-	sta->ampdu_mlme.tid_rx[tid] = NULL;
-	sta->ampdu_mlme.tid_state_rx[tid] = HT_AGG_STATE_IDLE;
-
-	rcu_read_unlock();
-}
-
-
 static void ieee80211_sta_process_delba(struct ieee80211_sub_if_data *sdata,
 			struct ieee80211_mgmt *mgmt, size_t len)
 {
@@ -1583,75 +1331,6 @@ static void ieee80211_sta_process_delba(
 	rcu_read_unlock();
 }
 
-/*
- * After sending add Block Ack request we activated a timer until
- * add Block Ack response will arrive from the recipient.
- * If this timer expires sta_addba_resp_timer_expired will be executed.
- */
-void sta_addba_resp_timer_expired(unsigned long data)
-{
-	/* not an elegant detour, but there is no choice as the timer passes
-	 * only one argument, and both sta_info and TID are needed, so init
-	 * flow in sta_info_create gives the TID as data, while the timer_to_id
-	 * array gives the sta through container_of */
-	u16 tid = *(u8 *)data;
-	struct sta_info *temp_sta = container_of((void *)data,
-		struct sta_info, timer_to_tid[tid]);
-
-	struct ieee80211_local *local = temp_sta->local;
-	struct ieee80211_hw *hw = &local->hw;
-	struct sta_info *sta;
-	u8 *state;
-
-	rcu_read_lock();
-
-	sta = sta_info_get(local, temp_sta->addr);
-	if (!sta) {
-		rcu_read_unlock();
-		return;
-	}
-
-	state = &sta->ampdu_mlme.tid_state_tx[tid];
-	/* check if the TID waits for addBA response */
-	spin_lock_bh(&sta->lock);
-	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
-		spin_unlock_bh(&sta->lock);
-		*state = HT_AGG_STATE_IDLE;
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		printk(KERN_DEBUG "timer expired on tid %d but we are not "
-				"expecting addBA response there", tid);
-#endif
-		goto timer_expired_exit;
-	}
-
-#ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "addBA response timer expired on tid %d\n", tid);
-#endif
-
-	/* go through the state check in stop_BA_session */
-	*state = HT_AGG_STATE_OPERATIONAL;
-	spin_unlock_bh(&sta->lock);
-	ieee80211_stop_tx_ba_session(hw, temp_sta->addr, tid,
-				     WLAN_BACK_INITIATOR);
-
-timer_expired_exit:
-	rcu_read_unlock();
-}
-
-void ieee80211_sta_tear_down_BA_sessions(struct ieee80211_sub_if_data *sdata, u8 *addr)
-{
-	struct ieee80211_local *local = sdata->local;
-	int i;
-
-	for (i = 0; i <  STA_TID_NUM; i++) {
-		ieee80211_stop_tx_ba_session(&local->hw, addr, i,
-					     WLAN_BACK_INITIATOR);
-		ieee80211_sta_stop_rx_ba_session(sdata, addr, i,
-						 WLAN_BACK_RECIPIENT,
-						 WLAN_REASON_QSTA_LEAVE_QBSS);
-	}
-}
-
 static void ieee80211_send_refuse_measurement_request(struct ieee80211_sub_if_data *sdata,
 					struct ieee80211_msrment_ie *request_ie,
 					const u8 *da, const u8 *bssid,
--- everything.orig/net/mac80211/Makefile	2008-09-08 16:05:28.000000000 +0200
+++ everything/net/mac80211/Makefile	2008-09-08 16:05:29.000000000 +0200
@@ -8,6 +8,7 @@ mac80211-y := \
 	wep.o \
 	wpa.o \
 	scan.o \
+	ht.o \
 	mlme.o \
 	iface.o \
 	rate.o \

-- 

