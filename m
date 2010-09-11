Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14287 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541Ab0IKQGp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 12:06:45 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/10] iwlwifi: make sure runtime calibration is enabled after association
Date: Sat, 11 Sep 2010 09:08:37 -0700
Message-Id: <1284221318-28281-10-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1284221318-28281-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1284221318-28281-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Clear the "start calib" flag only for new association,
The flag will be set in post_associate function to trigger
the runtime calibration. Set this flag to "0" will stop the
runtime sensitivity calibration

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a19671d..36df9a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -226,9 +226,8 @@ int iwl_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 			return ret;
 		}
 	}
-
-	priv->start_calib = 0;
 	if (new_assoc) {
+		priv->start_calib = 0;
 		/* Apply the new configuration
 		 * RXON assoc doesn't clear the station table in uCode,
 		 */
-- 
1.7.0.4

