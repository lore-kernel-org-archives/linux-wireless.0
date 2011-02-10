Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:30282 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab1BJQaD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 11:30:03 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/1] iwl3945: iwl3945_good_plcp_health might not used
Date: Thu, 10 Feb 2011 08:16:33 -0800
Message-Id: <1297354593-22897-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove plcp check for 3945, mark the function __maybe_unused

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: <stable@kernel.org> # .35+: c91d015: iwl3945: remove plcp check
Cc: stable@kernel.org  # 2.6.35+
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 3eb14fd..eb82341 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -408,7 +408,7 @@ static void iwl3945_accumulative_statistics(struct iwl_priv *priv,
  * When the plcp error is exceeding the thresholds, reset the radio
  * to improve the throughput.
  */
-static bool iwl3945_good_plcp_health(struct iwl_priv *priv,
+static bool __maybe_unused iwl3945_good_plcp_health(struct iwl_priv *priv,
 				struct iwl_rx_packet *pkt)
 {
 	bool rc = true;
-- 
1.7.0.4

