Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:58404 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213AbaCROqc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:32 -0400
Received: by mail-ee0-f42.google.com with SMTP id d17so5505768eek.29
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:30 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/35] iwlwifi: mvm: configure seq_num to D0i3
Date: Tue, 18 Mar 2014 16:45:28 +0200
Message-Id: <1395153939-23897-24-git-send-email-egrumbach@gmail.com> (sfid-20140318_154716_341306_1EF32CC8)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Configure the QoS counters when entering D0i3.

The fw might use them later when performing protocol
offloading (we'll update the the counters back on
d0i3 exit in a following patch).

Non-QoS counter is handled internally in the fw, so
no need to configure it.

Also, add support for a new version of WOWLAN_CONFIG_CMD

Signed-off-by: Eliad Peller <eliad@wizery.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h         |   8 +
 drivers/net/wireless/iwlwifi/mvm/Makefile     |   2 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c         | 189 ++++-------------------
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h  |   8 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h        |   5 +-
 drivers/net/wireless/iwlwifi/mvm/offloading.c | 214 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/ops.c        |  41 ++++-
 7 files changed, 300 insertions(+), 167 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/offloading.c

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 18f867c..d14f193 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -126,6 +126,14 @@ enum iwl_ucode_tlv_flag {
 };
 
 /**
+ * enum iwl_ucode_tlv_api - ucode api
+ * @IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID: wowlan config includes tid field.
+ */
+enum iwl_ucode_tlv_api {
+	IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID	= BIT(0),
+};
+
+/**
  * enum iwl_ucode_tlv_capa - ucode capabilities
  * @IWL_UCODE_TLV_CAPA_D0I3_SUPPORT: supports D0i3
  */
diff --git a/drivers/net/wireless/iwlwifi/mvm/Makefile b/drivers/net/wireless/iwlwifi/mvm/Makefile
index 9798aa5..ccdd3b7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/Makefile
+++ b/drivers/net/wireless/iwlwifi/mvm/Makefile
@@ -3,7 +3,7 @@ iwlmvm-y += fw.o mac80211.o nvm.o ops.o phy-ctxt.o mac-ctxt.o
 iwlmvm-y += utils.o rx.o tx.o binding.o quota.o sta.o sf.o
 iwlmvm-y += scan.o time-event.o rs.o
 iwlmvm-y += power.o coex.o
-iwlmvm-y += led.o tt.o
+iwlmvm-y += led.o tt.o offloading.o
 iwlmvm-$(CONFIG_IWLWIFI_DEBUGFS) += debugfs.o debugfs-vif.o
 iwlmvm-$(CONFIG_PM_SLEEP) += d3.o
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index a087564..02fb950 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -376,139 +376,6 @@ static int iwl_mvm_send_patterns(struct iwl_mvm *mvm,
 	return err;
 }
 
