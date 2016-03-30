Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:31955 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342AbcC3OGb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:31 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 37/43] iwlwifi: mvm: enable TCP/UDP checksum support for 9000 family
Date: Wed, 30 Mar 2016 17:05:09 +0300
Message-Id: <1459346715-7954-37-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160701_687546_16BFADAC)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Declare and enable support of RX and TX checksum for 9000 family.
Configure offload_assist in the TX cmd accordingly to support
TX csum.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c     |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h   |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  13 +--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 124 +++++++++++++++++++++-
 4 files changed, 133 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index 277396a..1f25ba6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -137,6 +137,7 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 	.dccm2_len = IWL9000_DCCM2_LEN,					\
 	.smem_offset = IWL9000_SMEM_OFFSET,				\
 	.smem_len = IWL9000_SMEM_LEN,					\
+	.features = IWL_TX_CSUM_NETIF_FLAGS | NETIF_F_RXCSUM,		\
 	.thermal_params = &iwl9000_tt_params,				\
 	.apmg_not_supported = true,					\
 	.mq_rx_supported = true,					\
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 8cbd248..b002557 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -131,6 +131,8 @@ enum iwl_led_mode {
 #define IWL_MAX_WD_TIMEOUT	120000
 
 #define IWL_DEFAULT_MAX_TX_POWER 22
+#define IWL_TX_CSUM_NETIF_FLAGS (NETIF_F_IPV6_CSUM | NETIF_F_IP_CSUM |\
+				 NETIF_F_TSO | NETIF_F_TSO6)
 
 /* Antenna presence definitions */
 #define	ANT_NONE	0x0
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 115d7aa..4f5ec49 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -665,12 +665,13 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	}
 
 	hw->netdev_features |= mvm->cfg->features;
-	if (!iwl_mvm_is_csum_supported(mvm))
-		hw->netdev_features &= ~NETIF_F_RXCSUM;
-
-	if (IWL_MVM_SW_TX_CSUM_OFFLOAD)
-		hw->netdev_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			NETIF_F_TSO | NETIF_F_TSO6;
+	if (!iwl_mvm_is_csum_supported(mvm)) {
+		hw->netdev_features &= ~(IWL_TX_CSUM_NETIF_FLAGS |
+					 NETIF_F_RXCSUM);
+		/* We may support SW TX CSUM */
+		if (IWL_MVM_SW_TX_CSUM_OFFLOAD)
+			hw->netdev_features |= IWL_TX_CSUM_NETIF_FLAGS;
+	}
 
 	ret = ieee80211_register_hw(mvm->hw);
 	if (ret)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 24cff98..efb9b98 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -67,6 +67,7 @@
 #include <linux/etherdevice.h>
 #include <linux/tcp.h>
 #include <net/ip.h>
+#include <net/ipv6.h>
 
 #include "iwl-trans.h"
 #include "iwl-eeprom-parse.h"
@@ -98,6 +99,111 @@ iwl_mvm_bar_check_trigger(struct iwl_mvm *mvm, const u8 *addr,
 				    addr, tid, ssn);
 }
 
