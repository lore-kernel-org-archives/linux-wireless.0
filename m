Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34111 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbcEBTzi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2016 15:55:38 -0400
Received: by mail-wm0-f67.google.com with SMTP id n129so316593wmn.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 May 2016 12:55:37 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: johannes@sipsolutions.net, johannes.berg@intel.com,
	linux-wireless@vger.kernel.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH] iw: add vendor command response support
Date: Mon,  2 May 2016 21:55:30 +0200
Message-Id: <1462218930-6300-1-git-send-email-erik.stromdahl@gmail.com> (sfid-20160502_215542_036915_C91C9BAB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduced two new commands for reading vendor command responses:
recv and recvbin
Both will send a vendor command (typically some kind of GET request)
in the same way as the current send command and print the received
response in ASCII or binary.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 vendor.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/vendor.c b/vendor.c
index 279aac5..860cd48 100644
--- a/vendor.c
+++ b/vendor.c
@@ -12,6 +12,33 @@
 
 SECTION(vendor);
 
+static int print_vendor_response(struct nl_msg *msg, void *arg)
+{
+	struct nlattr *attr;
+	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
+	bool print_ascii = (bool) arg;
+	uint8_t *data;
+	int len;
+
+	attr = nla_find(genlmsg_attrdata(gnlh, 0),
+			genlmsg_attrlen(gnlh, 0),
+			NL80211_ATTR_VENDOR_DATA);
+	if (!attr) {
+		fprintf(stderr, "vendor data attribute missing!\n");
+		return NL_SKIP;
+	}
+
+	data = (uint8_t *) nla_data(attr);
+	len = nla_len(attr);
+
+	if (print_ascii)
+		iw_hexdump("vendor response", data, len);
+	else
+		fwrite(data, 1, len, stdout);
+
+	return NL_OK;
+}
+
 static int read_file(FILE *file, char *buf, size_t size)
 {
 	size_t count = 0;
@@ -96,4 +123,22 @@ nla_put_failure:
 	return -ENOBUFS;
 }
 
+static int handle_vendor_recv(struct nl80211_state *state,
+			      struct nl_msg *msg, int argc,
+			      char **argv, enum id_input id)
+{
+	register_handler(print_vendor_response, (void *) true);
+	return handle_vendor(state, msg, argc, argv, id);
+}
+
+static int handle_vendor_recv_bin(struct nl80211_state *state,
+				  struct nl_msg *msg, int argc,
+				  char **argv, enum id_input id)
+{
+	register_handler(print_vendor_response, (void *) false);
+	return handle_vendor(state, msg, argc, argv, id);
+}
+
 COMMAND(vendor, send, "<oui> <subcmd> <filename|-|hex data>", NL80211_CMD_VENDOR, 0, CIB_NETDEV, handle_vendor, "");
+COMMAND(vendor, recv, "<oui> <subcmd> <filename|-|hex data>", NL80211_CMD_VENDOR, 0, CIB_NETDEV, handle_vendor_recv, "");
+COMMAND(vendor, recvbin, "<oui> <subcmd> <filename|-|hex data>", NL80211_CMD_VENDOR, 0, CIB_NETDEV, handle_vendor_recv_bin, "");
-- 
1.7.9.5

