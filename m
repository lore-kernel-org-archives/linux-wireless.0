Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:55762 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756597Ab3AYK6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 05:58:54 -0500
Date: Fri, 25 Jan 2013 16:20:35 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 5/7] mwl8k: Add/Del self entry for AP interface only
Message-ID: <20130125105035.GA9473@markyou.marvell.com> (sfid-20130125_115859_934486_17450E74)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add and delete self entry in the firmware sta database
for AP interface only. We do not need such an entry for
STA interface.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index a83f3ca..7002fc8 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -4708,7 +4708,7 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 	/* Set the mac address.  */
 	mwl8k_cmd_set_mac_addr(hw, vif, vif->addr);
 
-	if (priv->ap_fw)
+	if (vif->type == NL80211_IFTYPE_AP)
 		mwl8k_cmd_set_new_stn_add_self(hw, vif);
 
 	priv->macids_used |= 1 << mwl8k_vif->macid;
@@ -4733,7 +4733,7 @@ static void mwl8k_remove_interface(struct ieee80211_hw *hw,
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_vif *mwl8k_vif = MWL8K_VIF(vif);
 
-	if (priv->ap_fw)
+	if (vif->type == NL80211_IFTYPE_AP)
 		mwl8k_cmd_set_new_stn_del(hw, vif, vif->addr);
 
 	mwl8k_cmd_del_mac_addr(hw, vif, vif->addr);
-- 
1.8.0.3

