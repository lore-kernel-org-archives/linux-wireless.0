Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:28518 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757268AbcAaLG7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:06:59 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Gregory Greenman <gregory.greenman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/31] iwlwifi: mvm: rs: fix TPC action decision algorithm
Date: Sun, 31 Jan 2016 13:06:22 +0200
Message-Id: <1454238386-27032-27-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_123655_431477_846CED1F)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

Decreasing Tx power is allowed only when success ratio is
above the threshold defined in the algorithm. Add this condition.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 7bb6fd0..986e12a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -2040,7 +2040,8 @@ static enum tpc_action rs_get_tpc_action(struct iwl_mvm *mvm,
 	}
 
 	/* try decreasing first if applicable */
-	if (weak != TPC_INVALID) {
+	if (sr >= RS_PERCENT(IWL_MVM_RS_TPC_SR_NO_INCREASE) &&
+	    weak != TPC_INVALID) {
 		if (weak_tpt == IWL_INVALID_VALUE &&
 		    (strong_tpt == IWL_INVALID_VALUE ||
 		     current_tpt >= strong_tpt)) {
-- 
2.5.0

