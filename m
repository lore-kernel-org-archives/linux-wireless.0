Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59443 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759429Ab1LPO3A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 09:29:00 -0500
Subject: [PATCH] mac80211: handle SMPS action frames
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Dec 2011 15:28:57 +0100
Message-ID: <1324045737.3429.4.camel@jlt3.sipsolutions.net> (sfid-20111216_152905_976850_C459601F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a peer changes SMPS state we should update
rate control so it doesn't have to detect it by
itself. It can't detect "dynamic" mode anyway
since that just requires rts-cts handshaking.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |    5 +++-
 net/mac80211/rx.c      |   58 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+), 1 deletion(-)

--- a/include/net/mac80211.h	2011-12-16 15:05:19.000000000 +0100
+++ b/include/net/mac80211.h	2011-12-16 15:05:24.000000000 +0100
@@ -3502,9 +3502,12 @@ void ieee80211_send_bar(struct ieee80211
  *
  * @IEEE80211_RC_HT_CHANGED: The HT parameters of the operating channel have
  *	changed, rate control algorithm can update its internal state if needed.
+ * @IEEE80211_RC_SMPS_CHANGED: The SMPS state of the station changed, the rate
+ *	control algorithm needs to adjust accordingly.
  */
 enum rate_control_changed {
-	IEEE80211_RC_HT_CHANGED = BIT(0)
+	IEEE80211_RC_HT_CHANGED		= BIT(0),
+	IEEE80211_RC_SMPS_CHANGED	= BIT(1),
 };
 
 /**
--- a/net/mac80211/rx.c	2011-12-16 15:05:19.000000000 +0100
+++ b/net/mac80211/rx.c	2011-12-16 15:27:49.000000000 +0100
@@ -28,6 +28,7 @@
 #include "wpa.h"
 #include "tkip.h"
 #include "wme.h"
+#include "rate.h"
 
 /*
  * monitor mode reception
@@ -2233,6 +2234,63 @@ ieee80211_rx_h_action(struct ieee80211_r
 		return RX_DROP_UNUSABLE;
 
 	switch (mgmt->u.action.category) {
+	case WLAN_CATEGORY_HT:
+		/* reject HT action frames from stations not supporting HT */
+		if (!rx->sta->sta.ht_cap.ht_supported)
+			goto invalid;
+
+		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
+		    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
+		    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
+		    sdata->vif.type != NL80211_IFTYPE_AP &&
+		    sdata->vif.type != NL80211_IFTYPE_ADHOC)
+			break;
+
+		/* verify action & smps_control are present */
+		if (len < IEEE80211_MIN_ACTION_SIZE + 2)
+			goto invalid;
+
+		switch (mgmt->u.action.u.ht_smps.action) {
+		case WLAN_HT_ACTION_SMPS: {
+			struct ieee80211_supported_band *sband;
+			u8 smps;
+
+			/* convert to HT capability */
+			switch (mgmt->u.action.u.ht_smps.smps_control) {
+			case WLAN_HT_SMPS_CONTROL_DISABLED:
+				smps = WLAN_HT_CAP_SM_PS_DISABLED;
+				break;
+			case WLAN_HT_SMPS_CONTROL_STATIC:
+				smps = WLAN_HT_CAP_SM_PS_STATIC;
+				break;
+			case WLAN_HT_SMPS_CONTROL_DYNAMIC:
+				smps = WLAN_HT_CAP_SM_PS_DYNAMIC;
+				break;
+			default:
+				goto invalid;
+			}
+			smps <<= IEEE80211_HT_CAP_SM_PS_SHIFT;
+
+			/* if no change do nothing */
+			if ((rx->sta->sta.ht_cap.cap &
+					IEEE80211_HT_CAP_SM_PS) == smps)
+				goto handled;
+
+			rx->sta->sta.ht_cap.cap &= ~IEEE80211_HT_CAP_SM_PS;
+			rx->sta->sta.ht_cap.cap |= smps;
+
+			sband = rx->local->hw.wiphy->bands[status->band];
+
+			rate_control_rate_update(local, sband, rx->sta,
+						 IEEE80211_RC_SMPS_CHANGED,
+						 local->_oper_channel_type);
+			goto handled;
+		}
+		default:
+			goto invalid;
+		}
+
+		break;
 	case WLAN_CATEGORY_BACK:
 		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 		    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&


