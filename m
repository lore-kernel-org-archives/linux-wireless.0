Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:1889 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754608Ab0ELI1w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 04:27:52 -0400
Received: from vs3010.wh2.ocn.ne.jp (125.206.180.173)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0442662870
	for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 17:27:50 +0900 (JST)
Subject: [PATCH 3/3] iw: Add antenna set/get
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, holgerschurig@gmail.com
Date: Wed, 12 May 2010 17:27:51 +0900
Message-ID: <20100512082751.26746.43302.stgit@tt-desk>
In-Reply-To: <20100512082516.26746.19520.stgit@tt-desk>
References: <20100512082516.26746.19520.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add commands to set and get the antenna configuration. The antenna
configuration is defined as a bitmap of 8 antennas. When multiple antennas are
selected the driver may use diversity. Also the driver may reject antenna
configurations it cannot support.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 Makefile  |    2 +
 antenna.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 util.c    |    2 +
 3 files changed, 91 insertions(+), 1 deletions(-)
 create mode 100644 antenna.c

diff --git a/Makefile b/Makefile
index d303f45..e526cda 100644
--- a/Makefile
+++ b/Makefile
@@ -17,7 +17,7 @@ CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing
 OBJS = iw.o genl.o event.o info.o phy.o \
 	interface.o ibss.o station.o survey.o util.o \
 	mesh.o mpath.o scan.o reg.o version.o \
-	reason.o status.o connect.o link.o offch.o ps.o cqm.o
+	reason.o status.o connect.o link.o offch.o ps.o cqm.o antenna.o
 OBJS += sections.o
 ALL = iw
 
diff --git a/antenna.c b/antenna.c
new file mode 100644
index 0000000..5869aa6
--- /dev/null
+++ b/antenna.c
@@ -0,0 +1,88 @@
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
+#include "nl80211.h"
+#include "iw.h"
+
+SECTION(antenna);
+
+static int set_antenna(struct nl80211_state *state,
+			struct nl_cb *cb,
+			struct nl_msg *msg,
+			int argc, char **argv)
+{
+	char *end;
+	uint8_t tx_ant = 0, rx_ant = 0;
+
+	if (argc == 1)
+		tx_ant = rx_ant = strtoul(argv[0], &end, 10);
+	else if (argc == 4)
+	{
+		while (argc) {
+			if (strcmp(*argv, "tx") == 0 ||
+			    strcmp(*argv, "rx") == 0) {
+				if (strcmp(*argv, "tx") == 0)
+					tx_ant = strtoul(argv[1], &end, 10);
+				else
+					rx_ant = strtoul(argv[1], &end, 10);
+				argv = argv + 2;
+				argc = argc - 2;
+			}
+		}
+	}
+
+	if (*end || !tx_ant || !rx_ant)
+		return 1;
+
+	NLA_PUT_U8(msg, NL80211_ATTR_ANTENNA_TX, tx_ant);
+	NLA_PUT_U8(msg, NL80211_ATTR_ANTENNA_RX, rx_ant);
+	return 0;
+
+ nla_put_failure:
+	return -ENOBUFS;
+}
+
+COMMAND(antenna, set, "<bitmap> | tx <bitmap> rx <bitmap>",
+	NL80211_CMD_SET_ANTENNA, 0, CIB_PHY, set_antenna,
+	"Set a bitmap of allowed antennas to use for TX and RX.\n"
+	"The driver may reject antenna configurations it cannot support.");
+
+
+static int print_antenna_handler(struct nl_msg *msg, void *arg)
+{
+	struct nlattr *attrs[NL80211_ATTR_MAX + 1];
+	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
+	uint8_t tx_ant, rx_ant;
+
+	nla_parse(attrs, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
+		  genlmsg_attrlen(gnlh, 0), NULL);
+
+	if (!attrs[NL80211_ATTR_ANTENNA_TX] || !attrs[NL80211_ATTR_ANTENNA_RX])
+		return NL_SKIP;
+
+	tx_ant = nla_get_u8(attrs[NL80211_ATTR_ANTENNA_TX]);
+	rx_ant = nla_get_u8(attrs[NL80211_ATTR_ANTENNA_RX]);
+
+	printf("Antenna configuration: tx %d rx %d\n", tx_ant, rx_ant);
+
+	return NL_SKIP;
+}
+
+static int get_antenna(struct nl80211_state *state,
+			struct nl_cb *cb,
+			struct nl_msg *msg,
+			int argc, char **argv)
+{
+	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, print_antenna_handler, NULL);
+	return 0;
+}
+
+COMMAND(antenna, get, NULL, NL80211_CMD_GET_ANTENNA, 0, CIB_PHY, get_antenna,
+	"Retrieve antenna configuration.");
diff --git a/util.c b/util.c
index 0c6d978..7d971ac 100644
--- a/util.c
+++ b/util.c
@@ -166,6 +166,8 @@ static const char *commands[NL80211_CMD_MAX + 1] = {
 	[NL80211_CMD_REGISTER_ACTION] = "register_action",
 	[NL80211_CMD_ACTION] = "action",
 	[NL80211_CMD_SET_CHANNEL] = "set_channel",
+	[NL80211_CMD_SET_ANTENNA] = "antenna_set",
+	[NL80211_CMD_GET_ANTENNA] = "antenna_get",
 };
 
 static char cmdbuf[100];

