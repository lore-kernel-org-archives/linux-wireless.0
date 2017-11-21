Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.uni-rostock.de ([139.30.22.71]:58968 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751715AbdKUMXY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 07:23:24 -0500
From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [PATCH v2 3/5] mac80211_hwsim: add generation count for netlink dump operation
Date: Tue, 21 Nov 2017 13:17:42 +0100
In-Reply-To: <20171121121744.23422-1-benjamin.beichler@uni-rostock.de>
References: <20171121121744.23422-1-benjamin.beichler@uni-rostock.de>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <7ee141a4-8983-4da6-9c0f-f070fa6e5611@MAIL2.uni-rostock.de> (sfid-20171121_132328_001748_FC1C4FEC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the dump operation aware of changes on radio list and corresponding
inconsistent dumps. Change the dump iteration to be independent from
increasing radio indices on radio list.

Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 48b9efed725e..fc8d9664cbfa 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -494,6 +494,7 @@ static struct rhashtable hwsim_radios_rht;
 static spinlock_t hwsim_delete_lock;
 static LIST_HEAD(delete_radios);
 static int hwsim_radio_idx;
+static int hwsim_radios_generation = 1;
 
 static struct platform_driver mac80211_hwsim_driver = {
 	.driver = {
@@ -2754,6 +2755,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	}
 
 	list_add_tail(&data->list, &hwsim_radios);
+	hwsim_radios_generation++;
 	spin_unlock_bh(&hwsim_radio_lock);
 
 	if (idx > 0)
@@ -3202,6 +3204,7 @@ static int hwsim_del_radio_nl(struct sk_buff *msg, struct genl_info *info)
 		list_del(&data->list);
 		rhashtable_remove_fast(&hwsim_radios_rht, &data->rht,
 				       hwsim_rht_params);
+		hwsim_radios_generation++;
 		spin_unlock_bh(&hwsim_radio_lock);
 		mac80211_hwsim_del_radio(data, wiphy_name(data->hw->wiphy),
 					 info);
@@ -3258,19 +3261,25 @@ static int hwsim_get_radio_nl(struct sk_buff *msg, struct genl_info *info)
 static int hwsim_dump_radio_nl(struct sk_buff *skb,
 			       struct netlink_callback *cb)
 {
-	int idx = cb->args[0];
-	struct mac80211_hwsim_data *data = NULL;
+	struct mac80211_hwsim_data *data =
+			(struct mac80211_hwsim_data *)cb->args[0];
 	int res;
 
 	spin_lock_bh(&hwsim_radio_lock);
+	cb->seq = hwsim_radios_generation;
 
-	if (idx == hwsim_radio_idx)
-		goto done;
+	/* list changed */
+	if (cb->prev_seq && cb->seq != cb->prev_seq)
+		goto cleanup;
 
-	list_for_each_entry(data, &hwsim_radios, list) {
-		if (data->idx < idx)
-			continue;
+	/* iterator is at head again, finish*/
+	if (data && &data->list == &hwsim_radios)
+		goto cleanup;
 
+	/* data will NULL or valid since we quit, if list changed */
+	data = list_prepare_entry(data, &hwsim_radios, list);
+
+	list_for_each_entry_continue(data, &hwsim_radios, list) {
 		if (!net_eq(wiphy_net(data->hw->wiphy), sock_net(skb->sk)))
 			continue;
 
@@ -3280,13 +3289,11 @@ static int hwsim_dump_radio_nl(struct sk_buff *skb,
 					       NLM_F_MULTI);
 		if (res < 0)
 			break;
-
-		idx = data->idx + 1;
 	}
 
-	cb->args[0] = idx;
+	cb->args[0] = (long)data;
 
-done:
+cleanup:
 	spin_unlock_bh(&hwsim_radio_lock);
 	return skb->len;
 }
@@ -3348,6 +3355,7 @@ static void destroy_radio(struct work_struct *work)
 
 	spin_lock_bh(&hwsim_delete_lock);
 	list_del(&data->list);
+	hwsim_radios_generation++;
 	spin_unlock_bh(&hwsim_delete_lock);
 	mac80211_hwsim_del_radio(data, wiphy_name(data->hw->wiphy), NULL);
 
-- 
2.15.0
