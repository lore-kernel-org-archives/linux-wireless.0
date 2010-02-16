Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:46309 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757Ab0BPUNb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 15:13:31 -0500
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o1GKDShA029008
	for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2010 22:13:29 +0200
Received: from [127.0.1.1] (essapo-nirac25384.europe.nokia.com [10.162.253.84])
	by mgw-sa01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o1GKDGJf014728
	for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2010 22:13:17 +0200
Subject: [RFC PATCH 2/2] iw: add set/get power_save commands
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 16 Feb 2010 22:13:16 +0200
Message-ID: <20100216201316.25291.18969.stgit@tikku>
In-Reply-To: <20100216201026.25148.40799.stgit@tikku>
References: <20100216201026.25148.40799.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


---
 Makefile |    2 +
 ps.c     |   83 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+), 1 deletions(-)
 create mode 100644 ps.c

diff --git a/Makefile b/Makefile
index bae1bfb..b0a4278 100644
--- a/Makefile
+++ b/Makefile
@@ -17,7 +17,7 @@ CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing
 OBJS = iw.o genl.o event.o info.o phy.o \
 	interface.o ibss.o station.o survey.o util.o \
 	mesh.o mpath.o scan.o reg.o version.o \
-	reason.o status.o connect.o link.o offch.o
+	reason.o status.o connect.o link.o offch.o ps.o
 OBJS += sections.o
 ALL = iw
 
diff --git a/ps.c b/ps.c
new file mode 100644
index 0000000..9b0614c
--- /dev/null
+++ b/ps.c
@@ -0,0 +1,83 @@
+#include <errno.h>
+#include <string.h>
+
+#include <netlink/genl/genl.h>
+#include <netlink/msg.h>
+#include <netlink/attr.h>
+
+#include "nl80211.h"
+#include "iw.h"
+
+static int set_power_save(struct nl80211_state *state,
+			  struct nl_cb *cb,
+			  struct nl_msg *msg,
+			  int argc, char **argv)
+{
+	enum nl80211_ps_state ps_state;
+
+	if (argc != 1) {
+		printf("Invalid parameters!\n");
+		return 2;
+	}
+
+	if (strcmp(argv[0], "on") == 0)
+		ps_state = NL80211_PS_ENABLED;
+	else if (strcmp(argv[0], "off") == 0)
+		ps_state = NL80211_PS_DISABLED;
+	else {
+		printf("Invalid parameter: %s\n", argv[0]);
+		return 2;
+	}
+
+	NLA_PUT_U8(msg, NL80211_ATTR_PS_STATE, ps_state);
+
+	return 0;
+
+ nla_put_failure:
+	return -ENOBUFS;
+}
+
+COMMAND(set, power_save, "<on|off>",
+	NL80211_CMD_SET_POWER_SAVE, 0, CIB_NETDEV, set_power_save,
+	"Set power save state to on or off.");
+
+static int print_power_save_handler(struct nl_msg *msg, void *arg)
+{
+	struct nlattr *attrs[NL80211_ATTR_MAX + 1];
+	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
+	const char *s;
+
+	nla_parse(attrs, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
+		  genlmsg_attrlen(gnlh, 0), NULL);
+
+	if (!attrs[NL80211_ATTR_PS_STATE])
+		return NL_SKIP;
+
+	switch (nla_get_u8(attrs[NL80211_ATTR_PS_STATE])) {
+	case NL80211_PS_ENABLED:
+		s = "on";
+		break;
+	case NL80211_PS_DISABLED:
+	default:
+		s = "off";
+		break;
+	}
+
+	printf("Power save: %s\n", s);
+
+	return NL_SKIP;
+}
+
+static int get_power_save(struct nl80211_state *state,
+				   struct nl_cb *cb,
+				   struct nl_msg *msg,
+				   int argc, char **argv)
+{
+	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM,
+		  print_power_save_handler, NULL);
+	return 0;
+}
+
+COMMAND(get, power_save, "<param>",
+	NL80211_CMD_GET_POWER_SAVE, 0, CIB_NETDEV, get_power_save,
+	"Retrieve power save state.");

