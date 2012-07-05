Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45653 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab2GEIZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 04:25:04 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 5/9] iwlwifi: disable the watchdog for queues by default
Date: Thu,  5 Jul 2012 10:24:51 +0200
Message-Id: <1341476695-6889-6-git-send-email-johannes@sipsolutions.net> (sfid-20120705_102541_053259_217D74D2)
In-Reply-To: <1341476695-6889-1-git-send-email-johannes@sipsolutions.net>
References: <1341476695-6889-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

I saw that when the watchdog triggers, the packets do go
through if we wait enough time. So we still have an issue
where packets are blocked in the Tx queue for a short while
and this needs to be debugged separately. For now, don't
restart the driver when it is not needed.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 095547b..6322e2a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1011,6 +1011,7 @@ struct iwl_mod_params iwlwifi_mod_params = {
 	.power_level = IWL_POWER_INDEX_1,
 	.bt_ch_announce = true,
 	.auto_agg = true,
+	.wd_disable = true,
 	/* the rest are 0 by default */
 };
 EXPORT_SYMBOL_GPL(iwlwifi_mod_params);
-- 
1.7.10

