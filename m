Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:34916 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbaIOFLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:11:13 -0400
Received: by mail-we0-f182.google.com with SMTP id k48so3322296wev.27
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:11:12 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/12] iwlwifi: mvm: fix endianity issues with Smart Fifo commands
Date: Mon, 15 Sep 2014 08:10:40 +0300
Message-Id: <1410757848-1827-4-git-send-email-egrumbach@gmail.com> (sfid-20140915_071115_832375_E26EAB14)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This code was broken on big endian systems. Sparse didn't
catch the bug since the firmware command was not tagged as
little endian.
Fix the bug for big endian systems and tag the field in the
firmware command to prevent such issues in the future.

Cc: stable@vger.kernel.org [3.14+]
Fixes: 1f3b0ff8ec ("iwlwifi: mvm: Add Smart FIFO support")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/sf.c     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 95f5b32..9a922f3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -1563,14 +1563,14 @@ enum iwl_sf_scenario {
 
 /**
  * Smart Fifo configuration command.
- * @state: smart fifo state, types listed in iwl_sf_sate.
+ * @state: smart fifo state, types listed in enum %iwl_sf_sate.
  * @watermark: Minimum allowed availabe free space in RXF for transient state.
  * @long_delay_timeouts: aging and idle timer values for each scenario
  * in long delay state.
  * @full_on_timeouts: timer values for each scenario in full on state.
  */
 struct iwl_sf_cfg_cmd {
-	enum iwl_sf_state state;
+	__le32 state;
 	__le32 watermark[SF_TRANSIENT_STATES_NUMBER];
 	__le32 long_delay_timeouts[SF_NUM_SCENARIO][SF_NUM_TIMEOUT_TYPES];
 	__le32 full_on_timeouts[SF_NUM_SCENARIO][SF_NUM_TIMEOUT_TYPES];
diff --git a/drivers/net/wireless/iwlwifi/mvm/sf.c b/drivers/net/wireless/iwlwifi/mvm/sf.c
index 7edfd15..e843b67 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sf.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sf.c
@@ -172,7 +172,7 @@ static int iwl_mvm_sf_config(struct iwl_mvm *mvm, u8 sta_id,
 			     enum iwl_sf_state new_state)
 {
 	struct iwl_sf_cfg_cmd sf_cmd = {
-		.state = new_state,
+		.state = cpu_to_le32(new_state),
 	};
 	struct ieee80211_sta *sta;
 	int ret = 0;
-- 
1.9.1

