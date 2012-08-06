Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37833 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab2HFJqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 05:46:25 -0400
Received: by weyx8 with SMTP id x8so1772196wey.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 02:46:23 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Eyal Shapira <eyal@wizery.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: avoid using synchronize_rcu in ieee80211_set_probe_resp
Date: Mon,  6 Aug 2012 12:46:20 +0300
Message-Id: <1344246380-30044-1-git-send-email-arik@wizery.com> (sfid-20120806_114628_800866_C409EB01)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

This could take a while (100ms+) and may delay sending assoc resp
in AP mode with WPS or P2P GO (as setting the probe resp takes place
there). We've encountered situations where the delay was big enough
to cause connection problems with devices like Galaxy Nexus.
Switch to using call_rcu with a free handler.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/cfg.c         |   42 +++++++++++++++++++++++++++++++++---------
 net/mac80211/ieee80211_i.h |   16 +++++++++++++++-
 net/mac80211/iface.c       |    4 ++--
 net/mac80211/tx.c          |    5 +++--
 4 files changed, 53 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index efbbdc8..c8833c1 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -722,28 +722,52 @@ static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
 	return ieee80211_set_channel(wiphy, NULL, chan, channel_type);
 }
 
+static struct probe_resp *ieee80211_probe_resp_alloc(size_t resp_len)
+{
+	struct probe_resp *probe_resp;
+
+	probe_resp = kzalloc(sizeof(struct probe_resp), GFP_KERNEL);
+	if (!probe_resp)
+		goto fail;
+
+	probe_resp->skb = dev_alloc_skb(resp_len);
+	if (!probe_resp->skb)
+		goto fail;
+
+	return probe_resp;
+fail:
+	kfree(probe_resp);
+	return NULL;
+}
+
+static void ieee80211_probe_resp_rcu_free(struct rcu_head *head)
+{
+	struct probe_resp *probe_resp;
+
+	probe_resp = container_of(head, struct probe_resp, rcu_head);
+	ieee80211_free_probe_resp(probe_resp);
+}
+
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
+	new = ieee80211_probe_resp_alloc(resp_len);
 	if (!new)
 		return -ENOMEM;
 
-	memcpy(skb_put(new, resp_len), resp, resp_len);
+	memcpy(skb_put(new->skb, resp_len), resp, resp_len);
 
 	rcu_assign_pointer(sdata->u.ap.probe_resp, new);
-	if (old) {
-		/* TODO: use call_rcu() */
-		synchronize_rcu();
-		dev_kfree_skb(old);
-	}
+	if (old)
+		call_rcu(&(old->rcu_head),
+			 ieee80211_probe_resp_rcu_free);
 
 	return 0;
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d08c547..51d3a0d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -279,9 +279,23 @@ struct beacon_data {
 	struct rcu_head rcu_head;
 };
 
+struct probe_resp {
+	struct sk_buff *skb;
+	struct rcu_head rcu_head;
+};
+
+static inline void ieee80211_free_probe_resp(struct probe_resp *probe_resp)
+{
+	if (!probe_resp)
+		return;
+
+	dev_kfree_skb(probe_resp->skb);
+	kfree(probe_resp);
+}
+
 struct ieee80211_if_ap {
 	struct beacon_data __rcu *beacon;
-	struct sk_buff __rcu *probe_resp;
+	struct probe_resp __rcu *probe_resp;
 
 	struct list_head vlans;
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index bfb57dc..17c4c32 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -708,7 +708,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		struct ieee80211_sub_if_data *vlan, *tmpsdata;
 		struct beacon_data *old_beacon =
 			rtnl_dereference(sdata->u.ap.beacon);
-		struct sk_buff *old_probe_resp =
+		struct probe_resp *old_probe_resp =
 			rtnl_dereference(sdata->u.ap.probe_resp);
 
 		/* sdata_running will return false, so this will disable */
@@ -720,7 +720,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		RCU_INIT_POINTER(sdata->u.ap.probe_resp, NULL);
 		synchronize_rcu();
 		kfree(old_beacon);
-		kfree_skb(old_probe_resp);
+		ieee80211_free_probe_resp(old_probe_resp);
 
 		/* down all dependent devices, that is VLANs */
 		list_for_each_entry_safe(vlan, tmpsdata, &sdata->u.ap.vlans,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index acf712f..3c33f94 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2482,7 +2482,8 @@ struct sk_buff *ieee80211_proberesp_get(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif)
 {
 	struct ieee80211_if_ap *ap = NULL;
-	struct sk_buff *presp = NULL, *skb = NULL;
+	struct sk_buff *skb = NULL;
+	struct probe_resp *presp = NULL;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 
@@ -2496,7 +2497,7 @@ struct sk_buff *ieee80211_proberesp_get(struct ieee80211_hw *hw,
 	if (!presp)
 		goto out;
 
-	skb = skb_copy(presp, GFP_ATOMIC);
+	skb = skb_copy(presp->skb, GFP_ATOMIC);
 	if (!skb)
 		goto out;
 
-- 
1.7.9.5