-static int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm,
-				      struct ieee80211_vif *vif)
-{
-	union {
-		struct iwl_proto_offload_cmd_v1 v1;
-		struct iwl_proto_offload_cmd_v2 v2;
-		struct iwl_proto_offload_cmd_v3_small v3s;
-		struct iwl_proto_offload_cmd_v3_large v3l;
-	} cmd = {};
-	struct iwl_host_cmd hcmd = {
-		.id = PROT_OFFLOAD_CONFIG_CMD,
-		.flags = CMD_SYNC,
-		.data[0] = &cmd,
-		.dataflags[0] = IWL_HCMD_DFL_DUP,
-	};
-	struct iwl_proto_offload_cmd_common *common;
-	u32 enabled = 0, size;
-	u32 capa_flags = mvm->fw->ucode_capa.flags;
-#if IS_ENABLED(CONFIG_IPV6)
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	int i;
-
-	if (capa_flags & IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL ||
-	    capa_flags & IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_LARGE) {
-		struct iwl_ns_config *nsc;
-		struct iwl_targ_addr *addrs;
-		int n_nsc, n_addrs;
-		int c;
-
-		if (capa_flags & IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL) {
-			nsc = cmd.v3s.ns_config;
-			n_nsc = IWL_PROTO_OFFLOAD_NUM_NS_CONFIG_V3S;
-			addrs = cmd.v3s.targ_addrs;
-			n_addrs = IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_V3S;
-		} else {
-			nsc = cmd.v3l.ns_config;
-			n_nsc = IWL_PROTO_OFFLOAD_NUM_NS_CONFIG_V3L;
-			addrs = cmd.v3l.targ_addrs;
-			n_addrs = IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_V3L;
-		}
-
-		if (mvmvif->num_target_ipv6_addrs)
-			enabled |= IWL_D3_PROTO_OFFLOAD_NS;
-
-		/*
-		 * For each address we have (and that will fit) fill a target
-		 * address struct and combine for NS offload structs with the
-		 * solicited node addresses.
-		 */
-		for (i = 0, c = 0;
-		     i < mvmvif->num_target_ipv6_addrs &&
-		     i < n_addrs && c < n_nsc; i++) {
-			struct in6_addr solicited_addr;
-			int j;
-
-			addrconf_addr_solict_mult(&mvmvif->target_ipv6_addrs[i],
-						  &solicited_addr);
-			for (j = 0; j < c; j++)
-				if (ipv6_addr_cmp(&nsc[j].dest_ipv6_addr,
-						  &solicited_addr) == 0)
-					break;
-			if (j == c)
-				c++;
-			addrs[i].addr = mvmvif->target_ipv6_addrs[i];
-			addrs[i].config_num = cpu_to_le32(j);
-			nsc[j].dest_ipv6_addr = solicited_addr;
-			memcpy(nsc[j].target_mac_addr, vif->addr, ETH_ALEN);
-		}
-
-		if (capa_flags & IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL)
-			cmd.v3s.num_valid_ipv6_addrs = cpu_to_le32(i);
-		else
-			cmd.v3l.num_valid_ipv6_addrs = cpu_to_le32(i);
-	} else if (capa_flags & IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS) {
-		if (mvmvif->num_target_ipv6_addrs) {
-			enabled |= IWL_D3_PROTO_OFFLOAD_NS;
-			memcpy(cmd.v2.ndp_mac_addr, vif->addr, ETH_ALEN);
-		}
-
-		BUILD_BUG_ON(sizeof(cmd.v2.target_ipv6_addr[0]) !=
-			     sizeof(mvmvif->target_ipv6_addrs[0]));
-
-		for (i = 0; i < min(mvmvif->num_target_ipv6_addrs,
-				    IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_V2); i++)
-			memcpy(cmd.v2.target_ipv6_addr[i],
-			       &mvmvif->target_ipv6_addrs[i],
-			       sizeof(cmd.v2.target_ipv6_addr[i]));
-	} else {
-		if (mvmvif->num_target_ipv6_addrs) {
-			enabled |= IWL_D3_PROTO_OFFLOAD_NS;
-			memcpy(cmd.v1.ndp_mac_addr, vif->addr, ETH_ALEN);
-		}
-
-		BUILD_BUG_ON(sizeof(cmd.v1.target_ipv6_addr[0]) !=
-			     sizeof(mvmvif->target_ipv6_addrs[0]));
-
-		for (i = 0; i < min(mvmvif->num_target_ipv6_addrs,
-				    IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_V1); i++)
-			memcpy(cmd.v1.target_ipv6_addr[i],
-			       &mvmvif->target_ipv6_addrs[i],
-			       sizeof(cmd.v1.target_ipv6_addr[i]));
-	}
-#endif
-
-	if (capa_flags & IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL) {
-		common = &cmd.v3s.common;
-		size = sizeof(cmd.v3s);
-	} else if (capa_flags & IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_LARGE) {
-		common = &cmd.v3l.common;
-		size = sizeof(cmd.v3l);
-	} else if (capa_flags & IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS) {
-		common = &cmd.v2.common;
-		size = sizeof(cmd.v2);
-	} else {
-		common = &cmd.v1.common;
-		size = sizeof(cmd.v1);
-	}
-
-	if (vif->bss_conf.arp_addr_cnt) {
-		enabled |= IWL_D3_PROTO_OFFLOAD_ARP;
-		common->host_ipv4_addr = vif->bss_conf.arp_addr_list[0];
-		memcpy(common->arp_mac_addr, vif->addr, ETH_ALEN);
-	}
-
-	if (!enabled)
-		return 0;
-
-	common->enabled = cpu_to_le32(enabled);
-
-	hcmd.len[0] = size;
-	return iwl_mvm_send_cmd(mvm, &hcmd);
-}
-
 enum iwl_mvm_tcp_packet_type {
 	MVM_TCP_TX_SYN,
 	MVM_TCP_RX_SYNACK,
@@ -927,6 +794,20 @@ void iwl_mvm_set_last_nonqos_seq(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		IWL_ERR(mvm, "failed to set non-QoS seqno\n");
 }
 
+static int
+iwl_mvm_send_wowlan_config_cmd(struct iwl_mvm *mvm,
+			       const struct iwl_wowlan_config_cmd_v3 *cmd)
+{
+	/* start only with the v2 part of the command */
+	u16 cmd_len = sizeof(cmd->common);
+
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID)
+		cmd_len = sizeof(*cmd);
+
+	return iwl_mvm_send_cmd_pdu(mvm, WOWLAN_CONFIGURATION, CMD_SYNC,
+				    cmd_len, cmd);
+}
+
 static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 			     struct cfg80211_wowlan *wowlan,
 			     bool test)
