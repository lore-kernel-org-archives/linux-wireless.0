Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:46779 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab3LQUp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:27 -0500
Received: by mail-ee0-f52.google.com with SMTP id d17so3099415eek.25
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:26 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 29/36] iwlwifi: mvm: rs: remove unnecessary debug logs
Date: Tue, 17 Dec 2013 22:44:32 +0200
Message-Id: <1387313079-28123-29-git-send-email-egrumbach@gmail.com> (sfid-20131217_214554_757291_C7CF40BA)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

The logs are emitted in a flow in which there were retries
and the rates in the rate table entry didn't match the active
or search table. This doesn't indicate a problem and is
expected in most cases where there will be retries for some
reason. Remove the logs.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index bc86032..6d0bd45 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1116,14 +1116,9 @@ static void rs_tx_status(void *mvm_r, struct ieee80211_supported_band *sband,
 				tmp_tbl = curr_tbl;
 			else if (rs_rate_match(&rate, &other_tbl->rate))
 				tmp_tbl = other_tbl;
-			else {
-				IWL_DEBUG_RATE(mvm,
-					       "Tx packet rate doesn't match ACTIVE or SEARCH tables\n");
-				rs_dump_rate(mvm, &rate, "Tx PACKET:");
-				rs_dump_rate(mvm, &curr_tbl->rate, "CURRENT:");
-				rs_dump_rate(mvm, &other_tbl->rate, "OTHER:");
+			else
 				continue;
-			}
+
 			rs_collect_tx_data(tmp_tbl, rate.index, 1,
 					   i < retries ? 0 : legacy_success);
 		}
-- 
1.7.9.5

