Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59514 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbcEQXba (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2016 19:31:30 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Intel Linux Wireless <linuxwifi@intel.com>,
	Eyal Shapira <eyal@wizery.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Alexander Bondar <alexander.bondar@intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] iwlwifi: rs: remove superfluous check
Date: Wed, 18 May 2016 01:31:08 +0200
Message-Id: <1463527868-12226-1-git-send-email-xypron.glpk@gmx.de> (sfid-20160518_013202_641152_15C0D4C8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we dereference a variable anyway in other parts of the code,
there is no need to check against NULL in a single place.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 81dd2f6..bab01ea 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -2867,7 +2867,7 @@ static void rs_get_rate(void *mvm_r, struct ieee80211_sta *sta, void *mvm_sta,
 	/* TODO: handle rate_idx_mask and rate_idx_mcs_mask */
 
 	/* Treat uninitialized rate scaling data same as non-existing. */
-	if (lq_sta && !lq_sta->pers.drv) {
+	if (!lq_sta->pers.drv) {
 		IWL_DEBUG_RATE(mvm, "Rate scaling not initialized yet.\n");
 		mvm_sta = NULL;
 	}
-- 
2.1.4

