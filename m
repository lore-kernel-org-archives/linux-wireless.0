Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:9233 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938AbYI3UHb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 16:07:31 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/2 V2] mac80211: send action frame when toggling SM PS mode
Date: Tue, 30 Sep 2008 23:07:24 +0300
Message-Id: <1222805245-31166-1-git-send-email-tomas.winkler@intel.com> (sfid-20080930_220735_828942_44BB6C98)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch makes mac80211 able to send action frames when toggling
(SM PS) Spacial Multiplexing Power Save mode.

Examples:
1.
A driver in order to lower power consumption may choose to close some of RX chains
in PS mode and needs to announce to AP that a RTS frame is need in order to wake all
RX chains (SM_PS_DYNAMIC), on other hand SM PS can be disabled in CAM mode or if HW is able
to wake all chains without RTS frame and thus reducing traffic overhead.

2.
iwlwifi can call this function when it detects that only
one antenna can effectively receive then SM PS mode is set to STATIC and
AP is asked not to send MIMO rates packets at all.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/linux/ieee80211.h |   14 +++++++-
 include/net/mac80211.h    |   10 ++++++
 net/mac80211/ht.c         |   79 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 102 insertions(+), 1 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 14126bc..d0bd612 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -623,6 +623,10 @@ struct ieee80211_mgmt {
 				} __attribute__((packed)) addba_resp;
 				struct{
 					u8 action_code;
+					u8 ps_ctrl;
+				} __attribute__((packed)) sm_ps;
+				struct{
+					u8 action_code;
 					__le16 params;
 					__le16 reason_code;
 				} __attribute__((packed)) delba;
@@ -759,12 +763,14 @@ struct ieee80211_ht_addt_info {
 #define IEEE80211_MIN_AMPDU_BUF 0x8
 #define IEEE80211_MAX_AMPDU_BUF 0x40
 
-
 /* Spatial Multiplexing Power Save Modes */
 #define WLAN_HT_CAP_SM_PS_STATIC	0
 #define WLAN_HT_CAP_SM_PS_DYNAMIC	1
 #define WLAN_HT_CAP_SM_PS_INVALID	2
 #define WLAN_HT_CAP_SM_PS_DISABLED	3
+/* Spatial Multiplexing control bits */
+#define IEEE80211_SM_PS_ENABLE  0x1
+#define IEEE80211_SM_PS_DYNAMIC 0x2
 
 /* Authentication algorithms */
 #define WLAN_AUTH_OPEN 0
@@ -964,6 +970,7 @@ enum ieee80211_category {
 	WLAN_CATEGORY_QOS = 1,
 	WLAN_CATEGORY_DLS = 2,
 	WLAN_CATEGORY_BACK = 3,
+	WLAN_CATEGORY_HT = 7,
 	WLAN_CATEGORY_WMM = 17,
 };
 
@@ -976,6 +983,11 @@ enum ieee80211_spectrum_mgmt_actioncode {
 	WLAN_ACTION_SPCT_CHL_SWITCH = 4,
 };
 
+/* HT action code */
+enum ieee80211_ht_actioncode {
+	WLAN_ACTION_SM_PS = 1,
+};
+
 /* BACK action code */
 enum ieee80211_back_actioncode {
 	WLAN_ACTION_ADDBA_REQ = 0,
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f5f5b1f..f15e495 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1868,4 +1868,14 @@ rate_lowest_index(struct ieee80211_supported_band *sband,
 int ieee80211_rate_control_register(struct rate_control_ops *ops);
 void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
 
+/**
+ * ieee80211_send_sm_ps_update - send SM Power Save Action frame
+ * @hw: pointer as obtained from ieee80211_alloc_hw().
+ * @new_mode: new SM Power Save mode WLAN_HT_CAP_SM_PS_*
+ *
+ * This function must be called by low level driver to inform AP about change
+ * in SM Power Save state.
+ */
+void ieee80211_sm_ps_update(struct ieee80211_hw *hw, u8 new_mode);
+
 #endif /* MAC80211_H */
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index dc7d9a3..e468137 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -990,3 +990,82 @@ void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
 					     WLAN_BACK_RECIPIENT);
 	}
 }
+
+static void ieee80211_send_sm_ps(struct ieee80211_sub_if_data *sdata, u8 mode)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_mgmt *mgmt;
+	struct sk_buff *skb;
+	DECLARE_MAC_BUF(mac);
+
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct net_device *dev = sdata->dev;
+
+	/* Implemented for STA only */
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return;
+
+	skb = dev_alloc_skb(sizeof(*mgmt) +
+		local->hw.extra_tx_headroom);
+
+	if (!skb) {
+		printk(KERN_ERR "%s: failed to allocate buffer "
+			"for SM_PS frame\n", dev->name);
+		return;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
+	memset(mgmt, 0, 24);
+	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
+	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					IEEE80211_STYPE_ACTION);
+
+	skb_put(skb, 1 + sizeof(mgmt->u.action.u.sm_ps));
+
+	mgmt->u.action.category = WLAN_CATEGORY_HT;
+	mgmt->u.action.u.sm_ps.action_code = WLAN_ACTION_SM_PS;
+
+	switch (mode) {
+
+	case  WLAN_HT_CAP_SM_PS_DISABLED:
+		mgmt->u.action.u.sm_ps.ps_ctrl &=
+			~(IEEE80211_SM_PS_ENABLE |
+			  IEEE80211_SM_PS_DYNAMIC);
+		break;
+	case  WLAN_HT_CAP_SM_PS_DYNAMIC:
+		mgmt->u.action.u.sm_ps.ps_ctrl |=
+			IEEE80211_SM_PS_ENABLE |
+			IEEE80211_SM_PS_DYNAMIC;
+		break;
+	case  WLAN_HT_CAP_SM_PS_STATIC:
+		mgmt->u.action.u.sm_ps.ps_ctrl |=
+			IEEE80211_SM_PS_ENABLE;
+		mgmt->u.action.u.sm_ps.ps_ctrl &=
+			~IEEE80211_SM_PS_DYNAMIC;
+		break;
+	default:
+		printk(KERN_DEBUG "%s: invalid power save mode\n",
+				dev->name);
+		WARN_ON(1);
+	}
+
+	if (ifsta->flags & IEEE80211_STA_ASSOCIATED)
+		ieee80211_tx_skb(sdata, skb, 0);
+}
+
+void ieee80211_sm_ps_update(struct ieee80211_hw *hw, u8 new_mode)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		ieee80211_send_sm_ps(sdata, new_mode);
+	}
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(ieee80211_sm_ps_update);
+
-- 
1.5.4.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

