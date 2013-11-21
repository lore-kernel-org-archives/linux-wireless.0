Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50221 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab3KUN7I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Nov 2013 08:59:08 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Bing Zhao <bzhao@marvell.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: implement HS2.0 gratuitous ARP/unsolicited NA dropping
Date: Thu, 21 Nov 2013 14:58:58 +0100
Message-Id: <1385042338-27255-1-git-send-email-johannes@sipsolutions.net> (sfid-20131121_145913_256079_8DA324B7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Taking the gratuitous ARP/unsolicited NA detection code from
mwifiex (but fixing it up to not have read-after-skb-end bugs),
implement the ability for userspace to request the behaviour
required by HS2.0 to drop gratuitous ARP and unsolicited NA
frames when proxy ARP service is enabled on the AP. Since this
behaviour is only mandatory for HS2.0 and may not always be
desired, make it optional - modify cfg80211/nl80211 for that.

TODO: make sure the gratuitous ARP/unsolicited NA checks are
      actually correct and sufficient

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mwifiex/decl.h   |  8 ------
 drivers/net/wireless/mwifiex/sta_rx.c | 44 +----------------------------
 include/linux/ieee80211.h             |  2 ++
 include/net/cfg80211.h                | 13 +++++++++
 include/uapi/linux/nl80211.h          |  5 ++++
 net/mac80211/ieee80211_i.h            |  4 +++
 net/mac80211/mlme.c                   | 16 +++++++++++
 net/mac80211/rx.c                     |  6 ++++
 net/mac80211/util.c                   |  4 +++
 net/wireless/nl80211.c                |  3 ++
 net/wireless/util.c                   | 52 +++++++++++++++++++++++++++++++++++
 11 files changed, 106 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 5c85d78..1887629 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -153,12 +153,4 @@ struct mwifiex_types_wmm_info {
 	u8 reserved;
 	struct ieee_types_wmm_ac_parameters ac_params[IEEE80211_NUM_ACS];
 } __packed;
-
-struct mwifiex_arp_eth_header {
-	struct arphdr hdr;
-	u8 ar_sha[ETH_ALEN];
-	u8 ar_sip[4];
-	u8 ar_tha[ETH_ALEN];
-	u8 ar_tip[4];
-} __packed;
 #endif /* !_MWIFIEX_DECL_H_ */
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index bb22664..2aba403 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -17,8 +17,6 @@
  * this warranty disclaimer.
  */
 
-#include <uapi/linux/ipv6.h>
-#include <net/ndisc.h>
 #include "decl.h"
 #include "ioctl.h"
 #include "util.h"
@@ -27,46 +25,6 @@
 #include "11n_aggr.h"
 #include "11n_rxreorder.h"
 
-/* This function checks if a frame is IPv4 ARP or IPv6 Neighbour advertisement
- * frame. If frame has both source and destination mac address as same, this
- * function drops such gratuitous frames.
- */
-static bool
-mwifiex_discard_gratuitous_arp(struct mwifiex_private *priv,
-			       struct sk_buff *skb)
-{
-	const struct mwifiex_arp_eth_header *arp;
-	struct ethhdr *eth_hdr;
-	struct ipv6hdr *ipv6;
-	struct icmp6hdr *icmpv6;
-
-	eth_hdr = (struct ethhdr *)skb->data;
-	switch (ntohs(eth_hdr->h_proto)) {
-	case ETH_P_ARP:
-		arp = (void *)(skb->data + sizeof(struct ethhdr));
-		if (arp->hdr.ar_op == htons(ARPOP_REPLY) ||
-		    arp->hdr.ar_op == htons(ARPOP_REQUEST)) {
-			if (!memcmp(arp->ar_sip, arp->ar_tip, 4))
-				return true;
-		}
-		break;
-	case ETH_P_IPV6:
-		ipv6 = (void *)(skb->data + sizeof(struct ethhdr));
-		icmpv6 = (void *)(skb->data + sizeof(struct ethhdr) +
-				  sizeof(struct ipv6hdr));
-		if (NDISC_NEIGHBOUR_ADVERTISEMENT == icmpv6->icmp6_type) {
-			if (!memcmp(&ipv6->saddr, &ipv6->daddr,
-				    sizeof(struct in6_addr)))
-				return true;
-		}
-		break;
-	default:
-		break;
-	}
-
-	return false;
-}
-
 /*
  * This function processes the received packet and forwards it
  * to kernel/upper layer.
@@ -133,7 +91,7 @@ int mwifiex_process_rx_packet(struct mwifiex_private *priv,
 	skb_pull(skb, hdr_chop);
 
 	if (priv->hs2_enabled &&
-	    mwifiex_discard_gratuitous_arp(priv, skb)) {
+	    cfg80211_is_gratuitous_arp_unsolicited_na(skb)) {
 		dev_dbg(priv->adapter->dev, "Bypassed Gratuitous ARP\n");
 		dev_kfree_skb_any(skb);
 		return 0;
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 776cbb8..ec91000 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1889,6 +1889,8 @@ enum ieee80211_tdls_actioncode {
 	WLAN_TDLS_DISCOVERY_REQUEST = 10,
 };
 
+#define WLAN_EXT_CAPA1_PROXY_ARP		BIT(4)
+
 /* Interworking capabilities are set in 7th bit of 4th byte of the
  * @WLAN_EID_EXT_CAPABILITY information element
  */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 37a4c09..6b96ebd 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1562,11 +1562,14 @@ struct cfg80211_auth_request {
  * @ASSOC_REQ_DISABLE_VHT:  Disable VHT
  * @ASSOC_REQ_DROP_GROUP_PROTECTED_UNICAST: Drop protocol unicast packets
  *	that were group-protected at the link layer.
+ * @ASSOC_REQ_DROP_PROXY_SERVICE_ARP_NA: While proxy ARP/NA service is enabled,
+ *	drop gratuitous ARP/unsolicited NA frames.
  */
 enum cfg80211_assoc_req_flags {
 	ASSOC_REQ_DISABLE_HT			= BIT(0),
 	ASSOC_REQ_DISABLE_VHT			= BIT(1),
 	ASSOC_REQ_DROP_GROUP_PROTECTED_UNICAST	= BIT(2),
+	ASSOC_REQ_DROP_PROXY_SERVICE_ARP_NA	= BIT(3),
 };
 
 /**
@@ -4419,6 +4422,16 @@ void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
  */
 void cfg80211_crit_proto_stopped(struct wireless_dev *wdev, gfp_t gfp);
 
+/**
+ * cfg80211_is_gratuitous_arp_unsolicited_na - packet is grat. ARP/unsol. NA
+ * @skb: the input packet, must be an ethernet frame already
+ *
+ * Return: %true if the packet is a gratuitous ARP or unsolicited NA packet.
+ * This is used to drop packets that shouldn't occur because the AP implements
+ * a proxy service.
+ */
+bool cfg80211_is_gratuitous_arp_unsolicited_na(struct sk_buff *skb);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 8fc8b05..e728d0e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1521,6 +1521,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_DROP_GROUP_PROTECTED_UNICAST: Drop protocol unicast packets
  *	that were group protected at the wireless level. This flag attribute
  *	is valid in the association command.
+ * @NL80211_ATTR_DROP_PROXY_SERVICE_ARP_NA: If the AP supports proxy ARP/NA
+ *	service, then drop gratuitous ARP/unsolicted NA packets while that
+ *	service is enabled. This flag attribute is valid in the association
+ *	command.
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -1841,6 +1845,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_SUPPORT_5_10_MHZ,
 
 	NL80211_ATTR_DROP_GROUP_PROTECTED_UNICAST,
+	NL80211_ATTR_DROP_PROXY_SERVICE_ARP_NA,
 
 	/* add attributes here, update the policy in nl80211.c */
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d39cfb5..6ccf1c1 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -338,6 +338,7 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_DISABLE_VHT	= BIT(11),
 	IEEE80211_STA_DISABLE_80P80MHZ	= BIT(12),
 	IEEE80211_STA_DISABLE_160MHZ	= BIT(13),
+	IEEE80211_STA_DROP_PROXY_SERVICE_ARP_NA = BIT(14),
 };
 
 struct ieee80211_mgd_auth_data {
@@ -707,6 +708,7 @@ struct ieee80211_sub_if_data {
 
 	bool drop_unencrypted;
 	bool drop_group_protected_unicast;
+	bool drop_gratuitous_arp_unsolicited_na;
 
 	char name[IFNAMSIZ];
 
@@ -1290,6 +1292,7 @@ struct ieee802_11_elems {
 	const u8 *opmode_notif;
 	const struct ieee80211_sec_chan_offs_ie *sec_chan_offs;
 	const struct ieee80211_mesh_chansw_params_ie *mesh_chansw_params_ie;
+	const u8 *ext_capa;
 
 	/* length of them, respectively */
 	u8 ssid_len;
@@ -1306,6 +1309,7 @@ struct ieee802_11_elems {
 	u8 prep_len;
 	u8 perr_len;
 	u8 country_elem_len;
+	u8 ext_capa_len;
 
 	/* whether a parse error occurred while retrieving these elements */
 	bool parse_error;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 649902b..7542861 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1750,6 +1750,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	ieee80211_vif_release_channel(sdata);
 
 	sdata->encrypt_headroom = IEEE80211_ENCRYPT_HEADROOM;
+	sdata->drop_gratuitous_arp_unsolicited_na = false;
 }
 
 void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
@@ -2501,6 +2502,11 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		sta->sta.rx_nss = nss;
 	}
 
+	if (ifmgd->flags & IEEE80211_STA_DROP_PROXY_SERVICE_ARP_NA &&
+	    elems.ext_capa && elems.ext_capa_len >= 2)
+		sdata->drop_gratuitous_arp_unsolicited_na =
+			elems.ext_capa[1] & WLAN_EXT_CAPA1_PROXY_ARP;
+
 	rate_control_rate_init(sta);
 
 	if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED)
@@ -3034,6 +3040,11 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 						       elems.country_elem_len,
 						       elems.pwr_constr_elem);
 
+	if (ifmgd->flags & IEEE80211_STA_DROP_PROXY_SERVICE_ARP_NA &&
+	    elems.ext_capa && elems.ext_capa_len >= 2)
+		sdata->drop_gratuitous_arp_unsolicited_na =
+			elems.ext_capa[1] & WLAN_EXT_CAPA1_PROXY_ARP;
+
 	ieee80211_bss_info_change_notify(sdata, changed);
 }
 
