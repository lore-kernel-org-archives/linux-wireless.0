Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sender163-mail.zoho.com ([74.201.84.163]:24099 "EHLO
	sender163-mail.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbbKDGbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 01:31:34 -0500
Date: Wed, 04 Nov 2015 08:31:32 +0200
From: Dima Krasner <dima@dimakrasner.com>
To: <linux-wireless@vger.kernel.org>
Message-ID: <150d1317b9d.cfdce22f1276537.435317345116585066@dimakrasner.com> (sfid-20151104_073201_819917_30C19821)
Subject: [PATCH 2/2] iw: Removed the libnl-tiny >= 1 requirement
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Recent libnl-tiny revisions do not specify a version in the pkg-config data. This patch corrects libnl-tiny support added in the previous patch in the series, so it works with the latest revision too.

Cheers,
Dima

>From 84f4fbf5e9f765dafbb436b2593f13d1326a27ea Mon Sep 17 00:00:00 2001
From: Dima Krasner <dima@dimakrasner.com>
Date: Wed, 4 Nov 2015 07:57:04 +0200
Subject: [PATCH 2/2] Removed the libnl-tiny >= 1 requirement

---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 63169a3..4077020 100644
--- a/Makefile
+++ b/Makefile
@@ -27,7 +27,7 @@ OBJS += $(OBJS-y) $(OBJS-Y)
 ALL = iw
 
 ifeq ($(NO_PKG_CONFIG),)
-NLTINYFOUND := $(shell $(PKG_CONFIG) --atleast-version=1 libnl-tiny && echo Y)
+NLTINYFOUND := $(shell $(PKG_CONFIG) libnl-tiny && echo Y)
 ifneq ($(NLTINYFOUND),Y)
 NL3xFOUND := $(shell $(PKG_CONFIG) --atleast-version=3.2 libnl-3.0 && echo Y)
 ifneq ($(NL3xFOUND),Y)
-- 
1.9.1

