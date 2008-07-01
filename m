Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34606 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbYGAHoz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 03:44:55 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] iwlwifi: fix error path of iwl_rfkill_init
Date: Tue,  1 Jul 2008 10:44:48 +0300
Message-Id: <1214898291-6232-1-git-send-email-tomas.winkler@intel.com> (sfid-20080701_094500_660602_18BA86CE)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch cleans rfkill error path. The problem was result of removing
the input device

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-rfkill.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
index aa9f31e..eebaf43 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -101,17 +101,13 @@ int iwl_rfkill_init(struct iwl_priv *priv)
 	ret = rfkill_register(priv->rfkill_mngr.rfkill);
 	if (ret) {
 		IWL_ERROR("Unable to register rfkill: %d\n", ret);
-		goto unregister_rfkill;
+		goto free_rfkill;
 	}
 
 	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
 	return ret;
 
-unregister_rfkill:
-	rfkill_unregister(priv->rfkill_mngr.rfkill);
-	priv->rfkill_mngr.rfkill = NULL;
-
-freed_rfkill:
+free_rfkill:
 	if (priv->rfkill_mngr.rfkill != NULL)
 		rfkill_free(priv->rfkill_mngr.rfkill);
 	priv->rfkill_mngr.rfkill = NULL;
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

