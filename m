Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:34025 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752547AbZAGL2D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 06:28:03 -0500
Message-Id: <20090107112650.614383765@atheros.com> (sfid-20090107_122809_147995_476FE5F5)
References: <20090107112346.369581673@atheros.com>
Date: Wed, 07 Jan 2009 13:23:54 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 08/14] mac80211: 802.11w - SA Query processing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Process SA Query Requests for client mode in mac80211. AP side
processing of SA Query Response frames is in user space (hostapd).

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


---
 include/linux/ieee80211.h |   14 +++++++++
 net/mac80211/rx.c         |   69 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+)

--- wireless-testing.orig/include/linux/ieee80211.h	2009-01-07 13:07:49.000000000 +0200
+++ wireless-testing/include/linux/ieee80211.h	2009-01-07 13:07:59.000000000 +0200
@@ -527,6 +527,8 @@ struct ieee80211_tim_ie {
 	u8 virtual_map[0];
 } __attribute__ ((packed));
 
+#define WLAN_SA_QUERY_TR_ID_LEN 16
+
 struct ieee80211_mgmt {
 	__le16 frame_control;
 	__le16 duration;
@@ -646,6 +648,10 @@ struct ieee80211_mgmt {
 					u8 action_code;
 					u8 variable[0];
 				} __attribute__((packed)) mesh_action;
+				struct {
+					u8 action;
+					u8 trans_id[WLAN_SA_QUERY_TR_ID_LEN];
+				} __attribute__ ((packed)) sa_query;
 			} u;
 		} __attribute__ ((packed)) action;
 	} u;
@@ -1041,6 +1047,7 @@ enum ieee80211_category {
 	WLAN_CATEGORY_DLS = 2,
 	WLAN_CATEGORY_BACK = 3,
 	WLAN_CATEGORY_PUBLIC = 4,
+	WLAN_CATEGORY_SA_QUERY = 8,
 	WLAN_CATEGORY_WMM = 17,
 };
 
@@ -1129,6 +1136,13 @@ enum ieee80211_back_parties {
 	WLAN_BACK_TIMER = 2,
 };
 
+/* SA Query action */
+enum ieee80211_sa_query_action {
+	WLAN_ACTION_SA_QUERY_REQUEST = 0,
+	WLAN_ACTION_SA_QUERY_RESPONSE = 1,
+};
+
+
 /* A-MSDU 802.11n */
 #define IEEE80211_QOS_CONTROL_A_MSDU_PRESENT 0x0080
 
--- wireless-testing.orig/net/mac80211/rx.c	2009-01-07 13:07:49.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2009-01-07 13:07:59.000000000 +0200
@@ -1635,6 +1635,57 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_
 	return RX_CONTINUE;
 }
 
+void ieee80211_process_sa_query_req(struct ieee80211_sub_if_data *sdata,
+				    struct ieee80211_mgmt *mgmt,
+				    size_t len)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *resp;
+
+	if (compare_ether_addr(mgmt->da, sdata->dev->dev_addr) != 0) {
+		/* Not to own unicast address */
+		return;
+	}
+
+	if (compare_ether_addr(mgmt->sa, sdata->u.sta.bssid) != 0 ||
+	    compare_ether_addr(mgmt->bssid, sdata->u.sta.bssid) != 0) {
+		/* Not from the current AP. */
+		return;
+	}
+
+	if (sdata->u.sta.state == IEEE80211_STA_MLME_ASSOCIATE) {
+		/* Association in progress; ignore SA Query */
+		return;
+	}
+
+	if (len < 24 + 1 + sizeof(resp->u.action.u.sa_query)) {
+		/* Too short SA Query request frame */
+		return;
+	}
+
+	skb = dev_alloc_skb(sizeof(*resp) + local->hw.extra_tx_headroom);
+	if (skb == NULL)
+		return;
+
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	resp = (struct ieee80211_mgmt *) skb_put(skb, 24);
+	memset(resp, 0, 24);
+	memcpy(resp->da, mgmt->sa, ETH_ALEN);
+	memcpy(resp->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(resp->bssid, sdata->u.sta.bssid, ETH_ALEN);
+	resp->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_ACTION);
+	skb_put(skb, 1 + sizeof(resp->u.action.u.sa_query));
+	resp->u.action.category = WLAN_CATEGORY_SA_QUERY;
+	resp->u.action.u.sa_query.action = WLAN_ACTION_SA_QUERY_RESPONSE;
+	memcpy(resp->u.action.u.sa_query.trans_id,
+	       mgmt->u.action.u.sa_query.trans_id,
+	       WLAN_SA_QUERY_TR_ID_LEN);
+
+	ieee80211_tx_skb(sdata, skb, 1);
+}
+
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 {
@@ -1708,6 +1759,24 @@ ieee80211_rx_h_action(struct ieee80211_r
 			break;
 		}
 		break;
+	case WLAN_CATEGORY_SA_QUERY:
+		if (len < (IEEE80211_MIN_ACTION_SIZE +
+			   sizeof(mgmt->u.action.u.sa_query)))
+			return RX_DROP_MONITOR;
+		switch (mgmt->u.action.u.sa_query.action) {
+		case WLAN_ACTION_SA_QUERY_REQUEST:
+			if (sdata->vif.type != NL80211_IFTYPE_STATION)
+				return RX_DROP_MONITOR;
+			ieee80211_process_sa_query_req(sdata, mgmt, len);
+			break;
+		case WLAN_ACTION_SA_QUERY_RESPONSE:
+			/*
+			 * SA Query response is currently only used in AP mode
+			 * and it is processed in user space.
+			 */
+			return RX_CONTINUE;
+		}
+		break;
 	default:
 		return RX_CONTINUE;
 	}

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
