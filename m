Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37010 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbYLBUNM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:13:12 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/11] iwlwifi: move host command check function into separate file
Date: Tue,  2 Dec 2008 12:13:57 -0800
Message-Id: <1228248847-10424-2-git-send-email-reinette.chatre@intel.com> (sfid-20081202_211319_202039_2313CDF9)
In-Reply-To: <1228248847-10424-1-git-send-email-reinette.chatre@intel.com>
References: <>
 <1228248847-10424-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch moves iwl_check_rxon_cmd into iwl-agn-hcmd-check.c
This function compiled out in none debugging or non development
mode and more. We haven't decided which one yet hence preserving the
current 'always compile' state.
More functions will be added to the file namely for checking TX and LQ
commands.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c |  108 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   75 +--------------
 drivers/net/wireless/iwlwifi/iwl-commands.h       |    2 +
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    5 -
 5 files changed, 112 insertions(+), 80 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 8b45b30..0be9e6b 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -8,7 +8,7 @@ iwlcore-$(CONFIG_IWLWIFI_RFKILL) += iwl-rfkill.o
 iwlcore-$(CONFIG_IWLAGN_SPECTRUM_MEASUREMENT) += iwl-spectrum.o
 
 obj-$(CONFIG_IWLAGN)	+= iwlagn.o
-iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o
+iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o iwl-agn-hcmd-check.o
 
 iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
 iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c
