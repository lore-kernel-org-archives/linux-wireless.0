Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:38599 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753953Ab0AVXfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 18:35:36 -0500
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/6] Refactor rfkill index/type lookup: move it below rfkill_block.
Date: Fri, 22 Jan 2010 23:35:29 +0000
Message-Id: <1264203330-20785-5-git-send-email-linux@youmustbejoking.demon.co.uk>
In-Reply-To: <1264203330-20785-4-git-send-email-linux@youmustbejoking.demon.co.uk>
References: <1264203330-20785-1-git-send-email-linux@youmustbejoking.demon.co.uk>
 <1264203330-20785-2-git-send-email-linux@youmustbejoking.demon.co.uk>
 <1264203330-20785-3-git-send-email-linux@youmustbejoking.demon.co.uk>
 <1264203330-20785-4-git-send-email-linux@youmustbejoking.demon.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 rfkill.c |  130 +++++++++++++++++++++++++++++++++++---------------------------
 1 files changed, 73 insertions(+), 57 deletions(-)

diff --git a/rfkill.c b/rfkill.c
index 4cf507a..998728e 100644
--- a/rfkill.c
+++ b/rfkill.c
@@ -118,6 +118,60 @@ static const char *type2string(enum rfkill_type type)
 	return NULL;
 }
 
+struct rfkill_type_str {
+	enum rfkill_type type;
+	const char *name;
+};
+static const struct rfkill_type_str rfkill_type_strings[] = {
+	{	.type = RFKILL_TYPE_ALL,		.name = "all"	},
+	{	.type = RFKILL_TYPE_WLAN,		.name = "wifi"	},
+	{	.type = RFKILL_TYPE_WLAN,		.name = "wlan"	}, /* alias */
+	{	.type = RFKILL_TYPE_BLUETOOTH,	.name = "bluetooth"	},
+	{	.type = RFKILL_TYPE_UWB,		.name = "uwb"	},
+	{	.type = RFKILL_TYPE_UWB,		.name = "ultrawideband"	}, /* alias */
+	{	.type = RFKILL_TYPE_WIMAX,		.name = "wimax"	},
+	{	.type = RFKILL_TYPE_WWAN,		.name = "wwan"	},
+	{	.type = RFKILL_TYPE_GPS,		.name = "gps"	},
+	{	.type = RFKILL_TYPE_FM,			.name = "fm"	},
+	{	.name = NULL }
+};
+
+struct rfkill_id {
+	union {
+		enum rfkill_type type;
+		__u32 index;
+	};
+	enum {
+		RFKILL_IS_INVALID,
+		RFKILL_IS_TYPE,
+		RFKILL_IS_INDEX,
+	} result;
+};
+
+static struct rfkill_id rfkill_id_to_type(const char *s)
+{
+	const struct rfkill_type_str *p;
+	struct rfkill_id ret;
+
+	if (islower(*s)) {
+		for (p = rfkill_type_strings; p->name != NULL; p++) {
+			if ((strlen(s) == strlen(p->name)) && (!strcmp(s,p->name))) {
+				ret.type = p->type;
+				ret.result = RFKILL_IS_TYPE;
+				return ret;
+			}
+		}
+	} else if (isdigit(*s)) {
+		/* assume a numeric character implies an index. */
+		ret.index = atoi(s);
+		ret.result = RFKILL_IS_INDEX;
+		return ret;
+	}
+
+	ret.result = RFKILL_IS_INVALID;
+	return ret;
+}
+
 static int rfkill_list(void)
 {
 	struct rfkill_event event;
@@ -166,12 +220,19 @@ static int rfkill_list(void)
 	return 0;
 }
 
