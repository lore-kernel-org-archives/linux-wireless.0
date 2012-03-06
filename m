Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64658 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031507Ab2CFWnl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 17:43:41 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH RESEND 32/33] iwlwifi: clean up iwl-commands.h
Date: Tue,  6 Mar 2012 13:31:07 -0800
Message-Id: <1331069468-11074-33-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120306_234349_168713_EDE3EE25)
In-Reply-To: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Do some cleanups here:
 * remove an unused prototype
 * remove some unused constants
 * clean up includes

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |   10 +---------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index cb6c230..cf5cc10 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -26,7 +26,7 @@
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
  *****************************************************************************/
-
+#include <linux/etherdevice.h>
 #include <net/mac80211.h>
 
 #include "iwl-dev.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 70ba962..9ed73e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -69,15 +69,9 @@
 #ifndef __iwl_commands_h__
 #define __iwl_commands_h__
 
-#include <linux/etherdevice.h>
 #include <linux/ieee80211.h>
+#include <linux/types.h>
 
-struct iwl_priv;
-
-/* Tx rates */
-#define IWL_CCK_RATES	4
-#define IWL_OFDM_RATES	8
-#define IWL_MAX_RATES	(IWL_CCK_RATES + IWL_OFDM_RATES)
 
 enum {
 	REPLY_ALIVE = 0x1,
@@ -3851,8 +3845,6 @@ struct iwlagn_wowlan_kek_kck_material_cmd {
 	__le64	replay_ctr;
 } __packed;
 
-int iwl_agn_check_rxon_cmd(struct iwl_priv *priv);
-
 /*
  * REPLY_WIPAN_PARAMS = 0xb2 (Commands and Notification)
  */
-- 
1.7.0.4

