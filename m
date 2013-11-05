Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:37707 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3KETWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 14:22:41 -0500
Received: by mail-pd0-f177.google.com with SMTP id p10so8923536pdj.8
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 11:22:40 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 02/17] mac80211: consolidate calls to plink_frame_tx
Date: Tue,  5 Nov 2013 11:16:50 -0800
Message-Id: <1383679025-7150-2-git-send-email-thomas@cozybit.com> (sfid-20131105_202331_526109_DAE75547)
In-Reply-To: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
References: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do all frame transfers in one place at the end of the
big switch statements.  sta->plid and sta->reason can
be passed in any case, since they are only used for
the frames that need them.  Remove assignments to locals
for values already stored in the sta structure.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/mesh_plink.c | 72 +++++++++++++++++++----------------------------
 1 file changed, 29 insertions(+), 43 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index a8c75c1..d45826e 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -533,6 +533,7 @@ static void mesh_plink_timer(unsigned long data)
 	__le16 llid, plid, reason;
 	struct ieee80211_sub_if_data *sdata;
 	struct mesh_config *mshcfg;
+	enum ieee80211_self_protected_actioncode action = 0;
 
 	/*
 	 * This STA is valid because sta_info_destroy() will
@@ -575,8 +576,7 @@ static void mesh_plink_timer(unsigned long data)
 			++sta->plink_retries;
 			mod_plink_timer(sta, sta->plink_timeout);
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_OPEN,
-					    sta->sta.addr, llid, 0, 0);
+			action = WLAN_SP_MESH_PEERING_OPEN;
 			break;
 		}
 		reason = cpu_to_le16(WLAN_REASON_MESH_MAX_RETRIES);
@@ -588,8 +588,7 @@ static void mesh_plink_timer(unsigned long data)
 		sta->plink_state = NL80211_PLINK_HOLDING;
 		mod_plink_timer(sta, mshcfg->dot11MeshHoldingTimeout);
 		spin_unlock_bh(&sta->lock);
-		mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
-				    sta->sta.addr, llid, plid, reason);
+		action = WLAN_SP_MESH_PEERING_CLOSE;
 		break;
 	case NL80211_PLINK_HOLDING:
 		/* holding timer */
@@ -601,6 +600,9 @@ static void mesh_plink_timer(unsigned long data)
 		spin_unlock_bh(&sta->lock);
 		break;
 	}
+	if (action)
+		mesh_plink_frame_tx(sdata, action, sta->sta.addr,
+				    llid, plid, reason);
 }
 
 static inline void mesh_plink_timer_set(struct sta_info *sta, int timeout)
@@ -662,6 +664,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 			 struct ieee80211_rx_status *rx_status)
 {
 	struct mesh_config *mshcfg = &sdata->u.mesh.mshcfg;
+	enum ieee80211_self_protected_actioncode action = 0;
 	struct ieee802_11_elems elems;
 	struct sta_info *sta;
 	enum plink_event event;
@@ -872,12 +875,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 			changed |= ieee80211_mps_local_status_update(sdata);
 
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata,
-					    WLAN_SP_MESH_PEERING_OPEN,
-					    sta->sta.addr, llid, 0, 0);
-			mesh_plink_frame_tx(sdata,
-					    WLAN_SP_MESH_PEERING_CONFIRM,
-					    sta->sta.addr, llid, plid, 0);
+			action = WLAN_SP_MESH_PEERING_OPEN;
 			break;
 		default:
 			spin_unlock_bh(&sta->lock);
@@ -899,21 +897,15 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 					     mshcfg->dot11MeshHoldingTimeout))
 				sta->ignore_plink_timer = true;
 
-			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata,
-					    WLAN_SP_MESH_PEERING_CLOSE,
-					    sta->sta.addr, llid, plid, reason);
+			action = WLAN_SP_MESH_PEERING_CLOSE;
 			break;
 		case OPN_ACPT:
 			/* retry timer is left untouched */
 			sta->plink_state = NL80211_PLINK_OPN_RCVD;
 			sta->plid = plid;
