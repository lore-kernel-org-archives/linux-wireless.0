Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:55737 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaLOQo1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 11:44:27 -0500
Received: by mail-wg0-f49.google.com with SMTP id n12so15012341wgh.8
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2014 08:44:25 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2] iw: support multiple regdom print
Date: Mon, 15 Dec 2014 18:44:23 +0200
Message-Id: <1418661863-2630-1-git-send-email-arik@wizery.com> (sfid-20141215_174430_870110_9A1200DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a phy is given, print only its regdomain. Otherwise, use the newly
implement dump functionality to print all regdomains in the system.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v2: fix reg get for older kernels

 reg.c | 40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/reg.c b/reg.c
index a02c982..0aef7ba 100644
--- a/reg.c
+++ b/reg.c
@@ -114,7 +114,6 @@ COMMAND(reg, set, "<ISO/IEC 3166-1 alpha2>",
 	"Notify the kernel about the current regulatory domain.");
 
 static int print_reg_handler(struct nl_msg *msg, void *arg)
-
 {
 #define PARSE_FLAG(nl_flag, string_value)  do { \
 		if ((flags & nl_flag)) { \
@@ -150,6 +149,13 @@ static int print_reg_handler(struct nl_msg *msg, void *arg)
 		return NL_SKIP;
 	}
 
+	if (tb_msg[NL80211_ATTR_WIPHY])
+		printf("phy#%d%s\n", nla_get_u32(tb_msg[NL80211_ATTR_WIPHY]),
+		       tb_msg[NL80211_ATTR_WIPHY_SELF_MANAGED_REG] ?
+		       " (self-managed)" : "");
+	else
+		printf("global\n");
+
 	if (tb_msg[NL80211_ATTR_DFS_REGION])
 		dfs_domain = nla_get_u8(tb_msg[NL80211_ATTR_DFS_REGION]);
 	else
@@ -216,18 +222,44 @@ static int print_reg_handler(struct nl_msg *msg, void *arg)
 
 		printf("\n");
 	}
-	return NL_OK;
+
+	printf("\n");
+	return NL_SKIP;
 #undef PARSE_FLAG
 }
 
+static int handle_reg_dump(struct nl80211_state *state,
+			   struct nl_cb *cb,
+			   struct nl_msg *msg,
+			   int argc, char **argv,
+			   enum id_input id)
+{
+	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, print_reg_handler, NULL);
+	return 0;
+}
+
 static int handle_reg_get(struct nl80211_state *state,
 			  struct nl_cb *cb,
 			  struct nl_msg *msg,
 			  int argc, char **argv,
 			  enum id_input id)
 {
-	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, print_reg_handler, NULL);
-	return 0;
+	char *dump_args[] = { "reg", "dump" };
+	int err;
+
+	err = handle_cmd(state, CIB_NONE, 2, dump_args);
+	/* dump might fail since it's not supported on older kernels */
+	if (err == -EOPNOTSUPP) {
+		nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, print_reg_handler,
+			  NULL);
+		return 0;
+	}
+
+	return err;
 }
 COMMAND(reg, get, NULL, NL80211_CMD_GET_REG, 0, CIB_NONE, handle_reg_get,
 	"Print out the kernel's current regulatory domain information.");
+COMMAND(reg, get, NULL, NL80211_CMD_GET_REG, 0, CIB_PHY, handle_reg_get,
+	"Print out the devices' current regulatory domain information.");
+HIDDEN(reg, dump, NULL, NL80211_CMD_GET_REG, NLM_F_DUMP, CIB_NONE,
+       handle_reg_dump);
-- 
1.9.1

