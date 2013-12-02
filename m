Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:50067 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758824Ab3LBU7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 15:59:49 -0500
Received: by mail-wg0-f52.google.com with SMTP id x13so12567599wgg.31
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 12:59:48 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/13] iwlwifi: mvm: rs: increase stay in column timeout
Date: Mon,  2 Dec 2013 22:59:17 +0200
Message-Id: <1386017965-13641-5-git-send-email-egrumbach@gmail.com> (sfid-20131202_220003_151413_741D8E0E)
In-Reply-To: <529CF2D6.1080008@gmail.com>
References: <529CF2D6.1080008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Remain in the same Tx modulation (i.e. column) for a longer
time before starting a search cycle for a better modulation.
This has been shown to give better results.
Also change the name of the timeout define to better match its
description.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index a289b77..9249e52 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -52,8 +52,8 @@
 
 /* max allowed rate miss before sync LQ cmd */
 #define IWL_MISSED_RATE_MAX		15
-/* max time to accum history 2 seconds */
-#define IWL_RATE_SCALE_FLUSH_INTVL   (3*HZ)
+#define RS_STAY_IN_COLUMN_TIMEOUT       (5*HZ)
+
 
 static u8 rs_ht_to_legacy[] = {
 	[IWL_RATE_1M_INDEX] = IWL_RATE_6M_INDEX,
@@ -1599,7 +1599,7 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search)
 			flush_interval_passed =
 				time_after(jiffies,
 					   (unsigned long)(lq_sta->flush_timer +
-						IWL_RATE_SCALE_FLUSH_INTVL));
+						RS_STAY_IN_COLUMN_TIMEOUT));
 
 		/*
 		 * Check if we should allow search for new modulation mode.
-- 
1.7.9.5