+#define OPT_HDR(type, skb, off) \
+	(type *)(skb_network_header(skb) + (off))
+
+static void iwl_mvm_tx_csum(struct iwl_mvm *mvm, struct sk_buff *skb,
+			    struct ieee80211_hdr *hdr,
+			    struct ieee80211_tx_info *info,
+			    struct iwl_tx_cmd *tx_cmd)
+{
+#if IS_ENABLED(CONFIG_INET)
+	u16 mh_len = ieee80211_hdrlen(hdr->frame_control);
+	u16 offload_assist = le16_to_cpu(tx_cmd->offload_assist);
+	u8 protocol = 0;
+
+	/*
+	 * Do not compute checksum if already computed or if transport will
+	 * compute it
+	 */
+	if (skb->ip_summed != CHECKSUM_PARTIAL || IWL_MVM_SW_TX_CSUM_OFFLOAD)
+		return;
+
+	/* We do not expect to be requested to csum stuff we do not support */
+	if (WARN_ONCE(!(mvm->hw->netdev_features & IWL_TX_CSUM_NETIF_FLAGS) ||
+		      (skb->protocol != htons(ETH_P_IP) &&
+		       skb->protocol != htons(ETH_P_IPV6)),
+		      "No support for requested checksum\n")) {
+		skb_checksum_help(skb);
+		return;
+	}
+
+	if (skb->protocol == htons(ETH_P_IP)) {
+		protocol = ip_hdr(skb)->protocol;
+	} else {
+#if IS_ENABLED(CONFIG_IPV6)
+		struct ipv6hdr *ipv6h =
+			(struct ipv6hdr *)skb_network_header(skb);
+		unsigned int off = sizeof(*ipv6h);
+
+		protocol = ipv6h->nexthdr;
+		while (protocol != NEXTHDR_NONE && ipv6_ext_hdr(protocol)) {
+			/* only supported extension headers */
+			if (protocol != NEXTHDR_ROUTING &&
+			    protocol != NEXTHDR_HOP &&
+			    protocol != NEXTHDR_DEST &&
+			    protocol != NEXTHDR_FRAGMENT) {
+				skb_checksum_help(skb);
+				return;
+			}
+
+			if (protocol == NEXTHDR_FRAGMENT) {
+				struct frag_hdr *hp =
+					OPT_HDR(struct frag_hdr, skb, off);
+
+				protocol = hp->nexthdr;
+				off += sizeof(struct frag_hdr);
+			} else {
+				struct ipv6_opt_hdr *hp =
+					OPT_HDR(struct ipv6_opt_hdr, skb, off);
+
+				protocol = hp->nexthdr;
+				off += ipv6_optlen(hp);
+			}
+		}
+		/* if we get here - protocol now should be TCP/UDP */
+#endif
+	}
+
+	if (protocol != IPPROTO_TCP && protocol != IPPROTO_UDP) {
+		WARN_ON_ONCE(1);
+		skb_checksum_help(skb);
+		return;
+	}
+
+	/* enable L4 csum */
+	offload_assist |= BIT(TX_CMD_OFFLD_L4_EN);
+
+	/*
+	 * Set offset to IP header (snap).
+	 * We don't support tunneling so no need to take care of inner header.
+	 * Size is in words.
+	 */
+	offload_assist |= (4 << TX_CMD_OFFLD_IP_HDR);
+
+	/* Do IPv4 csum for AMSDU only (no IP csum for Ipv6) */
+	if (skb->protocol == htons(ETH_P_IP) &&
+	    (offload_assist & BIT(TX_CMD_OFFLD_AMSDU))) {
+		ip_hdr(skb)->check = 0;
+		offload_assist |= BIT(TX_CMD_OFFLD_L3_EN);
+	}
+
+	/* reset UDP/TCP header csum */
+	if (protocol == IPPROTO_TCP)
+		tcp_hdr(skb)->check = 0;
+	else
+		udp_hdr(skb)->check = 0;
+
+	/* mac header len should include IV, size is in words */
+	if (info->control.hw_key)
+		mh_len += info->control.hw_key->iv_len;
+	mh_len /= 2;
+	offload_assist |= mh_len << TX_CMD_OFFLD_MH_SIZE;
+
+	tx_cmd->offload_assist = cpu_to_le16(offload_assist);
+#endif
+}
+
 /*
  * Sets most of the Tx cmd's fields
  */
@@ -196,6 +302,8 @@ void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (ieee80211_hdrlen(fc) % 4 &&
 	    !(tx_cmd->offload_assist & cpu_to_le16(BIT(TX_CMD_OFFLD_AMSDU))))
 		tx_cmd->offload_assist |= cpu_to_le16(BIT(TX_CMD_OFFLD_PAD));
+
+	iwl_mvm_tx_csum(mvm, skb, hdr, info, tx_cmd);
 }
 
 /*
@@ -466,6 +574,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	u16 ip_base_id = ipv4 ? ntohs(ip_hdr(skb)->id) : 0;
 	u16 amsdu_add, snap_ip_tcp, pad, i = 0;
 	unsigned int dbg_max_amsdu_len;
+	netdev_features_t netdev_features = NETIF_F_CSUM_MASK | NETIF_F_SG;
 	u8 *qc, tid, txf;
 
 	snap_ip_tcp = 8 + skb_transport_header(skb) - skb_network_header(skb) +
@@ -485,6 +594,19 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	}
 
 	/*
+	 * Do not build AMSDU for IPv6 with extension headers.
+	 * ask stack to segment and checkum the generated MPDUs for us.
+	 */
+	if (skb->protocol == htons(ETH_P_IPV6) &&
+	    ((struct ipv6hdr *)skb_network_header(skb))->nexthdr !=
+	    IPPROTO_TCP) {
+		num_subframes = 1;
+		pad = 0;
+		netdev_features &= ~NETIF_F_CSUM_MASK;
+		goto segment;
+	}
+
+	/*
 	 * No need to lock amsdu_in_ampdu_allowed since it can't be modified
 	 * during an BA session.
 	 */
@@ -577,7 +699,7 @@ segment:
 	skb_shinfo(skb)->gso_size = num_subframes * mss;
 	memcpy(cb, skb->cb, sizeof(cb));
 
-	next = skb_gso_segment(skb, NETIF_F_CSUM_MASK | NETIF_F_SG);
+	next = skb_gso_segment(skb, netdev_features);
 	skb_shinfo(skb)->gso_size = mss;
 	if (WARN_ON_ONCE(IS_ERR(next)))
 		return -EINVAL;
-- 
2.5.0

