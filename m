Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58144 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758081Ab3GZI3x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:29:53 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 17/30] iwlwifi: mvm: support six IPv6 addresses in D3
Date: Fri, 26 Jul 2013 10:28:34 +0200
Message-Id: <1374827327-3464-18-git-send-email-johannes@sipsolutions.net> (sfid-20130726_103018_204574_B5B2BBF7)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Newer firmware supports offloading more IPv6 addresses for NDP,
adjust the code to send the correct command depending on the
firmware capability.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h        |  3 ++
 drivers/net/wireless/iwlwifi/mvm/d3.c        | 66 +++++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h | 52 +++++++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/mvm.h       |  2 +-
 4 files changed, 94 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 46dc38a..b766ee9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -76,6 +76,8 @@
  * @IWL_UCODE_TLV_FLAGS_DW_BC_TABLE: The SCD byte count table is in DWORDS
  * @IWL_UCODE_TLV_FLAGS_UAPSD: This uCode image supports uAPSD
  * @IWL_UCODE_TLV_FLAGS_RX_ENERGY_API: supports rx signal strength api
+ * @IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS: D3 image supports up to six
+ *	(rather than two) IPv6 addresses
  */
 enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_PAN			= BIT(0),
@@ -85,6 +87,7 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_DW_BC_TABLE		= BIT(4),
 	IWL_UCODE_TLV_FLAGS_UAPSD		= BIT(6),
 	IWL_UCODE_TLV_FLAGS_RX_ENERGY_API	= BIT(8),
+	IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS	= BIT(10),
 };
 
 /* The default calibrate table size if not specified by firmware file */
diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 7e5e5c2..ebf7f94 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -105,7 +105,7 @@ void iwl_mvm_ipv6_addr_change(struct ieee80211_hw *hw,
 	list_for_each_entry(ifa, &idev->addr_list, if_list) {
 		mvmvif->target_ipv6_addrs[idx] = ifa->addr;
 		idx++;
-		if (idx >= IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS)
+		if (idx >= IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_MAX)
 			break;
 	}
 	read_unlock_bh(&idev->lock);
@@ -373,36 +373,68 @@ static int iwl_mvm_send_patterns(struct iwl_mvm *mvm,
 static int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm,
 				      struct ieee80211_vif *vif)
 {
-	struct iwl_proto_offload_cmd cmd = {};
+	union {
+		struct iwl_proto_offload_cmd_v1 v1;
+		struct iwl_proto_offload_cmd_v2 v2;
+	} cmd = {};
+	struct iwl_proto_offload_cmd_common *common;
+	u32 enabled = 0, size;
 #if IS_ENABLED(CONFIG_IPV6)
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	int i;
 
-	if (mvmvif->num_target_ipv6_addrs) {
-		cmd.enabled |= cpu_to_le32(IWL_D3_PROTO_OFFLOAD_NS);
-		memcpy(cmd.ndp_mac_addr, vif->addr, ETH_ALEN);
-	}
+	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS) {
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
 
-	BUILD_BUG_ON(sizeof(cmd.target_ipv6_addr[i]) !=
-		     sizeof(mvmvif->target_ipv6_addrs[i]));
+		BUILD_BUG_ON(sizeof(cmd.v1.target_ipv6_addr[0]) !=
+			     sizeof(mvmvif->target_ipv6_addrs[0]));
 
-	for (i = 0; i < mvmvif->num_target_ipv6_addrs; i++)
-		memcpy(cmd.target_ipv6_addr[i],
-		       &mvmvif->target_ipv6_addrs[i],
-		       sizeof(cmd.target_ipv6_addr[i]));
+		for (i = 0; i < min(mvmvif->num_target_ipv6_addrs,
+				    IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_V1); i++)
+			memcpy(cmd.v1.target_ipv6_addr[i],
+			       &mvmvif->target_ipv6_addrs[i],
+			       sizeof(cmd.v1.target_ipv6_addr[i]));
+	}
 #endif
 
+	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS) {
+		common = &cmd.v2.common;
+		size = sizeof(cmd.v2);
+	} else {
+		common = &cmd.v1.common;
+		size = sizeof(cmd.v1);
+	}
+
 	if (vif->bss_conf.arp_addr_cnt) {
-		cmd.enabled |= cpu_to_le32(IWL_D3_PROTO_OFFLOAD_ARP);
-		cmd.host_ipv4_addr = vif->bss_conf.arp_addr_list[0];
-		memcpy(cmd.arp_mac_addr, vif->addr, ETH_ALEN);
+		enabled |= IWL_D3_PROTO_OFFLOAD_ARP;
+		common->host_ipv4_addr = vif->bss_conf.arp_addr_list[0];
+		memcpy(common->arp_mac_addr, vif->addr, ETH_ALEN);
 	}
 
