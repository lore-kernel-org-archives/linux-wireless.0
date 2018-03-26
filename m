Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:41462 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752519AbeCZRxE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 13:53:04 -0400
Received: by mail-oi0-f65.google.com with SMTP id 188-v6so354450oih.8
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2018 10:53:03 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH v7 05/11] nl80211: Add SOCKET_OWNER support to JOIN_IBSS
Date: Mon, 26 Mar 2018 12:52:45 -0500
Message-Id: <20180326175251.20666-6-denkenz@gmail.com> (sfid-20180326_195322_982077_E0FF3AFB)
In-Reply-To: <20180326175251.20666-1-denkenz@gmail.com>
References: <20180326175251.20666-1-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 include/uapi/linux/nl80211.h | 2 ++
 net/wireless/ibss.c          | 1 +
 net/wireless/nl80211.c       | 6 ++++++
 3 files changed, 9 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1cdac3d732c1..877fab2836ec 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1985,6 +1985,8 @@ enum nl80211_commands {
  *	multicast group.
  *	If set during %NL80211_CMD_ASSOCIATE or %NL80211_CMD_CONNECT the
  *	station will deauthenticate when the socket is closed.
+ *	If set during %NL80211_CMD_JOIN_IBSS the IBSS will be automatically
+ *	torn down when the socket is closed.
  *
  * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
  *	the TDLS link initiator.
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index a1d10993d08a..d5d26fc5b853 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -224,6 +224,7 @@ int __cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
 	if (err)
 		return err;
 
+	wdev->conn_owner_nlportid = 0;
 	__cfg80211_clear_ibss(dev, nowext);
 
 	return 0;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 234f6a41aa03..2f630ee3240b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8704,6 +8704,12 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 	err = cfg80211_join_ibss(rdev, dev, &ibss, connkeys);
 	if (err)
 		kzfree(connkeys);
+	else if (info->attrs[NL80211_ATTR_SOCKET_OWNER]) {
+		wdev_lock(dev->ieee80211_ptr);
+		dev->ieee80211_ptr->conn_owner_nlportid = info->snd_portid;
+		wdev_unlock(dev->ieee80211_ptr);
+	}
+
 	return err;
 }
 
-- 
2.13.5
