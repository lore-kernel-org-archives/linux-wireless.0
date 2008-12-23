Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:61312 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbYLWFAL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 00:00:11 -0500
Subject: [PATCH] crda: use strerror() to report error code verbosely
To: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Tue, 23 Dec 2008 00:00:07 -0500
Message-ID: <20081223050006.3710.98311.stgit@ct.roinet.com> (sfid-20081223_060018_312821_FD12EA72)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 crda.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/crda.c b/crda.c
index afc5df1..fe2766b 100644
--- a/crda.c
+++ b/crda.c
@@ -6,6 +6,7 @@
 
 #include <errno.h>
 #include <stdio.h>
+#include <string.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <fcntl.h>
@@ -297,7 +298,8 @@ int main(int argc, char **argv)
 	r = nl_send_auto_complete(nlstate.nl_handle, msg);
 
 	if (r < 0) {
-		fprintf(stderr, "Failed to send regulatory request: %d\n", r);
+		fprintf(stderr, "Failed to send regulatory request: %s\n",
+			strerror(-r));
 		goto cb_out;
 	}
 
@@ -309,7 +311,7 @@ int main(int argc, char **argv)
 		r = nl_wait_for_ack(nlstate.nl_handle);
 		if (r < 0) {
 			fprintf(stderr, "Failed to set regulatory domain: "
-				"%d\n", r);
+				"%s\n", strerror(-r));
 			goto cb_out;
 		}
 	}
