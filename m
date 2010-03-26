Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:51549 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab0CZFtq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 01:49:46 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] iw: Add support for connection quality monitor configuation
Date: Fri, 26 Mar 2010 07:46:19 +0200
Message-Id: <1269582379-10253-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the cqm option to iw allowing enabling/disabling the
rssi connection quality monitoring mode, and configuring rssi threshold and
hysteresis.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 Makefile  |    2 +-
 cqm.c     |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 event.c   |   33 +++++++++++++++++++++++++++++++++
 nl80211.h |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 138 insertions(+), 1 deletions(-)
 create mode 100644 cqm.c

diff --git a/Makefile b/Makefile
index c51706b..e21900a 100644
--- a/Makefile
+++ b/Makefile
@@ -17,7 +17,7 @@ CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing
 OBJS = iw.o genl.o event.o info.o phy.o \
 	interface.o ibss.o station.o survey.o util.o \
 	mesh.o mpath.o scan.o reg.o version.o \
-	reason.o status.o connect.o link.o offch.o ps.o
+	reason.o status.o connect.o link.o offch.o ps.o cqm.c
 OBJS += sections.o
 ALL = iw
 
diff --git a/cqm.c b/cqm.c
new file mode 100644
index 0000000..3da2b54
--- /dev/null
+++ b/cqm.c
@@ -0,0 +1,54 @@
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
+static int iw_cqm_rssi(struct nl80211_state *state, struct nl_cb *cb,
+		       struct nl_msg *msg, int argc, char **argv)
+{
+	struct nl_msg *cqm = NULL;
+	int thold = 0;
+	int hyst = 0;
+	int ret = -ENOSPC;
+
+	/* get the required args */
+	if (argc < 1 || argc > 2)
+		return 1;
+
+	if (strcmp(argv[0], "off")) {
+		thold = atoi(argv[0]);
+
+		if (thold == 0)
+			return -EINVAL;
+
+		if (argc == 2)
+			hyst = atoi(argv[1]);
+	}
+
+	/* connection quality monitor attributes */
+	cqm = nlmsg_alloc();
+
+	NLA_PUT_U32(cqm, NL80211_ATTR_CQM_RSSI_THOLD, thold);
+	NLA_PUT_U32(cqm, NL80211_ATTR_CQM_RSSI_HYST, hyst);
+
+	nla_put_nested(msg, NL80211_ATTR_CQM, cqm);
+	ret = 0;
+
+ nla_put_failure:
+	nlmsg_free(cqm);
+	return ret;
+}
+
+TOPLEVEL(cqm, "",
+	 0, 0, CIB_NETDEV, NULL,
+	 "Configure the WLAN connection quality monitor.\n");
+
+COMMAND(cqm, rssi, "<threshold|off> [<hysteresis>]",
+	NL80211_CMD_SET_CQM, 0, CIB_NETDEV, iw_cqm_rssi,
+	"Set connection quality monitor RSSI threshold.\n");
diff --git a/event.c b/event.c
index 01a325c..0fae9a3 100644
--- a/event.c
+++ b/event.c
@@ -100,6 +100,36 @@ static void print_frame(struct print_event_args *args, struct nlattr *attr)
 	printf("]");
 }
 
+static void parse_cqm(struct nlattr *tb) {
+	static struct nla_policy cqm_policy[NL80211_ATTR_CQM_MAX + 1] = {
+		[NL80211_ATTR_CQM_RSSI_THOLD] = { .type = NLA_U32 },
+		[NL80211_ATTR_CQM_RSSI_HYST] = { .type = NLA_U8 },
+		[NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT] = { .type = NLA_U32 },
+	};
+	struct nlattr *cqm[NL80211_FREQUENCY_ATTR_MAX + 1];
+
+	printf("connection quality monitor event: ");
+
+	if (nla_parse_nested(cqm,
+			     NL80211_FREQUENCY_ATTR_MAX,
+			     tb,
+			     cqm_policy)) {
+		printf("none!\n");
+		return;
+	}
+
+	if (cqm[NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT]) {
+		enum nl80211_cqm_rssi_threshold_event rssi_event;
+		rssi_event = nla_get_u32(cqm[NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT]);
+		if (rssi_event == NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH)
+			printf("RSSI high: ");
+		else
+			printf("RSSI low: ");
+	}
+	printf("\n");
+}
+
+
 static int print_event(struct nl_msg *msg, void *arg)
 {
 #define PARSE_BEACON_CHAN(_attr, _chan) do { \
@@ -313,6 +343,9 @@ static int print_event(struct nl_msg *msg, void *arg)
 			nla_get_u32(tb[NL80211_ATTR_WIPHY_FREQ]),
 			(unsigned long long)nla_get_u64(tb[NL80211_ATTR_COOKIE]));
 		break;
