Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:42391 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3LQUot (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:44:49 -0500
Received: by mail-ea0-f182.google.com with SMTP id a15so3162726eae.13
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:44:48 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Lilach Edelstein <lilach.edelstein@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/36] iwlwifi: mvm: Add Smart FIFO support
Date: Tue, 17 Dec 2013 22:44:05 +0200
Message-Id: <1387313079-28123-2-git-send-email-egrumbach@gmail.com> (sfid-20131217_214453_505826_6677B609)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lilach Edelstein <lilach.edelstein@intel.com>

Send firmware a Smart FIFO Configuration host command to allow
interrupt coalescing. The smart FIFO is enabled when there is
only one bound interface (other than  p2p devices which are
ignored) and it is of type station, and activated while the
station is associated.

Smart Fifo allows aggragations of DMA transactions and by that
causes processor and memory controller to stay for a longer time
on lower c-states, thus saving platform power.
Firmware relies on driver to activate and disable it.

Signed-off-by: Lilach Edelstein <lilach.edelstein@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/Makefile   |    2 +-
 drivers/net/wireless/iwlwifi/mvm/binding.c  |   16 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h   |   62 ++++++
 drivers/net/wireless/iwlwifi/mvm/fw.c       |    4 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   21 ++
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |    7 +
 drivers/net/wireless/iwlwifi/mvm/ops.c      |    1 +
 drivers/net/wireless/iwlwifi/mvm/sf.c       |  291 +++++++++++++++++++++++++++
 8 files changed, 402 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/sf.c

diff --git a/drivers/net/wireless/iwlwifi/mvm/Makefile b/drivers/net/wireless/iwlwifi/mvm/Makefile
index 285d8c7..3ea47ab 100644
--- a/drivers/net/wireless/iwlwifi/mvm/Makefile
+++ b/drivers/net/wireless/iwlwifi/mvm/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_IWLMVM)   += iwlmvm.o
 iwlmvm-y += fw.o mac80211.o nvm.o ops.o phy-ctxt.o mac-ctxt.o
-iwlmvm-y += utils.o rx.o tx.o binding.o quota.o sta.o
+iwlmvm-y += utils.o rx.o tx.o binding.o quota.o sta.o sf.o
 iwlmvm-y += scan.o time-event.o rs.o
 iwlmvm-y += power.o power_legacy.o bt-coex.o
 iwlmvm-y += led.o tt.o
