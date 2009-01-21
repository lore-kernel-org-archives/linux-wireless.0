Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:44165 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943AbZAUFbb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 00:31:31 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/5] iwl3945: fix deep sleep when removing the driver.
Date: Tue, 20 Jan 2009 21:33:55 -0800
Message-Id: <1232516035-25524-6-git-send-email-reinette.chatre@intel.com> (sfid-20090121_063156_050896_7DA7FA84)
In-Reply-To: <1232516035-25524-5-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232516035-25524-1-git-send-email-reinette.chatre@intel.com>
 <1232516035-25524-2-git-send-email-reinette.chatre@intel.com>
 <1232516035-25524-3-git-send-email-reinette.chatre@intel.com>
 <1232516035-25524-4-git-send-email-reinette.chatre@intel.com>
 <1232516035-25524-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abbas, Mohamed <mohamed.abbas@intel.com>

A warning message "MAC is in deep sleep" sometimes happen when user removes
the driver.  This warning is related to card not being ready. In __iwl3945_down
function some of the going down steps are in wrong order, to fix this this patch
do the following:
	1- make sure we are calling iwl3945_apm_reset and iwl3945_apm_stop
	   in the right order.

	2- make sure we set CSR_GP_CNTRL_REG_FLAG_INIT_DONE in apm_reset before
	   poll on CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY.

	3- set correct polling counter.

This fixes bug
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1834

Signed-off-by: mohamed abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    8 +++-----
 drivers/net/wireless/iwlwifi/iwl-io.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 ++++++-
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index e6d4503..8b486c9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1332,6 +1332,9 @@ static int iwl3945_apm_reset(struct iwl_priv *priv)
 	spin_lock_irqsave(&priv->lock, flags);
 
 	iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+	udelay(10);
+
+	iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
 
 	iwl_poll_direct_bit(priv, CSR_GP_CNTRL,
 			 CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
@@ -1341,11 +1344,6 @@ static int iwl3945_apm_reset(struct iwl_priv *priv)
 		iwl_write_prph(priv, APMG_CLK_CTRL_REG,
 					 APMG_CLK_VAL_BSM_CLK_RQT);
 
-		udelay(10);
-
-		iwl_set_bit(priv, CSR_GP_CNTRL,
-			    CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-
 		iwl_write_prph(priv, APMG_RTC_INT_MSK_REG, 0x0);
 		iwl_write_prph(priv, APMG_RTC_INT_STT_REG,
 					0xFFFFFFFF);
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index bc3f3da..7341a2d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -165,7 +165,7 @@ static inline int _iwl_grab_nic_access(struct iwl_priv *priv)
 	ret = _iwl_poll_bit(priv, CSR_GP_CNTRL,
 			   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
 			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
-			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 50);
+			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 15000);
 	if (ret < 0) {
 		IWL_ERR(priv, "MAC is in deep sleep!\n");
 		return -EIO;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index be02272..e595c5a 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5295,6 +5295,7 @@ static void __iwl3945_down(struct iwl_priv *priv)
 			test_bit(STATUS_EXIT_PENDING, &priv->status) <<
 				STATUS_EXIT_PENDING;
 
+	priv->cfg->ops->lib->apm_ops.reset(priv);
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl_clear_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -5312,7 +5313,11 @@ static void __iwl3945_down(struct iwl_priv *priv)
 
 	udelay(5);
 
-	priv->cfg->ops->lib->apm_ops.reset(priv);
+	if (exit_pending || test_bit(STATUS_IN_SUSPEND, &priv->status))
+		priv->cfg->ops->lib->apm_ops.stop(priv);
+	else
+		priv->cfg->ops->lib->apm_ops.reset(priv);
+
  exit:
 	memset(&priv->card_alive, 0, sizeof(struct iwl_alive_resp));
 
-- 
1.5.4.3

