Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24355 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbZJWUms (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 16:42:48 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 15/18] iwlwifi: remove duplicated define
Date: Fri, 23 Oct 2009 13:42:33 -0700
Message-Id: <1256330556-20997-16-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
References: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Duplicated define for listen interval (IWL_CONN_MAX_LISTEN_INTERVAL and
IWL_CONN_LISTEN_INTERVAL), remove IWL_CONN_LISTEN_INTERVAL

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Reported-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-power.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-power.h |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 432f465..9bce2c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -163,9 +163,9 @@ static void iwl_static_sleep_cmd(struct iwl_priv *priv,
 		cmd->flags &= ~IWL_POWER_SLEEP_OVER_DTIM_MSK;
 
 	slp_itrvl = le32_to_cpu(cmd->sleep_interval[IWL_POWER_VEC_SIZE - 1]);
-	if (slp_itrvl > IWL_CONN_LISTEN_INTERVAL)
+	if (slp_itrvl > IWL_CONN_MAX_LISTEN_INTERVAL)
 		cmd->sleep_interval[IWL_POWER_VEC_SIZE - 1] =
-			cpu_to_le32(IWL_CONN_LISTEN_INTERVAL);
+			cpu_to_le32(IWL_CONN_MAX_LISTEN_INTERVAL);
 
 	/* enforce max sleep interval */
 	for (i = IWL_POWER_VEC_SIZE - 1; i >= 0 ; i--) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index 0755518..310c32e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -30,8 +30,6 @@
 
 #include "iwl-commands.h"
 
-#define IWL_CONN_LISTEN_INTERVAL	10
-
 #define IWL_ABSOLUTE_ZERO		0
 #define IWL_ABSOLUTE_MAX		0xFFFFFFFF
 #define IWL_TT_INCREASE_MARGIN	5
-- 
1.5.6.3

