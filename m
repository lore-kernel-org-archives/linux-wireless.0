Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:38626 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbZHRINj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 04:13:39 -0400
Date: Tue, 18 Aug 2009 10:13:39 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 10/29] mwl8k: fix mwl8k_configure_filter() parameter lifetime issue
Message-ID: <20090818081339.GI18639@mail.wantstofly.org>
References: <20090818035233.GO18639@mail.wantstofly.org> <20090818040039.GA4116@mail.wantstofly.org> <1250580198.30538.0.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1250580198.30538.0.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 18, 2009 at 09:23:18AM +0200, Johannes Berg wrote:

> > This will clash with:
> > 
> > 	http://article.gmane.org/gmane.linux.kernel.wireless.general/38141
> > 
> > But that is easy to fix up.  (The easiest would probably be to not
> > apply the mwl8k part of that patch, and I'll send a followup patch
> > to implement ->prepare_multicast() for mwl8k.)
> 
> It's not quite that easy because that patch changes the arguments to the
> functions so the multicast list is no longer available in
> ->configure_filter().

OK, if my patch set gets applied first, please use the mwl8k
->prepare_multicast() implementation that's below in your patch.

If your patch gets applied first, I'll fix it up in my set.



diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 2c7c85d..316a728 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2654,26 +2654,33 @@ out:
 	mwl8k_fw_unlock(hw);
 }
 
-struct mwl8k_configure_filter_worker {
-	struct work_struct wt;
-	struct ieee80211_hw *hw;
-	unsigned int changed_flags;
-	unsigned int total_flags;
-	struct mwl8k_cmd_pkt *set_multicast_adr;
-};
+static u64 mwl8k_prepare_multicast(struct ieee80211_hw *hw,
+				   int mc_count, struct dev_addr_list *mclist)
+{
+	struct mwl8k_cmd_pkt *cmd;
+
+	cmd = __mwl8k_cmd_mac_multicast_adr(hw, mc_count, mclist);
 
-static void mwl8k_configure_filter_wt(struct work_struct *wt)
+	return (unsigned long)cmd;
+}
+
+static void mwl8k_configure_filter(struct ieee80211_hw *hw,
+				   unsigned int changed_flags,
+				   unsigned int *total_flags,
+				   u64 multicast)
 {
-	struct mwl8k_configure_filter_worker *worker =
-		(struct mwl8k_configure_filter_worker *)wt;
-	struct ieee80211_hw *hw = worker->hw;
 	struct mwl8k_priv *priv = hw->priv;
+	struct mwl8k_cmd_pkt *multicast_adr_cmd =
+		(void *)(unsigned long)multicast;
+
+	/* Clear unsupported feature flags */
+	*total_flags &= FIF_BCN_PRBRESP_PROMISC;
 
 	if (mwl8k_fw_lock(hw))
-		return;
+		goto out;
 
-	if (worker->changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		if (worker->total_flags & FIF_BCN_PRBRESP_PROMISC)
+	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
+		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
 			mwl8k_cmd_set_pre_scan(hw);
 		else {
 			u8 *bssid;
@@ -2686,44 +2693,13 @@ static void mwl8k_configure_filter_wt(struct work_struct *wt)
 		}
 	}
 
-	if (worker->set_multicast_adr != NULL) {
-		mwl8k_post_cmd(hw, worker->set_multicast_adr);
-		kfree(worker->set_multicast_adr);
-	}
+	if (multicast_adr_cmd != NULL)
+		mwl8k_post_cmd(hw, multicast_adr_cmd);
 
 	mwl8k_fw_unlock(hw);
 
-	kfree(worker);
-}
-
-static void mwl8k_configure_filter(struct ieee80211_hw *hw,
-				   unsigned int changed_flags,
-				   unsigned int *total_flags,
-				   int mc_count,
-				   struct dev_addr_list *mclist)
-{
-	struct mwl8k_priv *priv = hw->priv;
-	struct mwl8k_configure_filter_worker *worker;
-
-	/* Clear unsupported feature flags */
-	*total_flags &= FIF_BCN_PRBRESP_PROMISC;
-
-	if (!(changed_flags & FIF_BCN_PRBRESP_PROMISC) && !mc_count)
-		return;
-
-	worker = kzalloc(sizeof(*worker), GFP_ATOMIC);
-	if (worker == NULL)
-		return;
-
-	worker->hw = hw;
-	worker->changed_flags = changed_flags;
-	worker->total_flags = *total_flags;
-	if (mc_count)
-		worker->set_multicast_adr =
-			__mwl8k_cmd_mac_multicast_adr(hw, mc_count, mclist);
-
-	INIT_WORK(&worker->wt, mwl8k_configure_filter_wt);
-	queue_work(priv->config_wq, &worker->wt);
+out:
+	kfree(multicast_adr_cmd);
 }
 
 static int mwl8k_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
@@ -2787,6 +2763,7 @@ static const struct ieee80211_ops mwl8k_ops = {
 	.remove_interface	= mwl8k_remove_interface,
 	.config			= mwl8k_config,
 	.bss_info_changed	= mwl8k_bss_info_changed,
+	.prepare_multicast	= mwl8k_prepare_multicast,
 	.configure_filter	= mwl8k_configure_filter,
 	.set_rts_threshold	= mwl8k_set_rts_threshold,
 	.conf_tx		= mwl8k_conf_tx,
