Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33600 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbaIOKsa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 06:48:30 -0400
Received: by mail-wi0-f171.google.com with SMTP id bs8so3893673wib.16
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2014 03:48:25 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 2/2] iw: add vendor send command
Date: Mon, 15 Sep 2014 12:47:58 +0200
Message-Id: <1410778078-25244-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140915_124833_903884_15EC7721)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allow to send vendor data to the driver.
This command required OUI and SUBCMD parameters.

Also optional DATA parameter could be used:

cat data.bin | iw wlan0 send oui subcmd -
iw wlan0 send oui subcmd file.bin
iw wlan0 vendor send oui subcmd 0x00 0x00 0x00 0x1f
echo EOF | iw wlan0 vendor send oui subcmd -

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 Makefile |  2 +-
 vendor.c | 95 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+), 1 deletion(-)
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
index 0000000..f32c00b
--- /dev/null
+++ b/vendor.c
@@ -0,0 +1,95 @@
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
+static int read_file(FILE *file, char *buf, size_t size)
+{
+	int data, count = 0;
+
+	while ((data = fgetc(file)) != EOF) {
+		if (count >= size)
+			return -EINVAL;
+		buf[count] = data;
+		count++;
+	}
+
+	return count;
+}
+
+static int read_hex(int argc, char **argv, char *buf, size_t size)
+{
+	int i, res;
+	unsigned int data;
+
+	if (argc > size)
+		return -EINVAL;
+
+	for (i = 0; i < argc; i++) {
+		res = sscanf(argv[i], "0x%x", &data);
+		if (res != 1 || data > 0xff)
+			return -EINVAL;
+		buf[i] = data;
+	}
+
+	return argc;
+}
+
+static int handle_vendor(struct nl80211_state *state, struct nl_cb *cb,
+			 struct nl_msg *msg, int argc, char **argv,
+			 enum id_input id)
+{
+	unsigned int oui;
+	unsigned int subcmd;
+	char buf[2048] = {};
+	int res, count = 0;
+	FILE *file = NULL;
+
+	if (argc < 3)
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
+	if (!strcmp(argv[2], "-"))
+		file = stdin;
+	else
+		file = fopen(argv[2], "r");
+
+	NLA_PUT_U32(msg, NL80211_ATTR_VENDOR_ID, oui);
+	NLA_PUT_U32(msg, NL80211_ATTR_VENDOR_SUBCMD, subcmd);
+
+	if (file) {
+		count = read_file(file, buf, sizeof(buf));
+		fclose(file);
+	} else
+		count = read_hex(argc - 2, &argv[2], buf, sizeof(buf));
+
+	if (count < 0)
+		return -EINVAL;
+
+	if (count > 0)
+		NLA_PUT(msg, NL80211_ATTR_VENDOR_DATA, count, buf);
+
+	return 0;
+
+nla_put_failure:
+	return -ENOBUFS;
+}
+
+COMMAND(vendor, send, "<oui> <subcmd> <filename|-|hex data>", NL80211_CMD_VENDOR, 0, CIB_NETDEV, handle_vendor, "");
-- 
1.9.1

