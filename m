Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:39433 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671Ab0AYWdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 17:33:37 -0500
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] Help text: output rfkill type names from an array instead of a static string.
Date: Mon, 25 Jan 2010 22:33:30 +0000
Message-Id: <1264458811-21411-2-git-send-email-linux@youmustbejoking.demon.co.uk>
In-Reply-To: <1264458811-21411-1-git-send-email-linux@youmustbejoking.demon.co.uk>
References: <1264458811-21411-1-git-send-email-linux@youmustbejoking.demon.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 rfkill.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/rfkill.c b/rfkill.c
index 8fa4c6a..bda649a 100644
--- a/rfkill.c
+++ b/rfkill.c
@@ -291,6 +291,8 @@ static const char *argv0;
 
 static void usage(void)
 {
+	const struct rfkill_type_str *p;
+
 	fprintf(stderr, "Usage:\t%s [options] command\n", argv0);
 	fprintf(stderr, "Options:\n");
 	fprintf(stderr, "\t--version\tshow version (%s)\n", rfkill_version);
@@ -301,7 +303,10 @@ static void usage(void)
 	fprintf(stderr, "\tblock IDENTIFIER\n");
 	fprintf(stderr, "\tunblock IDENTIFIER\n");
 	fprintf(stderr, "where IDENTIFIER is the index no. of an rfkill switch or one of:\n");
-	fprintf(stderr, "\t<idx> all wifi wlan bluetooth uwb ultrawideband wimax wwan gps\n");
+	fprintf(stderr, "\t<idx>");
+	for (p = rfkill_type_strings; p->name != NULL; p++)
+		fprintf(stderr, " %s", p->name);
+	fprintf(stderr, "\n");
 }
 
 static void version(void)
-- 
1.6.5

