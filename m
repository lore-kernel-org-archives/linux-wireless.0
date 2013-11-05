Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:51243 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab3KETWn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 14:22:43 -0500
Received: by mail-pd0-f178.google.com with SMTP id x10so8955168pdj.23
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 11:22:42 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Subject: [PATCH 03/17] mac80211: hold sta->lock across plink switch statements
Date: Tue,  5 Nov 2013 11:16:51 -0800
Message-Id: <1383679025-7150-3-git-send-email-thomas@cozybit.com> (sfid-20131105_202300_486768_019D020B)
In-Reply-To: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
References: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

Rather than unlock at the end of each case, do it once after
all is said and done.

Signed-off-by: Bob Copeland <bob@cozybit.com>
---
 net/mac80211/mesh_plink.c | 29 +++--------------------------
 1 file changed, 3 insertions(+), 26 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index d45826e..c3a3faf 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -575,7 +575,6 @@ static void mesh_plink_timer(unsigned long data)
 					     rand % sta->plink_timeout;
 			++sta->plink_retries;
 			mod_plink_timer(sta, sta->plink_timeout);
-			spin_unlock_bh(&sta->lock);
 			action = WLAN_SP_MESH_PEERING_OPEN;
 			break;
 		}
@@ -587,19 +586,17 @@ static void mesh_plink_timer(unsigned long data)
 			reason = cpu_to_le16(WLAN_REASON_MESH_CONFIRM_TIMEOUT);
 		sta->plink_state = NL80211_PLINK_HOLDING;
 		mod_plink_timer(sta, mshcfg->dot11MeshHoldingTimeout);
-		spin_unlock_bh(&sta->lock);
 		action = WLAN_SP_MESH_PEERING_CLOSE;
 		break;
 	case NL80211_PLINK_HOLDING:
 		/* holding timer */
 		del_timer(&sta->plink_timer);
 		mesh_plink_fsm_restart(sta);
-		spin_unlock_bh(&sta->lock);
 		break;
 	default:
-		spin_unlock_bh(&sta->lock);
 		break;
 	}
+	spin_unlock_bh(&sta->lock);
 	if (action)
 		mesh_plink_frame_tx(sdata, action, sta->sta.addr,
 				    llid, plid, reason);
@@ -856,12 +853,10 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 	reason = 0;
 	spin_lock_bh(&sta->lock);
 	switch (sta->plink_state) {
-		/* spin_unlock as soon as state is updated at each case */
 	case NL80211_PLINK_LISTEN:
 		switch (event) {
 		case CLS_ACPT:
 			mesh_plink_fsm_restart(sta);
-			spin_unlock_bh(&sta->lock);
 			break;
 		case OPN_ACPT:
 			sta->plink_state = NL80211_PLINK_OPN_RCVD;
@@ -874,11 +869,9 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 			/* set the non-peer mode to active during peering */
 			changed |= ieee80211_mps_local_status_update(sdata);
 
-			spin_unlock_bh(&sta->lock);
 			action = WLAN_SP_MESH_PEERING_OPEN;
 			break;
 		default:
-			spin_unlock_bh(&sta->lock);
 			break;
 		}
 		break;
@@ -897,14 +890,12 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 					     mshcfg->dot11MeshHoldingTimeout))
 				sta->ignore_plink_timer = true;
 
-			spin_unlock_bh(&sta->lock);
 			action = WLAN_SP_MESH_PEERING_CLOSE;
 			break;
 		case OPN_ACPT:
 			/* retry timer is left untouched */
 			sta->plink_state = NL80211_PLINK_OPN_RCVD;
 			sta->plid = plid;
-			spin_unlock_bh(&sta->lock);
 			action = WLAN_SP_MESH_PEERING_CONFIRM;
 			break;
 		case CNF_ACPT:
@@ -913,10 +904,8 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 					     mshcfg->dot11MeshConfirmTimeout))
 				sta->ignore_plink_timer = true;
 
