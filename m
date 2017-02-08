Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39334 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754754AbdBHPxM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 10:53:12 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  8 Feb 2017 17:51:44 +0200
Message-Id: <20170208155149.1704-4-luca@coelho.fi> (sfid-20170208_165317_535287_15D5E085)
In-Reply-To: <20170208155149.1704-1-luca@coelho.fi>
References: <20170208112322.29413-1-luca@coelho.fi>
 <20170208155149.1704-1-luca@coelho.fi>
Subject: [PATCH 12/17] iwlwifi: mvm: don't call << operator with a negative value
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In https://bugzilla.kernel.org/show_bug.cgi?id=177341 Bob
reported a UBSAN WARNING on rs.c in iwldvm.
Fix the same bug in iwlmvm.

This because
	i = index - 1;
	for (mask = (1 << i); i >= 0; i--, mask >>= 1)

is unsafe: i could be negative and hence we can call <<
on a negative value.
This bug doesn't have any real impact since the condition
of the for loop will prevent any usage of mask.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=177341
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 13be9a5b83ee..ce907c58ebf6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -972,7 +972,9 @@ static u16 rs_get_adjacent_rate(struct iwl_mvm *mvm, u8 index, u16 rate_mask,
 
 		/* Find the previous rate that is in the rate mask */
 		i = index - 1;
-		for (mask = (1 << i); i >= 0; i--, mask >>= 1) {
+		if (i >= 0)
+			mask = BIT(i);
+		for (; i >= 0; i--, mask >>= 1) {
 			if (rate_mask & mask) {
 				low = i;
 				break;
-- 
2.11.0
