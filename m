Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56670 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaJVTXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 15:23:15 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 2/9] mac80211-hwsim: support destroying radio by name
Date: Wed, 22 Oct 2014 12:22:59 -0700
Message-Id: <1414005786-27572-2-git-send-email-greearb@candelatech.com> (sfid-20141022_212327_066870_EDD2E067)
In-Reply-To: <1414005786-27572-1-git-send-email-greearb@candelatech.com>
References: <1414005786-27572-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

It is not always convenient to have to know the device-id,
so allow deleting by name as well.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 22 +++++++++++++++++-----
 drivers/net/wireless/mac80211_hwsim.h |  2 ++
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0224cc3..00c7b3c 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2544,16 +2544,28 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
 {
 	struct mac80211_hwsim_data *data;
-	int idx;
+	s64 idx = -1;
+	const char *hwname = NULL;
 
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
+			if (hwname &&
+			    strcmp(hwname,
+				   dev_name(&data->hw->wiphy->dev)) != 0)
+				continue;
+		}
+
 		list_del(&data->list);
 		spin_unlock_bh(&hwsim_radio_lock);
 		mac80211_hwsim_destroy_radio(data);
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index b96d867..98c6998 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -113,6 +113,7 @@ enum {
  *	single channel is supported
  * @HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE: used with the %HWSIM_CMD_CREATE_RADIO
  *	command to force radio removal when process that created the radio dies
+ * @HWSIM_ATTR_RADIO_NAME: Name of radio, e.g. phy666
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -135,6 +136,7 @@ enum {
 	HWSIM_ATTR_SUPPORT_P2P_DEVICE,
 	HWSIM_ATTR_USE_CHANCTX,
 	HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE,
+	HWSIM_ATTR_RADIO_NAME,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
-- 
1.7.11.7

