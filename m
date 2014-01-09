Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:64574 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaAINWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 08:22:38 -0500
Received: by mail-pa0-f49.google.com with SMTP id kx10so3300346pab.22
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jan 2014 05:22:35 -0800 (PST)
From: Ujjal Roy <royujjal@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: WiFi Mailing List <linux-wireless@vger.kernel.org>
Subject: [RFC] iw: add support for retry limit
Date: Thu,  9 Jan 2014 18:52:16 +0530
Message-Id: <1389273736-9486-1-git-send-email-royujjal@gmail.com> (sfid-20140109_142241_296492_C3FC42F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Show the retry limit in phy details and also configure the
retry limit.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
---
 info.c | 16 ++++++++++++++++
 phy.c  | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/info.c b/info.c
index a696503..08b3292 100644
--- a/info.c
+++ b/info.c
@@ -246,6 +246,22 @@ next:
 			printf("\tRTS threshold: %d\n", rts);
 	}
 
+	if (tb_msg[NL80211_ATTR_WIPHY_RETRY_SHORT] ||
+	    tb_msg[NL80211_ATTR_WIPHY_RETRY_LONG]) {
+		unsigned char retry_s = 0, retry_l = 0;
+
+		if (tb_msg[NL80211_ATTR_WIPHY_RETRY_SHORT])
+			retry_s = nla_get_u8(tb_msg[NL80211_ATTR_WIPHY_RETRY_SHORT]);
+		if (tb_msg[NL80211_ATTR_WIPHY_RETRY_LONG])
+			retry_l = nla_get_u8(tb_msg[NL80211_ATTR_WIPHY_RETRY_LONG]);
+		if (retry_s == retry_l) {
+			printf("\tRetry short long limit: %d\n", retry_s);
+		} else {
+			printf("\tRetry short limit: %d\n", retry_s);
+			printf("\tRetry long limit: %d\n", retry_l);
+		}
+	}
+
 	if (tb_msg[NL80211_ATTR_WIPHY_COVERAGE_CLASS]) {
 		unsigned char coverage;
 
diff --git a/phy.c b/phy.c
index 68f40f6..da05103 100644
--- a/phy.c
+++ b/phy.c
@@ -232,6 +232,45 @@ COMMAND(set, rts, "<rts threshold|off>",
 	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_rts,
 	"Set rts threshold.");
 
+static int handle_retry(struct nl80211_state *state,
+		      struct nl_cb *cb, struct nl_msg *msg,
+		      int argc, char **argv,
+		      enum id_input id)
+{
+	unsigned int retry_short = 0, retry_long = 0;
+	char *end;
+
+	if (!argc || argc > 2)
+		return 1;
+
+	if (!*argv[0])
+		return 1;
+	retry_short = strtoul(argv[0], &end, 10);
+	if (*end != '\0')
+		return 1;
+	if (!retry_short || retry_short > 255)
+		return -EINVAL;
+	NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_RETRY_SHORT, retry_short);
+
+	if (argc == 2) {
+		if (!*argv[1])
+			return 1;
+		retry_long = strtoul(argv[1], &end, 10);
+		if (*end != '\0')
+			return 1;
+		if (!retry_long || retry_long > 255)
+			return -EINVAL;
+		NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_RETRY_LONG, retry_long);
+	}
+
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(set, retry, "<short limit> [<long limit>]",
+	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_retry,
+	"Set retry limit.");
+
 static int handle_netns(struct nl80211_state *state,
 			struct nl_cb *cb,
 			struct nl_msg *msg,
-- 
1.8.1.4