@@ -939,7 +820,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 	struct iwl_mvm_vif *mvmvif;
 	struct ieee80211_sta *ap_sta;
 	struct iwl_mvm_sta *mvm_ap_sta;
-	struct iwl_wowlan_config_cmd wowlan_config_cmd = {};
+	struct iwl_wowlan_config_cmd_v3 wowlan_config_cmd = {};
 	struct iwl_wowlan_kek_kck_material_cmd kek_kck_cmd = {};
 	struct iwl_wowlan_tkip_params_cmd tkip_cmd = {};
 	struct iwl_d3_manager_config d3_cfg_cmd_data = {
@@ -961,7 +842,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 		.tkip = &tkip_cmd,
 		.use_tkip = false,
 	};
-	int ret, i;
+	int ret;
 	int len __maybe_unused;
 
 	if (!wowlan) {
@@ -1002,49 +883,41 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 
 	mvm_ap_sta = (struct iwl_mvm_sta *)ap_sta->drv_priv;
 
-	/* TODO: wowlan_config_cmd.wowlan_ba_teardown_tids */
+	/* TODO: wowlan_config_cmd.common.wowlan_ba_teardown_tids */
 
-	wowlan_config_cmd.is_11n_connection = ap_sta->ht_cap.ht_supported;
+	wowlan_config_cmd.common.is_11n_connection =
+					ap_sta->ht_cap.ht_supported;
 
 	/* Query the last used seqno and set it */
 	ret = iwl_mvm_get_last_nonqos_seq(mvm, vif);
 	if (ret < 0)
 		goto out_noreset;
-	wowlan_config_cmd.non_qos_seq = cpu_to_le16(ret);
+	wowlan_config_cmd.common.non_qos_seq = cpu_to_le16(ret);
 
-	/*
-	 * For QoS counters, we store the one to use next, so subtract 0x10
-	 * since the uCode will add 0x10 *before* using the value while we
-	 * increment after using the value (i.e. store the next value to use).
-	 */
-	for (i = 0; i < IWL_MAX_TID_COUNT; i++) {
-		u16 seq = mvm_ap_sta->tid_data[i].seq_number;
-		seq -= 0x10;
-		wowlan_config_cmd.qos_seq[i] = cpu_to_le16(seq);
-	}
+	iwl_mvm_set_wowlan_qos_seq(mvm_ap_sta, &wowlan_config_cmd.common);
 
 	if (wowlan->disconnect)
-		wowlan_config_cmd.wakeup_filter |=
+		wowlan_config_cmd.common.wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_BEACON_MISS |
 				    IWL_WOWLAN_WAKEUP_LINK_CHANGE);
 	if (wowlan->magic_pkt)
-		wowlan_config_cmd.wakeup_filter |=
+		wowlan_config_cmd.common.wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_MAGIC_PACKET);
 	if (wowlan->gtk_rekey_failure)
-		wowlan_config_cmd.wakeup_filter |=
+		wowlan_config_cmd.common.wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_GTK_REKEY_FAIL);
 	if (wowlan->eap_identity_req)
-		wowlan_config_cmd.wakeup_filter |=
+		wowlan_config_cmd.common.wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_EAP_IDENT_REQ);
 	if (wowlan->four_way_handshake)
-		wowlan_config_cmd.wakeup_filter |=
+		wowlan_config_cmd.common.wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_4WAY_HANDSHAKE);
 	if (wowlan->n_patterns)
