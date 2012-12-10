Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:37365 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab2LJP6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 10:58:43 -0500
To: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>
Subject: [PATCH] crda: fix compilation with libnl-3.0
Date: Mon, 10 Dec 2012 17:58:39 +0200
Message-ID: <5452866.tG58b6Y9lW@lx-vladimir> (sfid-20121210_165847_463580_D66A06B6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 97f1b27e02740ce6bb83c548de0c0a7fbe9b648f Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Mon, 10 Dec 2012 17:54:29 +0200
Subject: [PATCH] crda: fix compilation with libnl-3.0

On the distributives that use libnl v.3, libnl-genl named
libnl-genl-3.

Checked for both rpm based distros and Ubuntu.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 084d8e5..f5bd130 100644
--- a/Makefile
+++ b/Makefile
@@ -51,7 +51,7 @@ NL3FOUND := $(shell pkg-config --atleast-version=3 libnl-3.0 && echo Y)
 
 ifeq ($(NL3FOUND),Y)
 CFLAGS += -DCONFIG_LIBNL30
-NLLIBS += -lnl-genl
+NLLIBS += -lnl-genl-3
 NLLIBNAME = libnl-3.0
 else
 	ifeq ($(NL2FOUND),Y)
-- 
1.7.10.4


