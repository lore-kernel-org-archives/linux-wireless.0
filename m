Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:34144 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab1LSVZj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 16:25:39 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: Rodriguez Luis <rodrigue@qca.qualcomm.com>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 12/15] initvals: make 'print_initvals_family' static void
Date: Mon, 19 Dec 2011 22:24:57 +0100
Message-Id: <1324329900-3923-13-git-send-email-juhosg@openwrt.org> (sfid-20111219_222544_238067_BF83E390)
In-Reply-To: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
References: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch fixes the following warnings
(with CFLAGS=-Wall):

initvals.c:608: warning: return type defaults to ‘int’
initvals.c: In function ‘print_initvals_family’:
initvals.c:670: warning: control reaches end of non-void function

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 initvals.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/initvals.c b/initvals.c
index eca6705..9c149ef 100644
--- a/initvals.c
+++ b/initvals.c
@@ -605,7 +605,7 @@ static void usage()
 	printf("Usage: initvals [-w] [-f ar5008 | ar9001 | ar9002 | ar9003-2p2 | ar9330-1p1 | ar9330-1p2 | ar9485 | ar9580-1p0 ]\n");
 }
 
-print_initvals_family(char *family, bool check)
+static void print_initvals_family(char *family, bool check)
 {
 	if (!check)
 		print_license();
-- 
1.7.2.1

