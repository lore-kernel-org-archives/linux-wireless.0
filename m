Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:35851 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226AbcC3OGQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:16 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/43] iwlwifi: mvm: report checksum is done also for IPv6 packets
Date: Wed, 30 Mar 2016 17:04:57 +0300
Message-Id: <1459346715-7954-25-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160749_652083_85A4880A)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Currently the code checks if hardware reported both L4 and L3
checksums as valid, and only then reports it as validated to
the stack.
However, IPv6 does not have checksum at all and the L3 checksum
valid bit is always off for IPv6 packets, with the result of the
stack re-validating L4 checksum.
Fix code to set CHECKSUM_UNNECESSARY also for IPv6 packets whose
TCP/UDP checksum was verified.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h | 15 ++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  9 +++++++--
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
index 7a16e55..4c086d0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
@@ -268,12 +268,25 @@ enum iwl_rx_mpdu_amsdu_info {
 	IWL_RX_MPDU_AMSDU_LAST_SUBFRAME		= 0x80,
 };
 
+enum iwl_rx_l3_proto_values {
+	IWL_RX_L3_TYPE_NONE,
+	IWL_RX_L3_TYPE_IPV4,
+	IWL_RX_L3_TYPE_IPV4_FRAG,
+	IWL_RX_L3_TYPE_IPV6_FRAG,
+	IWL_RX_L3_TYPE_IPV6,
+	IWL_RX_L3_TYPE_IPV6_IN_IPV4,
+	IWL_RX_L3_TYPE_ARP,
+	IWL_RX_L3_TYPE_EAPOL,
+};
+
+#define IWL_RX_L3_PROTO_POS 4
+
 enum iwl_rx_l3l4_flags {
 	IWL_RX_L3L4_IP_HDR_CSUM_OK		= BIT(0),
 	IWL_RX_L3L4_TCP_UDP_CSUM_OK		= BIT(1),
 	IWL_RX_L3L4_TCP_FIN_SYN_RST_PSH		= BIT(2),
 	IWL_RX_L3L4_TCP_ACK			= BIT(3),
-	IWL_RX_L3L4_L3_PROTO_MASK		= 0xf << 4,
+	IWL_RX_L3L4_L3_PROTO_MASK		= 0xf << IWL_RX_L3_PROTO_POS,
 	IWL_RX_L3L4_L4_PROTO_MASK		= 0xf << 8,
 	IWL_RX_L3L4_RSS_HASH_MASK		= 0xf << 12,
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 9a54f2d..b2bc3d9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -294,10 +294,15 @@ static void iwl_mvm_rx_csum(struct ieee80211_sta *sta,
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(mvmsta->vif);
+	u16 flags = le16_to_cpu(desc->l3l4_flags);
+	u8 l3_prot = (u8)((flags & IWL_RX_L3L4_L3_PROTO_MASK) >>
+			  IWL_RX_L3_PROTO_POS);
 
 	if (mvmvif->features & NETIF_F_RXCSUM &&
-	    desc->l3l4_flags & cpu_to_le16(IWL_RX_L3L4_IP_HDR_CSUM_OK) &&
-	    desc->l3l4_flags & cpu_to_le16(IWL_RX_L3L4_TCP_UDP_CSUM_OK))
+	    flags & IWL_RX_L3L4_TCP_UDP_CSUM_OK &&
+	    (flags & IWL_RX_L3L4_IP_HDR_CSUM_OK ||
+	     l3_prot == IWL_RX_L3_TYPE_IPV6 ||
+	     l3_prot == IWL_RX_L3_TYPE_IPV6_FRAG))
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 }
 
-- 
2.5.0

