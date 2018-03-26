Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:39933 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752173AbeCZRQ2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 13:16:28 -0400
Received: by mail-oi0-f66.google.com with SMTP id q71-v6so16726093oic.6
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2018 10:16:28 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [RFC v6 06/11] nl80211: Add SOCKET_OWNER support to JOIN_MESH
Date: Mon, 26 Mar 2018 12:16:09 -0500
Message-Id: <20180326171614.20373-7-denkenz@gmail.com> (sfid-20180326_191716_616859_74A59A41)
In-Reply-To: <20180326171614.20373-1-denkenz@gmail.com>
References: <20180326171614.20373-1-denkenz@gmail.com>
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
index 2f630ee3240b..05b903958894 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10153,7 +10153,15 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
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
