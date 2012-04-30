Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f51.google.com ([209.85.210.51]:56658 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057Ab2D3VU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 17:20:56 -0400
Received: by mail-pz0-f51.google.com with SMTP id z8so4574046dad.10
        for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2012 14:20:56 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	javier@cozybit.com, devel@lists.open80211s.org,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH v2 2/4] mac80211: Implement HT mixed protection mode
Date: Mon, 30 Apr 2012 14:20:30 -0700
Message-Id: <1335820832-18887-2-git-send-email-ashok@cozybit.com> (sfid-20120430_232100_439722_22A8AD5C)
In-Reply-To: <1335820832-18887-1-git-send-email-ashok@cozybit.com>
References: <1335820832-18887-1-git-send-email-ashok@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Section 9.23.3.5 of IEEE 80211s standard describes the protection rules for
HT mesh STA in a MBSS. Three HT protection modes are supported for now:

non-HT mixed mode - is selected if any non-HT peers are present in our MBSS.
20MHz-protection mode - is selected if all peers in our 20/40MHz MBSS support
			HT and atleast one HT20 peer is present.
no-protection mode - is selected otherwise.

This is a limited implementation of 9.23.3.5, which only considers mesh peers
when determining the HT protection mode. Station's channel_type needs to be
maintained.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
Reviewed-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c |   83 +++++++++++++++++++++++++++++++++++++++++----
 net/mac80211/sta_info.h   |    1 +
 2 files changed, 77 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 6209327..2e0ae73 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -105,6 +105,66 @@ static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
 	return sta;
 }
 
+/** mesh_set_ht_prot_mode - set correct HT protection mode
+ *
+ * Section 9.23.3.5 of IEEE 80211s standard describes the protection rules for
+ * HT mesh STA in a MBSS. Three HT protection modes are supported for now,
+ * non-HT mixed mode, 20MHz-protection and no-protection mode. non-HT mixed
+ * mode is selected if any non-HT peers are present in our MBSS.
+ * 20MHz-protection mode is selected if all peers in our 20/40MHz MBSS support
+ * HT and atleast one HT20 peer is present. Otherwise no-protection mode is
+ * selected.
+ */
+static u32 mesh_set_ht_prot_mode(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+	u32 changed = 0;
+	u16 ht_opmode;
+	bool non_ht_sta = false, ht20_sta = false;
+
+	if (local->_oper_channel_type == NL80211_CHAN_NO_HT)
+		return 0;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		if (sdata == sta->sdata &&
+		    sta->plink_state == NL80211_PLINK_ESTAB) {
+			switch (sta->ch_type) {
+			case NL80211_CHAN_NO_HT:
+				mpl_dbg("mesh_plink %pM: nonHT sta (%pM) is present",
+					sdata->vif.addr, sta->sta.addr);
+				non_ht_sta = true;
+				goto out;
+			case NL80211_CHAN_HT20:
+				mpl_dbg("mesh_plink %pM: HT20 sta (%pM) is present",
+					sdata->vif.addr, sta->sta.addr);
+				ht20_sta = true;
+			default:
+				break;
+			}
+		}
+	}
+out:
+	rcu_read_unlock();
+
+	if (non_ht_sta)
+		ht_opmode = IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED;
+	else if (ht20_sta && local->_oper_channel_type > NL80211_CHAN_HT20)
+		ht_opmode = IEEE80211_HT_OP_MODE_PROTECTION_20MHZ;
+	else
+		ht_opmode = IEEE80211_HT_OP_MODE_PROTECTION_NONE;
+
+	if (sdata->vif.bss_conf.ht_operation_mode != ht_opmode) {
+		sdata->vif.bss_conf.ht_operation_mode = ht_opmode;
+		changed = BSS_CHANGED_HT;
+		mpl_dbg("mesh_plink %pM: protection mode changed to %d",
+			sdata->vif.addr, ht_opmode);
+	}
+
+	return changed;
+}
+
 /**
  * __mesh_plink_deactivate - deactivate mesh peer link
  *
@@ -302,11 +362,14 @@ static struct sta_info *mesh_peer_init(struct ieee80211_sub_if_data *sdata,
 	else
 		memset(&sta->sta.ht_cap, 0, sizeof(sta->sta.ht_cap));
 
-	if (elems->ht_operation)
+	if (elems->ht_operation) {
 		if (!(elems->ht_operation->ht_param &
 		      IEEE80211_HT_PARAM_CHAN_WIDTH_ANY))
 			sta->sta.ht_cap.cap &=
 					    ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+		sta->ch_type =
+			ieee80211_ht_oper_to_channel_type(elems->ht_operation);
+	}
 
 	rate_control_rate_init(sta);
 	spin_unlock_bh(&sta->lock);
@@ -495,9 +558,10 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	enum plink_event event;
 	enum ieee80211_self_protected_actioncode ftype;
 	size_t baselen;
-	bool deactivated, matches_local = true;
+	bool matches_local = true;
 	u8 ie_len;
 	u8 *baseaddr;
+	u32 changed = 0;
 	__le16 plid, llid, reason;
 #ifdef CONFIG_MAC80211_VERBOSE_MPL_DEBUG
 	static const char *mplstates[] = {
@@ -783,7 +847,8 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			sta->plink_state = NL80211_PLINK_ESTAB;
 			spin_unlock_bh(&sta->lock);
 			mesh_plink_inc_estab_count(sdata);
-			ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
+			changed |= mesh_set_ht_prot_mode(sdata);
+			changed |= BSS_CHANGED_BEACON;
 			mpl_dbg("Mesh plink with %pM ESTABLISHED\n",
 				sta->sta.addr);
 			break;
@@ -818,7 +883,8 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			sta->plink_state = NL80211_PLINK_ESTAB;
 			spin_unlock_bh(&sta->lock);
 			mesh_plink_inc_estab_count(sdata);
-			ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
+			changed |= mesh_set_ht_prot_mode(sdata);
+			changed |= BSS_CHANGED_BEACON;
 			mpl_dbg("Mesh plink with %pM ESTABLISHED\n",
 				sta->sta.addr);
 			mesh_plink_frame_tx(sdata,
@@ -836,13 +902,13 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		case CLS_ACPT:
 			reason = cpu_to_le16(WLAN_REASON_MESH_CLOSE);
 			sta->reason = reason;
-			deactivated = __mesh_plink_deactivate(sta);
+			__mesh_plink_deactivate(sta);
 			sta->plink_state = NL80211_PLINK_HOLDING;
 			llid = sta->llid;
 			mod_plink_timer(sta, dot11MeshHoldingTimeout(sdata));
 			spin_unlock_bh(&sta->lock);
-			if (deactivated)
-				ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
+			changed |= mesh_set_ht_prot_mode(sdata);
+			changed |= BSS_CHANGED_BEACON;
 			mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
 					    sta->sta.addr, llid, plid, reason);
 			break;
@@ -889,4 +955,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	}
 
 	rcu_read_unlock();
+
+	if (changed)
+		ieee80211_bss_info_change_notify(sdata, changed);
 }
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index f75f5d9..663dc90 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -362,6 +362,7 @@ struct sta_info {
 	struct timer_list plink_timer;
 	s64 t_offset;
 	s64 t_offset_setpoint;
+	enum nl80211_channel_type ch_type;
 #endif
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-- 
1.7.5.4

