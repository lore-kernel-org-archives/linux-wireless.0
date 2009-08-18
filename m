Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:40173 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbZHRDvv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:51:51 -0400
Date: Tue, 18 Aug 2009 05:51:52 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 06/29] mwl8k: remove MWL8K_RADIO_*_PREAMBLE defines
Message-ID: <20090818035152.GK18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   22 +++++-----------------
 1 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index f57d28c..92b2fce 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -187,9 +187,7 @@ struct mwl8k_priv {
 	struct ieee80211_rate rates[12];
 
 	bool radio_on;
-
-	/* RF preamble: Short, Long or Auto */
-	u8	radio_preamble;
+	bool radio_short_preamble;
 
 	/* WMM MODE 1 for enabled; 0 for disabled */
 	bool wmm_mode;
@@ -278,17 +276,10 @@ static const struct ieee80211_rate mwl8k_rates[] = {
 	{ .bitrate = 540, .hw_value = 108, },
 };
 
-/* Radio settings */
-#define MWL8K_RADIO_AUTO_PREAMBLE	0x0005
-#define MWL8K_RADIO_SHORT_PREAMBLE	0x0003
-#define MWL8K_RADIO_LONG_PREAMBLE	0x0001
-
 /* WMM */
 #define MWL8K_WMM_ENABLE		1
 #define MWL8K_WMM_DISABLE		0
 
-#define MWL8K_RADIO_DEFAULT_PREAMBLE	MWL8K_RADIO_LONG_PREAMBLE
-
 /* Slot time */
 
 /* Short Slot: 9us slot time */
@@ -1741,7 +1732,7 @@ mwl8k_cmd_802_11_radio_control(struct ieee80211_hw *hw, bool enable, bool force)
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_RADIO_CONTROL);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
 	cmd->action = cpu_to_le16(MWL8K_CMD_SET);
-	cmd->control = cpu_to_le16(priv->radio_preamble);
+	cmd->control = cpu_to_le16(priv->radio_short_preamble ? 3 : 1);
 	cmd->radio_on = cpu_to_le16(enable ? 0x0001 : 0x0000);
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
@@ -1772,9 +1763,7 @@ mwl8k_set_radio_preamble(struct ieee80211_hw *hw, bool short_preamble)
 		return -EINVAL;
 	priv = hw->priv;
 
-	priv->radio_preamble = (short_preamble ?
-		MWL8K_RADIO_SHORT_PREAMBLE :
-		MWL8K_RADIO_LONG_PREAMBLE);
+	priv->radio_short_preamble = short_preamble;
 
 	return mwl8k_cmd_802_11_radio_control(hw, 1, 1);
 }
@@ -3058,8 +3047,7 @@ static int mwl8k_bss_info_changed_wt(struct work_struct *wt)
 			goto mwl8k_bss_info_changed_exit;
 
 		/* Set radio preamble */
-		if (mwl8k_set_radio_preamble(hw,
-				info->use_short_preamble))
+		if (mwl8k_set_radio_preamble(hw, info->use_short_preamble))
 			goto mwl8k_bss_info_changed_exit;
 
 		/* Set slot time */
@@ -3491,8 +3479,8 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	priv->vif = NULL;
 
 	/* Set default radio state and preamble */
-	priv->radio_preamble = MWL8K_RADIO_DEFAULT_PREAMBLE;
 	priv->radio_on = 0;
+	priv->radio_short_preamble = 0;
 
 	/* Finalize join worker */
 	INIT_WORK(&priv->finalize_join_worker, mwl8k_finalize_join_worker);
-- 
1.5.6.4
