Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:61603 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbaCROqV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:21 -0400
Received: by mail-ee0-f44.google.com with SMTP id e49so5444317eek.17
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:20 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/35] iwlwifi: rs: split rs_collect_tx_data
Date: Tue, 18 Mar 2014 16:45:24 +0200
Message-Id: <1395153939-23897-20-git-send-email-egrumbach@gmail.com> (sfid-20140318_155649_743457_1C585765)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Make _rs_collect_tx_data get window as param, in order
to be able to set various windows.

This will be used later for saving tpc statistics
as well.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 4e16d7c..953c33f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -566,19 +566,13 @@ static s32 get_expected_tpt(struct iwl_scale_tbl_info *tbl, int rs_index)
  * at this rate.  window->data contains the bitmask of successful
  * packets.
  */
-static int rs_collect_tx_data(struct iwl_scale_tbl_info *tbl,
-			      int scale_index, int attempts, int successes)
+static int _rs_collect_tx_data(struct iwl_scale_tbl_info *tbl,
+			       int scale_index, int attempts, int successes,
+			       struct iwl_rate_scale_data *window)
 {
-	struct iwl_rate_scale_data *window = NULL;
 	static const u64 mask = (((u64)1) << (IWL_RATE_MAX_WINDOW - 1));
 	s32 fail_count, tpt;
 
-	if (scale_index < 0 || scale_index >= IWL_RATE_COUNT)
-		return -EINVAL;
-
-	/* Select window for current tx bit rate */
-	window = &(tbl->win[scale_index]);
-
 	/* Get expected throughput */
 	tpt = get_expected_tpt(tbl, scale_index);
 
@@ -636,6 +630,21 @@ static int rs_collect_tx_data(struct iwl_scale_tbl_info *tbl,
 	return 0;
 }
 
+static int rs_collect_tx_data(struct iwl_scale_tbl_info *tbl,
+			      int scale_index, int attempts, int successes)
+{
+	struct iwl_rate_scale_data *window = NULL;
+
+	if (scale_index < 0 || scale_index >= IWL_RATE_COUNT)
+		return -EINVAL;
+
+	/* Select window for current tx bit rate */
+	window = &(tbl->win[scale_index]);
+
+	return _rs_collect_tx_data(tbl, scale_index, attempts, successes,
+				   window);
+}
+
 /* Convert rs_rate object into ucode rate bitmask */
 static u32 ucode_rate_from_rs_rate(struct iwl_mvm *mvm,
 				  struct rs_rate *rate)
-- 
1.8.3.2

