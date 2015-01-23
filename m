Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:46791 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbbAWPYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 10:24:30 -0500
Received: by mail-wi0-f176.google.com with SMTP id em10so3584808wid.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2015 07:24:28 -0800 (PST)
From: Vadim Kochan <vadim4j@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Vadim Kochan <vadim4j@gmail.com>
Subject: [RFC iw next] phy: Allow set netns by fd
Date: Fri, 23 Jan 2015 17:13:47 +0200
Message-Id: <1422026027-5806-1-git-send-email-vadim4j@gmail.com> (sfid-20150123_162433_668129_A5F1E60F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vadim Kochan <vadim4j@gmail.com>

Added possibility to change network namespace
for phy device by network namespace name from
/var/run/netns or by absolute file path:

    iw phy XXX set netns <nsname> | <pid>

First iw tries to find given nsname from /var/run/netns
or by absoute path (in case if nsname contains "/") and if
it failed to open nsname file then iw uses given argument as <pid>.

Also added missing NL80211 attributes before NL80211_CMD_SET_WIPHY_NETNS.

Signed-off-by: Vadim Kochan <vadim4j@gmail.com>
---
 nl80211.h |  6 ++++++
 phy.c     | 44 ++++++++++++++++++++++++++++++++++++++------
 2 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index c0383e9..a200a0b 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -2072,6 +2072,12 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_WIPHY_SELF_MANAGED_REG,
 
+	NL80211_ATTR_EXT_FEATURES,
+
+	NL80211_ATTR_SURVEY_RADIO_STATS,
+
+	NL80211_ATTR_NETNS_FD,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/phy.c b/phy.c
index aab462d..8d51ed6 100644
--- a/phy.c
+++ b/phy.c
@@ -2,6 +2,9 @@
 #include <errno.h>
 #include <net/if.h>
 #include <strings.h>
+#include <sys/param.h>
+#include <sys/stat.h>
+#include <fcntl.h>
 
 #include <netlink/genl/genl.h>
 #include <netlink/genl/family.h>
@@ -296,6 +299,24 @@ COMMAND(set, retry, "[short <limit>] [long <limit>]",
 	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_retry,
 	"Set retry limit.");
 
+#ifndef NETNS_RUN_DIR
+#define NETNS_RUN_DIR "/var/run/netns"
+#endif
+int netns_get_fd(const char *name)
+{
+	char pathbuf[MAXPATHLEN];
+	const char *path, *ptr;
+
+	path = name;
+	ptr = strchr(name, '/');
+	if (!ptr) {
+		snprintf(pathbuf, sizeof(pathbuf), "%s/%s",
+			NETNS_RUN_DIR, name );
+		path = pathbuf;
+	}
+	return open(path, O_RDONLY);
+}
+
 static int handle_netns(struct nl80211_state *state,
 			struct nl_cb *cb,
 			struct nl_msg *msg,
@@ -303,6 +324,7 @@ static int handle_netns(struct nl80211_state *state,
 			enum id_input id)
 {
 	char *end;
+	int fd;
 
 	if (argc != 1)
 		return 1;
@@ -310,19 +332,29 @@ static int handle_netns(struct nl80211_state *state,
 	if (!*argv[0])
 		return 1;
 
-	NLA_PUT_U32(msg, NL80211_ATTR_PID,
-		    strtoul(argv[0], &end, 10));
+	if ((fd = netns_get_fd(argv[0])) >= 0) {
+		NLA_PUT_U32(msg, NL80211_ATTR_NETNS_FD, fd);
+	} else {
+		NLA_PUT_U32(msg, NL80211_ATTR_PID,
+				strtoul(argv[0], &end, 10));
+		if (*end != '\0')
+			return 1;
 
-	if (*end != '\0')
-		return 1;
+	}
 
 	return 0;
+
  nla_put_failure:
 	return -ENOBUFS;
 }
-COMMAND(set, netns, "<pid>",
+COMMAND(set, netns, "<nsname> | <pid>",
 	NL80211_CMD_SET_WIPHY_NETNS, 0, CIB_PHY, handle_netns,
-	"Put this wireless device into a different network namespace");
+	"Put this wireless device into a different network namespace:\n"
+	"    <nsname> - change network namespace by name from "NETNS_RUN_DIR"\n"
+	"               or by absolute path (man ip-netns)\n"
+	"    <pid>    - change network namespace by process id\n"
+	"If <nsname> file does not exist then given argument is used as <pid>\n"
+	);
 
 static int handle_coverage(struct nl80211_state *state,
 			struct nl_cb *cb,
-- 
2.1.3

