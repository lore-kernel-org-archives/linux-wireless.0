Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:34942 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752232AbcJEEzc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 00:55:32 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: johannes@sipsolutions.net
Cc: Michael Braun <michael-dev@fami-braun.de>,
        linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Subject: [PATCH 3/3] mac80211: multicast to unicast conversion
Date: Wed,  5 Oct 2016 06:55:24 +0200
Message-Id: <1475643324-2845-3-git-send-email-michael-dev@fami-braun.de> (sfid-20161005_065537_398300_0A54745B)
In-Reply-To: <1475643324-2845-1-git-send-email-michael-dev@fami-braun.de>
References: <1475643324-2845-1-git-send-email-michael-dev@fami-braun.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for sending multicast data packets with ARP, IPv4 and
IPv6 payload (possible 802.1q tagged) as 802.11 unicast frames to all stations.

IEEE 802.11 multicast has well known issues, among them:
 1. packets are not acked and hence not retransmitted, resulting in decreased
    reliablity
 2. packets are send at low rate, increasing time required on air

When used with AP_VLAN, there is another disadvantage:
 3. all stations in the BSS are woken up, regardsless of their AP_VLAN
    assignment.

By doing multicast to unicast conversion, all three issus are solved.

IEEE802.11-2012 proposes directed multicast service (DMS) using A-MSDU frames
and a station initiated control protocol. It has the advantage that the station
can recover the destination multicast mac address, but it is not backward
compatible with non QOS stations and does not enable the administrator of a BSS
to force this mode of operation within a BSS. Additionally, it would require
both the ap and the station to implement the control protocol, which is
optional on both ends. Furthermore, I've seen a few mobile phone stations
locally that indicate qos support but won't complete DHCP if their broadcasts
are encapsulated as A-MSDU. Though they work fine with this series approach.

This patch therefore does not opt to implement DMS but instead just replicates
the packet and changes the destination address. As this works fine with ARP,
IPv4 and IPv6, it is limited to these protocols and normal 802.11 multicast
frames are send out for all other payload protocols.

There is a runtime toggle to enable multicast conversion in a per-bss fashion.

When there is only a single station assigned to the AP_VLAN interface, no
packet replication will occur. 4addr mode of operation is unchanged.

This change opts for iterating all BSS stations for finding the stations
assigned to this AP/AP_VLAN interface, as there currently is no per AP_VLAN
list to iterate and multicast packets are expected to be few. If needed, such
a list could be added later.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>

--
v3: fix compile error for trace.h
v2: add nl80211 toggle
    rename tx_dnat to change_da
    change int to bool unicast
