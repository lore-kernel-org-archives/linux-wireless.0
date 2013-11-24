Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:50367 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab3KXUHV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:07:21 -0500
Received: by mail-wg0-f50.google.com with SMTP id a1so1197897wgh.5
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:07:20 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/29] iwlwifi: mvm: fix scan offloading flag definition
Date: Sun, 24 Nov 2013 22:06:41 +0200
Message-Id: <1385323606-3603-24-git-send-email-egrumbach@gmail.com> (sfid-20131124_210808_338913_F2C77EA6)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Bit 0 in the scan offloading flags asks the filter
to pass all the results (instead of filtering them,
by default), rather than the other way around (like
it is defined and used today).

Fix the flag name appropriately, and fix its user.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h |    5 ++---
 drivers/net/wireless/iwlwifi/mvm/scan.c        |    3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index c3782b4..b3ed592 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -530,14 +530,13 @@ struct iwl_scan_offload_schedule {
 /*
  * iwl_scan_offload_flags
  *
- * IWL_SCAN_OFFLOAD_FLAG_FILTER_SSID: filter mode - upload every beacon or match
- *	ssid list.
+ * IWL_SCAN_OFFLOAD_FLAG_PASS_ALL: pass all results - no filtering.
  * IWL_SCAN_OFFLOAD_FLAG_CACHED_CHANNEL: add cached channels to partial scan.
  * IWL_SCAN_OFFLOAD_FLAG_ENERGY_SCAN: use energy based scan before partial scan
  *	on A band.
  */
 enum iwl_scan_offload_flags {
-	IWL_SCAN_OFFLOAD_FLAG_FILTER_SSID	= BIT(0),
+	IWL_SCAN_OFFLOAD_FLAG_PASS_ALL		= BIT(0),
 	IWL_SCAN_OFFLOAD_FLAG_CACHED_CHANNEL	= BIT(2),
 	IWL_SCAN_OFFLOAD_FLAG_ENERGY_SCAN	= BIT(3),
 };
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index dff7592..5972266 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -817,11 +817,10 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 		IWL_DEBUG_SCAN(mvm,
 			       "Sending scheduled scan with filtering, filter len %d\n",
 			       req->n_match_sets);
-		scan_req.flags |=
-				cpu_to_le16(IWL_SCAN_OFFLOAD_FLAG_FILTER_SSID);
 	} else {
 		IWL_DEBUG_SCAN(mvm,
 			       "Sending Scheduled scan without filtering\n");
+		scan_req.flags |= cpu_to_le16(IWL_SCAN_OFFLOAD_FLAG_PASS_ALL);
 	}
 
 	return iwl_mvm_send_cmd_pdu(mvm, SCAN_OFFLOAD_REQUEST_CMD, CMD_SYNC,
-- 
1.7.9.5

