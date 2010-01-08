Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58367 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab0AHRbb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 12:31:31 -0500
Date: Fri, 8 Jan 2010 18:31:30 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 07/11] mwl8k: correctly set the mac_type field for AP SET_MAC_ADDR
Message-ID: <20100108173129.GA1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index f0026f3..428575b 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2607,6 +2607,9 @@ struct mwl8k_cmd_set_mac_addr {
 	};
 } __attribute__((packed));
 
+#define MWL8K_MAC_TYPE_PRIMARY_CLIENT	0
+#define MWL8K_MAC_TYPE_PRIMARY_AP	2
+
 static int mwl8k_cmd_set_mac_addr(struct ieee80211_hw *hw, u8 *mac)
 {
 	struct mwl8k_priv *priv = hw->priv;
@@ -2620,7 +2623,7 @@ static int mwl8k_cmd_set_mac_addr(struct ieee80211_hw *hw, u8 *mac)
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_MAC_ADDR);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
 	if (priv->ap_fw) {
-		cmd->mbss.mac_type = 0;
+		cmd->mbss.mac_type = cpu_to_le16(MWL8K_MAC_TYPE_PRIMARY_AP);
 		memcpy(cmd->mbss.mac_addr, mac, ETH_ALEN);
 	} else {
 		memcpy(cmd->mac_addr, mac, ETH_ALEN);
-- 
1.5.6.4
