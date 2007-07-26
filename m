Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24253 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757329AbXGZQAo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 12:00:44 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/2] mac80211 [HT] 802.11 code compiles under CONFIG_MAC80211_HT
Date: Thu, 26 Jul 2007 19:00:40 +0300
Message-Id: <11854656403581-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <11854656402369-git-send-email-tomas.winkler@intel.com>
References: <11854656402369-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch provides compilation of 802.11n HT features under
CONFIG_MAC80211_HT

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/net/mac80211.h       |   11 +++++++----
 net/mac80211/ieee80211_sta.c |   10 ++++++++--
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 405ce2a..17a4dd7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -722,16 +722,17 @@ struct ieee80211_ops {
 	 * Must be atomic. */
 	u64 (*get_tsf)(struct ieee80211_hw *hw);
 
-	/* Call low level driver with 11n Block Ack action */
-	int (*handle_ba_action)(struct ieee80211_hw *hw,
-				struct ieee80211_mgmt *mgmt);
-
 	/* Reset the TSF timer and allow firmware/hardware to synchronize with
 	 * other STAs in the IBSS. This is only used in IBSS mode. This
 	 * function is optional if the firmware/hardware takes full care of
 	 * TSF synchronization. */
 	void (*reset_tsf)(struct ieee80211_hw *hw);
 
+#ifdef CONFIG_MAC80211_HT
+	/* Call low level driver with 11n Block Ack action */
+	int (*handle_ba_action)(struct ieee80211_hw *hw,
+				struct ieee80211_mgmt *mgmt);
+
 	/* Configure ht parameters. */
 	int (*conf_ht)(struct ieee80211_hw *hw,
 		       struct ieee80211_ht_capability *ht_cap_param,
@@ -741,6 +742,8 @@ struct ieee80211_ops {
 	void (*get_ht_capab)(struct ieee80211_hw *hw,
 			     struct ieee80211_ht_capability *ht_cap_param);
 
+#endif /* CONFIG_MAC80211_HT */
+
 	/* Setup beacon data for IBSS beacons. Unlike access point (Master),
 	 * IBSS uses a fixed beacon frame which is configured using this
 	 * function. This handler is required only for IBSS mode. */
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 8296c0c..fe8296d 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -686,6 +686,7 @@ static void ieee80211_send_assoc(struct net_device *dev,
 		*pos++ = 0;
 	}
 
+#ifdef CONFIG_MAC80211_HT
 	/* if low level driver supports 11n, fill in 11n IE */
 	if (ht_enabled && ifsta->ht_enabled && local->ops->get_ht_capab) {
 		pos = skb_put(skb, sizeof(struct ieee80211_ht_capability)+2);
@@ -695,6 +696,7 @@ static void ieee80211_send_assoc(struct net_device *dev,
 		local->ops->get_ht_capab(local_to_hw(local),
 			(struct ieee80211_ht_capability *)pos);
 	}
+#endif /* CONFIG_MAC80211_HT */
 
 	kfree(ifsta->assocreq_ies);
 	ifsta->assocreq_ies_len = (skb->data + skb->len) - ies;
@@ -1740,7 +1742,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
 				rates |= BIT(j);
 	}
 	sta->supp_rates = rates;
-
+#ifdef CONFIG_MAC80211_HT
 	if (elems.ht_extra_param && elems.ht_cap_param && elems.wmm_param &&
 	    ifsta->ht_enabled && local->ops->conf_ht){
 		int rc;
@@ -1754,6 +1756,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct net_device *dev,
 			sta->flags |= WLAN_STA_HT;
 	}
 
+#endif	/* CONFIG_MAC80211_HT */
 
 	rate_control_rate_init(sta, local);
 
@@ -2516,6 +2519,7 @@ static void ieee80211_rx_mgmt_probe_req(struct net_device *dev,
 	ieee80211_sta_tx(dev, skb, 0);
 }
 
+#ifdef CONFIG_MAC80211_HT
 static void ieee80211_send_addba_resp(struct net_device *dev,
 				      struct ieee80211_mgmt *mgmt_src,
 				      size_t len,
@@ -2558,6 +2562,7 @@ static void ieee80211_send_addba_resp(struct net_device *dev,
 
 	return;
 }
+#endif /* CONFIG_MAC80211_HT */
 
 static void ieee80211_rx_mgmt_action(struct net_device *dev,
 				     struct ieee80211_if_sta *ifsta,
@@ -2640,6 +2645,7 @@ static void ieee80211_rx_mgmt_action(struct net_device *dev,
 		}
 		break;
 
+#ifdef CONFIG_MAC80211_HT
 	case WLAN_CATEGORY_BACK:
 		switch (mgmt->u.action.u.addba_req.action_code) {
 		case WLAN_ACTION_ADDBA_REQ:
@@ -2677,7 +2683,7 @@ static void ieee80211_rx_mgmt_action(struct net_device *dev,
 			break;
 		}
 		break;
-
+#endif /* CONFIG_MAC80211_HT */
 	default:
 		break;
 	}
-- 
1.5.2.2
