Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37368 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbbHDU65 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:58:57 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/37] iwlwifi: dvm: start HW before running FW
Date: Tue,  4 Aug 2015 23:42:54 +0300
Message-Id: <1438721007-23283-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230055_221156_0E82E317)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new locking in PCIe transport requires to start_hw
before start_fw. This uncovered a bug in dvm which failed
to do so.
Fix that.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 7acaa26..f603fb3 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -250,12 +250,24 @@ static int __iwl_up(struct iwl_priv *priv)
 		}
 	}
 
+	ret = iwl_trans_start_hw(priv->trans);
+	if (ret) {
+		IWL_ERR(priv, "Failed to start HW: %d\n", ret);
+		goto error;
+	}
+
 	ret = iwl_run_init_ucode(priv);
 	if (ret) {
 		IWL_ERR(priv, "Failed to run INIT ucode: %d\n", ret);
 		goto error;
 	}
 
+	ret = iwl_trans_start_hw(priv->trans);
+	if (ret) {
+		IWL_ERR(priv, "Failed to start HW: %d\n", ret);
+		goto error;
+	}
+
 	ret = iwl_load_ucode_wait_alive(priv, IWL_UCODE_REGULAR);
 	if (ret) {
 		IWL_ERR(priv, "Failed to start RT ucode: %d\n", ret);
-- 
2.1.4

