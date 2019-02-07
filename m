Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12AE3C282C4
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:36:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB8712173B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfBGWgq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 17:36:46 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:56622 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726900AbfBGWgp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 17:36:45 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grsHh-0002II-Tx; Fri, 08 Feb 2019 00:36:42 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 00:36:13 +0200
Message-Id: <20190207223622.9642-9-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190207223622.9642-1-luca@coelho.fi>
References: <20190207223622.9642-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/17] iwlwifi: mvm: support FTM responder
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Add support for FTM responder for hardware/firmware combinations
that advertise support for it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   9 +
 .../net/wireless/intel/iwlwifi/mvm/Makefile   |   2 +-
 .../intel/iwlwifi/mvm/ftm-responder.c         | 244 ++++++++++++++++++
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  92 ++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |   9 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |   2 +
 6 files changed, 353 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/ftm-responder.c

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 8c6ce4142204..3bffb0f7a5e5 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -370,12 +370,15 @@ typedef unsigned int __bitwise iwl_ucode_tlv_capa_t;
  *	capability.
  * @IWL_UCODE_TLV_CAPA_CSI_REPORTING: firmware is capable of being configured
  *	to report the CSI information with (certain) RX frames
+ * @IWL_UCODE_TLV_CAPA_FTM_CALIBRATED: has FTM calibrated and thus supports both
+ *	initiator and responder
  *
  * @IWL_UCODE_TLV_CAPA_MLME_OFFLOAD: supports MLME offload
  *
  * @NUM_IWL_UCODE_TLV_CAPA: number of bits used
  */
 enum iwl_ucode_tlv_capa {
+	/* set 0 */
 	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT			= (__force iwl_ucode_tlv_capa_t)0,
 	IWL_UCODE_TLV_CAPA_LAR_SUPPORT			= (__force iwl_ucode_tlv_capa_t)1,
 	IWL_UCODE_TLV_CAPA_UMAC_SCAN			= (__force iwl_ucode_tlv_capa_t)2,
@@ -397,6 +400,8 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC		= (__force iwl_ucode_tlv_capa_t)29,
 	IWL_UCODE_TLV_CAPA_BT_COEX_RRC			= (__force iwl_ucode_tlv_capa_t)30,
 	IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT		= (__force iwl_ucode_tlv_capa_t)31,
+
+	/* set 1 */
 	IWL_UCODE_TLV_CAPA_STA_PM_NOTIF			= (__force iwl_ucode_tlv_capa_t)38,
 	IWL_UCODE_TLV_CAPA_BINDING_CDB_SUPPORT		= (__force iwl_ucode_tlv_capa_t)39,
 	IWL_UCODE_TLV_CAPA_CDB_SUPPORT			= (__force iwl_ucode_tlv_capa_t)40,
@@ -406,6 +411,9 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_COEX_SCHEMA_2		= (__force iwl_ucode_tlv_capa_t)45,
 	IWL_UCODE_TLV_CAPA_CHANNEL_SWITCH_CMD		= (__force iwl_ucode_tlv_capa_t)46,
 	IWL_UCODE_TLV_CAPA_ULTRA_HB_CHANNELS		= (__force iwl_ucode_tlv_capa_t)48,
+	IWL_UCODE_TLV_CAPA_FTM_CALIBRATED		= (__force iwl_ucode_tlv_capa_t)47,
+
+	/* set 2 */
 	IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE		= (__force iwl_ucode_tlv_capa_t)64,
 	IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS		= (__force iwl_ucode_tlv_capa_t)65,
 	IWL_UCODE_TLV_CAPA_BT_MPLUT_SUPPORT		= (__force iwl_ucode_tlv_capa_t)67,
@@ -426,6 +434,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_MCC_UPDATE_11AX_SUPPORT	= (__force iwl_ucode_tlv_capa_t)89,
 	IWL_UCODE_TLV_CAPA_CSI_REPORTING		= (__force iwl_ucode_tlv_capa_t)90,
 
+	/* set 3 */
 	IWL_UCODE_TLV_CAPA_MLME_OFFLOAD			= (__force iwl_ucode_tlv_capa_t)96,
 
 	NUM_IWL_UCODE_TLV_CAPA
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/Makefile b/drivers/net/wireless/intel/iwlwifi/mvm/Makefile
index 30cbd981efbd..56e8d073f5aa 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/Makefile
@@ -4,7 +4,7 @@ iwlmvm-y += fw.o mac80211.o nvm.o ops.o phy-ctxt.o mac-ctxt.o
 iwlmvm-y += utils.o rx.o rxmq.o tx.o binding.o quota.o sta.o sf.o
 iwlmvm-y += scan.o time-event.o rs.o rs-fw.o
 iwlmvm-y += power.o coex.o
-iwlmvm-y += tt.o offloading.o tdls.o
+iwlmvm-y += tt.o offloading.o tdls.o ftm-responder.o
 iwlmvm-$(CONFIG_IWLWIFI_DEBUGFS) += debugfs.o debugfs-vif.o
 iwlmvm-$(CONFIG_IWLWIFI_LEDS) += led.o
 iwlmvm-$(CONFIG_PM) += d3.o
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-responder.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-responder.c
new file mode 100644
index 000000000000..1513b8b4062f
--- /dev/null
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-responder.c
@@ -0,0 +1,244 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
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
+ * The full GNU General Public License is included in this distribution
+ * in the file called COPYING.
+ *
+ * Contact Information:
+ * Intel Linux Wireless <linuxwifi@intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
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
+#include <net/cfg80211.h>
+#include <linux/etherdevice.h>
+#include "mvm.h"
+#include "constants.h"
+
+static int
+iwl_mvm_ftm_responder_cmd(struct iwl_mvm *mvm,
+			  struct ieee80211_vif *vif,
+			  struct cfg80211_chan_def *chandef)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_tof_responder_config_cmd cmd = {
+		.channel_num = chandef->chan->hw_value,
+		.cmd_valid_fields =
+			cpu_to_le32(IWL_TOF_RESPONDER_CMD_VALID_CHAN_INFO |
+				    IWL_TOF_RESPONDER_CMD_VALID_BSSID |
+				    IWL_TOF_RESPONDER_CMD_VALID_STA_ID),
+		.sta_id = mvmvif->bcast_sta.sta_id,
+	};
+
+	lockdep_assert_held(&mvm->mutex);
+
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+		cmd.bandwidth = IWL_TOF_BW_20_LEGACY;
+		break;
+	case NL80211_CHAN_WIDTH_20:
+		cmd.bandwidth = IWL_TOF_BW_20_HT;
+		break;
+	case NL80211_CHAN_WIDTH_40:
+		cmd.bandwidth = IWL_TOF_BW_40;
+		cmd.ctrl_ch_position = iwl_mvm_get_ctrl_pos(chandef);
+		break;
+	case NL80211_CHAN_WIDTH_80:
+		cmd.bandwidth = IWL_TOF_BW_80;
+		cmd.ctrl_ch_position = iwl_mvm_get_ctrl_pos(chandef);
+		break;
+	default:
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	memcpy(cmd.bssid, vif->addr, ETH_ALEN);
+
+	return iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(TOF_RESPONDER_CONFIG_CMD,
+						    LOCATION_GROUP, 0),
+				    0, sizeof(cmd), &cmd);
+}
+
+static int
+iwl_mvm_ftm_responder_dyn_cfg_cmd(struct iwl_mvm *mvm,
+				  struct ieee80211_vif *vif,
+				  struct ieee80211_ftm_responder_params *params)
+{
+	struct iwl_tof_responder_dyn_config_cmd cmd = {
+		.lci_len = cpu_to_le32(params->lci_len + 2),
+		.civic_len = cpu_to_le32(params->civicloc_len + 2),
+	};
+	u8 data[IWL_LCI_CIVIC_IE_MAX_SIZE] = {0};
+	struct iwl_host_cmd hcmd = {
+		.id = iwl_cmd_id(TOF_RESPONDER_DYN_CONFIG_CMD,
+				 LOCATION_GROUP, 0),
+		.data[0] = &cmd,
+		.len[0] = sizeof(cmd),
+		.data[1] = &data,
+		/* .len[1] set later */
+		/* may not be able to DMA from stack */
+		.dataflags[1] = IWL_HCMD_DFL_DUP,
+	};
+	u32 aligned_lci_len = ALIGN(params->lci_len + 2, 4);
+	u32 aligned_civicloc_len = ALIGN(params->civicloc_len + 2, 4);
+	u8 *pos = data;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	if (aligned_lci_len + aligned_civicloc_len > sizeof(data)) {
+		IWL_ERR(mvm, "LCI/civicloc data too big (%zd + %zd)\n",
+			params->lci_len, params->civicloc_len);
+		return -ENOBUFS;
+	}
+
+	pos[0] = WLAN_EID_MEASURE_REPORT;
+	pos[1] = params->lci_len;
+	memcpy(pos + 2, params->lci, params->lci_len);
+
+	pos += aligned_lci_len;
+	pos[0] = WLAN_EID_MEASURE_REPORT;
+	pos[1] = params->civicloc_len;
+	memcpy(pos + 2, params->civicloc, params->civicloc_len);
+
+	hcmd.len[1] = aligned_lci_len + aligned_civicloc_len;
+
+	return iwl_mvm_send_cmd(mvm, &hcmd);
+}
+
+int iwl_mvm_ftm_start_responder(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct ieee80211_ftm_responder_params *params;
+	struct ieee80211_chanctx_conf ctx, *pctx;
+	u16 *phy_ctxt_id;
+	struct iwl_mvm_phy_ctxt *phy_ctxt;
+	int ret;
+
+	params = vif->bss_conf.ftmr_params;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	if (WARN_ON_ONCE(!vif->bss_conf.ftm_responder))
+		return -EINVAL;
+
+	if (vif->p2p || vif->type != NL80211_IFTYPE_AP ||
+	    !mvmvif->ap_ibss_active) {
+		IWL_ERR(mvm, "Cannot start responder, not in AP mode\n");
+		return -EIO;
+	}
+
+	rcu_read_lock();
+	pctx = rcu_dereference(vif->chanctx_conf);
+	/* Copy the ctx to unlock the rcu and send the phy ctxt. We don't care
+	 * about changes in the ctx after releasing the lock because the driver
+	 * is still protected by the mutex. */
+	ctx = *pctx;
+	phy_ctxt_id  = (u16 *)pctx->drv_priv;
+	rcu_read_unlock();
+
+	phy_ctxt = &mvm->phy_ctxts[*phy_ctxt_id];
+	ret = iwl_mvm_phy_ctxt_changed(mvm, phy_ctxt, &ctx.def,
+				       ctx.rx_chains_static,
+				       ctx.rx_chains_dynamic);
+	if (ret)
+		return ret;
+
+	ret = iwl_mvm_ftm_responder_cmd(mvm, vif, &ctx.def);
+	if (ret)
+		return ret;
+
+	if (params)
+		ret = iwl_mvm_ftm_responder_dyn_cfg_cmd(mvm, vif, params);
+
+	return ret;
+}
+
+void iwl_mvm_ftm_restart_responder(struct iwl_mvm *mvm,
+				   struct ieee80211_vif *vif)
+{
+	if (!vif->bss_conf.ftm_responder)
+		return;
+
+	iwl_mvm_ftm_start_responder(mvm, vif);
+}
+
+void iwl_mvm_ftm_responder_stats(struct iwl_mvm *mvm,
+				 struct iwl_rx_cmd_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_ftm_responder_stats *resp = (void *)pkt->data;
+	struct cfg80211_ftm_responder_stats *stats = &mvm->ftm_resp_stats;
+	u32 flags = le32_to_cpu(resp->flags);
+
+	if (resp->success_ftm == resp->ftm_per_burst)
+		stats->success_num++;
+	else if (resp->success_ftm >= 2)
+		stats->partial_num++;
+	else
+		stats->failed_num++;
+
+	if ((flags & FTM_RESP_STAT_ASAP_REQ) &&
+	    (flags & FTM_RESP_STAT_ASAP_RESP))
+		stats->asap_num++;
+
+	if (flags & FTM_RESP_STAT_NON_ASAP_RESP)
+		stats->non_asap_num++;
+
+	stats->total_duration_ms += le32_to_cpu(resp->duration) / USEC_PER_MSEC;
+
+	if (flags & FTM_RESP_STAT_TRIGGER_UNKNOWN)
+		stats->unknown_triggers_num++;
+
+	if (flags & FTM_RESP_STAT_DUP)
+		stats->reschedule_requests_num++;
+
+	if (flags & FTM_RESP_STAT_NON_ASAP_OUT_WIN)
+		stats->out_of_window_triggers_num++;
+}
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index ea121c398aae..cba1a0fe33ca 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -548,6 +548,11 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		hw->wiphy->n_cipher_suites++;
 	}
 
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_FTM_CALIBRATED))
+		wiphy_ext_feature_set(hw->wiphy,
+				      NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER);
+
 	ieee80211_hw_set(hw, SINGLE_SCAN_ON_ALL_BANDS);
 	hw->wiphy->features |=
 		NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR |
