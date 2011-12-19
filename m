Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:34127 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab1LSVZh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 16:25:37 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: Rodriguez Luis <rodrigue@qca.qualcomm.com>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 11/15] initvals: include <string.h> to make gcc happy
Date: Mon, 19 Dec 2011 22:24:56 +0100
Message-Id: <1324329900-3923-12-git-send-email-juhosg@openwrt.org> (sfid-20111219_222543_669399_42AD4F65)
In-Reply-To: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
References: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch fixes the following warning
(with CFLAGS=-Wimplicit-function-declaration):

initvals.c: In function ‘print_initvals_family’:
initvals.c:612: warning: implicit declaration of function ‘strncmp’

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 initvals.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/initvals.c b/initvals.c
index 32a38f6..eca6705 100644
--- a/initvals.c
+++ b/initvals.c
@@ -7,6 +7,7 @@
 #include <stdio.h>
 #include <stdint.h>
 #include <stdbool.h>
+#include <string.h>
 
 typedef uint32_t u32;
 typedef long long unsigned int u64;
-- 
1.7.2.1