@@ -4123,6 +4134,11 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 							sdata->vif.type);
 	sdata->drop_group_protected_unicast =
 		req->flags & ASSOC_REQ_DROP_GROUP_PROTECTED_UNICAST;
+	sdata->drop_gratuitous_arp_unsolicited_na = false;
+	if (req->flags & ASSOC_REQ_DROP_PROXY_SERVICE_ARP_NA)
+		ifmgd->flags |= IEEE80211_STA_DROP_PROXY_SERVICE_ARP_NA;
+	else
+		ifmgd->flags &= ~IEEE80211_STA_DROP_PROXY_SERVICE_ARP_NA;
 
 	/* kick off associate process */
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 2095be1..d5e4ad1 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1940,6 +1940,12 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 	skb = rx->skb;
 	xmit_skb = NULL;
 
+	if (sdata->drop_gratuitous_arp_unsolicited_na &&
+	    cfg80211_is_gratuitous_arp_unsolicited_na(skb)) {
+		dev_kfree_skb(skb);
+		return;
+	}
+
 	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
 	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
 	    !(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) &&
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 1520a24..5bdbe65 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -745,6 +745,7 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 		 * not listing WLAN_EID_CHANNEL_SWITCH_WRAPPER -- it seems possible
 		 * that if the content gets bigger it might be needed more than once
 		 */
