Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:61746 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaCGGxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 01:53:45 -0500
Received: by mail-pa0-f48.google.com with SMTP id hz1so3767236pad.7
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2014 22:53:44 -0800 (PST)
From: Ujjal Roy <royujjal@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	WiFi Mailing List <linux-wireless@vger.kernel.org>
Subject: [PATCH] iw: add support to set/get retry limit
Date: Fri,  7 Mar 2014 12:23:38 +0530
Message-Id: <1394175218-24869-1-git-send-email-royujjal@gmail.com> (sfid-20140307_075348_825819_A6F42EB7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for late response. Original patch is started below.
...

Show the retry limit in phy details and also configure the
retry limit.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
---
 info.c | 16 ++++++++++++++++
 phy.c  | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/info.c b/info.c
index a696503..001b317 100644
--- a/info.c
+++ b/info.c
@@ -246,6 +246,22 @@ next:
 			printf("\tRTS threshold: %d\n", rts);
 	}
 
+	if (tb_msg[NL80211_ATTR_WIPHY_RETRY_SHORT] ||
+	    tb_msg[NL80211_ATTR_WIPHY_RETRY_LONG]) {
+		unsigned char retry_short = 0, retry_long = 0;
+
+		if (tb_msg[NL80211_ATTR_WIPHY_RETRY_SHORT])
+			retry_short = nla_get_u8(tb_msg[NL80211_ATTR_WIPHY_RETRY_SHORT]);
+		if (tb_msg[NL80211_ATTR_WIPHY_RETRY_LONG])
+			retry_long = nla_get_u8(tb_msg[NL80211_ATTR_WIPHY_RETRY_LONG]);
+		if (retry_short == retry_long) {
+			printf("\tRetry short long limit: %d\n", retry_short);
+		} else {
+			printf("\tRetry short limit: %d\n", retry_short);
+			printf("\tRetry long limit: %d\n", retry_long);
+		}
+	}
+
 	if (tb_msg[NL80211_ATTR_WIPHY_COVERAGE_CLASS]) {
 		unsigned char coverage;
 
diff --git a/phy.c b/phy.c
index 68f40f6..517d203 100644
--- a/phy.c
+++ b/phy.c
@@ -232,6 +232,70 @@ COMMAND(set, rts, "<rts threshold|off>",
 	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_rts,
 	"Set rts threshold.");
 
+static int handle_retry(struct nl80211_state *state,
+			struct nl_cb *cb, struct nl_msg *msg,
+			int argc, char **argv, enum id_input id)
+{
+	unsigned int retry_short = 0, retry_long = 0;
+	bool have_retry_s = false, have_retry_l = false;
+	int i;
+	enum {
+		S_NONE,
+		S_SHORT,
+		S_LONG,
+	} parser_state = S_NONE;
+
+	if (!argc || (argc != 2 && argc != 4))
+		return 1;
+
+	for (i = 0; i < argc; i++) {
+		char *end;
+		unsigned int tmpul;
+
+		if (strcmp(argv[i], "short") == 0) {
+			if (have_retry_s)
+				return 1;
+			parser_state = S_SHORT;
+			have_retry_s = true;
+		} else if (strcmp(argv[i], "long") == 0) {
+			if (have_retry_l)
+				return 1;
+			parser_state = S_LONG;
+			have_retry_l = true;
+		} else {
+			tmpul = strtoul(argv[i], &end, 10);
+			if (*end != '\0')
+				return 1;
+			if (!tmpul || tmpul > 255)
+				return -EINVAL;
+			switch (parser_state) {
+			case S_SHORT:
+				retry_short = tmpul;
+				break;
+			case S_LONG:
+				retry_long = tmpul;
+				break;
+			default:
+				return 1;
+			}
+		}
+	}
+
+	if (!have_retry_s && !have_retry_l)
+		return 1;
+	if (have_retry_s)
+		NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_RETRY_SHORT, retry_short);
+	if (have_retry_l)
+		NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_RETRY_LONG, retry_long);
+
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(set, retry, "[short <limit>] [long <limit>]",
+	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_retry,
+	"Set retry limit.");
+
 static int handle_netns(struct nl80211_state *state,
 			struct nl_cb *cb,
 			struct nl_msg *msg,
-- 
1.8.1.4

