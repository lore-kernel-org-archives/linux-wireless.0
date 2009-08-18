Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:40175 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165AbZHRDv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:51:58 -0400
Date: Tue, 18 Aug 2009 05:52:00 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 07/29] mwl8k: remove MWL8K_WMM_* defines
Message-ID: <20090818035200.GL18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 92b2fce..c9bb9b1 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -188,9 +188,7 @@ struct mwl8k_priv {
 
 	bool radio_on;
 	bool radio_short_preamble;
-
-	/* WMM MODE 1 for enabled; 0 for disabled */
-	bool wmm_mode;
+	bool wmm_enabled;
 
 	/* Set if PHY config is in progress */
 	bool inconfig;
@@ -276,10 +274,6 @@ static const struct ieee80211_rate mwl8k_rates[] = {
 	{ .bitrate = 540, .hw_value = 108, },
 };
 
-/* WMM */
-#define MWL8K_WMM_ENABLE		1
-#define MWL8K_WMM_DISABLE		0
-
 /* Slot time */
 
 /* Short Slot: 9us slot time */
@@ -2028,13 +2022,13 @@ static int mwl8k_set_wmm(struct ieee80211_hw *hw, bool enable)
 
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_WMM_MODE);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-	cmd->action = enable ? cpu_to_le16(MWL8K_CMD_SET) : 0;
+	cmd->action = cpu_to_le16(!!enable);
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
 
 	if (!rc)
-		priv->wmm_mode = enable;
+		priv->wmm_enabled = enable;
 
 	return rc;
 }
@@ -2762,7 +2756,7 @@ static int mwl8k_start_wt(struct work_struct *wt)
 	}
 
 	/* Disable WMM. WMM gets enabled when stack sends WMM parms */
-	if (mwl8k_set_wmm(hw, MWL8K_WMM_DISABLE)) {
+	if (mwl8k_set_wmm(hw, 0)) {
 		rc = -EIO;
 		goto mwl8k_start_exit;
 	}
@@ -3260,10 +3254,11 @@ static int mwl8k_conf_tx_wt(struct work_struct *wt)
 	struct mwl8k_priv *priv = hw->priv;
 	int rc = 0;
 
-	if (priv->wmm_mode == MWL8K_WMM_DISABLE)
-		if (mwl8k_set_wmm(hw, MWL8K_WMM_ENABLE)) {
+	if (!priv->wmm_enabled) {
+		if (mwl8k_set_wmm(hw, 1)) {
 			rc = -EINVAL;
 			goto mwl8k_conf_tx_exit;
+		}
 	}
 
 	if (mwl8k_set_edca_params(hw, GET_TXQ(queue), params->cw_min,
@@ -3433,7 +3428,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	priv->hostcmd_wait = NULL;
 	priv->tx_wait = NULL;
 	priv->inconfig = false;
-	priv->wmm_mode = false;
+	priv->wmm_enabled = false;
 	priv->pending_tx_pkts = 0;
 	strncpy(priv->name, MWL8K_NAME, sizeof(priv->name));
 
-- 
1.5.6.4
