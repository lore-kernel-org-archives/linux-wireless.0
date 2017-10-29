Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42292 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750848AbdJ2M2c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 08:28:32 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 29 Oct 2017 14:28:03 +0200
Message-Id: <20171029122816.8802-5-luca@coelho.fi> (sfid-20171029_132852_268816_ADECD955)
In-Reply-To: <20171029122816.8802-1-luca@coelho.fi>
References: <20171029122816.8802-1-luca@coelho.fi>
Subject: [PATCH 04/17] iwlwifi: mvm: rs: remove the ANT C from the toogle antenna logic
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We don't plan to have products with 3 antennas in the near
future. All the rest of the code follows the same
assumption as well.
Remove the support for antenna C from rs_toggle_ant.
When trying to toggle from ANT_B, this avoids to go through
ANT_C, discover that it doesn't exist and continue to ANT_A.
In MIMO, this avoids to do ANT_AB -> ANT_BC -> ANT_AC and
back to ANT_AB.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 0fe723ca844e..c69515ed72df 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -67,12 +67,8 @@ static u8 rs_ht_to_legacy[] = {
 static const u8 ant_toggle_lookup[] = {
 	[ANT_NONE] = ANT_NONE,
 	[ANT_A] = ANT_B,
-	[ANT_B] = ANT_C,
-	[ANT_AB] = ANT_BC,
-	[ANT_C] = ANT_A,
-	[ANT_AC] = ANT_AB,
-	[ANT_BC] = ANT_AC,
-	[ANT_ABC] = ANT_ABC,
+	[ANT_B] = ANT_A,
+	[ANT_AB] = ANT_AB,
 };
 
 #define IWL_DECLARE_RATE_INFO(r, s, rp, rn)			      \
@@ -975,7 +971,7 @@ static int rs_toggle_antenna(u32 valid_ant, struct rs_rate *rate)
 {
 	u8 new_ant_type;
 
-	if (!rate->ant || rate->ant > ANT_ABC)
+	if (!rate->ant || WARN_ON_ONCE(rate->ant & ANT_C))
 		return 0;
 
 	if (!rs_is_valid_ant(valid_ant, rate->ant))
-- 
2.14.2
