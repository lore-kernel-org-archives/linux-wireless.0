Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:49170 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522AbZJVShK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:37:10 -0400
Date: Thu, 22 Oct 2009 20:19:41 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 04/28] mwl8k: fix multicast address filter programming
Message-ID: <20091022181941.GF1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mwl8k's ->prepare_multicast() currently just enables reception of
all multicast packets, which is somewhat ineffective.

Fix this by either disabling all multicast RX, enabling multicast
RX according to the multicast address filter table, or enabling all
multicast RX, depending on whether ->prepare_multicast() was given
any multicast addresses and whether the hardware multicast address
filter table is large enough to fit all requested addresses.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   40 +++++++++++++++++++++++++++-------------
 1 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index ba7b8ef..0b4fa14 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1539,7 +1539,10 @@ struct mwl8k_cmd_mac_multicast_adr {
 	__u8 addr[0][ETH_ALEN];
 };
 
-#define MWL8K_ENABLE_RX_MULTICAST 0x000F
+#define MWL8K_ENABLE_RX_DIRECTED	0x0001
+#define MWL8K_ENABLE_RX_MULTICAST	0x0002
+#define MWL8K_ENABLE_RX_ALL_MULTICAST	0x0004
+#define MWL8K_ENABLE_RX_BROADCAST	0x0008
 
 static struct mwl8k_cmd_pkt *
 __mwl8k_cmd_mac_multicast_adr(struct ieee80211_hw *hw,
@@ -1547,11 +1550,14 @@ __mwl8k_cmd_mac_multicast_adr(struct ieee80211_hw *hw,
 {
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_cmd_mac_multicast_adr *cmd;
+	int allmulti;
 	int size;
-	int i;
 
-	if (mc_count > priv->num_mcaddrs)
-		mc_count = priv->num_mcaddrs;
+	allmulti = 0;
+	if (mc_count > priv->num_mcaddrs) {
+		allmulti = 1;
+		mc_count = 0;
+	}
 
 	size = sizeof(*cmd) + mc_count * ETH_ALEN;
 
@@ -1561,16 +1567,24 @@ __mwl8k_cmd_mac_multicast_adr(struct ieee80211_hw *hw,
 
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_MAC_MULTICAST_ADR);
 	cmd->header.length = cpu_to_le16(size);
-	cmd->action = cpu_to_le16(MWL8K_ENABLE_RX_MULTICAST);
-	cmd->numaddr = cpu_to_le16(mc_count);
-
-	for (i = 0; i < mc_count && mclist; i++) {
-		if (mclist->da_addrlen != ETH_ALEN) {
-			kfree(cmd);
-			return NULL;
+	cmd->action = cpu_to_le16(MWL8K_ENABLE_RX_DIRECTED |
+				  MWL8K_ENABLE_RX_BROADCAST);
+
+	if (allmulti) {
+		cmd->action |= cpu_to_le16(MWL8K_ENABLE_RX_ALL_MULTICAST);
+	} else if (mc_count) {
+		int i;
+
+		cmd->action |= cpu_to_le16(MWL8K_ENABLE_RX_MULTICAST);
+		cmd->numaddr = cpu_to_le16(mc_count);
+		for (i = 0; i < mc_count && mclist; i++) {
+			if (mclist->da_addrlen != ETH_ALEN) {
+				kfree(cmd);
+				return NULL;
+			}
+			memcpy(cmd->addr[i], mclist->da_addr, ETH_ALEN);
+			mclist = mclist->next;
 		}
-		memcpy(cmd->addr[i], mclist->da_addr, ETH_ALEN);
-		mclist = mclist->next;
 	}
 
 	return &cmd->header;
-- 
1.5.6.4
