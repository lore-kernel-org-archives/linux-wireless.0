Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:34529 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933854AbcBQLzt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 06:55:49 -0500
Received: by mail-lb0-f181.google.com with SMTP id of3so7987407lbc.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2016 03:55:48 -0800 (PST)
From: Grzegorz Bajorski <grzegorz.bajorski@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Grzegorz Bajorski <grzegorz.bajorski@tieto.com>
Subject: [RFC] mac80211: add extap functionality
Date: Wed, 17 Feb 2016 12:55:31 +0100
Message-Id: <1455710131-9967-1-git-send-email-grzegorz.bajorski@tieto.com> (sfid-20160217_125554_733900_CC3CA13B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Client interface briding was only possible when 4addr frames were used with
a 4addr/WDS aware AP. It was not possible to do it otherwise due to 3addr
frame limitation.

The extap logic introduces a smart MAC address masking/translation
(including modyfing packets beyond SA/DA, e.g. DHCP broadcast flag is set).

There are still some unsolved problems and bugs:
 - due to bridge port routing and sk_buff payload sharing skb_copy() is
   performed; this ideally should be reworked
 - ipv6 support is still not finished
 - extap is enabled by default currently; it should be configurable via
   nl80211 the same way 4addr is

There's also an idea to move this as a generic link driver (just like
macvlan, et al) which would allow unmodified cfg80211 drivers to enjoy the
extap functionality. Thoughts?

Note: This changes cfg80211 file in this single patch only for reviewing
convienence.

This is an early draft to solicit comments on the design.

Signed-off-by: Grzegorz Bajorski <grzegorz.bajorski@tieto.com>
---
 net/mac80211/Makefile      |   3 +-
 net/mac80211/extap.c       | 440 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/extap.h       |  31 ++++
 net/mac80211/ieee80211_i.h |   2 +
 net/mac80211/iface.c       |   3 +
 net/mac80211/rx.c          |   5 +
 net/mac80211/tx.c          |  11 ++
 net/wireless/core.c        |   2 +
 8 files changed, 496 insertions(+), 1 deletion(-)
 create mode 100644 net/mac80211/extap.c
 create mode 100644 net/mac80211/extap.h

diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index f9137a8..e3d7fd7 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -30,7 +30,8 @@ mac80211-y := \
 	chan.o \
 	trace.o mlme.o \
 	tdls.o \
-	ocb.o
+	ocb.o \
+	extap.o
 
 mac80211-$(CONFIG_MAC80211_LEDS) += led.o
 mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