diff --git a/drivers/net/wireless/iwlwifi/mvm/binding.c b/drivers/net/wireless/iwlwifi/mvm/binding.c
index 93fd145..57d3eed 100644
--- a/drivers/net/wireless/iwlwifi/mvm/binding.c
+++ b/drivers/net/wireless/iwlwifi/mvm/binding.c
@@ -183,15 +183,29 @@ int iwl_mvm_binding_add_vif(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	if (WARN_ON_ONCE(!mvmvif->phy_ctxt))
 		return -EINVAL;
 
+	/*
+	 * Update SF - Disable if needed. if this fails, SF might still be on
+	 * while many macs are bound, which is forbidden - so fail the binding.
+	 */
+	if (iwl_mvm_sf_update(mvm, vif, false))
+		return -EINVAL;
+
 	return iwl_mvm_binding_update(mvm, vif, mvmvif->phy_ctxt, true);
 }
 
 int iwl_mvm_binding_remove_vif(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	int ret;
 
 	if (WARN_ON_ONCE(!mvmvif->phy_ctxt))
 		return -EINVAL;
 
-	return iwl_mvm_binding_update(mvm, vif, mvmvif->phy_ctxt, false);
+	ret = iwl_mvm_binding_update(mvm, vif, mvmvif->phy_ctxt, false);
+
+	if (!ret)
+		if (iwl_mvm_sf_update(mvm, vif, true))
+			IWL_ERR(mvm, "Failed to update SF state\n");
+
+	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index bad5a55..3af4133 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -183,6 +183,7 @@ enum {
 	BT_PROFILE_NOTIFICATION = 0xce,
 	BT_COEX_CI = 0x5d,
 
+	REPLY_SF_CFG_CMD = 0xd1,
 	REPLY_BEACON_FILTERING_CMD = 0xd2,
 
 	REPLY_DEBUG_CMD = 0xf0,
@@ -1363,4 +1364,65 @@ struct iwl_notif_statistics { /* STATISTICS_NTFY_API_S_VER_8 */
 	struct mvm_statistics_general general;
 } __packed;
 
+/***********************************
+ * Smart Fifo API
+ ***********************************/
+/* Smart Fifo state */
+enum iwl_sf_state {
+	SF_LONG_DELAY_ON = 0, /* should never be called by driver */
+	SF_FULL_ON,
+	SF_UNINIT,
+	SF_INIT_OFF,
+	SF_HW_NUM_STATES
+};
+
+/* Smart Fifo possible scenario */
+enum iwl_sf_scenario {
+	SF_SCENARIO_SINGLE_UNICAST,
+	SF_SCENARIO_AGG_UNICAST,
+	SF_SCENARIO_MULTICAST,
+	SF_SCENARIO_BA_RESP,
+	SF_SCENARIO_TX_RESP,
+	SF_NUM_SCENARIO
+};
+
+#define SF_TRANSIENT_STATES_NUMBER 2	/* SF_LONG_DELAY_ON and SF_FULL_ON */
+#define SF_NUM_TIMEOUT_TYPES 2		/* Aging timer and Idle timer */
+
+/* smart FIFO default values */
+#define SF_W_MARK_SISO 4096
+#define SF_W_MARK_MIMO2 8192
+#define SF_W_MARK_MIMO3 6144
+#define SF_W_MARK_LEGACY 4096
+#define SF_W_MARK_SCAN 4096
+
+/* SF Scenarios timers for FULL_ON state (aligned to 32 uSec) */
+#define SF_SINGLE_UNICAST_IDLE_TIMER 320	/* 300 uSec  */
+#define SF_SINGLE_UNICAST_AGING_TIMER 2016	/* 2 mSec */
+#define SF_AGG_UNICAST_IDLE_TIMER 320		/* 300 uSec */
+#define SF_AGG_UNICAST_AGING_TIMER 2016		/* 2 mSec */
+#define SF_MCAST_IDLE_TIMER 2016		/* 2 mSec */
+#define SF_MCAST_AGING_TIMER 10016		/* 10 mSec */
+#define SF_BA_IDLE_TIMER 320			/* 300 uSec */
+#define SF_BA_AGING_TIMER 2016			/* 2 mSec */
+#define SF_TX_RE_IDLE_TIMER 320			/* 300 uSec */
+#define SF_TX_RE_AGING_TIMER 2016		/* 2 mSec */
+
+#define SF_LONG_DELAY_AGING_TIMER 1000000	/* 1 Sec */
+
+/**
+ * Smart Fifo configuration command.
+ * @state: smart fifo state, types listed in iwl_sf_sate.
+ * @watermark: Minimum allowed availabe free space in RXF for transient state.
+ * @long_delay_timeouts: aging and idle timer values for each scenario
+ * in long delay state.
+ * @full_on_timeouts: timer values for each scenario in full on state.
+ */
+struct iwl_sf_cfg_cmd {
+	enum iwl_sf_state state;
+	__le32 watermark[SF_TRANSIENT_STATES_NUMBER];
+	__le32 long_delay_timeouts[SF_NUM_SCENARIO][SF_NUM_TIMEOUT_TYPES];
+	__le32 full_on_timeouts[SF_NUM_SCENARIO][SF_NUM_TIMEOUT_TYPES];
+} __packed; /* SF_CFG_API_S_VER_2 */
+
 #endif /* __fw_api_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 70e5297..b2bfa73 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -386,6 +386,10 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 		goto error;
 	}
 
+	ret = iwl_mvm_sf_update(mvm, NULL, false);
+	if (ret)
+		IWL_ERR(mvm, "Failed to initialize Smart Fifo\n");
+
 	ret = iwl_send_tx_ant_cfg(mvm, iwl_fw_valid_tx_ant(mvm->fw));
 	if (ret)
 		goto error;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index afc4419..f0f8b2c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -850,7 +850,16 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 				iwl_mvm_protect_session(mvm, vif, dur, dur,
 							5 * dur);
 			}
