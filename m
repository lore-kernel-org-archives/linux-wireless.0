Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:38601 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754845Ab0AVXfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 18:35:36 -0500
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/6] Return error codes instead of exiting.
Date: Fri, 22 Jan 2010 23:35:28 +0000
Message-Id: <1264203330-20785-4-git-send-email-linux@youmustbejoking.demon.co.uk>
In-Reply-To: <1264203330-20785-3-git-send-email-linux@youmustbejoking.demon.co.uk>
References: <1264203330-20785-1-git-send-email-linux@youmustbejoking.demon.co.uk>
 <1264203330-20785-2-git-send-email-linux@youmustbejoking.demon.co.uk>
 <1264203330-20785-3-git-send-email-linux@youmustbejoking.demon.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 rfkill.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/rfkill.c b/rfkill.c
index 8c0aea6..4cf507a 100644
--- a/rfkill.c
+++ b/rfkill.c
@@ -118,7 +118,7 @@ static const char *type2string(enum rfkill_type type)
 	return NULL;
 }
 
-static void rfkill_list(void)
+static int rfkill_list(void)
 {
 	struct rfkill_event event;
 	const char *name;
@@ -128,12 +128,13 @@ static void rfkill_list(void)
 	fd = open("/dev/rfkill", O_RDONLY);
 	if (fd < 0) {
 		perror("Can't open RFKILL control device");
-		return;
+		return 1;
 	}
 
 	if (fcntl(fd, F_SETFL, O_NONBLOCK) < 0) {
 		perror("Can't set RFKILL control device to non-blocking");
 		close(fd);
+		return 1;
 	}
 
 	while (1) {
@@ -162,9 +163,10 @@ static void rfkill_list(void)
 	}
 
 	close(fd);
+	return 0;
 }
 
-static void rfkill_block(bool all, __u32 idx, __u8 block, __u8 type)
+static int rfkill_block(bool all, __u32 idx, __u8 block, __u8 type)
 {
 	struct rfkill_event event;
 	ssize_t len;
@@ -173,7 +175,7 @@ static void rfkill_block(bool all, __u32 idx, __u8 block, __u8 type)
 	fd = open("/dev/rfkill", O_RDWR);
 	if (fd < 0) {
 		perror("Can't open RFKILL control device");
-		return;
+		return 1;
 	}
 
 	memset(&event, 0, sizeof(event));
@@ -191,6 +193,7 @@ static void rfkill_block(bool all, __u32 idx, __u8 block, __u8 type)
 		perror("Failed to change RFKILL state");
 
 	close(fd);
+	return 0;
 }
 
 struct rfkill_type_str {
@@ -244,7 +247,7 @@ static void version(void)
 	printf("rfkill %s\n", rfkill_version);
 }
 
-static void do_block_unblock(__u8 block, const char *param)
+static int do_block_unblock(__u8 block, const char *param)
 {
 	enum rfkill_type t;
 	__u32 idx;
@@ -253,24 +256,21 @@ static void do_block_unblock(__u8 block, const char *param)
 		/* assume alphabetic characters imply a wireless type name */
 		t = rfkill_str_to_type(param);
 		if (t < NUM_RFKILL_TYPES)
-			rfkill_block(true, 0, block, t);
-		else
-			goto err;
+			return rfkill_block(true, 0, block, t);
 	} else if (isdigit(*param)) {
 		/* assume a numeric character implies an index. */
 		idx = atoi(param);
-		rfkill_block(false, idx, block, 0);
-	} else
-		goto err;
+		return rfkill_block(false, idx, block, 0);
+	}
 
-	return;
-err:
 	fprintf(stderr,"Bogus %sblock argument '%s'.\n",block?"":"un",param);
 	exit(1);
 }
 
 int main(int argc, char **argv)
 {
+	int ret = 0;
+
 	/* strip off self */
 	argc--;
 	argv0 = *argv++;
@@ -292,15 +292,15 @@ int main(int argc, char **argv)
 	} else if (strcmp(*argv, "block") == 0 && argc > 1) {
 		argc--;
 		argv++;
-		do_block_unblock(1,*argv);
+		ret = do_block_unblock(1,*argv);
 	} else if (strcmp(*argv, "unblock") == 0 && argc > 1) {
 		argc--;
 		argv++;
-		do_block_unblock(0,*argv);
+		ret = do_block_unblock(0,*argv);
 	} else {
 		usage();
 		return 1;
 	}
 
-	return 0;
+	return ret;
 }
-- 
1.6.5

