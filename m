Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39764 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbaJ2Lu6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:50:58 -0400
Received: by mail-wi0-f172.google.com with SMTP id bs8so1433225wib.5
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:50:57 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/25] iwlwifi: rs: option to easily disable Tx MIMO
Date: Wed, 29 Oct 2014 13:50:22 +0200
Message-Id: <1414583446-11032-1-git-send-email-egrumbach@gmail.com> (sfid-20141029_125101_119160_C4C944EF)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

The current TLC isn't optimized for low latency and some devices
have issues with MIMO. This kind of combo creates latency issues.
Allow to temporarily disable MIMO for tests in order to solve
the latency issues without the added complexity of MIMO.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h | 1 +
 drivers/net/wireless/iwlwifi/mvm/rs.c        | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index d4dfbe4..dfec5b5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -95,5 +95,6 @@
 #define IWL_MVM_FW_MCAST_FILTER_PASS_ALL	0
 #define IWL_MVM_QUOTA_THRESHOLD			8
 #define IWL_MVM_RS_RSSI_BASED_INIT_RATE         0
+#define IWL_MVM_RS_DISABLE_MIMO			0
 
 #endif /* __MVM_CONSTANTS_H */
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 18a5399..0d836fe 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2684,6 +2684,9 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			lq_sta->ldpc = true;
 	}
 
+	if (IWL_MVM_RS_DISABLE_MIMO)
+		lq_sta->active_mimo2_rate = 0;
+
 	lq_sta->max_legacy_rate_idx = find_last_bit(&lq_sta->active_legacy_rate,
 						    BITS_PER_LONG);
 	lq_sta->max_siso_rate_idx = find_last_bit(&lq_sta->active_siso_rate,
-- 
1.9.1

