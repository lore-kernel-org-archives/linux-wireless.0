Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55432 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753820AbdDMNwD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 09:52:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 3/3] mac80211: support bpf monitor filter
Date: Thu, 13 Apr 2017 15:51:55 +0200
Message-Id: <20170413135155.27265-3-johannes@sipsolutions.net> (sfid-20170413_155230_224654_63AD579D)
In-Reply-To: <20170413135155.27265-1-johannes@sipsolutions.net>
References: <20170413135155.27265-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add the necessary hooks for running monitor filter programs
in mac80211's RX path, before a frame is handed off to a
monitor interface. If the frame isn't accepted then this
will save the overhead of creating a new SKB and building
the radiotap header.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/Kconfig       |  1 +
 net/mac80211/cfg.c         | 15 +++++++++++++++
 net/mac80211/ieee80211_i.h |  6 ++++++
 net/mac80211/iface.c       | 11 ++++++++++-
 net/mac80211/main.c        |  3 +++
 net/mac80211/rx.c          | 33 +++++++++++++++++++++++++++++++--
 6 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 76e30f4797fb..080e0c705c72 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -8,6 +8,7 @@ config MAC80211
 	select CRYPTO_GCM
 	select CRYPTO_CMAC
 	select CRC32
+	select WANT_BPF_WIFIMON
 	---help---
 	  This option enables the hardware independent IEEE 802.11
 	  networking stack.
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7af648e95bc6..5d427ed8b6c8 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -107,6 +107,21 @@ static int ieee80211_set_mon_options(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+#ifdef CONFIG_BPF_WIFIMON
+	if (params->filter) {
+		struct bpf_prog *old = rtnl_dereference(sdata->u.mntr.filter);
+
+		if (IS_ERR(params->filter))
+			RCU_INIT_POINTER(sdata->u.mntr.filter, NULL);
+		else
+			rcu_assign_pointer(sdata->u.mntr.filter,
+					   params->filter);
+
+		if (old)
+			bpf_prog_put(old);
+	}
+#endif
+
 	return 0;
 }
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index cf6d5abb65a3..fb0592e0f7b3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -27,6 +27,8 @@
 #include <linux/leds.h>
 #include <linux/idr.h>
 #include <linux/rhashtable.h>
+#include <linux/filter.h>
+#include <linux/bpf.h>
 #include <net/ieee80211_radiotap.h>
 #include <net/cfg80211.h>
 #include <net/mac80211.h>
@@ -841,6 +843,10 @@ struct ieee80211_if_mntr {
 	u8 mu_follow_addr[ETH_ALEN] __aligned(2);
 
 	struct list_head list;
+
+#ifdef CONFIG_BPF_WIFIMON
+	struct bpf_prog *filter;
+#endif
 };
 
 /**
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 3bd5b81f5d81..5c25afa6cf77 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1122,8 +1122,17 @@ static void ieee80211_teardown_sdata(struct ieee80211_sub_if_data *sdata)
 		__skb_queue_purge(&sdata->fragments[i].skb_list);
 	sdata->fragment_next = 0;
 
-	if (ieee80211_vif_is_mesh(&sdata->vif))
+	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		ieee80211_mesh_teardown_sdata(sdata);
+	} else if (sdata->vif.type == NL80211_IFTYPE_MONITOR) {
+#ifdef CONFIG_BPF_WIFIMON
+		struct bpf_prog *old = rtnl_dereference(sdata->u.mntr.filter);
+
+		RCU_INIT_POINTER(sdata->u.mntr.filter, NULL);
+		if (old)
+			bpf_prog_put(old);
+#endif
+	}
 }
 
 static void ieee80211_uninit(struct net_device *dev)
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index ae408a96c407..b7857e710fd5 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -551,6 +551,9 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 			   NL80211_FEATURE_FULL_AP_CLIENT_STATE;
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_FILS_STA);
 
+	if (IS_ENABLED(CONFIG_BPF_WIFIMON))
+		wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_WIFIMON_BPF);
+
 	if (!ops->hw_scan)
 		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |
 				   NL80211_FEATURE_AP_SCAN;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 50d8f8435830..ea7d56774dd3 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -651,17 +651,39 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 
 	ieee80211_handle_mu_mimo_mon(monitor_sdata, origskb, rtap_vendor_space);
 
+	/* pretend all the monitor info isn't there */
+	__pskb_pull(origskb, rtap_vendor_space);
+	origskb->len -= present_fcs_len;
+
 	list_for_each_entry_rcu(sdata, &local->mon_list, u.mntr.list) {
+		const struct bpf_prog *filter __maybe_unused;
 		bool last_monitor = list_is_last(&sdata->u.mntr.list,
 						 &local->mon_list);
 
-		if (!monskb)
+#ifdef CONFIG_BPF_WIFIMON
+		filter = rcu_dereference(sdata->u.mntr.filter);
+		if (filter && !BPF_PROG_RUN(filter, origskb))
+			continue;
+#endif
+
+		if (!monskb) {
+			/* stop pretending the monitor info isn't there */
+			origskb->len += present_fcs_len;
+			__skb_push(origskb, rtap_vendor_space);
+
 			monskb = ieee80211_make_monitor_skb(local, &origskb,
 							    rate,
 							    rtap_vendor_space,
 							    only_monitor &&
 							    last_monitor);
 
+			if (origskb) {
+				/* pretend all the monitor info isn't there */
+				__pskb_pull(origskb, rtap_vendor_space);
+				origskb->len -= present_fcs_len;
+			}
+		}
+
 		if (monskb) {
 			struct sk_buff *skb;
 
@@ -683,13 +705,20 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 			break;
 	}
 
-	/* this happens if last_monitor was erroneously false */
+	/*
+	 * this may happen if filtering, or if the list RCU handling
+	 * got last_monitor erroneously false
+	 */
 	dev_kfree_skb(monskb);
 
 	/* ditto */
 	if (!origskb)
 		return NULL;
 
+	/* stop pretending the monitor info isn't there */
+	origskb->len += present_fcs_len;
+	__skb_push(origskb, rtap_vendor_space);
+
 	remove_monitor_info(origskb, present_fcs_len, rtap_vendor_space);
 	return origskb;
 }
-- 
2.11.0
