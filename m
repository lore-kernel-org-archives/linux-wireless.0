Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:46256 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbZBDXHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:07:15 -0500
Received: by mail-ew0-f21.google.com with SMTP id 14so4024043ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 15:07:14 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH v2 16/16] orinoco: hermes doesn't need to be a separate module
Date: Wed,  4 Feb 2009 23:05:58 +0000
Message-Id: <1233788758-9850-17-git-send-email-kilroyd@googlemail.com> (sfid-20090205_000726_071275_B115B120)
In-Reply-To: <1233788758-9850-16-git-send-email-kilroyd@googlemail.com>
References: <1233788758-9850-1-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-2-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-3-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-4-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-5-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-6-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-7-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-8-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-9-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-10-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-11-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-12-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-13-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-14-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-15-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-16-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just compile it into the orinoco module. If we merge USB support, the
module can then be split as appropriate.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/Makefile |    4 ++--
 drivers/net/wireless/orinoco/hermes.c |   18 ------------------
 2 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/orinoco/Makefile b/drivers/net/wireless/orinoco/Makefile
index 2f3e0dd..1fc7409 100644
--- a/drivers/net/wireless/orinoco/Makefile
+++ b/drivers/net/wireless/orinoco/Makefile
@@ -1,9 +1,9 @@
 #
 # Makefile for the orinoco wireless device drivers.
 #
-orinoco-objs := main.o fw.o hw.o mic.o scan.o wext.o hermes_dld.o
+orinoco-objs := main.o fw.o hw.o mic.o scan.o wext.o hermes_dld.o hermes.o
 
-obj-$(CONFIG_HERMES)		+= orinoco.o hermes.o
+obj-$(CONFIG_HERMES)		+= orinoco.o
 obj-$(CONFIG_PCMCIA_HERMES)	+= orinoco_cs.o
 obj-$(CONFIG_APPLE_AIRPORT)	+= airport.o
 obj-$(CONFIG_PLX_HERMES)	+= orinoco_plx.o
diff --git a/drivers/net/wireless/orinoco/hermes.c b/drivers/net/wireless/orinoco/hermes.c
index f48358f..f2c918c 100644
--- a/drivers/net/wireless/orinoco/hermes.c
+++ b/drivers/net/wireless/orinoco/hermes.c
@@ -45,12 +45,6 @@
 
 #include "hermes.h"
 
-MODULE_DESCRIPTION("Low-level driver helper for Lucent Hermes chipset"
-		   " and Prism II HFA384x wireless MAC controller");
-MODULE_AUTHOR("Pavel Roskin <proski@gnu.org>"
-	" & David Gibson <hermes@gibson.dropbear.id.au>");
-MODULE_LICENSE("Dual MPL/GPL");
-
 /* These are maximum timeouts. Most often, card wil react much faster */
 #define CMD_BUSY_TIMEOUT (100) /* In iterations of ~1us */
 #define CMD_INIT_TIMEOUT (50000) /* in iterations of ~10us */
@@ -540,15 +534,3 @@ int hermes_write_ltv(hermes_t *hw, int bap, u16 rid,
 	return err;
 }
 EXPORT_SYMBOL(hermes_write_ltv);
-
-static int __init init_hermes(void)
-{
-	return 0;
-}
-
-static void __exit exit_hermes(void)
-{
-}
-
-module_init(init_hermes);
-module_exit(exit_hermes);
-- 
1.6.0.6

