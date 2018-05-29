Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:59806 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933157AbeE2KE4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 06:04:56 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Colin King <colin.king@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: fix module init error paths
Date: Tue, 29 May 2018 12:04:51 +0200
Message-Id: <20180529100451.21547-1-johannes@sipsolutions.net> (sfid-20180529_120511_127889_8DC00B0E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We didn't free the workqueue on any errors, nor did we
correctly check for rhashtable allocation errors, nor
did we free the hashtable on error.

Reported-by: Colin King <colin.king@canonical.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 89fc22520d40..9be75b4185f1 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3573,11 +3573,14 @@ static int __init init_mac80211_hwsim(void)
 	hwsim_wq = alloc_workqueue("hwsim_wq", 0, 0);
 	if (!hwsim_wq)
 		return -ENOMEM;
-	rhashtable_init(&hwsim_radios_rht, &hwsim_rht_params);
+
+	err = rhashtable_init(&hwsim_radios_rht, &hwsim_rht_params);
+	if (err)
+		goto out_free_wq;
 
 	err = register_pernet_device(&hwsim_net_ops);
 	if (err)
-		return err;
+		goto out_free_rht;
 
 	err = platform_driver_register(&mac80211_hwsim_driver);
 	if (err)
@@ -3702,6 +3705,10 @@ static int __init init_mac80211_hwsim(void)
 	platform_driver_unregister(&mac80211_hwsim_driver);
 out_unregister_pernet:
 	unregister_pernet_device(&hwsim_net_ops);
+out_free_rht:
+	rhashtable_destroy(&hwsim_radios_rht);
+out_free_wq:
+	destroy_workqueue(hwsim_wq);
 	return err;
 }
 module_init(init_mac80211_hwsim);
-- 
2.14.3
