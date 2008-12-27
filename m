Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:41720 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbYL0Gm6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2008 01:42:58 -0500
Subject: Re: [PATCH] wireless-regdb: Add install target to Makefile
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Luis Rodriguez <mcgrof@gmail.com>
In-Reply-To: <200812262342.57675.mb@bu3sch.de>
References: <200812262342.57675.mb@bu3sch.de>
Content-Type: text/plain
Date: Sat, 27 Dec 2008 01:42:54 -0500
Message-Id: <1230360174.2633.15.camel@dv> (sfid-20081227_074303_655356_4CCBDC94)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-12-26 at 23:42 +0100, Michael Buesch wrote:
> +install:
> +	-install -o 0 -g 0 -m 644 regulatory.bin $(PREFIX)/lib/crda/regulatory.bin

The directory should be created first.  Most likely it doesn't exist.

Also, the minus in front of the "install" command is harmful.  Errors
should not be ignored.  If the file is not installed, "make install"
should fail.

"install -D" is not widely used in makefiles, so let's do it in two
steps.  $(PREFIX)/lib/crda/ could be abstracted as another variable.

Here's my take:

wireless-regdb: Add install target to Makefile

Signed-off-by: Pavel Roskin <proski@gnu.org>

diff --git a/Makefile b/Makefile
index 1d8ff2a..56881a7 100644
--- a/Makefile
+++ b/Makefile
@@ -1,4 +1,8 @@
-.PHONY: all clean
+# Install prefix
+PREFIX = /usr
+CDRA_PATH = $(PREFIX)/lib/crda
+
+.PHONY: all clean install
 
 all: regulatory.bin key.pub.pem
 
@@ -13,3 +17,7 @@ key.pub.pem: key.priv.pem
 
 key.priv.pem:
 	openssl genrsa -out key.priv.pem 2048
+
+install:
+	install -o 0 -g 0 -m 755 -d $(CDRA_PATH)
+	install -o 0 -g 0 -m 644 regulatory.bin $(CDRA_PATH)/regulatory.bin

-- 
Regards,
Pavel Roskin
