Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50392 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2L0R7H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 12:59:07 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 3/3] mac80211: handle operating mode notification action
Date: Thu, 27 Dec 2012 18:59:27 +0100
Message-Id: <1356631167-15192-4-git-send-email-johannes@sipsolutions.net> (sfid-20121227_185920_241154_3FE0E50D)
In-Reply-To: <1356631167-15192-1-git-send-email-johannes@sipsolutions.net>
References: <1356631167-15192-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Handle the operating mode notification action frame.
When the supported streams change, let the driver and
rate control algorithm know.

INCOMPLETE - need to handle bandwidth changes

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |  3 +++
 net/mac80211/rx.c      | 42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5bc6459..66a8b0a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2072,11 +2072,14 @@ enum ieee80211_frame_release_type {
  * @IEEE80211_RC_SUPP_RATES_CHANGED: The supported rate set of this peer
  *	changed (in IBSS mode) due to discovering more information about
  *	the peer.
+ * @IEEE80211_RC_NSS_CHANGED: N_SS (number of spatial streams) was changed
+ *	by the peer, using an operating mode notification
  */
 enum ieee80211_rate_control_changed {
 	IEEE80211_RC_BW_CHANGED		= BIT(0),
 	IEEE80211_RC_SMPS_CHANGED	= BIT(1),
 	IEEE80211_RC_SUPP_RATES_CHANGED	= BIT(2),
+	IEEE80211_RC_NSS_CHANGED	= BIT(3),
 };
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 580704e..e863190 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2397,6 +2397,48 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 		}
 
 		break;
+	case WLAN_CATEGORY_VHT:
+		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
+		    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
+		    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
+		    sdata->vif.type != NL80211_IFTYPE_AP &&
+		    sdata->vif.type != NL80211_IFTYPE_ADHOC)
+			break;
+
+		/* verify action code and one more byte (opmode) are present */
+		if (len < IEEE80211_MIN_ACTION_SIZE + 2)
+			goto invalid;
+
+		switch (mgmt->u.action.u.vht_opmode_notif.action_code) {
+		case WLAN_VHT_ACTION_OPMODE_NOTIF: {
+			struct ieee80211_supported_band *sband;
+			u8 opmode = mgmt->u.action.u.vht_opmode_notif.operating_mode;
+			u8 nss;
+
+			/* ignore - no support for BF yet */
+			if (opmode & IEEE80211_VHT_OPMODE_RX_NSS_TYPE_BF)
+				goto handled;
+
+			nss = opmode & IEEE80211_VHT_OPMODE_RX_NSS_MASK;
+			nss >>= IEEE80211_VHT_OPMODE_RX_NSS_SHIFT;
+
+			/* if no change do nothing */
+			if (rx->sta->sta.rx_nss == nss)
+				goto handled;
+			rx->sta->sta.rx_nss = nss;
+
+			/* TODO: handle bandwidth */
+
+			sband = rx->local->hw.wiphy->bands[status->band];
+
+			rate_control_rate_update(local, sband, rx->sta,
+						 IEEE80211_RC_NSS_CHANGED);
+			goto handled;
+		}
+		default:
+			goto invalid;
+		}
+		break;
 	case WLAN_CATEGORY_BACK:
 		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 		    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
-- 
1.8.0

