Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52258 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab3E0MhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 08:37:19 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: make WoWLAN configuration available to drivers
Date: Mon, 27 May 2013 14:37:14 +0200
Message-Id: <1369658234-3821-1-git-send-email-johannes@sipsolutions.net> (sfid-20130527_143723_754811_07CE76F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Make the current WoWLAN configuration available to drivers
at runtime. This isn't really useful for the normal WoWLAN
behaviour and accessing it can also be racy, but drivers
may use it for testing the WoWLAN device behaviour while
the host stays up & running to observe the device.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |  4 ++++
 net/wireless/core.c    |  2 +-
 net/wireless/core.h    | 19 +++++++++---------
 net/wireless/nl80211.c | 53 ++++++++++++++++++++++++++------------------------
 net/wireless/sysfs.c   |  4 ++--
 5 files changed, 44 insertions(+), 38 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9f45d74..b3b076a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2583,6 +2583,9 @@ struct wiphy_wowlan_support {
  *	may request, if implemented.
  *
  * @wowlan: WoWLAN support information
+ * @wowlan_config: current WoWLAN configuration; this should usually not be
+ *	used since access to it is necessarily racy, use the parameter passed
+ *	to the suspend() operation instead.
  *
  * @ap_sme_capa: AP SME capabilities, flags from &enum nl80211_ap_sme_features.
  * @ht_capa_mod_mask:  Specify what ht_cap values can be over-ridden.
@@ -2650,6 +2653,7 @@ struct wiphy {
 
 #ifdef CONFIG_PM
 	struct wiphy_wowlan_support wowlan;
+	struct cfg80211_wowlan *wowlan_config;
 #endif
 
 	u16 max_remain_on_channel_duration;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index ee42287..45abc45 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -663,7 +663,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	flush_work(&rdev->event_work);
 	cancel_delayed_work_sync(&rdev->dfs_update_channels_wk);
 
-	if (rdev->wowlan && rdev->ops->set_wakeup)
+	if (rdev->wiphy.wowlan_config && rdev->ops->set_wakeup)
 		rdev_set_wakeup(rdev, false);
 	cfg80211_rdev_free_wowlan(rdev);
 }
diff --git a/net/wireless/core.h b/net/wireless/core.h
index b4b4a56..c303627 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -74,8 +74,6 @@ struct cfg80211_registered_device {
 	struct work_struct conn_work;
 	struct work_struct event_work;
 
-	struct cfg80211_wowlan *wowlan;
-
 	struct delayed_work dfs_update_channels_wk;
 
 	/* netlink port which started critical protocol (0 means not started) */
@@ -98,15 +96,16 @@ cfg80211_rdev_free_wowlan(struct cfg80211_registered_device *rdev)
 {
 	int i;
 
-	if (!rdev->wowlan)
+	if (!rdev->wiphy.wowlan_config)
 		return;
-	for (i = 0; i < rdev->wowlan->n_patterns; i++)
-		kfree(rdev->wowlan->patterns[i].mask);
-	kfree(rdev->wowlan->patterns);
-	if (rdev->wowlan->tcp && rdev->wowlan->tcp->sock)
-		sock_release(rdev->wowlan->tcp->sock);
-	kfree(rdev->wowlan->tcp);
-	kfree(rdev->wowlan);
+	for (i = 0; i < rdev->wiphy.wowlan_config->n_patterns; i++)
+		kfree(rdev->wiphy.wowlan_config->patterns[i].mask);
+	kfree(rdev->wiphy.wowlan_config->patterns);
+	if (rdev->wiphy.wowlan_config->tcp &&
+	    rdev->wiphy.wowlan_config->tcp->sock)
+		sock_release(rdev->wiphy.wowlan_config->tcp->sock);
+	kfree(rdev->wiphy.wowlan_config->tcp);
+	kfree(rdev->wiphy.wowlan_config);
 }
 
 extern struct workqueue_struct *cfg80211_wq;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a09f36b..fb6abcb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7489,28 +7489,29 @@ static int nl80211_leave_mesh(struct sk_buff *skb, struct genl_info *info)
 static int nl80211_send_wowlan_patterns(struct sk_buff *msg,
 					struct cfg80211_registered_device *rdev)
 {
+	struct cfg80211_wowlan *wowlan = rdev->wiphy.wowlan_config;
 	struct nlattr *nl_pats, *nl_pat;
 	int i, pat_len;
 
-	if (!rdev->wowlan->n_patterns)
+	if (!wowlan->n_patterns)
 		return 0;
 
 	nl_pats = nla_nest_start(msg, NL80211_WOWLAN_TRIG_PKT_PATTERN);
 	if (!nl_pats)
 		return -ENOBUFS;
 
-	for (i = 0; i < rdev->wowlan->n_patterns; i++) {
+	for (i = 0; i < wowlan->n_patterns; i++) {
 		nl_pat = nla_nest_start(msg, i + 1);
 		if (!nl_pat)
 			return -ENOBUFS;
-		pat_len = rdev->wowlan->patterns[i].pattern_len;
+		pat_len = wowlan->patterns[i].pattern_len;
 		if (nla_put(msg, NL80211_WOWLAN_PKTPAT_MASK,
 			    DIV_ROUND_UP(pat_len, 8),
-			    rdev->wowlan->patterns[i].mask) ||
+			    wowlan->patterns[i].mask) ||
 		    nla_put(msg, NL80211_WOWLAN_PKTPAT_PATTERN,
-			    pat_len, rdev->wowlan->patterns[i].pattern) ||
+			    pat_len, wowlan->patterns[i].pattern) ||
 		    nla_put_u32(msg, NL80211_WOWLAN_PKTPAT_OFFSET,
-				rdev->wowlan->patterns[i].pkt_offset))
+				wowlan->patterns[i].pkt_offset))
 			return -ENOBUFS;
 		nla_nest_end(msg, nl_pat);
 	}
@@ -7573,12 +7574,12 @@ static int nl80211_get_wowlan(struct sk_buff *skb, struct genl_info *info)
 	    !rdev->wiphy.wowlan.tcp)
 		return -EOPNOTSUPP;
 
