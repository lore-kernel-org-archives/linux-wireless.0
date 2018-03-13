Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:38671 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752778AbeCMWAC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 18:00:02 -0400
Received: by mail-pf0-f195.google.com with SMTP id d26so491151pfn.5
        for <linux-wireless@vger.kernel.org>; Tue, 13 Mar 2018 15:00:01 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [RFC v5 6/9] nl80211: Add SOCKET_OWNER support to JOIN_MESH
Date: Tue, 13 Mar 2018 16:59:39 -0500
Message-Id: <20180313215942.29176-7-denkenz@gmail.com> (sfid-20180313_230010_413215_4D4AA164)
In-Reply-To: <20180313215942.29176-1-denkenz@gmail.com>
References: <20180313215942.29176-1-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 include/uapi/linux/nl80211.h |  2 ++
 net/wireless/mesh.c          |  1 +
 net/wireless/nl80211.c       | 10 +++++++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 877fab2836ec..e3329bc4644b 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1987,6 +1987,8 @@ enum nl80211_commands {
  *	station will deauthenticate when the socket is closed.
  *	If set during %NL80211_CMD_JOIN_IBSS the IBSS will be automatically
  *	torn down when the socket is closed.
+ *	If set during %NL80211_CMD_JOIN_MESH the mesh setup will be
+ *	automatically torn down when the socket is closed.
  *
  * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
  *	the TDLS link initiator.
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index b12da6ef3c12..e91a5078615b 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -286,6 +286,7 @@ int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
 
 	err = rdev_leave_mesh(rdev, dev);
 	if (!err) {
+		wdev->conn_owner_nlportid = 0;
 		wdev->mesh_id_len = 0;
 		wdev->beacon_interval = 0;
 		memset(&wdev->chandef, 0, sizeof(wdev->chandef));
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e678dc510f3a..e38d55cf34f7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10140,7 +10140,15 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 	setup.userspace_handles_dfs =
 		nla_get_flag(info->attrs[NL80211_ATTR_HANDLE_DFS]);
 
-	return cfg80211_join_mesh(rdev, dev, &setup, &cfg);
+	err = cfg80211_join_mesh(rdev, dev, &setup, &cfg);
+
+	if (!err && info->attrs[NL80211_ATTR_SOCKET_OWNER]) {
+		wdev_lock(dev->ieee80211_ptr);
+		dev->ieee80211_ptr->conn_owner_nlportid = info->snd_portid;
+		wdev_unlock(dev->ieee80211_ptr);
+	}
+
+	return err;
 }
 
 static int nl80211_leave_mesh(struct sk_buff *skb, struct genl_info *info)
-- 
2.13.5
