Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:3883 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758665AbXLQP6E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 10:58:04 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 7/8] mac80211: A-MPDU Rx handling DELBA requests
Date: Mon, 17 Dec 2007 17:57:48 +0200
Message-Id: <11979070791111-git-send-email-ron.rindjunsky@intel.com> (sfid-20071217_155808_430342_1644CE29)
In-Reply-To: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch opens the flow to DELBA management frames, and handles end
of A-MPDU session produced by this event.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/ieee80211_sta.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 39 insertions(+), 1 deletions(-)

Index: wl2_6_24_rc3_Rx_Agg/net/mac80211/ieee80211_sta.c
===================================================================
--- wl2_6_24_rc3_Rx_Agg.orig/net/mac80211/ieee80211_sta.c
+++ wl2_6_24_rc3_Rx_Agg/net/mac80211/ieee80211_sta.c
@@ -63,6 +63,8 @@
 #define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
 #define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
 #define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFA0
+#define IEEE80211_DELBA_PARAM_TID_MASK 0xF000
+#define IEEE80211_DELBA_PARAM_INITIATOR_MASK 0x0800
 
 #define IEEE80211_MIN_AMPDU_BUF 0x8
 #define IEEE80211_MAX_AMPDU_BUF 0x40
@@ -1274,6 +1276,36 @@ void ieee80211_sta_stop_rx_BA_session(st
 	sta_info_put(sta);
 }
 
+static void ieee80211_sta_process_delba(struct net_device *dev,
+			struct ieee80211_mgmt *mgmt, size_t len)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sta_info *sta;
+	u16 tid, params;
+	u16 initiator;
+	DECLARE_MAC_BUF(mac);
+
+	sta = sta_info_get(local, mgmt->sa);
+	if (!sta)
+		return;
+
+	params = le16_to_cpu(mgmt->u.action.u.delba.params);
+	tid = (params & IEEE80211_DELBA_PARAM_TID_MASK) >> 12;
+	initiator = (params & IEEE80211_DELBA_PARAM_INITIATOR_MASK) >> 11;
+
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	if (net_ratelimit())
+		printk(KERN_DEBUG "delba from %s on tid %d reason code %d\n",
+			print_mac(mac, mgmt->sa), tid,
+			mgmt->u.action.u.delba.reason_code);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+
+	if (initiator == WLAN_BACK_INITIATOR)
+		ieee80211_sta_stop_rx_BA_session(dev, sta->addr, tid,
+						 WLAN_BACK_INITIATOR, 0);
+	sta_info_put(sta);
+}
+
 /*
  * After receiving Block Ack Request (BAR) we activated a
  * timer after each frame arrives from the originator.
@@ -2234,9 +2266,15 @@ void ieee80211_rx_mgmt_action(struct net
 				break;
 			ieee80211_sta_process_addba_request(dev, mgmt, len);
 			break;
+		case WLAN_ACTION_DELBA:
+			if (len < (IEEE80211_MIN_ACTION_SIZE +
+				   sizeof(mgmt->u.action.u.delba)))
+				break;
+			ieee80211_sta_process_delba(dev, mgmt, len);
+			break;
 		default:
 			if (net_ratelimit())
-			   printk(KERN_DEBUG "%s: received unsupported BACK\n",
+			   printk(KERN_DEBUG "%s: Rx unknown A-MPDU action\n",
 					dev->name);
 			break;
 		}
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

