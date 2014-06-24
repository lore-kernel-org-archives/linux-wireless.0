Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:47572 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165AbaFXTwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:52:31 -0400
Received: by mail-we0-f180.google.com with SMTP id x48so888240wes.25
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:52:30 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/27] iwlwifi: mvm: use ksize to memset scan_command
Date: Tue, 24 Jun 2014 22:51:56 +0300
Message-Id: <1403639541-4621-2-git-send-email-egrumbach@gmail.com> (sfid-20140624_215235_210562_F1C284BA)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Use ksize to get scan command size instead of calculating it, to
avoid nasty bugs.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 4b6c7d4..df8f3eb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -325,9 +325,7 @@ int iwl_mvm_scan_request(struct iwl_mvm *mvm,
 
 	IWL_DEBUG_SCAN(mvm, "Handling mac80211 scan request\n");
 	mvm->scan_status = IWL_MVM_SCAN_OS;
-	memset(cmd, 0, sizeof(struct iwl_scan_cmd) +
-	       mvm->fw->ucode_capa.max_probe_length +
-	       (MAX_NUM_SCAN_CHANNELS * sizeof(struct iwl_scan_channel)));
+	memset(cmd, 0, ksize(cmd));
 
 	cmd->channel_count = (u8)req->n_channels;
 	cmd->quiet_time = cpu_to_le16(IWL_ACTIVE_QUIET_TIME);
-- 
1.8.3.2

