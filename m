Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.uni-rostock.de ([139.30.22.71]:64798 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965569AbeAJQnp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 11:43:45 -0500
From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [PATCH v3 3/5] mac80211_hwsim: add generation count for netlink dump operation
Date: Wed, 10 Jan 2018 17:42:53 +0100
In-Reply-To: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
References: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <44644db1-58a4-4b6e-a77e-37c72ee2e4a6@MAIL2.uni-rostock.de> (sfid-20180110_174350_143330_B3370AD3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the dump operation aware of changes on radio list and corresponding
inconsistent dumps. Change the dump iteration to be independent from
increasing radio indices on radio list.

Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 43 ++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 55d25e3fbbcc..2d4e97b6dc8f 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -493,6 +493,7 @@ static LIST_HEAD(hwsim_radios);
 static struct workqueue_struct *hwsim_wq;
 static struct rhashtable hwsim_radios_rht;
 static int hwsim_radio_idx;
+static int hwsim_radios_generation = 1;
 
 static struct platform_driver mac80211_hwsim_driver = {
 	.driver = {
@@ -2758,6 +2759,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	}
 
 	list_add_tail(&data->list, &hwsim_radios);
+	hwsim_radios_generation++;
 	spin_unlock_bh(&hwsim_radio_lock);
 
 	if (idx > 0)
@@ -3209,6 +3211,7 @@ static int hwsim_del_radio_nl(struct sk_buff *msg, struct genl_info *info)
 		list_del(&data->list);
 		rhashtable_remove_fast(&hwsim_radios_rht, &data->rht,
 				       hwsim_rht_params);
+		hwsim_radios_generation++;
 		spin_unlock_bh(&hwsim_radio_lock);
 		mac80211_hwsim_del_radio(data, wiphy_name(data->hw->wiphy),
 					 info);
@@ -3265,19 +3268,34 @@ static int hwsim_get_radio_nl(struct sk_buff *msg, struct genl_info *info)
 static int hwsim_dump_radio_nl(struct sk_buff *skb,
 			       struct netlink_callback *cb)
 {
-	int idx = cb->args[0];
-	struct mac80211_hwsim_data *data = NULL;
-	int res;
+	struct mac80211_hwsim_data *data =
+			(struct mac80211_hwsim_data *)cb->args[0];
+	int res = 0;
+	void *hdr;
 
 	spin_lock_bh(&hwsim_radio_lock);
+	cb->seq = hwsim_radios_generation;
+
+	/* list changed, send msg with dump interrupted header*/
+	if (cb->prev_seq && cb->seq != cb->prev_seq) {
+		hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
+				  cb->nlh->nlmsg_seq, &hwsim_genl_family,
+				  NLM_F_MULTI, HWSIM_CMD_GET_RADIO);
+		if (!hdr)
+			res = -EMSGSIZE;
+		genl_dump_check_consistent(cb, hdr);
+		genlmsg_end(skb, hdr);
+		goto cleanup;
+	}
 
-	if (idx == hwsim_radio_idx)
-		goto done;
+	/* iterator is at head again, finish*/
+	if (data && &data->list == &hwsim_radios)
+		goto cleanup;
 
-	list_for_each_entry(data, &hwsim_radios, list) {
-		if (data->idx < idx)
-			continue;
+	/* data will NULL or valid since we quit, if list changed */
+	data = list_prepare_entry(data, &hwsim_radios, list);
 
+	list_for_each_entry_continue(data, &hwsim_radios, list) {
 		if (!net_eq(wiphy_net(data->hw->wiphy), sock_net(skb->sk)))
 			continue;
 
@@ -3287,15 +3305,13 @@ static int hwsim_dump_radio_nl(struct sk_buff *skb,
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
-	return skb->len;
+	return (res)? res : skb->len;
 }
 
 /* Generic Netlink operations array */
@@ -3353,6 +3369,7 @@ static void destroy_radio(struct work_struct *work)
 	struct mac80211_hwsim_data *data =
 		container_of(work, struct mac80211_hwsim_data, destroy_work);
 
+	hwsim_radios_generation++;
 	mac80211_hwsim_del_radio(data, wiphy_name(data->hw->wiphy), NULL);
 }
 
-- 
2.15.1
