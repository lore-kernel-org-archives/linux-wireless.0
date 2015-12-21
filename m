Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:46048 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbbLUUvb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:51:31 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/45] iwlwifi: mvm: change protocol offload flows
Date: Mon, 21 Dec 2015 22:50:22 +0200
Message-Id: <1450731046-2796-21-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215135_372951_211D08B1)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

RFC4862 states that "In all cases, a node MUST NOT respond to
a Neighbor Solicitation for a tentative address".
Currently the driver configures the NS offload and does not wait
for address to become permanent, thus violating the RFC.
Just removing the address from the address list is not good enough
for all cases, since the NS messages are needed for the duplicate
address detection and should not be discarded.

For d0i3 disable NS offload. Put tentative address in the address
list so the NS packet will not be filtered out by ucode.
For D3 the platform will not wake from NS packets - so enable
NS offload while removing the tentative address from the list.

Given that now NS offload might be disabled, and that the ucode
uses the IP data for other puroposes (L3 filtering) add two
independent flags indicating if IPv4\IPv6 data is valid.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h |  4 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  2 +
 .../net/wireless/intel/iwlwifi/mvm/offloading.c    | 74 ++++++++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  3 +-
 5 files changed, 69 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index b1c9992..8824a89 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -104,9 +104,13 @@ void iwl_mvm_ipv6_addr_change(struct ieee80211_hw *hw,
 	struct inet6_ifaddr *ifa;
 	int idx = 0;
 
+	memset(mvmvif->tentative_addrs, 0, sizeof(mvmvif->tentative_addrs));
+
 	read_lock_bh(&idev->lock);
 	list_for_each_entry(ifa, &idev->addr_list, if_list) {
 		mvmvif->target_ipv6_addrs[idx] = ifa->addr;
+		if (ifa->flags & IFA_F_TENTATIVE)
+			__set_bit(idx, mvmvif->tentative_addrs);
 		idx++;
 		if (idx >= IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_MAX)
 			break;
@@ -964,7 +968,7 @@ iwl_mvm_wowlan_config(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
-	ret = iwl_mvm_send_proto_offload(mvm, vif, false, 0);
+	ret = iwl_mvm_send_proto_offload(mvm, vif, false, true, 0);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h
index 228684c..c36c956 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h
@@ -94,10 +94,14 @@ struct iwl_d3_manager_config {
  * enum iwl_d3_proto_offloads - enabled protocol offloads
  * @IWL_D3_PROTO_OFFLOAD_ARP: ARP data is enabled
  * @IWL_D3_PROTO_OFFLOAD_NS: NS (Neighbor Solicitation) is enabled
+ * @IWL_D3_PROTO_IPV4_VALID: IPv4 data is valid
+ * @IWL_D3_PROTO_IPV6_VALID: IPv6 data is valid
  */
 enum iwl_proto_offloads {
 	IWL_D3_PROTO_OFFLOAD_ARP = BIT(0),
 	IWL_D3_PROTO_OFFLOAD_NS = BIT(1),
+	IWL_D3_PROTO_IPV4_VALID = BIT(2),
+	IWL_D3_PROTO_IPV6_VALID = BIT(3),
 };
 
 #define IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_V1	2
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 3fc7199..d8760fa 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -422,6 +422,7 @@ struct iwl_mvm_vif {
 #if IS_ENABLED(CONFIG_IPV6)
 	/* IPv6 addresses for WoWLAN */
 	struct in6_addr target_ipv6_addrs[IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_MAX];
+	unsigned long tentative_addrs[BITS_TO_LONGS(IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_MAX)];
 	int num_target_ipv6_addrs;
 #endif
 
@@ -1299,6 +1300,7 @@ void iwl_mvm_set_wowlan_qos_seq(struct iwl_mvm_sta *mvm_ap_sta,
 int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm,
 			       struct ieee80211_vif *vif,
 			       bool disable_offloading,
+			       bool offload_ns,
 			       u32 cmd_flags);
 
 /* D0i3 */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/offloading.c b/drivers/net/wireless/intel/iwlwifi/mvm/offloading.c
index f83e2bc..6338d9c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/offloading.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/offloading.c
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2015 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -33,6 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2015 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -64,6 +66,7 @@
  *****************************************************************************/
 #include <net/ipv6.h>
 #include <net/addrconf.h>
+#include <linux/bitops.h>
 #include "mvm.h"
 
 void iwl_mvm_set_wowlan_qos_seq(struct iwl_mvm_sta *mvm_ap_sta,
@@ -86,6 +89,7 @@ void iwl_mvm_set_wowlan_qos_seq(struct iwl_mvm_sta *mvm_ap_sta,
 int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm,
 			       struct ieee80211_vif *vif,
 			       bool disable_offloading,
+			       bool offload_ns,
 			       u32 cmd_flags)
 {
 	union {
@@ -106,6 +110,13 @@ int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm,
 #if IS_ENABLED(CONFIG_IPV6)
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	int i;
+	/*
+	 * Skip tentative address when ns offload is enabled to avoid
+	 * violating RFC4862.
+	 * Keep tentative address when ns offload is disabled so the NS packets
+	 * will not be filtered out and will wake up the host.
+	 */
+	bool skip_tentative = offload_ns;
 
 	if (capa_flags & IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL ||
 	    capa_flags & IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_LARGE) {
@@ -113,6 +124,7 @@ int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm,
 		struct iwl_targ_addr *addrs;
 		int n_nsc, n_addrs;
 		int c;
+		int num_skipped = 0;
 
 		if (capa_flags & IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL) {
 			nsc = cmd.v3s.ns_config;
@@ -126,9 +138,6 @@ int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm,
 			n_addrs = IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_V3L;
 		}
 
-		if (mvmvif->num_target_ipv6_addrs)
-			enabled |= IWL_D3_PROTO_OFFLOAD_NS;
-
 		/*
 		 * For each address we have (and that will fit) fill a target
 		 * address struct and combine for NS offload structs with the
@@ -140,6 +149,12 @@ int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm,
 			struct in6_addr solicited_addr;
 			int j;
 
+			if (skip_tentative &&
+			    test_bit(i, mvmvif->tentative_addrs)) {
+				num_skipped++;
+				continue;
+			}
+
 			addrconf_addr_solict_mult(&mvmvif->target_ipv6_addrs[i],
 						  &solicited_addr);
 			for (j = 0; j < c; j++)
@@ -154,41 +169,64 @@ int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm,
 			memcpy(nsc[j].target_mac_addr, vif->addr, ETH_ALEN);
 		}
 
+		if (mvmvif->num_target_ipv6_addrs - num_skipped)
+			enabled |= IWL_D3_PROTO_IPV6_VALID;
+
 		if (capa_flags & IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL)
-			cmd.v3s.num_valid_ipv6_addrs = cpu_to_le32(i);
+			cmd.v3s.num_valid_ipv6_addrs =
+				cpu_to_le32(i - num_skipped);
 		else
-			cmd.v3l.num_valid_ipv6_addrs = cpu_to_le32(i);
+			cmd.v3l.num_valid_ipv6_addrs =
+				cpu_to_le32(i - num_skipped);
 	} else if (capa_flags & IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS) {
-		if (mvmvif->num_target_ipv6_addrs) {
-			enabled |= IWL_D3_PROTO_OFFLOAD_NS;
-			memcpy(cmd.v2.ndp_mac_addr, vif->addr, ETH_ALEN);
-		}
+		bool found = false;
 
 		BUILD_BUG_ON(sizeof(cmd.v2.target_ipv6_addr[0]) !=
 			     sizeof(mvmvif->target_ipv6_addrs[0]));
 
 		for (i = 0; i < min(mvmvif->num_target_ipv6_addrs,
-				    IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_V2); i++)
+				    IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_V2); i++) {
+			if (skip_tentative &&
+			    test_bit(i, mvmvif->tentative_addrs))
+				continue;
+
 			memcpy(cmd.v2.target_ipv6_addr[i],
 			       &mvmvif->target_ipv6_addrs[i],
 			       sizeof(cmd.v2.target_ipv6_addr[i]));
-	} else {
-		if (mvmvif->num_target_ipv6_addrs) {
-			enabled |= IWL_D3_PROTO_OFFLOAD_NS;
-			memcpy(cmd.v1.ndp_mac_addr, vif->addr, ETH_ALEN);
-		}
 
+			found = true;
+		}
+		if (found) {
+			enabled |= IWL_D3_PROTO_IPV6_VALID;
+			memcpy(cmd.v2.ndp_mac_addr, vif->addr, ETH_ALEN);
+		}
+	} else {
+		bool found = false;
 		BUILD_BUG_ON(sizeof(cmd.v1.target_ipv6_addr[0]) !=
 			     sizeof(mvmvif->target_ipv6_addrs[0]));
 
 		for (i = 0; i < min(mvmvif->num_target_ipv6_addrs,
-				    IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_V1); i++)
+				    IWL_PROTO_OFFLOAD_NUM_IPV6_ADDRS_V1); i++) {
+			if (skip_tentative &&
+			    test_bit(i, mvmvif->tentative_addrs))
+				continue;
+
 			memcpy(cmd.v1.target_ipv6_addr[i],
 			       &mvmvif->target_ipv6_addrs[i],
 			       sizeof(cmd.v1.target_ipv6_addr[i]));
+
+			found = true;
+		}
+
+		if (found) {
+			enabled |= IWL_D3_PROTO_IPV6_VALID;
+			memcpy(cmd.v1.ndp_mac_addr, vif->addr, ETH_ALEN);
+		}
 	}
-#endif
 
+	if (offload_ns && (enabled & IWL_D3_PROTO_IPV6_VALID))
+		enabled |= IWL_D3_PROTO_OFFLOAD_NS;
+#endif
 	if (capa_flags & IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL) {
 		common = &cmd.v3s.common;
 		size = sizeof(cmd.v3s);
@@ -204,7 +242,7 @@ int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm,
 	}
 
 	if (vif->bss_conf.arp_addr_cnt) {
-		enabled |= IWL_D3_PROTO_OFFLOAD_ARP;
+		enabled |= IWL_D3_PROTO_OFFLOAD_ARP | IWL_D3_PROTO_IPV4_VALID;
 		common->host_ipv4_addr = vif->bss_conf.arp_addr_list[0];
 		memcpy(common->arp_mac_addr, vif->addr, ETH_ALEN);
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 31c16a1..4753ecd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1153,7 +1153,8 @@ static void iwl_mvm_enter_d0i3_iterator(void *_data, u8 *mac,
 		data->disable_offloading = true;
 
 	iwl_mvm_update_d0i3_power_mode(mvm, vif, true, flags);
-	iwl_mvm_send_proto_offload(mvm, vif, data->disable_offloading, flags);
+	iwl_mvm_send_proto_offload(mvm, vif, data->disable_offloading,
+				   false, flags);
 
 	/*
 	 * on init/association, mvm already configures POWER_TABLE_CMD
-- 
2.5.0