-		wowlan_config_cmd.wakeup_filter |=
+		wowlan_config_cmd.common.wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_PATTERN_MATCH);
 
 	if (wowlan->rfkill_release)
-		wowlan_config_cmd.wakeup_filter |=
+		wowlan_config_cmd.common.wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_RF_KILL_DEASSERT);
 
 	if (wowlan->tcp) {
@@ -1052,7 +925,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 		 * Set the "link change" (really "link lost") flag as well
 		 * since that implies losing the TCP connection.
 		 */
-		wowlan_config_cmd.wakeup_filter |=
+		wowlan_config_cmd.common.wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_REMOTE_LINK_LOSS |
 				    IWL_WOWLAN_WAKEUP_REMOTE_SIGNATURE_TABLE |
 				    IWL_WOWLAN_WAKEUP_REMOTE_WAKEUP_PACKET |
@@ -1150,9 +1023,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 		}
 	}
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, WOWLAN_CONFIGURATION,
-				   CMD_SYNC, sizeof(wowlan_config_cmd),
-				   &wowlan_config_cmd);
+	ret = iwl_mvm_send_wowlan_config_cmd(mvm, &wowlan_config_cmd);
 	if (ret)
 		goto out;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
index 5219976..10fcc1a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
@@ -239,7 +239,7 @@ enum iwl_wowlan_wakeup_filters {
 	IWL_WOWLAN_WAKEUP_BCN_FILTERING			= BIT(16),
 }; /* WOWLAN_WAKEUP_FILTER_API_E_VER_4 */
 
