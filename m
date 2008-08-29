Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39705 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889AbYH2SCD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 14:02:03 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] iw: Add support to send a request to set the regulatory domain
Date: Fri, 29 Aug 2008 11:01:59 -0700
Message-ID: <1220032919-6821-1-git-send-email-lrodriguez@atheros.com> (sfid-20080829_200208_951670_150C15D9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You can set the regulatory domain with this now.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 COPYING  |    1 +
 Makefile |    2 +-
 iw.c     |   10 ++++-
 iw.h     |    3 +
 reg.c    |  155 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 169 insertions(+), 2 deletions(-)
 create mode 100644 reg.c

diff --git a/COPYING b/COPYING
index 1ba9ded..fc9a519 100644
--- a/COPYING
+++ b/COPYING
@@ -1,6 +1,7 @@
 Copyright (c) 2007, 2008	Johannes Berg
 Copyright (c) 2007		Andy Lutomirski
 Copyright (c) 2007		Mike Kershaw
+Copyright (c) 2008		Luis R. Rodriguez
 
 All rights reserved.
 
diff --git a/Makefile b/Makefile
index c6990cc..0c0bfbe 100644
--- a/Makefile
+++ b/Makefile
@@ -8,7 +8,7 @@ CFLAGS += -I/lib/modules/`uname -r`/build/include
 CFLAGS += -O2 -g
 LDFLAGS += -lnl
 
-OBJS = iw.o interface.o info.o station.o util.o mpath.o
+OBJS = iw.o interface.o info.o station.o util.o mpath.o reg.o
 ALL = iw
 
 ifeq ($(V),1)
diff --git a/iw.c b/iw.c
index 2661d7c..09a04cb 100644
--- a/iw.c
+++ b/iw.c
@@ -93,7 +93,8 @@ static int get_phy_or_dev(int *argc, char ***argv, char **name)
 static void usage(char *argv0)
 {
 	fprintf(stderr, "Usage:	%1$s dev <phydev> <OBJECT> <COMMAND> [OPTIONS]"
-			"\n	%1$s dev <phydev> info\n"
+			"\n	%1$s dev <phydev> info"
+			"\n	%1$s reg set <ISO/IEC 3166-1 alpha2>\n"
 			"\n"
 			"where OBJECT := { interface | station | mpath | info }\n"
 			"and COMMAND := { add | del | set | get | dump }\n",
@@ -119,6 +120,13 @@ int main(int argc, char **argv)
 		goto out;
 	}
 
+	if (strcmp(argv[0], "reg") == 0) {
+		argc--;
+		argv++;
+		err = handle_reg(&nlstate, argc, argv);
+		goto out;
+	}
+
 	pod = get_phy_or_dev(&argc, &argv, &ifname);
 	if (pod == 0) {
 		err = 1;
diff --git a/iw.h b/iw.h
index 0ece3af..e023059 100644
--- a/iw.h
+++ b/iw.h
@@ -25,6 +25,9 @@ int handle_station(struct nl80211_state *state,
 int handle_mpath(struct nl80211_state *state,
 		   char *dev, int argc, char **argv);
 
+int handle_reg(struct nl80211_state *state,
+		   int argc, char **argv);
+
 int mac_addr_a2n(unsigned char *mac_addr, char *arg);
 int mac_addr_n2a(char *mac_addr, unsigned char *arg);
 
diff --git a/reg.c b/reg.c
new file mode 100644
index 0000000..b8f5fa2
--- /dev/null
+++ b/reg.c
@@ -0,0 +1,155 @@
+#include <linux/nl80211.h>
+#include <net/if.h>
+#include <errno.h>
+#include <string.h>
+
+#include <netlink/genl/genl.h>
+#include <netlink/genl/family.h>
+#include <netlink/genl/ctrl.h>
+#include <netlink/msg.h>
+#include <netlink/attr.h>
+
+#include "iw.h"
+
+static int wait_handler(struct nl_msg *msg, void *arg)
+{
+	int *finished = arg;
+
+	*finished = 1;
+	return NL_STOP;
+}
+
+static int error_handler(struct sockaddr_nl *nla, struct nlmsgerr *err,
+			 void *arg)
+{
+	fprintf(stderr, "nl80211 error %d\n", err->error);
+	exit(err->error);
+}
+
+static int reg_handler(struct nl_msg *msg, void *arg)
+{
+        return NL_SKIP;
+}
+
+int isalpha_upper(char letter)
+{
+	if (letter >= 65 && letter <= 90)
+		return 1;
+	return 0;
+}
+
+static int is_alpha2(char *alpha2)
+{
+	if (isalpha_upper(alpha2[0]) && isalpha_upper(alpha2[1]))
+		return 1;
+	return 0;
+}
+
+static int is_world_regdom(char *alpha2)
+{
+	/* ASCII 0 */
+	if (alpha2[0] == 48 && alpha2[1] == 48)
+		return 1;
+	return 0;
+}
+
+static int handle_reg_set(struct nl80211_state *state,
+			int argc, char **argv)
+{
+	struct nl_msg *msg;
+	struct nl_cb *cb = NULL;
+	int ret = -1;
+	int err;
+	int finished = 0;
+	char alpha2[3];
+
+	if (argc < 1) {
+		fprintf(stderr, "not enough arguments\n");
+		return -1;
+	}
+
+	if (!is_alpha2(argv[0]) && !is_world_regdom(argv[0])) {
+		fprintf(stderr, "not a valid ISO/IEC 3166-1 alpha2\n");
+		fprintf(stderr, "Special non-alph2 usable entries:\n");
+		fprintf(stderr, "\t00\tWorld Regulatory domain\n");
+		return -1;
+	}
+
+	alpha2[0] = argv[0][0];
+	alpha2[1] = argv[0][1];
+	alpha2[2] = '\0';
+
+	argc--;
+	argv++;
+
+	if (argc) {
+		fprintf(stderr, "too many arguments\n");
+		return -1;
+	}
+
+	msg = nlmsg_alloc();
+	if (!msg)
+		goto out;
+
+	genlmsg_put(msg, 0, 0, genl_family_get_id(state->nl80211), 0,
+		    0, NL80211_CMD_ASK_SET_REG, 0);
+
+	NLA_PUT_STRING(msg, NL80211_ATTR_REG_ALPHA2, alpha2);
+
+	cb = nl_cb_alloc(NL_CB_CUSTOM);
+	if (!cb)
+		goto out;
+
+	err = nl_send_auto_complete(state->nl_handle, msg);
+
+	if (err < 0) {
+		fprintf(stderr, "failed to send reg set command\n");
+		goto out;
+	}
+
+	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, reg_handler, NULL);
+	nl_cb_set(cb, NL_CB_ACK, NL_CB_CUSTOM, wait_handler, &finished);
+	nl_cb_err(cb, NL_CB_CUSTOM, error_handler, NULL);
+
+	err = nl_recvmsgs(state->nl_handle, cb);
+
+	if (!finished) {
+		err = nl_wait_for_ack(state->nl_handle);
+	}
+
+	if (err < 0)
+		goto out;
+
+	ret = 0;
+
+ out:
+	nl_cb_put(cb);
+ nla_put_failure:
+	nlmsg_free(msg);
+	return ret;
+}
+
+int handle_reg(struct nl80211_state *state,
+		   int argc, char **argv)
+{
+	char *cmd = argv[0];
+
+	if (argc < 1) {
+		fprintf(stderr, "you must specify an station command\n");
+		return -1;
+	}
+
+	argc--;
+	argv++;
+
+	/* XXX: write support for getting the currently set regdomain
+	if (strcmp(cmd, "get") == 0)
+		return handle_reg_get(state, argc, argv);
+	*/
+
+	if (strcmp(cmd, "set") == 0)
+		return handle_reg_set(state, argc, argv);
+
+	printf("invalid regulatory command %s\n", cmd);
+	return -1;
+}
-- 
1.5.6.4

