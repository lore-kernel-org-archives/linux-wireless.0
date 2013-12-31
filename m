Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:46541 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab3LaRQk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:40 -0500
Received: by mail-ea0-f171.google.com with SMTP id h10so5588706eak.16
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:39 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/28] iwlwifi: mvm: rs: fix a potential NULL deref
Date: Tue, 31 Dec 2013 19:15:55 +0200
Message-Id: <1388510157-23345-26-git-send-email-egrumbach@gmail.com> (sfid-20131231_183436_810818_F6107BF9)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Found by klocwork analysis.
mvm could be NULL which may cause a NULL dereference
in a theoretical call flow

rs_fill_lq_cmd(mvm = NULL, ...)
rs_build_rates_table
rs_fill_rates_for_column
ucode_rate_from_rs_rate
IWL_ERR(mvm,...)

No real reason for passing NULL to rs_fill_lq_cmd so fix that.

Reported-by: Eytan Lifshitz <eytan.lifshitz@intel.com>
Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 269fa0a..b7668dc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2121,7 +2121,7 @@ static void rs_initialize_lq(struct iwl_mvm *mvm,
 		tbl->column = RS_COLUMN_LEGACY_ANT_B;
 
 	rs_set_expected_tpt_table(lq_sta, tbl);
-	rs_fill_lq_cmd(NULL, NULL, lq_sta, rate);
+	rs_fill_lq_cmd(mvm, sta, lq_sta, rate);
 	/* TODO restore station should remember the lq cmd */
 	iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, init);
 }
@@ -2448,8 +2448,7 @@ static void rs_build_rates_table(struct iwl_mvm *mvm,
 
 	memcpy(&rate, initial_rate, sizeof(rate));
 
-	if (mvm)
-		valid_tx_ant = iwl_fw_valid_tx_ant(mvm->fw);
+	valid_tx_ant = iwl_fw_valid_tx_ant(mvm->fw);
 
 	if (is_siso(&rate)) {
 		num_rates = RS_INITIAL_SISO_NUM_RATES;
@@ -2623,7 +2622,7 @@ static void rs_program_fix_rate(struct iwl_mvm *mvm,
 		struct rs_rate rate;
 		rs_rate_from_ucode_rate(lq_sta->dbg_fixed_rate,
 					lq_sta->band, &rate);
-		rs_fill_lq_cmd(NULL, NULL, lq_sta, &rate);
+		rs_fill_lq_cmd(mvm, NULL, lq_sta, &rate);
 		iwl_mvm_send_lq_cmd(lq_sta->drv, &lq_sta->lq, false);
 	}
 }
-- 
1.7.9.5

