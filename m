Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:62930 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaEGTxo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 15:53:44 -0400
Received: by mail-we0-f173.google.com with SMTP id u57so1502804wes.4
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 12:53:43 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/23] iwlwifi: mvm: rs: avoid TPC while in search cycle
Date: Wed,  7 May 2014 22:52:44 +0300
Message-Id: <1399492380-12050-7-git-send-email-egrumbach@gmail.com> (sfid-20140507_215438_208191_DE8B2FDB)
In-Reply-To: <536A8EE3.2050906@gmail.com>
References: <536A8EE3.2050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

TPC is a power optimization which should only be attempted when
we're in the "stay in column" state after we've locked onto an optimal
rate.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 32ac66b..6216618 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2185,7 +2185,8 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 		break;
 	case RS_ACTION_STAY:
 		/* No change */
-		update_lq = rs_tpc_perform(mvm, sta, lq_sta, tbl);
+		if (lq_sta->rs_state == RS_STATE_STAY_IN_COLUMN)
+			update_lq = rs_tpc_perform(mvm, sta, lq_sta, tbl);
 		break;
 	default:
 		break;
-- 
1.8.3.2

