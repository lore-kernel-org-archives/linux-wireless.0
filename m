Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43814 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649AbYICDbP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:31:15 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 15/39] iwlwifi: remove rfkill warning from iwl-io
Date: Wed,  3 Sep 2008 11:26:35 +0800
Message-Id: <1220412419-15404-16-git-send-email-yi.zhu@intel.com> (sfid-20080903_053123_793622_FEA87BAD)
In-Reply-To: <1220412419-15404-15-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-3-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-4-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-5-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-6-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-7-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-8-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-9-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-10-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-11-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-12-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-13-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-14-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-15-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

The patch removes the warning since registers might be accessed also
during rfkill.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-io.h |   18 ------------------
 drivers/net/wireless/iwlwifi/iwl-io.h      |   18 ------------------
 2 files changed, 0 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-io.h b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
index 98740e8..b3fe48d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-io.h
@@ -153,28 +153,10 @@ static inline void __iwl3945_clear_bit(const char *f, u32 l,
 static inline int _iwl3945_grab_nic_access(struct iwl3945_priv *priv)
 {
 	int ret;
-	u32 gp_ctl;
-
 #ifdef CONFIG_IWL3945_DEBUG
 	if (atomic_read(&priv->restrict_refcnt))
 		return 0;
 #endif
-	if (test_bit(STATUS_RF_KILL_HW, &priv->status) ||
-	    test_bit(STATUS_RF_KILL_SW, &priv->status)) {
-		IWL_WARNING("WARNING: Requesting MAC access during RFKILL "
-			"wakes up NIC\n");
-
-		/* 10 msec allows time for NIC to complete its data save */
-		gp_ctl = _iwl3945_read32(priv, CSR_GP_CNTRL);
-		if (gp_ctl & CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY) {
-			IWL_DEBUG_RF_KILL("Wait for complete power-down, "
-				"gpctl = 0x%08x\n", gp_ctl);
-			mdelay(10);
-		} else
-			IWL_DEBUG_RF_KILL("power-down complete, "
-					  "gpctl = 0x%08x\n", gp_ctl);
-	}
-
 	/* this bit wakes up the NIC */
 	_iwl3945_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 	ret = _iwl3945_poll_bit(priv, CSR_GP_CNTRL,
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 17fb4e2..9740fcc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -155,28 +155,10 @@ static inline void __iwl_clear_bit(const char *f, u32 l,
 static inline int _iwl_grab_nic_access(struct iwl_priv *priv)
 {
 	int ret;
-	u32 gp_ctl;
-
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (atomic_read(&priv->restrict_refcnt))
 		return 0;
 #endif
-	if (test_bit(STATUS_RF_KILL_HW, &priv->status) ||
-	    test_bit(STATUS_RF_KILL_SW, &priv->status)) {
-		IWL_WARNING("WARNING: Requesting MAC access during RFKILL "
-			"wakes up NIC\n");
-
-		/* 10 msec allows time for NIC to complete its data save */
-		gp_ctl = _iwl_read32(priv, CSR_GP_CNTRL);
-		if (gp_ctl & CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY) {
-			IWL_DEBUG_RF_KILL("Wait for complete power-down, "
-				"gpctl = 0x%08x\n", gp_ctl);
-			mdelay(10);
-		} else
-			IWL_DEBUG_RF_KILL("power-down complete, "
-					  "gpctl = 0x%08x\n", gp_ctl);
-	}
-
 	/* this bit wakes up the NIC */
 	_iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 	ret = _iwl_poll_bit(priv, CSR_GP_CNTRL,
-- 
1.5.3.6

