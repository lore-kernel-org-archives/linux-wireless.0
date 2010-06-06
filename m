Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22880 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab0FFG4p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 18/23] iwlwifi: do not use huge command buffer for channel switch
Date: Sat,  5 Jun 2010 23:56:33 -0700
Message-Id: <1275807398-18184-19-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
References: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Channel switch host command do not need to allocate huge command buffer
since its size is already included in the iwl_device_cmd structure.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 19bb5b8..32710a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -285,7 +285,7 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_CHANNEL_SWITCH,
 		.len = sizeof(cmd),
-		.flags = CMD_SIZE_HUGE,
+		.flags = CMD_SYNC,
 		.data = &cmd,
 	};
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 0775145..afdeec5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -253,7 +253,7 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_CHANNEL_SWITCH,
 		.len = sizeof(cmd),
-		.flags = CMD_SIZE_HUGE,
+		.flags = CMD_SYNC,
 		.data = &cmd,
 	};
 
-- 
1.7.0.4

