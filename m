Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:62264 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbaEOTG6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 15:06:58 -0400
From: Kyeyoon Park <kyeyoonp@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <jouni@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: [RFC] cfg80211/mac80211: Add support for Proxy ARP
Date: Thu, 15 May 2014 12:06:24 -0700
Message-ID: <1400180784-26008-1-git-send-email-kyeyoonp@qca.qualcomm.com> (sfid-20140515_210704_048339_F7BFE1BB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Proxy ARP allows the AP devices to keep track of the hardware address
to IP address mapping of the STA devices within the BSS. When a request
for such information is made (i.e. ARP request, Neighbor Solicitation),
the AP will respond on behalf of the STA device within the BSS. Such
requests could originate from a device within the BSS or also from the
bridge. In the process of the AP replying to the request (i.e. ARP
reply, Neighbor Advertisement), the AP will drop the original request
frame. The relevant STA will not even know that such information was
ever requested.

This feature is a requirement for Hotspot 2.0. This feature is defined
in IEEE Std 802.11-2012, 10.23.13. This particular commit will
eventually be split into two separate commits (cfg80211 and mac80211
separately). This commit implements one part of the feature, dynamic
IPv4 addresses and ARP. Additional commits will be made to support
static IPv4 addresses and IPv6.

Signed-off-by: Kyeyoon Park <kyeyoonp@qca.qualcomm.com>
---
 include/net/cfg80211.h       |   2 +
 include/net/mac80211.h       |   2 +
 include/uapi/linux/nl80211.h |   8 ++
 net/mac80211/cfg.c           |   1 +
 net/mac80211/debug.h         |  10 ++
 net/mac80211/ieee80211_i.h   |   1 +
 net/mac80211/main.c          |   3 +-
 net/mac80211/sta_info.c      | 100 +++++++++++++++++++
 net/mac80211/sta_info.h      |  14 +++
 net/mac80211/tx.c            | 229 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       |   6 ++
 11 files changed, 375 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f2c3186..07cba1d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -668,6 +668,7 @@ struct cfg80211_acl_data {
  * @p2p_opp_ps: P2P opportunistic PS
  * @acl: ACL configuration used by the drivers which has support for
  *	MAC address based access control
+ * @proxy_arp: the proxy ARP enable flag for the AP
  */
 struct cfg80211_ap_settings {
 	struct cfg80211_chan_def chandef;
@@ -685,6 +686,7 @@ struct cfg80211_ap_settings {
 	u8 p2p_ctwindow;
 	bool p2p_opp_ps;
 	const struct cfg80211_acl_data *acl;
+	bool proxy_arp;
 };
 
 /**
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 451c1bf..c329ee9 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -337,6 +337,7 @@ enum ieee80211_rssi_event {
  * @hidden_ssid: The SSID of the current vif is hidden. Only valid in AP-mode.
  * @txpower: TX power in dBm
  * @p2p_noa_attr: P2P NoA attribute for P2P powersave
+ * @proxy_arp: This is a Proxy ARP enabled BSS.
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
@@ -372,6 +373,7 @@ struct ieee80211_bss_conf {
 	bool hidden_ssid;
 	int txpower;
 	struct ieee80211_p2p_noa_attr p2p_noa_attr;
+	bool proxy_arp;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9922b9b..f2d212c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1583,6 +1583,9 @@ enum nl80211_commands {
  *	creation then the new interface will be owned by the netlink socket
  *	that created it and will be destroyed when the socket is closed
  *
+ * @NL80211_ATTR_PROXY_ARP: A flag indicating that the AP device has proxy ARP
+ *	enabled. This should not be enabled for a non-AP device.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1920,6 +1923,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_IFACE_SOCKET_OWNER,
 
+	NL80211_ATTR_PROXY_ARP,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3934,6 +3939,8 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE: This driver supports dynamic
  *	channel bandwidth change (e.g., HT 20 <-> 40 MHz channel) during the
  *	lifetime of a BSS.
+ * @NL80211_FEATURE_AP_PROXY_ARP: This driver supports proxy ARP. This feature
+ *	is for AP mode only.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3955,6 +3962,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_USERSPACE_MPM			= 1 << 16,
 	NL80211_FEATURE_ACTIVE_MONITOR			= 1 << 17,
 	NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE	= 1 << 18,
+	NL80211_FEATURE_AP_PROXY_ARP			= 1 << 19,
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7b8d3cf..d69906d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1013,6 +1013,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
 	sdata->vif.bss_conf.dtim_period = params->dtim_period;
 	sdata->vif.bss_conf.enable_beacon = true;
+	sdata->vif.bss_conf.proxy_arp = params->proxy_arp;
 
 	sdata->vif.bss_conf.ssid_len = params->ssid_len;
 	if (params->ssid_len)
diff --git a/net/mac80211/debug.h b/net/mac80211/debug.h
index 493d680..2f985d9 100644
--- a/net/mac80211/debug.h
+++ b/net/mac80211/debug.h
@@ -74,6 +74,12 @@
 #define MAC80211_MLME_DEBUG 0
 #endif
 
+#ifdef CONFIG_MAC80211_PROXYARP_DEBUG
+#define MAC80211_PROXYARP_DEBUG 1
+#else
+#define MAC80211_PROXYARP_DEBUG 0
+#endif
+
 #ifdef CONFIG_MAC80211_MESSAGE_TRACING
 void __sdata_info(const char *fmt, ...) __printf(1, 2);
 void __sdata_dbg(bool print, const char *fmt, ...) __printf(2, 3);
@@ -187,4 +193,8 @@ do {									\
 	_sdata_dbg(MAC80211_MLME_DEBUG && net_ratelimit(),		\
 		   sdata, fmt, ##__VA_ARGS__)
 
+#define proxyarp_dbg(sdata, fmt, ...)					\
+	_sdata_dbg(MAC80211_PROXYARP_DEBUG && net_ratelimit(),		\
+		   sdata, fmt, ##__VA_ARGS__)
+
 #endif /* __MAC80211_DEBUG_H */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 487c2ef..9241b03 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1093,6 +1093,7 @@ struct ieee80211_local {
 	unsigned long num_sta;
 	struct list_head sta_list;
 	struct sta_info __rcu *sta_hash[STA_HASH_SIZE];
+	struct sta_info __rcu *sta_ipv4hash[STA_IPV4_HASH_SIZE];
 	struct timer_list sta_cleanup;
 	int sta_generation;
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 27b9364..bfd586b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -548,7 +548,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 			   NL80211_FEATURE_SAE |
 			   NL80211_FEATURE_HT_IBSS |
 			   NL80211_FEATURE_VIF_TXPOWER |
-			   NL80211_FEATURE_USERSPACE_MPM;
+			   NL80211_FEATURE_USERSPACE_MPM |
+			   NL80211_FEATURE_AP_PROXY_ARP;
 
 	if (!ops->hw_scan)
 		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 632d372..be9ba33 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -194,6 +194,29 @@ struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 	return sta;
 }
 
+struct sta_info *sta_info_get_ipv4(struct ieee80211_sub_if_data *sdata,
+				   __be32 ipv4_addr)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+
+	mutex_lock(&local->sta_mtx);
+
+	sta = rcu_dereference_check(local->
+				    sta_ipv4hash[STA_IPV4_HASH(ipv4_addr)],
+				    lockdep_is_held(&local->sta_mtx));
+	while (sta) {
+		if (sta->sdata == sdata && sta->ipv4_addr == ipv4_addr)
+			break;
+		sta = rcu_dereference_check(sta->ipv4hnext,
+					    lockdep_is_held(&local->sta_mtx));
+	}
+
+	mutex_unlock(&local->sta_mtx);
+
+	return sta;
+}
+
 struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
 				     int idx)
 {
@@ -583,6 +606,81 @@ int sta_info_insert(struct sta_info *sta)
 	return err;
 }
 
+static int __sta_info_ipv4hash_del(struct ieee80211_local *local,
+				   struct sta_info *sta)
+{
+	struct sta_info *s;
+	int idx = STA_IPV4_HASH(sta->ipv4_addr);
+
+	if (!sta->ipv4_addr)
+		return -ENOENT;
+
+	s = rcu_dereference_protected(local->sta_ipv4hash[idx],
+		lockdep_is_held(&local->sta_mtx));
+	if (!s)
+		return -ENOENT;
+
+	if (s == sta) {
+		rcu_assign_pointer(local->sta_ipv4hash[idx],
+				   s->ipv4hnext);
+		sta->ipv4_addr = 0;
+		return 0;
+	}
+
+	while (rcu_access_pointer(s->ipv4hnext) &&
+	       rcu_access_pointer(s->ipv4hnext) != sta)
+		s = rcu_dereference_protected(s->ipv4hnext,
+					lockdep_is_held(&local->sta_mtx));
+
+	if (rcu_access_pointer(s->ipv4hnext)) {
+		rcu_assign_pointer(s->ipv4hnext, sta->ipv4hnext);
+		sta->ipv4_addr = 0;
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
+void sta_info_ipv4hash_add_sta(struct sta_info *sta,
+			       __be32 ipv4_addr) __acquires(RCU)
+{
+	struct ieee80211_local *local = sta->local;
+	int idx = STA_IPV4_HASH(sta->ipv4_addr);
+
+	if (sta->ipv4_addr == ipv4_addr)
+		return;
+
+	might_sleep();
+
+	mutex_lock(&local->sta_mtx);
+
+	if (sta->ipv4_addr)
+		__sta_info_ipv4hash_del(local, sta);
+
+	lockdep_assert_held(&local->sta_mtx);
+	sta->ipv4hnext = local->sta_ipv4hash[idx];
+	sta->ipv4_addr = ipv4_addr;
+	rcu_assign_pointer(local->sta_ipv4hash[idx], sta);
+
+	mutex_unlock(&local->sta_mtx);
+}
+
+int sta_info_ipv4hash_remove_sta(struct sta_info *sta) __acquires(RCU)
+{
+	struct ieee80211_local *local = sta->local;
+	int err;
+
+	might_sleep();
+
+	mutex_lock(&local->sta_mtx);
+
+	err = __sta_info_ipv4hash_del(local, sta);
+
+	mutex_unlock(&local->sta_mtx);
+
+	return err;
+}
+
 static inline void __bss_tim_set(u8 *tim, u16 id)
 {
 	/*
@@ -849,6 +947,8 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 	set_sta_flag(sta, WLAN_STA_BLOCK_BA);
 	ieee80211_sta_tear_down_BA_sessions(sta, AGG_STOP_DESTROY_STA);
 
+	__sta_info_ipv4hash_del(local, sta);
+
 	ret = sta_info_hash_del(local, sta);
 	if (WARN_ON(ret))
 		return ret;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 4acc5fc..a6699b4 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -335,6 +335,7 @@ struct sta_info {
 	struct list_head list, free_list;
 	struct rcu_head rcu_head;
 	struct sta_info __rcu *hnext;
+	struct sta_info __rcu *ipv4hnext;
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_key __rcu *gtk[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
@@ -445,6 +446,10 @@ struct sta_info {
 	enum ieee80211_smps_mode known_smps_mode;
 	const struct ieee80211_cipher_scheme *cipher_scheme;
 
+	/* Proxy ARP IP address */
+	__be32 ipv4_addr;
+	unsigned long ipv4_lease_timeout;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
@@ -528,6 +533,8 @@ rcu_dereference_protected_tid_tx(struct sta_info *sta, int tid)
 #define STA_HASH_SIZE 256
 #define STA_HASH(sta) (sta[5])
 
+#define STA_IPV4_HASH_SIZE 32
+#define STA_IPV4_HASH(ipv4) (((u8 *)&ipv4)[3] & 0x1F)
 
 /* Maximum number of frames to buffer per power saving station per AC */
 #define STA_MAX_TX_BUFFER	64
@@ -549,6 +556,9 @@ struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
 struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 				  const u8 *addr);
 
+struct sta_info *sta_info_get_ipv4(struct ieee80211_sub_if_data *sdata,
+				   __be32 ipv4_addr);
+
 static inline
 void for_each_sta_info_type_check(struct ieee80211_local *local,
 				  const u8 *addr,
@@ -596,6 +606,10 @@ void sta_info_free(struct ieee80211_local *local, struct sta_info *sta);
  */
 int sta_info_insert(struct sta_info *sta);
 int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU);
+void sta_info_ipv4hash_add_sta(struct sta_info *sta,
+			       __be32 ipv4_addr) __acquires(RCU);
+int sta_info_ipv4hash_remove_sta(struct sta_info *sta) __acquires(RCU);
+
 
 int __must_check __sta_info_destroy(struct sta_info *sta);
 int sta_info_destroy_addr(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 19d36d4..9a20547 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -24,6 +24,8 @@
 #include <net/ieee80211_radiotap.h>
 #include <net/cfg80211.h>
 #include <net/mac80211.h>
+#include <net/arp.h>
+#include <net/ip.h>
 #include <asm/unaligned.h>
 
 #include "ieee80211_i.h"
@@ -194,6 +196,219 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
 }
 
 /* tx handlers */
+
+struct bootp_pkt {		/* BOOTP packet format */
+	struct iphdr iph;	/* IP header */
+	struct udphdr udph;	/* UDP header */
+	u8 op;			/* 1=request, 2=reply */
+	u8 htype;		/* HW address type */
+	u8 hlen;		/* HW address length */
+	u8 hops;		/* Used only by gateways */
+	__be32 xid;		/* Transaction ID */
+	__be16 secs;		/* Seconds since we started */
+	__be16 flags;		/* Just what it says */
+	__be32 client_ip;	/* Client's IP address if known */
+	__be32 your_ip;		/* Assigned IP address */
+	__be32 server_ip;	/* (Next, e.g. NFS) Server's IP address */
+	__be32 relay_ip;	/* IP address of BOOTP relay */
+	u8 hw_addr[16];		/* Client's HW address */
+	u8 serv_name[64];	/* Server host name */
+	u8 boot_file[128];	/* Name of boot file */
+	u8 exten[312];		/* DHCP options / BOOTP vendor extensions */
+};
+
+#define DHCPACK	5
+static const u8 ic_bootp_cookie[4] = { 99, 130, 83, 99 };
+
+static inline int ieee80211_proxyarp_arp(struct ieee80211_sub_if_data *sdata,
+					 struct sk_buff *skb)
+{
+	struct net_device *dev = sdata->dev;
+	struct ethhdr *eh = (struct ethhdr *)skb->data;
+	struct arphdr *arp = (struct arphdr *)(eh + 1);
+	int linear_len;
+	u8 *sha, *tha, *pos;
+	__be32 sip, tip;
+
+	linear_len = sizeof(struct ethhdr) + sizeof(struct arphdr);
+	if (!pskb_may_pull(skb, linear_len))
+		return 1;
+
+	pos = (unsigned char *)(arp + 1);
+	sha = pos;
+	pos += ETH_ALEN;
+	memcpy(&sip, pos, sizeof(__be32));
+	pos += sizeof(__be32);
+	tha = pos;
+	pos += ETH_ALEN;
+	memcpy(&tip, pos , sizeof(__be32));
+
+	if (arp->ar_op == htons(ARPOP_REQUEST)) {
+		struct sta_info *ssta, *tsta;
+
+		/* Proxy ARP request for the STAs within the BSS */
+		tsta = sta_info_get_ipv4(sdata, tip);
+		if (tsta && !tsta->ipv4_lease_timeout &&
+		    time_after(jiffies, tsta->ipv4_lease_timeout)) {
+			proxyarp_dbg(sdata,
+				     "Remove ARP entry: mac %pM-> ip %pI4 due to timeout. expired %lu, current %lu\n",
+				     tsta->sta.addr, &tip,
+				     tsta->ipv4_lease_timeout,
+				     jiffies);
+
+			sta_info_ipv4hash_remove_sta(tsta);
+
+		} else if (tsta && !ether_addr_equal(tsta->sta.addr, sha)) {
+			bool frombridge;
+
+			/* Drop G.ARP from both BSS and bridge */
+			if (tip == sip)
+				return 1;
+
+			/* Regular ARP Request, form ARP Reply */
+			ssta = sta_info_get(sdata, sha);
+			frombridge = ssta ? false : true;
+			tha = sha;
+			if (frombridge) {
+				struct sk_buff *skb;
+
+				skb = arp_create(ARPOP_REPLY, ETH_P_ARP, sip,
+						 dev, tip, sha, tsta->sta.addr,
+						 tha);
+				if (skb)
+					netif_rx(skb);
+			} else {
+				arp_send(ARPOP_REPLY, ETH_P_ARP, sip, dev, tip,
+					 sha, tsta->sta.addr, tha);
+			}
+			return 1;
+		}
+
+		/**
+		 * The ARP Request Target IP Address is not in our hash.
+		 *
+		 * Try to learn from the G.ARP requests
+		 */
+		if (tip == sip || sip == 0) {
+			/**
+			 * Learn ARP mapping from G.ARP request. Allow
+			 * the IPv4 address update from a later G.ARP
+			 * to overwrite a previous one.
+			 */
+			ssta = sta_info_get(sdata, sha);
+			if (ssta) {
+				sta_info_ipv4hash_add_sta(ssta, tip);
+				/**
+				 * If we receive a G.ARP for a previously
+				 * expired DHCP lease, change the lease type
+				 * to unlimited.
+				 */
+				if (ssta->ipv4_lease_timeout &&
+				    time_after(jiffies,
+					       ssta->ipv4_lease_timeout))
+					ssta->ipv4_lease_timeout = 0;
+			}
+		}
+
+		/* Suppress ARP Request within the BSS */
+		return 1;
+
+	} else if (arp->ar_op == htons(ARPOP_REPLY)) {
+		if (is_multicast_ether_addr(eh->h_dest))
+			return 1;
+	}
+
+	return 0;
+}
+
+static inline int ieee80211_proxyarp_ipv4(struct ieee80211_sub_if_data *sdata,
+					  struct sk_buff *skb)
+{
+	struct ethhdr *eh = (struct ethhdr *)skb->data;
+	struct bootp_pkt *b = (struct bootp_pkt *)(eh + 1);
+	struct sta_info *sta;
+	int len, linear_len, exten_len;
+
+	linear_len = sizeof(struct ethhdr) + sizeof(struct iphdr) +
+		     sizeof(struct udphdr) + 1;
+	if (!pskb_may_pull(skb, linear_len))
+		return 0;
+
+	/* Only downstream DHCP packets are relevant */
+	if (b->iph.protocol != IPPROTO_UDP ||
+	    b->udph.source != htons(67) ||
+	    b->udph.dest != htons(68) ||
+	    b->op != 2)
+		return 0;
+
+	if (skb->len < ntohs(b->iph.tot_len))
+		return 0;
+
+	if (ntohs(b->iph.tot_len) < ntohs(b->udph.len) + sizeof(struct iphdr))
+		return 0;
+
+	len = ntohs(b->udph.len) - sizeof(struct udphdr);
+	exten_len = len - (sizeof(*b) - sizeof(struct iphdr) -
+			 sizeof(struct udphdr) - sizeof(b->exten));
+	if (exten_len < 0)
+		return 0;
+
+	if (skb_linearize(skb))
+		return 0;
+
+	/* Parse DHCP options */
+	b = (struct bootp_pkt *)skb_network_header(skb);
+	if (exten_len >= 4 && !memcmp(b->exten, ic_bootp_cookie, 4)) {
+		u8 *end = (u8 *)b + ntohs(b->iph.tot_len);
+		u8 *pos = &b->exten[4];
+		int mt = 0;
+		u32 lease_time = 0;
+
+		while (pos < end && *pos != 0xff) {
+			u8 *opt = pos++;
+
+			if (*opt == 0) /* padding */
+				continue;
+
+			pos += *pos + 1;
+			if (pos >= end)
+				break;
+
+			switch (*opt) {
+			case 53: /* message type */
+				if (opt[1])
+					mt = opt[2];
+				break;
+
+			case 51: /* lease time */
+				if (opt[1] == 4)
+					lease_time =
+						get_unaligned_be32(&opt[2]);
+				break;
+			}
+		}
+
+		if (mt == DHCPACK) {
+			sta = sta_info_get(sdata, b->hw_addr);
+
+			/* DHCPACK for DHCPINFORM */
+			if (b->your_ip == 0)
+				return 0;
+
+			/* DHCPACK for DHCPREQUEST */
+			sta_info_ipv4hash_add_sta(sta, b->your_ip);
+
+			if (lease_time) {
+				sta->ipv4_lease_timeout =
+					msecs_to_jiffies(lease_time * 1000) +
+					jiffies;
+			} else
+				sta->ipv4_lease_timeout = 0;
+		}
+	}
+	return 0;
+}
+
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 {
@@ -1859,6 +2074,20 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 			chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 		if (!chanctx_conf)
 			goto fail_rcu;
+
+		if (unlikely(sdata->vif.bss_conf.proxy_arp)) {
+			switch (ethertype) {
+			case ETH_P_ARP:
+				if (ieee80211_proxyarp_arp(sdata, skb))
+					goto fail;
+				break;
+			case ETH_P_IP:
+				if (ieee80211_proxyarp_ipv4(sdata, skb))
+					goto fail;
+				break;
+			}
+		}
+
 		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS);
 		/* DA BSSID SA */
 		memcpy(hdr.addr1, skb->data, ETH_ALEN);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0f1b18f2..9624f3a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -382,6 +382,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_VENDOR_DATA] = { .type = NLA_BINARY },
 	[NL80211_ATTR_QOS_MAP] = { .type = NLA_BINARY,
 				   .len = IEEE80211_QOS_MAP_LEN_MAX },
+	[NL80211_ATTR_PROXY_ARP] = { .type = NLA_U8 },
 	[NL80211_ATTR_MAC_HINT] = { .len = ETH_ALEN },
 	[NL80211_ATTR_WIPHY_FREQ_HINT] = { .type = NLA_U32 },
 	[NL80211_ATTR_TDLS_PEER_CAPABILITY] = { .type = NLA_U32 },
@@ -3309,6 +3310,11 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 			return PTR_ERR(params.acl);
 	}
 
+	if (info->attrs[NL80211_ATTR_PROXY_ARP]) {
+		params.proxy_arp =
+			nla_get_u8(info->attrs[NL80211_ATTR_PROXY_ARP]);
+	}
+
 	wdev_lock(wdev);
 	err = rdev_start_ap(rdev, dev, &params);
 	if (!err) {
-- 
1.9.1

