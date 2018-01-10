Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.uni-rostock.de ([139.30.22.71]:64777 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965075AbeAJQno (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 11:43:44 -0500
From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [PATCH v3 2/5] mac80211_hwsim: add hashtable with mac address keys for faster lookup
Date: Wed, 10 Jan 2018 17:42:52 +0100
In-Reply-To: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
References: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <1d7bda28-6a77-4c4e-a3fc-3857b3c05aa1@MAIL2.uni-rostock.de> (sfid-20180110_174349_486900_4C5ADE93)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a rhastable for mac address lookup of hwsim radios. This
especially improve the speed on reception of a netlink message with a new
frame. Although redundant, we keep holding a normal list for all radios,
since the rhashtable_walk interface adds a lot of overhead for iterating
over all radios and the doc of rhashtable recommend a redundant structure
for stable walks in such situations.

Since rhashtable is rcu protected we do not need a lock for delivering
frames and thus improving this scenario.

Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 57 +++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 742a1551bb1c..55d25e3fbbcc 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -32,6 +32,7 @@
 #include <net/genetlink.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
+#include <linux/rhashtable.h>
 #include "mac80211_hwsim.h"
 
 #define WARN_QUEUE 100
@@ -490,6 +491,7 @@ static const struct ieee80211_iface_combination hwsim_if_comb_p2p_dev[] = {
 static spinlock_t hwsim_radio_lock;
 static LIST_HEAD(hwsim_radios);
 static struct workqueue_struct *hwsim_wq;
+static struct rhashtable hwsim_radios_rht;
 static int hwsim_radio_idx;
 
 static struct platform_driver mac80211_hwsim_driver = {
@@ -500,6 +502,7 @@ static struct platform_driver mac80211_hwsim_driver = {
 
 struct mac80211_hwsim_data {
 	struct list_head list;
+	struct rhash_head rht;
 	struct ieee80211_hw *hw;
 	struct device *dev;
 	struct ieee80211_supported_band bands[NUM_NL80211_BANDS];
@@ -574,6 +577,20 @@ struct mac80211_hwsim_data {
 	u64 tx_failed;
 };
 
+static u32 hwsim_table_hash(const void *addr, u32 len, u32 seed)
+{
+	/* Use last four bytes of hw addr as hash index */
+	return jhash_1word(*(u32 *)(addr + 2), seed);
+}
+
+static const struct rhashtable_params hwsim_rht_params = {
+	.nelem_hint = 2,
+	.automatic_shrinking = true,
+	.key_len = ETH_ALEN,
+	.key_offset = offsetof(struct mac80211_hwsim_data, addresses[1]),
+	.head_offset = offsetof(struct mac80211_hwsim_data, rht),
+	.hashfn = hwsim_table_hash,
+};
 
 struct hwsim_radiotap_hdr {
 	struct ieee80211_radiotap_header hdr;
@@ -2731,6 +2748,15 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 			     CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 
 	spin_lock_bh(&hwsim_radio_lock);
+	err = rhashtable_insert_fast(&hwsim_radios_rht, &data->rht,
+				     hwsim_rht_params);
+	if (err < 0) {
+		pr_debug("mac80211_hwsim: radio index %d already present\n",
+			 idx);
+		spin_unlock_bh(&hwsim_radio_lock);
+		goto failed_final_insert;
+	}
+
 	list_add_tail(&data->list, &hwsim_radios);
 	spin_unlock_bh(&hwsim_radio_lock);
 
@@ -2739,6 +2765,9 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 
 	return idx;
 
+failed_final_insert:
+	debugfs_remove_recursive(data->debugfs);
+	ieee80211_unregister_hw(data->hw);
 failed_hw:
 	device_release_driver(data->dev);
 failed_bind:
@@ -2874,22 +2903,9 @@ static void hwsim_mon_setup(struct net_device *dev)
 
 static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(const u8 *addr)
 {
-	struct mac80211_hwsim_data *data;
-	bool _found = false;
-
-	spin_lock_bh(&hwsim_radio_lock);
-	list_for_each_entry(data, &hwsim_radios, list) {
-		if (memcmp(data->addresses[1].addr, addr, ETH_ALEN) == 0) {
-			_found = true;
-			break;
-		}
-	}
-	spin_unlock_bh(&hwsim_radio_lock);
-
-	if (!_found)
-		return NULL;
-
-	return data;
+	return rhashtable_lookup_fast(&hwsim_radios_rht,
+				      addr,
+				      hwsim_rht_params);
 }
 
 static void hwsim_register_wmediumd(struct net *net, u32 portid)
@@ -3191,6 +3207,8 @@ static int hwsim_del_radio_nl(struct sk_buff *msg, struct genl_info *info)
 			continue;
 
 		list_del(&data->list);
+		rhashtable_remove_fast(&hwsim_radios_rht, &data->rht,
+				       hwsim_rht_params);
 		spin_unlock_bh(&hwsim_radio_lock);
 		mac80211_hwsim_del_radio(data, wiphy_name(data->hw->wiphy),
 					 info);
@@ -3346,6 +3364,8 @@ static void remove_user_radios(u32 portid)
 	list_for_each_entry_safe(entry, tmp, &hwsim_radios, list) {
 		if (entry->destroy_on_close && entry->portid == portid) {
 			list_del(&entry->list);
+			rhashtable_remove_fast(&hwsim_radios_rht, &entry->rht,
+					       hwsim_rht_params);
 			INIT_WORK(&entry->destroy_work, destroy_radio);
 			queue_work(hwsim_wq, &entry->destroy_work);
 		}
@@ -3421,6 +3441,8 @@ static void __net_exit hwsim_exit_net(struct net *net)
 			continue;
 
 		list_del(&data->list);
+		rhashtable_remove_fast(&hwsim_radios_rht, &data->rht,
+				       hwsim_rht_params);
 		INIT_WORK(&data->destroy_work, destroy_radio);
 		queue_work(hwsim_wq, &data->destroy_work);
 	}
@@ -3458,6 +3480,8 @@ static int __init init_mac80211_hwsim(void)
 	if (!hwsim_wq)
 		return -ENOMEM;
 
+	rhashtable_init(&hwsim_radios_rht, &hwsim_rht_params);
+
 	err = register_pernet_device(&hwsim_net_ops);
 	if (err)
 		return err;
@@ -3598,6 +3622,7 @@ static void __exit exit_mac80211_hwsim(void)
 	mac80211_hwsim_free();
 	flush_workqueue(hwsim_wq);
 
+	rhashtable_destroy(&hwsim_radios_rht);
 	unregister_netdev(hwsim_mon);
 	platform_driver_unregister(&mac80211_hwsim_driver);
 	unregister_pernet_device(&hwsim_net_ops);
-- 
2.15.1
