Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24115 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908Ab0HWOxd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:33 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/26] iwlwifi: indicate bt_kill condition when receive tx reply
Date: Mon, 23 Aug 2010 07:57:06 -0700
Message-Id: <1282575437-23270-16-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Generate log when receive tx reply with bt_kill count > 0 and
in advance bt coex mode

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index e0ec6c0..ea24240 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -247,7 +247,14 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 		struct iwl_ht_agg *agg;
 
 		agg = &priv->stations[sta_id].tid[tid].agg;
-
+		/*
+		 * If the BT kill count is non-zero, we'll get this
+		 * notification again.
+		 */
+		if (tx_resp->bt_kill_count && tx_resp->frame_count == 1 &&
+		    priv->cfg->advanced_bt_coexist) {
+			IWL_WARN(priv, "receive reply tx with bt_kill\n");
+		}
 		iwlagn_tx_status_reply_tx(priv, agg, tx_resp, txq_id, index);
 
 		/* check if BAR is needed */
-- 
1.7.0.4

