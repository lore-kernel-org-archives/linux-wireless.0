Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.189]:56327 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbYI1UI3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 16:08:29 -0400
Received: by mu-out-0910.google.com with SMTP id g7so1466878muf.1
        for <linux-wireless@vger.kernel.org>; Sun, 28 Sep 2008 13:08:27 -0700 (PDT)
Date: Sun, 28 Sep 2008 22:08:21 +0200
From: Davide Pesavento <davidepesa@gmail.com>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [CRDA PATCH 3/4] Use char literals in comparisons, instead of
	their ASCII codes.
Message-ID: <20080928200821.GA5945@PesaBook.pesa.homelinux.org> (sfid-20080928_220831_715636_6D4E3B3E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Davide Pesavento <davidepesa@gmail.com>
---
 crda.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/crda.c b/crda.c
index e4cbe96..72ac42b 100644
--- a/crda.c
+++ b/crda.c
@@ -110,7 +110,7 @@ static int error_handler(struct sockaddr_nl *nla, struct nlmsgerr *err, void *ar
 
 int isalpha_upper(char letter)
 {
-	if (letter >= 65 && letter <= 90)
+	if (letter >= 'A' && letter <= 'Z')
 		return 1;
 	return 0;
 }
@@ -124,8 +124,7 @@ static int is_alpha2(char *alpha2)
 
 static int is_world_regdom(char *alpha2)
 {
-	/* ASCII 0 */
-	if (alpha2[0] == 48 && alpha2[1] == 48)
+	if (alpha2[0] == '0' && alpha2[1] == '0')
 		return 1;
 	return 0;
 }
-- 
1.6.0.2

