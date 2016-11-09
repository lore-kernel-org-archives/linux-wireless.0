Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35098 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751015AbcKIFuk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 00:50:40 -0500
Received: by mail-pf0-f194.google.com with SMTP id i88so22240936pfk.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2016 21:50:39 -0800 (PST)
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Tue, 8 Nov 2016 21:50:33 -0800
To: Luca Coelho <luciano.coelho@intel.com>
Cc: linux-wireless@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Eran Harary <eran.harary@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        Eyal Shapira <eyal@wizery.com>,
        Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH v2 2/3] iwlwifi: mvm: rs: Remove unused 'mcs' variable
Message-ID: <20161109055033.GA27470@google.com> (sfid-20161109_065044_926262_4B5ACF33)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 5fc0f76c4 introduced Rx stats from debugfs, the function
iwl_mvm_reset_frame_stats from that commit defines and sets mcs but does not use
it. Compiling iwlwifi with W=1 gives this warning -

iwlwifi/mvm/rs.c: In function ‘iwl_mvm_update_frame_stats’:
iwlwifi/mvm/rs.c:3074:14: warning: variable ‘mcs’ set but not used [-Wunused-but-set-variable]

Fixes: 5fc0f76c43bd (iwlwifi: mvm: add Rx frames statistics via debugfs)

Signed-off-by: Kirtika Ruchandani <kirtika@google.com>
Cc: Eyal Shapira <eyal@wizery.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 0b79f4a..80f99c3 100644
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
2.8.0.rc3.226.g39d4020
