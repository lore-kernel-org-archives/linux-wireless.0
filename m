Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:34167 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab1KHHxU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 02:53:20 -0500
From: Gilles Espinasse <g.esp@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Gilles Espinasse <g.esp@free.fr>
Subject: [PATCH] Fix linking with libnl-3
Date: Tue,  8 Nov 2011 09:09:43 +0100
Message-Id: <1320739783-3415-1-git-send-email-g.esp@free.fr> (sfid-20111108_085323_405030_E6668AB4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iw3.2 fail to link libnl-3.2.2 with this error
/usr/bin/ld: cannot find -lnl-genl

Contrary to previous libnl version, on v3 there is a dedicated libnl-genl-3.0.pc file
Simply use that.

Signed-off-by: Gilles Espinasse <g.esp@free.fr>
---
 Makefile |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 8443ee6..fb46324 100644
--- a/Makefile
+++ b/Makefile
@@ -36,10 +36,11 @@ LIBS += -lnl-genl
 NLLIBNAME = libnl-2.0
 endif
 
+# libnl-3 has a separate libnl-genl-3.0.pc
 ifeq ($(NL3FOUND),Y)
 CFLAGS += -DCONFIG_LIBNL30
-LIBS += -lnl-genl
-NLLIBNAME = libnl-3.0
+LIBS =
+NLLIBNAME = libnl-genl-3.0
 endif
 
 ifeq ($(NLLIBNAME),)
-- 
1.5.6.5

