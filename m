Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:33458 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549AbZA3WdL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 17:33:11 -0500
Subject: [PATCH] crda: report if no supported version of libnl is found
To: Luis R Rodriguez <mcgrof@gmail.com>, linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Fri, 30 Jan 2009 17:33:06 -0500
Message-ID: <20090130223305.15916.7954.stgit@dv.roinet.com> (sfid-20090130_233315_604379_DB59274D)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise, the error messase would be very confusing.
---
 Makefile |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index aaa9ca6..461103d 100644
--- a/Makefile
+++ b/Makefile
@@ -52,6 +52,10 @@ NLLIBS += -lnl-genl
 NLLIBNAME = libnl-2.0
 endif
 
+ifeq ($(NLLIBNAME),)
+$(error Cannot find development files for any supported version of libnl)
+endif
+
 NLLIBS += `pkg-config --libs $(NLLIBNAME)`
 CFLAGS += `pkg-config --cflags $(NLLIBNAME)`
 
