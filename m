Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40139 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab3LBSwF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 13:52:05 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] cfg80211/mac80211: drop GTK-protected unicast IP packets
Date: Mon,  2 Dec 2013 19:51:56 +0100
Message-Id: <1386010316-2540-1-git-send-email-johannes@sipsolutions.net> (sfid-20131202_195209_635220_2008C9D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The GTK is shared by all stations in an 802.11 BSS and as such any
one of them can send forged group-addressed frames. To prevent this
kind of attack, drop unicast IP packets if they were protected with
the GTK, i.e. were multicast packets at the 802.11 layer.

Based in part on a patch by Jouni that did the same but in the IP
stack, which was considered too intrusive.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 13 +++++++++++--
 include/uapi/linux/nl80211.h |  6 ++++++
 net/mac80211/ieee80211_i.h   |  6 +++++-
 net/mac80211/mlme.c          |  2 ++
 net/mac80211/rx.c            | 35 +++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       |  4 ++++
 6 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e9abc7b..93175b0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1560,10 +1560,13 @@ struct cfg80211_auth_request {
  *
  * @ASSOC_REQ_DISABLE_HT:  Disable HT (802.11n)
  * @ASSOC_REQ_DISABLE_VHT:  Disable VHT
+ * @ASSOC_REQ_DROP_GROUP_PROTECTED_UNICAST: Drop protocol unicast packets
+ *	that were group-protected at the link layer.
  */
 enum cfg80211_assoc_req_flags {
-	ASSOC_REQ_DISABLE_HT		= BIT(0),
-	ASSOC_REQ_DISABLE_VHT		= BIT(1),
+	ASSOC_REQ_DISABLE_HT			= BIT(0),
+	ASSOC_REQ_DISABLE_VHT			= BIT(1),
+	ASSOC_REQ_DROP_GROUP_PROTECTED_UNICAST	= BIT(2),
 };
 
 /**
@@ -4417,6 +4420,12 @@ void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
  */
 void cfg80211_crit_proto_stopped(struct wireless_dev *wdev, gfp_t gfp);
 
+/**
+ * cfg80211_is_ip_unicast - check if packet is IP unicast
+ * @skb: skb, in 802.3 format
+ */
+bool cfg80211_is_ip_unicast(struct sk_buff *skb);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 129b7b0..bd4aa09 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1520,6 +1520,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_SUPPORT_10_MHZ: A flag indicating that the device supports
  *	10 MHz channel bandwidth.
  *
+ * @NL80211_ATTR_DROP_GROUP_PROTECTED_UNICAST: Drop protocol unicast packets
+ *	that were group protected at the wireless level. This flag attribute
+ *	is valid in the association command.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1839,6 +1843,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_SUPPORT_5_MHZ,
 	NL80211_ATTR_SUPPORT_10_MHZ,
 
+	NL80211_ATTR_DROP_GROUP_PROTECTED_UNICAST,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 32bae21..630b06c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -192,6 +192,8 @@ enum ieee80211_packet_rx_flags {
  * @IEEE80211_RX_CMNTR: received on cooked monitor already
  * @IEEE80211_RX_BEACON_REPORTED: This frame was already reported
  *	to cfg80211_report_obss_beacon().
+ * @IEEE80211_RX_DROP_IP_UNICAST: drop the frame later if it turns
+ *	out it contains IP unicast - it was group protected
  *
  * These flags are used across handling multiple interfaces
  * for a single frame.
@@ -199,6 +201,7 @@ enum ieee80211_packet_rx_flags {
 enum ieee80211_rx_flags {
 	IEEE80211_RX_CMNTR		= BIT(0),
 	IEEE80211_RX_BEACON_REPORTED	= BIT(1),
+	IEEE80211_RX_DROP_IP_UNICAST	= BIT(2),
 };
 
 struct ieee80211_rx_data {
@@ -706,7 +709,8 @@ struct ieee80211_sub_if_data {
 
 	unsigned long state;
 
-	int drop_unencrypted;
+	bool drop_unencrypted;
+	bool drop_group_protected_unicast;
 
 	char name[IFNAMSIZ];
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 33bcf80..986ab81 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4196,6 +4196,8 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	sdata->control_port_no_encrypt = req->crypto.control_port_no_encrypt;
 	sdata->encrypt_headroom = ieee80211_cs_headroom(local, &req->crypto,
 							sdata->vif.type);
+	sdata->drop_group_protected_unicast =
+		req->flags & ASSOC_REQ_DROP_GROUP_PROTECTED_UNICAST;
 
 	/* kick off associate process */
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5cf7285..c1ca4e2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -17,8 +17,10 @@
 #include <linux/etherdevice.h>
 #include <linux/rcupdate.h>
 #include <linux/export.h>
+#include <linux/ip.h>
 #include <net/mac80211.h>
 #include <net/ieee80211_radiotap.h>
+#include <net/addrconf.h>
 #include <asm/unaligned.h>
 
 #include "ieee80211_i.h"
@@ -1544,6 +1546,13 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 			    !is_multicast_ether_addr(hdr->addr1))
 				rx->key = NULL;
 		}
+
+		if (rx->key && is_multicast_ether_addr(hdr->addr1) &&
+		    rx->sdata->vif.type == NL80211_IFTYPE_STATION &&
+		    rx->sdata->drop_group_protected_unicast &&
+		    rx->key->conf.cipher != WLAN_CIPHER_SUITE_WEP40 &&
+		    rx->key->conf.cipher != WLAN_CIPHER_SUITE_WEP104)
+			rx->flags |= IEEE80211_RX_DROP_IP_UNICAST;
 	}
 
 	if (rx->key) {
@@ -1889,6 +1898,32 @@ __ieee80211_data_to_8023(struct ieee80211_rx_data *rx, bool *port_control)
 	else if (check_port_control)
 		return -1;
 
+	if (unlikely(rx->flags & IEEE80211_RX_DROP_IP_UNICAST)) {
+		union {
+			struct iphdr hdr4;
+			struct ipv6hdr hdr6;
+		} ip;
+
+		switch (ehdr->h_proto) {
+		case cpu_to_be16(ETH_P_IP):
+			if (rx->skb->len < sizeof(*ehdr) + sizeof(ip.hdr4))
+				return false;
+			skb_copy_bits(rx->skb, sizeof(*ehdr),
+				      &ip.hdr4, sizeof(ip.hdr4));
+			if (!ipv4_is_multicast(ip.hdr4.daddr))
+				return -1;
+			break;
+		case cpu_to_be16(ETH_P_IPV6):
+			if (rx->skb->len < sizeof(*ehdr) + sizeof(ip.hdr6))
+				return false;
+			skb_copy_bits(rx->skb, sizeof(*ehdr),
+				      &ip.hdr6, sizeof(ip.hdr6));
+			if (!ipv6_addr_is_multicast(&ip.hdr6.daddr))
+				return -1;
+			break;
+		}
+	}
+
 	return 0;
 }
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 95882a7..8f7d75e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -357,6 +357,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_STA_SUPPORTED_CHANNELS] = { .type = NLA_BINARY },
 	[NL80211_ATTR_STA_SUPPORTED_OPER_CLASSES] = { .type = NLA_BINARY },
 	[NL80211_ATTR_HANDLE_DFS] = { .type = NLA_FLAG },
+	[NL80211_ATTR_DROP_GROUP_PROTECTED_UNICAST] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -6362,6 +6363,9 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 		       sizeof(req.vht_capa));
 	}
 
+	if (info->attrs[NL80211_ATTR_DROP_GROUP_PROTECTED_UNICAST])
+		req.flags |= ASSOC_REQ_DROP_GROUP_PROTECTED_UNICAST;
+
 	err = nl80211_crypto_settings(rdev, info, &req.crypto, 1);
 	if (!err) {
 		wdev_lock(dev->ieee80211_ptr);
-- 
1.8.4.rc3

