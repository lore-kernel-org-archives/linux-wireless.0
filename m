Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65238 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab1AWVDQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 16:03:16 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so3406578fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 23 Jan 2011 13:03:15 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 4/6] mac80211: Save probe response data for BSS
Date: Sun, 23 Jan 2011 23:02:57 +0200
Message-Id: <1295816579-28925-5-git-send-email-arik@wizery.com>
In-Reply-To: <1295816579-28925-1-git-send-email-arik@wizery.com>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow setting a probe response template for an interface operating in
AP mode. Low level drivers are notified about changes in the probe
response template and are able to retrieve a copy of the current probe
response. This data can, for example, be uploaded to hardware as a
template.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/net/mac80211.h     |   15 +++++++++++++++
 net/mac80211/cfg.c         |   33 +++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/iface.c       |    5 ++++-
 net/mac80211/tx.c          |   31 +++++++++++++++++++++++++++++++
 net/mac80211/util.c        |    3 ++-
 6 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ff3bad1..55c48a1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -165,6 +165,7 @@ struct ieee80211_low_level_stats {
  *	that it is only ever disabled for station mode.
  * @BSS_CHANGED_IDLE: Idle changed for this BSS/interface.
  * @BSS_CHANGED_SSID: SSID changed for this BSS (AP mode)
+ * @BSS_CHANGED_AP_PROBE_RESP: Probe Response changed for this BSS (AP mode)
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -183,6 +184,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_QOS			= 1<<13,
 	BSS_CHANGED_IDLE		= 1<<14,
 	BSS_CHANGED_SSID		= 1<<15,
+	BSS_CHANGED_AP_PROBE_RESP	= 1<<16,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
@@ -2220,6 +2222,19 @@ static inline struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
 }
 
 /**
+ * ieee80211_proberesp_get - retrieve a Probe Response template
+ * @hw: pointer obtained from ieee80211_alloc_hw().
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ *
+ * Creates a Probe Response template which can, for example, be uploaded to
+ * hardware. The destination address should be set by the caller.
+ *
+ * Can only be called in AP mode.
+ */
+struct sk_buff *ieee80211_proberesp_get(struct ieee80211_hw *hw,
+					struct ieee80211_vif *vif);
+
+/**
  * ieee80211_pspoll_get - retrieve a PS Poll template
  * @hw: pointer obtained from ieee80211_alloc_hw().
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a2a75e9..834de52 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1944,6 +1944,38 @@ static int ieee80211_get_antenna(struct wiphy *wiphy, u32 *tx_ant, u32 *rx_ant)
 	return drv_get_antenna(local, tx_ant, rx_ant);
 }
 
+static int ieee80211_set_probe_resp(struct wiphy *wiphy,
+				    struct net_device *dev, u8 *resp,
+				    size_t resp_len)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct sk_buff *new, *old;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	old = sdata->u.ap.probe_resp;
+
+	if (!resp || !resp_len)
+		return -EINVAL;
+
+	new = dev_alloc_skb(resp_len);
+	if (!new) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer for probe "
+		       "response template\n", sdata->name);
+		return -ENOMEM;
+	}
+
+	memcpy(skb_put(new, resp_len), resp, resp_len);
+
+	rcu_assign_pointer(sdata->u.ap.probe_resp, new);
+	synchronize_rcu();
+
+	if (old)
+		dev_kfree_skb(old);
+
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_AP_PROBE_RESP);
+	return 0;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -2001,4 +2033,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.mgmt_frame_register = ieee80211_mgmt_frame_register,
 	.set_antenna = ieee80211_set_antenna,
 	.get_antenna = ieee80211_get_antenna,
+	.set_probe_resp = ieee80211_set_probe_resp,
 };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c47d7c0..4513cc5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -215,6 +215,7 @@ struct beacon_data {
 
 struct ieee80211_if_ap {
 	struct beacon_data *beacon;
+	struct sk_buff *probe_resp;
 
 	struct list_head vlans;
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 8acba45..7795778 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -449,15 +449,18 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
 		struct ieee80211_sub_if_data *vlan, *tmpsdata;
 		struct beacon_data *old_beacon = sdata->u.ap.beacon;
+		struct sk_buff *old_probe_resp = sdata->u.ap.probe_resp;
 
 		/* sdata_running will return false, so this will disable */
 		ieee80211_bss_info_change_notify(sdata,
 						 BSS_CHANGED_BEACON_ENABLED);
 
-		/* remove beacon */
+		/* remove beacon and probe response */
 		rcu_assign_pointer(sdata->u.ap.beacon, NULL);
+		rcu_assign_pointer(sdata->u.ap.probe_resp, NULL);
 		synchronize_rcu();
 		kfree(old_beacon);
+		kfree(old_probe_resp);
 
 		/* free all potentially still buffered bcast frames */
 		while ((skb = skb_dequeue(&sdata->u.ap.ps_bc_buf))) {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5950e3a..ef182c9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2359,6 +2359,37 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_beacon_get_tim);
 
+struct sk_buff *ieee80211_proberesp_get(struct ieee80211_hw *hw,
+					struct ieee80211_vif *vif)
+{
+	struct ieee80211_if_ap *ap = NULL;
+	struct sk_buff *presp = NULL, *skb = NULL;
+	struct ieee80211_hdr *hdr;
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	if (sdata->vif.type != NL80211_IFTYPE_AP)
+		return NULL;
+
+	rcu_read_lock();
+
+	ap = &sdata->u.ap;
+	presp = rcu_dereference(ap->probe_resp);
+	if (!presp)
+		goto out;
+
+	skb = skb_copy(presp, GFP_ATOMIC);
+	if (!skb)
+		goto out;
+
+	hdr = (struct ieee80211_hdr *) skb->data;
+	memset(hdr->addr1, 0, sizeof(hdr->addr1));
+
+out:
+	rcu_read_unlock();
+	return skb;
+}
+EXPORT_SYMBOL(ieee80211_proberesp_get);
+
 struct sk_buff *ieee80211_pspoll_get(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif)
 {
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index a2d2f73..59a7b61 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1213,7 +1213,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			ieee80211_bss_info_change_notify(sdata, changed);
 			break;
 		case NL80211_IFTYPE_AP:
-			changed |= BSS_CHANGED_SSID |
+			changed |= BSS_CHANGED_AP_PROBE_RESP |
+				   BSS_CHANGED_SSID |
 				   BSS_CHANGED_BEACON |
 				   BSS_CHANGED_BEACON_ENABLED;
 			ieee80211_bss_info_change_notify(sdata, changed);
-- 
1.7.1

