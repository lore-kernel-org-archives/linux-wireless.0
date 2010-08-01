Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42459 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab0HAWD1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 18:03:27 -0400
Received: by mail-ey0-f174.google.com with SMTP id 25so1118027eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 01 Aug 2010 15:03:26 -0700 (PDT)
From: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	Kshitij Kulshreshtha <kshitij@math.hu-berlin.de>
Subject: [PATCH 4/5] compat-wireless: allow compilation of compat-2.6.35.c from compat
Date: Mon,  2 Aug 2010 00:02:52 +0200
Message-Id: <1280700173-14690-5-git-send-email-kkhere.geo@gmail.com>
In-Reply-To: <4C55D22A.5040302@hauke-m.de>
References: <4C55D22A.5040302@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kshitij Kulshreshtha <kshitij@math.hu-berlin.de>

Signed-off-by: Kshitij Kulshreshtha <kshitij@math.hu-berlin.de>
---
 config.mk |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/config.mk b/config.mk
index e8ec458..733ea33 100644
--- a/config.mk
+++ b/config.mk
@@ -20,7 +20,7 @@ endif
 # as I suspect all users of this package want 802.11e (WME) and
 # 802.11n (HT) support.
 ifneq ($(wildcard $(KLIB_BUILD)/Makefile),)
-COMPAT_LATEST_VERSION = 33
+COMPAT_LATEST_VERSION = 35
 KERNEL_SUBLEVEL := $(shell $(MAKE) -C $(KLIB_BUILD) kernelversion | sed -n 's/^2\.6\.\([0-9]\+\).*/\1/p')
 COMPAT_VERSIONS := $(shell I=$(COMPAT_LATEST_VERSION); while [ "$$I" -gt $(KERNEL_SUBLEVEL) ]; do echo $$I; I=$$(($$I - 1)); done)
 $(foreach ver,$(COMPAT_VERSIONS),$(eval CONFIG_COMPAT_KERNEL_$(ver)=y))
-- 
1.7.1

