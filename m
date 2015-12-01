Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbbLAJ7U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:20 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/41] iwlwifi: mvm: ignore LMAC scan notifications when running UMAC scans
Date: Tue,  1 Dec 2015 11:58:34 +0200
Message-Id: <1448963947-24302-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_110353_467068_931E5E47)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

If the firmware sends LMAC scan notifications while a UMAC scan is
running, just WARN and ignore it, otherwise the scanning state gets
messed up.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 6b9b190..e8a79bf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -333,6 +333,13 @@ void iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
 	struct iwl_periodic_scan_complete *scan_notif = (void *)pkt->data;
 	bool aborted = (scan_notif->status == IWL_SCAN_OFFLOAD_ABORTED);
 
+	/* If this happens, the firmware has mistakenly sent an LMAC
+	 * notification during UMAC scans -- warn and ignore it.
+	 */
+	if (WARN_ON_ONCE(fw_has_capa(&mvm->fw->ucode_capa,
+				     IWL_UCODE_TLV_CAPA_UMAC_SCAN)))
+		return;
+
 	/* scan status must be locked for proper checking */
 	lockdep_assert_held(&mvm->mutex);
 
-- 
2.5.0

