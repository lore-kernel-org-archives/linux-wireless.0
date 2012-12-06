Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37205 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946513Ab2LFSRd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 13:17:33 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 06/13] qca-swiss-army-knife: fix string length for ar9340
Date: Thu,  6 Dec 2012 19:17:20 +0100
Message-Id: <1354817847-23440-7-git-send-email-juhosg@openwrt.org> (sfid-20121206_191739_341386_08DA2257)
In-Reply-To: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
References: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/initvals.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index cb0bbbf..cff2c4e 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -838,7 +838,7 @@ static void print_initvals_family(char *family, bool check)
 		ar9330_1p2_hw_print_initvals(check);
 		if (!check)
 			printf("#endif /* INITVALS_9330_1P2_H */\n");
-	} else if (strncmp(family, "ar9340", 10) == 0) {
+	} else if (strncmp(family, "ar9340", 6) == 0) {
 		if (!check) {
 			printf("#ifndef INITVALS_9340_H\n");
 			printf("#define INITVALS_9340_H\n");
-- 
1.7.10

