Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:42229 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647AbaJ2Lv0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:51:26 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so1101223wgh.39
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:51:25 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/25] iwlwifi: mvm: improve MCS rate warning
Date: Wed, 29 Oct 2014 13:50:38 +0200
Message-Id: <1414583446-11032-17-git-send-email-egrumbach@gmail.com> (sfid-20141029_131322_171778_DACE17A4)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The warning gives no information about the frame, and presents
the flags so that one might think they're the frame. Clarify
and add more information.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index c6a517c..8d84873 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -189,8 +189,10 @@ static void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm,
 
 	/* HT rate doesn't make sense for a non data frame */
 	WARN_ONCE(info->control.rates[0].flags & IEEE80211_TX_RC_MCS,
-		  "Got an HT rate for a non data frame 0x%x\n",
-		  info->control.rates[0].flags);
+		  "Got an HT rate (flags:0x%x/mcs:%d) for a non data frame (fc:0x%x)\n",
+		  info->control.rates[0].flags,
+		  info->control.rates[0].idx,
+		  le16_to_cpu(fc));
 
 	rate_idx = info->control.rates[0].idx;
 	/* if the rate isn't a well known legacy rate, take the lowest one */
-- 
1.9.1

