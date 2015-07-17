Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbbGQQQu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 12:16:50 -0400
Subject: [PATCH 09/27] modsign: Abort modules_install when signing fails
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Fri, 17 Jul 2015 17:16:44 +0100
Message-ID: <20150717161644.2578.6348.stgit@warthog.procyon.org.uk> (sfid-20150717_182323_815823_BCC01CC4)
In-Reply-To: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
References: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Woodhouse <David.Woodhouse@intel.com>

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 scripts/Makefile.modinst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.modinst b/scripts/Makefile.modinst
index e48a4e9d8868..07650eeaaf06 100644
--- a/scripts/Makefile.modinst
+++ b/scripts/Makefile.modinst
@@ -22,7 +22,7 @@ quiet_cmd_modules_install = INSTALL $@
     mkdir -p $(2) ; \
     cp $@ $(2) ; \
     $(mod_strip_cmd) $(2)/$(notdir $@) ; \
-    $(mod_sign_cmd) $(2)/$(notdir $@) $(patsubst %,|| true,$(KBUILD_EXTMOD)) ; \
+    $(mod_sign_cmd) $(2)/$(notdir $@) $(patsubst %,|| true,$(KBUILD_EXTMOD)) && \
     $(mod_compress_cmd) $(2)/$(notdir $@)
 
 # Modules built outside the kernel source tree go into extra by default

