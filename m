Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:63884 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758833Ab3LBU7z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 15:59:55 -0500
Received: by mail-wi0-f169.google.com with SMTP id hn6so1066027wib.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 12:59:54 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/13] iwlwifi: mvm: rs: set dual_stream_ant_msk to ANT_AB always
Date: Mon,  2 Dec 2013 22:59:21 +0200
Message-Id: <1386017965-13641-9-git-send-email-egrumbach@gmail.com> (sfid-20131202_220005_651884_2D493002)
In-Reply-To: <529CF2D6.1080008@gmail.com>
References: <529CF2D6.1080008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Drop code which was relevant when there were chips with
3 antennas. Setting to ANT_AB should be ok with all mvm
supported chips.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 7beb548..5c98d462 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2386,15 +2386,7 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	/* These values will be overridden later */
 	lq_sta->lq.single_stream_ant_msk =
 		first_antenna(iwl_fw_valid_tx_ant(mvm->fw));
-	lq_sta->lq.dual_stream_ant_msk =
-		iwl_fw_valid_tx_ant(mvm->fw) &
-		~first_antenna(iwl_fw_valid_tx_ant(mvm->fw));
-	if (!lq_sta->lq.dual_stream_ant_msk) {
-		lq_sta->lq.dual_stream_ant_msk = ANT_AB;
-	} else if (num_of_ant(iwl_fw_valid_tx_ant(mvm->fw)) == 2) {
-		lq_sta->lq.dual_stream_ant_msk =
-			iwl_fw_valid_tx_ant(mvm->fw);
-	}
+	lq_sta->lq.dual_stream_ant_msk = ANT_AB;
 
 	/* as default allow aggregation for all tids */
 	lq_sta->tx_agg_tid_en = IWL_AGG_ALL_TID;
@@ -2463,8 +2455,6 @@ static void rs_fill_link_cmd(struct iwl_mvm *mvm,
 
 	if (num_of_ant(rate.ant) == 1)
 		lq_cmd->single_stream_ant_msk = rate.ant;
-	else if (num_of_ant(rate.ant) == 2)
-		lq_cmd->dual_stream_ant_msk = rate.ant;
 	/* otherwise we don't modify the existing value */
 
 	index++;
-- 
1.7.9.5

