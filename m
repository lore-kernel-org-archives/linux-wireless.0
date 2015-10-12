Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37762 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbbJLUcS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 16:32:18 -0400
Received: by wijq8 with SMTP id q8so762044wij.0
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2015 13:32:17 -0700 (PDT)
From: Ola Olsson <ola1olsson@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ola Olsson <ola1olsson@gmail.com>,
	Ola Olsson <ola.olsson@sonymobile.com>
Subject: [PATCH] iw: Adding helpful hints for vendor cmd
Date: Mon, 12 Oct 2015 22:32:10 +0200
Message-Id: <1444681930-25527-1-git-send-email-ola1olsson@gmail.com> (sfid-20151012_223225_121991_F6331593)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without having access to the source, it was
hard to know the format of vendor oui and sub
cmd. This commit fixes that.

Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
---
 vendor.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/vendor.c b/vendor.c
index d0b4f9e..86c03d1 100644
--- a/vendor.c
+++ b/vendor.c
@@ -55,15 +55,19 @@ static int handle_vendor(struct nl80211_state *state,
 	FILE *file = NULL;
 
 	if (argc < 3)
-		return -EINVAL;
+		return 1;
 
 	res = sscanf(argv[0], "0x%x", &oui);
-	if (res != 1)
-		return -EINVAL;
+	if (res != 1) {
+		printf("Vendor command must start with 0x\n");
+		return 2;
+	}
 
 	res = sscanf(argv[1], "0x%x", &subcmd);
-	if (res != 1)
-		return -EINVAL;
+	if (res != 1) {
+		printf("Sub command must start with 0x\n");
+		return 2;
+	}
 
 	if (!strcmp(argv[2], "-"))
 		file = stdin;
-- 
1.7.9.5

