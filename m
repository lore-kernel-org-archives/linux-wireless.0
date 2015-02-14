Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:46208 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbbBNHoT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Feb 2015 02:44:19 -0500
Received: by mail-lb0-f180.google.com with SMTP id z12so19297763lbi.11
        for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2015 23:44:17 -0800 (PST)
From: Vadim Kochan <vadim4j@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Vadim Kochan <vadim4j@gmail.com>
Subject: [PATCH iw] phy: Allow set netns by fd
Date: Sat, 14 Feb 2015 09:33:12 +0200
Message-Id: <1423899192-4315-1-git-send-email-vadim4j@gmail.com> (sfid-20150214_084422_521515_CB673939)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vadim Kochan <vadim4j@gmail.com>

Added possibility to change network namespace
for phy device by network namespace name from
/var/run/netns or by absolute file path:

iw phy XXX set netns name <nsname>

iw tries to open fd of given nsname from /var/run/netns
or by absoute path if nsname contains "/".

Signed-off-by: Vadim Kochan <vadim4j@gmail.com>
---
 phy.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 46 insertions(+), 9 deletions(-)

diff --git a/phy.c b/phy.c
index aab462d..271c9d9 100644
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
@@ -303,26 +324,42 @@ static int handle_netns(struct nl80211_state *state,
 			enum id_input id)
 {
 	char *end;
+	int fd;
 
-	if (argc != 1)
+	if (argc < 1 || !*argv[0])
 		return 1;
 
-	if (!*argv[0])
+	if (argc == 1) {
+		NLA_PUT_U32(msg, NL80211_ATTR_PID,
+				strtoul(argv[0], &end, 10));
+		if (*end != '\0') {
+			printf("Invalid parameter: pid(%s)\n", argv[0]);
+			return 1;
+		}
+		return 0;
+	}
+
+	if (argc != 2 || strcmp(argv[0], "name"))
 		return 1;
 
-	NLA_PUT_U32(msg, NL80211_ATTR_PID,
-		    strtoul(argv[0], &end, 10));
+	if ((fd = netns_get_fd(argv[1])) >= 0) {
+		NLA_PUT_U32(msg, NL80211_ATTR_NETNS_FD, fd);
+		return 0;
+	} else {
+		printf("Invalid parameter: nsname(%s)\n", argv[0]);
+	}
 
-	if (*end != '\0')
-		return 1;
+	return 1;
 
-	return 0;
  nla_put_failure:
 	return -ENOBUFS;
 }
-COMMAND(set, netns, "<pid>",
+COMMAND(set, netns, "{ <pid> | name <nsname> }",
 	NL80211_CMD_SET_WIPHY_NETNS, 0, CIB_PHY, handle_netns,
-	"Put this wireless device into a different network namespace");
+	"Put this wireless device into a different network namespace:\n"
+	"    <pid>    - change network namespace by process id\n"
+	"    <nsname> - change network namespace by name from "NETNS_RUN_DIR"\n"
+	"               or by absolute path (man ip-netns)\n");
 
 static int handle_coverage(struct nl80211_state *state,
 			struct nl_cb *cb,
-- 
2.2.2

