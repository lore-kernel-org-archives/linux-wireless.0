Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12449 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbYFLBto (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:44 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 12/29] iwlwifi: format log prints for easier parsing
Date: Thu, 12 Jun 2008 09:47:02 +0800
Message-Id: <1213235239-2954-13-git-send-email-yi.zhu@intel.com> (sfid-20080612_041915_030021_635741A2)
In-Reply-To: <1213235239-2954-12-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-7-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-8-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-9-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-10-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-11-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-12-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch changes uCode log print to for easier parsing.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 7d0a257..21995ff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1169,12 +1169,14 @@ void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 		ptr += sizeof(u32);
 		time = iwl_read_targ_mem(priv, ptr);
 		ptr += sizeof(u32);
-		if (mode == 0)
-			IWL_ERROR("0x%08x\t%04u\n", time, ev); /* data, ev */
-		else {
+		if (mode == 0) {
+			/* data, ev */
+			IWL_ERROR("EVT_LOG:0x%08x:%04u\n", time, ev);
+		} else {
 			data = iwl_read_targ_mem(priv, ptr);
 			ptr += sizeof(u32);
-			IWL_ERROR("%010u\t0x%08x\t%04u\n", time, data, ev);
+			IWL_ERROR("EVT_LOGT:%010u:0x%08x:%04u\n",
+					time, data, ev);
 		}
 	}
 }
-- 
1.5.3.6

