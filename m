Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64318 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab3I3JoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 05:44:17 -0400
Received: by mail-wi0-f171.google.com with SMTP id hm2so3505730wib.10
        for <linux-wireless@vger.kernel.org>; Mon, 30 Sep 2013 02:44:16 -0700 (PDT)
From: Javier Lopez <jlopex@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Javier Lopez <jlopex@cozybit.com>
Subject: [PATCH] iw: use nl80211 for phy_lookup function
Date: Mon, 30 Sep 2013 11:44:03 +0200
Message-Id: <1380534243-4766-1-git-send-email-jlopex@cozybit.com> (sfid-20130930_114422_983945_3555D805)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Original implementation uses sysfs to get dev index from
dev name. Due the changes on netns and sysfs iw is broken
if using multiple network namespaces. iw works properly
if using it from the main namespace, but it won't work if
using from the new namespace.

Kernel commit 3ff195b0, "sysfs: Implement sysfs tagged
directory support" patch, added a filtering mechanism
to sysfs, allowing sysfs directories to look different
depending on the context where they are being observed.

When an interface is moved to another namespace, the
interface dissapears from sysfs structure. In order
to recover access to the directory a solution is to
remount sysfs from the correct context. This will force
the user to remount sysfs before using iw from a
different namespace.

To avoid this issue we can use nl80211 (using
NL80211_CMD_GET_WIPHY command) this returns the list of
phys, then process the list, find the device and return
the device index.

Signed-off-by: Javier Lopez <jlopex@cozybit.com>
---
 iw.c |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 78 insertions(+), 23 deletions(-)

diff --git a/iw.c b/iw.c
index dc99566..23c0386 100644
--- a/iw.c
+++ b/iw.c
@@ -23,6 +23,12 @@
 #include "nl80211.h"
 #include "iw.h"
 
+struct lookup_data
+{
+	char *name;
+	int idx;
+};
+
 /* libnl 1.x compatibility code */
 #if !defined(CONFIG_LIBNL20) && !defined(CONFIG_LIBNL30)
 static inline struct nl_handle *nl_socket_alloc(void)
@@ -251,26 +257,6 @@ static void version(void)
 	printf("iw version %s\n", iw_version);
 }
 
-static int phy_lookup(char *name)
-{
-	char buf[200];
-	int fd, pos;
-
-	snprintf(buf, sizeof(buf), "/sys/class/ieee80211/%s/index", name);
-
-	fd = open(buf, O_RDONLY);
-	if (fd < 0)
-		return -1;
-	pos = read(fd, buf, sizeof(buf) - 1);
-	if (pos < 0) {
-		close(fd);
-		return -1;
-	}
-	buf[pos] = '\0';
-	close(fd);
-	return atoi(buf);
-}
-
 static int error_handler(struct sockaddr_nl *nla, struct nlmsgerr *err,
 			 void *arg)
 {
@@ -293,6 +279,75 @@ static int ack_handler(struct nl_msg *msg, void *arg)
 	return NL_STOP;
 }
 
+static int lookup_handler(struct nl_msg *msg, void *arg)
+{
+	struct nlattr *tb_msg[NL80211_ATTR_MAX + 1];
+	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
+	struct lookup_data *data = (struct lookup_data*) arg;
+
+	nla_parse(tb_msg, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
+		  genlmsg_attrlen(gnlh, 0), NULL);
+
+	if (tb_msg[NL80211_ATTR_WIPHY_NAME]) {
+		if (strcmp(nla_get_string(tb_msg[NL80211_ATTR_WIPHY_NAME]),
+		    data->name) == 0)  {
+			data->idx = nla_get_u32(tb_msg[NL80211_ATTR_WIPHY]);
+			return NL_STOP;
+		}
+	}
+	return NL_SKIP;
+}
+
+static int phy_lookup(struct nl80211_state *state, char *name)
+{
+	struct nl_cb *cb;
+	struct nl_msg *msg;
+	struct lookup_data data;
+	int err;
+
+	data.name = name;
+	data.idx = -1;
+
+	msg = nlmsg_alloc();
+	if (!msg) {
+		fprintf(stderr, "failed to allocate netlink message\n");
+		return -ENOMEM;
+	}
+
+	cb = nl_cb_alloc(iw_debug ? NL_CB_DEBUG : NL_CB_DEFAULT);
+	if (!cb) {
+		fprintf(stderr, "failed to allocate netlink callbacks\n");
+		err = -ENOMEM;
+		goto out_free_msg;
+	}
+
+	genlmsg_put(msg, 0, 0, state->nl80211_id, 0,
+		    NLM_F_DUMP, NL80211_CMD_GET_WIPHY, 0);
+
+	err = nl_send_auto_complete(state->nl_sock, msg);
+	if (err < 0)
+		goto out;
+
+	err = 1;
+
+	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, lookup_handler, &data);
+	nl_cb_err(cb, NL_CB_CUSTOM, error_handler, &err);
+	nl_cb_set(cb, NL_CB_FINISH, NL_CB_CUSTOM, finish_handler, &err);
+	nl_cb_set(cb, NL_CB_ACK, NL_CB_CUSTOM, ack_handler, &err);
+
+	while (err > 0)
+		nl_recvmsgs(state->nl_sock, cb);
+ out:
+	nl_cb_put(cb);
+ out_free_msg:
+	nlmsg_free(msg);
+	if (data.idx != -1)
+		return data.idx;
+	else if (err == 0)
+		return -ENODEV;
+	return err;
+}
+
 static int __handle_cmd(struct nl80211_state *state, enum id_input idby,
 			int argc, char **argv, const struct cmd **cmdout)
 {
@@ -323,7 +378,7 @@ static int __handle_cmd(struct nl80211_state *state, enum id_input idby,
 		break;
 	case II_PHY_NAME:
 		command_idby = CIB_PHY;
-		devidx = phy_lookup(*argv);
+		devidx = phy_lookup(state, *argv);
 		argc--;
 		argv++;
 		break;
@@ -347,7 +402,7 @@ static int __handle_cmd(struct nl80211_state *state, enum id_input idby,
 	}
 
 	if (devidx < 0)
-		return -errno;
+		return devidx;
 
 	section = *argv;
 	argc--;
@@ -548,7 +603,7 @@ int main(int argc, char **argv)
  detect:
 		if ((idx = if_nametoindex(argv[0])) != 0)
 			idby = II_NETDEV;
-		else if ((idx = phy_lookup(argv[0])) >= 0)
+		else if ((idx = phy_lookup(&nlstate, argv[0])) >= 0)
 			idby = II_PHY_NAME;
 		err = __handle_cmd(&nlstate, idby, argc, argv, &cmd);
 	}
-- 
1.7.9.5

