Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:57010 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbaDMNCM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 09:02:12 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>, <stable@vger.kernel.org>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/13] iwlwifi: mvm: rs: fix mimo delimiter in LQ cmd
Date: Sun, 13 Apr 2014 16:01:52 +0300
Message-Id: <1397394123-25102-2-git-send-email-egrumbach@gmail.com> (sfid-20140413_150220_645461_8426FCA4)
In-Reply-To: <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
References: <534A8A49.2030100@gmail.com>
 <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

mimo_delim was always set to 0 instead of pointing to
the first SISO entry after MIMO rates.
This can cause keep transmitting in MIMO even when we shouldn't.
For example when the peer is requesting static SMPS.

Cc: <stable@vger.kernel.org> [3.14]
Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 568abd6..dd13629 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2547,6 +2547,7 @@ static void rs_build_rates_table(struct iwl_mvm *mvm,
 	if (is_siso(&rate)) {
 		num_rates = RS_SECONDARY_SISO_NUM_RATES;
 		num_retries = RS_SECONDARY_SISO_RETRIES;
+		lq_cmd->mimo_delim = index;
 	} else if (is_legacy(&rate)) {
 		num_rates = RS_SECONDARY_LEGACY_NUM_RATES;
 		num_retries = RS_LEGACY_RETRIES_PER_RATE;
-- 
1.8.3.2

