Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:59622 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648AbZJVSxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:53:50 -0400
Date: Thu, 22 Oct 2009 20:21:40 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 26/28] mwl8k: add AP firmware (mbss) handling to mwl8k_set_mac_addr()
Message-ID: <20091022182140.GB1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index b2c68b2..4eda6f9 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2134,11 +2134,18 @@ static int mwl8k_enable_sniffer(struct ieee80211_hw *hw, bool enable)
  */
 struct mwl8k_cmd_set_mac_addr {
 	struct mwl8k_cmd_pkt header;
-	__u8 mac_addr[ETH_ALEN];
+	union {
+		struct {
+			__le16 mac_type;
+			__u8 mac_addr[ETH_ALEN];
+		} mbss;
+		__u8 mac_addr[ETH_ALEN];
+	};
 } __attribute__((packed));
 
 static int mwl8k_set_mac_addr(struct ieee80211_hw *hw, u8 *mac)
 {
+	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_cmd_set_mac_addr *cmd;
 	int rc;
 
@@ -2148,7 +2155,12 @@ static int mwl8k_set_mac_addr(struct ieee80211_hw *hw, u8 *mac)
 
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_MAC_ADDR);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-	memcpy(cmd->mac_addr, mac, ETH_ALEN);
+	if (priv->ap_fw) {
+		cmd->mbss.mac_type = 0;
+		memcpy(cmd->mbss.mac_addr, mac, ETH_ALEN);
+	} else {
+		memcpy(cmd->mac_addr, mac, ETH_ALEN);
+	}
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
-- 
1.5.6.4
