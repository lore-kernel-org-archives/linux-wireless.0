Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47044 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab2HFL0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 07:26:21 -0400
Received: by wgbfm10 with SMTP id fm10so1356822wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 04:26:20 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Eyal Shapira <eyal@wizery.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2] mac80211: avoid using synchronize_rcu in ieee80211_set_probe_resp
Date: Mon,  6 Aug 2012 14:26:16 +0300
Message-Id: <1344252376-20971-1-git-send-email-arik@wizery.com> (sfid-20120806_132709_831956_A51FF690)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

This could take a while (100ms+) and may delay sending assoc resp
in AP mode with WPS or P2P GO (as setting the probe resp takes place
there). We've encountered situations where the delay was big enough
to cause connection problems with devices like Galaxy Nexus.
Switch to using call_rcu with a free handler.

[Arik - rework to use plain buffer and instead of skb]

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/cfg.c         |   16 +++++++---------
 net/mac80211/ieee80211_i.h |    8 +++++++-
 net/mac80211/iface.c       |    4 ++--
 net/mac80211/tx.c          |    7 +++++--
 4 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5801735..6d77ed7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -734,25 +734,23 @@ static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
 static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
 				    const u8 *resp, size_t resp_len)
 {
-	struct sk_buff *new, *old;
+	struct probe_resp *new, *old;
 
 	if (!resp || !resp_len)
-		return 1;
+		return -EINVAL;
 
 	old = rtnl_dereference(sdata->u.ap.probe_resp);
 
-	new = dev_alloc_skb(resp_len);
+	new = kzalloc(sizeof(struct probe_resp) + resp_len, GFP_KERNEL);
 	if (!new)
 		return -ENOMEM;
 
-	memcpy(skb_put(new, resp_len), resp, resp_len);
+	new->len = resp_len;
+	memcpy(new->data, resp, resp_len);
 
 	rcu_assign_pointer(sdata->u.ap.probe_resp, new);
-	if (old) {
-		/* TODO: use call_rcu() */
-		synchronize_rcu();
-		dev_kfree_skb(old);
-	}
+	if (old)
+		kfree_rcu(old, rcu_head);
 
 	return 0;
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ac9b758..02d28cd 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -279,9 +279,15 @@ struct beacon_data {
 	struct rcu_head rcu_head;
 };
 
+struct probe_resp {
+	struct rcu_head rcu_head;
+	int len;
+	u8 data[0];
+};
+
 struct ieee80211_if_ap {
 	struct beacon_data __rcu *beacon;
-	struct sk_buff __rcu *probe_resp;
+	struct probe_resp __rcu *probe_resp;
 
 	struct list_head vlans;
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 090ec3a..513b85e 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -714,7 +714,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		struct ieee80211_sub_if_data *vlan, *tmpsdata;
 		struct beacon_data *old_beacon =
 			rtnl_dereference(sdata->u.ap.beacon);
-		struct sk_buff *old_probe_resp =
+		struct probe_resp *old_probe_resp =
 			rtnl_dereference(sdata->u.ap.probe_resp);
 
 		/* sdata_running will return false, so this will disable */
@@ -726,7 +726,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		RCU_INIT_POINTER(sdata->u.ap.probe_resp, NULL);
 		synchronize_rcu();
 		kfree(old_beacon);
-		kfree_skb(old_probe_resp);
+		kfree(old_probe_resp);
 
 		/* down all dependent devices, that is VLANs */
 		list_for_each_entry_safe(vlan, tmpsdata, &sdata->u.ap.vlans,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index dc592eb..5faa32a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2483,7 +2483,8 @@ struct sk_buff *ieee80211_proberesp_get(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif)
 {
 	struct ieee80211_if_ap *ap = NULL;
-	struct sk_buff *presp = NULL, *skb = NULL;
+	struct sk_buff *skb = NULL;
+	struct probe_resp *presp = NULL;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 
@@ -2497,10 +2498,12 @@ struct sk_buff *ieee80211_proberesp_get(struct ieee80211_hw *hw,
 	if (!presp)
 		goto out;
 
-	skb = skb_copy(presp, GFP_ATOMIC);
+	skb = dev_alloc_skb(presp->len);
 	if (!skb)
 		goto out;
 
+	memcpy(skb_put(skb, presp->len), presp->data, presp->len);
+
 	hdr = (struct ieee80211_hdr *) skb->data;
 	memset(hdr->addr1, 0, sizeof(hdr->addr1));
 
-- 
1.7.9.5

