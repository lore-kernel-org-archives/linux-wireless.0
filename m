Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:56901 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758823Ab3LBU7r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 15:59:47 -0500
Received: by mail-wi0-f173.google.com with SMTP id hn9so1144427wib.6
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 12:59:46 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/13] iwlwifi: mvm: rs: rename thresholds defines
Date: Mon,  2 Dec 2013 22:59:16 +0200
Message-Id: <1386017965-13641-4-git-send-email-egrumbach@gmail.com> (sfid-20131202_220004_763621_715857CE)
In-Reply-To: <529CF2D6.1080008@gmail.com>
References: <529CF2D6.1080008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Rename for clearer names.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/rs.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 882ecd3..a289b77 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1107,7 +1107,7 @@ static s32 rs_get_best_rate(struct iwl_mvm *mvm,
 		 *    "active" throughput (under perfect conditions).
 		 */
 		if ((((100 * tpt_tbl[rate]) > lq_sta->last_tpt) &&
-		     ((active_sr > IWL_RATE_DECREASE_TH) &&
+		     ((active_sr > RS_SR_FORCE_DECREASE) &&
 		      (active_sr <= IWL_RATE_HIGH_TH) &&
 		      (tpt_tbl[rate] <= active_tpt))) ||
 		    ((active_sr >= IWL_RATE_SCALE_SWITCH) &&
@@ -1928,7 +1928,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 	scale_action = 0;
 
 	/* Too many failures, decrease rate */
-	if ((sr <= IWL_RATE_DECREASE_TH) || (current_tpt == 0)) {
+	if ((sr <= RS_SR_FORCE_DECREASE) || (current_tpt == 0)) {
 		IWL_DEBUG_RATE(mvm,
 			       "decrease rate because of low SR\n");
 		scale_action = -1;
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index 5dd30ea..e5d448c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -155,7 +155,7 @@ enum {
 #define IWL_RATE_SCALE_SWITCH		10880	/*  85% */
 #define IWL_RATE_HIGH_TH		10880	/*  85% */
 #define IWL_RATE_INCREASE_TH		6400	/*  50% */
-#define IWL_RATE_DECREASE_TH		1920	/*  15% */
+#define RS_SR_FORCE_DECREASE		1920	/*  15% */
 
 /* possible actions when in legacy mode */
 enum {
-- 
1.7.9.5

