Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:60578 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbZKJR3e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 12:29:34 -0500
Received: from p5099b351.dip0.t-ipconnect.de ([80.153.179.81] helo=zzz.local)
	by bar.sig21.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_SHA1:16)
	(Exim 4.63)
	(envelope-from <js@sig21.net>)
	id 1N7uX9-0006Wn-BC
	for linux-wireless@vger.kernel.org; Tue, 10 Nov 2009 18:29:39 +0100
Received: from js by zzz.local with local (Exim 4.69)
	(envelope-from <js@sig21.net>)
	id 1N7uX8-0000wT-Lt
	for linux-wireless@vger.kernel.org; Tue, 10 Nov 2009 18:29:34 +0100
Date: Tue, 10 Nov 2009 18:29:34 +0100
From: Johannes Stezenbach <js@sig21.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] iw: use PKG_CONFIG variable consistently
Message-ID: <20091110172934.GA3600@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the correct pkg-config version consistently.
Note: For quick&dirty cross compilation I used the following in .config:

PKG_CONFIG = false
NLLIBNAME = libnl-1
LIBS += -L../libnl-1.1/lib -lnl
CFLAGS += -I../libnl-1.1/include
CC := arm-linux-gcc

Signed-off-by: Johannes Stezenbach <js@sig21.net>
---

diff --git a/Makefile b/Makefile
index 68bef4d..1174130 100644
--- a/Makefile
+++ b/Makefile
@@ -38,8 +38,8 @@ ifeq ($(NLLIBNAME),)
 $(error Cannot find development files for any supported version of libnl)
 endif
 
-LIBS += $(shell pkg-config --libs $(NLLIBNAME))
-CFLAGS += $(shell pkg-config --cflags $(NLLIBNAME))
+LIBS += $(shell $(PKG_CONFIG) --libs $(NLLIBNAME))
+CFLAGS += $(shell $(PKG_CONFIG) --cflags $(NLLIBNAME))
 
 ifeq ($(V),1)
 Q=
