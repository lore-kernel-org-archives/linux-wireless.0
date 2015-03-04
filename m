Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:39533 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757921AbbCDTv7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 14:51:59 -0500
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id E8F8D340784
	for <linux-wireless@vger.kernel.org>; Wed,  4 Mar 2015 19:51:58 +0000 (UTC)
From: Mike Frysinger <vapier@gentoo.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH crda 2/4] allow people to turn off -Werror
Date: Wed,  4 Mar 2015 14:51:52 -0500
Message-Id: <1425498714-8654-2-git-send-email-vapier@gentoo.org> (sfid-20150304_205207_348128_4A5AEDAB)
In-Reply-To: <1425498714-8654-1-git-send-email-vapier@gentoo.org>
References: <1425498714-8654-1-git-send-email-vapier@gentoo.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mike Frysinger <vapier@chromium.org>

Forcing -Werror at build time easily breaks across compiler settings,
compiler versions, architectures, C libraries, etc...  Add a knob so
distro peeps can turn it off.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 46c683d..5f988f4 100644
--- a/Makefile
+++ b/Makefile
@@ -25,8 +25,9 @@ UDEV_RULE_DIR?=/lib/udev/rules.d/
 PUBKEY_DIR?=pubkeys
 RUNTIME_PUBKEY_DIR?=/etc/wireless-regdb/pubkeys
 
+WERROR = -Werror
 CFLAGS += -O2 -fpic
-CFLAGS += -std=gnu99 -Wall -Werror -pedantic
+CFLAGS += -std=gnu99 -Wall $(WERROR) -pedantic
 CFLAGS += -Wall -g
 LDLIBREG += -lreg
 LDLIBS += $(LDLIBREG)
-- 
2.3.1

