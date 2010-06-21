Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59381 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757915Ab0FUSGq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 14:06:46 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/9] iwlwifi: display ucode SW Error in hex
Date: Mon, 21 Jun 2010 11:06:35 -0700
Message-Id: <1277143600-32554-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1277143600-32554-1-git-send-email-reinette.chatre@intel.com>
References: <1277143600-32554-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@intel.com>

errors are defined in hex but displayed as decimal.  displaying as hex
debugging easier and eliminated having to manually convert.

Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 294b7ed..fd245c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2310,9 +2310,9 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	trace_iwlwifi_dev_ucode_error(priv, desc, time, data1, data2, line,
 				      blink1, blink2, ilink1, ilink2);
 
-	IWL_ERR(priv, "Desc                               Time       "
+	IWL_ERR(priv, "Desc                                  Time       "
 		"data1      data2      line\n");
-	IWL_ERR(priv, "%-28s (#%02d) %010u 0x%08X 0x%08X %u\n",
+	IWL_ERR(priv, "%-28s (0x%04X) %010u 0x%08X 0x%08X %u\n",
 		desc_lookup(desc), desc, time, data1, data2, line);
 	IWL_ERR(priv, "pc      blink1  blink2  ilink1  ilink2  hcmd\n");
 	IWL_ERR(priv, "0x%05X 0x%05X 0x%05X 0x%05X 0x%05X 0x%05X\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 697fa6c..8eb3471 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1424,7 +1424,7 @@ void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
 		    iwl_read_targ_mem(priv, base + i + 6 * sizeof(u32));
 
 		IWL_ERR(priv,
-			"%-13s (#%d) %010u 0x%05X 0x%05X 0x%05X 0x%05X %u\n\n",
+			"%-13s (0x%X) %010u 0x%05X 0x%05X 0x%05X 0x%05X %u\n\n",
 			desc_lookup(desc), desc, time, blink1, blink2,
 			ilink1, ilink2, data1);
 		trace_iwlwifi_dev_ucode_error(priv, desc, time, data1, 0,
-- 
1.7.0.4

