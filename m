Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:53588 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbZHRJyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 05:54:00 -0400
Date: Tue, 18 Aug 2009 11:54:00 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 10/29] mwl8k: fix mwl8k_configure_filter() parameter lifetime issue
Message-ID: <20090818095400.GB6195@mail.wantstofly.org>
References: <20090818035233.GO18639@mail.wantstofly.org> <20090818040039.GA4116@mail.wantstofly.org> <1250580198.30538.0.camel@johannes.local> <20090818081339.GI18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090818081339.GI18639@mail.wantstofly.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 18, 2009 at 10:13:39AM +0200, Lennert Buytenhek wrote:

> > > This will clash with:
> > > 
> > > 	http://article.gmane.org/gmane.linux.kernel.wireless.general/38141
> > > 
> > > But that is easy to fix up.  (The easiest would probably be to not
> > > apply the mwl8k part of that patch, and I'll send a followup patch
> > > to implement ->prepare_multicast() for mwl8k.)
> > 
> > It's not quite that easy because that patch changes the arguments to the
> > functions so the multicast list is no longer available in
> > ->configure_filter().
> 
> OK, if my patch set gets applied first, please use the mwl8k
> ->prepare_multicast() implementation that's below in your patch.
> 
> If your patch gets applied first, I'll fix it up in my set.

OK, your patch is already in, as you noted on IRC, so I've replaced
this by:



>From 9145398d5822cf3ed963fb155a2771c4facd1d85 Mon Sep 17 00:00:00 2001
From: Lennert Buytenhek <buytenh@wantstofly.org>
Date: Tue, 18 Aug 2009 03:55:42 +0200
Subject: [PATCH 09/29] mwl8k: fix mwl8k_configure_filter() parameter lifetime issue

mwl8k_configure_filter() passes pointers to total_flags and the
multicast address list to a workqueue function, while there is no
guarantee that those pointers will still be valid by the time the
workqueue function runs.

Solve this by passing total_flags by value, and by passing an
already built multicast address setup command packet to the workqueue
function so that we don't have to look at the multicast address list
itself outside of mwl8k_configure_filter().

