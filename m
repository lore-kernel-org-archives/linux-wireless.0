Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BAC2C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10CEC2173B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfBGWgr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 17:36:47 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:56632 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726622AbfBGWgq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 17:36:46 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grsHj-0002II-4H; Fri, 08 Feb 2019 00:36:44 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 00:36:14 +0200
Message-Id: <20190207223622.9642-10-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190207223622.9642-1-luca@coelho.fi>
References: <20190207223622.9642-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/17] iwlwifi: mvm: support FTM initiator
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Add support for FTM initiator, i.e. peer measurements with FTM
if the firmware supports FTM.

Additionally, add two defines we depend on in
include/linux/ieee80211.h.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/location.h  |  10 +-
 .../net/wireless/intel/iwlwifi/mvm/Makefile   |   3 +-
 .../wireless/intel/iwlwifi/mvm/constants.h    |   3 +
 .../intel/iwlwifi/mvm/ftm-initiator.c         | 459 ++++++++++++++++++
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  56 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  16 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |   7 +
 include/linux/ieee80211.h                     |   2 +
 8 files changed, 552 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/location.h b/drivers/net/wireless/intel/iwlwifi/fw/api/location.h
index 6da91ec0df55..10cac5f987e7 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/location.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/location.h
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -28,6 +29,7 @@
  *
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -403,7 +405,10 @@ enum iwl_tof_response_mode {
  * @IWL_TOF_INITIATOR_FLAGS_TX_CHAIN_SEL_A: use antenna A fo TX ACKs during FTM
  * @IWL_TOF_INITIATOR_FLAGS_TX_CHAIN_SEL_B: use antenna B fo TX ACKs during FTM
  * @IWL_TOF_INITIATOR_FLAGS_TX_CHAIN_SEL_C: use antenna C fo TX ACKs during FTM
- * @IWL_TOF_INITIATOR_FLAGS_MINDELTA_NO_PREF: no preference for minDeltaFTM
+ * @IWL_TOF_INITIATOR_FLAGS_SPECIFIC_CALIB: use the specific calib value from
+ *	the range request command
+ * @IWL_TOF_INITIATOR_FLAGS_COMMON_CALIB: use the common calib value from the
+ *	ragne request command
  */
 enum iwl_tof_initiator_flags {
 	IWL_TOF_INITIATOR_FLAGS_FAST_ALGO_DISABLED = BIT(0),
@@ -413,7 +418,8 @@ enum iwl_tof_initiator_flags {
 	IWL_TOF_INITIATOR_FLAGS_TX_CHAIN_SEL_A = BIT(4),
 	IWL_TOF_INITIATOR_FLAGS_TX_CHAIN_SEL_B = BIT(5),
 	IWL_TOF_INITIATOR_FLAGS_TX_CHAIN_SEL_C = BIT(6),
-	IWL_TOF_INITIATOR_FLAGS_MINDELTA_NO_PREF = BIT(7),
+	IWL_TOF_INITIATOR_FLAGS_SPECIFIC_CALIB = BIT(15),
+	IWL_TOF_INITIATOR_FLAGS_COMMON_CALIB   = BIT(16),
 }; /* LOCATION_RANGE_REQ_CMD_API_S_VER_5 */
 
 #define IWL_MVM_TOF_MAX_APS 5
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/Makefile b/drivers/net/wireless/intel/iwlwifi/mvm/Makefile
index 56e8d073f5aa..dd268c4bd371 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/Makefile
@@ -4,7 +4,8 @@ iwlmvm-y += fw.o mac80211.o nvm.o ops.o phy-ctxt.o mac-ctxt.o
 iwlmvm-y += utils.o rx.o rxmq.o tx.o binding.o quota.o sta.o sf.o
 iwlmvm-y += scan.o time-event.o rs.o rs-fw.o
 iwlmvm-y += power.o coex.o
-iwlmvm-y += tt.o offloading.o tdls.o ftm-responder.o
+iwlmvm-y += tt.o offloading.o tdls.o
+iwlmvm-y += ftm-responder.o ftm-initiator.o
 iwlmvm-$(CONFIG_IWLWIFI_DEBUGFS) += debugfs.o debugfs-vif.o
 iwlmvm-$(CONFIG_IWLWIFI_LEDS) += led.o
 iwlmvm-$(CONFIG_PM) += d3.o
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
index d96ada3c06fc..58e29af12a14 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/constants.h
@@ -63,6 +63,7 @@
 #define __MVM_CONSTANTS_H
 
 #include <linux/ieee80211.h>
+#include "fw-api.h"
 
 #define IWL_MVM_UAPSD_NOAGG_BSSIDS_NUM		20
 
@@ -145,5 +146,7 @@
 #define IWL_MVM_RS_TPC_SR_NO_INCREASE		85	/* percent */
 #define IWL_MVM_RS_TPC_TX_POWER_STEP		3
 #define IWL_MVM_ENABLE_EBS			1
+#define IWL_MVM_FTM_INITIATOR_ALGO		IWL_TOF_ALGO_TYPE_MAX_LIKE
+#define IWL_MVM_FTM_INITIATOR_DYNACK		true
 
 #endif /* __MVM_CONSTANTS_H */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
new file mode 100644
index 000000000000..eb6f084a0f8a
--- /dev/null
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -0,0 +1,459 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2019 Intel Corporation
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
+ * Copyright (C) 2019 Intel Corporation
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
+#include <linux/etherdevice.h>
+#include <linux/math64.h>
+#include <net/cfg80211.h>
+#include "mvm.h"
+#include "iwl-io.h"
+#include "iwl-prph.h"
+#include "constants.h"
+
+struct iwl_mvm_loc_entry {
+	struct list_head list;
+	u8 addr[ETH_ALEN];
+	u8 lci_len, civic_len;
+	u8 buf[];
+};
+
+static void iwl_mvm_ftm_reset(struct iwl_mvm *mvm)
+{
+	struct iwl_mvm_loc_entry *e, *t;
+
+	mvm->ftm_initiator.req = NULL;
+	mvm->ftm_initiator.req_wdev = NULL;
+	memset(mvm->ftm_initiator.responses, 0,
+	       sizeof(mvm->ftm_initiator.responses));
+	list_for_each_entry_safe(e, t, &mvm->ftm_initiator.loc_list, list) {
+		list_del(&e->list);
+		kfree(e);
+	}
+}
+
+void iwl_mvm_ftm_restart(struct iwl_mvm *mvm)
+{
+	struct cfg80211_pmsr_result result = {
+		.status = NL80211_PMSR_STATUS_FAILURE,
+		.final = 1,
+		.host_time = ktime_get_boot_ns(),
+		.type = NL80211_PMSR_TYPE_FTM,
+	};
+	int i;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	if (!mvm->ftm_initiator.req)
+		return;
+
+	for (i = 0; i < mvm->ftm_initiator.req->n_peers; i++) {
+		memcpy(result.addr, mvm->ftm_initiator.req->peers[i].addr,
+		       ETH_ALEN);
+		result.ftm.burst_index = mvm->ftm_initiator.responses[i];
+
+		cfg80211_pmsr_report(mvm->ftm_initiator.req_wdev,
+				     mvm->ftm_initiator.req,
+				     &result, GFP_KERNEL);
+	}
+
+	cfg80211_pmsr_complete(mvm->ftm_initiator.req_wdev,
+			       mvm->ftm_initiator.req, GFP_KERNEL);
+	iwl_mvm_ftm_reset(mvm);
+}
+
+static int
+iwl_ftm_range_request_status_to_err(enum iwl_tof_range_request_status s)
+{
+	switch (s) {
+	case IWL_TOF_RANGE_REQUEST_STATUS_SUCCESS:
+		return 0;
+	case IWL_TOF_RANGE_REQUEST_STATUS_BUSY:
+		return -EBUSY;
+	default:
+		WARN_ON_ONCE(1);
+		return -EIO;
+	}
+}
+
+int iwl_mvm_ftm_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+		      struct cfg80211_pmsr_request *req)
+{
+	struct iwl_tof_range_req_cmd cmd = {
+		.request_id = req->cookie,
+		.req_timeout = DIV_ROUND_UP(req->timeout, 100),
+		.num_of_ap = req->n_peers,
+		/*
+		 * We treat it always as random, since if not we'll
+		 * have filled our local address there instead.
+		 */
+		.macaddr_random = 1,
+	};
+	struct iwl_host_cmd hcmd = {
+		.id = iwl_cmd_id(TOF_RANGE_REQ_CMD, LOCATION_GROUP, 0),
+		.data[0] = &cmd,
+		.len[0] = sizeof(cmd),
+		.dataflags[0] = IWL_HCMD_DFL_DUP,
+	};
+	u32 status = 0;
+	int err, i;
+
+	/* use maximum for "no timeout" or bigger than what we can do */
+	if (!req->timeout || req->timeout > 255 * 100)
+		cmd.req_timeout = 255;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	if (mvm->ftm_initiator.req)
+		return -EBUSY;
+
+	memcpy(cmd.macaddr_template, req->mac_addr, ETH_ALEN);
+	for (i = 0; i < ETH_ALEN; i++)
+		cmd.macaddr_mask[i] = ~req->mac_addr_mask[i];
+
+	for (i = 0; i < cmd.num_of_ap; i++) {
+		struct cfg80211_pmsr_request_peer *peer = &req->peers[i];
+		struct iwl_tof_range_req_ap_entry *cmd_target = &cmd.ap[i];
+		u32 freq = peer->chandef.chan->center_freq;
+
+		cmd_target->channel_num = ieee80211_frequency_to_channel(freq);
+		switch (peer->chandef.width) {
+		case NL80211_CHAN_WIDTH_20_NOHT:
+			cmd_target->bandwidth = IWL_TOF_BW_20_LEGACY;
+			break;
+		case NL80211_CHAN_WIDTH_20:
+			cmd_target->bandwidth = IWL_TOF_BW_20_HT;
+			break;
+		case NL80211_CHAN_WIDTH_40:
+			cmd_target->bandwidth = IWL_TOF_BW_40;
+			break;
+		case NL80211_CHAN_WIDTH_80:
+			cmd_target->bandwidth = IWL_TOF_BW_80;
+			break;
+		default:
+			IWL_ERR(mvm, "Unsupported BW in FTM request (%d)\n",
+				peer->chandef.width);
+			return -EINVAL;
+		}
+		cmd_target->ctrl_ch_position =
+			(peer->chandef.width > NL80211_CHAN_WIDTH_20) ?
+			iwl_mvm_get_ctrl_pos(&peer->chandef) : 0;
+
+		memcpy(cmd_target->bssid, peer->addr, ETH_ALEN);
+		cmd_target->measure_type = 0; /* regular two-sided FTM */
+		cmd_target->num_of_bursts = peer->ftm.num_bursts_exp;
+		cmd_target->burst_period =
+			cpu_to_le16(peer->ftm.burst_period);
+		cmd_target->samples_per_burst = peer->ftm.ftms_per_burst;
+		cmd_target->retries_per_sample = peer->ftm.ftmr_retries;
+		cmd_target->asap_mode = peer->ftm.asap;
+		cmd_target->enable_dyn_ack = IWL_MVM_FTM_INITIATOR_DYNACK;
+
+		if (peer->ftm.request_lci)
+			cmd_target->location_req |= IWL_TOF_LOC_LCI;
+		if (peer->ftm.request_civicloc)
+			cmd_target->location_req |= IWL_TOF_LOC_CIVIC;
+
+		cmd_target->algo_type = IWL_MVM_FTM_INITIATOR_ALGO;
+	}
+
+	if (vif->bss_conf.assoc)
+		memcpy(cmd.range_req_bssid, vif->bss_conf.bssid, ETH_ALEN);
+	else
+		eth_broadcast_addr(cmd.range_req_bssid);
+
+	err = iwl_mvm_send_cmd_status(mvm, &hcmd, &status);
+	if (!err && status) {
+		IWL_ERR(mvm, "FTM range request command failure, status: %u\n",
+			status);
+		err = iwl_ftm_range_request_status_to_err(status);
+	}
+
+	if (!err) {
+		mvm->ftm_initiator.req = req;
+		mvm->ftm_initiator.req_wdev = ieee80211_vif_to_wdev(vif);
+	}
+
+	return err;
+}
+
+void iwl_mvm_ftm_abort(struct iwl_mvm *mvm, struct cfg80211_pmsr_request *req)
+{
+	struct iwl_tof_range_abort_cmd cmd = {
+		.request_id = req->cookie,
+	};
+
+	lockdep_assert_held(&mvm->mutex);
+
+	if (req != mvm->ftm_initiator.req)
+		return;
+
+	if (iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(TOF_RANGE_ABORT_CMD,
+						 LOCATION_GROUP, 0),
+				 0, sizeof(cmd), &cmd))
+		IWL_ERR(mvm, "failed to abort FTM process\n");
+}
+
+static int iwl_mvm_ftm_find_peer(struct cfg80211_pmsr_request *req,
+				 const u8 *addr)
+{
+	int i;
+
+	for (i = 0; i < req->n_peers; i++) {
+		struct cfg80211_pmsr_request_peer *peer = &req->peers[i];
+
+		if (ether_addr_equal_unaligned(peer->addr, addr))
+			return i;
+	}
+
+	return -ENOENT;
+}
+
+static u64 iwl_mvm_ftm_get_host_time(struct iwl_mvm *mvm, __le32 fw_gp2_ts)
+{
+	u32 gp2_ts = le32_to_cpu(fw_gp2_ts);
+	u32 curr_gp2, diff;
+	u64 now_from_boot_ns;
+
+	iwl_mvm_get_sync_time(mvm, &curr_gp2, &now_from_boot_ns);
+
+	if (curr_gp2 >= gp2_ts)
+		diff = curr_gp2 - gp2_ts;
+	else
+		diff = curr_gp2 + (U32_MAX - gp2_ts + 1);
+
+	return now_from_boot_ns - (u64)diff * 1000;
+}
+
+static void iwl_mvm_ftm_get_lci_civic(struct iwl_mvm *mvm,
+				      struct cfg80211_pmsr_result *res)
+{
+	struct iwl_mvm_loc_entry *entry;
+
+	list_for_each_entry(entry, &mvm->ftm_initiator.loc_list, list) {
+		if (!ether_addr_equal_unaligned(res->addr, entry->addr))
+			continue;
+
+		if (entry->lci_len) {
+			res->ftm.lci_len = entry->lci_len;
+			res->ftm.lci = entry->buf;
+		}
+
+		if (entry->civic_len) {
+			res->ftm.civicloc_len = entry->civic_len;
+			res->ftm.civicloc = entry->buf + entry->lci_len;
+		}
+
+		/* we found the entry we needed */
+		break;
+	}
+}
+
+void iwl_mvm_ftm_range_resp(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_tof_range_rsp_ntfy *fw_resp = (void *)pkt->data;
+	int i;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	if (!mvm->ftm_initiator.req) {
+		IWL_ERR(mvm, "Got FTM response but have no request?\n");
+		return;
+	}
+
+	if (fw_resp->request_id != (u8)mvm->ftm_initiator.req->cookie) {
+		IWL_ERR(mvm, "Request ID mismatch, got %u, active %u\n",
+			fw_resp->request_id,
+			(u8)mvm->ftm_initiator.req->cookie);
+		return;
+	}
+
+	if (fw_resp->num_of_aps > mvm->ftm_initiator.req->n_peers) {
+		IWL_ERR(mvm, "FTM range response invalid\n");
+		return;
+	}
+
+	for (i = 0; i < fw_resp->num_of_aps && i < IWL_MVM_TOF_MAX_APS; i++) {
+		struct iwl_tof_range_rsp_ap_entry_ntfy *fw_ap = &fw_resp->ap[i];
+		struct cfg80211_pmsr_result result = {};
+		int peer_idx;
+
+		peer_idx = iwl_mvm_ftm_find_peer(mvm->ftm_initiator.req,
+						 fw_ap->bssid);
+		if (peer_idx < 0) {
+			IWL_WARN(mvm,
+				 "Unknown address (%pM, target #%d) in FTM response.\n",
+				 fw_ap->bssid, i);
+			continue;
+		}
+
+		switch (fw_ap->measure_status) {
+		case IWL_TOF_ENTRY_SUCCESS:
+			result.status = NL80211_PMSR_STATUS_SUCCESS;
+			break;
+		case IWL_TOF_ENTRY_TIMING_MEASURE_TIMEOUT:
+			result.status = NL80211_PMSR_STATUS_TIMEOUT;
+			break;
+		case IWL_TOF_ENTRY_NO_RESPONSE:
+			result.status = NL80211_PMSR_STATUS_FAILURE;
+			result.ftm.failure_reason =
+				NL80211_PMSR_FTM_FAILURE_NO_RESPONSE;
+			break;
+		case IWL_TOF_ENTRY_REQUEST_REJECTED:
+			result.status = NL80211_PMSR_STATUS_FAILURE;
+			result.ftm.failure_reason =
+				NL80211_PMSR_FTM_FAILURE_PEER_BUSY;
+			result.ftm.busy_retry_time = fw_ap->refusal_period;
+			break;
+		default:
+			result.status = NL80211_PMSR_STATUS_FAILURE;
+			result.ftm.failure_reason =
+				NL80211_PMSR_FTM_FAILURE_UNSPECIFIED;
+			break;
+		}
+		memcpy(result.addr, fw_ap->bssid, ETH_ALEN);
+		result.host_time = iwl_mvm_ftm_get_host_time(mvm,
+							     fw_ap->timestamp);
+		result.type = NL80211_PMSR_TYPE_FTM;
+		result.ftm.burst_index = mvm->ftm_initiator.responses[peer_idx];
+		mvm->ftm_initiator.responses[peer_idx]++;
+		/*
+		 * FIXME: the firmware needs to report this, we don't even know
+		 *        the number of bursts the responder picked (if we asked
+		 *        it to)
+		 */
+		result.final = 0;
+		result.ftm.rssi_avg = fw_ap->rssi;
+		result.ftm.rssi_avg_valid = 1;
+		result.ftm.rssi_spread = fw_ap->rssi_spread;
+		result.ftm.rssi_spread_valid = 1;
+		result.ftm.rtt_avg = (s32)le32_to_cpu(fw_ap->rtt);
+		result.ftm.rtt_avg_valid = 1;
+		result.ftm.rtt_variance = le32_to_cpu(fw_ap->rtt_variance);
+		result.ftm.rtt_variance_valid = 1;
+		result.ftm.rtt_spread = le32_to_cpu(fw_ap->rtt_spread);
+		result.ftm.rtt_spread_valid = 1;
+
+		iwl_mvm_ftm_get_lci_civic(mvm, &result);
+
+		cfg80211_pmsr_report(mvm->ftm_initiator.req_wdev,
+				     mvm->ftm_initiator.req,
+				     &result, GFP_KERNEL);
+	}
+
+	if (fw_resp->last_in_batch) {
+		cfg80211_pmsr_complete(mvm->ftm_initiator.req_wdev,
+				       mvm->ftm_initiator.req,
+				       GFP_KERNEL);
+		iwl_mvm_ftm_reset(mvm);
+	}
+}
+
+void iwl_mvm_ftm_lc_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	const struct ieee80211_mgmt *mgmt = (void *)pkt->data;
+	size_t len = iwl_rx_packet_payload_len(pkt);
+	struct iwl_mvm_loc_entry *entry;
+	const u8 *ies, *lci, *civic, *msr_ie;
+	size_t ies_len, lci_len = 0, civic_len = 0;
+	size_t baselen = IEEE80211_MIN_ACTION_SIZE +
+			 sizeof(mgmt->u.action.u.ftm);
+	static const u8 rprt_type_lci = IEEE80211_SPCT_MSR_RPRT_TYPE_LCI;
+	static const u8 rprt_type_civic = IEEE80211_SPCT_MSR_RPRT_TYPE_CIVIC;
+
+	if (len <= baselen)
+		return;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	ies = mgmt->u.action.u.ftm.variable;
+	ies_len = len - baselen;
+
+	msr_ie = cfg80211_find_ie_match(WLAN_EID_MEASURE_REPORT, ies, ies_len,
+					&rprt_type_lci, 1, 4);
+	if (msr_ie) {
+		lci = msr_ie + 2;
+		lci_len = msr_ie[1];
+	}
+
+	msr_ie = cfg80211_find_ie_match(WLAN_EID_MEASURE_REPORT, ies, ies_len,
+					&rprt_type_civic, 1, 4);
+	if (msr_ie) {
+		civic = msr_ie + 2;
+		civic_len = msr_ie[1];
+	}
+
+	entry = kmalloc(sizeof(*entry) + lci_len + civic_len, GFP_KERNEL);
+	if (!entry)
+		return;
+
+	memcpy(entry->addr, mgmt->bssid, ETH_ALEN);
+
+	entry->lci_len = lci_len;
+	if (lci_len)
+		memcpy(entry->buf, lci, lci_len);
+
+	entry->civic_len = civic_len;
+	if (civic_len)
+		memcpy(entry->buf + lci_len, civic, civic_len);
+
+	list_add_tail(&entry->list, &mvm->ftm_initiator.loc_list);
+}
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index cba1a0fe33ca..9377fca39edf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -184,6 +184,29 @@ static const struct iwl_fw_bcast_filter iwl_mvm_default_bcast_filters[] = {
 };
 #endif
 
