Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45398 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759862Ab2C3LLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 07:11:05 -0400
Message-ID: <1333105864.3908.12.camel@jlt3.sipsolutions.net> (sfid-20120330_131110_674965_CB758ECF)
Subject: [PATCH 1/2] compat-wireless: include config.mk early
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 30 Mar 2012 13:11:04 +0200
In-Reply-To: <1333105815.3908.11.camel@jlt3.sipsolutions.net> (sfid-20120330_131022_444171_B95DE05C)
References: <1333105815.3908.11.camel@jlt3.sipsolutions.net>
	 (sfid-20120330_131022_444171_B95DE05C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Not doing so can cause extreme build slowdowns,
somehow that confuses the kernel's Makefiles into
calculating the size of every single file all the
time (the calculation code is part of compressing
the kernel with bzip2 etc. so that's very strange.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 67f8e84..bbd77f7 100644
--- a/Makefile
+++ b/Makefile
@@ -12,7 +12,6 @@ DESTDIR?=
 
 ifneq ($(KERNELRELEASE),)
 
-include $(COMPAT_CONFIG_CW)
 include $(COMPAT_CONFIG)
 
 NOSTDINC_FLAGS := -I$(M)/include/ \
@@ -68,6 +67,8 @@ export COMPAT_AUTOCONF=include/linux/compat_autoconf.h
 export CREL_PRE:=.compat_autoconf_
 export CREL_CHECK:=$(PWD)/$(CREL_PRE)$(CREL)
 
+include $(COMPAT_CONFIG_CW)
+
 all: modules
 
 $(COMPAT_CONFIG): ;
-- 
1.7.9.1



