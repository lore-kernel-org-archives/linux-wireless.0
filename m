Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35736 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752289AbeCZRxG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 13:53:06 -0400
Received: by mail-oi0-f68.google.com with SMTP id x20-v6so16586582oie.2
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2018 10:53:05 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH v7 07/11] nl80211: Add SOCKET_OWNER support to START_AP
Date: Mon, 26 Mar 2018 12:52:47 -0500
Message-Id: <20180326175251.20666-8-denkenz@gmail.com> (sfid-20180326_195316_172497_B7C39428)
In-Reply-To: <20180326175251.20666-1-denkenz@gmail.com>
References: <20180326175251.20666-1-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 include/uapi/linux/nl80211.h | 2 ++
 net/wireless/ap.c            | 1 +
 net/wireless/nl80211.c       | 4 ++++
 3 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index e3329bc4644b..9b4fd4bca141 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1989,6 +1989,8 @@ enum nl80211_commands {
  *	torn down when the socket is closed.
  *	If set during %NL80211_CMD_JOIN_MESH the mesh setup will be
  *	automatically torn down when the socket is closed.
+ *	If set during %NL80211_CMD_START_AP the AP will be automatically
+ *	disabled when the socket is closed.
  *
  * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
  *	the TDLS link initiator.
diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index 63682176c96c..882d97bdc6bf 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -27,6 +27,7 @@ int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 
 	err = rdev_stop_ap(rdev, dev);
 	if (!err) {
+		wdev->conn_owner_nlportid = 0;
 		wdev->beacon_interval = 0;
 		memset(&wdev->chandef, 0, sizeof(wdev->chandef));
 		wdev->ssid_len = 0;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 05b903958894..34e8435f0c43 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4135,6 +4135,10 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		wdev->chandef = params.chandef;
 		wdev->ssid_len = params.ssid_len;
 		memcpy(wdev->ssid, params.ssid, wdev->ssid_len);
+
+		if (info->attrs[NL80211_ATTR_SOCKET_OWNER])
+			wdev->conn_owner_nlportid = info->snd_portid;
+
 	}
 	wdev_unlock(wdev);
 
-- 
2.13.5