-	if (rdev->wowlan && rdev->wowlan->tcp) {
+	if (rdev->wiphy.wowlan_config && rdev->wiphy.wowlan_config->tcp) {
 		/* adjust size to have room for all the data */
-		size += rdev->wowlan->tcp->tokens_size +
-			rdev->wowlan->tcp->payload_len +
-			rdev->wowlan->tcp->wake_len +
-			rdev->wowlan->tcp->wake_len / 8;
+		size += rdev->wiphy.wowlan_config->tcp->tokens_size +
+			rdev->wiphy.wowlan_config->tcp->payload_len +
+			rdev->wiphy.wowlan_config->tcp->wake_len +
+			rdev->wiphy.wowlan_config->tcp->wake_len / 8;
 	}
 
 	msg = nlmsg_new(size, GFP_KERNEL);
@@ -7590,33 +7591,34 @@ static int nl80211_get_wowlan(struct sk_buff *skb, struct genl_info *info)
 	if (!hdr)
 		goto nla_put_failure;
 
-	if (rdev->wowlan) {
+	if (rdev->wiphy.wowlan_config) {
 		struct nlattr *nl_wowlan;
 
 		nl_wowlan = nla_nest_start(msg, NL80211_ATTR_WOWLAN_TRIGGERS);
 		if (!nl_wowlan)
 			goto nla_put_failure;
 
-		if ((rdev->wowlan->any &&
+		if ((rdev->wiphy.wowlan_config->any &&
 		     nla_put_flag(msg, NL80211_WOWLAN_TRIG_ANY)) ||
-		    (rdev->wowlan->disconnect &&
+		    (rdev->wiphy.wowlan_config->disconnect &&
 		     nla_put_flag(msg, NL80211_WOWLAN_TRIG_DISCONNECT)) ||
-		    (rdev->wowlan->magic_pkt &&
+		    (rdev->wiphy.wowlan_config->magic_pkt &&
 		     nla_put_flag(msg, NL80211_WOWLAN_TRIG_MAGIC_PKT)) ||
-		    (rdev->wowlan->gtk_rekey_failure &&
+		    (rdev->wiphy.wowlan_config->gtk_rekey_failure &&
 		     nla_put_flag(msg, NL80211_WOWLAN_TRIG_GTK_REKEY_FAILURE)) ||
-		    (rdev->wowlan->eap_identity_req &&
+		    (rdev->wiphy.wowlan_config->eap_identity_req &&
 		     nla_put_flag(msg, NL80211_WOWLAN_TRIG_EAP_IDENT_REQUEST)) ||
-		    (rdev->wowlan->four_way_handshake &&
+		    (rdev->wiphy.wowlan_config->four_way_handshake &&
 		     nla_put_flag(msg, NL80211_WOWLAN_TRIG_4WAY_HANDSHAKE)) ||
-		    (rdev->wowlan->rfkill_release &&
+		    (rdev->wiphy.wowlan_config->rfkill_release &&
 		     nla_put_flag(msg, NL80211_WOWLAN_TRIG_RFKILL_RELEASE)))
 			goto nla_put_failure;
 
 		if (nl80211_send_wowlan_patterns(msg, rdev))
 			goto nla_put_failure;
 
-		if (nl80211_send_wowlan_tcp(msg, rdev->wowlan->tcp))
+		if (nl80211_send_wowlan_tcp(msg,
+					    rdev->wiphy.wowlan_config->tcp))
 			goto nla_put_failure;
 
 		nla_nest_end(msg, nl_wowlan);
@@ -7783,7 +7785,7 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_wowlan *ntrig;
 	struct wiphy_wowlan_support *wowlan = &rdev->wiphy.wowlan;
 	int err, i;
-	bool prev_enabled = rdev->wowlan;
+	bool prev_enabled = rdev->wiphy.wowlan_config;
 
 	if (!rdev->wiphy.wowlan.flags && !rdev->wiphy.wowlan.n_patterns &&
 	    !rdev->wiphy.wowlan.tcp)
@@ -7791,7 +7793,7 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 
 	if (!info->attrs[NL80211_ATTR_WOWLAN_TRIGGERS]) {
 		cfg80211_rdev_free_wowlan(rdev);
-		rdev->wowlan = NULL;
+		rdev->wiphy.wowlan_config = NULL;
 		goto set_wakeup;
 	}
 
@@ -7927,11 +7929,12 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 		goto error;
 	}
 	cfg80211_rdev_free_wowlan(rdev);
-	rdev->wowlan = ntrig;
+	rdev->wiphy.wowlan_config = ntrig;
 
  set_wakeup:
-	if (rdev->ops->set_wakeup && prev_enabled != !!rdev->wowlan)
-		rdev_set_wakeup(rdev, rdev->wowlan);
+	if (rdev->ops->set_wakeup &&
+	    prev_enabled != !!rdev->wiphy.wowlan_config)
+		rdev_set_wakeup(rdev, rdev->wiphy.wowlan_config);
 
 	return 0;
  error:
diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 8f28b9f..dec0f4e 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -100,10 +100,10 @@ static int wiphy_suspend(struct device *dev, pm_message_t state)
 
 	rtnl_lock();
 	if (rdev->wiphy.registered) {
-		if (!rdev->wowlan)
+		if (!rdev->wiphy.wowlan_config)
 			cfg80211_leave_all(rdev);
 		if (rdev->ops->suspend)
-			ret = rdev_suspend(rdev, rdev->wowlan);
+			ret = rdev_suspend(rdev, rdev->wiphy.wowlan_config);
 		if (ret == 1) {
 			/* Driver refuse to configure wowlan */
 			cfg80211_leave_all(rdev);
-- 
1.8.0

