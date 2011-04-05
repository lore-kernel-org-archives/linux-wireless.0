Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4582 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab1DERBe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:34 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/25] iwlagn: check more error return code
Date: Tue,  5 Apr 2011 09:42:01 -0700
Message-Id: <1302021732-21250-15-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In alive notify, we should check return code instead of assume everything ok

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index a7c9131..9c5abff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -432,6 +432,7 @@ int iwlagn_alive_notify(struct iwl_priv *priv)
 	unsigned long flags;
 	int i, chan;
 	u32 reg_val;
+	int ret;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -527,9 +528,14 @@ int iwlagn_alive_notify(struct iwl_priv *priv)
 	iwl_clear_bits_prph(priv, APMG_PCIDEV_STT_REG,
 			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
 
-	iwlagn_send_wimax_coex(priv);
+	ret = iwlagn_send_wimax_coex(priv);
+	if (ret)
+		return ret;
+
+	ret = iwlagn_set_Xtal_calib(priv);
+	if (ret)
+		return ret;
 
-	iwlagn_set_Xtal_calib(priv);
 	return iwl_send_calib_results(priv);
 }
 
-- 
1.7.0.4

