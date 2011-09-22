Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7986 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984Ab1IVXBS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 19:01:18 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/12] iwlagn: add debugging to show probe related info in scan notification
Date: Thu, 22 Sep 2011 15:14:51 -0700
Message-Id: <1316729700-1770-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110923_010130_209185_23C1A2F9)
In-Reply-To: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add debugging to show the status of probe in scan notification
to help debug probe related issues

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 2b6db24..07af6ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -242,10 +242,12 @@ static int iwl_rx_scan_results_notif(struct iwl_priv *priv,
 
 	IWL_DEBUG_SCAN(priv, "Scan ch.res: "
 		       "%d [802.11%s] "
+		       "probe status: %u:%u "
 		       "(TSF: 0x%08X:%08X) - %d "
 		       "elapsed=%lu usec\n",
 		       notif->channel,
 		       notif->band ? "bg" : "a",
+		       notif->probe_status, notif->num_probe_not_sent,
 		       le32_to_cpu(notif->tsf_high),
 		       le32_to_cpu(notif->tsf_low),
 		       le32_to_cpu(notif->statistics[0]),
-- 
1.7.0.4

