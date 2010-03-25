Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f221.google.com ([209.85.219.221]:34048 "EHLO
	mail-ew0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab0CYV7P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 17:59:15 -0400
Received: by ewy21 with SMTP id 21so1932701ewy.25
        for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 14:59:14 -0700 (PDT)
From: Rakesh <gopchandani@gmail.com>
To: johannes@sipsolutions.net
Cc: rakesh.illini@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH] Changes for implementing NL80211_CMD_SET_TX_BITRATE_MASK for legacy rates for now.
Date: Thu, 25 Mar 2010 16:52:35 -0500
Message-Id: <1269553955-5858-1-git-send-email-gopchandani@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rakesh <rakesh@pineapple.(none)>

---
 mask.c |   82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 82 insertions(+), 0 deletions(-)
 create mode 100755 mask.c

diff --git a/mask.c b/mask.c
new file mode 100755
index 0000000..a184b67
--- /dev/null
+++ b/mask.c
@@ -0,0 +1,82 @@
+#include <net/if.h>
+#include <errno.h>
+#include <string.h>
+#include <ctype.h>
+#include <stdbool.h>
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
+
+static int handle_mask(struct nl80211_state *state,
+		       struct nl_cb *cb,
+		       struct nl_msg *msg,
+		       int argc, char **argv)
+{
+	__u8 input_legacy_rates[32];
+	struct nlattr *nl_rates, *nl_rate;
+	
+	char *eptr;
+	int err = -ENOBUFS;
+	int i,legacy_rate_counter=0;
+	
+	enum {
+		NONE,
+		LEGACY,
+		MCS,
+	} parse = NONE;
+	bool have_legacy,have_mcs;
+	for (i = 0; i < argc; i++) {
+		if (strcmp(argv[i], "legacy") == 0) {
+			parse = LEGACY;
+			have_legacy = true;	
+			continue;
+		}
+
+                if (strcmp(argv[i], "mcs") == 0) {
+                        parse = MCS;
+                        have_mcs = true;
+                        continue;
+                }
+
+		switch (parse) {
+		case NONE:
+		case LEGACY:
+			input_legacy_rates[legacy_rate_counter] = strtoul(argv[i], &eptr, 10);
+			legacy_rate_counter++;	
+			break;
+		case MCS:
+			//NLA_PUT(ssids, i, strlen(argv[i]), argv[i]);
+			break;
+		}
+	}
+	err = 0;
+
+// Nesting of attribute begins
+
+	nl_rates = nla_nest_start(msg, NL80211_ATTR_TX_RATES);
+	if (!nl_rates)
+		goto nla_put_failure;
+	int band = 0;
+	nl_rate = nla_nest_start(msg,band);
+	if (!nl_rate)
+		goto nla_put_failure;
+
+	nla_put(msg, NL80211_TXRATE_LEGACY, legacy_rate_counter, input_legacy_rates);
+	
+	nla_nest_end(msg,nl_rate);
+	nla_nest_end(msg,nl_rates);
+
+//Nesting of attribute ends.
+ nla_put_failure:
+	return err;
+}
+COMMAND(set, mask, "[legacy <legacy rate in Mbps multiplied by 2, e.g. 11 for 5.5 Mbps>*]",
+	NL80211_CMD_SET_TX_BITRATE_MASK, 0, CIB_NETDEV, handle_mask,
+	 "Sets up the specified rate masks for different bands.");
-- 
1.6.3.3

