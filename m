Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:14042 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759121AbaJaMsy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 08:48:54 -0400
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v3 2/2] mac80211-hwsim: Provide multicast event for HWSIM_CMD_DEL_RADIO
Date: Fri, 31 Oct 2014 14:48:48 +0200
Message-Id: <1414759728-20659-3-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141031_134858_584560_5B21A296)
In-Reply-To: <1414759728-20659-1-git-send-email-jukka.rissanen@linux.intel.com>
References: <1414759728-20659-1-git-send-email-jukka.rissanen@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When deleting old radio via HWSIM_CMD_DEL_RADIO then listeners on the
multicast group "config" are informed.

Signed-off-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 54 ++++++++++++++++++++++++++++++-----
 1 file changed, 47 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 476c89c..209db62 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2404,8 +2404,48 @@ failed:
 	return err;
 }
 
-static void mac80211_hwsim_destroy_radio(struct mac80211_hwsim_data *data)
+static void hwsim_mcast_del_radio(int id, const char *hwname,
+				  struct genl_info *info)
 {
+	struct sk_buff *skb;
+	void *data;
+	int ret;
+
+	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!skb)
+		return;
+
+	data = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0,
+			   HWSIM_CMD_DEL_RADIO);
+	if (!data)
+		goto error;
+
+	ret = nla_put_u32(skb, HWSIM_ATTR_RADIO_ID, id);
+	if (ret < 0)
+		goto error;
+
+	if (hwname) {
+		ret = nla_put(skb, HWSIM_ATTR_RADIO_NAME, strlen(hwname),
+			      hwname);
+		if (ret < 0)
+			goto error;
+	}
+
+	genlmsg_end(skb, data);
+
+	hwsim_mcast_config_msg(skb, info);
+
+	return;
+
+error:
+	nlmsg_free(skb);
+}
+
+static void mac80211_hwsim_del_radio(struct mac80211_hwsim_data *data,
+				     const char *hwname,
+				     struct genl_info *info)
+{
+	hwsim_mcast_del_radio(data->idx, hwname, info);
 	debugfs_remove_recursive(data->debugfs);
 	ieee80211_unregister_hw(data->hw);
 	device_release_driver(data->dev);
@@ -2423,7 +2463,7 @@ static void mac80211_hwsim_free(void)
 						list))) {
 		list_del(&data->list);
 		spin_unlock_bh(&hwsim_radio_lock);
-		mac80211_hwsim_destroy_radio(data);
+		mac80211_hwsim_del_radio(data, NULL, NULL);
 		spin_lock_bh(&hwsim_radio_lock);
 	}
 	spin_unlock_bh(&hwsim_radio_lock);
@@ -2683,7 +2723,7 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	return mac80211_hwsim_new_radio(info, &param);
 }
 
-static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
+static int hwsim_del_radio_nl(struct sk_buff *msg, struct genl_info *info)
 {
 	struct mac80211_hwsim_data *data;
 	s64 idx = -1;
@@ -2709,7 +2749,7 @@ static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
 
 		list_del(&data->list);
 		spin_unlock_bh(&hwsim_radio_lock);
-		mac80211_hwsim_destroy_radio(data);
+		mac80211_hwsim_del_radio(data, hwname, info);
 		return 0;
 	}
 	spin_unlock_bh(&hwsim_radio_lock);
@@ -2742,9 +2782,9 @@ static const struct genl_ops hwsim_ops[] = {
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
@@ -2754,7 +2794,7 @@ static void destroy_radio(struct work_struct *work)
 	struct mac80211_hwsim_data *data =
 		container_of(work, struct mac80211_hwsim_data, destroy_work);
 
-	mac80211_hwsim_destroy_radio(data);
+	mac80211_hwsim_del_radio(data, NULL, NULL);
 }
 
 static void remove_user_radios(u32 portid)
-- 
1.8.3.1

