Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35940 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933454Ab3CZOTt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 10:19:49 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: handle extended channel switch announcement
Date: Tue, 26 Mar 2013 15:19:43 +0100
Message-Id: <1364307583-5554-1-git-send-email-johannes@sipsolutions.net> (sfid-20130326_151954_296844_1BAB6195)
In-Reply-To: <1364304961-32028-1-git-send-email-johannes@sipsolutions.net>
References: <1364304961-32028-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Handle the (public) extended channel switch announcement
action frames. Parts of the data in these frames isn't
really in IEs, but put it into the elems struct anyway
to simplify the handling.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h |  6 ++++++
 net/mac80211/mlme.c       | 31 +++++++++++++++++++++++++++----
 net/mac80211/rx.c         | 16 ++++++++++++++++
 3 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index a985e67..db1b3a6 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -874,6 +874,11 @@ struct ieee80211_mgmt {
 				} __packed chan_switch;
 				struct{
 					u8 action_code;
+					struct ieee80211_ext_chansw_ie data;
+					u8 variable[0];
+				} __packed ext_chan_switch;
+				struct{
+					u8 action_code;
 					u8 dialog_token;
 					u8 element_id;
 					u8 length;
@@ -1825,6 +1830,7 @@ enum ieee80211_key_len {
 
 /* Public action codes */
 enum ieee80211_pub_actioncode {
+	WLAN_PUB_ACTION_EXT_CHANSW_ANN = 4,
 	WLAN_PUB_ACTION_TDLS_DISCOVER_RES = 14,
 };
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7b99d50..cb0c738 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3154,6 +3154,8 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 	enum rx_mgmt_action rma = RX_MGMT_NONE;
 	u8 deauth_buf[IEEE80211_DEAUTH_FRAME_LEN];
 	u16 fc;
+	struct ieee802_11_elems elems;
+	int ies_len;
 
 	rx_status = (struct ieee80211_rx_status *) skb->cb;
 	mgmt = (struct ieee80211_mgmt *) skb->data;
@@ -3184,10 +3186,9 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 		break;
 	case IEEE80211_STYPE_ACTION:
 		if (mgmt->u.action.category == WLAN_CATEGORY_SPECTRUM_MGMT) {
-			struct ieee802_11_elems elems;
-			int ies_len = skb->len -
-				      offsetof(struct ieee80211_mgmt,
-					       u.action.u.chan_switch.variable);
+			ies_len = skb->len -
+				  offsetof(struct ieee80211_mgmt,
+					   u.action.u.chan_switch.variable);
 
 			if (ies_len < 0)
 				break;
@@ -3202,6 +3203,28 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 			ieee80211_sta_process_chanswitch(sdata,
 							 rx_status->mactime,
 							 &elems);
+		} else if (mgmt->u.action.category == WLAN_CATEGORY_PUBLIC) {
+			ies_len = skb->len -
+				  offsetof(struct ieee80211_mgmt,
+					   u.action.u.ext_chan_switch.variable);
+
+			if (ies_len < 0)
+				break;
+
+			ieee802_11_parse_elems(
+				mgmt->u.action.u.ext_chan_switch.variable,
+				ies_len, &elems);
+
+			if (elems.parse_error)
+				break;
+
+			/* for the handling code pretend this was also an IE */
+			elems.ext_chansw_ie =
+				&mgmt->u.action.u.ext_chan_switch.data;
+
+			ieee80211_sta_process_chanswitch(sdata,
+							 rx_status->mactime,
+							 &elems);
 		}
 		break;
 	}
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ea91262..562ae34 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2452,6 +2452,22 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 		}
 
 		break;
+	case WLAN_CATEGORY_PUBLIC:
+		if (len < IEEE80211_MIN_ACTION_SIZE + 1)
+			goto invalid;
+		if (sdata->vif.type != NL80211_IFTYPE_STATION)
+			break;
+		if (!rx->sta)
+			break;
+		if (!ether_addr_equal(mgmt->bssid, sdata->u.mgd.bssid))
+			break;
+		if (mgmt->u.action.u.ext_chan_switch.action_code !=
+				WLAN_PUB_ACTION_EXT_CHANSW_ANN)
+			break;
+		if (len < offsetof(struct ieee80211_mgmt,
+				   u.action.u.ext_chan_switch.variable))
+			goto invalid;
+		goto queue;
 	case WLAN_CATEGORY_VHT:
 		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 		    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
-- 
1.8.0

