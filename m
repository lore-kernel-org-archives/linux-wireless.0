Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57106 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab1JVNNo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Oct 2011 09:13:44 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt19so5986913bkb.19
        for <linux-wireless@vger.kernel.org>; Sat, 22 Oct 2011 06:13:43 -0700 (PDT)
From: Guy Eilam <guy@wizery.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] mac80211: Save probe response data for BSS
Date: Sat, 22 Oct 2011 15:11:52 +0200
Message-Id: <1319289112-21896-4-git-send-email-guy@wizery.com> (sfid-20111022_151348_585554_7E8B5E20)
In-Reply-To: <1319289112-21896-1-git-send-email-guy@wizery.com>
References: <1319289112-21896-1-git-send-email-guy@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow setting a probe response template for an interface operating in
AP mode. Low level drivers are notified about changes in the probe
response template and are able to retrieve a copy of the current probe
response. This data can, for example, be uploaded to hardware as a
template.

Signed-off-by: Guy Eilam <guy@wizery.com>
---
 include/net/mac80211.h     |   15 +++++++++++++++
 net/mac80211/cfg.c         |   35 +++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/iface.c       |    6 +++++-
 net/mac80211/tx.c          |   31 +++++++++++++++++++++++++++++++
 net/mac80211/util.c        |    3 ++-
 6 files changed, 89 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1c58fd7..050aa32 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -166,6 +166,7 @@ struct ieee80211_low_level_stats {
  *	that it is only ever disabled for station mode.
  * @BSS_CHANGED_IDLE: Idle changed for this BSS/interface.
  * @BSS_CHANGED_SSID: SSID changed for this BSS (AP mode)
+ * @BSS_CHANGED_AP_PROBE_RESP: Probe Response changed for this BSS (AP mode)
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -184,6 +185,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_QOS			= 1<<13,
 	BSS_CHANGED_IDLE		= 1<<14,
 	BSS_CHANGED_SSID		= 1<<15,
+	BSS_CHANGED_AP_PROBE_RESP	= 1<<16,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
@@ -2662,6 +2664,19 @@ static inline struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
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
index 3cdb4a9..e2ad3da 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1230,6 +1230,34 @@ static int ieee80211_leave_mesh(struct wiphy *wiphy, struct net_device *dev)
 }
 #endif
 
+static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
+				    u8 *resp, size_t resp_len)
+{
+	struct sk_buff *new, *old;
+
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
+	return 0;
+}
+
 static int ieee80211_change_bss(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct bss_parameters *params)
@@ -1292,6 +1320,13 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 		changed |= BSS_CHANGED_HT;
 	}
 
+	if (params->probe_resp_len > 0) {
+		int ret = ieee80211_set_probe_resp(sdata, params->probe_resp,
+						   params->probe_resp_len);
+		if (!ret)
+			changed |= BSS_CHANGED_AP_PROBE_RESP;
+	}
+
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	return 0;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9fa5f8a..41f2a9a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -230,6 +230,7 @@ struct beacon_data {
 
 struct ieee80211_if_ap {
 	struct beacon_data __rcu *beacon;
+	struct sk_buff __rcu *probe_resp;
 
 	struct list_head vlans;
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index ef741e8..74d6f79 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -450,15 +450,19 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		struct ieee80211_sub_if_data *vlan, *tmpsdata;
 		struct beacon_data *old_beacon =
 			rtnl_dereference(sdata->u.ap.beacon);
+		struct sk_buff *old_probe_resp =
+			rtnl_dereference(sdata->u.ap.probe_resp);
 
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
 
 		/* down all dependent devices, that is VLANs */
 		list_for_each_entry_safe(vlan, tmpsdata, &sdata->u.ap.vlans,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ad2ee4a..1f077e2 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2414,6 +2414,37 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
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
index 7439d26..d6d3ef4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1085,7 +1085,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			changed |= BSS_CHANGED_IBSS;
 			/* fall through */
 		case NL80211_IFTYPE_AP:
-			changed |= BSS_CHANGED_SSID;
+			changed |= BSS_CHANGED_SSID |
+				   BSS_CHANGED_AP_PROBE_RESP;
 			/* fall through */
 		case NL80211_IFTYPE_MESH_POINT:
 			changed |= BSS_CHANGED_BEACON |
-- 
1.7.4.1

