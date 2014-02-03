Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:45108 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbaBCU6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:54 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so3948676ead.6
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:53 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/62] iwlwifi: mvm: add dest ip to bcast filter configuration
Date: Mon,  3 Feb 2014 22:57:31 +0200
Message-Id: <1391461088-8082-25-git-send-email-egrumbach@gmail.com> (sfid-20140203_220010_860584_5C9A0CDD)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Add our ip as a new attribute to the bcast filtering
configuration (i.e. check the dest ip field of the
arp request).

Add bcast filter to pass incoming dhcp offer
broadcast frames as well (for sta vifs).

In order to support such dynamic configuration,
use the reserved1 field as a bitmap for driver internal
flags (which will indicate we want to configure the ip
in this attribute), and reconfigure the bcast
filtering on BSS_CHANGED_ARP_FILTER indication.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   73 +++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 6f9640b..b3f6c2b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -66,6 +66,7 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/ip.h>
+#include <linux/if_arp.h>
 #include <net/mac80211.h>
 #include <net/tcp.h>
 
@@ -129,6 +130,23 @@ static const struct wiphy_wowlan_tcp_support iwl_mvm_wowlan_tcp_support = {
 #endif
 
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
+/*
+ * Use the reserved field to indicate magic values.
+ * these values will only be used internally by the driver,
+ * and won't make it to the fw (reserved will be 0).
+ * BC_FILTER_MAGIC_IP - configure the val of this attribute to
+ *	be the vif's ip address. in case there is not a single
+ *	ip address (0, or more than 1), this attribute will
+ *	be skipped.
+ * BC_FILTER_MAGIC_MAC - set the val of this attribute to
+ *	the LSB bytes of the vif's mac address
+ */
+enum {
+	BC_FILTER_MAGIC_NONE = 0,
+	BC_FILTER_MAGIC_IP,
+	BC_FILTER_MAGIC_MAC,
+};
+
 static const struct iwl_fw_bcast_filter iwl_mvm_default_bcast_filters[] = {
 	{
 		/* arp */
@@ -143,6 +161,40 @@ static const struct iwl_fw_bcast_filter iwl_mvm_default_bcast_filters[] = {
 				.val = cpu_to_be32(0x08060001),
 				.mask = cpu_to_be32(0xffffffff),
 			},
+			{
+				/* arp dest ip */
+				.offset_type =
+					BCAST_FILTER_OFFSET_PAYLOAD_START,
+				.offset = sizeof(rfc1042_header) + 2 +
+					  sizeof(struct arphdr) +
+					  ETH_ALEN + sizeof(__be32) +
+					  ETH_ALEN,
+				.mask = cpu_to_be32(0xffffffff),
+				/* mark it as special field */
+				.reserved1 = cpu_to_le16(BC_FILTER_MAGIC_IP),
+			},
+		},
+	},
+	{
+		/* dhcp offer bcast */
+		.discard = 0,
+		.frame_type = BCAST_FILTER_FRAME_TYPE_IPV4,
+		.attrs = {
+			{
+				/* udp dest port - 68 (bootp client)*/
+				.offset_type = BCAST_FILTER_OFFSET_IP_END,
+				.offset = offsetof(struct udphdr, dest),
+				.val = cpu_to_be32(0x00440000),
+				.mask = cpu_to_be32(0xffff0000),
+			},
+			{
+				/* dhcp - lsb bytes of client hw address */
+				.offset_type = BCAST_FILTER_OFFSET_IP_END,
+				.offset = 38,
+				.mask = cpu_to_be32(0xffffffff),
+				/* mark it as special field */
+				.reserved1 = cpu_to_le16(BC_FILTER_MAGIC_MAC),
+			},
 		},
 	},
 	/* last filter must be empty */
@@ -922,6 +974,22 @@ iwl_mvm_set_bcast_filter(struct ieee80211_vif *vif,
 		if (!attr->mask)
 			break;
 
+		switch (attr->reserved1) {
+		case cpu_to_le16(BC_FILTER_MAGIC_IP):
+			if (vif->bss_conf.arp_addr_cnt != 1) {
+				attr->mask = 0;
+				continue;
+			}
+
+			attr->val = vif->bss_conf.arp_addr_list[0];
+			break;
+		case cpu_to_le16(BC_FILTER_MAGIC_MAC):
+			attr->val = *(__be32 *)&vif->addr[2];
+			break;
+		default:
+			break;
+		}
+		attr->reserved1 = 0;
 		out_filter->num_attrs++;
 	}
 }
@@ -1130,6 +1198,11 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		if (ret)
 			IWL_ERR(mvm, "failed to update CQM thresholds\n");
 	}
+
+	if (changes & BSS_CHANGED_ARP_FILTER) {
+		IWL_DEBUG_MAC80211(mvm, "arp filter changed");
+		iwl_mvm_configure_bcast_filter(mvm, vif);
+	}
 }
 
 static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
-- 
1.7.9.5

