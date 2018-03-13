Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:44186 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752636AbeCMWAA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 18:00:00 -0400
Received: by mail-pf0-f196.google.com with SMTP id m68so484333pfm.11
        for <linux-wireless@vger.kernel.org>; Tue, 13 Mar 2018 15:00:00 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [RFC v5 5/9] nl80211: Add SOCKET_OWNER support to JOIN_IBSS
Date: Tue, 13 Mar 2018 16:59:38 -0500
Message-Id: <20180313215942.29176-6-denkenz@gmail.com> (sfid-20180313_230017_817218_80EFACF3)
In-Reply-To: <20180313215942.29176-1-denkenz@gmail.com>
References: <20180313215942.29176-1-denkenz@gmail.com>
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
index 24b1bd940fca..e678dc510f3a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8691,6 +8691,12 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
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
