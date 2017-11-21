Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.uni-rostock.de ([139.30.22.72]:57400 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751684AbdKUMXX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 07:23:23 -0500
From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [PATCH v2 1/5] mac80211_hwsim: wait for deferred radio deletion on mod unload
Date: Tue, 21 Nov 2017 13:17:40 +0100
In-Reply-To: <20171121121744.23422-1-benjamin.beichler@uni-rostock.de>
References: <20171121121744.23422-1-benjamin.beichler@uni-rostock.de>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <3a182eff-3f00-49bb-94ac-ec371ff1c26e@MAIL2.uni-rostock.de> (sfid-20171121_132334_719727_EFD58654)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When closing multiple wmediumd instances with many radios and try to
unload the mac80211_hwsim module it may happen that the work items live
longer than the module. This patch does not mitigate completely the
problem, since we need to delete hwsim_data struct from delete queue
(since afterwards the reference is not valid anymore) at the beginning of
the work function and it may be interrupted in between. But this problem
only occurs for the last (or only) item of the delete list. We could either
create a dedicated work queue or call flush_scheduled_work, but both
introduce unnecessary overhead.

Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ec2f4c31425a..d35dc6b2a733 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -489,6 +489,8 @@ static const struct ieee80211_iface_combination hwsim_if_comb_p2p_dev[] = {
 
 static spinlock_t hwsim_radio_lock;
 static LIST_HEAD(hwsim_radios);
+static spinlock_t hwsim_delete_lock;
+static LIST_HEAD(delete_radios);
 static int hwsim_radio_idx;
 
 static struct platform_driver mac80211_hwsim_driver = {
@@ -3326,7 +3328,11 @@ static void destroy_radio(struct work_struct *work)
 	struct mac80211_hwsim_data *data =
 		container_of(work, struct mac80211_hwsim_data, destroy_work);
 
+	spin_lock_bh(&hwsim_delete_lock);
+	list_del(&data->list);
+	spin_unlock_bh(&hwsim_delete_lock);
 	mac80211_hwsim_del_radio(data, wiphy_name(data->hw->wiphy), NULL);
+
 }
 
 static void remove_user_radios(u32 portid)
@@ -3337,6 +3343,11 @@ static void remove_user_radios(u32 portid)
 	list_for_each_entry_safe(entry, tmp, &hwsim_radios, list) {
 		if (entry->destroy_on_close && entry->portid == portid) {
 			list_del(&entry->list);
+
+			spin_lock_bh(&hwsim_delete_lock);
+			list_add(&entry->list, &delete_radios);
+			spin_unlock_bh(&hwsim_delete_lock);
+
 			INIT_WORK(&entry->destroy_work, destroy_radio);
 			schedule_work(&entry->destroy_work);
 		}
@@ -3412,6 +3423,11 @@ static void __net_exit hwsim_exit_net(struct net *net)
 			continue;
 
 		list_del(&data->list);
+
+		spin_lock_bh(&hwsim_delete_lock);
+		list_add(&data->list, &delete_radios);
+		spin_unlock_bh(&hwsim_delete_lock);
+
 		INIT_WORK(&data->destroy_work, destroy_radio);
 		schedule_work(&data->destroy_work);
 	}
@@ -3444,6 +3460,7 @@ static int __init init_mac80211_hwsim(void)
 		return -EINVAL;
 
 	spin_lock_init(&hwsim_radio_lock);
+	spin_lock_init(&hwsim_delete_lock);
 
 	err = register_pernet_device(&hwsim_net_ops);
 	if (err)
@@ -3583,6 +3600,19 @@ static void __exit exit_mac80211_hwsim(void)
 	hwsim_exit_netlink();
 
 	mac80211_hwsim_free();
+
+	/*wait for radios with deferred delete*/
+	spin_lock_bh(&hwsim_delete_lock);
+	while (!list_empty(&delete_radios)) {
+		pr_debug("mac80211_hwsim: wait for deferred radio remove\n");
+		spin_unlock_bh(&hwsim_delete_lock);
+		flush_work(&list_entry(&delete_radios,
+				       struct mac80211_hwsim_data, list)
+			   ->destroy_work);
+		spin_lock_bh(&hwsim_delete_lock);
+	}
+	spin_unlock_bh(&hwsim_delete_lock);
+
 	unregister_netdev(hwsim_mon);
 	platform_driver_unregister(&mac80211_hwsim_driver);
 	unregister_pernet_device(&hwsim_net_ops);
-- 
2.15.0
