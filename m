Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58825 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab0ALMrd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 07:47:33 -0500
Date: Tue, 12 Jan 2010 13:47:32 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 02/17] mwl8k: remove (mostly) write-only variable priv->current_channel
Message-ID: <20100112124732.GR1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 01cabab..f2c4524 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -156,8 +156,6 @@ struct mwl8k_priv {
 
 	struct ieee80211_vif *vif;
 
-	struct ieee80211_channel *current_channel;
-
 	/* power management status cookie from firmware */
 	u32 *cookie;
 	dma_addr_t cookie_dma;
@@ -3050,7 +3048,7 @@ static int mwl8k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	int index = skb_get_queue_mapping(skb);
 	int rc;
 
-	if (priv->current_channel == NULL) {
+	if (!priv->radio_on) {
 		printk(KERN_DEBUG "%s: dropped TX frame since radio "
 		       "disabled\n", wiphy_name(hw->wiphy));
 		dev_kfree_skb(skb);
@@ -3182,7 +3180,6 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 	mwl8k_vif->seqno = 0;
 
 	priv->vif = vif;
-	priv->current_channel = NULL;
 
 	return 0;
 }
@@ -3208,7 +3205,6 @@ static int mwl8k_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (conf->flags & IEEE80211_CONF_IDLE) {
 		mwl8k_cmd_radio_disable(hw);
-		priv->current_channel = NULL;
 		return 0;
 	}
 
@@ -3224,8 +3220,6 @@ static int mwl8k_config(struct ieee80211_hw *hw, u32 changed)
 	if (rc)
 		goto out;
 
-	priv->current_channel = conf->channel;
-
 	if (conf->power_level > 18)
 		conf->power_level = 18;
 	rc = mwl8k_cmd_rf_tx_power(hw, conf->power_level);
-- 
1.5.6.4
