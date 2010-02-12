Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:43229 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab0BLVCv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2010 16:02:51 -0500
Date: Fri, 12 Feb 2010 13:02:23 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linville@tuxdriver.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: [PATCH -next] wireless: airo_cs build fixes
Message-Id: <20100212130223.ac3ac46b.randy.dunlap@oracle.com>
In-Reply-To: <20100212181304.a7bd9a63.sfr@canb.auug.org.au>
References: <20100212181304.a7bd9a63.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

When WEXT_PRIV is not enabled, airo_cs has build errors.
It needs to include net/iw_handler.h and it should select
WEXT_PRIV, like the airo driver does.

drivers/net/wireless/airo.c:7655: error: unknown field 'num_private' specified in initializer
drivers/net/wireless/airo.c:7655: warning: initialization makes pointer from integer without a cast
drivers/net/wireless/airo.c:7656: error: unknown field 'num_private_args' specified in initializer
drivers/net/wireless/airo.c:7656: warning: excess elements in struct initializer
drivers/net/wireless/airo.c:7656: warning: (near initialization for 'airo_handler_def')
drivers/net/wireless/airo.c:7658: error: unknown field 'private' specified in initializer
drivers/net/wireless/airo.c:7658: warning: initialization makes integer from pointer without a cast
drivers/net/wireless/airo.c:7658: error: initializer element is not computable at load time
drivers/net/wireless/airo.c:7658: error: (near initialization for 'airo_handler_def.num_standard')
drivers/net/wireless/airo.c:7659: error: unknown field 'private_args' specified in initializer
drivers/net/wireless/airo.c:7659: warning: initialization from incompatible pointer type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/wireless/Kconfig |    1 +
 drivers/net/wireless/airo.c  |    1 +
 2 files changed, 2 insertions(+)

--- linux-next-20100212.orig/drivers/net/wireless/airo.c
+++ linux-next-20100212/drivers/net/wireless/airo.c
@@ -51,6 +51,7 @@
 #include <linux/freezer.h>
 
 #include <linux/ieee80211.h>
+#include <net/iw_handler.h>
 
 #include "airo.h"
 
--- linux-next-20100212.orig/drivers/net/wireless/Kconfig
+++ linux-next-20100212/drivers/net/wireless/Kconfig
@@ -112,6 +112,7 @@ config AIRO_CS
 	depends on PCMCIA && (BROKEN || !M32R)
 	select WIRELESS_EXT
 	select WEXT_SPY
+	select WEXT_PRIV
 	select CRYPTO
 	select CRYPTO_AES
 	---help---