diff --git a/net/mac80211/extap.c b/net/mac80211/extap.c
new file mode 100644
index 0000000..852f2a0
--- /dev/null
+++ b/net/mac80211/extap.c
@@ -0,0 +1,440 @@
+ /*
+  * Copyright (c) 2016, Qualcomm Atheros Inc.
+  *
+  * Permission to use, copy, modify, and/or distribute this software for any
+  * purpose with or without fee is hereby granted, provided that the above
+  * copyright notice and this permission notice appear in all copies.
+  *
+  * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+  * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+  * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+  * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+  * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+  * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+  */
+
+#include "extap.h"
+#include <linux/if_ether.h>
+#include <linux/kernel.h>
+#include <linux/etherdevice.h>
+#include <linux/if_arp.h>
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/udp.h>
+#include <net/ip.h>
+#include <net/udp.h>
+#include <net/ndisc.h>
+#include <uapi/linux/ip.h>
+#include <uapi/linux/udp.h>
+
+#define EXPIRY_SEC 600
+#define UDP_DST_PORT 67
+#define IPV4_ADDR_LEN 4
+#define IPV6_ADDR_LEN 16
+
+#define DHCP_MSG_BOOTREQ 1
+#define DHCP_FLAG_BCAST 0x8000
+#define DHCP_COOKIE 0x63825363
+#define EXTAP_MAX_ENTRIES 512
+
+struct ip4arp {
+	struct arphdr hdr;
+	u8 ar_sha[ETH_ALEN];
+	u8 ar_sip[4];
+	u8 ar_dha[ETH_ALEN];
+	u8 ar_tip[4];
+} __packed;
+
+struct dhcphdr {
+	u8     dhcp_msg_type;
+	u8     dhcp_hw_type;
+	u8     dhcp_hw_addr_len;
+	u8     dhcp_num_hops;
+	__be32 dhcp_transc_id;
+	__be16 dhcp_secs_elapsed;
+	__be16 dhcp_flags;
+	__be32 dhcp_ciaddr;
+	__be32 dhcp_yiaddr;
+	__be32 dhcp_siaddr_nip;
+	__be32 dhcp_gateway_nip;
+	u8     dhcp_chaddr[16];
+	u8     dhcp_sname[64];
+	u8     dhcp_file[128];
+	__be32 dhcp_cookie;
+} __packed;
+
+static int extap_arp_has_ip4(struct arphdr *arp)
+{
+	return arp->ar_hln == ETH_ALEN && arp->ar_pln == IPV4_ADDR_LEN;
+}
+
+static struct ip4arp *extap_ip4arp(struct sk_buff *skb)
+{
+	struct arphdr *arp = arp_hdr(skb);
+
+	if (!arp)
+		return NULL;
+
+	if (!extap_arp_has_ip4(arp))
+		return NULL;
+
+	return (void *)arp;
+}
+
+static void extap_dhcp_hack(struct sk_buff *skb)
+{
+	struct iphdr *ip = ip_hdr(skb);
+	struct udphdr *udp = udp_hdr(skb);
+	struct dhcphdr *dhcp;
+
+	if (!ip)
+		return;
+
+	if (!udp)
+		return;
+
+	if (ip->protocol != IPPROTO_UDP)
+		return;
+
+	if (udp->dest != cpu_to_be16(UDP_DST_PORT))
+		return;
+
+	dhcp = (void *)udp + sizeof(*udp);
+
+	if (WARN_ON_ONCE(dhcp->dhcp_cookie != cpu_to_be32(DHCP_COOKIE)))
+		return;
+
+	if (dhcp->dhcp_msg_type != DHCP_MSG_BOOTREQ)
+		return;
+
+	dhcp->dhcp_flags |= cpu_to_be16(DHCP_FLAG_BCAST);
+
+	udp->check = 0;
+	udp->check = csum_tcpudp_magic(ip->saddr,
+				       ip->daddr,
+				       be16_to_cpu(udp->len),
+				       IPPROTO_UDP,
+				       csum_partial((void *)udp,
+						    be16_to_cpu(udp->len),
+						    0));
+}
+
+static struct extap_entry *extap_lookup(struct extap *extap,
+					const void *addr,
+					size_t addr_len)
+{
+	struct extap_entry *i;
+
+	lockdep_assert_held(&extap->lock);
+
+	list_for_each_entry(i, &extap->entries, list)
+		if (i->addr_len == addr_len &&
+		    !memcmp(addr, (void *)&i->addr, addr_len))
+			return i;
+
+	return NULL;
+}
+
+static void extap_gc(struct extap *extap)
+{
+	struct extap_entry *i;
+	struct extap_entry *tmp;
+
+	lockdep_assert_held(&extap->lock);
+
+	list_for_each_entry_safe(i, tmp, &extap->entries, list) {
+		if (time_after(jiffies, i->expiry)) {
+			list_del(&i->list);
+			kfree(i);
+			extap->num_entries--;
+		}
+	}
+}
+
+static void extap_bump_expiry(struct extap_entry *entry)
+{
+	entry->expiry = jiffies + msecs_to_jiffies(EXPIRY_SEC * MSEC_PER_SEC);
+}
+
+static void extap_bump_expiry_by_addr(struct extap *extap,
+				      void *addr,
+				      size_t addr_len)
+{
+	struct extap_entry *entry;
+
+	lockdep_assert_held(&extap->lock);
+
+	entry = extap_lookup(extap, addr, addr_len);
+	if (entry)
+		extap_bump_expiry(entry);
+}
+
+static void extap_entry_create(struct extap *extap,
+			       const void *mac,
+			       const void *addr,
+			       size_t addr_len)
+{
+	struct extap_entry *entry;
+
+	extap_gc(extap);
+
+	if (extap->num_entries >= EXTAP_MAX_ENTRIES)
+		return;
+
+	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
+	if (!entry)
+		return;
+
+	INIT_LIST_HEAD(&entry->list);
+	entry->addr_len = addr_len;
+	ether_addr_copy(entry->mac, mac);
+	memcpy(entry->addr, addr, addr_len);
+
+	list_add_tail(&entry->list, &extap->entries);
+	extap->num_entries++;
+}
+
+static void extap_learn_ipv6(struct extap *extap, struct sk_buff *skb)
+{
+	struct ethhdr *eth = eth_hdr(skb);
+	struct ipv6hdr *ip6 = ipv6_hdr(skb);
+	struct icmp6hdr *icmp6 = icmp6_hdr(skb);
+	struct extap_entry *entry;
+	void *addr;
+
+	if (ip6->nexthdr != NEXTHDR_ICMP)
+		return;
+
+	switch (icmp6->icmp6_type) {
+	case NDISC_NEIGHBOUR_SOLICITATION:
+	case NDISC_NEIGHBOUR_ADVERTISEMENT:
+		addr = ip6->daddr.in6_u.u6_addr8;
+		break;
+	default:
+		return;
+	}
+
+	entry = extap_lookup(extap, addr, IPV6_ADDR_LEN);
+	if (entry) {
+		extap_bump_expiry(entry);
+		ether_addr_copy(entry->mac, eth->h_source);
+		return;
+	}
+
+	extap_entry_create(extap, eth->h_source, addr, IPV6_ADDR_LEN);
+}
+
+static void extap_learn(struct extap *extap, struct sk_buff *skb)
+{
+	struct ethhdr *eth = eth_hdr(skb);
+	struct iphdr *ip;
+	struct ip4arp *arp;
+
+	lockdep_assert_held(&extap->lock);
+
+	switch (be16_to_cpu(eth->h_proto)) {
+	case ETH_P_ARP:
+		arp = extap_ip4arp(skb);
+		if (!arp)
+			break;
+
+		if (be16_to_cpu(arp->hdr.ar_op) != ARPOP_REQUEST &&
+		    be16_to_cpu(arp->hdr.ar_op) != ARPOP_RREQUEST)
+			break;
+
+		extap_entry_create(extap, eth->h_source, arp->ar_sip,
+				   IPV4_ADDR_LEN);
+		break;
+	case ETH_P_IP:
+		extap_dhcp_hack(skb);
+
+		ip = ip_hdr(skb);
+		if (ip)
+			extap_bump_expiry_by_addr(extap, &ip->saddr,
+						  IPV4_ADDR_LEN);
+		break;
+	case ETH_P_IPV6:
+		extap_learn_ipv6(extap, skb);
+		break;
+	default:
+		break;
+	}
+}
+
+static void extap_put_entry_da(struct sk_buff *skb, void *mac)
+{
+	struct ethhdr *eth = eth_hdr(skb);
+	struct ip4arp *arp;
+
+	switch (be16_to_cpu(eth->h_proto)) {
+	case ETH_P_ARP:
+		arp = extap_ip4arp(skb);
+		if (arp)
+			ether_addr_copy(arp->ar_dha, mac);
+		break;
+	}
+
+	ether_addr_copy(eth->h_dest, mac);
+}
+
+static void extap_xlate_sa_arp(struct extap *extap, struct sk_buff *skb)
+{
+	struct ethhdr *eth = eth_hdr(skb);
+	struct ip4arp *arp;
+
+	arp = extap_ip4arp(skb);
+	if (!arp)
+		return;
+
+	switch (be16_to_cpu(arp->hdr.ar_op)) {
+	case ARPOP_REQUEST:
+	case ARPOP_REPLY:
+	case ARPOP_RREQUEST:
+	case ARPOP_RREPLY:
+		ether_addr_copy(arp->ar_sha, extap->addr);
+		break;
+	}
+
+	ether_addr_copy(eth->h_source, extap->addr);
+}
+
+static void extap_xlate_sa_ipv4(struct extap *extap, struct sk_buff *skb)
+{
+	struct ethhdr *eth = eth_hdr(skb);
+
+	ether_addr_copy(eth->h_source, extap->addr);
+}
+
+static void extap_xlate_sa_ipv6(struct extap *extap, struct sk_buff *skb)
+{
+	struct ethhdr *eth = eth_hdr(skb);
+	struct ipv6hdr *ip6 = ipv6_hdr(skb);
+	struct nd_msg *nd = (void *)icmp6_hdr(skb);
+	struct nd_opt_hdr *opt;
+	void *addr;
+
+	if (ip6->nexthdr != NEXTHDR_ICMP)
+		return;
+
+	switch (nd->icmph.icmp6_type) {
+	case NDISC_NEIGHBOUR_ADVERTISEMENT:
+	case NDISC_NEIGHBOUR_SOLICITATION:
+		opt = (void *)nd->opt;
+		addr = (void *)opt + sizeof(*opt);
+		ether_addr_copy(addr, extap->addr);
+
+		nd->icmph.icmp6_cksum = 0;
+		nd->icmph.icmp6_cksum = csum_ipv6_magic(&ip6->saddr,
+							&ip6->daddr,
+							be16_to_cpu(ip6->payload_len),
+							IPPROTO_ICMPV6,
+							csum_partial((void *)nd,
+								     be16_to_cpu(ip6->payload_len),
+								     0));
+		break;
+	}
+
+	ether_addr_copy(eth->h_source, extap->addr);
+}
+
+void extap_xlate_sa(struct extap *extap, struct sk_buff *skb)
+{
+	struct ethhdr *eth = eth_hdr(skb);
+
+	spin_lock_bh(&extap->lock);
+	extap_learn(extap, skb);
+	spin_unlock_bh(&extap->lock);
+
+	switch (be16_to_cpu(eth->h_proto)) {
+	case ETH_P_ARP:
+		extap_xlate_sa_arp(extap, skb);
+		break;
+	case ETH_P_IP:
+		extap_xlate_sa_ipv4(extap, skb);
+		break;
+	case ETH_P_IPV6:
+		extap_xlate_sa_ipv6(extap, skb);
+		break;
+	}
+}
+
+void extap_xlate_da(struct extap *extap, struct sk_buff *skb)
+{
+	struct ethhdr *eth = eth_hdr(skb);
+	struct extap_entry *entry;
+	struct ip4arp *arp;
+	struct iphdr *iphdr = NULL;
+	struct ipv6hdr *ip6 = NULL;
+	size_t addr_len = 0;
+	u8 mcast[ETH_ALEN] = {0};
+	__be32 ip4;
+	void *addr;
+	void *mac;
+
+	switch (be16_to_cpu(eth->h_proto)) {
+	case ETH_P_ARP:
+		arp = extap_ip4arp(skb);
+		if (arp) {
+			addr_len = IPV4_ADDR_LEN;
+			addr = arp->ar_tip;
+		}
+		break;
+	case ETH_P_IP:
+		iphdr = ip_hdr(skb);
+		if (iphdr) {
+			addr_len = IPV4_ADDR_LEN;
+			addr = &iphdr->daddr;
+		}
+		break;
+	case ETH_P_IPV6:
+		ip6 = ipv6_hdr(skb);
+		if (ip6) {
+			addr_len = IPV6_ADDR_LEN;
+			addr = ip6->daddr.in6_u.u6_addr8;
+		}
+		break;
+	}
+
+	if (addr_len == 0)
+		return;
+
+	spin_lock_bh(&extap->lock);
+
+	entry = extap_lookup(extap, addr, addr_len);
+	if (entry) {
+		mac = entry->mac;
+	} else if (addr_len == IPV4_ADDR_LEN &&
+		   is_unicast_ether_addr(eth->h_dest)) {
+		memcpy(&ip4, addr, addr_len);
+		ip_eth_mc_map(ip4, mcast);
+		mac = mcast;
+	} else {
+		mac = NULL;
+	}
+
+	if (mac)
+		extap_put_entry_da(skb, mac);
+
+	spin_unlock_bh(&extap->lock);
+}
+
+void extap_init(struct extap *extap, const u8 addr[ETH_ALEN])
+{
+	INIT_LIST_HEAD(&extap->entries);
+	ether_addr_copy(extap->addr, addr);
+	spin_lock_init(&extap->lock);
+}
+
+void extap_fini(struct extap *extap)
+{
+	struct extap_entry *i;
+	struct extap_entry *tmp;
+
+	list_for_each_entry_safe(i, tmp, &extap->entries, list) {
+		list_del(&i->list);
+		kfree(i);
+	}
+
+	extap->num_entries = 0;
+}
diff --git a/net/mac80211/extap.h b/net/mac80211/extap.h
new file mode 100644
index 0000000..f918a23
--- /dev/null
+++ b/net/mac80211/extap.h
@@ -0,0 +1,31 @@
+#ifndef _EXTAP_H
+#define _EXTAP_H
+
+#include <uapi/linux/if_ether.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+
+struct sk_buff;
+struct net_device;
+
+struct extap_entry {
+	struct list_head list;
+	size_t addr_len;
+	u8 mac[ETH_ALEN] __aligned(sizeof(u16));
+	u8 addr[16];
+	unsigned long expiry;
+};
+
+struct extap {
+	u8 addr[ETH_ALEN] __aligned(sizeof(u16));
+	struct list_head entries;
+	unsigned int num_entries;
+	spinlock_t lock; /* protects entries */
+};
+
+void extap_xlate_sa(struct extap *extap, struct sk_buff *skb);
+void extap_xlate_da(struct extap *extap, struct sk_buff *skb);
+void extap_init(struct extap *extap, const u8 addr[ETH_ALEN]);
+void extap_fini(struct extap *extap);
+
+#endif /* _EXPAT_H */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a49c103..6c1ecf5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -30,6 +30,7 @@
 #include <net/ieee80211_radiotap.h>
 #include <net/cfg80211.h>
 #include <net/mac80211.h>
