Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:49153 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbZJVShI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:37:08 -0400
Date: Thu, 22 Oct 2009 20:20:32 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 12/28] mwl8k: add support for enabling hardware sniffer mode
Message-ID: <20091022182032.GN1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   66 ++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 7462fca..60b0076 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -172,6 +172,7 @@ struct mwl8k_priv {
 
 	bool radio_on;
 	bool radio_short_preamble;
+	bool sniffer_enabled;
 	bool wmm_enabled;
 
 	/* XXX need to convert this to handle multiple interfaces */
@@ -2559,6 +2560,18 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 	if (conf->type != NL80211_IFTYPE_STATION)
 		return -EINVAL;
 
+	/*
+	 * Reject interface creation if sniffer mode is active, as
+	 * STA operation is mutually exclusive with hardware sniffer
+	 * mode.
+	 */
+	if (priv->sniffer_enabled) {
+		printk(KERN_INFO "%s: unable to create STA "
+		       "interface due to sniffer mode being enabled\n",
+		       wiphy_name(hw->wiphy));
+		return -EINVAL;
+	}
+
 	/* Clean out driver private area */
 	mwl8k_vif = MWL8K_VIF(conf->vif);
 	memset(mwl8k_vif, 0, sizeof(*mwl8k_vif));
@@ -2729,13 +2742,56 @@ static u64 mwl8k_prepare_multicast(struct ieee80211_hw *hw,
 	return (unsigned long)cmd;
 }
 
+static int
+mwl8k_configure_filter_sniffer(struct ieee80211_hw *hw,
+			       unsigned int changed_flags,
+			       unsigned int *total_flags)
+{
+	struct mwl8k_priv *priv = hw->priv;
+
+	/*
+	 * Hardware sniffer mode is mutually exclusive with STA
+	 * operation, so refuse to enable sniffer mode if a STA
+	 * interface is active.
+	 */
+	if (priv->vif != NULL) {
+		if (net_ratelimit())
+			printk(KERN_INFO "%s: not enabling sniffer "
+			       "mode because STA interface is active\n",
+			       wiphy_name(hw->wiphy));
+		return 0;
+	}
+
+	if (!priv->sniffer_enabled) {
+		if (mwl8k_enable_sniffer(hw, 1))
+			return 0;
+		priv->sniffer_enabled = true;
+	}
+
+	*total_flags &=	FIF_PROMISC_IN_BSS | FIF_ALLMULTI |
+			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL |
+			FIF_OTHER_BSS;
+
+	return 1;
+}
+
 static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 				   unsigned int changed_flags,
 				   unsigned int *total_flags,
 				   u64 multicast)
 {
 	struct mwl8k_priv *priv = hw->priv;
-	struct mwl8k_cmd_pkt *cmd;
+	struct mwl8k_cmd_pkt *cmd = (void *)(unsigned long)multicast;
+
+	/*
+	 * Enable hardware sniffer mode if FIF_CONTROL or
+	 * FIF_OTHER_BSS is requested.
+	 */
+	if (*total_flags & (FIF_CONTROL | FIF_OTHER_BSS) &&
+	    mwl8k_configure_filter_sniffer(hw, changed_flags, total_flags)) {
+		kfree(cmd);
+		return;
+	}
 
 	/* Clear unsupported feature flags */
 	*total_flags &= FIF_ALLMULTI | FIF_BCN_PRBRESP_PROMISC;
@@ -2743,6 +2799,11 @@ static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 	if (mwl8k_fw_lock(hw))
 		return;
 
+	if (priv->sniffer_enabled) {
+		mwl8k_enable_sniffer(hw, 0);
+		priv->sniffer_enabled = false;
+	}
+
 	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
 		if (*total_flags & FIF_BCN_PRBRESP_PROMISC) {
 			/*
@@ -2768,8 +2829,6 @@ static void mwl8k_configure_filter(struct ieee80211_hw *hw,
 		}
 	}
 
-	cmd = (void *)(unsigned long)multicast;
-
 	/*
 	 * If FIF_ALLMULTI is being requested, throw away the command
 	 * packet that ->prepare_multicast() built and replace it with
@@ -2928,6 +2987,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	priv = hw->priv;
 	priv->hw = hw;
 	priv->pdev = pdev;
+	priv->sniffer_enabled = false;
 	priv->wmm_enabled = false;
 	priv->pending_tx_pkts = 0;
 
-- 
1.5.6.4
