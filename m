Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:49151 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbZJVShI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:37:08 -0400
Date: Thu, 22 Oct 2009 20:19:50 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 06/28] mwl8k: implement FIF_ALLMULTI
Message-ID: <20091022181950.GH1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   39 ++++++++++++++++++++++++++++-----------
 1 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 77985e9..cc58ecb 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1543,16 +1543,14 @@ struct mwl8k_cmd_mac_multicast_adr {
 #define MWL8K_ENABLE_RX_BROADCAST	0x0008
 
 static struct mwl8k_cmd_pkt *
-__mwl8k_cmd_mac_multicast_adr(struct ieee80211_hw *hw,
+__mwl8k_cmd_mac_multicast_adr(struct ieee80211_hw *hw, int allmulti,
 			      int mc_count, struct dev_addr_list *mclist)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_cmd_mac_multicast_adr *cmd;
-	int allmulti;
 	int size;
 
-	allmulti = 0;
-	if (mc_count > priv->num_mcaddrs) {
+	if (allmulti || mc_count > priv->num_mcaddrs) {
 		allmulti = 1;
 		mc_count = 0;
 	}
@@ -2680,7 +2678,14 @@ static u64 mwl8k_prepare_multicast(struct ieee80211_hw *hw,
 {
 	struct mwl8k_cmd_pkt *cmd;
 
-	cmd = __mwl8k_cmd_mac_multicast_adr(hw, mc_count, mclist);
+	/*
+	 * Synthesize and return a command packet that programs the
+	 * hardware multicast address filter.  At this point we don't
+	 * know whether FIF_ALLMULTI is being requested, but if it is,
+	 * we'll end up throwing this packet away and creating a new
+	 * one in mwl8k_configure_filter().
+	 */
+	cmd = __mwl8k_cmd_mac_multicast_adr(hw, 0, mc_count, mclist);
 
 	return (unsigned long)cmd;
 }
@@ -2691,10 +2696,10 @@ static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 				   u64 multicast)
 {
 	struct mwl8k_priv *priv = hw->priv;
-	struct mwl8k_cmd_pkt *multicast_adr_cmd;
+	struct mwl8k_cmd_pkt *cmd;
 
 	/* Clear unsupported feature flags */
-	*total_flags &= FIF_BCN_PRBRESP_PROMISC;
+	*total_flags &= FIF_ALLMULTI | FIF_BCN_PRBRESP_PROMISC;
 
 	if (mwl8k_fw_lock(hw))
 		return;
@@ -2713,10 +2718,22 @@ static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 		}
 	}
 
-	multicast_adr_cmd = (void *)(unsigned long)multicast;
-	if (multicast_adr_cmd != NULL) {
-		mwl8k_post_cmd(hw, multicast_adr_cmd);
-		kfree(multicast_adr_cmd);
+	cmd = (void *)(unsigned long)multicast;
+
+	/*
+	 * If FIF_ALLMULTI is being requested, throw away the command
+	 * packet that ->prepare_multicast() built and replace it with
+	 * a command packet that enables reception of all multicast
+	 * packets.
+	 */
+	if (*total_flags & FIF_ALLMULTI) {
+		kfree(cmd);
+		cmd = __mwl8k_cmd_mac_multicast_adr(hw, 1, 0, NULL);
+	}
+
+	if (cmd != NULL) {
+		mwl8k_post_cmd(hw, cmd);
+		kfree(cmd);
 	}
 
 	mwl8k_fw_unlock(hw);
-- 
1.5.6.4