+#include "extap.h"
 #include "key.h"
 #include "sta_info.h"
 #include "debug.h"
@@ -814,6 +815,7 @@ struct ieee80211_sub_if_data {
 	struct list_head list;
 
 	struct wireless_dev wdev;
+	struct extap extap;
 
 	/* keys */
 	struct list_head key_list;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 453b4e74..71a3c74f 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1094,6 +1094,8 @@ static void ieee80211_teardown_sdata(struct ieee80211_sub_if_data *sdata)
 
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_rmc_free(sdata);
+
+	extap_fini(&sdata->extap);
 }
 
 static void ieee80211_uninit(struct net_device *dev)
@@ -1401,6 +1403,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	INIT_WORK(&sdata->csa_finalize_work, ieee80211_csa_finalize_work);
 	INIT_LIST_HEAD(&sdata->assigned_chanctx_list);
 	INIT_LIST_HEAD(&sdata->reserved_chanctx_list);
+	extap_init(&sdata->extap, sdata->dev->dev_addr);
 
 	switch (type) {
 	case NL80211_IFTYPE_P2P_GO:
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9127957..f5ae4eb 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -33,6 +33,7 @@
 #include "tkip.h"
 #include "wme.h"
 #include "rate.h"
+#include "extap.h"
 
 static inline void ieee80211_rx_stats(struct net_device *dev, u32 len)
 {
@@ -2168,7 +2169,11 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 	if (skb) {
 		/* deliver to local stack */
 		skb->protocol = eth_type_trans(skb, dev);
+		skb_reset_network_header(skb);
 		memset(skb->cb, 0, sizeof(skb->cb));
+
+		extap_xlate_da(&sdata->extap, skb);
+
 		if (rx->napi)
 			napi_gro_receive(rx->napi, skb);
 		else
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7bb67fa..2b29d73 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -34,6 +34,7 @@
 #include "wpa.h"
 #include "wme.h"
 #include "rate.h"
+#include "extap.h"
 
 /* misc utils */
 
@@ -3012,6 +3013,16 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 				       struct net_device *dev)
 {
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct sk_buff *tmp_skb;
+
+	/* XXX: This is a hack. Only to check if solves ARP problem. */
+	tmp_skb = skb;
+	skb = skb_copy(tmp_skb, GFP_ATOMIC);
+	kfree_skb(tmp_skb);
+
+	extap_xlate_sa(&sdata->extap, skb);
+
 	__ieee80211_subif_start_xmit(skb, dev, 0);
 	return NETDEV_TX_OK;
 }
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 3a9c41b..d2464f6 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1037,10 +1037,12 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		/* allow mac80211 to determine the timeout */
 		wdev->ps_timeout = -1;
 
+#if 0
 		if ((wdev->iftype == NL80211_IFTYPE_STATION ||
 		     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT ||
 		     wdev->iftype == NL80211_IFTYPE_ADHOC) && !wdev->use_4addr)
 			dev->priv_flags |= IFF_DONT_BRIDGE;
+#endif
 		break;
 	case NETDEV_GOING_DOWN:
 		cfg80211_leave(rdev, wdev);
-- 
2.3.7

