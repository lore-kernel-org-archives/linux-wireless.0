Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48108 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbbFCHcE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 03:32:04 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/15] iwlwifi: mvm: Remove old scan commands
Date: Wed,  3 Jun 2015 10:31:33 +0300
Message-Id: <1433316696-4612-12-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150603_093350_823440_B725A27A)
In-Reply-To: <1433316253.25661.3.camel@intel.com>
References: <1433316253.25661.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

The firmwares that used these commands is not supported
anymore. Remove them.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h | 7 -------
 drivers/net/wireless/iwlwifi/mvm/ops.c    | 5 -----
 2 files changed, 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 0ed7675..7128379 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -171,13 +171,6 @@ enum {
 	/* Thermal Throttling*/
 	REPLY_THERMAL_MNG_BACKOFF = 0x7e,
 
-	/* Scanning */
-	SCAN_REQUEST_CMD = 0x80,
-	SCAN_ABORT_CMD = 0x81,
-	SCAN_START_NOTIFICATION = 0x82,
-	SCAN_RESULTS_NOTIFICATION = 0x83,
-	SCAN_COMPLETE_NOTIFICATION = 0x84,
-
 	/* NVM */
 	NVM_ACCESS_CMD = 0x88,
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 91ca626..2801f97 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -281,11 +281,6 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(BINDING_CONTEXT_CMD),
 	CMD(TIME_QUOTA_CMD),
 	CMD(NON_QOS_TX_COUNTER_CMD),
-	CMD(SCAN_REQUEST_CMD),
-	CMD(SCAN_ABORT_CMD),
-	CMD(SCAN_START_NOTIFICATION),
-	CMD(SCAN_RESULTS_NOTIFICATION),
-	CMD(SCAN_COMPLETE_NOTIFICATION),
 	CMD(NVM_ACCESS_CMD),
 	CMD(PHY_CONFIGURATION_CMD),
 	CMD(CALIB_RES_NOTIF_PHY_DB),
-- 
2.1.4

