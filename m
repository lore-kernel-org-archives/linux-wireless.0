Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58849 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab0ALMtw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 07:49:52 -0500
Date: Tue, 12 Jan 2010 13:49:51 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 13/17] mwl8k: convert the priv->vif pointer to a list of vifs
Message-ID: <20100112124951.GC1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To prepare for adding multi-BSS support.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   51 ++++++++++++++++++++++++++++-------------
 1 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 382ef43..ee7d8a6 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -160,7 +160,8 @@ struct mwl8k_priv {
 	/* TX quiesce completion, protected by fw_mutex and tx_lock */
 	struct completion *tx_wait;
 
-	struct ieee80211_vif *vif;
+	/* List of interfaces.  */
+	struct list_head vif_list;
 
 	/* power management status cookie from firmware */
 	u32 *cookie;
@@ -210,6 +211,9 @@ struct mwl8k_priv {
 
 /* Per interface specific private data */
 struct mwl8k_vif {
+	struct list_head list;
+	struct ieee80211_vif *vif;
+
 	/* Non AMPDU sequence number assigned by driver.  */
 	u16 seqno;
 };
@@ -3246,7 +3250,7 @@ static void mwl8k_stop(struct ieee80211_hw *hw)
 }
 
 static int mwl8k_add_interface(struct ieee80211_hw *hw,
-				struct ieee80211_vif *vif)
+			       struct ieee80211_vif *vif)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_vif *mwl8k_vif;
@@ -3254,7 +3258,7 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 	/*
 	 * We only support one active interface at a time.
 	 */
-	if (priv->vif != NULL)
+	if (!list_empty(&priv->vif_list))
 		return -EBUSY;
 
 	/*
@@ -3275,14 +3279,13 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 	if (priv->ap_fw)
 		mwl8k_cmd_set_new_stn_add_self(hw, vif);
 
-	/* Clean out driver private area */
+	/* Setup driver private area. */
 	mwl8k_vif = MWL8K_VIF(vif);
 	memset(mwl8k_vif, 0, sizeof(*mwl8k_vif));
-
-	/* Set Initial sequence number to zero */
+	mwl8k_vif->vif = vif;
 	mwl8k_vif->seqno = 0;
 
-	priv->vif = vif;
+	list_add_tail(&mwl8k_vif->list, &priv->vif_list);
 
 	return 0;
 }
@@ -3291,13 +3294,14 @@ static void mwl8k_remove_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif)
 {
 	struct mwl8k_priv *priv = hw->priv;
+	struct mwl8k_vif *mwl8k_vif = MWL8K_VIF(vif);
 
 	if (priv->ap_fw)
 		mwl8k_cmd_set_new_stn_del(hw, vif, vif->addr);
 
 	mwl8k_cmd_set_mac_addr(hw, "\x00\x00\x00\x00\x00\x00");
 
-	priv->vif = NULL;
+	list_del(&mwl8k_vif->list);
 }
 
 static int mwl8k_config(struct ieee80211_hw *hw, u32 changed)
@@ -3526,7 +3530,7 @@ mwl8k_configure_filter_sniffer(struct ieee80211_hw *hw,
 	 * operation, so refuse to enable sniffer mode if a STA
 	 * interface is active.
 	 */
-	if (priv->vif != NULL) {
+	if (!list_empty(&priv->vif_list)) {
 		if (net_ratelimit())
 			printk(KERN_INFO "%s: not enabling sniffer "
 			       "mode because STA interface is active\n",
@@ -3547,6 +3551,14 @@ mwl8k_configure_filter_sniffer(struct ieee80211_hw *hw,
 	return 1;
 }
 
+static struct mwl8k_vif *mwl8k_first_vif(struct mwl8k_priv *priv)
+{
+	if (!list_empty(&priv->vif_list))
+		return list_entry(priv->vif_list.next, struct mwl8k_vif, list);
+
+	return NULL;
+}
+
 static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 				   unsigned int changed_flags,
 				   unsigned int *total_flags,
@@ -3595,6 +3607,7 @@ static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 			 */
 			mwl8k_cmd_set_pre_scan(hw);
 		} else {
+			struct mwl8k_vif *mwl8k_vif;
 			const u8 *bssid;
 
 			/*
@@ -3605,9 +3618,11 @@ static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 			 * (where the OUI part needs to be nonzero for
 			 * the BSSID to be accepted by POST_SCAN).
 			 */
-			bssid = "\x01\x00\x00\x00\x00\x00";
-			if (priv->vif != NULL)
-				bssid = priv->vif->bss_conf.bssid;
+			mwl8k_vif = mwl8k_first_vif(priv);
+			if (mwl8k_vif != NULL)
+				bssid = mwl8k_vif->vif->bss_conf.bssid;
+			else
+				bssid = "\x01\x00\x00\x00\x00\x00";
 
 			mwl8k_cmd_set_post_scan(hw, bssid);
 		}
@@ -3810,11 +3825,14 @@ static void mwl8k_finalize_join_worker(struct work_struct *work)
 	struct mwl8k_priv *priv =
 		container_of(work, struct mwl8k_priv, finalize_join_worker);
 	struct sk_buff *skb = priv->beacon_skb;
+	struct mwl8k_vif *mwl8k_vif;
 
-	mwl8k_cmd_finalize_join(priv->hw, skb->data, skb->len,
-				priv->vif->bss_conf.dtim_period);
-	dev_kfree_skb(skb);
+	mwl8k_vif = mwl8k_first_vif(priv);
+	if (mwl8k_vif != NULL)
+		mwl8k_cmd_finalize_join(priv->hw, skb->data, skb->len,
+					mwl8k_vif->vif->bss_conf.dtim_period);
 
+	dev_kfree_skb(skb);
 	priv->beacon_skb = NULL;
 }
 
@@ -3986,7 +4004,8 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	hw->flags |= IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_NOISE_DBM;
 	hw->vif_data_size = sizeof(struct mwl8k_vif);
 	hw->sta_data_size = sizeof(struct mwl8k_sta);
-	priv->vif = NULL;
+
+	INIT_LIST_HEAD(&priv->vif_list);
 
 	/* Set default radio state and preamble */
 	priv->radio_on = 0;
-- 
1.5.6.4