@@ -1657,6 +1662,9 @@ static void iwl_mvm_mac_remove_interface(struct ieee80211_hw *hw,
 				       IEEE80211_VIF_SUPPORTS_CQM_RSSI);
 	}
 
+	if (vif->bss_conf.ftm_responder)
+		memset(&mvm->ftm_resp_stats, 0, sizeof(mvm->ftm_resp_stats));
+
 	iwl_mvm_vif_dbgfs_clean(mvm, vif);
 
 	/*
@@ -2548,6 +2556,8 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	if (iwl_mvm_phy_ctx_count(mvm) > 1)
 		iwl_mvm_teardown_tdls_peers(mvm);
 
+	iwl_mvm_ftm_restart_responder(mvm, vif);
+
 	goto out_unlock;
 
 out_quota_failed:
@@ -2659,6 +2669,15 @@ iwl_mvm_bss_info_changed_ap_ibss(struct iwl_mvm *mvm,
 				bss_conf->txpower);
 		iwl_mvm_set_tx_power(mvm, vif, bss_conf->txpower);
 	}
+
+	if (changes & BSS_CHANGED_FTM_RESPONDER) {
+		int ret = iwl_mvm_ftm_start_responder(mvm, vif);
+
+		if (ret)
+			IWL_WARN(mvm, "Failed to enable FTM responder (%d)\n",
+				 ret);
+	}
+
 }
 
 static void iwl_mvm_bss_info_changed(struct ieee80211_hw *hw,
@@ -3796,11 +3815,43 @@ static int iwl_mvm_cancel_roc(struct ieee80211_hw *hw)
 	return 0;
 }
 
+struct iwl_mvm_ftm_responder_iter_data {
+	bool responder;
+	struct ieee80211_chanctx_conf *ctx;
+};
+
+static void iwl_mvm_ftm_responder_chanctx_iter(void *_data, u8 *mac,
+					       struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_ftm_responder_iter_data *data = _data;
+
+	if (rcu_access_pointer(vif->chanctx_conf) == data->ctx &&
+	    vif->type == NL80211_IFTYPE_AP && vif->bss_conf.ftmr_params)
+		data->responder = true;
+}
+
+static bool iwl_mvm_is_ftm_responder_chanctx(struct iwl_mvm *mvm,
+					     struct ieee80211_chanctx_conf *ctx)
+{
+	struct iwl_mvm_ftm_responder_iter_data data = {
+		.responder = false,
+		.ctx = ctx,
+	};
+
+	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
+					IEEE80211_IFACE_ITER_NORMAL,
+					iwl_mvm_ftm_responder_chanctx_iter,
+					&data);
+	return data.responder;
+}
+
 static int __iwl_mvm_add_chanctx(struct iwl_mvm *mvm,
 				 struct ieee80211_chanctx_conf *ctx)
 {
 	u16 *phy_ctxt_id = (u16 *)ctx->drv_priv;
 	struct iwl_mvm_phy_ctxt *phy_ctxt;
+	bool responder = iwl_mvm_is_ftm_responder_chanctx(mvm, ctx);
+	struct cfg80211_chan_def *def = responder ? &ctx->def : &ctx->min_def;
 	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -3813,7 +3864,7 @@ static int __iwl_mvm_add_chanctx(struct iwl_mvm *mvm,
 		goto out;
 	}
 
-	ret = iwl_mvm_phy_ctxt_changed(mvm, phy_ctxt, &ctx->min_def,
+	ret = iwl_mvm_phy_ctxt_changed(mvm, phy_ctxt, def,
 				       ctx->rx_chains_static,
 				       ctx->rx_chains_dynamic);
 	if (ret) {
@@ -3868,6 +3919,8 @@ static void iwl_mvm_change_chanctx(struct ieee80211_hw *hw,
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	u16 *phy_ctxt_id = (u16 *)ctx->drv_priv;
 	struct iwl_mvm_phy_ctxt *phy_ctxt = &mvm->phy_ctxts[*phy_ctxt_id];
+	bool responder = iwl_mvm_is_ftm_responder_chanctx(mvm, ctx);
+	struct cfg80211_chan_def *def = responder ? &ctx->def : &ctx->min_def;
 
 	if (WARN_ONCE((phy_ctxt->ref > 1) &&
 		      (changed & ~(IEEE80211_CHANCTX_CHANGE_WIDTH |
@@ -3882,17 +3935,17 @@ static void iwl_mvm_change_chanctx(struct ieee80211_hw *hw,
 
 	/* we are only changing the min_width, may be a noop */
 	if (changed == IEEE80211_CHANCTX_CHANGE_MIN_WIDTH) {
-		if (phy_ctxt->width == ctx->min_def.width)
+		if (phy_ctxt->width == def->width)
 			goto out_unlock;
 
 		/* we are just toggling between 20_NOHT and 20 */
 		if (phy_ctxt->width <= NL80211_CHAN_WIDTH_20 &&
-		    ctx->min_def.width <= NL80211_CHAN_WIDTH_20)
+		    def->width <= NL80211_CHAN_WIDTH_20)
 			goto out_unlock;
 	}
 
 	iwl_mvm_bt_coex_vif_change(mvm);
