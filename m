Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from diserzione.investici.org ([82.221.99.153]:59709 "EHLO
	diserzione.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab3FRMbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 08:31:18 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH] nl80211: allow to register for mgmt frames without a matching pattern
Date: Tue, 18 Jun 2013 14:29:14 +0200
Message-Id: <1371558554-367-1-git-send-email-ordex@autistici.org> (sfid-20130618_143121_449409_2DE3C41E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

It may be the case that a user wants to register for any
frame of a particular type.

Allow this operation by passing null as matching pattern and
0 as pattern len when registering for the frame.

This is useful to wpa_supplicant when it wants to receive
any AUTH frame.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/wireless/nl80211.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e402819..878d346 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7099,9 +7099,11 @@ static int nl80211_register_mgmt(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct wireless_dev *wdev = info->user_ptr[1];
 	u16 frame_type = IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_ACTION;
+	void *data = nla_data(info->attrs[NL80211_ATTR_FRAME_MATCH]);
+	int len = 0;
 
-	if (!info->attrs[NL80211_ATTR_FRAME_MATCH])
-		return -EINVAL;
+	if (data)
+		len = nla_len(data);
 
 	if (info->attrs[NL80211_ATTR_FRAME_TYPE])
 		frame_type = nla_get_u16(info->attrs[NL80211_ATTR_FRAME_TYPE]);
@@ -7125,8 +7127,7 @@ static int nl80211_register_mgmt(struct sk_buff *skb, struct genl_info *info)
 		return -EOPNOTSUPP;
 
 	return cfg80211_mlme_register_mgmt(wdev, info->snd_portid, frame_type,
-			nla_data(info->attrs[NL80211_ATTR_FRAME_MATCH]),
-			nla_len(info->attrs[NL80211_ATTR_FRAME_MATCH]));
+					   data, len);
 }
 
 static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
-- 
1.8.1.5

