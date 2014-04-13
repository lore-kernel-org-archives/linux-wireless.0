Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56315 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432AbaDMTUm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:42 -0400
Received: by mail-we0-f174.google.com with SMTP id t60so7281691wes.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:41 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eytan Lifshitz <eytan.lifshitz@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/47] iwlwifi: mvm: Fix tx-backoff when NIC exit thermal throttling
Date: Sun, 13 Apr 2014 22:19:36 +0300
Message-Id: <1397416802-32403-21-git-send-email-egrumbach@gmail.com> (sfid-20140413_213515_030400_8BBBC1CF)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eytan Lifshitz <eytan.lifshitz@intel.com>

When NIC is exiting from thermal throttling state (i.e. after
heating and then cooling down), tx-backoff values are assigned
to be zero, instead of being restored to the minimal value. Fixed.

Signed-off-by: Eytan Lifshitz <eytan.lifshitz@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tt.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index cee4e72..39a3e03 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -468,13 +468,14 @@ void iwl_mvm_tt_handler(struct iwl_mvm *mvm)
 	}
 
 	if (params->support_tx_backoff) {
-		tx_backoff = 0;
+		tx_backoff = tt->min_backoff;
 		for (i = 0; i < TT_TX_BACKOFF_SIZE; i++) {
 			if (temperature < params->tx_backoff[i].temperature)
 				break;
-			tx_backoff = params->tx_backoff[i].backoff;
+			tx_backoff = max(tt->min_backoff,
+					 params->tx_backoff[i].backoff);
 		}
-		if (tx_backoff != 0)
+		if (tx_backoff != tt->min_backoff)
 			throttle_enable = true;
 		if (tt->tx_backoff != tx_backoff)
 			iwl_mvm_tt_tx_backoff(mvm, tx_backoff);
-- 
1.8.3.2