-struct iwl_wowlan_config_cmd {
+struct iwl_wowlan_config_cmd_v2 {
 	__le32 wakeup_filter;
 	__le16 non_qos_seq;
 	__le16 qos_seq[8];
@@ -247,6 +247,12 @@ struct iwl_wowlan_config_cmd {
 	u8 is_11n_connection;
 } __packed; /* WOWLAN_CONFIG_API_S_VER_2 */
 
+struct iwl_wowlan_config_cmd_v3 {
+	struct iwl_wowlan_config_cmd_v2 common;
+	u8 offloading_tid;
+	u8 reserved[3];
+} __packed; /* WOWLAN_CONFIG_API_S_VER_3 */
+
 /*
  * WOWLAN_TSC_RSC_PARAMS
  */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index f77be76..095bc26 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -317,13 +317,13 @@ struct iwl_mvm_vif {
 
 	bool seqno_valid;
 	u16 seqno;
+#endif
 
 #if IS_ENABLED(CONFIG_IPV6)
 	/* IPv6 addresses for WoWLAN */
 	struct in6_addr target_ipv6_addrs[IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_MAX];
 	int num_target_ipv6_addrs;
 #endif
-#endif
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	struct iwl_mvm *mvm;
@@ -896,6 +896,9 @@ iwl_mvm_set_last_nonqos_seq(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
 }
 #endif
+void iwl_mvm_set_wowlan_qos_seq(struct iwl_mvm_sta *mvm_ap_sta,
+				struct iwl_wowlan_config_cmd_v2 *cmd);
+int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 
 /* D0i3 */
 void iwl_mvm_ref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type);
diff --git a/drivers/net/wireless/iwlwifi/mvm/offloading.c b/drivers/net/wireless/iwlwifi/mvm/offloading.c
new file mode 100644
index 0000000..9ec5a59
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/mvm/offloading.c
@@ -0,0 +1,214 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
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
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
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
+#include <net/ipv6.h>
+#include <net/addrconf.h>
+#include "mvm.h"
+
+void iwl_mvm_set_wowlan_qos_seq(struct iwl_mvm_sta *mvm_ap_sta,
+				struct iwl_wowlan_config_cmd_v2 *cmd)
+{
+	int i;
+
+	/*
+	 * For QoS counters, we store the one to use next, so subtract 0x10
+	 * since the uCode will add 0x10 *before* using the value while we
+	 * increment after using the value (i.e. store the next value to use).
+	 */
+	for (i = 0; i < IWL_MAX_TID_COUNT; i++) {
+		u16 seq = mvm_ap_sta->tid_data[i].seq_number;
+		seq -= 0x10;
+		cmd->qos_seq[i] = cpu_to_le16(seq);
+	}
+}
+
+int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+{
+	union {
+		struct iwl_proto_offload_cmd_v1 v1;
+		struct iwl_proto_offload_cmd_v2 v2;
+		struct iwl_proto_offload_cmd_v3_small v3s;
+		struct iwl_proto_offload_cmd_v3_large v3l;
+	} cmd = {};
+	struct iwl_host_cmd hcmd = {
+		.id = PROT_OFFLOAD_CONFIG_CMD,
+		.flags = CMD_SYNC,
+		.data[0] = &cmd,
+		.dataflags[0] = IWL_HCMD_DFL_DUP,
+	};
+	struct iwl_proto_offload_cmd_common *common;
+	u32 enabled = 0, size;
+	u32 capa_flags = mvm->fw->ucode_capa.flags;
+#if IS_ENABLED(CONFIG_IPV6)
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	int i;
+
+	if (capa_flags & IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL ||
+	    capa_flags & IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_LARGE) {
+		struct iwl_ns_config *nsc;
+		struct iwl_targ_addr *addrs;
+		int n_nsc, n_addrs;
+		int c;
+
+		if (capa_flags & IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL) {
+			nsc = cmd.v3s.ns_config;
+			n_nsc = IWL_PROTO_OFFLOAD_NUM_NS_CONFIG_V3S;
+			addrs = cmd.v3s.targ_addrs;
+			n_addrs = IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_V3S;
+		} else {
+			nsc = cmd.v3l.ns_config;
+			n_nsc = IWL_PROTO_OFFLOAD_NUM_NS_CONFIG_V3L;
+			addrs = cmd.v3l.targ_addrs;
+			n_addrs = IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_V3L;
+		}
+
+		if (mvmvif->num_target_ipv6_addrs)
+			enabled |= IWL_D3_PROTO_OFFLOAD_NS;
+
+		/*
+		 * For each address we have (and that will fit) fill a target
+		 * address struct and combine for NS offload structs with the
+		 * solicited node addresses.
+		 */
+		for (i = 0, c = 0;
+		     i < mvmvif->num_target_ipv6_addrs &&
+		     i < n_addrs && c < n_nsc; i++) {
+			struct in6_addr solicited_addr;
+			int j;
+
+			addrconf_addr_solict_mult(&mvmvif->target_ipv6_addrs[i],
+						  &solicited_addr);
+			for (j = 0; j < c; j++)
+				if (ipv6_addr_cmp(&nsc[j].dest_ipv6_addr,
+						  &solicited_addr) == 0)
+					break;
+			if (j == c)
+				c++;
+			addrs[i].addr = mvmvif->target_ipv6_addrs[i];
+			addrs[i].config_num = cpu_to_le32(j);
+			nsc[j].dest_ipv6_addr = solicited_addr;
+			memcpy(nsc[j].target_mac_addr, vif->addr, ETH_ALEN);
+		}
+
+		if (capa_flags & IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL)
+			cmd.v3s.num_valid_ipv6_addrs = cpu_to_le32(i);
+		else
+			cmd.v3l.num_valid_ipv6_addrs = cpu_to_le32(i);
+	} else if (capa_flags & IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS) {
+		if (mvmvif->num_target_ipv6_addrs) {
+			enabled |= IWL_D3_PROTO_OFFLOAD_NS;
+			memcpy(cmd.v2.ndp_mac_addr, vif->addr, ETH_ALEN);
+		}
+
+		BUILD_BUG_ON(sizeof(cmd.v2.target_ipv6_addr[0]) !=
+			     sizeof(mvmvif->target_ipv6_addrs[0]));
+
+		for (i = 0; i < min(mvmvif->num_target_ipv6_addrs,
+				    IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_V2); i++)
+			memcpy(cmd.v2.target_ipv6_addr[i],
+			       &mvmvif->target_ipv6_addrs[i],
+			       sizeof(cmd.v2.target_ipv6_addr[i]));
+	} else {
+		if (mvmvif->num_target_ipv6_addrs) {
+			enabled |= IWL_D3_PROTO_OFFLOAD_NS;
+			memcpy(cmd.v1.ndp_mac_addr, vif->addr, ETH_ALEN);
+		}
+
+		BUILD_BUG_ON(sizeof(cmd.v1.target_ipv6_addr[0]) !=
+			     sizeof(mvmvif->target_ipv6_addrs[0]));
+
+		for (i = 0; i < min(mvmvif->num_target_ipv6_addrs,
+				    IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_V1); i++)
+			memcpy(cmd.v1.target_ipv6_addr[i],
+			       &mvmvif->target_ipv6_addrs[i],
+			       sizeof(cmd.v1.target_ipv6_addr[i]));
+	}
+#endif
+
+	if (capa_flags & IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL) {
+		common = &cmd.v3s.common;
+		size = sizeof(cmd.v3s);
+	} else if (capa_flags & IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_LARGE) {
+		common = &cmd.v3l.common;
+		size = sizeof(cmd.v3l);
+	} else if (capa_flags & IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS) {
+		common = &cmd.v2.common;
+		size = sizeof(cmd.v2);
+	} else {
+		common = &cmd.v1.common;
+		size = sizeof(cmd.v1);
+	}
+
+	if (vif->bss_conf.arp_addr_cnt) {
+		enabled |= IWL_D3_PROTO_OFFLOAD_ARP;
+		common->host_ipv4_addr = vif->bss_conf.arp_addr_list[0];
+		memcpy(common->arp_mac_addr, vif->addr, ETH_ALEN);
+	}
+
+	if (!enabled)
+		return 0;
+
+	common->enabled = cpu_to_le32(enabled);
+
+	hcmd.len[0] = size;
+	return iwl_mvm_send_cmd(mvm, &hcmd);
+}
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 75fbc40..87c32e8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -850,6 +850,33 @@ static void iwl_mvm_enter_d0i3_iterator(void *_data, u8 *mac,
 	data->vif_count++;
 }
 
+static void iwl_mvm_set_wowlan_data(struct iwl_mvm *mvm,
+				    struct iwl_wowlan_config_cmd_v3 *cmd,
+				    struct iwl_d0i3_iter_data *iter_data)
+{
+	struct ieee80211_sta *ap_sta;
+	struct iwl_mvm_sta *mvm_ap_sta;
+
+	if (iter_data->ap_sta_id == IWL_MVM_STATION_COUNT)
+		return;
+
+	rcu_read_lock();
+
+	ap_sta = rcu_dereference(mvm->fw_id_to_mac_id[iter_data->ap_sta_id]);
+	if (IS_ERR_OR_NULL(ap_sta))
+		goto out;
+
+	mvm_ap_sta = iwl_mvm_sta_from_mac80211(ap_sta);
+	cmd->common.is_11n_connection = ap_sta->ht_cap.ht_supported;
+
+	/*
+	 * The d0i3 uCode takes care of the nonqos counters,
+	 * so configure only the qos seq ones.
+	 */
+	iwl_mvm_set_wowlan_qos_seq(mvm_ap_sta, &cmd->common);
+out:
+	rcu_read_unlock();
+}
 static int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 {
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
@@ -858,11 +885,14 @@ static int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 	struct iwl_d0i3_iter_data d0i3_iter_data = {
 		.mvm = mvm,
 	};
-	struct iwl_wowlan_config_cmd wowlan_config_cmd = {
-		.wakeup_filter = cpu_to_le32(IWL_WOWLAN_WAKEUP_RX_FRAME |
-					     IWL_WOWLAN_WAKEUP_BEACON_MISS |
-					     IWL_WOWLAN_WAKEUP_LINK_CHANGE |
-					     IWL_WOWLAN_WAKEUP_BCN_FILTERING),
+	struct iwl_wowlan_config_cmd_v3 wowlan_config_cmd = {
+		.common = {
+			.wakeup_filter =
+				cpu_to_le32(IWL_WOWLAN_WAKEUP_RX_FRAME |
+					    IWL_WOWLAN_WAKEUP_BEACON_MISS |
+					    IWL_WOWLAN_WAKEUP_LINK_CHANGE |
+					    IWL_WOWLAN_WAKEUP_BCN_FILTERING),
+		},
 	};
 	struct iwl_d3_manager_config d3_cfg_cmd = {
 		.min_sleep_time = cpu_to_le32(1000),
@@ -881,6 +911,7 @@ static int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 		mvm->d0i3_ap_sta_id = IWL_MVM_STATION_COUNT;
 	}
 
+	iwl_mvm_set_wowlan_data(mvm, &wowlan_config_cmd, &d0i3_iter_data);
 	ret = iwl_mvm_send_cmd_pdu(mvm, WOWLAN_CONFIGURATION, flags,
 				   sizeof(wowlan_config_cmd),
 				   &wowlan_config_cmd);
-- 
1.8.3.2