-	iwl_mvm_phy_ctxt_changed(mvm, phy_ctxt, &ctx->min_def,
+	iwl_mvm_phy_ctxt_changed(mvm, phy_ctxt, def,
 				 ctx->rx_chains_static,
 				 ctx->rx_chains_dynamic);
 
@@ -4813,6 +4866,35 @@ static void iwl_mvm_sync_rx_queues(struct ieee80211_hw *hw)
 	mutex_unlock(&mvm->mutex);
 }
 
+static int
+iwl_mvm_mac_get_ftm_responder_stats(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif,
+				    struct cfg80211_ftm_responder_stats *stats)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	if (vif->p2p || vif->type != NL80211_IFTYPE_AP ||
+	    !mvmvif->ap_ibss_active || !vif->bss_conf.ftm_responder)
+		return -EINVAL;
+
+	mutex_lock(&mvm->mutex);
+	*stats = mvm->ftm_resp_stats;
+	mutex_unlock(&mvm->mutex);
+
+	stats->filled = BIT(NL80211_FTM_STATS_SUCCESS_NUM) |
+			BIT(NL80211_FTM_STATS_PARTIAL_NUM) |
+			BIT(NL80211_FTM_STATS_FAILED_NUM) |
+			BIT(NL80211_FTM_STATS_ASAP_NUM) |
+			BIT(NL80211_FTM_STATS_NON_ASAP_NUM) |
+			BIT(NL80211_FTM_STATS_TOTAL_DURATION_MSEC) |
+			BIT(NL80211_FTM_STATS_UNKNOWN_TRIGGERS_NUM) |
+			BIT(NL80211_FTM_STATS_RESCHEDULE_REQUESTS_NUM) |
+			BIT(NL80211_FTM_STATS_OUT_OF_WINDOW_TRIGGERS_NUM);
+
+	return 0;
+}
+
 static bool iwl_mvm_can_hw_csum(struct sk_buff *skb)
 {
 	u8 protocol = ip_hdr(skb)->protocol;
@@ -4915,6 +4997,8 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 #endif
 	.get_survey = iwl_mvm_mac_get_survey,
 	.sta_statistics = iwl_mvm_mac_sta_statistics,
+	.get_ftm_responder_stats = iwl_mvm_mac_get_ftm_responder_stats,
+
 	.can_aggregate_in_amsdu = iwl_mvm_mac_can_aggregate,
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	.sta_add_debugfs = iwl_mvm_sta_add_debugfs,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index ee61f4a00c5e..2bd330a093fb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1150,6 +1150,8 @@ struct iwl_mvm {
 	u32 ciphers[IWL_MVM_NUM_CIPHERS];
 	struct ieee80211_cipher_scheme cs[IWL_UCODE_MAX_CS];
 
+	struct cfg80211_ftm_responder_stats ftm_resp_stats;
+
 	struct ieee80211_vif *nan_vif;
 #define IWL_MAX_BAID	32
 	struct iwl_mvm_baid_data __rcu *baid_map[IWL_MAX_BAID];
@@ -2060,6 +2062,13 @@ void iwl_mvm_update_changed_regdom(struct iwl_mvm *mvm);
 int iwl_mvm_sf_update(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		      bool added_vif);
 
+/* FTM responder */
+int iwl_mvm_ftm_start_responder(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+void iwl_mvm_ftm_restart_responder(struct iwl_mvm *mvm,
+				   struct ieee80211_vif *vif);
+void iwl_mvm_ftm_responder_stats(struct iwl_mvm *mvm,
+				 struct iwl_rx_cmd_buffer *rxb);
+
 /* TDLS */
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 8a16388c3a0b..d5644d252fe0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -300,6 +300,8 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 		   RX_HANDLER_ASYNC_LOCKED),
 	RX_HANDLER(MFUART_LOAD_NOTIFICATION, iwl_mvm_rx_mfuart_notif,
 		   RX_HANDLER_SYNC),
+	RX_HANDLER_GRP(LOCATION_GROUP, TOF_RESPONDER_STATS,
+		       iwl_mvm_ftm_responder_stats, RX_HANDLER_ASYNC_LOCKED),
 	RX_HANDLER_GRP(DEBUG_GROUP, MFU_ASSERT_DUMP_NTF,
 		       iwl_mvm_mfu_assert_dump_notif, RX_HANDLER_SYNC),
 	RX_HANDLER_GRP(PROT_OFFLOAD_GROUP, STORED_BEACON_NTF,
-- 
2.20.1

