Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54235 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849AbZKQRTD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 12:19:03 -0500
Subject: [PATCH] mac80211: make software rate control optional
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 18:18:36 +0100
Message-ID: <1258478316.21197.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some devices implement the entire rate control in
firmware in some way, like wl1271 or like iwlwifi
which does some things in software but not a lot.
Therefore generic software rate control is rather
useless for them and just adds avoidable overhead
to the transmit path.

It's fairly simple to let drivers indicate that
they do not need rate control, but they need to
fulfil a number of conditions that we encode in
WARN_ONs.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h  |   14 ++++++++++++++
 net/mac80211/debugfs.c  |    2 +-
 net/mac80211/rate.c     |   12 +++++++++++-
 net/mac80211/rate.h     |    9 ++++++---
 net/mac80211/sta_info.c |   29 ++++++++++++++++++++++-------
 net/mac80211/tx.c       |    3 ++-
 6 files changed, 56 insertions(+), 13 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-11-16 17:26:28.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-11-16 17:26:33.000000000 +0100
@@ -852,6 +852,19 @@ enum ieee80211_tkip_key_type {
  * any particular flags. There are some exceptions to this rule,
  * however, so you are advised to review these flags carefully.
  *
+ * @IEEE80211_HW_HAS_RATE_CONTROL:
+ *	The hardware or firmware includes rate control, and cannot be
+ *	controlled by the stack. As such, no rate control algorithm
+ *	should be instantiated, and the TX rate reported to userspace
+ *	will be taken from the TX status instead of the rate control
+ *	algorithm.
+ *	Note that this requires that the driver implement a number of
+ *	callbacks so it has the correct information, it needs to have
+ *	the @set_rts_threshold callback and must look at the BSS config
+ *	@use_cts_prot for G/N protection, @use_short_slot for slot
+ *	timing in 2.4 GHz and @use_short_preamble for preambles for
+ *	CCK frames.
+ *
  * @IEEE80211_HW_RX_INCLUDES_FCS:
  *	Indicates that received frames passed to the stack include
  *	the FCS at the end.
@@ -910,6 +923,7 @@ enum ieee80211_tkip_key_type {
  *	avoid waking up cpu.
  */
 enum ieee80211_hw_flags {
+	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
 	IEEE80211_HW_RX_INCLUDES_FCS			= 1<<1,
 	IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING	= 1<<2,
 	IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE		= 1<<3,
--- wireless-testing.orig/net/mac80211/rate.h	2009-11-16 17:26:28.000000000 +0100
+++ wireless-testing/net/mac80211/rate.h	2009-11-16 17:26:33.000000000 +0100
@@ -59,6 +59,9 @@ static inline void rate_control_rate_ini
 	void *priv_sta = sta->rate_ctrl_priv;
 	struct ieee80211_supported_band *sband;
 
+	if (!ref)
+		return;
+
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
 	ref->ops->rate_init(ref->priv, sband, ista, priv_sta);
@@ -72,7 +75,7 @@ static inline void rate_control_rate_upd
 	struct ieee80211_sta *ista = &sta->sta;
 	void *priv_sta = sta->rate_ctrl_priv;
 
-	if (ref->ops->rate_update)
+	if (ref && ref->ops->rate_update)
 		ref->ops->rate_update(ref->priv, sband, ista,
 				      priv_sta, changed);
 }
@@ -97,7 +100,7 @@ static inline void rate_control_add_sta_
 {
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct rate_control_ref *ref = sta->rate_ctrl;
-	if (sta->debugfs.dir && ref->ops->add_sta_debugfs)
+	if (ref && sta->debugfs.dir && ref->ops->add_sta_debugfs)
 		ref->ops->add_sta_debugfs(ref->priv, sta->rate_ctrl_priv,
 					  sta->debugfs.dir);
 #endif
@@ -107,7 +110,7 @@ static inline void rate_control_remove_s
 {
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct rate_control_ref *ref = sta->rate_ctrl;
-	if (ref->ops->remove_sta_debugfs)
+	if (ref && ref->ops->remove_sta_debugfs)
 		ref->ops->remove_sta_debugfs(ref->priv, sta->rate_ctrl_priv);
 #endif
 }
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-11-16 17:26:28.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.c	2009-11-16 17:26:33.000000000 +0100
@@ -147,8 +147,10 @@ struct sta_info *sta_info_get_by_idx(str
 static void __sta_info_free(struct ieee80211_local *local,
 			    struct sta_info *sta)
 {
-	rate_control_free_sta(sta);
-	rate_control_put(sta->rate_ctrl);
+	if (sta->rate_ctrl) {
+		rate_control_free_sta(sta);
+		rate_control_put(sta->rate_ctrl);
+	}
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	printk(KERN_DEBUG "%s: Destroyed STA %pM\n",
@@ -276,6 +278,23 @@ static void sta_unblock(struct work_stru
 		ieee80211_sta_ps_deliver_poll_response(sta);
 }
 
+static int sta_prepare_rate_control(struct ieee80211_local *local,
+				    struct sta_info *sta, gfp_t gfp)
+{
+	if (local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)
+		return 0;
+
+	sta->rate_ctrl = rate_control_get(local->rate_ctrl);
+	sta->rate_ctrl_priv = rate_control_alloc_sta(sta->rate_ctrl,
+						     &sta->sta, gfp);
+	if (!sta->rate_ctrl_priv) {
+		rate_control_put(sta->rate_ctrl);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
 struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 				u8 *addr, gfp_t gfp)
 {
@@ -295,11 +314,7 @@ struct sta_info *sta_info_alloc(struct i
 	sta->local = local;
 	sta->sdata = sdata;
 
-	sta->rate_ctrl = rate_control_get(local->rate_ctrl);
-	sta->rate_ctrl_priv = rate_control_alloc_sta(sta->rate_ctrl,
-						     &sta->sta, gfp);
-	if (!sta->rate_ctrl_priv) {
-		rate_control_put(sta->rate_ctrl);
+	if (sta_prepare_rate_control(local, sta, gfp)) {
 		kfree(sta);
 		return NULL;
 	}
--- wireless-testing.orig/net/mac80211/tx.c	2009-11-16 17:26:28.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-11-16 17:26:33.000000000 +0100
@@ -1219,7 +1219,8 @@ static int invoke_tx_handlers(struct iee
 	CALL_TXH(ieee80211_tx_h_ps_buf);
 	CALL_TXH(ieee80211_tx_h_select_key);
 	CALL_TXH(ieee80211_tx_h_michael_mic_add);
-	CALL_TXH(ieee80211_tx_h_rate_ctrl);
+	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
+		CALL_TXH(ieee80211_tx_h_rate_ctrl);
 	CALL_TXH(ieee80211_tx_h_misc);
 	CALL_TXH(ieee80211_tx_h_sequence);
 	CALL_TXH(ieee80211_tx_h_fragment);
--- wireless-testing.orig/net/mac80211/rate.c	2009-11-16 17:26:28.000000000 +0100
+++ wireless-testing/net/mac80211/rate.c	2009-11-16 17:26:33.000000000 +0100
@@ -284,9 +284,16 @@ int ieee80211_init_rate_ctrl_alg(struct 
 	struct rate_control_ref *ref, *old;
 
 	ASSERT_RTNL();
+
 	if (local->open_count)
 		return -EBUSY;
 
+	if (local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) {
+		if (WARN_ON(!local->ops->set_rts_threshold))
+			return -EINVAL;
+		return 0;
+	}
+
 	ref = rate_control_alloc(name, local);
 	if (!ref) {
 		printk(KERN_WARNING "%s: Failed to select rate control "
@@ -305,7 +312,6 @@ int ieee80211_init_rate_ctrl_alg(struct 
 	       "algorithm '%s'\n", wiphy_name(local->hw.wiphy),
 	       ref->ops->name);
 
-
 	return 0;
 }
 
@@ -314,6 +320,10 @@ void rate_control_deinitialize(struct ie
 	struct rate_control_ref *ref;
 
 	ref = local->rate_ctrl;
+
+	if (!ref)
+		return;
+
 	local->rate_ctrl = NULL;
 	rate_control_put(ref);
 }
--- wireless-testing.orig/net/mac80211/debugfs.c	2009-11-16 17:26:28.000000000 +0100
+++ wireless-testing/net/mac80211/debugfs.c	2009-11-16 17:26:33.000000000 +0100
@@ -52,7 +52,7 @@ DEBUGFS_READONLY_FILE(total_ps_buffered,
 DEBUGFS_READONLY_FILE(wep_iv, 20, "%#08x",
 		      local->wep_iv & 0xffffff);
 DEBUGFS_READONLY_FILE(rate_ctrl_alg, 100, "%s",
-		      local->rate_ctrl ? local->rate_ctrl->ops->name : "<unset>");
+	local->rate_ctrl ? local->rate_ctrl->ops->name : "hw/driver");
 
 static ssize_t tsf_read(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)