---
 include/net/cfg80211.h        |   5 ++
 include/uapi/linux/nl80211.h  |   7 +++
 net/mac80211/cfg.c            |  14 ++++++
 net/mac80211/debugfs_netdev.c |  29 ++++++++++++
 net/mac80211/ieee80211_i.h    |   1 +
 net/mac80211/tx.c             | 103 ++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c        |  33 ++++++++++++++
 net/wireless/rdev-ops.h       |  11 +++++
 net/wireless/trace.h          |  19 ++++++++
 9 files changed, 222 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d768fcd..89049d9 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2460,6 +2460,8 @@ struct cfg80211_qos_map {
  *
  * @set_wds_peer: set the WDS peer for a WDS interface
  *
+ * @set_ap_unicast: set the multicast to unicast flag for a AP interface
+ *
  * @rfkill_poll: polls the hw rfkill line, use cfg80211 reporting
  *	functions to adjust rfkill hw state
  *
@@ -2722,6 +2724,9 @@ struct cfg80211_ops {
 	int	(*set_wds_peer)(struct wiphy *wiphy, struct net_device *dev,
 				const u8 *addr);
 
+	int	(*set_ap_unicast)(struct wiphy *wiphy, struct net_device *dev,
+				  const bool unicast);
+
 	void	(*rfkill_poll)(struct wiphy *wiphy);
 
 #ifdef CONFIG_NL80211_TESTMODE
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 2206941..cfbeebc 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -599,6 +599,9 @@
  *
  * @NL80211_CMD_SET_WDS_PEER: Set the MAC address of the peer on a WDS interface.
  *
+ * @NL80211_CMD_SET_AP_UNICAST: Set the multicast to unicast toggle on a AP
+ *                              interface.
+ *
  * @NL80211_CMD_JOIN_MESH: Join a mesh. The mesh ID must be given, and initial
  *	mesh config parameters may be given.
  * @NL80211_CMD_LEAVE_MESH: Leave the mesh network -- no special arguments, the
@@ -1026,6 +1029,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_ABORT_SCAN,
 
+	NL80211_CMD_SET_AP_UNICAST,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2261,6 +2266,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MESH_PEER_AID,
 
+	NL80211_ATTR_UNICAST,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1edb017..a543e46 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2242,6 +2242,19 @@ static int ieee80211_set_wds_peer(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static int ieee80211_set_ap_unicast(struct wiphy *wiphy, struct net_device *dev,
+				    const bool unicast)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (sdata->vif.type != NL80211_IFTYPE_AP)
+		return -1;
+
+	sdata->u.ap.unicast = unicast;
+
+	return 0;
+}
+
 static void ieee80211_rfkill_poll(struct wiphy *wiphy)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
@@ -3400,6 +3413,7 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.set_tx_power = ieee80211_set_tx_power,
 	.get_tx_power = ieee80211_get_tx_power,
 	.set_wds_peer = ieee80211_set_wds_peer,
+	.set_ap_unicast = ieee80211_set_ap_unicast,
 	.rfkill_poll = ieee80211_rfkill_poll,
 	CFG80211_TESTMODE_CMD(ieee80211_testmode_cmd)
 	CFG80211_TESTMODE_DUMP(ieee80211_testmode_dump)
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 7fe468e..03ff0ab 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -487,6 +487,34 @@ static ssize_t ieee80211_if_fmt_num_buffered_multicast(
 }
 IEEE80211_IF_FILE_R(num_buffered_multicast);
 
+static ssize_t
+ieee80211_if_fmt_unicast(const struct ieee80211_sub_if_data *sdata,
+			 char *buf, int buflen)
+{
+	const struct ieee80211_if_ap *ifap = &sdata->u.ap;
+
+	return snprintf(buf, buflen, "0x%x\n", ifap->unicast);
+}
+
+static ssize_t
+ieee80211_if_parse_unicast(struct ieee80211_sub_if_data *sdata,
+			   const char *buf, int buflen)
+{
+	struct ieee80211_if_ap *ifap = &sdata->u.ap;
+	u8 val;
+	int ret;
+
+	ret = kstrtou8(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	ifap->unicast = val ? 1 : 0;
+
+	return buflen;
+}
+
+IEEE80211_IF_FILE_RW(unicast);
+
 /* IBSS attributes */
 static ssize_t ieee80211_if_fmt_tsf(
 	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
@@ -642,6 +670,7 @@ static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(dtim_count);
 	DEBUGFS_ADD(num_buffered_multicast);
 	DEBUGFS_ADD_MODE(tkip_mic_test, 0200);
+	DEBUGFS_ADD_MODE(unicast, 0600);
 }
 
 static void add_vlan_files(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 933688e..99f990a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -293,6 +293,7 @@ struct ieee80211_if_ap {
 			 driver_smps_mode; /* smps mode request */
 
 	struct work_struct request_smps_work;
+	bool unicast;
 };
 
 struct ieee80211_if_wds {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index aed375f..b230aa2 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/skbuff.h>
+#include <linux/if_vlan.h>
 #include <linux/etherdevice.h>
 #include <linux/bitmap.h>
 #include <linux/rcupdate.h>
@@ -1770,6 +1771,104 @@ bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_tx_prepare_skb);
 
+/* rewrite destination mac address */
+static int ieee80211_change_da(struct sk_buff *skb, struct sta_info *sta)
+{
+	struct ethhdr *eth;
+	int err;
+
+	err = skb_ensure_writable(skb, ETH_HLEN);
+	if (unlikely(err))
+		return err;
+
+	eth = (void *)skb->data;
+	ether_addr_copy(eth->h_dest, sta->sta.addr);
+
+	return 0;
+}
+
+/* Check if multicast to unicast conversion is needed and do it.
+ * Returns 1 if skb was freed and should not be send out. */
+static int
+ieee80211_tx_multicast_to_unicast(struct ieee80211_sub_if_data *sdata,
+				  struct sk_buff *skb, u32  info_flags)
+{
+	struct ieee80211_local *local = sdata->local;
+	const struct ethhdr *eth = (void *)skb->data;
+	const struct vlan_ethhdr *ethvlan = (void *)skb->data;
+	struct sta_info *sta, *prev = NULL;
+	struct sk_buff *cloned_skb;
+	u16 ethertype;
+
+	/* multicast to unicast conversion only for AP interfaces */
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_AP_VLAN:
+		sta = rcu_dereference(sdata->u.vlan.sta);
+		if (sta) /* 4addr */
+			return 0;
+	case NL80211_IFTYPE_AP:
+		break;
+	default:
+		return 0;
+	}
+
+	/* check runtime toggle for this bss */
+	if (!sdata->bss->unicast)
+		return 0;
+
+	/* check if this is a multicast frame */
+	if (!is_multicast_ether_addr(eth->h_dest))
+		return 0;
+
+	/* info_flags would not get preserved, used only by TLDS */
+	if (info_flags)
+		return 0;
+
+	/* multicast to unicast conversion only for some payload */
+	ethertype = ntohs(eth->h_proto);
+	if (ethertype == ETH_P_8021Q && skb->len >= VLAN_ETH_HLEN)
+		ethertype = ntohs(ethvlan->h_vlan_encapsulated_proto);
+	switch (ethertype) {
+	case ETH_P_ARP:
+	case ETH_P_IP:
+	case ETH_P_IPV6:
+		break;
+	default:
+		return 0;
+	}
+
+	/* clone packets and update destination mac */
+	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		if (sdata != sta->sdata)
+			continue;
+		if (unlikely(!memcmp(eth->h_source, sta->sta.addr, ETH_ALEN)))
+			/* do not send back to source */
+			continue;
+		if (unlikely(is_multicast_ether_addr(sta->sta.addr))) {
+			WARN_ONCE(1, "sta with multicast address %pM",
+				  sta->sta.addr);
+			continue;
+		}
+		if (prev) {
+			cloned_skb = skb_clone(skb, GFP_ATOMIC);
+			if (likely(!ieee80211_change_da(cloned_skb, prev)))
+				ieee80211_subif_start_xmit(cloned_skb,
+							   cloned_skb->dev);
+			else
+				dev_kfree_skb(cloned_skb);
+		}
+		prev = sta;
+	}
+
+	if (likely(prev)) {
+		ieee80211_change_da(skb, prev);
+		return 0;
+	}
+
+	/* no STA connected, drop */
+	return 1;
+}
+
 /*
  * Returns false if the frame couldn't be transmitted but was queued instead.
  */
@@ -3353,6 +3452,10 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 
 	rcu_read_lock();
 
+	/* AP multicast to unicast conversion */
+	if (ieee80211_tx_multicast_to_unicast(sdata, skb, info_flags))
+		goto out_free;
+
 	if (ieee80211_lookup_ra_sta(sdata, skb, &sta))
 		goto out_free;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f02653a..2eefee7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -409,6 +409,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 		.len = VHT_MUMIMO_GROUPS_DATA_LEN
 	},
 	[NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR] = { .len = ETH_ALEN },
+	[NL80211_ATTR_UNICAST] = { .type = NLA_U8, },
 };
 
 /* policy for the key attributes */
