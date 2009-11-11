Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:44972 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbZKKKhS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 05:37:18 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] iw: display noise level from survey data
Date: Wed, 11 Nov 2009 11:36:34 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911111136.34949.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sample output:

# iw dev wlan0 survey dump
Survey data from wlan0
        frequency:      2412 MHz
        noise:          -92 dBm

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>

--- iw.orig/Makefile
+++ iw/Makefile
@@ -15,7 +15,7 @@
 CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration
 
 OBJS = iw.o genl.o event.o info.o phy.o \
-	interface.o ibss.o station.o util.o \
+	interface.o ibss.o station.o survey.o util.o \
 	mesh.o mpath.o scan.o reg.o version.o \
 	reason.o status.o connect.o link.o
 OBJS += sections.o
--- /dev/null
+++ iw/survey.c
@@ -0,0 +1,66 @@
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
+SECTION(survey);
+
+static int print_survey_handler(struct nl_msg *msg, void *arg)
+{
+	struct nlattr *tb[NL80211_ATTR_MAX + 1];
+	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
+	struct nlattr *sinfo[NL80211_SURVEY_INFO_MAX + 1];
+	char dev[20];
+
+	static struct nla_policy survey_policy[NL80211_SURVEY_INFO_MAX + 1] = {
+		[NL80211_SURVEY_INFO_FREQUENCY] = { .type = NLA_U32 },
+		[NL80211_SURVEY_INFO_NOISE] = { .type = NLA_U8 },
+	};
+
+	nla_parse(tb, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
+		  genlmsg_attrlen(gnlh, 0), NULL);
+
+	if_indextoname(nla_get_u32(tb[NL80211_ATTR_IFINDEX]), dev);
+	printf("Survey data from %s\n", dev);
+
+	if (!tb[NL80211_ATTR_SURVEY_INFO]) {
+		fprintf(stderr, "survey data missing!");
+		return NL_SKIP;
+	}
+
+	if (nla_parse_nested(sinfo, NL80211_SURVEY_INFO_MAX,
+			     tb[NL80211_ATTR_SURVEY_INFO],
+			     survey_policy)) {
+		fprintf(stderr, "failed to parse nested attributes!\n");
+		return NL_SKIP;
+	}
+
+	if (sinfo[NL80211_SURVEY_INFO_FREQUENCY])
+		printf("\tfrequency:\t%u MHz\n",
+			nla_get_u32(sinfo[NL80211_SURVEY_INFO_FREQUENCY]));
+	if (sinfo[NL80211_SURVEY_INFO_NOISE])
+		printf("\tnoise:\t\t%d dBm\n",
+			(int8_t)nla_get_u8(sinfo[NL80211_SURVEY_INFO_NOISE]));
+	return NL_SKIP;
+}
+
+static int handle_survey_dump(struct nl80211_state *state,
+			       struct nl_cb *cb,
+			       struct nl_msg *msg,
+			       int argc, char **argv)
+{
+	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, print_survey_handler, NULL);
+	return 0;
+}
+COMMAND(survey, dump, NULL,
+	NL80211_CMD_GET_SURVEY, NLM_F_DUMP, CIB_NETDEV, handle_survey_dump,
+	"List all gathered channel survey data");
+
--- iw.orig/nl80211.h
+++ iw/nl80211.h
@@ -160,6 +160,11 @@
  * @NL80211_CMD_SCAN_ABORTED: scan was aborted, for unspecified reasons,
  *	partial scan results may be available
  *
+ * @NL80211_CMD_GET_SURVEY: get survey resuls, e.g. channel occupation
+ *      or noise level
+ * @NL80211_CMD_NEW_SURVEY_RESULTS: survey data notification (as a reply to
+ *	NL80211_CMD_GET_SURVEY and on the "scan" multicast group)
+ *
  * @NL80211_CMD_REG_CHANGE: indicates to userspace the regulatory domain
  * 	has been changed and provides details of the request information
  * 	that caused the change such as who initiated the regulatory request
@@ -341,6 +346,9 @@
 
 	NL80211_CMD_SET_WIPHY_NETNS,
 
+	NL80211_CMD_GET_SURVEY,
+	NL80211_CMD_NEW_SURVEY_RESULTS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -584,6 +592,10 @@
  *	changed then the list changed and the dump should be repeated
  *	completely from scratch.
  *
+ * @NL80211_ATTR_SURVEY_INFO: survey information about a channel, part of
+ *      the survey response for %NL80211_CMD_GET_SURVEY, nested attribute
+ *      containing info as possible, see &enum survey_info.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -714,6 +726,8 @@
 
 	NL80211_ATTR_PID,
 
+	NL80211_ATTR_SURVEY_INFO,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1117,6 +1131,26 @@
 };
 
 /**
+ * enum nl80211_survey_info - survey information
+ *
+ * These attribute types are used with %NL80211_ATTR_SURVEY_INFO
+ * when getting information about a survey.
+ *
+ * @__NL80211_SURVEY_INFO_INVALID: attribute number 0 is reserved
+ * @NL80211_SURVEY_INFO_FREQUENCY: center frequency of channel
+ * @NL80211_SURVEY_INFO_NOISE: noise level of channel (u8, dBm)
+ */
+enum nl80211_survey_info {
+	__NL80211_SURVEY_INFO_INVALID,
+	NL80211_SURVEY_INFO_FREQUENCY,
+	NL80211_SURVEY_INFO_NOISE,
+
+	/* keep last */
+	__NL80211_SURVEY_INFO_AFTER_LAST,
+	NL80211_SURVEY_INFO_MAX = __NL80211_SURVEY_INFO_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_mntr_flags - monitor configuration flags
  *
  * Monitor configuration flags.

-- 
http://www.holgerschurig.de