-	if (!cmd.enabled)
+	if (!enabled)
 		return 0;
 
+	common->enabled = cpu_to_le32(enabled);
+
 	return iwl_mvm_send_cmd_pdu(mvm, PROT_OFFLOAD_CONFIG_CMD, CMD_SYNC,
-				    sizeof(cmd), &cmd);
+				    size, &cmd);
 }
 
 enum iwl_mvm_tcp_packet_type {
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
index 6f8b2c1..64fe8c9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
@@ -98,34 +98,64 @@ enum iwl_proto_offloads {
 	IWL_D3_PROTO_OFFLOAD_NS = BIT(1),
 };
 
-#define IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS	2
+#define IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_V1	2
+#define IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_V2	6
+#define IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_MAX	6
 
 /**
- * struct iwl_proto_offload_cmd - ARP/NS offload configuration
+ * struct iwl_proto_offload_cmd_common - ARP/NS offload common part
  * @enabled: enable flags
  * @remote_ipv4_addr: remote address to answer to (or zero if all)
  * @host_ipv4_addr: our IPv4 address to respond to queries for
  * @arp_mac_addr: our MAC address for ARP responses
- * @remote_ipv6_addr: remote address to answer to (or zero if all)
- * @solicited_node_ipv6_addr: broken -- solicited node address exists
- *	for each target address
- * @target_ipv6_addr: our target addresses
- * @ndp_mac_addr: neighbor soliciation response MAC address
+ * @reserved: unused
  */
-struct iwl_proto_offload_cmd {
+struct iwl_proto_offload_cmd_common {
 	__le32 enabled;
 	__be32 remote_ipv4_addr;
 	__be32 host_ipv4_addr;
 	u8 arp_mac_addr[ETH_ALEN];
-	__le16 reserved1;
+	__le16 reserved;
+} __packed;
 
+/**
+ * struct iwl_proto_offload_cmd_v1 - ARP/NS offload configuration
+ * @common: common/IPv4 configuration
+ * @remote_ipv6_addr: remote address to answer to (or zero if all)
+ * @solicited_node_ipv6_addr: broken -- solicited node address exists
+ *	for each target address
+ * @target_ipv6_addr: our target addresses
+ * @ndp_mac_addr: neighbor soliciation response MAC address
+ */
+struct iwl_proto_offload_cmd_v1 {
+	struct iwl_proto_offload_cmd_common common;
 	u8 remote_ipv6_addr[16];
 	u8 solicited_node_ipv6_addr[16];
-	u8 target_ipv6_addr[IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS][16];
+	u8 target_ipv6_addr[IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_V1][16];
 	u8 ndp_mac_addr[ETH_ALEN];
-	__le16 reserved2;
+	u8 numValidIPv6Addresses;
+	u8 reserved2[3];
 } __packed; /* PROT_OFFLOAD_CONFIG_CMD_DB_S_VER_1 */
 
+/**
+ * struct iwl_proto_offload_cmd_v2 - ARP/NS offload configuration
+ * @common: common/IPv4 configuration
+ * @remote_ipv6_addr: remote address to answer to (or zero if all)
+ * @solicited_node_ipv6_addr: broken -- solicited node address exists
+ *	for each target address
+ * @target_ipv6_addr: our target addresses
+ * @ndp_mac_addr: neighbor soliciation response MAC address
+ */
+struct iwl_proto_offload_cmd_v2 {
+	struct iwl_proto_offload_cmd_common common;
+	u8 remote_ipv6_addr[16];
+	u8 solicited_node_ipv6_addr[16];
+	u8 target_ipv6_addr[IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_V2][16];
+	u8 ndp_mac_addr[ETH_ALEN];
+	u8 numValidIPv6Addresses;
+	u8 reserved2[3];
+} __packed; /* PROT_OFFLOAD_CONFIG_CMD_DB_S_VER_2 */
+
 
 /*
  * WOWLAN_PATTERNS
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index caa6a175..879fb01 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -282,7 +282,7 @@ struct iwl_mvm_vif {
 
 #if IS_ENABLED(CONFIG_IPV6)
 	/* IPv6 addresses for WoWLAN */
-	struct in6_addr target_ipv6_addrs[IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS];
+	struct in6_addr target_ipv6_addrs[IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_MAX];
 	int num_target_ipv6_addrs;
 #endif
 #endif
-- 
1.8.0

