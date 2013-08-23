Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:44781 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755344Ab3HWXvc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 19:51:32 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/3] mwifiex: drop gratuitous ARP frames
Date: Fri, 23 Aug 2013 16:48:23 -0700
Message-ID: <1377301703-8853-3-git-send-email-bzhao@marvell.com> (sfid-20130824_015137_101239_C751689E)
In-Reply-To: <1377301703-8853-1-git-send-email-bzhao@marvell.com>
References: <1377301703-8853-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds support for dropping gratuitous ARP frames which is
requirement for WFA Hotspot2.0.

Hotspot2.0 capability is enabled in driver if extended capabilities
IE from BSS descriptor has 11u interworking enabled.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c      |  6 ++++
 drivers/net/wireless/mwifiex/cfg80211.c |  1 +
 drivers/net/wireless/mwifiex/decl.h     |  9 ++++++
 drivers/net/wireless/mwifiex/init.c     |  1 +
 drivers/net/wireless/mwifiex/main.h     |  1 +
 drivers/net/wireless/mwifiex/sta_rx.c   | 49 +++++++++++++++++++++++++++++++++
 6 files changed, 67 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index b579a2e..0b803c0 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -399,6 +399,12 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 		       bss_desc->bcn_ext_cap + sizeof(struct ieee_types_header),
 		       le16_to_cpu(ext_cap->header.len));
 
+		if (hdr->len > 3 &&
+		    ext_cap->ext_capab[3] & WLAN_EXT_CAPA4_INTERWORKING_ENABLED)
+			priv->hs2_enabled = true;
+		else
+			priv->hs2_enabled = false;
+
 		*buffer += sizeof(struct mwifiex_ie_types_extcap) + hdr->len;
 		ret_len += sizeof(struct mwifiex_ie_types_extcap) + hdr->len;
 	}
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index ca149ae..fbad00a 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1508,6 +1508,7 @@ mwifiex_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 		" reason code %d\n", priv->cfg_bssid, reason_code);
 
 	memset(priv->cfg_bssid, 0, ETH_ALEN);
+	priv->hs2_enabled = false;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index a599347..5c85d78 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -26,6 +26,7 @@
 #include <linux/wait.h>
 #include <linux/timer.h>
 #include <linux/ieee80211.h>
+#include <uapi/linux/if_arp.h>
 #include <net/mac80211.h>
 
 
@@ -152,4 +153,12 @@ struct mwifiex_types_wmm_info {
 	u8 reserved;
 	struct ieee_types_wmm_ac_parameters ac_params[IEEE80211_NUM_ACS];
 } __packed;
+
+struct mwifiex_arp_eth_header {
+	struct arphdr hdr;
+	u8 ar_sha[ETH_ALEN];
+	u8 ar_sip[4];
+	u8 ar_tha[ETH_ALEN];
+	u8 ar_tip[4];
+} __packed;
 #endif /* !_MWIFIEX_DECL_H_ */
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index e021a58..6499117 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -136,6 +136,7 @@ int mwifiex_init_priv(struct mwifiex_private *priv)
 	priv->csa_chan = 0;
 	priv->csa_expire_time = 0;
 	priv->del_list_idx = 0;
+	priv->hs2_enabled = false;
 
 	return mwifiex_add_bss_prio_tbl(priv);
 }
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index d2e5ccd..7d4d137 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -516,6 +516,7 @@ struct mwifiex_private {
 	u8 csa_chan;
 	unsigned long csa_expire_time;
 	u8 del_list_idx;
+	bool hs2_enabled;
 };
 
 enum mwifiex_ba_status {
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index b5c1095..bb22664 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -17,6 +17,8 @@
  * this warranty disclaimer.
  */
 
+#include <uapi/linux/ipv6.h>
+#include <net/ndisc.h>
 #include "decl.h"
 #include "ioctl.h"
 #include "util.h"
@@ -25,6 +27,46 @@
 #include "11n_aggr.h"
 #include "11n_rxreorder.h"
 
+/* This function checks if a frame is IPv4 ARP or IPv6 Neighbour advertisement
+ * frame. If frame has both source and destination mac address as same, this
+ * function drops such gratuitous frames.
+ */
+static bool
+mwifiex_discard_gratuitous_arp(struct mwifiex_private *priv,
+			       struct sk_buff *skb)
+{
+	const struct mwifiex_arp_eth_header *arp;
+	struct ethhdr *eth_hdr;
+	struct ipv6hdr *ipv6;
+	struct icmp6hdr *icmpv6;
+
+	eth_hdr = (struct ethhdr *)skb->data;
+	switch (ntohs(eth_hdr->h_proto)) {
+	case ETH_P_ARP:
+		arp = (void *)(skb->data + sizeof(struct ethhdr));
+		if (arp->hdr.ar_op == htons(ARPOP_REPLY) ||
+		    arp->hdr.ar_op == htons(ARPOP_REQUEST)) {
+			if (!memcmp(arp->ar_sip, arp->ar_tip, 4))
+				return true;
+		}
+		break;
+	case ETH_P_IPV6:
+		ipv6 = (void *)(skb->data + sizeof(struct ethhdr));
+		icmpv6 = (void *)(skb->data + sizeof(struct ethhdr) +
+				  sizeof(struct ipv6hdr));
+		if (NDISC_NEIGHBOUR_ADVERTISEMENT == icmpv6->icmp6_type) {
+			if (!memcmp(&ipv6->saddr, &ipv6->daddr,
+				    sizeof(struct in6_addr)))
+				return true;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 /*
  * This function processes the received packet and forwards it
  * to kernel/upper layer.
@@ -90,6 +132,13 @@ int mwifiex_process_rx_packet(struct mwifiex_private *priv,
 	   either the reconstructed EthII frame or the 802.2/llc/snap frame */
 	skb_pull(skb, hdr_chop);
 
+	if (priv->hs2_enabled &&
+	    mwifiex_discard_gratuitous_arp(priv, skb)) {
+		dev_dbg(priv->adapter->dev, "Bypassed Gratuitous ARP\n");
+		dev_kfree_skb_any(skb);
+		return 0;
+	}
+
 	priv->rxpd_rate = local_rx_pd->rx_rate;
 
 	priv->rxpd_htinfo = local_rx_pd->ht_info;
-- 
1.8.2.3

