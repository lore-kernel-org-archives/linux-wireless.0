Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24527 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991Ab1BUTV1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 14:21:27 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/4] iwlwifi: Loading correct uCode again when fail to load
Date: Mon, 21 Feb 2011 11:06:47 -0800
Message-Id: <1298315209-17986-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1298315209-17986-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1298315209-17986-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During uCode loading, if the reply_alive come back with "failure",
try to load the same uCode again.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index abd0461..c04d991 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -466,6 +466,15 @@ static void iwl_rx_reply_alive(struct iwl_priv *priv,
 		IWL_WARN(priv, "%s uCode did not respond OK.\n",
 			(palive->ver_subtype == INITIALIZE_SUBTYPE) ?
 			"init" : "runtime");
+		/*
+		 * If fail to load init uCode,
+		 * let's try to load the init uCode again.
+		 * We should not get into this situation, but if it
+		 * does happen, we should not move on and loading "runtime"
+		 * without proper calibrate the device.
+		 */
+		if (palive->ver_subtype == INITIALIZE_SUBTYPE)
+			priv->ucode_type = UCODE_NONE;
 		queue_work(priv->workqueue, &priv->restart);
 	}
 }
-- 
1.7.0.4

