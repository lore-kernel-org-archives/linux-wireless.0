Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:53916 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754262Ab0AVXfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 18:35:36 -0500
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/6] Add filtering to "rfkill list".
Date: Fri, 22 Jan 2010 23:35:30 +0000
Message-Id: <1264203330-20785-6-git-send-email-linux@youmustbejoking.demon.co.uk>
In-Reply-To: <1264203330-20785-5-git-send-email-linux@youmustbejoking.demon.co.uk>
References: <1264203330-20785-1-git-send-email-linux@youmustbejoking.demon.co.uk>
 <1264203330-20785-2-git-send-email-linux@youmustbejoking.demon.co.uk>
 <1264203330-20785-3-git-send-email-linux@youmustbejoking.demon.co.uk>
 <1264203330-20785-4-git-send-email-linux@youmustbejoking.demon.co.uk>
 <1264203330-20785-5-git-send-email-linux@youmustbejoking.demon.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 rfkill.c |   34 +++++++++++++++++++++++++++++++---
 1 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/rfkill.c b/rfkill.c
index 998728e..8fa4c6a 100644
--- a/rfkill.c
+++ b/rfkill.c
@@ -172,13 +172,25 @@ static struct rfkill_id rfkill_id_to_type(const char *s)
 	return ret;
 }
 
-static int rfkill_list(void)
+static int rfkill_list(const char *param)
 {
+	struct rfkill_id id = { .result = RFKILL_IS_INVALID };
 	struct rfkill_event event;
 	const char *name;
 	ssize_t len;
 	int fd;
 
+	if (param) {
+		id = rfkill_id_to_type(param);
+		if (id.result == RFKILL_IS_INVALID) {
+			fprintf(stderr, "Bogus %s argument '%s'.\n", "list", param);
+			return 2;
+		}
+		/* don't filter "all" */
+		if (id.result == RFKILL_IS_TYPE && id.type == RFKILL_TYPE_ALL)
+			id.result = RFKILL_IS_INVALID;
+	}
+
 	fd = open("/dev/rfkill", O_RDONLY);
 	if (fd < 0) {
 		perror("Can't open RFKILL control device");
@@ -208,6 +220,20 @@ static int rfkill_list(void)
 		if (event.op != RFKILL_OP_ADD)
 			continue;
 
+		/* filter out unwanted results */
+		switch (id.result)
+		{
+		case RFKILL_IS_TYPE:
+			if (event.type != id.type)
+				continue;
+			break;
+		case RFKILL_IS_INDEX:
+			if (event.idx != id.index)
+				continue;
+			break;
+		case RFKILL_IS_INVALID:; /* must be last */
+		}
+
 		name = get_name(event.idx);
 
 		printf("%u: %s: %s\n", event.idx, name,
@@ -271,7 +297,7 @@ static void usage(void)
 	fprintf(stderr, "Commands:\n");
 	fprintf(stderr, "\thelp\n");
 	fprintf(stderr, "\tevent\n");
-	fprintf(stderr, "\tlist\n");
+	fprintf(stderr, "\tlist [IDENTIFIER]\n");
 	fprintf(stderr, "\tblock IDENTIFIER\n");
 	fprintf(stderr, "\tunblock IDENTIFIER\n");
 	fprintf(stderr, "where IDENTIFIER is the index no. of an rfkill switch or one of:\n");
@@ -304,7 +330,9 @@ int main(int argc, char **argv)
 	if (strcmp(*argv, "event") == 0) {
 		rfkill_event();
 	} else if (strcmp(*argv, "list") == 0) {
-		rfkill_list();
+		argc--;
+		argv++;
+		rfkill_list(*argv); /* NULL is acceptable */
 	} else if (strcmp(*argv, "block") == 0 && argc > 1) {
 		argc--;
 		argv++;
-- 
1.6.5