+
+			iwl_mvm_sf_update(mvm, vif, false);
 		} else if (mvmvif->ap_sta_id != IWL_MVM_STATION_COUNT) {
+			/*
+			 * If update fails - SF might be running in associated
+			 * mode while disassociated - which is forbidden.
+			 */
+			WARN_ONCE(iwl_mvm_sf_update(mvm, vif, false),
+				  "Failed to update SF upon disassociation\n");
+
 			/* remove AP station now that the MAC is unassoc */
 			ret = iwl_mvm_rm_sta_id(mvm, vif, mvmvif->ap_sta_id);
 			if (ret)
@@ -1200,6 +1209,17 @@ static int iwl_mvm_mac_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 	return 0;
 }
 
+static void iwl_mvm_sta_rc_update(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif,
+				  struct ieee80211_sta *sta, u32 changed)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+
+	if (vif->type == NL80211_IFTYPE_STATION &&
+	    changed & IEEE80211_RC_NSS_CHANGED)
+		iwl_mvm_sf_update(mvm, vif, false);
+}
+
 static int iwl_mvm_mac_conf_tx(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif, u16 ac,
 			       const struct ieee80211_tx_queue_params *params)
@@ -1765,6 +1785,7 @@ struct ieee80211_ops iwl_mvm_hw_ops = {
 	.sta_notify = iwl_mvm_mac_sta_notify,
 	.allow_buffered_frames = iwl_mvm_mac_allow_buffered_frames,
 	.set_rts_threshold = iwl_mvm_mac_set_rts_threshold,
+	.sta_rc_update = iwl_mvm_sta_rc_update,
 	.conf_tx = iwl_mvm_mac_conf_tx,
 	.mgd_prepare_tx = iwl_mvm_mac_mgd_prepare_tx,
 	.sched_scan_start = iwl_mvm_mac_sched_scan_start,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 7dc57cf..bd072c7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -489,6 +489,9 @@ struct iwl_mvm {
 	u8 scan_last_antenna_idx; /* to toggle TX between antennas */
 	u8 mgmt_last_antenna_idx;
 
+	/* last smart fifo state that was successfully sent to firmware */
+	enum iwl_sf_state sf_state;
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	struct dentry *debugfs_dir;
 	u32 dbgfs_sram_offset, dbgfs_sram_len;
@@ -869,4 +872,8 @@ void iwl_mvm_tt_initialize(struct iwl_mvm *mvm);
 void iwl_mvm_tt_exit(struct iwl_mvm *mvm);
 void iwl_mvm_set_hw_ctkill_state(struct iwl_mvm *mvm, bool state);
 
+/* smart fifo */
+int iwl_mvm_sf_update(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+		      bool added_vif);
+
 #endif /* __IWL_MVM_H__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index d86083c..cae6123 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -359,6 +359,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		mvm->aux_queue = 11;
 		mvm->first_agg_queue = 12;
 	}
+	mvm->sf_state = SF_UNINIT;
 
 	mutex_init(&mvm->mutex);
 	spin_lock_init(&mvm->async_handlers_lock);
diff --git a/drivers/net/wireless/iwlwifi/mvm/sf.c b/drivers/net/wireless/iwlwifi/mvm/sf.c
new file mode 100644
index 0000000..97bb3c3
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/mvm/sf.c
@@ -0,0 +1,291 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2013 Intel Corporation. All rights reserved.
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
+ * in the file called COPYING.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2013 Intel Corporation. All rights reserved.
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
+#include "mvm.h"
+
+/* For counting bound interfaces */
+struct iwl_mvm_active_iface_iterator_data {
+	struct ieee80211_vif *ignore_vif;
+	u8 sta_vif_ap_sta_id;
+	enum iwl_sf_state sta_vif_state;
+	int num_active_macs;
+};
+
+/*
+ * Count bound interfaces which are not p2p, besides data->ignore_vif.
+ * data->station_vif will point to one bound vif of type station, if exists.
+ */
+static void iwl_mvm_bound_iface_iterator(void *_data, u8 *mac,
+					 struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_active_iface_iterator_data *data = _data;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	if (vif == data->ignore_vif || !mvmvif->phy_ctxt ||
+	    vif->type == NL80211_IFTYPE_P2P_DEVICE)
+		return;
+
+	data->num_active_macs++;
+
+	if (vif->type == NL80211_IFTYPE_STATION) {
+		data->sta_vif_ap_sta_id = mvmvif->ap_sta_id;
+		if (vif->bss_conf.assoc)
+			data->sta_vif_state = SF_FULL_ON;
+		else
+			data->sta_vif_state = SF_INIT_OFF;
+	}
+}
+
+/*
+ * Aging and idle timeouts for the different possible scenarios
+ * in SF_FULL_ON state.
+ */
+static const __le32 sf_full_timeout[SF_NUM_SCENARIO][SF_NUM_TIMEOUT_TYPES] = {
+	{
+		cpu_to_le32(SF_SINGLE_UNICAST_AGING_TIMER),
+		cpu_to_le32(SF_SINGLE_UNICAST_IDLE_TIMER)
+	},
+	{
+		cpu_to_le32(SF_AGG_UNICAST_AGING_TIMER),
+		cpu_to_le32(SF_AGG_UNICAST_IDLE_TIMER)
+	},
+	{
+		cpu_to_le32(SF_MCAST_AGING_TIMER),
+		cpu_to_le32(SF_MCAST_IDLE_TIMER)
+	},
+	{
+		cpu_to_le32(SF_BA_AGING_TIMER),
+		cpu_to_le32(SF_BA_IDLE_TIMER)
+	},
+	{
+		cpu_to_le32(SF_TX_RE_AGING_TIMER),
+		cpu_to_le32(SF_TX_RE_IDLE_TIMER)
+	},
+};
+
+static void iwl_mvm_fill_sf_command(struct iwl_sf_cfg_cmd *sf_cmd,
+				    struct ieee80211_sta *sta)
+{
+	int i, j, watermark;
+
+	sf_cmd->watermark[SF_LONG_DELAY_ON] = cpu_to_le32(SF_W_MARK_SCAN);
+
+	/*
+	 * If we are in association flow - check antenna configuration
+	 * capabilities of the AP station, and choose the watermark accordingly.
+	 */
+	if (sta) {
+		if (sta->ht_cap.ht_supported || sta->vht_cap.vht_supported) {
+			switch (sta->rx_nss) {
+			case 1:
+				watermark = SF_W_MARK_SISO;
+				break;
+			case 2:
+				watermark = SF_W_MARK_MIMO2;
+				break;
+			default:
+				watermark = SF_W_MARK_MIMO3;
+				break;
+			}
+		} else {
+			watermark = SF_W_MARK_LEGACY;
+		}
+	/* default watermark value for unassociated mode. */
+	} else {
+		watermark = SF_W_MARK_MIMO2;
+	}
+	sf_cmd->watermark[SF_FULL_ON] = cpu_to_le32(watermark);
+
+	for (i = 0; i < SF_NUM_SCENARIO; i++) {
+		for (j = 0; j < SF_NUM_TIMEOUT_TYPES; j++) {
+			sf_cmd->long_delay_timeouts[i][j] =
+					cpu_to_le32(SF_LONG_DELAY_AGING_TIMER);
+		}
+	}
+	BUILD_BUG_ON(sizeof(sf_full_timeout) !=
+		     sizeof(__le32) * SF_NUM_SCENARIO * SF_NUM_TIMEOUT_TYPES);
+
+	memcpy(sf_cmd->full_on_timeouts, sf_full_timeout,
+	       sizeof(sf_full_timeout));
+}
+
+static int iwl_mvm_sf_config(struct iwl_mvm *mvm, u8 sta_id,
+			     enum iwl_sf_state new_state)
+{
+	struct iwl_sf_cfg_cmd sf_cmd = {
+		.state = new_state,
+	};
+	struct ieee80211_sta *sta;
+	int ret = 0;
+
+	/*
+	 * If an associated AP sta changed its antenna configuration, the state
+	 * will remain FULL_ON but SF parameters need to be reconsidered.
+	 */
+	if (new_state != SF_FULL_ON && mvm->sf_state == new_state)
+		return 0;
+
+	switch (new_state) {
+	case SF_UNINIT:
+		break;
+	case SF_FULL_ON:
+		if (sta_id == IWL_MVM_STATION_COUNT) {
+			IWL_ERR(mvm,
+				"No station: Cannot switch SF to FULL_ON\n");
+			return -EINVAL;
+		}
+		rcu_read_lock();
+		sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
+		if (IS_ERR_OR_NULL(sta)) {
+			IWL_ERR(mvm, "Invalid station id\n");
+			rcu_read_unlock();
+			return -EINVAL;
+		}
+		iwl_mvm_fill_sf_command(&sf_cmd, sta);
+		rcu_read_unlock();
+		break;
+	case SF_INIT_OFF:
+		iwl_mvm_fill_sf_command(&sf_cmd, NULL);
+		break;
+	default:
+		WARN_ONCE(1, "Invalid state: %d. not sending Smart Fifo cmd\n",
+			  new_state);
+		return -EINVAL;
+	}
+
+	ret = iwl_mvm_send_cmd_pdu(mvm, REPLY_SF_CFG_CMD, CMD_ASYNC,
+				   sizeof(sf_cmd), &sf_cmd);
+	if (!ret)
+		mvm->sf_state = new_state;
+
+	return ret;
+}
+
+/*
+ * Update Smart fifo:
+ * Count bound interfaces that are not to be removed, ignoring p2p devices,
+ * and set new state accordingly.
+ */
+int iwl_mvm_sf_update(struct iwl_mvm *mvm, struct ieee80211_vif *changed_vif,
+		      bool remove_vif)
+{
+	enum iwl_sf_state new_state;
+	u8 sta_id = IWL_MVM_STATION_COUNT;
+	struct iwl_mvm_vif *mvmvif = NULL;
+	struct iwl_mvm_active_iface_iterator_data data = {
+		.ignore_vif = changed_vif,
+		.sta_vif_state = SF_UNINIT,
+		.sta_vif_ap_sta_id = IWL_MVM_STATION_COUNT,
+	};
+
+	if (IWL_UCODE_API(mvm->fw->ucode_ver) < 8)
+		return 0;
+
+	/*
+	 * Ignore the call if we are in HW Restart flow, or if the handled
+	 * vif is a p2p device.
+	 */
+	if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status) ||
+	    (changed_vif && changed_vif->type == NL80211_IFTYPE_P2P_DEVICE))
+		return 0;
+
+	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
+						   IEEE80211_IFACE_ITER_NORMAL,
+						   iwl_mvm_bound_iface_iterator,
+						   &data);
+
+	/* If changed_vif exists and is not to be removed, add to the count */
+	if (changed_vif && !remove_vif)
+		data.num_active_macs++;
+
+	switch (data.num_active_macs) {
+	case 0:
+		/* If there are no active macs - change state to SF_INIT_OFF */
+		new_state = SF_INIT_OFF;
+		break;
+	case 1:
+		if (remove_vif) {
+			/* The one active mac left is of type station
+			 * and we filled the relevant data during iteration
+			 */
+			new_state = data.sta_vif_state;
+			sta_id = data.sta_vif_ap_sta_id;
+		} else {
+			if (WARN_ON(!changed_vif))
+				return -EINVAL;
+			if (changed_vif->type != NL80211_IFTYPE_STATION) {
+				new_state = SF_UNINIT;
+			} else if (changed_vif->bss_conf.assoc) {
+				mvmvif = iwl_mvm_vif_from_mac80211(changed_vif);
+				sta_id = mvmvif->ap_sta_id;
+				new_state = SF_FULL_ON;
+			} else {
+				new_state = SF_INIT_OFF;
+			}
+		}
+		break;
+	default:
+		/* If there are multiple active macs - change to SF_UNINIT */
+		new_state = SF_UNINIT;
+	}
+	return iwl_mvm_sf_config(mvm, sta_id, new_state);
+}
-- 
1.7.9.5