-			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata,
-					    WLAN_SP_MESH_PEERING_CONFIRM,
-					    sta->sta.addr, llid, plid, 0);
+			action = WLAN_SP_MESH_PEERING_CONFIRM;
 			break;
 		case CNF_ACPT:
 			sta->plink_state = NL80211_PLINK_CNF_RCVD;
@@ -943,17 +935,12 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 					     mshcfg->dot11MeshHoldingTimeout))
 				sta->ignore_plink_timer = true;
 
-			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
-					    sta->sta.addr, llid, plid, reason);
+			action = WLAN_SP_MESH_PEERING_CLOSE;
 			break;
 		case OPN_ACPT:
-			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata,
-					    WLAN_SP_MESH_PEERING_CONFIRM,
-					    sta->sta.addr, llid, plid, 0);
+			action = WLAN_SP_MESH_PEERING_CONFIRM;
 			break;
 		case CNF_ACPT:
 			del_timer(&sta->plink_timer);
@@ -988,11 +975,8 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 					     mshcfg->dot11MeshHoldingTimeout))
 				sta->ignore_plink_timer = true;
 
-			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata,
-					    WLAN_SP_MESH_PEERING_CLOSE,
-					    sta->sta.addr, llid, plid, reason);
+			action = WLAN_SP_MESH_PEERING_CLOSE;
 			break;
 		case OPN_ACPT:
 			del_timer(&sta->plink_timer);
@@ -1003,9 +987,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 			changed |= mesh_set_short_slot_time(sdata);
 			mpl_dbg(sdata, "Mesh plink with %pM ESTABLISHED\n",
 				sta->sta.addr);
-			mesh_plink_frame_tx(sdata,
-					    WLAN_SP_MESH_PEERING_CONFIRM,
-					    sta->sta.addr, llid, plid, 0);
+			action = WLAN_SP_MESH_PEERING_CONFIRM;
 			ieee80211_mps_sta_status_update(sta);
 			changed |= ieee80211_mps_set_sta_local_pm(sta,
 							mshcfg->power_mode);
@@ -1023,20 +1005,15 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 			sta->reason = reason;
 			changed |= __mesh_plink_deactivate(sta);
 			sta->plink_state = NL80211_PLINK_HOLDING;
-			llid = sta->llid;
 			mod_plink_timer(sta, mshcfg->dot11MeshHoldingTimeout);
 			spin_unlock_bh(&sta->lock);
 			changed |= mesh_set_ht_prot_mode(sdata);
 			changed |= mesh_set_short_slot_time(sdata);
-			mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
-					    sta->sta.addr, llid, plid, reason);
+			action = WLAN_SP_MESH_PEERING_CLOSE;
 			break;
 		case OPN_ACPT:
-			llid = sta->llid;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata,
-					    WLAN_SP_MESH_PEERING_CONFIRM,
-					    sta->sta.addr, llid, plid, 0);
+			action = WLAN_SP_MESH_PEERING_CONFIRM;
 			break;
 		default:
 			spin_unlock_bh(&sta->lock);
@@ -1055,11 +1032,8 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 		case CNF_ACPT:
 		case OPN_RJCT:
 		case CNF_RJCT:
-			llid = sta->llid;
-			reason = sta->reason;
 			spin_unlock_bh(&sta->lock);
-			mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
-					    sta->sta.addr, llid, plid, reason);
+			action = WLAN_SP_MESH_PEERING_CLOSE;
 			break;
 		default:
 			spin_unlock_bh(&sta->lock);
@@ -1072,6 +1046,18 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 		spin_unlock_bh(&sta->lock);
 		break;
 	}
+	if (action) {
+		mesh_plink_frame_tx(sdata, action, sta->sta.addr,
+				    sta->llid, sta->plid, sta->reason);
+
+		/* also send confirm in open case */
+		if (action == WLAN_SP_MESH_PEERING_OPEN) {
+			mesh_plink_frame_tx(sdata,
+					    WLAN_SP_MESH_PEERING_CONFIRM,
+					    sta->sta.addr, sta->llid,
+					    sta->plid, 0);
+		}
+	}
 
 	rcu_read_unlock();
 
-- 
1.8.4.rc3

