Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:12312 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbZA3Wdh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 17:33:37 -0500
Subject: [PATCH] iw: report if no supported version of libnl is found
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Fri, 30 Jan 2009 17:33:34 -0500
Message-ID: <20090130223334.15961.45110.stgit@dv.roinet.com> (sfid-20090130_233341_046216_98F41A7D)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise, the error messase would be very confusing.
---
 Makefile |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index 4de66e8..89ebd7f 100644
--- a/Makefile
+++ b/Makefile
@@ -29,6 +29,10 @@ LIBS += -lnl-genl
 NLLIBNAME = libnl-2.0
 endif
 
+ifeq ($(NLLIBNAME),)
+$(error Cannot find development files for any supported version of libnl)
+endif
+
 LIBS += $(shell pkg-config --libs $(NLLIBNAME))
 CFLAGS += $(shell pkg-config --cflags $(NLLIBNAME))
 