@@ -1538,6 +1539,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 				goto nla_put_failure;
 		}
 		CMD(set_wds_peer, SET_WDS_PEER);
+		CMD(set_ap_unicast, SET_AP_UNICAST);
 		if (rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS) {
 			CMD(tdls_mgmt, TDLS_MGMT);
 			CMD(tdls_oper, TDLS_OPER);
@@ -2164,6 +2166,29 @@ static int nl80211_set_wds_peer(struct sk_buff *skb, struct genl_info *info)
 	return rdev_set_wds_peer(rdev, dev, bssid);
 }
 
+static int nl80211_set_ap_unicast(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	bool unicast;
+
+	if (!info->attrs[NL80211_ATTR_UNICAST])
+		return -EINVAL;
+
+	if (netif_running(dev))
+		return -EBUSY;
+
+	if (!rdev->ops->set_ap_unicast)
+		return -EOPNOTSUPP;
+
+	if (wdev->iftype != NL80211_IFTYPE_AP)
+		return -EOPNOTSUPP;
+
+	unicast = nla_data(info->attrs[NL80211_ATTR_UNICAST]);
+	return rdev_set_ap_unicast(rdev, dev, unicast);
+}
+
 static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev;
@@ -11574,6 +11599,14 @@ static const struct genl_ops nl80211_ops[] = {
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
+		.cmd = NL80211_CMD_SET_AP_UNICAST,
+		.doit = nl80211_set_ap_unicast,
+		.policy = nl80211_policy,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
 		.cmd = NL80211_CMD_JOIN_MESH,
 		.doit = nl80211_join_mesh,
 		.policy = nl80211_policy,
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 85ff30b..af3ca14 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -562,6 +562,17 @@ static inline int rdev_set_wds_peer(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_set_ap_unicast(struct cfg80211_registered_device *rdev,
+				      struct net_device *dev,
+				      const bool unicast)
+{
+	int ret;
+	trace_rdev_set_ap_unicast(&rdev->wiphy, dev, unicast);
+	ret = rdev->ops->set_ap_unicast(&rdev->wiphy, dev, unicast);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 static inline void rdev_rfkill_poll(struct cfg80211_registered_device *rdev)
 {
 	trace_rdev_rfkill_poll(&rdev->wiphy);
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 72b5255..6016821 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2940,6 +2940,25 @@ DEFINE_EVENT(wiphy_wdev_evt, rdev_abort_scan,
 	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
 	TP_ARGS(wiphy, wdev)
 );
+
+TRACE_EVENT(rdev_set_ap_unicast,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 const bool unicast),
+	TP_ARGS(wiphy, netdev, unicast),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(bool, unicast)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->unicast = unicast;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", unicast: %s",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG,
+		  BOOL_TO_STR(__entry->unicast))
+);
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.1.4
