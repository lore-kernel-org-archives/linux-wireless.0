Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.uni-rostock.de ([139.30.22.71]:51924 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751112AbeAVRFA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 12:05:00 -0500
From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [PATCH v4 3/3] mac80211_hwsim: add generation count for netlink dump operation
Date: Mon, 22 Jan 2018 18:04:37 +0100
Message-ID: <20180122170437.14213-4-benjamin.beichler@uni-rostock.de> (sfid-20180122_180504_602375_F1FA129C)
In-Reply-To: <20180122170437.14213-1-benjamin.beichler@uni-rostock.de>
References: <20180122170437.14213-1-benjamin.beichler@uni-rostock.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the dump operation aware of changes on radio list and corresponding
inconsistent dumps. Changed variable name for better understanding.

Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 8baf61dea961..7cff948ef438 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -492,6 +492,7 @@ static spinlock_t hwsim_radio_lock;
 static LIST_HEAD(hwsim_radios);
 static struct rhashtable hwsim_radios_rht;
 static int hwsim_radio_idx;
+static int hwsim_radios_generation = 1;
 
 static struct platform_driver mac80211_hwsim_driver = {
 	.driver = {
@@ -2808,6 +2809,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	}
 
 	list_add_tail(&data->list, &hwsim_radios);
+	hwsim_radios_generation++;
 	spin_unlock_bh(&hwsim_radio_lock);
 
 	if (idx > 0)
@@ -3273,6 +3275,7 @@ static int hwsim_del_radio_nl(struct sk_buff *msg, struct genl_info *info)
 		list_del(&data->list);
 		rhashtable_remove_fast(&hwsim_radios_rht, &data->rht,
 				       hwsim_rht_params);
+		hwsim_radios_generation++;
 		spin_unlock_bh(&hwsim_radio_lock);
 		mac80211_hwsim_del_radio(data, wiphy_name(data->hw->wiphy),
 					 info);
@@ -3329,17 +3332,19 @@ static int hwsim_get_radio_nl(struct sk_buff *msg, struct genl_info *info)
 static int hwsim_dump_radio_nl(struct sk_buff *skb,
 			       struct netlink_callback *cb)
 {
-	int idx = cb->args[0];
+	int last_idx = cb->args[0];
 	struct mac80211_hwsim_data *data = NULL;
-	int res;
+	int res = 0;
+	void *hdr;
 
 	spin_lock_bh(&hwsim_radio_lock);
+	cb->seq = hwsim_radios_generation;
 
-	if (idx == hwsim_radio_idx)
+	if (last_idx >= hwsim_radio_idx-1)
 		goto done;
 
 	list_for_each_entry(data, &hwsim_radios, list) {
-		if (data->idx < idx)
+		if (data->idx <= last_idx)
 			continue;
 
 		if (!net_eq(wiphy_net(data->hw->wiphy), sock_net(skb->sk)))
@@ -3352,14 +3357,25 @@ static int hwsim_dump_radio_nl(struct sk_buff *skb,
 		if (res < 0)
 			break;
 
-		idx = data->idx + 1;
+		last_idx = data->idx;
 	}
 
-	cb->args[0] = idx;
+	cb->args[0] = last_idx;
+
+	/* list changed, but no new element sent, set interrupted flag */
+	if (skb->len == 0 && cb->prev_seq && cb->seq != cb->prev_seq) {
+		hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
+				  cb->nlh->nlmsg_seq, &hwsim_genl_family,
+				  NLM_F_MULTI, HWSIM_CMD_GET_RADIO);
+		if (!hdr)
+			res = -EMSGSIZE;
+		genl_dump_check_consistent(cb, hdr);
+		genlmsg_end(skb, hdr);
+	}
 
 done:
 	spin_unlock_bh(&hwsim_radio_lock);
-	return skb->len;
+	return (res)? res : skb->len;
 }
 
 /* Generic Netlink operations array */
@@ -3417,6 +3433,7 @@ static void destroy_radio(struct work_struct *work)
 	struct mac80211_hwsim_data *data =
 		container_of(work, struct mac80211_hwsim_data, destroy_work);
 
+	hwsim_radios_generation++;
 	mac80211_hwsim_del_radio(data, wiphy_name(data->hw->wiphy), NULL);
 }
 
-- 
2.15.1
