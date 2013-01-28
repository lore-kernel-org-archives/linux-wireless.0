Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41693 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab3A1JiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 04:38:25 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 25/37] iwlwifi: add the MVM driver (power)
Date: Mon, 28 Jan 2013 10:37:32 +0100
Message-Id: <1359365864-4259-26-git-send-email-johannes@sipsolutions.net> (sfid-20130128_103828_954159_E0FDC63B)
In-Reply-To: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
References: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Newer firmware revisions have a completely new
firmware API. This is the new driver for this
new API.

I've listed the people who directly contributed
code, but many others from various teams have
contributed in other ways.

Change-Id: Id62a7ce1b80ec762c9a902b93188d3502837b77b
Cc: Alexander Bondar <alexander.bondar@intel.com>
Cc: Amit Beka <amit.beka@intel.com>
Cc: Amnon Paz <amnonx.paz@intel.com>
Cc: Assaf Krauss <assaf.krauss@intel.com>
Cc: David Spinadel <david.spinadel@intel.com>
Cc: Dor Shaish <dor.shaish@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Eytan Lifshitz <eytan.lifshitz@intel.com>
Cc: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/power.c | 207 +++++++++++++++++++++++++++++++
 1 file changed, 207 insertions(+)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/power.c

diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
new file mode 100644
index 0000000..719bfa9
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -0,0 +1,207 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
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
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+
+#include <net/mac80211.h>
+
+#include "iwl-debug.h"
+#include "mvm.h"
+#include "iwl-modparams.h"
+#include "fw-api-power.h"
+
+#define POWER_KEEP_ALIVE_PERIOD_SEC    25
+
+static void iwl_power_build_cmd(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+				struct iwl_powertable_cmd *cmd)
+{
+	struct ieee80211_hw *hw = mvm->hw;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_channel *chan;
+	int dtimper, dtimper_msec;
+	int keep_alive;
+	bool radar_detect = false;
+
+	cmd->id_and_color = cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id,
+							    mvmvif->color));
+	cmd->action = cpu_to_le32(FW_CTXT_ACTION_MODIFY);
+
+	if ((!vif->bss_conf.ps) ||
+	    (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM))
+		return;
+
+	cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK);
+
+	dtimper = hw->conf.ps_dtim_period ?: 1;
+
+	/* Check if radar detection is required on current channel */
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(vif->chanctx_conf);
+	WARN_ON(!chanctx_conf);
+	if (chanctx_conf) {
+		chan = chanctx_conf->def.chan;
+		radar_detect = chan->flags & IEEE80211_CHAN_RADAR;
+	}
+	rcu_read_unlock();
+
+	/* Check skip over DTIM conditions */
+	if (!radar_detect && (dtimper <= 10) &&
+	    (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_LP)) {
+		cmd->flags |= cpu_to_le16(POWER_FLAGS_SLEEP_OVER_DTIM_MSK);
+		cmd->num_skip_dtim = 2;
+	}
+
+	/* Check that keep alive period is at least 3 * DTIM */
+	dtimper_msec = dtimper * vif->bss_conf.beacon_int;
+	keep_alive = max_t(int, 3 * dtimper_msec,
+			   MSEC_PER_SEC * POWER_KEEP_ALIVE_PERIOD_SEC);
+	keep_alive = DIV_ROUND_UP(keep_alive, MSEC_PER_SEC);
+
+	cmd->keep_alive_seconds = cpu_to_le16(keep_alive);
+
+	if (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_LP) {
+		/* TODO: Also for D3 (device sleep / WoWLAN) */
+		cmd->rx_data_timeout = cpu_to_le32(10);
+		cmd->tx_data_timeout = cpu_to_le32(10);
+	} else {
+		cmd->rx_data_timeout = cpu_to_le32(50);
+		cmd->tx_data_timeout = cpu_to_le32(50);
+	}
+}
+
+int iwl_power_update_mode(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+{
+	struct iwl_powertable_cmd cmd = {};
+
+	if (!iwlwifi_mod_params.power_save) {
+		IWL_DEBUG_POWER(mvm, "Power management is not allowed\n");
+		return 0;
+	}
+
+	if (vif->type != NL80211_IFTYPE_STATION || vif->p2p)
+		return 0;
+
+	iwl_power_build_cmd(mvm, vif, &cmd);
+
+	IWL_DEBUG_POWER(mvm,
+			"Sending power table command on mac id 0x%X for power level %d, flags = 0x%X\n",
+			cmd.id_and_color, iwlmvm_mod_params.power_scheme,
+			le16_to_cpu(cmd.flags));
+
+	if (cmd.flags & cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK)) {
+		IWL_DEBUG_POWER(mvm, "Keep alive = %u sec\n",
+				le16_to_cpu(cmd.keep_alive_seconds));
+		IWL_DEBUG_POWER(mvm, "Rx timeout = %u usec\n",
+				le32_to_cpu(cmd.rx_data_timeout));
+		IWL_DEBUG_POWER(mvm, "Tx timeout = %u usec\n",
+				le32_to_cpu(cmd.tx_data_timeout));
+		IWL_DEBUG_POWER(mvm, "Rx timeout (uAPSD) = %u usec\n",
+				le32_to_cpu(cmd.rx_data_timeout_uapsd));
+		IWL_DEBUG_POWER(mvm, "Tx timeout = %u usec\n",
+				le32_to_cpu(cmd.tx_data_timeout_uapsd));
+		IWL_DEBUG_POWER(mvm, "LP RX RSSI threshold = %u\n",
+				cmd.lprx_rssi_threshold);
+		IWL_DEBUG_POWER(mvm, "DTIMs to skip = %u\n", cmd.num_skip_dtim);
+	}
+
+	return iwl_mvm_send_cmd_pdu(mvm, POWER_TABLE_CMD, CMD_SYNC,
+				    sizeof(cmd), &cmd);
+}
+
+int iwl_power_disable(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+{
+	struct iwl_powertable_cmd cmd = {};
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	if (!iwlwifi_mod_params.power_save) {
+		IWL_DEBUG_POWER(mvm, "Power management is not allowed\n");
+		return 0;
+	}
+
+	if (vif->type != NL80211_IFTYPE_STATION || vif->p2p)
+		return 0;
+
+	cmd.id_and_color = cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id,
+							    mvmvif->color));
+	cmd.action = cpu_to_le32(FW_CTXT_ACTION_MODIFY);
+
+	IWL_DEBUG_POWER(mvm,
+			"Sending power table command on mac id 0x%X for power level %d, flags = 0x%X\n",
+			cmd.id_and_color, iwlmvm_mod_params.power_scheme,
+			le16_to_cpu(cmd.flags));
+
+	return iwl_mvm_send_cmd_pdu(mvm, POWER_TABLE_CMD, CMD_SYNC,
+				    sizeof(cmd), &cmd);
+}
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+void iwl_power_get_params(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			  struct iwl_powertable_cmd *cmd)
+{
+	iwl_power_build_cmd(mvm, vif, cmd);
+}
+#endif /* CONFIG_IWLWIFI_DEBUGFS */
-- 
1.8.0

