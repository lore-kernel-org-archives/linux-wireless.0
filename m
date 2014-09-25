Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47730 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbaIYWyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2014 18:54:43 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac-hwsim:  support destroying radio by name.
Date: Thu, 25 Sep 2014 15:54:39 -0700
Message-Id: <1411685679-25404-1-git-send-email-greearb@candelatech.com> (sfid-20140926_005456_257641_223004F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

It is not always convenient to have to know the device-id,
so allow deleting by name as well.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 21 ++++++++++++++++-----
 drivers/net/wireless/mac80211_hwsim.h |  2 ++
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 43435c0..a371290 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2535,16 +2535,27 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
 {
 	struct mac80211_hwsim_data *data;
-	int idx;
+	int idx = -1;
+	const char *hwname;
 
-	if (!info->attrs[HWSIM_ATTR_RADIO_ID])
+	if (info->attrs[HWSIM_ATTR_RADIO_ID])
+		idx = nla_get_u32(info->attrs[HWSIM_ATTR_RADIO_ID]);
+	else if (info->attrs[HWSIM_ATTR_RADIO_NAME])
+		hwname = (void *)nla_data(info->attrs[HWSIM_ATTR_RADIO_NAME]);
+	else
 		return -EINVAL;
-	idx = nla_get_u32(info->attrs[HWSIM_ATTR_RADIO_ID]);
 
 	spin_lock_bh(&hwsim_radio_lock);
 	list_for_each_entry(data, &hwsim_radios, list) {
-		if (data->idx != idx)
-			continue;
+		if (idx >= 0) {
+			if (data->idx != idx)
+				continue;
+		} else {
+			if (strcmp(hwname,
+				   dev_name(&data->hw->wiphy->dev)) != 0)
+				continue;
+		}
+
 		list_del(&data->list);
 		spin_unlock_bh(&hwsim_radio_lock);
 		mac80211_hwsim_destroy_radio(data);
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index c9d0315..37c040b 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -111,6 +111,7 @@ enum {
  * @HWSIM_ATTR_USE_CHANCTX: used with the %HWSIM_CMD_CREATE_RADIO
  *	command to force use of channel contexts even when only a
  *	single channel is supported
+ * @HWSIM_ATTR_RADIO_NAME: Name of radio, ie phy666
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -132,6 +133,7 @@ enum {
 	HWSIM_ATTR_REG_STRICT_REG,
 	HWSIM_ATTR_SUPPORT_P2P_DEVICE,
 	HWSIM_ATTR_USE_CHANCTX,
+	HWSIM_ATTR_RADIO_NAME,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
-- 
1.7.11.7

