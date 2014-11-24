Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33478 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbaKXOfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:52 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so5887126wib.4
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:51 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 34/75] iwlwifi: mvm: remove warning on unknown scan complete
Date: Mon, 24 Nov 2014 16:34:10 +0200
Message-Id: <1416839691-28533-34-git-send-email-egrumbach@gmail.com> (sfid-20141124_154008_140942_320F9EA8)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Remove warning on scan complete with unknown ID, since this
scan could be already cleared in abort flow.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index b6719b6..e5294d0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1951,8 +1951,10 @@ int iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 	bool sched = !!(uid & IWL_UMAC_SCAN_UID_SCHED_SCAN);
 	int uid_idx = iwl_mvm_find_scan_uid(mvm, uid);
 
-	if (WARN(uid_idx >= IWL_MVM_MAX_SIMULTANEOUS_SCANS,
-		 "Scan notification for uknown scan ID\n"))
+	/*
+	 * Scan uid may be set to zero in case of scan abort request from above.
+	 */
+	if (uid_idx >= IWL_MVM_MAX_SIMULTANEOUS_SCANS)
 		return 0;
 
 	IWL_DEBUG_SCAN(mvm,
-- 
1.9.1

