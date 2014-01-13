Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54588 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaAMUWJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:22:09 -0500
Received: by mail-ee0-f46.google.com with SMTP id d49so3395699eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 12:22:07 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/18] iwlwifi: mvm: rs: fix handling of column switch error
Date: Mon, 13 Jan 2014 22:21:43 +0200
Message-Id: <1389644517-22807-4-git-send-email-egrumbach@gmail.com> (sfid-20140113_212224_902752_348ED7F5)
In-Reply-To: <52D44A46.4000805@gmail.com>
References: <52D44A46.4000805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

If we can't switch to a column because no rates are supported
in that column this led to a state where the search cycle
got stuck and never ended. This in turn also led to aggregation
not being turned on. Fix this by marking a column as
visited if we can't switch to it.

Reported-and-tested-by: Karl Beldan <karl.beldan@gmail.com>
Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index c9ff41c..54887b9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1591,6 +1591,8 @@ static int rs_switch_to_column(struct iwl_mvm *mvm,
 	search_tbl->column = col_id;
 	rs_set_expected_tpt_table(lq_sta, search_tbl);
 
+	lq_sta->visited_columns |= BIT(col_id);
+
 	/* Get the best matching rate if we're changing modes. e.g.
 	 * SISO->MIMO, LEGACY->SISO, MIMO->SISO
 	 */
@@ -1614,7 +1616,6 @@ static int rs_switch_to_column(struct iwl_mvm *mvm,
 	IWL_DEBUG_RATE(mvm, "Switched to column %d: Index %d\n",
 		       col_id, rate->index);
 
-	lq_sta->visited_columns |= BIT(col_id);
 	return 0;
 
 err:
-- 
1.7.9.5

