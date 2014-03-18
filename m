Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:41442 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbaCROpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:45:49 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so5427086eek.39
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:45:48 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/35] iwlwifi: mvm: fix quota for D3 image
Date: Tue, 18 Mar 2014 16:45:08 +0200
Message-Id: <1395153939-23897-4-git-send-email-egrumbach@gmail.com> (sfid-20140318_154557_163220_762297C4)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

New firmware enforce valid values for the quota in D3.
The values given to the firmware when suspending and using
WoWLAN where dummy - change them to realistics values.

Tested-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index b956e2f..a087564 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -846,8 +846,8 @@ static int iwl_mvm_d3_reprogram(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	quota_cmd.quotas[0].id_and_color =
 		cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->phy_ctxt->id,
 						mvmvif->phy_ctxt->color));
-	quota_cmd.quotas[0].quota = cpu_to_le32(100);
-	quota_cmd.quotas[0].max_duration = cpu_to_le32(1000);
+	quota_cmd.quotas[0].quota = cpu_to_le32(IWL_MVM_MAX_QUOTA);
+	quota_cmd.quotas[0].max_duration = cpu_to_le32(IWL_MVM_MAX_QUOTA);
 
 	for (i = 1; i < MAX_BINDINGS; i++)
 		quota_cmd.quotas[i].id_and_color = cpu_to_le32(FW_CTXT_INVALID);
-- 
1.8.3.2

