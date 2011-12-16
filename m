Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:36387 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab1LPTT2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 14:19:28 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: Rodriguez Luis <rodrigue@qca.qualcomm.com>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/7] initvals: add ATH9K_DEPS variable to improve Makefile readability
Date: Fri, 16 Dec 2011 20:19:19 +0100
Message-Id: <1324063165-4349-1-git-send-email-juhosg@openwrt.org> (sfid-20111216_201932_123521_06026E3E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 Makefile |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index f7fa59f..facbd2a 100644
--- a/Makefile
+++ b/Makefile
@@ -12,7 +12,13 @@ ATHEROS_DEPS += \
 	ar9300_osprey22.ini
 endif
 
-initvals: ar5008_initvals.h ar9001_initvals.h ar9002_initvals.h ar9003_2p2_initvals.h $(ATHEROS_DEPS) initvals.c
+ATH9K_DEPS += \
+	ar5008_initvals.h 	\
+	ar9001_initvals.h	\
+	ar9002_initvals.h 	\
+	ar9003_2p2_initvals.h
+
+initvals: $(ATH9K_DEPS) $(ATHEROS_DEPS) initvals.c
 	gcc $(CFLAGS) -o $@ $@.c
 
 all: initvals
-- 
1.7.2.1

