Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33053 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbaKXOfF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:05 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so5855814wiv.11
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:03 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/75] iwlwifi: mvm: rs: don't use shadowing variable
Date: Mon, 24 Nov 2014 16:33:41 +0200
Message-Id: <1416839691-28533-5-git-send-email-egrumbach@gmail.com> (sfid-20141124_154446_194815_1141B6F7)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The variable 'tid' is already defined in this function, so use
just 't' for the new one. As we return from the function just
overwriting 'tid' would be acceptable, but less obvious to the
reader.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index ce88484..6775100 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1110,10 +1110,11 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 
 	if (time_after(jiffies,
 		       (unsigned long)(lq_sta->last_tx + RS_IDLE_TIMEOUT))) {
-		int tid;
+		int t;
+
 		IWL_DEBUG_RATE(mvm, "Tx idle for too long. reinit rs\n");
-		for (tid = 0; tid < IWL_MAX_TID_COUNT; tid++)
-			ieee80211_stop_tx_ba_session(sta, tid);
+		for (t = 0; t < IWL_MAX_TID_COUNT; t++)
+			ieee80211_stop_tx_ba_session(sta, t);
 
 		iwl_mvm_rs_rate_init(mvm, sta, info->band, false);
 		return;
-- 
1.9.1

