Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56317 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbaLAPvl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 10:51:41 -0500
Received: by mail-wi0-f175.google.com with SMTP id l15so25113944wiw.2
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2014 07:51:40 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 4/4] iw: support multiple regdom print
Date: Mon,  1 Dec 2014 17:51:33 +0200
Message-Id: <1417449093-9470-4-git-send-email-arik@wizery.com> (sfid-20141201_165144_541245_C07D00C1)
In-Reply-To: <1417449093-9470-1-git-send-email-arik@wizery.com>
References: <1417449093-9470-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a phy is given, print only its regdomain. Otherwise, use the newly
implement dump functionality to print all regdomains in the system.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 reg.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/reg.c b/reg.c
index a02c982..4e4c707 100644
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
@@ -216,7 +222,9 @@ static int print_reg_handler(struct nl_msg *msg, void *arg)
 
 		printf("\n");
 	}
-	return NL_OK;
+
+	printf("\n");
+	return NL_SKIP;
 #undef PARSE_FLAG
 }
 
@@ -229,5 +237,8 @@ static int handle_reg_get(struct nl80211_state *state,
 	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, print_reg_handler, NULL);
 	return 0;
 }
-COMMAND(reg, get, NULL, NL80211_CMD_GET_REG, 0, CIB_NONE, handle_reg_get,
+COMMAND(reg, get, NULL, NL80211_CMD_GET_REG, NLM_F_DUMP, CIB_NONE,
+	handle_reg_get,
 	"Print out the kernel's current regulatory domain information.");
+COMMAND(reg, get, NULL, NL80211_CMD_GET_REG, 0, CIB_PHY, handle_reg_get,
+	"Print out the devices' current regulatory domain information.");
-- 
1.9.1

