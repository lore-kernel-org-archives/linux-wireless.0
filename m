Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:39537 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758884AbbCDTwA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 14:52:00 -0500
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id B91E33407A8
	for <linux-wireless@vger.kernel.org>; Wed,  4 Mar 2015 19:51:59 +0000 (UTC)
From: Mike Frysinger <vapier@gentoo.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH crda 4/4] clean up CFLAGS handling
Date: Wed,  4 Mar 2015 14:51:54 -0500
Message-Id: <1425498714-8654-4-git-send-email-vapier@gentoo.org> (sfid-20150304_205210_050153_C1FD743D)
In-Reply-To: <1425498714-8654-1-git-send-email-vapier@gentoo.org>
References: <1425498714-8654-1-git-send-email-vapier@gentoo.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mike Frysinger <vapier@chromium.org>

Rather than append -O2 -g all the time to the user's CFLAGS (and thus
clobbering whatever they have set up), initialize the default value to
that and let the user override it entirely.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 5f988f4..8e345a1 100644
--- a/Makefile
+++ b/Makefile
@@ -26,9 +26,9 @@ PUBKEY_DIR?=pubkeys
 RUNTIME_PUBKEY_DIR?=/etc/wireless-regdb/pubkeys
 
 WERROR = -Werror
-CFLAGS += -O2 -fpic
+CFLAGS ?= -O2 -g
+CFLAGS += -fpic
 CFLAGS += -std=gnu99 -Wall $(WERROR) -pedantic
-CFLAGS += -Wall -g
 LDLIBREG += -lreg
 LDLIBS += $(LDLIBREG)
 LDLIBS += -lm
-- 
2.3.1

