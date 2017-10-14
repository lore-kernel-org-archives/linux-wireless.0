Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0066.outbound.protection.outlook.com ([104.47.33.66]:21536
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750973AbdJNVCY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 14 Oct 2017 17:02:24 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH] iw: add command to register and capture mgmt frames
Date: Sun, 15 Oct 2017 00:00:36 +0300
Message-Id: <20171014210036.29556-1-sergey.matyukevich.os@quantenna.com> (sfid-20171014_230318_416688_A24AC9E0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new command to register for receiving multiple mgmt frames,
capture and print them. Frames are selected by their type and
pattern containing their the first several bytes of the frame
that should match.

Format:
$ iw dev <devname> frame <type> <pattern> [frame <type> <pattern>]* [count <frames>]

Example:
$ iw dev wlan0 mgmt capture frame 40 00 frame 40 01:02 count 10

Frame type is supplied as hex w/o leading 0x. Frame pattern is supplied
as hex pattern of the form aa:bb:cc w/o leading 0x as well.
Count is a number of frames to capture.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 Makefile |   2 +-
 mgmt.c   | 149 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 150 insertions(+), 1 deletion(-)
 create mode 100644 mgmt.c

diff --git a/Makefile b/Makefile
index e61825e..38d782d 100644
--- a/Makefile
+++ b/Makefile
@@ -17,7 +17,7 @@ OBJS = iw.o genl.o event.o info.o phy.o \
 	interface.o ibss.o station.o survey.o util.o ocb.o \
 	mesh.o mpath.o mpp.o scan.o reg.o version.o \
 	reason.o status.o connect.o link.o offch.o ps.o cqm.o \
-	bitrate.o wowlan.o coalesce.o roc.o p2p.o vendor.o
+	bitrate.o wowlan.o coalesce.o roc.o p2p.o vendor.o mgmt.o
 OBJS += sections.o
 
 OBJS-$(HWSIM) += hwsim.o
diff --git a/mgmt.c b/mgmt.c
new file mode 100644
index 0000000..c42d802
--- /dev/null
+++ b/mgmt.c
@@ -0,0 +1,149 @@
+#include <string.h>
+#include <errno.h>
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
+SECTION(mgmt);
+
+static int seq_handler(struct nl_msg *msg, void *arg)
+{
+	return NL_OK;
+}
+
+static int dump_mgmt_frame(struct nl_msg *msg, void *arg)
+{
+	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
+	struct nlattr *tb_msg[NL80211_ATTR_MAX + 1];
+
+	nla_parse(tb_msg, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
+		  genlmsg_attrlen(gnlh, 0), NULL);
+
+	if (tb_msg[NL80211_ATTR_WIPHY_FREQ]) {
+		uint32_t freq = nla_get_u32(tb_msg[NL80211_ATTR_WIPHY_FREQ]);
+		printf("freq %u MHz\n", freq);
+	}
+
+	if (tb_msg[NL80211_ATTR_RX_SIGNAL_DBM]) {
+		uint32_t dbm = nla_get_u32(tb_msg[NL80211_ATTR_RX_SIGNAL_DBM]);
+		printf("signal %u dbm\n", dbm);
+	}
+
+	if (tb_msg[NL80211_ATTR_FRAME]) {
+		int len = nla_len(tb_msg[NL80211_ATTR_FRAME]);
+		uint8_t *data = nla_data(tb_msg[NL80211_ATTR_FRAME]);
+		iw_hexdump("mgmt frame", data, len);
+	}
+
+	return 0;
+}
+
+static int register_mgmt_frame(struct nl80211_state *state,
+			       struct nl_msg *msg, int argc, char **argv,
+			       enum id_input id)
+{
+	unsigned int type;
+	unsigned char *match;
+	size_t match_len;
+	int ret;
+
+	ret = sscanf(argv[0], "%x", &type);
+	if (ret != 1) {
+		printf("invalid frame type: %s\n", argv[0]);
+		return 2;
+	}
+
+	match = parse_hex(argv[1], &match_len);
+	if (!match) {
+		printf("invalid frame pattern: %s\n", argv[1]);
+		return 2;
+	}
+
+	NLA_PUT_U16(msg, NL80211_ATTR_FRAME_TYPE, type);
+	NLA_PUT(msg, NL80211_ATTR_FRAME_MATCH, match_len, match);
+
+	return 0;
+
+nla_put_failure:
+	return -ENOBUFS;
+}
+
+static int handle_mgmt_reg(struct nl80211_state *state,
+				    struct nl_msg *msg, int argc,
+				    char **argv, enum id_input id)
+{
+	return register_mgmt_frame(state, msg, argc, argv, id);
+}
+
+HIDDEN(mgmt, reg, "", NL80211_CMD_REGISTER_FRAME, 0, CIB_NETDEV, handle_mgmt_reg);
+
+static int handle_mgmt_capture(struct nl80211_state *state,
+			       struct nl_msg *msg, int argc,
+			       char **argv, enum id_input id)
+{
+	struct nl_cb *mgmt_cb;
+	char *ndev = argv[0];
+	int mgmt_argc = 5;
+	char **mgmt_argv;
+	unsigned int count = 0;
+	int err = 0;
+	int i;
+
+	mgmt_argv = calloc(mgmt_argc, sizeof(char*));
+	if (!mgmt_argv)
+		return -ENOMEM;
+
+	mgmt_argv[0] = ndev;
+	mgmt_argv[1] = "mgmt";
+	mgmt_argv[2] = "reg";
+
+	for (i = 3; i < argc; i += 3) {
+		if (strcmp(argv[i], "count") == 0) {
+			count = 1 + atoi(argv[i + 1]);
+			break;
+		}
+
+		if (strcmp(argv[i], "frame") != 0) {
+			err = 1;
+			goto out;
+		}
+
+		mgmt_argv[3] = argv[i + 1];
+		mgmt_argv[4] = argv[i + 2];
+
+		err = handle_cmd(state, II_NETDEV, mgmt_argc, mgmt_argv);
+		if (err)
+			goto out;
+	}
+
+	mgmt_cb = nl_cb_alloc(iw_debug ? NL_CB_DEBUG : NL_CB_DEFAULT);
+	if (!mgmt_cb) {
+		err = 1;
+		goto out;
+	}
+
+	/* need to turn off sequence number checking */
+	nl_cb_set(mgmt_cb, NL_CB_SEQ_CHECK, NL_CB_CUSTOM, seq_handler, NULL);
+	nl_cb_set(mgmt_cb, NL_CB_VALID, NL_CB_CUSTOM, dump_mgmt_frame, NULL);
+
+	while (--count)
+		nl_recvmsgs(state->nl_sock, mgmt_cb);
+
+	nl_cb_put(mgmt_cb);
+out:
+	free(mgmt_argv);
+	return err;
+}
+
+COMMAND(mgmt, capture, "frame <type as hex ab> <pattern as hex ab:cd:..> [frame <type> <pattern>]* [count <frames>]",
+	0, 0, CIB_NETDEV, handle_mgmt_capture,
+	"Register for receiving certain mgmt frames, capture and print them.\n"
+	"Frames are selected by their type and pattern containing\n"
+	"the first several bytes of the frame that should match.\n\n"
+	"Example: iw dev wlan0 mgmt capture frame 40 00 frame 40 01:02 count 10\n");
-- 
2.11.0
