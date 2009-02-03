Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:43284 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbZBCUnL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 15:43:11 -0500
Received: by mail-ew0-f21.google.com with SMTP id 14so2846565ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 12:43:10 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 17/17] orinoco: hermes doesn't need to be a separate module
Date: Tue,  3 Feb 2009 20:40:39 +0000
Message-Id: <1233693639-8608-18-git-send-email-kilroyd@googlemail.com> (sfid-20090203_214315_799670_DE148BAA)
In-Reply-To: <1233693639-8608-17-git-send-email-kilroyd@googlemail.com>
References: <1233693639-8608-1-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-2-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-3-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-4-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-5-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-6-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-7-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-8-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-9-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-10-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-11-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-12-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-13-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-14-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-15-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-16-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-17-git-send-email-kilroyd@googlemail.com>
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
index 3946a40..64be359 100644
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
@@ -542,15 +536,3 @@ int hermes_write_ltv(hermes_t *hw, int bap, u16 rid,
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

