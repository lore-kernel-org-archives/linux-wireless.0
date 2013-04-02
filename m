Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51824 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab3DBXp3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 19:45:29 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r32NjSNH027085
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 2 Apr 2013 16:45:28 -0700
Message-ID: <515B6D98.4060303@candelatech.com> (sfid-20130403_014533_732333_9EEA2246)
Date: Tue, 02 Apr 2013 16:45:28 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RFC:  Hashing by VIF addr for rx of data packets.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I notice that the rx logic currently walks through all stations when a NIC receives
a packet.

With the attached patch, total TCP download throughput goes from 70Mbps to 190Mbps on
my test system (Atom 1.6Ghz) with 50 station VIFs receiving TCP data streams.

The basic idea is to hash on the VIF addr (ie, what you see in 'ifconfig wlan0' as MAC
address), and then look up stations using the hdr->addr1 in the rx logic.

The attached patch probably breaks monitor interfaces and other VIFs other than AP and
STA.  It also changes the behaviour of PROMISC, but I'm not sure that is bad (is
the old behaviour needed for anything useful?)

I'm thinking to store a count of all VIF types on a radio, and make
this hash code only be enabled when only STA and AP exist.  Maybe later optimize
so we can quickly find monitor or other VIF types to handle them properly.

Comments and suggestions are welcome.

Thanks,
Ben


diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b985722..84f1b73 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -985,7 +985,8 @@ struct ieee80211_local {
  	spinlock_t tim_lock;
  	unsigned long num_sta;
  	struct list_head sta_list;
-	struct sta_info __rcu *sta_hash[STA_HASH_SIZE];
+	struct sta_info __rcu *sta_hash[STA_HASH_SIZE]; /* By station addr */
+	struct sta_info __rcu *sta_vhash[STA_HASH_SIZE]; /* By VIF mac addr */
  	struct timer_list sta_cleanup;
  	int sta_generation;

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c6844ad..1fbf5b4 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3152,6 +3152,20 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
  	if (ieee80211_is_data(fc)) {
  		prev_sta = NULL;

+		/* If we have only station and AP interfaces, then hash on
+		 * the destination MAC (ie, local sdata MAC).  Could add other
+		 * device types as well, perhaps.  This changes 'promisc' behaviour,
+		 * but not sure that is a bad thing.
+		 */
+		if (!is_multicast_ether_addr(hdr->addr1)) {
+			sta = sta_info_get_by_vif(local, hdr->addr1);
+			if (sta) {
+				rx.sta = sta;
+				rx.sdata = sta->sdata;
+				goto rx_and_done;
+			}
+		}
+
  		for_each_sta_info(local, hdr->addr2, sta, tmp) {
  			if (!prev_sta) {
  				prev_sta = sta;
@@ -3169,6 +3183,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
  			rx.sta = prev_sta;
  			rx.sdata = prev_sta->sdata;

+		rx_and_done:
  			if (ieee80211_prepare_and_rx_handle(&rx, skb, true))
  				return;
  			goto out;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index c465b1d..ff7ac08 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -77,19 +77,42 @@ static int sta_info_hash_del(struct ieee80211_local *local,
  	s = rcu_dereference_protected(local->sta_hash[STA_HASH(sta->sta.addr)],
  				      lockdep_is_held(&local->sta_mtx));
  	if (!s)
-		return -ENOENT;
+		goto try_lhash;
+	
  	if (s == sta) {
  		rcu_assign_pointer(local->sta_hash[STA_HASH(sta->sta.addr)],
  				   s->hnext);
-		return 0;
+		goto try_lhash;
  	}

  	while (rcu_access_pointer(s->hnext) &&
  	       rcu_access_pointer(s->hnext) != sta)
  		s = rcu_dereference_protected(s->hnext,
-					lockdep_is_held(&local->sta_mtx));
+					      lockdep_is_held(&local->sta_mtx));
  	if (rcu_access_pointer(s->hnext)) {
  		rcu_assign_pointer(s->hnext, sta->hnext);
+		goto try_lhash;
+	}
+
+	/* Remove from the local VIF addr hash */
+try_lhash:
+	s = rcu_dereference_protected(local->sta_vhash[STA_HASH(sta->sdata->vif.addr)],
+				      lockdep_is_held(&local->sta_mtx));
+	if (!s)
+		return -ENONET;
+	
+	if (s == sta) {
+		rcu_assign_pointer(local->sta_vhash[STA_HASH(sta->sdata->vif.addr)],
+				   s->vnext);
+		return 0;
+	}
+
+	while (rcu_access_pointer(s->vnext) &&
+	       rcu_access_pointer(s->vnext) != sta)
+		s = rcu_dereference_protected(s->vnext,
+					      lockdep_is_held(&local->sta_mtx));
+	if (rcu_access_pointer(s->vnext)) {
+		rcu_assign_pointer(s->vnext, sta->vnext);
  		return 0;
  	}

@@ -251,6 +274,22 @@ struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
  	return sta;
  }

+struct sta_info *sta_info_get_by_vif(struct ieee80211_local *local,
+				     const u8 *addr) {
+	struct sta_info *sta;
+
+	sta = rcu_dereference_check(local->sta_vhash[STA_HASH(addr)],
+				    lockdep_is_held(&local->sta_mtx));
+	while (sta) {
+		if (ether_addr_equal(sta->sdata->vif.addr, addr))
+			break;
+		sta = rcu_dereference_check(sta->vnext,
+					    lockdep_is_held(&local->sta_mtx));
+	}
+	return sta;
+}
+
+
  struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
  				     int idx)
  {
@@ -300,6 +339,9 @@ static void sta_info_hash_add(struct ieee80211_local *local,
  	sta->hnext = local->sta_hash[STA_HASH(sta->sta.addr)];
  	rcu_assign_pointer(local->sta_hash[STA_HASH(sta->sta.addr)], sta);

+	sta->vnext = local->sta_vhash[STA_HASH(sta->sdata->vif.addr)];
+	rcu_assign_pointer(local->sta_vhash[STA_HASH(sta->sdata->vif.addr)], sta);
+
  	rcu_assign_pointer(sta->sdata->some_sta, sta);
  }

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 4947341..d2a53ae 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -227,7 +227,8 @@ struct sta_ampdu_mlme {
   * mac80211 is communicating with.
   *
   * @list: global linked list entry
- * @hnext: hash table linked list pointer
+ * @hnext: hash table linked list pointer, by (remote) station MAC
+ * @vnext: hash table linked list pointer, by VIF MAC
   * @local: pointer to the global information
   * @sdata: virtual interface this station belongs to
   * @ptk: peer key negotiated with this station, if any
@@ -304,6 +305,7 @@ struct sta_info {
  	struct list_head list;
  	struct rcu_head rcu_head;
  	struct sta_info __rcu *hnext;
+	struct sta_info __rcu *vnext;
  	struct ieee80211_local *local;
  	struct ieee80211_sub_if_data *sdata;
  	struct ieee80211_key __rcu *gtk[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
@@ -507,6 +509,9 @@ struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
  struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
  				  const u8 *addr);

+struct sta_info *sta_info_get_by_vif(struct ieee80211_local *local,
+				     const u8 *addr);
+
  static inline
  void for_each_sta_info_type_check(struct ieee80211_local *local,
  				  const u8 *addr,


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

