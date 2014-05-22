Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63547 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaEVHYG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 03:24:06 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so8773306wib.17
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 00:24:05 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/11] iwlwifi: mvm: Remove redundant initialization
Date: Thu, 22 May 2014 10:23:46 +0300
Message-Id: <1400743435-702-2-git-send-email-egrumbach@gmail.com> (sfid-20140522_092726_172170_2BAC2CA0)
In-Reply-To: <537DA58C.5050003@gmail.com>
References: <537DA58C.5050003@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

This value is being set few lines under in set_cqm_params.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/power.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 2e99ddd..1057647 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -130,7 +130,6 @@ int iwl_mvm_update_beacon_abort(struct iwl_mvm *mvm,
 	struct iwl_beacon_filter_cmd cmd = {
 		IWL_BF_CMD_CONFIG_DEFAULTS,
 		.bf_enable_beacon_filter = cpu_to_le32(1),
-		.ba_enable_beacon_abort = cpu_to_le32(enable),
 	};
 
 	if (!mvmvif->bf_data.bf_enabled)
-- 
1.8.3.2

