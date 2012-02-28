Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6942 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab2B1BGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 20:06:08 -0500
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <hauke@hauke-m.de>, <nbd@nbd.name>, <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 7/7] compat: optimize building by extending .PHONY
Date: Mon, 27 Feb 2012 17:05:41 -0800
Message-ID: <1330391141-19909-8-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120228_020626_751489_B582C9EC)
In-Reply-To: <1330391141-19909-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1330391141-19909-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@frijolero.org>

I've started reading make -d output to realize that GNU Make
is pretty simple but darn stupid and needs a little help in
direction. Traditionally GNU Make will try to see if it needs
Makefile* generation. I can count 18 variations of Makefile it
looks for:

Makefile
Makefile.c
Makefile.C
Makefile.cc
Makefile.cpp
Makefile.f
Makefile.F
Makefile.l
Makefile.mod
Makefile.o
Makefile.p
Makefile.r
Makefile.s
Makefile.S
Makefile.sh
Makefile.w
Makefile.web
Makefile.y

GNU Make will look for targets in the Makefile for each of these...

GNU Make will also look for these 18 variations of files for each
target that it does not a target rule for. There are two ways to
help GNU Make do the right thing, write a simple empty target rule [0]
or just extend the target into the .PHONY target. Lets just extend
the .PHONY target with the items we see in make -d are not needed.
This simple change forces GNU Make to skip 36 lookups of false
targets.

[0] Makefile : ;

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 9e676ed..82d4cbb 100644
--- a/Makefile
+++ b/Makefile
@@ -69,4 +69,4 @@ clean:
 clean-files := Module.symvers modules.order Module.markers compat/modules.order
 clean-files += modules $(COMPAT_CONFIG) $(COMPAT_AUTOCONF)
 
-.PHONY: all install clean
+.PHONY: all install clean modules Makefile
-- 
1.7.4.15.g7811d