+static const struct cfg80211_pmsr_capabilities iwl_mvm_pmsr_capa = {
+	.max_peers = IWL_MVM_TOF_MAX_APS,
+	.report_ap_tsf = 1,
+	.randomize_mac_addr = 1,
+
+	.ftm = {
+		.supported = 1,
+		.asap = 1,
+		.non_asap = 1,
+		.request_lci = 1,
+		.request_civicloc = 1,
+		.max_bursts_exponent = -1, /* all supported */
+		.max_ftms_per_burst = 0, /* no limits */
+		.bandwidths = BIT(NL80211_CHAN_WIDTH_20_NOHT) |
+			      BIT(NL80211_CHAN_WIDTH_20) |
+			      BIT(NL80211_CHAN_WIDTH_40) |
+			      BIT(NL80211_CHAN_WIDTH_80),
+		.preambles = BIT(NL80211_PREAMBLE_LEGACY) |
+			     BIT(NL80211_PREAMBLE_HT) |
+			     BIT(NL80211_PREAMBLE_VHT),
+	},
+};
+
 void iwl_mvm_ref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type)
 {
 	if (!iwl_mvm_is_d0i3_supported(mvm))
@@ -549,9 +572,11 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	}
 
 	if (fw_has_capa(&mvm->fw->ucode_capa,
-			IWL_UCODE_TLV_CAPA_FTM_CALIBRATED))
+			IWL_UCODE_TLV_CAPA_FTM_CALIBRATED)) {
 		wiphy_ext_feature_set(hw->wiphy,
 				      NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER);
+		hw->wiphy->pmsr_capa = &iwl_mvm_pmsr_capa;
+	}
 
 	ieee80211_hw_set(hw, SINGLE_SCAN_ON_ALL_BANDS);
 	hw->wiphy->features |=
