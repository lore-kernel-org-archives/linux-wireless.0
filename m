Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59431 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752463AbaKJJXy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:23:54 -0500
From: Luca Coelho <luca@coelho.fi>
To: emmanuel.grumbach@intel.com
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 10 Nov 2014 11:10:20 +0200
Message-Id: <1415610621-27438-16-git-send-email-luca@coelho.fi> (sfid-20141110_102402_600563_748316A5)
In-Reply-To: <1415610621-27438-1-git-send-email-luca@coelho.fi>
References: <1415610621-27438-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 15/16] iwlwifi: mvm: clear TE data if CSA time event fails to start
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

If setting the CSA time event fails, we must clear the TE data,
otherwise we'll try to remove it when, for instance, a disconnection
occurs, causing a SYSASSERT.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index 2feff15..6120ff2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -198,6 +198,7 @@ iwl_mvm_te_handle_notify_csa(struct iwl_mvm *mvm,
 {
 	if (!le32_to_cpu(notif->status)) {
 		IWL_DEBUG_TE(mvm, "CSA time event failed to start\n");
+		iwl_mvm_te_clear_data(mvm, te_data);
 		return;
 	}
 
-- 
2.1.1

