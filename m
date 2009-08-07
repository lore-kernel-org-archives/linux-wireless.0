Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:24343 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099AbZHGWl6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 18:41:58 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/16] iwlwifi: fix legacy thermal throttling power index
Date: Fri,  7 Aug 2009 15:41:46 -0700
Message-Id: <1249684912-22936-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
References: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For legacy thermal throttling, set the new Thermal Throttling
state and change power index when thermal throttling manager detects
temperature changed. The current implementation sets the state to the
previous Thermal Throttling state, which causes system to enter wrong
power index. The worse case, it will trying to set the
lower power index when device reach critical temperature, it will cuase
issue for both system and the device.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-power.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 9c05af7..bd97a0d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -425,7 +425,7 @@ static void iwl_perform_ct_kill_task(struct iwl_priv *priv,
 static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp)
 {
 	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
-	enum iwl_tt_state new_state;
+	enum iwl_tt_state old_state;
 	struct iwl_power_mgr *setting = &priv->power_data;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -438,26 +438,27 @@ static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp)
 			(temp - tt->tt_previous_temp));
 	}
 #endif
+	old_state = tt->state;
 	/* in Celsius */
 	if (temp >= IWL_MINIMAL_POWER_THRESHOLD)
-		new_state = IWL_TI_CT_KILL;
+		tt->state = IWL_TI_CT_KILL;
 	else if (temp >= IWL_REDUCED_PERFORMANCE_THRESHOLD_2)
-		new_state = IWL_TI_2;
+		tt->state = IWL_TI_2;
 	else if (temp >= IWL_REDUCED_PERFORMANCE_THRESHOLD_1)
-		new_state = IWL_TI_1;
+		tt->state = IWL_TI_1;
 	else
-		new_state = IWL_TI_0;
+		tt->state = IWL_TI_0;
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	tt->tt_previous_temp = temp;
 #endif
-	if (tt->state != new_state) {
-		if (tt->state == IWL_TI_0) {
+	if (tt->state != old_state) {
+		if (old_state == IWL_TI_0) {
 			tt->sys_power_mode = setting->power_mode;
 			IWL_DEBUG_POWER(priv, "current power mode: %u\n",
 				setting->power_mode);
 		}
-		switch (new_state) {
+		switch (tt->state) {
 		case IWL_TI_0:
 			/* when system ready to go back to IWL_TI_0 state
 			 * using system power mode instead of TT power mode
@@ -486,15 +487,15 @@ static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp)
 			/* TT state not updated
 			 * try again during next temperature read
 			 */
+			tt->state = old_state;
 			IWL_ERR(priv, "Cannot update power mode, "
 					"TT state not updated\n");
 		} else {
-			if (new_state == IWL_TI_CT_KILL)
+			if (tt->state == IWL_TI_CT_KILL)
 				iwl_perform_ct_kill_task(priv, true);
-			else if (tt->state == IWL_TI_CT_KILL &&
-				 new_state != IWL_TI_CT_KILL)
+			else if (old_state == IWL_TI_CT_KILL &&
+				 tt->state != IWL_TI_CT_KILL)
 				iwl_perform_ct_kill_task(priv, false);
-			tt->state = new_state;
 			IWL_DEBUG_POWER(priv, "Temperature state changed %u\n",
 					tt->state);
 			IWL_DEBUG_POWER(priv, "Power Index change to %u\n",
-- 
1.5.6.3