@@ -1186,6 +1211,8 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 	iwl_mvm_cleanup_roc_te(mvm);
 	ieee80211_remain_on_channel_expired(mvm->hw);
 
+	iwl_mvm_ftm_restart(mvm);
+
 	/*
 	 * cleanup all interfaces, even inactive ones, as some might have
 	 * gone down during the HW restart
@@ -4895,6 +4922,31 @@ iwl_mvm_mac_get_ftm_responder_stats(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static int iwl_mvm_start_pmsr(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      struct cfg80211_pmsr_request *request)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	int ret;
+
+	mutex_lock(&mvm->mutex);
+	ret = iwl_mvm_ftm_start(mvm, vif, request);
+	mutex_unlock(&mvm->mutex);
+
+	return ret;
+}
+
+static void iwl_mvm_abort_pmsr(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       struct cfg80211_pmsr_request *request)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+
+	mutex_lock(&mvm->mutex);
+	iwl_mvm_ftm_abort(mvm, request);
+	mutex_unlock(&mvm->mutex);
+}
+
 static bool iwl_mvm_can_hw_csum(struct sk_buff *skb)
 {
 	u8 protocol = ip_hdr(skb)->protocol;
@@ -4998,6 +5050,8 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.get_survey = iwl_mvm_mac_get_survey,
 	.sta_statistics = iwl_mvm_mac_sta_statistics,
 	.get_ftm_responder_stats = iwl_mvm_mac_get_ftm_responder_stats,
+	.start_pmsr = iwl_mvm_start_pmsr,
+	.abort_pmsr = iwl_mvm_abort_pmsr,
 
 	.can_aggregate_in_amsdu = iwl_mvm_mac_can_aggregate,
 #ifdef CONFIG_IWLWIFI_DEBUGFS
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 2bd330a093fb..e9873fc7bd2b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1151,6 +1151,12 @@ struct iwl_mvm {
 	struct ieee80211_cipher_scheme cs[IWL_UCODE_MAX_CS];
 
 	struct cfg80211_ftm_responder_stats ftm_resp_stats;
+	struct {
+		struct cfg80211_pmsr_request *req;
+		struct wireless_dev *req_wdev;
+		struct list_head loc_list;
+		int responses[IWL_MVM_TOF_MAX_APS];
+	} ftm_initiator;
 
 	struct ieee80211_vif *nan_vif;
 #define IWL_MAX_BAID	32
@@ -2069,6 +2075,16 @@ void iwl_mvm_ftm_restart_responder(struct iwl_mvm *mvm,
 void iwl_mvm_ftm_responder_stats(struct iwl_mvm *mvm,
 				 struct iwl_rx_cmd_buffer *rxb);
 
+/* FTM initiator */
+void iwl_mvm_ftm_restart(struct iwl_mvm *mvm);
+void iwl_mvm_ftm_range_resp(struct iwl_mvm *mvm,
+			    struct iwl_rx_cmd_buffer *rxb);
+void iwl_mvm_ftm_lc_notif(struct iwl_mvm *mvm,
+			  struct iwl_rx_cmd_buffer *rxb);
+int iwl_mvm_ftm_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+		      struct cfg80211_pmsr_request *request);
+void iwl_mvm_ftm_abort(struct iwl_mvm *mvm, struct cfg80211_pmsr_request *req);
+
 /* TDLS */
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index d5644d252fe0..0c276124bf0f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -302,6 +302,12 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 		   RX_HANDLER_SYNC),
 	RX_HANDLER_GRP(LOCATION_GROUP, TOF_RESPONDER_STATS,
 		       iwl_mvm_ftm_responder_stats, RX_HANDLER_ASYNC_LOCKED),
