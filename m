Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:36786 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755255Ab3HEWHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 18:07:52 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Bing Zhao <bzhao@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] iw: correction in coalesce condition display message
Date: Mon, 5 Aug 2013 15:06:06 -0700
Message-ID: <1375740366-8986-1-git-send-email-bzhao@marvell.com> (sfid-20130806_000802_517293_A02C58FB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

NL80211_COALESCE_CONDITION_MATCH is 0 and
NL80211_COALESCE_CONDITION_NO_MATCH is 1.
Hence this change is required

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 coalesce.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/coalesce.c b/coalesce.c
index 22d1534..0239915 100644
--- a/coalesce.c
+++ b/coalesce.c
@@ -175,7 +175,7 @@ COMMAND(coalesce, enable, "<config-file>",
 	"  patterns=<[offset1+]<pattern1>,<[offset2+]<pattern2>,...>\n"
 	"  ...\n"
 	"delay: maximum coalescing delay in msec.\n"
-	"condition: 0/1 i.e. 'not match'/'match' the patterns\n"
+	"condition: 1/0 i.e. 'not match'/'match' the patterns\n"
 	"patterns: each pattern is given as a bytestring with '-' in\n"
 	"places where any byte may be present, e.g. 00:11:22:-:44 will\n"
 	"match 00:11:22:33:44 and 00:11:22:33:ff:44 etc. Offset and\n"
@@ -224,9 +224,9 @@ static int print_coalesce_handler(struct nl_msg *msg, void *arg)
 
 		printf("Rule - max coalescing delay: %dmsec condition:", delay);
 		if (condition)
-			printf("match\n");
-		else
 			printf("not match\n");
+		else
+			printf("match\n");
 
 		if (ruleattr[NL80211_ATTR_COALESCE_RULE_PKT_PATTERN]) {
 			nla_for_each_nested(pattern,
-- 
1.8.0

