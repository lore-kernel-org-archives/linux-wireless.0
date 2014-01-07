Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48613 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbaAGXPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 18:15:23 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 05/12] mac80211_hwsim: refactor radio cleanup
Date: Wed,  8 Jan 2014 00:15:10 +0100
Message-Id: <1389136517-21216-6-git-send-email-johannes@sipsolutions.net> (sfid-20140108_001532_305116_6592D57A)
In-Reply-To: <1389136517-21216-1-git-send-email-johannes@sipsolutions.net>
References: <1389136517-21216-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Refactor the radio cleanup into a new function to later
allow deleting a single radio from the list.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 23fa6ee..421528e 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1623,25 +1623,26 @@ static const struct ieee80211_ops mac80211_hwsim_ops = {
 
 static struct ieee80211_ops mac80211_hwsim_mchan_ops;
 
+static void mac80211_hwsim_destroy_radio(struct mac80211_hwsim_data *data)
+{
+	lockdep_assert_held(&hwsim_radio_lock);
+	list_del(&data->list);
+
+	debugfs_remove_recursive(data->debugfs);
+	ieee80211_unregister_hw(data->hw);
+	device_release_driver(data->dev);
+	device_unregister(data->dev);
+	ieee80211_free_hw(data->hw);
+}
+
 static void mac80211_hwsim_free(void)
 {
-	struct list_head tmplist, *i, *tmp;
 	struct mac80211_hwsim_data *data, *tmpdata;
 
-	INIT_LIST_HEAD(&tmplist);
-
 	spin_lock_bh(&hwsim_radio_lock);
-	list_for_each_safe(i, tmp, &hwsim_radios)
-		list_move(i, &tmplist);
+	list_for_each_entry_safe(data, tmpdata, &hwsim_radios, list)
+		mac80211_hwsim_destroy_radio(data);
 	spin_unlock_bh(&hwsim_radio_lock);
-
-	list_for_each_entry_safe(data, tmpdata, &tmplist, list) {
-		debugfs_remove_recursive(data->debugfs);
-		ieee80211_unregister_hw(data->hw);
-		device_release_driver(data->dev);
-		device_unregister(data->dev);
-		ieee80211_free_hw(data->hw);
-	}
 	class_destroy(hwsim_class);
 }
 
-- 
1.8.5.1