+	case NL80211_CMD_NOTIFY_CQM:
+		parse_cqm(tb[NL80211_ATTR_CQM]);
+		break;
 	default:
 		printf("unknown event %d\n", gnlh->cmd);
 		break;
diff --git a/nl80211.h b/nl80211.h
index 28ba20f..daf6a34 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -323,6 +323,12 @@
  *	the TX command and %NL80211_ATTR_FRAME includes the contents of the
  *	frame. %NL80211_ATTR_ACK flag is included if the recipient acknowledged
  *	the frame.
+ * @NL80211_CMD_SET_CQM: Connection quality monitor configuration. This command
+ *	is used to configure connection quality monitoring notification trigger
+ *	levels.
+ * @NL80211_CMD_NOTIFY_CQM: Connection quality monitor notification. This
+ *	command is used as an event to indicate the that a trigger level was
+ *	reached.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -419,6 +425,9 @@ enum nl80211_commands {
 	NL80211_CMD_SET_POWER_SAVE,
 	NL80211_CMD_GET_POWER_SAVE,
 
+	NL80211_CMD_SET_CQM,
+	NL80211_CMD_NOTIFY_CQM,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -691,6 +700,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_ACK: Flag attribute indicating that the frame was
  *	acknowledged by the recipient.
  *
+ * @NL80211_ATTR_CQM: connection quality monitor configuration in a
+ *	nested attribute with %NL80211_ATTR_CQM_* sub-attributes.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -842,6 +854,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PS_STATE,
 
+	NL80211_ATTR_CQM,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1583,4 +1597,40 @@ enum nl80211_ps_state {
 	NL80211_PS_ENABLED,
 };
 
+/**
+ * enum nl80211_attr_cqm - connection quality monitor attributes
+ * @__NL80211_ATTR_CQM_INVALID: invalid
+ * @NL80211_ATTR_CQM_RSSI_THOLD: RSSI threshold in dBm. This value specifies
+ *	the threshold for the RSSI level at which an event will be sent. Zero
+ *	to disable.
+ * @NL80211_ATTR_CQM_RSSI_HYST: RSSI hysteresis in dBm. This value specifies
+ *	the minimum amount the RSSI level must change after an event before a
+ *	new event may be issued (to reduce effects of RSSI oscillation).
+ * @NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT: RSSI threshold event
+ * @__NL80211_ATTR_CQM_AFTER_LAST: internal
+ * @NL80211_ATTR_CQM_MAX: highest key attribute
+ */
+enum nl80211_attr_cqm {
+	__NL80211_ATTR_CQM_INVALID,
+	NL80211_ATTR_CQM_RSSI_THOLD,
+	NL80211_ATTR_CQM_RSSI_HYST,
+	NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT,
+
+	/* keep last */
+	__NL80211_ATTR_CQM_AFTER_LAST,
+	NL80211_ATTR_CQM_MAX = __NL80211_ATTR_CQM_AFTER_LAST - 1
+};
+
+/**
+ * enum nl80211_cqm_rssi_threshold_event - RSSI threshold event
+ * @NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW - The RSSI level is lower than the
+ *      configured threshold
+ * @NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH - The RSSI is higher than the
+ *      configured threshold
+ */
+enum nl80211_cqm_rssi_threshold_event {
+	NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
+	NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
+};
+
 #endif /* __LINUX_NL80211_H */
-- 
1.6.3.3

