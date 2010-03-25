Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22725 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab0CYUpB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:45:01 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 20/22] iwlwifi: remove "\n" from module parameter description
Date: Thu, 25 Mar 2010 13:44:48 -0700
Message-Id: <1269549890-19195-21-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Remove the "\n" from following module parameter description:
 - enable wifi/bluetooth co-exist
 - led mode: 0=blinking, 1=On(RF On)/Off(RF Off), (default 0)
to be consistence with the rest of iwlagn/iwlcore module parameters format.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6fe7853..d152198 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -65,7 +65,7 @@ MODULE_LICENSE("GPL");
  */
 static bool bt_coex_active = true;
 module_param(bt_coex_active, bool, S_IRUGO);
-MODULE_PARM_DESC(bt_coex_active, "enable wifi/bluetooth co-exist\n");
+MODULE_PARM_DESC(bt_coex_active, "enable wifi/bluetooth co-exist");
 
 static struct iwl_wimax_coex_event_entry cu_priorities[COEX_NUM_OF_EVENTS] = {
 	{COEX_CU_UNASSOC_IDLE_RP, COEX_CU_UNASSOC_IDLE_WP,
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index a6f9c91..db5bfcb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -46,7 +46,7 @@
 static int led_mode;
 module_param(led_mode, int, S_IRUGO);
 MODULE_PARM_DESC(led_mode, "led mode: 0=blinking, 1=On(RF On)/Off(RF Off), "
-			   "(default 0)\n");
+			   "(default 0)");
 
 
 static const struct {
-- 
1.6.3.3

