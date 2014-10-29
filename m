Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:43134 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbaJ2LvA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:51:00 -0400
Received: by mail-wi0-f169.google.com with SMTP id n3so1308665wiv.2
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:50:59 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/25] iwlwifi: mvm: remove unneeded NULL pointer check
Date: Wed, 29 Oct 2014 13:50:23 +0200
Message-Id: <1414583446-11032-2-git-send-email-egrumbach@gmail.com> (sfid-20141029_125104_295913_97D4F42D)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

mac80211 will never call rate_control_tx_status with a NULL
pointer for sta. Remove the superfluous check. This check
misled smatch.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 0d836fe..66e971a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1225,7 +1225,7 @@ void iwl_mvm_rs_tx_status(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	IWL_DEBUG_RATE(mvm, "reduced txpower: %d\n", reduced_txp);
 done:
 	/* See if there's a better rate or modulation mode to try. */
-	if (sta && sta->supp_rates[info->band])
+	if (sta->supp_rates[info->band])
 		rs_rate_scale_perform(mvm, sta, lq_sta, tid);
 }
 
-- 
1.9.1

