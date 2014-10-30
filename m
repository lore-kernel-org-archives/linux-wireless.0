Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:21758 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934156AbaJ3PgN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 11:36:13 -0400
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 2/2] mac80211-hwsim: Provide multicast event for HWSIM_CMD_DEL_RADIO
Date: Thu, 30 Oct 2014 17:34:26 +0200
Message-Id: <1414683266-28427-3-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141030_163616_502891_B0D1FAB4)
In-Reply-To: <1414683266-28427-1-git-send-email-jukka.rissanen@linux.intel.com>
References: <1414683266-28427-1-git-send-email-jukka.rissanen@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When deleting old radio via HWSIM_CMD_DEL_RADIO then listeners on the
multicast group "config" are informed.

Signed-off-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 43 ++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ff187fe..909777c 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2305,8 +2305,39 @@ failed:
 	return err;
 }
 
-static void mac80211_hwsim_destroy_radio(struct mac80211_hwsim_data *data)
+static void hwsim_mcast_del_radio(int id, struct genl_info *info)
 {
+	struct sk_buff *mcast_skb;
+	void *data;
+	int ret;
+
+	mcast_skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!mcast_skb)
+		return;
+
+	data = genlmsg_put(mcast_skb, 0, 0, &hwsim_genl_family, 0,
+			   HWSIM_CMD_DEL_RADIO);
+	if (!data)
+		goto error;
+
+	ret = nla_put_u32(mcast_skb, HWSIM_ATTR_RADIO_ID, id);
+	if (ret < 0)
+		goto error;
+
+	genlmsg_end(mcast_skb, data);
+
+	hwsim_mcast_config_msg(mcast_skb, info);
+
+	return;
+
+error:
+	nlmsg_free(mcast_skb);
+}
+
+static void mac80211_hwsim_del_radio(struct mac80211_hwsim_data *data,
+				     struct genl_info *info)
+{
+	hwsim_mcast_del_radio(data->idx, info);
 	debugfs_remove_recursive(data->debugfs);
 	ieee80211_unregister_hw(data->hw);
 	device_release_driver(data->dev);
@@ -2324,7 +2355,7 @@ static void mac80211_hwsim_free(void)
 						list))) {
 		list_del(&data->list);
 		spin_unlock_bh(&hwsim_radio_lock);
-		mac80211_hwsim_destroy_radio(data);
+		mac80211_hwsim_del_radio(data, NULL);
 		spin_lock_bh(&hwsim_radio_lock);
 	}
 	spin_unlock_bh(&hwsim_radio_lock);
@@ -2573,7 +2604,7 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	return mac80211_hwsim_new_radio(info, &param);
 }
 
-static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
+static int hwsim_del_radio_nl(struct sk_buff *msg, struct genl_info *info)
 {
 	struct mac80211_hwsim_data *data;
 	int idx;
@@ -2588,7 +2619,7 @@ static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
 			continue;
 		list_del(&data->list);
 		spin_unlock_bh(&hwsim_radio_lock);
-		mac80211_hwsim_destroy_radio(data);
+		mac80211_hwsim_del_radio(data, info);
 		return 0;
 	}
 	spin_unlock_bh(&hwsim_radio_lock);
@@ -2621,9 +2652,9 @@ static const struct genl_ops hwsim_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = HWSIM_CMD_DESTROY_RADIO,
+		.cmd = HWSIM_CMD_DEL_RADIO,
 		.policy = hwsim_genl_policy,
-		.doit = hwsim_destroy_radio_nl,
+		.doit = hwsim_del_radio_nl,
 		.flags = GENL_ADMIN_PERM,
 	},
 };
-- 
1.8.3.1