+
+	RX_HANDLER_GRP(LOCATION_GROUP, TOF_RANGE_RESPONSE_NOTIF,
+		       iwl_mvm_ftm_range_resp, RX_HANDLER_ASYNC_LOCKED),
+	RX_HANDLER_GRP(LOCATION_GROUP, TOF_LC_NOTIF,
+		       iwl_mvm_ftm_lc_notif, RX_HANDLER_ASYNC_LOCKED),
+
 	RX_HANDLER_GRP(DEBUG_GROUP, MFU_ASSERT_DUMP_NTF,
 		       iwl_mvm_mfu_assert_dump_notif, RX_HANDLER_SYNC),
 	RX_HANDLER_GRP(PROT_OFFLOAD_GROUP, STORED_BEACON_NTF,
@@ -693,6 +699,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	INIT_LIST_HEAD(&mvm->aux_roc_te_list);
 	INIT_LIST_HEAD(&mvm->async_handlers_list);
 	spin_lock_init(&mvm->time_event_lock);
+	INIT_LIST_HEAD(&mvm->ftm_initiator.loc_list);
 
 	INIT_WORK(&mvm->async_handlers_wk, iwl_mvm_async_handlers_wk);
 	INIT_WORK(&mvm->roc_done_wk, iwl_mvm_roc_done_wk);
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 3b04e72315e1..f1f66e675ca1 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2118,6 +2118,8 @@ ieee80211_he_oper_size(const u8 *he_oper_ie)
 #define IEEE80211_SPCT_MSR_RPRT_TYPE_BASIC	0
 #define IEEE80211_SPCT_MSR_RPRT_TYPE_CCA	1
 #define IEEE80211_SPCT_MSR_RPRT_TYPE_RPI	2
+#define IEEE80211_SPCT_MSR_RPRT_TYPE_LCI	8
+#define IEEE80211_SPCT_MSR_RPRT_TYPE_CIVIC	11
 
 /* 802.11g ERP information element */
 #define WLAN_ERP_NON_ERP_PRESENT (1<<0)
-- 
2.20.1