new file mode 100644
index 0000000..c50494a
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c
@@ -0,0 +1,108 @@
+/******************************************************************************
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ * Tomas Winkler <tomas.winkler@intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *****************************************************************************/
+
+#include <linux/kernel.h>
+#include <net/mac80211.h>
+#include "iwl-dev.h"
+#include "iwl-debug.h"
+#include "iwl-commands.h"
+
+
+/**
+ * iwl_check_rxon_cmd - validate RXON structure is valid
+ *
+ * NOTE:  This is really only useful during development and can eventually
+ * be #ifdef'd out once the driver is stable and folks aren't actively
+ * making changes
+ */
+int iwl_agn_check_rxon_cmd(struct iwl_rxon_cmd *rxon)
+{
+	int error = 0;
+	int counter = 1;
+
+	if (rxon->flags & RXON_FLG_BAND_24G_MSK) {
+		error |= le32_to_cpu(rxon->flags &
+				(RXON_FLG_TGJ_NARROW_BAND_MSK |
+				 RXON_FLG_RADAR_DETECT_MSK));
+		if (error)
+			IWL_WARNING("check 24G fields %d | %d\n",
+				    counter++, error);
+	} else {
+		error |= (rxon->flags & RXON_FLG_SHORT_SLOT_MSK) ?
+				0 : le32_to_cpu(RXON_FLG_SHORT_SLOT_MSK);
+		if (error)
+			IWL_WARNING("check 52 fields %d | %d\n",
+				    counter++, error);
+		error |= le32_to_cpu(rxon->flags & RXON_FLG_CCK_MSK);
+		if (error)
+			IWL_WARNING("check 52 CCK %d | %d\n",
+				    counter++, error);
+	}
+	error |= (rxon->node_addr[0] | rxon->bssid_addr[0]) & 0x1;
+	if (error)
+		IWL_WARNING("check mac addr %d | %d\n", counter++, error);
+
+	/* make sure basic rates 6Mbps and 1Mbps are supported */
+	error |= (((rxon->ofdm_basic_rates & IWL_RATE_6M_MASK) == 0) &&
+		  ((rxon->cck_basic_rates & IWL_RATE_1M_MASK) == 0));
+	if (error)
+		IWL_WARNING("check basic rate %d | %d\n", counter++, error);
+
+	error |= (le16_to_cpu(rxon->assoc_id) > 2007);
+	if (error)
+		IWL_WARNING("check assoc id %d | %d\n", counter++, error);
+
+	error |= ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK))
+			== (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK));
+	if (error)
+		IWL_WARNING("check CCK and short slot %d | %d\n",
+			    counter++, error);
+
+	error |= ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK))
+			== (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK));
+	if (error)
+		IWL_WARNING("check CCK & auto detect %d | %d\n",
+			    counter++, error);
+
+	error |= ((rxon->flags & (RXON_FLG_AUTO_DETECT_MSK |
+			RXON_FLG_TGG_PROTECT_MSK)) == RXON_FLG_TGG_PROTECT_MSK);
+	if (error)
+		IWL_WARNING("check TGG and auto detect %d | %d\n",
+			    counter++, error);
+
+	if (error)
+		IWL_WARNING("Tuning to channel %d\n",
+			    le16_to_cpu(rxon->channel));
+
+	if (error) {
+		IWL_ERROR("Not a valid iwl4965_rxon_assoc_cmd field values\n");
+		return -1;
+	}
+	return 0;
+}
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5ddc86d..4f45894 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -108,79 +108,6 @@ static void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
 }
 
 /**
- * iwl_check_rxon_cmd - validate RXON structure is valid
- *
- * NOTE:  This is really only useful during development and can eventually
- * be #ifdef'd out once the driver is stable and folks aren't actively
- * making changes
- */
-static int iwl_check_rxon_cmd(struct iwl_rxon_cmd *rxon)
-{
-	int error = 0;
-	int counter = 1;
-
-	if (rxon->flags & RXON_FLG_BAND_24G_MSK) {
-		error |= le32_to_cpu(rxon->flags &
-				(RXON_FLG_TGJ_NARROW_BAND_MSK |
-				 RXON_FLG_RADAR_DETECT_MSK));
-		if (error)
-			IWL_WARNING("check 24G fields %d | %d\n",
-				    counter++, error);
-	} else {
-		error |= (rxon->flags & RXON_FLG_SHORT_SLOT_MSK) ?
-				0 : le32_to_cpu(RXON_FLG_SHORT_SLOT_MSK);
-		if (error)
-			IWL_WARNING("check 52 fields %d | %d\n",
-				    counter++, error);
-		error |= le32_to_cpu(rxon->flags & RXON_FLG_CCK_MSK);
-		if (error)
-			IWL_WARNING("check 52 CCK %d | %d\n",
-				    counter++, error);
-	}
-	error |= (rxon->node_addr[0] | rxon->bssid_addr[0]) & 0x1;
-	if (error)
-		IWL_WARNING("check mac addr %d | %d\n", counter++, error);
-
-	/* make sure basic rates 6Mbps and 1Mbps are supported */
-	error |= (((rxon->ofdm_basic_rates & IWL_RATE_6M_MASK) == 0) &&
-		  ((rxon->cck_basic_rates & IWL_RATE_1M_MASK) == 0));
-	if (error)
-		IWL_WARNING("check basic rate %d | %d\n", counter++, error);
-
-	error |= (le16_to_cpu(rxon->assoc_id) > 2007);
-	if (error)
-		IWL_WARNING("check assoc id %d | %d\n", counter++, error);
-
-	error |= ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK))
-			== (RXON_FLG_CCK_MSK | RXON_FLG_SHORT_SLOT_MSK));
-	if (error)
-		IWL_WARNING("check CCK and short slot %d | %d\n",
-			    counter++, error);
-
-	error |= ((rxon->flags & (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK))
-			== (RXON_FLG_CCK_MSK | RXON_FLG_AUTO_DETECT_MSK));
-	if (error)
-		IWL_WARNING("check CCK & auto detect %d | %d\n",
-			    counter++, error);
-
-	error |= ((rxon->flags & (RXON_FLG_AUTO_DETECT_MSK |
-			RXON_FLG_TGG_PROTECT_MSK)) == RXON_FLG_TGG_PROTECT_MSK);
-	if (error)
-		IWL_WARNING("check TGG and auto detect %d | %d\n",
-			    counter++, error);
-
-	if (error)
-		IWL_WARNING("Tuning to channel %d\n",
-			    le16_to_cpu(rxon->channel));
-
-	if (error) {
-		IWL_ERROR("Not a valid iwl_rxon_assoc_cmd field values\n");
-		return -1;
-	}
-	return 0;
-}
-
-/**
  * iwl_full_rxon_required - check if full RXON (vs RXON_ASSOC) cmd is needed
  * @priv: staging_rxon is compared to active_rxon
  *
@@ -253,7 +180,7 @@ static int iwl_commit_rxon(struct iwl_priv *priv)
 	 * 5000, but will not damage 4965 */
 	priv->staging_rxon.flags |= RXON_FLG_SELF_CTS_EN;
 
-	ret = iwl_check_rxon_cmd(&priv->staging_rxon);
+	ret = iwl_agn_check_rxon_cmd(&priv->staging_rxon);
 	if (ret) {
 		IWL_ERROR("Invalid RXON configuration.  Not committing.\n");
 		return -EINVAL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 7761504..d6196b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3064,4 +3064,6 @@ struct iwl_rx_packet {
 
 #define IWL_RX_FRAME_SIZE        (4 + sizeof(struct iwl4965_rx_frame))
 
+int iwl_agn_check_rxon_cmd(struct iwl_rxon_cmd *rxon);
+
 #endif				/* __iwl_commands_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index b2ce29c..846b8b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1086,9 +1086,4 @@ static inline int is_channel_ibss(const struct iwl_channel_info *ch)
 	return ((ch->flags & EEPROM_CHANNEL_IBSS)) ? 1 : 0;
 }
 
-extern const struct iwl_channel_info *iwl_get_channel_info(
-	const struct iwl_priv *priv, enum ieee80211_band band, u16 channel);
-
-/* Requires full declaration of iwl_priv before including */
-
 #endif				/* __iwl_dev_h__ */
-- 
1.5.4.3

