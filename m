Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:57719 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbaEORFR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:05:17 -0400
Received: by mail-we0-f177.google.com with SMTP id x48so1360787wes.22
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:05:16 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/24] iwlwifi: mvm: set SKIP_OVER_DTIM flag only if needed
Date: Thu, 15 May 2014 20:04:32 +0300
Message-Id: <1400173481-9047-15-git-send-email-egrumbach@gmail.com> (sfid-20140515_190534_864640_E2E58914)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

setting SKIP_OVER_DTIM when skip_dtim_periods is 0
causes a ucode assert. set the flag only if needed.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/power.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index fc178d0..2e99ddd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -902,9 +902,10 @@ int iwl_mvm_update_d0i3_power_mode(struct iwl_mvm *mvm,
 		if (WARN_ON(!dtimper_msec))
 			return 0;
 
-		cmd.flags |=
-			cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK);
 		cmd.skip_dtim_periods = 300 / dtimper_msec;
+		if (cmd.skip_dtim_periods)
+			cmd.flags |=
+				cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK);
 	}
 	iwl_mvm_power_log(mvm, &cmd);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-- 
1.8.3.2

