Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59695 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab1KHOfk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 09:35:40 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so395520eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 06:35:39 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v3 3/3] mac80211: Save probe response data for bss
Date: Tue,  8 Nov 2011 16:35:28 +0200
Message-Id: <1320762928-6782-3-git-send-email-arik@wizery.com> (sfid-20111108_153544_445902_727117EB)
In-Reply-To: <1320762928-6782-1-git-send-email-arik@wizery.com>
References: <1320762928-6782-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow setting a probe response template for an interface operating in
AP mode. Low level drivers are notified about changes in the probe
response template and are able to retrieve a copy of the current probe
response. This data can, for example, be uploaded to hardware as a
template.

Signed-off-by: Guy Eilam <guy@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v1->3:
save the probe response in mac80211 when configuring the new beacon,
not part of a BSS change.

include/net/mac80211.h     |   15 +++++++++++++++
 net/mac80211/cfg.c         |   44 +++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/iface.c       |    6 +++++-
 net/mac80211/tx.c          |   31 +++++++++++++++++++++++++++++++
 net/mac80211/util.c        |    3 ++-
 6 files changed, 95 insertions(+), 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 72eddd1..0f1d784 100644
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
@@ -2661,6 +2663,19 @@ static inline struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
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
index a9ded52..a06e695 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -488,6 +488,37 @@ static void ieee80211_config_ap_ssid(struct ieee80211_sub_if_data *sdata,
 		(params->hidden_ssid != NL80211_HIDDEN_SSID_NOT_IN_USE);
 }
 
+static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
+				    u8 *resp, size_t resp_len)
+{
+	struct sk_buff *new, *old;
+
+	if (resp_len == 0)
+		return -EINVAL;
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
 /*
  * This handles both adding a beacon and setting new beacon info
  */
@@ -498,6 +529,7 @@ static int ieee80211_config_beacon(struct ieee80211_sub_if_data *sdata,
 	int new_head_len, new_tail_len;
 	int size;
 	int err = -EINVAL;
+	u32 changed = 0;
 
 	old = rtnl_dereference(sdata->u.ap.beacon);
 
@@ -581,11 +613,17 @@ static int ieee80211_config_beacon(struct ieee80211_sub_if_data *sdata,
 
 	kfree(old);
 
+	err = ieee80211_set_probe_resp(sdata, params->probe_resp,
+				       params->probe_resp_len);
+	if (!err)
+		changed |= BSS_CHANGED_AP_PROBE_RESP;
+
 	ieee80211_config_ap_ssid(sdata, params);
+	changed |= BSS_CHANGED_BEACON_ENABLED |
+		   BSS_CHANGED_BEACON |
+		   BSS_CHANGED_SSID;
 
-	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED |
-						BSS_CHANGED_BEACON |
-						BSS_CHANGED_SSID);
+	ieee80211_bss_info_change_notify(sdata, changed);
 	return 0;
 }
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ea10a51..5a351cc 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -228,6 +228,7 @@ struct beacon_data {
 
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
index 48bbb96..6b86f77 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2354,6 +2354,37 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
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
1.7.5.4