-static int rfkill_block(bool all, __u32 idx, __u8 block, __u8 type)
+static int rfkill_block(__u8 block, const char *param)
 {
+	struct rfkill_id id;
 	struct rfkill_event event;
 	ssize_t len;
 	int fd;
 
+	id = rfkill_id_to_type(param);
+	if (id.result == RFKILL_IS_INVALID) {
+		fprintf(stderr, "Bogus %s argument '%s'.\n", block ? "block" : "unblock", param);
+		return 2;
+	}
+
 	fd = open("/dev/rfkill", O_RDWR);
 	if (fd < 0) {
 		perror("Can't open RFKILL control device");
@@ -179,12 +240,16 @@ static int rfkill_block(bool all, __u32 idx, __u8 block, __u8 type)
 	}
 
 	memset(&event, 0, sizeof(event));
-	if (!all) {
-		event.idx = idx;
-		event.op = RFKILL_OP_CHANGE;
-	} else {
+	switch (id.result) {
+	case RFKILL_IS_TYPE:
 		event.op = RFKILL_OP_CHANGE_ALL;
-		event.type = type;
+		event.type = id.type;
+		break;
+	case RFKILL_IS_INDEX:
+		event.op = RFKILL_OP_CHANGE;
+		event.idx = id.index;
+		break;
+	case RFKILL_IS_INVALID:; /* must be last */
 	}
 	event.soft = block;
 
@@ -196,35 +261,6 @@ static int rfkill_block(bool all, __u32 idx, __u8 block, __u8 type)
 	return 0;
 }
 
-struct rfkill_type_str {
-	enum rfkill_type type;
-	const char *name;
-};
-static const struct rfkill_type_str rfkill_type_strings[] = {
-	{	.type = RFKILL_TYPE_ALL,		.name = "all"	},
-	{	.type = RFKILL_TYPE_WLAN,		.name = "wifi"	},
-	{	.type = RFKILL_TYPE_WLAN,		.name = "wlan"	}, /* alias */
-	{	.type = RFKILL_TYPE_BLUETOOTH,	.name = "bluetooth"	},
-	{	.type = RFKILL_TYPE_UWB,		.name = "uwb"	},
-	{	.type = RFKILL_TYPE_UWB,		.name = "ultrawideband"	}, /* alias */
-	{	.type = RFKILL_TYPE_WIMAX,		.name = "wimax"	},
-	{	.type = RFKILL_TYPE_WWAN,		.name = "wwan"	},
-	{	.type = RFKILL_TYPE_GPS,		.name = "gps"	},
-	{	.type = RFKILL_TYPE_FM,			.name = "fm"	},
-	{	.name = NULL }
-};
-
-static enum rfkill_type rfkill_str_to_type(const char *s)
-{
-	const struct rfkill_type_str *p;
-
-	for (p = rfkill_type_strings; p->name != NULL; p++) {
-		if ((strlen(s) == strlen(p->name)) && (!strcmp(s,p->name)))
-			return p->type;
-	}
-	return NUM_RFKILL_TYPES;
-}
-
 static const char *argv0;
 
 static void usage(void)
@@ -247,26 +283,6 @@ static void version(void)
 	printf("rfkill %s\n", rfkill_version);
 }
 
-static int do_block_unblock(__u8 block, const char *param)
-{
-	enum rfkill_type t;
-	__u32 idx;
-
-	if (islower(*param)) {
-		/* assume alphabetic characters imply a wireless type name */
-		t = rfkill_str_to_type(param);
-		if (t < NUM_RFKILL_TYPES)
-			return rfkill_block(true, 0, block, t);
-	} else if (isdigit(*param)) {
-		/* assume a numeric character implies an index. */
-		idx = atoi(param);
-		return rfkill_block(false, idx, block, 0);
-	}
-
-	fprintf(stderr,"Bogus %sblock argument '%s'.\n",block?"":"un",param);
-	exit(1);
-}
-
 int main(int argc, char **argv)
 {
 	int ret = 0;
@@ -292,11 +308,11 @@ int main(int argc, char **argv)
 	} else if (strcmp(*argv, "block") == 0 && argc > 1) {
 		argc--;
 		argv++;
-		ret = do_block_unblock(1,*argv);
+		ret = rfkill_block(1,*argv);
 	} else if (strcmp(*argv, "unblock") == 0 && argc > 1) {
 		argc--;
 		argv++;
-		ret = do_block_unblock(0,*argv);
+		ret = rfkill_block(0,*argv);
 	} else {
 		usage();
 		return 1;
-- 
1.6.5

