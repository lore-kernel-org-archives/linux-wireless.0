Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr60135.outbound.protection.outlook.com ([40.107.6.135]:10512
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728351AbeGVPmJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Jul 2018 11:42:09 -0400
From: Omer Dagan <omer.dagan@tandemg.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Omer Dagan <omer.dagan@tandemg.com>
Subject: [PATCH] iw: 'idby' might be used uninitialized in main function
Date: Sun, 22 Jul 2018 17:44:36 +0300
Message-Id: <20180722144436.10648-1-omer.dagan@tandemg.com> (sfid-20180722_164520_271895_9B3B68E2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During static-analysis of the code, a message appeared stating that
'idby' enum might be used un-initialized.
It described a case in which the 'goto detect' statment occurred and
that means that the enum initialiaztion will be skipped
The change puts the declaration of the 'idx' var and the enum at the
start of the main function and resets the enum value
at the original location in-order to maintain the current flow

Signed-off-by: Omer Dagan <omer.dagan@tandemg.com>
---
 iw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/iw.c b/iw.c
index daa2a77..558cc9c 100644
--- a/iw.c
+++ b/iw.c
@@ -547,6 +547,8 @@ int main(int argc, char **argv)
 	struct nl80211_state nlstate;
 	int err;
 	const struct cmd *cmd = NULL;
+	int idx;
+	enum id_input idby = II_NONE;
 
 	/* calculate command size including padding */
 	cmd_size = labs((long)&__section_set - (long)&__section_get);
@@ -593,8 +595,7 @@ int main(int argc, char **argv)
 		argv++;
 		err = __handle_cmd(&nlstate, II_WDEV, argc, argv, &cmd);
 	} else {
-		int idx;
-		enum id_input idby = II_NONE;
+		idby = II_NONE;
  detect:
 		if ((idx = if_nametoindex(argv[0])) != 0)
 			idby = II_NETDEV;
-- 
2.17.1
