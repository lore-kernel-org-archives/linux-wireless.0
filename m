Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:41323 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827Ab3LBU7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 15:59:50 -0500
Received: by mail-we0-f173.google.com with SMTP id u57so6978589wes.32
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 12:59:49 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/13] iwlwifi: mvm: rs: remove unused timestamp field
Date: Mon,  2 Dec 2013 22:59:18 +0200
Message-Id: <1386017965-13641-6-git-send-email-egrumbach@gmail.com> (sfid-20131202_215958_367289_76BBBF4D)
In-Reply-To: <529CF2D6.1080008@gmail.com>
References: <529CF2D6.1080008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Remove this as it's unused.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |    4 ----
 drivers/net/wireless/iwlwifi/mvm/rs.h |    1 -
 2 files changed, 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 9249e52..0598f26 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -271,7 +271,6 @@ static void rs_rate_scale_clear_window(struct iwl_rate_scale_data *window)
 	window->success_ratio = IWL_INVALID_VALUE;
 	window->counter = 0;
 	window->average_tpt = IWL_INVALID_VALUE;
-	window->stamp = 0;
 }
 
 static inline u8 rs_is_valid_ant(u8 valid_antenna, u8 ant_type)
@@ -428,9 +427,6 @@ static int rs_collect_tx_data(struct iwl_scale_tbl_info *tbl,
 	else
 		window->average_tpt = IWL_INVALID_VALUE;
 
-	/* Tag this window as having been updated */
-	window->stamp = jiffies;
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index e5d448c..ae983bc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -257,7 +257,6 @@ struct iwl_rate_scale_data {
 	s32 success_ratio;	/* per-cent * 128  */
 	s32 counter;		/* number of frames attempted */
 	s32 average_tpt;	/* success ratio * expected throughput */
-	unsigned long stamp;
 };
 
 /**
-- 
1.7.9.5

