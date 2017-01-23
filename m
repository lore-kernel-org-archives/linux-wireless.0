Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36306 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751677AbdAWWTJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:19:09 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com,
        Kirtika Ruchandani <kirtika.ruchandani@gmail.com>,
        Kirtika Ruchandani <kirtika@google.com>,
        Eyal Shapira <eyal@wizery.com>
Date: Tue, 24 Jan 2017 00:03:42 +0200
Message-Id: <20170123220350.25305-18-luca@coelho.fi> (sfid-20170123_231911_477151_89F2EB1F)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 17/25] iwlwifi: mvm: rs: Remove unused 'mcs' variable
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>

Commit 5fc0f76c4 introduced Rx stats from debugfs, the function
iwl_mvm_reset_frame_stats from that commit defines and sets mcs but
does not use it. Compiling iwlwifi with W=1 gives this warning -

iwlwifi/mvm/rs.c: In function ‘iwl_mvm_update_frame_stats’:
iwlwifi/mvm/rs.c:3074:14: warning: variable ‘mcs’ set but not used [-Wunused-but-set-variable]

Fixes: 5fc0f76c43bd (iwlwifi: mvm: add Rx frames statistics via debugfs)
Signed-off-by: Kirtika Ruchandani <kirtika@google.com>
Cc: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 0b79f4a43eaf..80f99c365b6a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -3065,7 +3065,7 @@ static void iwl_mvm_reset_frame_stats(struct iwl_mvm *mvm)
 
 void iwl_mvm_update_frame_stats(struct iwl_mvm *mvm, u32 rate, bool agg)
 {
-	u8 nss = 0, mcs = 0;
+	u8 nss = 0;
 
 	spin_lock(&mvm->drv_stats_lock);
 
@@ -3093,11 +3093,9 @@ void iwl_mvm_update_frame_stats(struct iwl_mvm *mvm, u32 rate, bool agg)
 
 	if (rate & RATE_MCS_HT_MSK) {
 		mvm->drv_rx_stats.ht_frames++;
-		mcs = rate & RATE_HT_MCS_RATE_CODE_MSK;
 		nss = ((rate & RATE_HT_MCS_NSS_MSK) >> RATE_HT_MCS_NSS_POS) + 1;
 	} else if (rate & RATE_MCS_VHT_MSK) {
 		mvm->drv_rx_stats.vht_frames++;
-		mcs = rate & RATE_VHT_MCS_RATE_CODE_MSK;
 		nss = ((rate & RATE_VHT_MCS_NSS_MSK) >>
 		       RATE_VHT_MCS_NSS_POS) + 1;
 	} else {
-- 
2.11.0
