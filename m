Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34747 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759623Ab2EKQj7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 12:39:59 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/6] atheros-initvals: add a makefile target for refreshing all initval files
Date: Fri, 11 May 2012 18:39:51 +0200
Message-Id: <1336754396-30216-1-git-send-email-nbd@openwrt.org> (sfid-20120511_184015_495582_A1581FAD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 Makefile |   31 +++++++++++++++++++++----------
 1 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/Makefile b/Makefile
index ad02c6d..b8b0838 100644
--- a/Makefile
+++ b/Makefile
@@ -23,22 +23,33 @@ ATHEROS_DEPS += \
 	ar9300_jupiter20.ini
 endif
 
-ATH9K_DEPS += \
-	ar5008_initvals.h 	\
-	ar9001_initvals.h	\
-	ar9002_initvals.h 	\
-	ar9003_2p2_initvals.h	\
-	ar9330_1p1_initvals.h	\
-	ar9330_1p2_initvals.h	\
-	ar9485_initvals.h	\
-	ar9580_1p0_initvals.h   \
-	ar9462_2p0_initvals.h
+ATH9K_HEADERS = \
+	ar5008:ar5008_initvals.h		\
+	ar9001:ar9001_initvals.h		\
+	ar9002:ar9002_initvals.h		\
+	ar9003-2p2:ar9003_2p2_initvals.h	\
+	ar9330-1p1:ar9330_1p1_initvals.h	\
+	ar9330-1p2:ar9330_1p2_initvals.h	\
+	ar9485:ar9485_initvals.h		\
+	ar9580-1p0:ar9580_1p0_initvals.h \
+	ar9462-2p0:ar9462_2p0_initvals.h
+
+ATH9K_DEPS := $(foreach header,$(ATH9K_HEADERS),$(word 2,$(subst :, ,$(header))))
 
 SOURCES:=initvals.c sha1.c
 
 initvals: $(ATH9K_DEPS) $(ATHEROS_DEPS) $(SOURCES)
 	gcc $(LOCAL_CFLAGS) -o $@ $(SOURCES)
 
+define refresh_command
+	./initvals -w -f $(word 1,$(subst :, ,$(1))) > $(word 2,$(subst :, ,$(1)))
+
+endef
+
+refresh: initvals
+	$(foreach header,$(ATH9K_HEADERS),$(call refresh_command,$(header)))
+	./initvals > checksums.txt
+
 all: initvals
 
 clean:
-- 
1.7.3.2

