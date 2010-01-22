Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:53918 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754621Ab0AVXfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 18:35:36 -0500
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/6] Constification.
Date: Fri, 22 Jan 2010 23:35:27 +0000
Message-Id: <1264203330-20785-3-git-send-email-linux@youmustbejoking.demon.co.uk>
In-Reply-To: <1264203330-20785-2-git-send-email-linux@youmustbejoking.demon.co.uk>
References: <1264203330-20785-1-git-send-email-linux@youmustbejoking.demon.co.uk>
 <1264203330-20785-2-git-send-email-linux@youmustbejoking.demon.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 rfkill.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/rfkill.c b/rfkill.c
index 3cb2605..8c0aea6 100644
--- a/rfkill.c
+++ b/rfkill.c
@@ -195,9 +195,9 @@ static void rfkill_block(bool all, __u32 idx, __u8 block, __u8 type)
 
 struct rfkill_type_str {
 	enum rfkill_type type;
-	char *name;
+	const char *name;
 };
-static struct rfkill_type_str rfkill_type_strings[] = {
+static const struct rfkill_type_str rfkill_type_strings[] = {
 	{	.type = RFKILL_TYPE_ALL,		.name = "all"	},
 	{	.type = RFKILL_TYPE_WLAN,		.name = "wifi"	},
 	{	.type = RFKILL_TYPE_WLAN,		.name = "wlan"	}, /* alias */
@@ -211,9 +211,9 @@ static struct rfkill_type_str rfkill_type_strings[] = {
 	{	.name = NULL }
 };
 
-static enum rfkill_type rfkill_str_to_type(char *s)
+static enum rfkill_type rfkill_str_to_type(const char *s)
 {
-	struct rfkill_type_str *p;
+	const struct rfkill_type_str *p;
 
 	for (p = rfkill_type_strings; p->name != NULL; p++) {
 		if ((strlen(s) == strlen(p->name)) && (!strcmp(s,p->name)))
@@ -244,7 +244,7 @@ static void version(void)
 	printf("rfkill %s\n", rfkill_version);
 }
 
-static void do_block_unblock(__u8 block, char *param)
+static void do_block_unblock(__u8 block, const char *param)
 {
 	enum rfkill_type t;
 	__u32 idx;
-- 
1.6.5

