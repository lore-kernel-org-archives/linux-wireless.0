Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:40171 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbZHRDvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:51:43 -0400
Date: Tue, 18 Aug 2009 05:51:44 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 05/29] mwl8k: remove MWL8K_RADIO_* defines
Message-ID: <20090818035144.GJ18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of passing a flag bitmask to mwl8k_cmd_802_11_radio_control,
pass the 'enable' and 'force' arguments as separate parameters, and
introduce wrappers for the common cases of enabling and disabling
without forcing.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   52 +++++++++++++++++++++--------------------
 1 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index a3b0e19..f57d28c 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -186,9 +186,10 @@ struct mwl8k_priv {
 	struct ieee80211_channel channels[14];
 	struct ieee80211_rate rates[12];
 
+	bool radio_on;
+
 	/* RF preamble: Short, Long or Auto */
 	u8	radio_preamble;
-	u8	radio_state;
 
 	/* WMM MODE 1 for enabled; 0 for disabled */
 	bool wmm_mode;
@@ -278,9 +279,6 @@ static const struct ieee80211_rate mwl8k_rates[] = {
 };
 
 /* Radio settings */
-#define MWL8K_RADIO_FORCE		0x2
-#define MWL8K_RADIO_ENABLE		0x1
-#define MWL8K_RADIO_DISABLE		0x0
 #define MWL8K_RADIO_AUTO_PREAMBLE	0x0005
 #define MWL8K_RADIO_SHORT_PREAMBLE	0x0003
 #define MWL8K_RADIO_LONG_PREAMBLE	0x0001
@@ -1195,7 +1193,7 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw, u32 delay_ms)
 	count = mwl8k_txq_busy(priv);
 	if (count) {
 		priv->tx_wait = &cmd_wait;
-		if (priv->radio_state)
+		if (priv->radio_on)
 			mwl8k_tx_start(priv);
 	}
 	spin_unlock_bh(&priv->tx_lock);
@@ -1318,7 +1316,7 @@ static void mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int force)
 
 		ieee80211_tx_status_irqsafe(hw, skb);
 
-		wake = !priv->inconfig && priv->radio_state;
+		wake = !priv->inconfig && priv->radio_on;
 	}
 
 	if (wake)
@@ -1726,18 +1724,16 @@ struct mwl8k_cmd_802_11_radio_control {
 	__le16 radio_on;
 } __attribute__((packed));
 
-static int mwl8k_cmd_802_11_radio_control(struct ieee80211_hw *hw, int enable)
+static int
+mwl8k_cmd_802_11_radio_control(struct ieee80211_hw *hw, bool enable, bool force)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_cmd_802_11_radio_control *cmd;
 	int rc;
 
-	if (((enable & MWL8K_RADIO_ENABLE) == priv->radio_state) &&
-	    !(enable & MWL8K_RADIO_FORCE))
+	if (enable == priv->radio_on && !force)
 		return 0;
 
-	enable &= MWL8K_RADIO_ENABLE;
-
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (cmd == NULL)
 		return -ENOMEM;
@@ -1752,11 +1748,21 @@ static int mwl8k_cmd_802_11_radio_control(struct ieee80211_hw *hw, int enable)
 	kfree(cmd);
 
 	if (!rc)
-		priv->radio_state = enable;
+		priv->radio_on = enable;
 
 	return rc;
 }
 
+static int mwl8k_cmd_802_11_radio_disable(struct ieee80211_hw *hw)
+{
+	return mwl8k_cmd_802_11_radio_control(hw, 0, 0);
+}
+
+static int mwl8k_cmd_802_11_radio_enable(struct ieee80211_hw *hw)
+{
+	return mwl8k_cmd_802_11_radio_control(hw, 1, 0);
+}
+
 static int
 mwl8k_set_radio_preamble(struct ieee80211_hw *hw, bool short_preamble)
 {
@@ -1770,8 +1776,7 @@ mwl8k_set_radio_preamble(struct ieee80211_hw *hw, bool short_preamble)
 		MWL8K_RADIO_SHORT_PREAMBLE :
 		MWL8K_RADIO_LONG_PREAMBLE);
 
