Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41921 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab2F1A0m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 20:26:42 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com
Subject: [PATCH 03/11] qca-swiss-army-knife: only depend on ath9k header files if ATHEROS is unset
Date: Thu, 28 Jun 2012 02:26:31 +0200
Message-Id: <1340843199-49821-3-git-send-email-nbd@openwrt.org> (sfid-20120628_022651_339553_3D6DA54C)
In-Reply-To: <1340843199-49821-2-git-send-email-nbd@openwrt.org>
References: <1340843199-49821-1-git-send-email-nbd@openwrt.org>
 <1340843199-49821-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 tools/initvals/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/initvals/Makefile b/tools/initvals/Makefile
index 25a034f..a7f7c0c 100644
--- a/tools/initvals/Makefile
+++ b/tools/initvals/Makefile
@@ -36,7 +36,9 @@ ATH9K_HEADERS = \
 	ar9580-1p0:ar9580_1p0_initvals.h \
 	ar9462-2p0:ar9462_2p0_initvals.h
 
+ifndef ATHEROS
 ATH9K_DEPS := $(foreach header,$(ATH9K_HEADERS),$(word 2,$(subst :, ,$(header))))
+endif
 
 SOURCES:=initvals.c sha1.c
 
-- 
1.7.3.2

