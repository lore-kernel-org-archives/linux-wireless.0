Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26340 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759977Ab0GQOxk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jul 2010 10:53:40 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/3] iwlwifi: "recover_from_tx_stall" function for 4965
Date: Sat, 17 Jul 2010 07:55:16 -0700
Message-Id: <1279378516-31290-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1279378516-31290-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1279378516-31290-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

"Recover from tx stall" function is available for all devices except
4965, here add the functionality to 4965.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 1dd3bc4..3a0d0ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2286,6 +2286,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.tx_stats_read = iwl_ucode_tx_stats_read,
 		.general_stats_read = iwl_ucode_general_stats_read,
 	},
+	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
 };
 
-- 
1.7.0.4

