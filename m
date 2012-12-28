Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53058 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab2L1LOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2012 06:14:37 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: support HT notify channel width action
Date: Fri, 28 Dec 2012 12:14:59 +0100
Message-Id: <1356693299-12143-1-git-send-email-johannes@sipsolutions.net> (sfid-20121228_121444_315212_961A27CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Support the HT notify channel width action frame
to update the rate scaling about the bandwidth
the peer can receive in.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h |  9 +++++++++
 net/mac80211/rx.c         | 31 ++++++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index d827f2f..afe237b 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -713,6 +713,11 @@ enum ieee80211_rann_flags {
 	RANN_FLAG_IS_GATE = 1 << 0,
 };
 
+enum ieee80211_ht_chanwidth_values {
+	IEEE80211_HT_CHANWIDTH_20MHZ = 0,
+	IEEE80211_HT_CHANWIDTH_ANY = 1,
+};
+
 #define WLAN_SA_QUERY_TR_ID_LEN 2
 
 struct ieee80211_mgmt {
@@ -835,6 +840,10 @@ struct ieee80211_mgmt {
 				} __packed ht_smps;
 				struct {
 					u8 action_code;
+					u8 chanwidth;
+				} __packed ht_notify_cw;
+				struct {
+					u8 action_code;
 					u8 dialog_token;
 					__le16 capability;
 					u8 variable[0];
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 580704e..a190895 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2353,7 +2353,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 		    sdata->vif.type != NL80211_IFTYPE_ADHOC)
 			break;
 
-		/* verify action & smps_control are present */
+		/* verify action & smps_control/chanwidth are present */
 		if (len < IEEE80211_MIN_ACTION_SIZE + 2)
 			goto invalid;
 
@@ -2392,6 +2392,35 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 						 IEEE80211_RC_SMPS_CHANGED);
 			goto handled;
 		}
+		case WLAN_HT_ACTION_NOTIFY_CHANWIDTH: {
+			struct ieee80211_supported_band *sband;
+			u8 chanwidth = mgmt->u.action.u.ht_notify_cw.chanwidth;
+			bool old_40mhz, new_40mhz;
+
+			/* If it doesn't support 40 MHz it can't change ... */
+			if (!rx->sta->supports_40mhz)
+				goto handled;
+
+			old_40mhz = rx->sta->sta.ht_cap.cap &
+					IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			new_40mhz = chanwidth == IEEE80211_HT_CHANWIDTH_ANY;
+
+			if (old_40mhz == new_40mhz)
+				goto handled;
+
+			if (new_40mhz)
+				rx->sta->sta.ht_cap.cap |=
+					IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			else
+				rx->sta->sta.ht_cap.cap &=
+					~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+
+			sband = rx->local->hw.wiphy->bands[status->band];
+
+			rate_control_rate_update(local, sband, rx->sta,
+						 IEEE80211_RC_BW_CHANGED);
+			goto handled;
+		}
 		default:
 			goto invalid;
 		}
-- 
1.8.0