-			spin_unlock_bh(&sta->lock);
 			break;
 		default:
-			spin_unlock_bh(&sta->lock);
 			break;
 		}
 		break;
@@ -935,17 +924,14 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 					     mshcfg->dot11MeshHoldingTimeout))
 				sta->ignore_plink_timer = true;
 
-			spin_unlock_bh(&sta->lock);
 			action = WLAN_SP_MESH_PEERING_CLOSE;
 			break;
 		case OPN_ACPT:
-			spin_unlock_bh(&sta->lock);
 			action = WLAN_SP_MESH_PEERING_CONFIRM;
 			break;
 		case CNF_ACPT:
 			del_timer(&sta->plink_timer);
 			sta->plink_state = NL80211_PLINK_ESTAB;
-			spin_unlock_bh(&sta->lock);
 			changed |= mesh_plink_inc_estab_count(sdata);
 			changed |= mesh_set_ht_prot_mode(sdata);
 			changed |= mesh_set_short_slot_time(sdata);
@@ -956,7 +942,6 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 						       mshcfg->power_mode);
 			break;
 		default:
-			spin_unlock_bh(&sta->lock);
 			break;
 		}
 		break;
@@ -975,13 +960,11 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 					     mshcfg->dot11MeshHoldingTimeout))
 				sta->ignore_plink_timer = true;
 
-			spin_unlock_bh(&sta->lock);
 			action = WLAN_SP_MESH_PEERING_CLOSE;
 			break;
 		case OPN_ACPT:
 			del_timer(&sta->plink_timer);
 			sta->plink_state = NL80211_PLINK_ESTAB;
-			spin_unlock_bh(&sta->lock);
 			changed |= mesh_plink_inc_estab_count(sdata);
 			changed |= mesh_set_ht_prot_mode(sdata);
 			changed |= mesh_set_short_slot_time(sdata);
@@ -993,7 +976,6 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 							mshcfg->power_mode);
 			break;
 		default:
-			spin_unlock_bh(&sta->lock);
 			break;
 		}
 		break;
@@ -1006,17 +988,14 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 			changed |= __mesh_plink_deactivate(sta);
 			sta->plink_state = NL80211_PLINK_HOLDING;
 			mod_plink_timer(sta, mshcfg->dot11MeshHoldingTimeout);
-			spin_unlock_bh(&sta->lock);
 			changed |= mesh_set_ht_prot_mode(sdata);
 			changed |= mesh_set_short_slot_time(sdata);
 			action = WLAN_SP_MESH_PEERING_CLOSE;
 			break;
 		case OPN_ACPT:
-			spin_unlock_bh(&sta->lock);
 			action = WLAN_SP_MESH_PEERING_CONFIRM;
 			break;
 		default:
-			spin_unlock_bh(&sta->lock);
 			break;
 		}
 		break;
@@ -1026,26 +1005,24 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 			if (del_timer(&sta->plink_timer))
 				sta->ignore_plink_timer = 1;
 			mesh_plink_fsm_restart(sta);
-			spin_unlock_bh(&sta->lock);
 			break;
 		case OPN_ACPT:
 		case CNF_ACPT:
 		case OPN_RJCT:
 		case CNF_RJCT:
-			spin_unlock_bh(&sta->lock);
 			action = WLAN_SP_MESH_PEERING_CLOSE;
 			break;
 		default:
-			spin_unlock_bh(&sta->lock);
+			break;
 		}
 		break;
 	default:
 		/* should not get here, PLINK_BLOCKED is dealt with at the
 		 * beginning of the function
 		 */
-		spin_unlock_bh(&sta->lock);
 		break;
 	}
+	spin_unlock_bh(&sta->lock);
 	if (action) {
 		mesh_plink_frame_tx(sdata, action, sta->sta.addr,
 				    sta->llid, sta->plid, sta->reason);
-- 
1.8.4.rc3

