Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15724 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756146Ab0GaQyr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jul 2010 12:54:47 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 7/8] iwlwifi: BA scd_flow not match condition detected
Date: Sat, 31 Jul 2010 08:34:11 -0700
Message-Id: <1280590452-10655-8-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

It is a uCode bug which cause the tx queue id not match scd_flow
in compressed block ack frame, and it need to be addressed in uCode.
Currently, driver will log the information when it happen.

Since it is possible happen very often and we do not want to fill the syslog,
so don't enable the logging by default.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 55a1b31..ecb953f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1331,7 +1331,14 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	tid = ba_resp->tid;
 	agg = &priv->stations[sta_id].tid[tid].agg;
 	if (unlikely(agg->txq_id != scd_flow)) {
-		IWL_ERR(priv, "BA scd_flow %d does not match txq_id %d\n",
+		/*
+		 * FIXME: this is a uCode bug which need to be addressed,
+		 * log the information and return for now!
+		 * since it is possible happen very often and in order
+		 * not to fill the syslog, don't enable the logging by default
+		 */
+		IWL_DEBUG_TX_REPLY(priv,
+			"BA scd_flow %d does not match txq_id %d\n",
 			scd_flow, agg->txq_id);
 		return;
 	}
-- 
1.7.0.4

