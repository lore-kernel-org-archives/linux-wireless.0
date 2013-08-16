Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38887 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab3HPLIA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:08:00 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>
Subject: [PATCH 11/20] iwlwifi: mvm: don't clear tbl->win mistakenly
Date: Fri, 16 Aug 2013 13:07:01 +0200
Message-Id: <1376651230-1060-11-git-send-email-johannes@sipsolutions.net> (sfid-20130816_130805_400344_348B7709)
In-Reply-To: <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
References: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
 <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

rs_get_tbl_info_from_mcs() mistakenly clears
the rate histories window, overriding its initialization
values (i.e. filling it with 0, instead of -1).

Signed-off-by: Eliad Peller <eliad@wizery.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index a69bd4c..a587b21 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -492,7 +492,7 @@ static int rs_get_tbl_info_from_mcs(const u32 rate_n_flags,
 	u8 num_of_ant = get_num_of_ant_from_rate(rate_n_flags);
 	u8 mcs;
 
-	memset(tbl, 0, sizeof(struct iwl_scale_tbl_info));
+	memset(tbl, 0, offsetof(struct iwl_scale_tbl_info, win));
 	*rate_idx = iwl_hwrate_to_plcp_idx(rate_n_flags);
 
 	if (*rate_idx  == IWL_RATE_INVALID) {
-- 
1.8.4.rc2

