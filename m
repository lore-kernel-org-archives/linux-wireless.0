Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:47406 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbZHCT65 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:58:57 -0400
Date: Mon, 3 Aug 2009 21:58:57 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: nico@cam.org
Subject: [PATCH 4/5] mwl8k: prevent crash in ->configure_filter() if no interface was added
Message-ID: <20090803195857.GK18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
Acked-by: Nicolas Pitre <nico@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index a92752e..4890f8f 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -261,7 +261,7 @@ struct mwl8k_vif {
 	 */
 };
 
-#define MWL8K_VIF(_vif) (struct mwl8k_vif *)(&((_vif)->drv_priv))
+#define MWL8K_VIF(_vif) ((struct mwl8k_vif *)&((_vif)->drv_priv))
 
 static const struct ieee80211_channel mwl8k_channels[] = {
 	{ .center_freq = 2412, .hw_value = 1, },
@@ -3228,15 +3228,19 @@ static int mwl8k_configure_filter_wt(struct work_struct *wt)
 	struct dev_addr_list *mclist = worker->mclist;
 
 	struct mwl8k_priv *priv = hw->priv;
-	struct mwl8k_vif *mv_vif;
 	int rc = 0;
 
 	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
 		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
 			rc = mwl8k_cmd_set_pre_scan(hw);
 		else {
-			mv_vif = MWL8K_VIF(priv->vif);
-			rc = mwl8k_cmd_set_post_scan(hw, mv_vif->bssid);
+			u8 *bssid;
+
+			bssid = "\x00\x00\x00\x00\x00\x00";
+			if (priv->vif != NULL)
+				bssid = MWL8K_VIF(priv->vif)->bssid;
+
+			rc = mwl8k_cmd_set_post_scan(hw, bssid);
 		}
 	}
 
-- 
1.5.6.4
