Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:34048 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab1LSVZW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 16:25:22 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: Rodriguez Luis <rodrigue@qca.qualcomm.com>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 07/15] initvals: allow to use additional CFLAGS
Date: Mon, 19 Dec 2011 22:24:52 +0100
Message-Id: <1324329900-3923-8-git-send-email-juhosg@openwrt.org> (sfid-20111219_222531_165207_FD09210D)
In-Reply-To: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
References: <1324329900-3923-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 Makefile |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 1194504..0df14df 100644
--- a/Makefile
+++ b/Makefile
@@ -1,5 +1,8 @@
+CFLAGS=
+
+LOCAL_CFLAGS=$(CFLAGS)
 ifdef ATHEROS
-CFLAGS += -DATHEROS
+LOCAL_CFLAGS += -DATHEROS
 
 ATHEROS_DEPS += \
 	ar9280.ini		\
@@ -25,7 +28,7 @@ ATH9K_DEPS += \
 	ar9580_1p0_initvals.h
 
 initvals: $(ATH9K_DEPS) $(ATHEROS_DEPS) initvals.c
-	gcc $(CFLAGS) -o $@ $@.c
+	gcc $(LOCAL_CFLAGS) -o $@ $@.c
 
 all: initvals
 
-- 
1.7.2.1

