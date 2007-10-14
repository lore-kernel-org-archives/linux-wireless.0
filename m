Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:24399 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbXJNUWU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2007 16:22:20 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5/5] iwlwifi: remove cck_power_index_compensation
Date: Sun, 14 Oct 2007 22:20:34 +0200
Message-Id: <11923932402777-git-send-email-tomas.winkler@intel.com> (sfid-20071014_212232_137970_7741F810)
In-Reply-To: <11923932403492-git-send-email-tomas.winkler@intel.com>
References: <11923932343888-git-send-email-tomas.winkler@intel.com>
 <11923932403473-git-send-email-tomas.winkler@intel.com>
 <11923932401165-git-send-email-tomas.winkler@intel.com>
 <11923932403492-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cck_power_index_compensation variable was never used

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-priv.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 --
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-priv.h b/drivers/net/wireless/iwlwifi/iwl-priv.h
index 6b490d0..f43679a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-priv.h
+++ b/drivers/net/wireless/iwlwifi/iwl-priv.h
@@ -278,7 +278,6 @@ struct iwl_priv {
 #define IWL_DEFAULT_TX_POWER 0x0F
 	s8 user_txpower_limit;
 	s8 max_channel_txpower_limit;
-	u32 cck_power_index_compensation;
 
 #ifdef CONFIG_PM
 	u32 pm_state[16];
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index a198b01..9cd8dcb 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -8982,8 +8982,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->channel_width = IWL_CHANNEL_WIDTH_40MHZ;
 	priv->valid_antenna = 0x7;	/* assume all 3 connected */
 	priv->ps_mode = IWL_MIMO_PS_NONE;
-	priv->cck_power_index_compensation = iwl_read32(
-		priv, CSR_HW_REV_WA_REG);
 
 	iwl4965_set_rxon_chain(priv);
 
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
