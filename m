Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:40181 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429AbZHRDwc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:52:32 -0400
Date: Tue, 18 Aug 2009 05:52:33 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 10/29] mwl8k: fix mwl8k_configure_filter() parameter lifetime issue
Message-ID: <20090818035233.GO18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mwl8k_configure_filter() passes pointers to total_flags and the
multicast address list to a workqueue function, while there is no
guarantee that those pointers will still be valid by the time the
workqueue function runs.

Solve this by passing total_flags by value, and by passing an
already built multicast address setup command packet to the workqueue
function so that we don't have to look at the multicast address list
itself outside of mwl8k_configure_filter().

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   72 +++++++++++++++++------------------------
 1 files changed, 30 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 3a201a2..e266bc1 100644
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
 
-	cmd = kzalloc(size, GFP_KERNEL);
+	size = sizeof(*cmd) + mc_count * ETH_ALEN;
+
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
@@ -3101,9 +3102,8 @@ static void mwl8k_bss_info_changed(struct ieee80211_hw *hw,
 struct mwl8k_configure_filter_worker {
 	struct mwl8k_work_struct header;
 	unsigned int changed_flags;
-	unsigned int *total_flags;
-	int mc_count;
-	struct dev_addr_list *mclist;
+	unsigned int total_flags;
+	struct mwl8k_cmd_pkt *set_multicast_adr;
 };
 
 #define MWL8K_SUPPORTED_IF_FLAGS	FIF_BCN_PRBRESP_PROMISC
@@ -3112,18 +3112,14 @@ static int mwl8k_configure_filter_wt(struct work_struct *wt)
 {
 	struct mwl8k_configure_filter_worker *worker =
 		(struct mwl8k_configure_filter_worker *)wt;
-
 	struct ieee80211_hw *hw = worker->header.hw;
 	unsigned int changed_flags = worker->changed_flags;
-	unsigned int *total_flags = worker->total_flags;
-	int mc_count = worker->mc_count;
-	struct dev_addr_list *mclist = worker->mclist;
-
+	unsigned int total_flags = worker->total_flags;
 	struct mwl8k_priv *priv = hw->priv;
 	int rc = 0;
 
 	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
+		if (total_flags & FIF_BCN_PRBRESP_PROMISC)
 			rc = mwl8k_cmd_set_pre_scan(hw);
 		else {
 			u8 *bssid;
@@ -3136,20 +3132,12 @@ static int mwl8k_configure_filter_wt(struct work_struct *wt)
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
+	if (worker->set_multicast_adr != NULL) {
+		if (!rc)
+			rc = mwl8k_post_cmd(hw, worker->set_multicast_adr);
+		kfree(worker->set_multicast_adr);
 	}
 
-mwl8k_configure_filter_exit:
 	return rc;
 }
 
@@ -3159,7 +3147,6 @@ static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 				   int mc_count,
 				   struct dev_addr_list *mclist)
 {
-
 	struct mwl8k_configure_filter_worker *worker;
 	struct mwl8k_priv *priv = hw->priv;
 
@@ -3175,9 +3162,10 @@ static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 
 	worker->header.options = MWL8K_WQ_QUEUE_ONLY | MWL8K_WQ_TX_WAIT_EMPTY;
 	worker->changed_flags = changed_flags;
-	worker->total_flags = total_flags;
-	worker->mc_count = mc_count;
-	worker->mclist = mclist;
+	worker->total_flags = *total_flags;
+	if (mc_count)
+		worker->set_multicast_adr =
+			__mwl8k_cmd_mac_multicast_adr(hw, mc_count, mclist);
 
 	mwl8k_queue_work(hw, &worker->header, priv->config_wq,
 			 mwl8k_configure_filter_wt);
-- 
1.5.6.4
