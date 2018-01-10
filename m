Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.uni-rostock.de ([139.30.22.71]:64769 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965569AbeAJQnn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 11:43:43 -0500
From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [PATCH v3 1/5] mac80211_hwsim: add workqueue to wait for deferred radio deletion on mod unload
Date: Wed, 10 Jan 2018 17:42:51 +0100
In-Reply-To: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
References: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <2a021406-db0b-42e9-be2b-7185814139af@MAIL2.uni-rostock.de> (sfid-20180110_174348_389295_586E4FBA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When closing multiple wmediumd instances with many radios and try to
unload the  mac80211_hwsim module, it may happen that the work items live
longer than the module. To wait especially for this deletion work items,
add a work queue, otherwise flush_scheduled_work would be necessary.

Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 45cca54c05bf..742a1551bb1c 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -489,6 +489,7 @@ static const struct ieee80211_iface_combination hwsim_if_comb_p2p_dev[] = {
 
 static spinlock_t hwsim_radio_lock;
 static LIST_HEAD(hwsim_radios);
+static struct workqueue_struct *hwsim_wq;
 static int hwsim_radio_idx;
 
 static struct platform_driver mac80211_hwsim_driver = {
@@ -3346,7 +3347,7 @@ static void remove_user_radios(u32 portid)
 		if (entry->destroy_on_close && entry->portid == portid) {
 			list_del(&entry->list);
 			INIT_WORK(&entry->destroy_work, destroy_radio);
-			schedule_work(&entry->destroy_work);
+			queue_work(hwsim_wq, &entry->destroy_work);
 		}
 	}
 	spin_unlock_bh(&hwsim_radio_lock);
@@ -3421,7 +3422,7 @@ static void __net_exit hwsim_exit_net(struct net *net)
 
 		list_del(&data->list);
 		INIT_WORK(&data->destroy_work, destroy_radio);
-		schedule_work(&data->destroy_work);
+		queue_work(hwsim_wq, &data->destroy_work);
 	}
 	spin_unlock_bh(&hwsim_radio_lock);
 }
@@ -3453,6 +3454,10 @@ static int __init init_mac80211_hwsim(void)
 
 	spin_lock_init(&hwsim_radio_lock);
 
+	hwsim_wq = alloc_workqueue("hwsim_wq",WQ_MEM_RECLAIM,0);
+	if (!hwsim_wq)
+		return -ENOMEM;
+
 	err = register_pernet_device(&hwsim_net_ops);
 	if (err)
 		return err;
@@ -3591,8 +3596,11 @@ static void __exit exit_mac80211_hwsim(void)
 	hwsim_exit_netlink();
 
 	mac80211_hwsim_free();
+	flush_workqueue(hwsim_wq);
+
 	unregister_netdev(hwsim_mon);
 	platform_driver_unregister(&mac80211_hwsim_driver);
 	unregister_pernet_device(&hwsim_net_ops);
+	destroy_workqueue(hwsim_wq);
 }
 module_exit(exit_mac80211_hwsim);
-- 
2.15.1
