Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59929 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab0JGXIw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:08:52 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 19/22] iwlwifi: fix dual-mode scanning
Date: Thu,  7 Oct 2010 16:07:58 -0700
Message-Id: <1286492881-15743-20-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286492881-15743-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The recent scanning code shuffle accidentally
moved the SCAN_HW bit setting _after_ the PAN
parameters are modified, which means that they
don't take the scan into account -- fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 0ad0d44..c1a3898 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1565,13 +1565,15 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	cmd.data = scan;
 	scan->len = cpu_to_le16(cmd.len);
 
+	/* set scan bit here for PAN params */
+	set_bit(STATUS_SCAN_HW, &priv->status);
+
 	if (priv->cfg->ops->hcmd->set_pan_params) {
 		ret = priv->cfg->ops->hcmd->set_pan_params(priv);
 		if (ret)
 			return ret;
 	}
 
-	set_bit(STATUS_SCAN_HW, &priv->status);
 	ret = iwl_send_cmd_sync(priv, &cmd);
 	if (ret) {
 		clear_bit(STATUS_SCAN_HW, &priv->status);
-- 
1.7.0.4

