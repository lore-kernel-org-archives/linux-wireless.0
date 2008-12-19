Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33262 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbYLSCpN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:13 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 14/43] iwl3945: Remove power related definitions from 3945 code
Date: Fri, 19 Dec 2008 10:37:14 +0800
Message-Id: <1229654263-21454-15-git-send-email-yi.zhu@intel.com> (sfid-20081219_034544_407386_5E4225A2)
In-Reply-To: <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

Most of the power (not TX power, but power management) structures and
definitions are duplicated accross iwl-power.h and iwl-3945.h. We should try
to only use the iwl header.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Acked-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |   28 +--------------------------
 drivers/net/wireless/iwlwifi/iwl-power.h    |   16 +++++++++++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   25 ++++++++++++-----------
 3 files changed, 30 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 6d0ec0a..dd15b32 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -47,6 +47,7 @@ extern struct pci_device_id iwl3945_hw_card_ids[];
 #include "iwl-prph.h"
 #include "iwl-3945-hw.h"
 #include "iwl-debug.h"
+#include "iwl-power.h"
 #include "iwl-3945-led.h"
 
 /* Highest firmware API version supported */
@@ -246,33 +247,6 @@ struct iwl3945_clip_group {
 /* Minimum number of queues. MAX_NUM is defined in hw specific files */
 #define IWL_MIN_NUM_QUEUES	4
 
-/* Power management (not Tx power) structures */
-
-struct iwl3945_power_vec_entry {
-	struct iwl_powertable_cmd cmd;
-	u8 no_dtim;
-};
-#define IWL_POWER_RANGE_0  (0)
-#define IWL_POWER_RANGE_1  (1)
-
-#define IWL_POWER_MODE_CAM	0x00	/* Continuously Aware Mode, always on */
-#define IWL_POWER_INDEX_3	0x03
-#define IWL_POWER_INDEX_5	0x05
-#define IWL_POWER_AC		0x06
-#define IWL_POWER_BATTERY	0x07
-#define IWL_POWER_LIMIT		0x07
-#define IWL_POWER_MASK		0x0F
-#define IWL_POWER_ENABLED	0x10
-#define IWL_POWER_LEVEL(x)	((x) & IWL_POWER_MASK)
-
-struct iwl3945_power_mgr {
-	spinlock_t lock;
-	struct iwl3945_power_vec_entry pwr_range_0[IWL_POWER_AC];
-	struct iwl3945_power_vec_entry pwr_range_1[IWL_POWER_AC];
-	u8 active_index;
-	u32 dtim_val;
-};
-
 #define IEEE80211_DATA_LEN              2304
 #define IEEE80211_4ADDR_LEN             30
 #define IEEE80211_HLEN                  (IEEE80211_4ADDR_LEN)
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index fa098d8..7cab04f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -42,7 +42,10 @@ enum {
 	IWL_POWER_INDEX_5,
 	IWL_POWER_AUTO,
 	IWL_POWER_MAX = IWL_POWER_AUTO,
+	IWL39_POWER_AC = IWL_POWER_AUTO, /* 0x06 */
 	IWL_POWER_AC,
+	IWL39_POWER_BATTERY = IWL_POWER_AC, /* 0x07 */
+	IWL39_POWER_LIMIT = IWL_POWER_AC,
 	IWL_POWER_BATTERY,
 };
 
@@ -56,6 +59,11 @@ enum {
 #define IWL_POWER_MASK		0x0F
 #define IWL_POWER_ENABLED	0x10
 
+#define IWL_POWER_RANGE_0  (0)
+#define IWL_POWER_RANGE_1  (1)
+
+#define IWL_POWER_LEVEL(x)	((x) & IWL_POWER_MASK)
+
 /* Power management (not Tx power) structures */
 
 struct iwl_power_vec_entry {
@@ -78,6 +86,14 @@ struct iwl_power_mgr {
 	u8 power_disabled; /* flag to disable using power saving level */
 };
 
+struct iwl3945_power_mgr {
+	spinlock_t lock;
+	struct iwl_power_vec_entry pwr_range_0[IWL_POWER_AC];
+	struct iwl_power_vec_entry pwr_range_1[IWL_POWER_AC];
+	u8 active_index;
+	u32 dtim_val;
+};
+
 void iwl_setup_power_deferred_work(struct iwl_priv *priv);
 void iwl_power_cancel_timeout(struct iwl_priv *priv);
 int iwl_power_update_mode(struct iwl_priv *priv, bool force);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index ee77066..9eb5b12 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1817,7 +1817,7 @@ static void iwl3945_activate_qos(struct iwl3945_priv *priv, u8 force)
 
 /* default power management (not Tx power) table values */
 /* for TIM  0-10 */
-static struct iwl3945_power_vec_entry range_0[IWL_POWER_AC] = {
+static struct iwl_power_vec_entry range_0[IWL39_POWER_AC] = {
 	{{NOSLP, SLP_TIMEOUT(0), SLP_TIMEOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
 	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(500), SLP_VEC(1, 2, 3, 4, 4)}, 0},
 	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(300), SLP_VEC(2, 4, 6, 7, 7)}, 0},
@@ -1827,7 +1827,7 @@ static struct iwl3945_power_vec_entry range_0[IWL_POWER_AC] = {
 };
 
 /* for TIM > 10 */
-static struct iwl3945_power_vec_entry range_1[IWL_POWER_AC] = {
+static struct iwl_power_vec_entry range_1[IWL39_POWER_AC] = {
 	{{NOSLP, SLP_TIMEOUT(0), SLP_TIMEOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
 	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(500),
 		 SLP_VEC(1, 2, 3, 4, 0xFF)}, 0},
@@ -1844,7 +1844,7 @@ int iwl3945_power_init_handle(struct iwl3945_priv *priv)
 {
 	int rc = 0, i;
 	struct iwl3945_power_mgr *pow_data;
-	int size = sizeof(struct iwl3945_power_vec_entry) * IWL_POWER_AC;
+	int size = sizeof(struct iwl_power_vec_entry) * IWL39_POWER_AC;
 	u16 pci_pm;
 
 	IWL_DEBUG_POWER("Initialize power \n");
@@ -1867,7 +1867,7 @@ int iwl3945_power_init_handle(struct iwl3945_priv *priv)
 
 		IWL_DEBUG_POWER("adjust power command flags\n");
 
-		for (i = 0; i < IWL_POWER_AC; i++) {
+		for (i = 0; i < IWL39_POWER_AC; i++) {
 			cmd = &pow_data->pwr_range_0[i].cmd;
 
 			if (pci_pm & 0x1)
@@ -1885,7 +1885,7 @@ static int iwl3945_update_power_cmd(struct iwl3945_priv *priv,
 	int rc = 0, i;
 	u8 skip;
 	u32 max_sleep = 0;
-	struct iwl3945_power_vec_entry *range;
+	struct iwl_power_vec_entry *range;
 	u8 period = 0;
 	struct iwl3945_power_mgr *pow_data;
 
@@ -1953,10 +1953,10 @@ static int iwl3945_send_power_mode(struct iwl3945_priv *priv, u32 mode)
 	 * if plugged into AC power, set to CAM ("continuously aware mode"),
 	 * else user level */
 	switch (mode) {
-	case IWL_POWER_BATTERY:
+	case IWL39_POWER_BATTERY:
 		final_mode = IWL_POWER_INDEX_3;
 		break;
-	case IWL_POWER_AC:
+	case IWL39_POWER_AC:
 		final_mode = IWL_POWER_MODE_CAM;
 		break;
 	default:
@@ -7528,8 +7528,9 @@ static ssize_t store_power_level(struct device *d,
 		goto out;
 	}
 
-	if ((mode < 1) || (mode > IWL_POWER_LIMIT) || (mode == IWL_POWER_AC))
-		mode = IWL_POWER_AC;
+	if ((mode < 1) || (mode > IWL39_POWER_LIMIT) ||
+	    (mode == IWL39_POWER_AC))
+		mode = IWL39_POWER_AC;
 	else
 		mode |= IWL_POWER_ENABLED;
 
@@ -7577,10 +7578,10 @@ static ssize_t show_power_level(struct device *d,
 	p += sprintf(p, "%d ", level);
 	switch (level) {
 	case IWL_POWER_MODE_CAM:
-	case IWL_POWER_AC:
+	case IWL39_POWER_AC:
 		p += sprintf(p, "(AC)");
 		break;
-	case IWL_POWER_BATTERY:
+	case IWL39_POWER_BATTERY:
 		p += sprintf(p, "(BATTERY)");
 		break;
 	default:
@@ -7986,7 +7987,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 
 	priv->rates_mask = IWL_RATES_MASK;
 	/* If power management is turned on, default to AC mode */
-	priv->power_mode = IWL_POWER_AC;
+	priv->power_mode = IWL39_POWER_AC;
 	priv->user_txpower_limit = IWL_DEFAULT_TX_POWER;
 
 	err = iwl3945_init_channel_map(priv);
-- 
1.5.3.6