Also, since ->configure_filter() can sleep now, wait synchronously
for the worker to finish.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |  107 +++++++++++++++--------------------------
 1 files changed, 39 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index a40434b..a961b69 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1613,38 +1613,39 @@ struct mwl8k_cmd_mac_multicast_adr {
 
 #define MWL8K_ENABLE_RX_MULTICAST 0x000F
 
-static int mwl8k_cmd_mac_multicast_adr(struct ieee80211_hw *hw,
-					int mc_count,
-					struct dev_addr_list *mclist)
+static struct mwl8k_cmd_pkt *
+__mwl8k_cmd_mac_multicast_adr(struct ieee80211_hw *hw,
+			      int mc_count, struct dev_addr_list *mclist)
 {
+	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_cmd_mac_multicast_adr *cmd;
-	int index = 0;
-	int rc;
-	int size = sizeof(*cmd) + mc_count * ETH_ALEN;
+	int size;
+	int i;
+
+	if (mc_count > priv->num_mcaddrs)
+		mc_count = priv->num_mcaddrs;
+
+	size = sizeof(*cmd) + mc_count * ETH_ALEN;
 
-	cmd = kzalloc(size, GFP_KERNEL);
+	cmd = kzalloc(size, GFP_ATOMIC);
 	if (cmd == NULL)
-		return -ENOMEM;
+		return NULL;
 
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_MAC_MULTICAST_ADR);
 	cmd->header.length = cpu_to_le16(size);
 	cmd->action = cpu_to_le16(MWL8K_ENABLE_RX_MULTICAST);
 	cmd->numaddr = cpu_to_le16(mc_count);
 
-	while (index < mc_count && mclist) {
+	for (i = 0; i < mc_count && mclist; i++) {
 		if (mclist->da_addrlen != ETH_ALEN) {
-			rc = -EINVAL;
-			goto mwl8k_cmd_mac_multicast_adr_exit;
+			kfree(cmd);
+			return NULL;
 		}
-		memcpy(cmd->addr[index++], mclist->da_addr, ETH_ALEN);
+		memcpy(cmd->addr[i], mclist->da_addr, ETH_ALEN);
 		mclist = mclist->next;
 	}
 
-	rc = mwl8k_post_cmd(hw, &cmd->header);
-
-mwl8k_cmd_mac_multicast_adr_exit:
-	kfree(cmd);
-	return rc;
+	return &cmd->header;
 }
 
 /*
@@ -3091,12 +3092,21 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 		printk(KERN_ERR "%s() timed out\n", __func__);
 }
 
+static u64 mwl8k_prepare_multicast(struct ieee80211_hw *hw,
+				   int mc_count, struct dev_addr_list *mclist)
+{
+	struct mwl8k_cmd_pkt *cmd;
+
+	cmd = __mwl8k_cmd_mac_multicast_adr(hw, mc_count, mclist);
+
+	return (unsigned long)cmd;
+}
+
 struct mwl8k_configure_filter_worker {
 	struct mwl8k_work_struct header;
 	unsigned int changed_flags;
-	unsigned int *total_flags;
-	int mc_count;
-	struct dev_addr_list *mclist;
+	unsigned int total_flags;
+	struct mwl8k_cmd_pkt *multicast_adr_cmd;
 };
 
 #define MWL8K_SUPPORTED_IF_FLAGS	FIF_BCN_PRBRESP_PROMISC
@@ -3105,18 +3115,12 @@ static int mwl8k_configure_filter_wt(struct work_struct *wt)
 {
 	struct mwl8k_configure_filter_worker *worker =
 		(struct mwl8k_configure_filter_worker *)wt;
-
 	struct ieee80211_hw *hw = worker->header.hw;
-	unsigned int changed_flags = worker->changed_flags;
-	unsigned int *total_flags = worker->total_flags;
-	int mc_count = worker->mc_count;
-	struct dev_addr_list *mclist = worker->mclist;
-
 	struct mwl8k_priv *priv = hw->priv;
 	int rc = 0;
 
-	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
+	if (worker->changed_flags & FIF_BCN_PRBRESP_PROMISC) {
+		if (worker->total_flags & FIF_BCN_PRBRESP_PROMISC)
 			rc = mwl8k_cmd_set_pre_scan(hw);
 		else {
 			u8 *bssid;
@@ -3129,54 +3133,20 @@ static int mwl8k_configure_filter_wt(struct work_struct *wt)
 		}
 	}
 
-	if (rc)
-		goto mwl8k_configure_filter_exit;
-	if (mc_count) {
-		if (mc_count > priv->num_mcaddrs)
-			mc_count = priv->num_mcaddrs;
-
-		rc = mwl8k_cmd_mac_multicast_adr(hw, mc_count, mclist);
-		if (rc)
-			printk(KERN_ERR
-			"%s()Error setting multicast addresses\n",
-			__func__);
-	}
+	if (!rc && worker->multicast_adr_cmd != NULL)
+		rc = mwl8k_post_cmd(hw, worker->multicast_adr_cmd);
+	kfree(worker->multicast_adr_cmd);
 
-mwl8k_configure_filter_exit:
 	return rc;
 }
 
-static u64 mwl8k_prepare_multicast(struct ieee80211_hw *hw,
-				   int mc_count, struct dev_addr_list *mclist)
-{
-	struct mwl8k_configure_filter_worker *worker;
-
-	worker = kzalloc(sizeof(*worker), GFP_ATOMIC);
-
-	if (!worker)
-		return 0;
-
-	/*
-	 * XXX: This is _HORRIBLY_ broken!!
-	 *
-	 *	No locking, the mclist pointer might be invalid as soon as this
-	 *	function returns, something in the list might be invalidated
-	 *	once we get to the worker, etc...
-	 */
-	worker->mc_count = mc_count;
-	worker->mclist = mclist;
-
-	return (u64)worker;
-}
-
 static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 				   unsigned int changed_flags,
 				   unsigned int *total_flags,
 				   u64 multicast)
 {
-
-	struct mwl8k_configure_filter_worker *worker = (void *)multicast;
 	struct mwl8k_priv *priv = hw->priv;
+	struct mwl8k_configure_filter_worker *worker;
 
 	/* Clear unsupported feature flags */
 	*total_flags &= MWL8K_SUPPORTED_IF_FLAGS;
@@ -3184,12 +3154,13 @@ static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 	if (!(changed_flags & MWL8K_SUPPORTED_IF_FLAGS))
 		return;
 
+	worker = kzalloc(sizeof(*worker), GFP_ATOMIC);
 	if (worker == NULL)
 		return;
 
-	worker->header.options = MWL8K_WQ_QUEUE_ONLY | MWL8K_WQ_TX_WAIT_EMPTY;
 	worker->changed_flags = changed_flags;
-	worker->total_flags = total_flags;
+	worker->total_flags = *total_flags;
+	worker->multicast_adr_cmd = (void *)(unsigned long)multicast;
 
 	mwl8k_queue_work(hw, &worker->header, priv->config_wq,
 			 mwl8k_configure_filter_wt);
-- 
1.5.6.4
