Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:37843 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaH0H6v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 03:58:51 -0400
Received: by mail-la0-f46.google.com with SMTP id b8so16275602lan.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Aug 2014 00:58:49 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 2/2] iw: add vendor send command
Date: Wed, 27 Aug 2014 09:58:29 +0200
Message-Id: <1409126309-4052-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140827_095911_961431_459CE407)
In-Reply-To: <1409126309-4052-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1409126309-4052-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allow to send vendor data to the driver.
This command required OUI and SUBCMD parameters.

Also optional DATA parameter could be used:

cat data.bin | iw wlan0 send oui subcmd

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 Makefile |    2 +-
 vendor.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 1 deletion(-)
 create mode 100644 vendor.c

diff --git a/Makefile b/Makefile
index f042e30..802f87a 100644
--- a/Makefile
+++ b/Makefile
@@ -16,7 +16,7 @@ OBJS = iw.o genl.o event.o info.o phy.o \
 	interface.o ibss.o station.o survey.o util.o \
 	mesh.o mpath.o scan.o reg.o version.o \
 	reason.o status.o connect.o link.o offch.o ps.o cqm.o \
-	bitrate.o wowlan.o coalesce.o roc.o p2p.o
+	bitrate.o wowlan.o coalesce.o roc.o p2p.o vendor.o
 OBJS += sections.o
 
 OBJS-$(HWSIM) += hwsim.o
diff --git a/vendor.c b/vendor.c
new file mode 100644
index 0000000..9c51cb9
--- /dev/null
+++ b/vendor.c
@@ -0,0 +1,56 @@
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
+SECTION(vendor);
+
+static int handle_vendor(struct nl80211_state *state, struct nl_cb *cb,
+			 struct nl_msg *msg, int argc, char **argv,
+			 enum id_input id)
+{
+	unsigned int oui;
+	unsigned int subcmd;
+	char buf[2048] = {};
+	int res, count = 0;
+
+	if (argc < 2)
+		return -EINVAL;
+
+	res = sscanf(argv[0], "0x%x", &oui);
+	if (res != 1)
+		return -EINVAL;
+
+	res = sscanf(argv[1], "0x%x", &subcmd);
+	if (res != 1)
+		return -EINVAL;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_VENDOR_ID, oui);
+	NLA_PUT_U32(msg, NL80211_ATTR_VENDOR_SUBCMD, subcmd);
+
+	while ((res = fgetc(stdin)) != EOF) {
+		if (count >= sizeof(buf))
+			return -EINVAL;
+
+		buf[count] = res;
+		count++;
+	}
+
+	if (count > 0)
+		NLA_PUT(msg, NL80211_ATTR_VENDOR_DATA, count, buf);
+
+	return 0;
+
+ nla_put_failure:
+	return -ENOBUFS;
+}
+
+COMMAND(vendor, send, "<oui> <subcmd> [stdin data]", NL80211_CMD_VENDOR, 0, CIB_NETDEV, handle_vendor, "");
-- 
1.7.9.5

