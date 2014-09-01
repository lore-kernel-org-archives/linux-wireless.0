Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:38362 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbaIALeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 07:34:37 -0400
Received: by mail-la0-f45.google.com with SMTP id pn19so5935232lab.32
        for <linux-wireless@vger.kernel.org>; Mon, 01 Sep 2014 04:34:35 -0700 (PDT)
From: Henning Rogge <hrogge@gmail.com>
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Subject: iw: Add support for mesh proxy path dump
Date: Mon, 01 Sep 2014 13:34:33 +0200
Message-ID: <1576867.1mLXgWJdDk@rogge-hp-probook-6470b> (sfid-20140901_133442_633761_8F11D401)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add "mpp get" and "mpp dump" command to query to mac80211s
mesh proxy path table.

Signed-off-by: Henning Rogge <henning.rogge@fkie.fraunhofer.de>
---
 Makefile  |  2 +-
 mpp.c     | 84 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 nl80211.h | 11 +++++++++
 3 files changed, 96 insertions(+), 1 deletion(-)
 create mode 100644 mpp.c

diff --git a/Makefile b/Makefile
index f042e30..c05b2c4 100644
--- a/Makefile
+++ b/Makefile
@@ -14,7 +14,7 @@ CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -
fno-strict-aliasing
 
 OBJS = iw.o genl.o event.o info.o phy.o \
 	interface.o ibss.o station.o survey.o util.o \
-	mesh.o mpath.o scan.o reg.o version.o \
+	mesh.o mpath.o mpp.o scan.o reg.o version.o \
 	reason.o status.o connect.o link.o offch.o ps.o cqm.o \
 	bitrate.o wowlan.o coalesce.o roc.o p2p.o
 OBJS += sections.o
diff --git a/mpp.c b/mpp.c
new file mode 100644
index 0000000..2d20d6b
--- /dev/null
+++ b/mpp.c
@@ -0,0 +1,84 @@
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
+SECTION(mpp);
+
+static int print_mpp_handler(struct nl_msg *msg, void *arg)
+{
+	struct nlattr *tb[NL80211_ATTR_MAX + 1];
+	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
+	char dst[20], next_hop[20], dev[20];
+
+	nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
+		  genlmsg_attrlen(gnlh, 0), NULL);
+
+	/*
+	 * TODO: validate the interface and mac address!
+	 * Otherwise, there's a race condition as soon as
+	 * the kernel starts sending mpath notifications.
+	 */
+
+	mac_addr_n2a(dst, nla_data(tb[NL80211_ATTR_MAC]));
+	mac_addr_n2a(next_hop, nla_data(tb[NL80211_ATTR_MPATH_NEXT_HOP]));
+	if_indextoname(nla_get_u32(tb[NL80211_ATTR_IFINDEX]), dev);
+	printf("%s %s %s\n", dst, next_hop, dev);
+
+	return NL_SKIP;
+}
+
+static int handle_mpp_get(struct nl80211_state *state,
+			  struct nl_cb *cb,
+			  struct nl_msg *msg,
+			  int argc, char **argv,
+			  enum id_input id)
+{
+	unsigned char dst[ETH_ALEN];
+
+	if (argc < 1)
+		return 1;
+
+	if (mac_addr_a2n(dst, argv[0])) {
+		fprintf(stderr, "invalid mac address\n");
+		return 2;
+	}
+	argc--;
+	argv++;
+
+	if (argc)
+		return 1;
+
+	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, dst);
+
+	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, print_mpp_handler, NULL);
+
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(mpp, get, "<MAC address>",
+	NL80211_CMD_GET_MPP, 0, CIB_NETDEV, handle_mpp_get,
+	"Get information on mesh proxy path to the given node.");
+
+static int handle_mpp_dump(struct nl80211_state *state,
+			     struct nl_cb *cb,
+			     struct nl_msg *msg,
+			     int argc, char **argv,
+			     enum id_input id)
+{
+	printf("DEST ADDR         PROXY NODE        IFACE\n");
+	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, print_mpp_handler, NULL);
+	return 0;
+}
+COMMAND(mpp, dump, NULL,
+	NL80211_CMD_GET_MPP, NLM_F_DUMP, CIB_NETDEV, handle_mpp_dump,
+	"List known mesh proxy paths.");
diff --git a/nl80211.h b/nl80211.h
index be9519b..80cff48 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -722,6 +722,10 @@
  *	QoS mapping is relevant for IP packets, it is only valid during an
  *	association. This is cleared on disassociation and AP restart.
  *
+ * @NL80211_CMD_GET_MPP: Get mesh path attributes for mesh proxy path to
+ *	destination %NL80211_ATTR_MAC on the interface identified by
+ *	%NL80211_ATTR_IFINDEX.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -893,6 +897,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_QOS_MAP,
 
+	NL80211_CMD_GET_MPP,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1591,6 +1597,9 @@ enum nl80211_commands {
  *	creation then the new interface will be owned by the netlink socket
  *	that created it and will be destroyed when the socket is closed
  *
+ * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
+ *	the TDLS link initiator.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1931,6 +1940,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_CSA_C_OFFSETS_TX,
 	NL80211_ATTR_MAX_CSA_COUNTERS,
 
+	NL80211_ATTR_TDLS_INITIATOR,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
-- 
1.9.1


