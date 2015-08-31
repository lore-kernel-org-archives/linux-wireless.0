Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:35946 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbbHaVBO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 17:01:14 -0400
Received: by labnh1 with SMTP id nh1so54597830lab.3
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2015 14:01:12 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] nl80211: put current TX power in interface info
Date: Mon, 31 Aug 2015 22:59:38 +0200
Message-Id: <1441054778-22499-1-git-send-email-zajec5@gmail.com> (sfid-20150831_230117_209391_B8527C0A)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Many drivers implement reading current TX power (using either cfg80211
or ieee80211 op) but userspace can't get it using nl80211. Right now the
only way to access it is to call some wext ioctl.
Let's put TX power in interface info reply (callback is wdev specific)
just like we do with current channel.
To be consistent (e.g. NL80211_CMD_SET_WIPHY) let's use mBm as na unit.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 net/wireless/nl80211.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5d8748b..a5d4e6f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2403,6 +2403,17 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 		}
 	}
 
+	if (rdev->ops->get_tx_power) {
+		int dbm, ret;
+
+		ret = rdev_get_tx_power(rdev, wdev, &dbm);
+		if (ret == 0) {
+			if (nla_put_u32(msg, NL80211_ATTR_WIPHY_TX_POWER_LEVEL,
+					DBM_TO_MBM(dbm)))
+				goto nla_put_failure;
+		}
+	}
+
 	if (wdev->ssid_len) {
 		if (nla_put(msg, NL80211_ATTR_SSID, wdev->ssid_len, wdev->ssid))
 			goto nla_put_failure;
-- 
1.8.4.5

