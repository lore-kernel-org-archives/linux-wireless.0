Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:34074 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab1LSVZ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 16:25:27 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: Rodriguez Luis <rodrigue@qca.qualcomm.com>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 09/15] initvals: fix printf format warnings
Date: Mon, 19 Dec 2011 22:24:54 +0100
Message-Id: <1324329900-3923-10-git-send-email-juhosg@openwrt.org> (sfid-20111219_222540_098073_3302E7A1)
In-Reply-To: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
References: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch fixes the following warnings
(with CFLAGS=-Wformat):

initvals.c: In function ‘ar5008_hw_print_initvals’:
initvals.c:393: warning: format ‘%ld’ expects type ‘long int’, but argument 2 has type ‘unsigned int’
initvals.c:394: warning: format ‘%ld’ expects type ‘long int’, but argument 2 has type ‘unsigned int’
initvals.c:395: warning: format ‘%ld’ expects type ‘long int’, but argument 2 has type ‘unsigned int’
initvals.c:396: warning: format ‘%ld’ expects type ‘long int’, but argument 2 has type ‘unsigned int’
initvals.c:397: warning: format ‘%ld’ expects type ‘long int’, but argument 2 has type ‘unsigned int’
initvals.c:398: warning: format ‘%ld’ expects type ‘long int’, but argument 2 has type ‘unsigned int’
initvals.c:399: warning: format ‘%ld’ expects type ‘long int’, but argument 2 has type ‘unsigned int’
initvals.c:400: warning: format ‘%ld’ expects type ‘long int’, but argument 2 has type ‘unsigned int’
initvals.c:401: warning: format ‘%ld’ expects type ‘long int’, but argument 2 has type ‘unsigned int’
initvals.c:402: warning: format ‘%ld’ expects type ‘long int’, but argument 2 has type ‘unsigned int’
initvals.c:403: warning: format ‘%ld’ expects type ‘long int’, but argument 2 has type ‘unsigned int’
...

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 initvals.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/initvals.c b/initvals.c
index a12573a..1908986 100644
--- a/initvals.c
+++ b/initvals.c
@@ -257,7 +257,7 @@ typedef long long unsigned int u64;
 						ARRAY_SIZE(_array), ARRAY_SIZE((_array)[0])); \
 		printf("0x%016llx        "#_array"\n", chksum); \
 	} else { \
-		printf("static const u32 "#_array"[][%ld] = {\n", ARRAY_SIZE((_array)[0])); \
+		printf("static const u32 "#_array"[][%d] = {\n", (int) ARRAY_SIZE((_array)[0])); \
 		ath9k_hw_print_initval((const u32 *) _array, \
 				       ARRAY_SIZE(_array), ARRAY_SIZE((_array)[0]), false); \
 	} \
-- 
1.7.2.1

