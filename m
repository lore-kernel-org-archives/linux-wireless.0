Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:62414 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497Ab1D3Qko (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 12:40:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/14] iwlagn: introduce silent grabbing of NIC access
Date: Sat, 30 Apr 2011 09:17:28 -0700
Message-Id: <1304180260-13875-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110430_184049_610457_D66EB627)
In-Reply-To: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are a few cases like the WoWLAN support
I'm writing that require attempting to access
the NIC when it is known that it might not be
accessible, e.g. after the system woke up and
the platform might have reset the device.

To avoid messages in this case, introduce the
new function iwl_grab_nic_access_silent(), it
will only return an error status.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-io.c |   18 +++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-io.h |    1 +
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index 993b3df..aa4a906 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -73,10 +73,9 @@ int iwl_poll_bit(struct iwl_priv *priv, u32 addr,
 	return -ETIMEDOUT;
 }
 
-int iwl_grab_nic_access(struct iwl_priv *priv)
+int iwl_grab_nic_access_silent(struct iwl_priv *priv)
 {
 	int ret;
-	u32 val;
 
 	lockdep_assert_held(&priv->reg_lock);
 
@@ -107,9 +106,6 @@ int iwl_grab_nic_access(struct iwl_priv *priv)
 			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
 			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 15000);
 	if (ret < 0) {
-		val = iwl_read32(priv, CSR_GP_CNTRL);
-		IWL_ERR(priv,
-			"MAC is in deep sleep!. CSR_GP_CNTRL = 0x%08X\n", val);
 		iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_FORCE_NMI);
 		return -EIO;
 	}
@@ -117,6 +113,18 @@ int iwl_grab_nic_access(struct iwl_priv *priv)
 	return 0;
 }
 
+int iwl_grab_nic_access(struct iwl_priv *priv)
+{
+	int ret = iwl_grab_nic_access_silent(priv);
+	if (ret) {
+		u32 val = iwl_read32(priv, CSR_GP_CNTRL);
+		IWL_ERR(priv,
+			"MAC is in deep sleep!. CSR_GP_CNTRL = 0x%08X\n", val);
+	}
+
+	return ret;
+}
+
 void iwl_release_nic_access(struct iwl_priv *priv)
 {
 	lockdep_assert_held(&priv->reg_lock);
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 262e026..869edc5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -62,6 +62,7 @@ int iwl_poll_bit(struct iwl_priv *priv, u32 addr,
 int iwl_poll_direct_bit(struct iwl_priv *priv, u32 addr, u32 mask,
 			int timeout);
 
+int iwl_grab_nic_access_silent(struct iwl_priv *priv);
 int iwl_grab_nic_access(struct iwl_priv *priv);
 void iwl_release_nic_access(struct iwl_priv *priv);
 
-- 
1.7.0.4

