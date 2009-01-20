Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:36505 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759240AbZATSKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 13:10:31 -0500
Date: Tue, 20 Jan 2009 18:36:32 +0100
From: Daniel Wagner <wagi@monom.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] libnl API change struct nl_handle renamed to struct libnl_sock
Message-ID: <20090120173632.GA30815@toronto053.server4you.de> (sfid-20090120_191056_312902_E5C1A2BF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Daniel Wagner <wagi@monom.org>
---
 I had to patch the iw HEAD to get it compiled against the libnl HEAD.

 genl.c |    8 ++++----
 iw.h   |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/genl.c b/genl.c
index e99ea9d..6091b97 100644
--- a/genl.c
+++ b/genl.c
@@ -64,7 +64,7 @@ static int family_handler(struct nl_msg *msg, void *arg)
 	return NL_SKIP;
 }
 
-int nl_get_multicast_id(struct nl_handle *handle, const char *family, const char *group)
+int nl_get_multicast_id(struct nl_sock *sock, const char *family, const char *group)
 {
 	struct nl_msg *msg;
 	struct nl_cb *cb;
@@ -84,7 +84,7 @@ int nl_get_multicast_id(struct nl_handle *handle, const char *family, const char
 		goto out_fail_cb;
 	}
 
-	ctrlid = genl_ctrl_resolve(handle, "nlctrl");
+	ctrlid = genl_ctrl_resolve(sock, "nlctrl");
 
         genlmsg_put(msg, 0, 0, ctrlid, 0,
 		    0, CTRL_CMD_GETFAMILY, 0);
@@ -92,7 +92,7 @@ int nl_get_multicast_id(struct nl_handle *handle, const char *family, const char
 	ret = -ENOBUFS;
 	NLA_PUT_STRING(msg, CTRL_ATTR_FAMILY_NAME, family);
 
-	ret = nl_send_auto_complete(handle, msg);
+	ret = nl_send_auto_complete(sock, msg);
 	if (ret < 0)
 		goto out;
 
@@ -103,7 +103,7 @@ int nl_get_multicast_id(struct nl_handle *handle, const char *family, const char
 	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, family_handler, &grp);
 
 	while (ret > 0)
-		nl_recvmsgs(handle, cb);
+		nl_recvmsgs(sock, cb);
 
 	if (ret == 0)
 		ret = grp.id;
diff --git a/iw.h b/iw.h
index 14b7fa5..5a260ce 100644
--- a/iw.h
+++ b/iw.h
@@ -66,6 +66,6 @@ const char *iftype_name(enum nl80211_iftype iftype);
 int ieee80211_channel_to_frequency(int chan);
 int ieee80211_frequency_to_channel(int freq);
 
-int nl_get_multicast_id(struct nl_handle *handle, const char *family, const char *group);
+int nl_get_multicast_id(struct nl_sock *sock, const char *family, const char *group);
 
 #endif /* __IW_H */
-- 
1.6.1