+		case WLAN_EID_EXT_CAPABILITY:
 			if (test_bit(id, seen_elems)) {
 				elems->parse_error = true;
 				left -= elen;
@@ -959,6 +960,9 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			else
 				elem_parse_failed = true;
 			break;
+		case WLAN_EID_EXT_CAPABILITY:
+			elems->ext_capa = pos;
+			elems->ext_capa_len = elen;
 		default:
 			break;
 		}
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f8e3c83..1bb7e69 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -358,6 +358,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES] = { .type = NLA_BINARY },
 	[NL80211_ATTR_HANDLE_DFS] = { .type = NLA_FLAG },
 	[NL80211_ATTR_DROP_GROUP_PROTECTED_UNICAST] = { .type = NLA_FLAG },
+	[NL80211_ATTR_DROP_PROXY_SERVICE_ARP_NA] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -6348,6 +6349,8 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 
 	if (info->attrs[NL80211_ATTR_DROP_GROUP_PROTECTED_UNICAST])
 		req.flags |= ASSOC_REQ_DROP_GROUP_PROTECTED_UNICAST;
+	if (info->attrs[NL80211_ATTR_DROP_PROXY_SERVICE_ARP_NA])
+		req.flags |= ASSOC_REQ_DROP_PROXY_SERVICE_ARP_NA;
 
 	err = nl80211_crypto_settings(rdev, info, &req.crypto, 1);
 	if (!err) {
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 935dea9..2ada3ee 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -10,7 +10,9 @@
 #include <net/cfg80211.h>
 #include <net/ip.h>
 #include <net/dsfield.h>
+#include <net/ndisc.h>
 #include <linux/if_vlan.h>
+#include <linux/if_arp.h>
 #include "core.h"
 #include "rdev-ops.h"
 
@@ -1472,3 +1474,53 @@ EXPORT_SYMBOL(rfc1042_header);
 const unsigned char bridge_tunnel_header[] __aligned(2) =
 	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
 EXPORT_SYMBOL(bridge_tunnel_header);
+
+bool cfg80211_is_gratuitous_arp_unsolicited_na(struct sk_buff *skb)
+{
+	const struct ethhdr *eth = (void *)skb->data;
+	const struct {
+		struct arphdr hdr;
+		u8 ar_sha[ETH_ALEN];
+		u8 ar_sip[4];
+		u8 ar_tha[ETH_ALEN];
+		u8 ar_tip[4];
+	} __packed *arp;
+	const struct ipv6hdr *ipv6;
+	const struct icmp6hdr *icmpv6;
+
+	switch (eth->h_proto) {
+	case cpu_to_be16(ETH_P_ARP):
+		/* can't say - but will probably be dropped later anyway */
+		if (skb->len < sizeof(*eth) + sizeof(*arp))
+			return false;
+
+		arp = (void *)(eth + 1);
+
+		if ((arp->hdr.ar_op == cpu_to_be16(ARPOP_REPLY) ||
+		     arp->hdr.ar_op == cpu_to_be16(ARPOP_REQUEST)) &&
+		    !memcmp(arp->ar_sip, arp->ar_tip, sizeof(arp->ar_sip)))
+			return true;
+		break;
+	case cpu_to_be16(ETH_P_IPV6):
+		/* can't say - but will probably be dropped later anyway */
+		if (skb->len < sizeof(*eth) + sizeof(*ipv6) + sizeof(*icmpv6))
+			return false;
+
+		ipv6 = (void *)(eth + 1);
+		icmpv6 = (void *)(ipv6 + 1);
+
+		if (icmpv6->icmp6_type == NDISC_NEIGHBOUR_ADVERTISEMENT &&
+		    !memcmp(&ipv6->saddr, &ipv6->daddr, sizeof(ipv6->saddr)))
+			return true;
+		break;
+	default:
+		/*
+		 * no need to support other protocols, proxy service isn't
+		 * specified for any others
+		 */
+		break;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL(cfg80211_is_gratuitous_arp_unsolicited_na);
-- 
1.8.4.rc3

