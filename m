Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from edge01.uni-rostock.de ([139.30.8.12]:32077 "EHLO
        edge01.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752955AbdIHOQr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 10:16:47 -0400
Content-Type: text/plain
From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [RFC 1/4] mac80211_hwsim: changed hwsim_radios from list to hashlist keyed by MAC-Address
Date: Fri, 8 Sep 2017 16:11:34 +0200
MIME-Version: 1.0
Message-ID: <9df35571-bc40-4af0-8a4f-01ba400dbb50@MAIL1.uni-rostock.de> (sfid-20170908_161759_567609_9F66BAC0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use hashlist to improve lookup speed for every received NL-message,
especially for higher counts of radios, like 100 or more. The stringhash
should be neglible for 6 Bytes MAC-Address, could be improved by using
cast to 64bit integer and hash this instead.

For a more reliable implementation of radio dump, a generation count is inserted,
which indicates a change while dump (this was missing before and could lead into problems because of inconsistent NL-dumps).

Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 180 +++++++++++++++++++++++++---------
 1 file changed, 136 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index c8852acc1462..aeeea7a35404 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -32,6 +32,8 @@
 #include <net/genetlink.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
+#include <linux/hashtable.h>
+#include <linux/stringhash.h>
 #include "mac80211_hwsim.h"
 
 #define WARN_QUEUE 100
@@ -487,9 +489,19 @@ static const struct ieee80211_iface_combination hwsim_if_comb_p2p_dev[] = {
 	},
 };
 
+#define HWSIM_HT_BITS 7
+static unsigned long mac_hash_salt = 0;
+
+static unsigned int hash_mac(const u8 *mac )
+{
+	return full_name_hash(&mac_hash_salt,mac,ETH_ALEN);
+}
+
+
 static spinlock_t hwsim_radio_lock;
-static LIST_HEAD(hwsim_radios);
-static int hwsim_radio_idx;
+static DEFINE_HASHTABLE(hwsim_radios,HWSIM_HT_BITS);
+static int hwsim_radio_count;
+static int hwsim_radio_generation=1;
 
 static struct platform_driver mac80211_hwsim_driver = {
 	.driver = {
@@ -498,7 +510,7 @@ static struct platform_driver mac80211_hwsim_driver = {
 };
 
 struct mac80211_hwsim_data {
-	struct list_head list;
+	struct hlist_node list;
 	struct ieee80211_hw *hw;
 	struct device *dev;
 	struct ieee80211_supported_band bands[NUM_NL80211_BANDS];
@@ -1179,6 +1191,7 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 					  struct ieee80211_channel *chan)
 {
 	struct mac80211_hwsim_data *data = hw->priv, *data2;
+	int bucket;
 	bool ack = false;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1240,7 +1253,7 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 
 	/* Copy skb to all enabled radios that are on the current frequency */
 	spin_lock(&hwsim_radio_lock);
-	list_for_each_entry(data2, &hwsim_radios, list) {
+	hash_for_each( hwsim_radios, bucket, data2, list) {
 		struct sk_buff *nskb;
 		struct tx_iter_data tx_iter_data = {
 			.receive = false,
@@ -2458,23 +2471,68 @@ static void hwsim_mcast_new_radio(int id, struct genl_info *info,
 	nlmsg_free(mcast_skb);
 }
 
+struct mac_address create_mac_from_idx(int idx)
+{
+	struct mac_address mac;
+	eth_zero_addr(mac.addr);
+	mac.addr[0] = 0x42;
+	mac.addr[3] = idx >> 8;
+	mac.addr[4] = idx;
+	return mac;
+
+}
+
 static int mac80211_hwsim_new_radio(struct genl_info *info,
 				    struct hwsim_new_radio_params *param)
 {
 	int err;
-	u8 addr[ETH_ALEN];
+	struct mac_address mac;
 	struct mac80211_hwsim_data *data;
 	struct ieee80211_hw *hw;
 	enum nl80211_band band;
 	const struct ieee80211_ops *ops = &mac80211_hwsim_ops;
 	struct net *net;
-	int idx;
+	int idx,hashkey;
+	bool new_id_found=true;
+
 
 	if (WARN_ON(param->channels > 1 && !param->use_chanctx))
 		return -EINVAL;
 
 	spin_lock_bh(&hwsim_radio_lock);
-	idx = hwsim_radio_idx++;
+
+
+	if(param->idx == -1){
+		idx = hwsim_radio_count;
+
+	}
+	else{
+		idx = param->idx;
+	}
+
+	do{
+	mac = create_mac_from_idx(idx);
+	hashkey = hash_mac(mac.addr);
+		hash_for_each_possible(hwsim_radios,data,list,hashkey){
+			if (data->idx == idx) {
+				if (param->idx != -1) {
+					printk(KERN_ERR "mac80211_hwsim: given idx %d "
+							"is already in use", param->idx);
+					spin_unlock_bh(&hwsim_radio_lock);
+					return -EINVAL;
+				}
+				else {
+					//try next index for new radio
+					++idx;
+					new_id_found = false;
+					break;
+				}
+			}
+
+		}
+
+	} while (new_id_found);
+
 	spin_unlock_bh(&hwsim_radio_lock);
 
 	if (param->use_chanctx)
@@ -2727,7 +2785,9 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 			     CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 
 	spin_lock_bh(&hwsim_radio_lock);
-	list_add_tail(&data->list, &hwsim_radios);
+	hash_add(hwsim_radios,&data->list,hash_mac(data->addresses[1].addr));
+	++hwsim_radio_generation;
+	++hwsim_radio_count;
 	spin_unlock_bh(&hwsim_radio_lock);
 
 	if (idx > 0)
@@ -2836,16 +2896,16 @@ static int mac80211_hwsim_get_radio(struct sk_buff *skb,
 static void mac80211_hwsim_free(void)
 {
 	struct mac80211_hwsim_data *data;
-
+	int bucket;
 	spin_lock_bh(&hwsim_radio_lock);
-	while ((data = list_first_entry_or_null(&hwsim_radios,
-						struct mac80211_hwsim_data,
-						list))) {
-		list_del(&data->list);
-		spin_unlock_bh(&hwsim_radio_lock);
-		mac80211_hwsim_del_radio(data, wiphy_name(data->hw->wiphy),
-					 NULL);
-		spin_lock_bh(&hwsim_radio_lock);
+	if (!hash_empty(hwsim_radios)) {
+		hash_for_each(hwsim_radios, bucket, data, list){
+			hash_del(&data->list);
+			spin_unlock_bh(&hwsim_radio_lock);
+			mac80211_hwsim_del_radio(data, wiphy_name(data->hw->wiphy),
+			NULL);
+			spin_lock_bh(&hwsim_radio_lock);
+		}
 	}
 	spin_unlock_bh(&hwsim_radio_lock);
 	class_destroy(hwsim_class);
@@ -2873,8 +2933,10 @@ static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(const u8 *addr)
 	struct mac80211_hwsim_data *data;
 	bool _found = false;
 
+	unsigned int hash = hash_mac(addr);
+
 	spin_lock_bh(&hwsim_radio_lock);
-	list_for_each_entry(data, &hwsim_radios, list) {
+	hash_for_each_possible(hwsim_radios,data,list,hash){
 		if (memcmp(data->addresses[1].addr, addr, ETH_ALEN) == 0) {
 			_found = true;
 			break;
@@ -2891,11 +2953,12 @@ static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(const u8 *addr)
 static void hwsim_register_wmediumd(struct net *net, u32 portid)
 {
 	struct mac80211_hwsim_data *data;
+	int bucket;
 
 	hwsim_net_set_wmediumd(net, portid);
 
 	spin_lock_bh(&hwsim_radio_lock);
-	list_for_each_entry(data, &hwsim_radios, list) {
+	hash_for_each(hwsim_radios, bucket, data, list) {
 		if (data->netgroup == hwsim_net_get_netgroup(net))
 			data->wmediumd = portid;
 	}
@@ -3080,10 +3143,11 @@ static int hwsim_register_received_nl(struct sk_buff *skb_2,
 {
 	struct net *net = genl_info_net(info);
 	struct mac80211_hwsim_data *data;
+	int bucket;
 	int chans = 1;
 
 	spin_lock_bh(&hwsim_radio_lock);
-	list_for_each_entry(data, &hwsim_radios, list)
+	hash_for_each(hwsim_radios, bucket, data, list)
 		chans = max(chans, data->channels);
 	spin_unlock_bh(&hwsim_radio_lock);
 
@@ -3155,6 +3219,7 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 static int hwsim_del_radio_nl(struct sk_buff *msg, struct genl_info *info)
 {
 	struct mac80211_hwsim_data *data;
+	int bucket;
 	s64 idx = -1;
 	const char *hwname = NULL;
 
@@ -3170,7 +3235,7 @@ static int hwsim_del_radio_nl(struct sk_buff *msg, struct genl_info *info)
 		return -EINVAL;
 
 	spin_lock_bh(&hwsim_radio_lock);
-	list_for_each_entry(data, &hwsim_radios, list) {
+	hash_for_each(hwsim_radios, bucket, data, list) {
 		if (idx >= 0) {
 			if (data->idx != idx)
 				continue;
@@ -3183,7 +3248,9 @@ static int hwsim_del_radio_nl(struct sk_buff *msg, struct genl_info *info)
 		if (!net_eq(wiphy_net(data->hw->wiphy), genl_info_net(info)))
 			continue;
 
-		list_del(&data->list);
+		hash_del(&data->list);
+		--hwsim_radio_count;
+		++hwsim_radio_generation;
 		spin_unlock_bh(&hwsim_radio_lock);
 		mac80211_hwsim_del_radio(data, wiphy_name(data->hw->wiphy),
 					 info);
@@ -3199,6 +3266,7 @@ static int hwsim_del_radio_nl(struct sk_buff *msg, struct genl_info *info)
 static int hwsim_get_radio_nl(struct sk_buff *msg, struct genl_info *info)
 {
 	struct mac80211_hwsim_data *data;
+	int bucket;
 	struct sk_buff *skb;
 	int idx, res = -ENODEV;
 
@@ -3207,7 +3275,7 @@ static int hwsim_get_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	idx = nla_get_u32(info->attrs[HWSIM_ATTR_RADIO_ID]);
 
 	spin_lock_bh(&hwsim_radio_lock);
-	list_for_each_entry(data, &hwsim_radios, list) {
+	hash_for_each(hwsim_radios,bucket, data, list) {
 		if (data->idx != idx)
 			continue;
 
@@ -3240,34 +3308,53 @@ static int hwsim_get_radio_nl(struct sk_buff *msg, struct genl_info *info)
 static int hwsim_dump_radio_nl(struct sk_buff *skb,
 			       struct netlink_callback *cb)
 {
-	int idx = cb->args[0];
+	int previous_idx = cb->args[0];
+	int bucket;
 	struct mac80211_hwsim_data *data = NULL;
 	int res;
+	bool previous_idx_reached;
 
 	spin_lock_bh(&hwsim_radio_lock);
 
-	if (idx == hwsim_radio_idx)
+	cb->seq = hwsim_radio_generation;
+
+	/* cb->args[3] = #radios already dumped*/
+	if (cb->args[1] == hwsim_radio_count )
 		goto done;
 
-	list_for_each_entry(data, &hwsim_radios, list) {
-		if (data->idx < idx)
+	/* No radios dumped yet, send already first valid entry*/
+	if(cb->args[1]==0){
+		previous_idx_reached=true;
+	}
+	else{
+		previous_idx_reached=false;
+	}
+
+	hash_for_each(hwsim_radios,bucket,data,list){
+		if(!previous_idx_reached && data->idx != previous_idx){
 			continue;
+		}
+		else{
+			previous_idx_reached=true;
+		}
 
 		if (!net_eq(wiphy_net(data->hw->wiphy), sock_net(skb->sk)))
-			continue;
+					continue;
 
 		res = mac80211_hwsim_get_radio(skb, data,
-					       NETLINK_CB(cb->skb).portid,
-					       cb->nlh->nlmsg_seq, cb,
-					       NLM_F_MULTI);
-		if (res < 0)
-			break;
-
-		idx = data->idx + 1;
+							       NETLINK_CB(cb->skb).portid,
+							       cb->nlh->nlmsg_seq, cb,
+							       NLM_F_MULTI);
+		if (res < 0){
+			cb->args[0]=data->idx;
+			goto done;
+		}
+		else{
+			++cb->args[1];
+		}
 	}
-
-	cb->args[0] = idx;
-
+	//leaving loop without goto, there is no radio left, cancel dump
+	cb->args[1] = hwsim_radio_count;
 done:
 	spin_unlock_bh(&hwsim_radio_lock);
 	return skb->len;
@@ -3333,12 +3420,14 @@ static void destroy_radio(struct work_struct *work)
 
 static void remove_user_radios(u32 portid)
 {
-	struct mac80211_hwsim_data *entry, *tmp;
+	struct mac80211_hwsim_data *entry;
+	struct hlist_node *tmp;
+	int bucket;
 
 	spin_lock_bh(&hwsim_radio_lock);
-	list_for_each_entry_safe(entry, tmp, &hwsim_radios, list) {
+	hash_for_each_safe(hwsim_radios,bucket,tmp, entry, list) {
 		if (entry->destroy_on_close && entry->portid == portid) {
-			list_del(&entry->list);
+			hash_del(&entry->list);
 			INIT_WORK(&entry->destroy_work, destroy_radio);
 			schedule_work(&entry->destroy_work);
 		}
@@ -3402,10 +3491,13 @@ static __net_init int hwsim_init_net(struct net *net)
 
 static void __net_exit hwsim_exit_net(struct net *net)
 {
-	struct mac80211_hwsim_data *data, *tmp;
+	struct mac80211_hwsim_data *data;
+	struct hlist_node *tmp;
+	int bucket;
 
 	spin_lock_bh(&hwsim_radio_lock);
-	list_for_each_entry_safe(data, tmp, &hwsim_radios, list) {
+
+	hash_for_each_safe(hwsim_radios,bucket,tmp,data,list)  {
 		if (!net_eq(wiphy_net(data->hw->wiphy), net))
 			continue;
 
@@ -3413,7 +3505,7 @@ static void __net_exit hwsim_exit_net(struct net *net)
 		if (data->netgroup == hwsim_net_get_netgroup(&init_net))
 			continue;
 
-		list_del(&data->list);
+		hash_del(&data->list);
 		INIT_WORK(&data->destroy_work, destroy_radio);
 		schedule_work(&data->destroy_work);
 	}
-- 
2.14.1
