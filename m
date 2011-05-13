Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53515 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801Ab1EMTip (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 15:38:45 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/13] iwlagn: always send RXON with disassociate flag before associate
Date: Fri, 13 May 2011 12:13:27 -0700
Message-Id: <1305314010-18073-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110513_213913_567080_8CBFF64E)
In-Reply-To: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before send the RXON command with associated flag set, always do disassociate
first to make sure uCode is in the correct state.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    8 +++-----
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    5 +++++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 0238743..7d40e2d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -389,11 +389,9 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	 * AP station must be done after the BSSID is set to correctly
 	 * set up filters in the device.
 	 */
-	if ((old_assoc && new_assoc) || !new_assoc) {
-		ret = iwlagn_rxon_disconn(priv, ctx);
-		if (ret)
-			return ret;
-	}
+	ret = iwlagn_rxon_disconn(priv, ctx);
+	if (ret)
+		return ret;
 
 	if (new_assoc)
 		return iwlagn_rxon_connect(priv, ctx);
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 2f6b38c..54a935f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -582,6 +582,11 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	int trace_idx;
 #endif
 
+	if (test_bit(STATUS_FW_ERROR, &priv->status)) {
+		IWL_WARN(priv, "fw recovery, no hcmd send\n");
+		return -EIO;
+	}
+
 	copy_size = sizeof(out_cmd->hdr);
 	cmd_size = sizeof(out_cmd->hdr);
 
-- 
1.7.0.4

