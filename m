Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59834 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaAJMvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 07:51:16 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 05/13] mac80211_hwsim: refactor radio cleanup
Date: Fri, 10 Jan 2014 13:51:02 +0100
Message-Id: <1389358270-20901-6-git-send-email-johannes@sipsolutions.net> (sfid-20140110_135136_355741_EA86E502)
In-Reply-To: <1389358270-20901-1-git-send-email-johannes@sipsolutions.net>
References: <1389358270-20901-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Refactor the radio cleanup into a new function to later
allow deleting a single radio from the list.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 23fa6ee..cca5b3f 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1623,25 +1623,29 @@ static const struct ieee80211_ops mac80211_hwsim_ops = {
 
 static struct ieee80211_ops mac80211_hwsim_mchan_ops;
 
-static void mac80211_hwsim_free(void)
+static void mac80211_hwsim_destroy_radio(struct mac80211_hwsim_data *data)
 {
-	struct list_head tmplist, *i, *tmp;
-	struct mac80211_hwsim_data *data, *tmpdata;
+	debugfs_remove_recursive(data->debugfs);
+	ieee80211_unregister_hw(data->hw);
+	device_release_driver(data->dev);
+	device_unregister(data->dev);
+	ieee80211_free_hw(data->hw);
+}
 
-	INIT_LIST_HEAD(&tmplist);
+static void mac80211_hwsim_free(void)
+{
+	struct mac80211_hwsim_data *data;
 
 	spin_lock_bh(&hwsim_radio_lock);
-	list_for_each_safe(i, tmp, &hwsim_radios)
-		list_move(i, &tmplist);
-	spin_unlock_bh(&hwsim_radio_lock);
-
-	list_for_each_entry_safe(data, tmpdata, &tmplist, list) {
-		debugfs_remove_recursive(data->debugfs);
-		ieee80211_unregister_hw(data->hw);
-		device_release_driver(data->dev);
-		device_unregister(data->dev);
-		ieee80211_free_hw(data->hw);
+	while ((data = list_first_entry_or_null(&hwsim_radios,
+						struct mac80211_hwsim_data,
+						list))) {
+		list_del(&data->list);
+		spin_unlock_bh(&hwsim_radio_lock);
+		mac80211_hwsim_destroy_radio(data);
+		spin_lock_bh(&hwsim_radio_lock);
 	}
+	spin_unlock_bh(&hwsim_radio_lock);
 	class_destroy(hwsim_class);
 }
 
-- 
1.8.5.1

