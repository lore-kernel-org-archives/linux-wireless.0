Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57191 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752502AbbJEPBk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 11:01:40 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:58 +0300
Message-Id: <1444055820-27506-27-git-send-email-luca@coelho.fi> (sfid-20151005_170145_126060_9D45989D)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 27/29] iwlwifi: mvm: make threshold temperatures unsigned
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to have negative threshold temperatures, so make
them unsigned to avoid signedness warnings in debugfs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-config.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 939fa22..9109708 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -223,13 +223,13 @@ struct iwl_tt_tx_backoff {
  * @support_tx_backoff: Support tx-backoff?
  */
 struct iwl_tt_params {
-	s32 ct_kill_entry;
-	s32 ct_kill_exit;
+	u32 ct_kill_entry;
+	u32 ct_kill_exit;
 	u32 ct_kill_duration;
-	s32 dynamic_smps_entry;
-	s32 dynamic_smps_exit;
-	s32 tx_protection_entry;
-	s32 tx_protection_exit;
+	u32 dynamic_smps_entry;
+	u32 dynamic_smps_exit;
+	u32 tx_protection_entry;
+	u32 tx_protection_exit;
 	struct iwl_tt_tx_backoff tx_backoff[TT_TX_BACKOFF_SIZE];
 	bool support_ct_kill;
 	bool support_dynamic_smps;
-- 
2.5.3