-	return mwl8k_cmd_802_11_radio_control(hw,
-			MWL8K_RADIO_ENABLE | MWL8K_RADIO_FORCE);
+	return mwl8k_cmd_802_11_radio_control(hw, 1, 1);
 }
 
 /*
@@ -2483,7 +2488,7 @@ static irqreturn_t mwl8k_interrupt(int irq, void *dev_id)
 
 	if (status & MWL8K_A2H_INT_QUEUE_EMPTY) {
 		if (!priv->inconfig &&
-			priv->radio_state &&
+			priv->radio_on &&
 			mwl8k_txq_busy(priv))
 				mwl8k_tx_start(priv);
 	}
@@ -2661,7 +2666,7 @@ static void mwl8k_config_thread(struct work_struct *wt)
 
 	spin_lock_irq(&priv->tx_lock);
 	priv->inconfig = false;
-	if (priv->pending_tx_pkts && priv->radio_state)
+	if (priv->pending_tx_pkts && priv->radio_on)
 		mwl8k_tx_start(priv);
 	spin_unlock_irq(&priv->tx_lock);
 	ieee80211_wake_queues(hw);
@@ -2745,7 +2750,7 @@ static int mwl8k_start_wt(struct work_struct *wt)
 	}
 
 	/* Turn on radio */
-	if (mwl8k_cmd_802_11_radio_control(hw, MWL8K_RADIO_ENABLE)) {
+	if (mwl8k_cmd_802_11_radio_enable(hw)) {
 		rc = -EIO;
 		goto mwl8k_start_exit;
 	}
@@ -2839,11 +2844,8 @@ static int mwl8k_stop_wt(struct work_struct *wt)
 {
 	struct mwl8k_stop_worker *worker = (struct mwl8k_stop_worker *)wt;
 	struct ieee80211_hw *hw = worker->header.hw;
-	int rc;
-
-	rc = mwl8k_cmd_802_11_radio_control(hw, MWL8K_RADIO_DISABLE);
 
-	return rc;
+	return mwl8k_cmd_802_11_radio_disable(hw);
 }
 
 static void mwl8k_stop(struct ieee80211_hw *hw)
@@ -2959,13 +2961,13 @@ static int mwl8k_config_wt(struct work_struct *wt)
 	int rc = 0;
 
 	if (!conf->radio_enabled) {
-		mwl8k_cmd_802_11_radio_control(hw, MWL8K_RADIO_DISABLE);
+		mwl8k_cmd_802_11_radio_disable(hw);
 		priv->current_channel = NULL;
 		rc = 0;
 		goto mwl8k_config_exit;
 	}
 
-	if (mwl8k_cmd_802_11_radio_control(hw, MWL8K_RADIO_ENABLE)) {
+	if (mwl8k_cmd_802_11_radio_enable(hw)) {
 		rc = -EINVAL;
 		goto mwl8k_config_exit;
 	}
@@ -3490,7 +3492,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 
 	/* Set default radio state and preamble */
 	priv->radio_preamble = MWL8K_RADIO_DEFAULT_PREAMBLE;
-	priv->radio_state = MWL8K_RADIO_DISABLE;
+	priv->radio_on = 0;
 
 	/* Finalize join worker */
 	INIT_WORK(&priv->finalize_join_worker, mwl8k_finalize_join_worker);
@@ -3571,7 +3573,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	}
 
 	/* Turn radio off */
-	rc = mwl8k_cmd_802_11_radio_control(hw, MWL8K_RADIO_DISABLE);
+	rc = mwl8k_cmd_802_11_radio_disable(hw);
 	if (rc) {
 		printk(KERN_ERR "%s: Cannot disable\n", priv->name);
 		goto err_stop_firmware;
-- 
1.5.6.4
