Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:43284 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbZBCUmI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 15:42:08 -0500
Received: by mail-ew0-f21.google.com with SMTP id 14so2846565ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 12:42:07 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 07/17] orinoco: Rename orinoco.c
Date: Tue,  3 Feb 2009 20:40:29 +0000
Message-Id: <1233693639-8608-8-git-send-email-kilroyd@googlemail.com> (sfid-20090203_214212_411958_F8F40446)
In-Reply-To: <1233693639-8608-7-git-send-email-kilroyd@googlemail.com>
References: <1233693639-8608-1-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-2-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-3-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-4-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-5-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-6-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-7-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So that we can split up the file and still produce a module named
orinoco.o.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/Makefile              |    1 +
 drivers/net/wireless/orinoco/airport.c             |    2 +-
 drivers/net/wireless/orinoco/{orinoco.c => main.c} |    2 +-
 drivers/net/wireless/orinoco/orinoco_cs.c          |    2 +-
 drivers/net/wireless/orinoco/orinoco_pci.h         |    2 +-
 drivers/net/wireless/orinoco/orinoco_tmd.c         |    2 +-
 drivers/net/wireless/orinoco/spectrum_cs.c         |    4 ++--
 7 files changed, 8 insertions(+), 7 deletions(-)
 rename drivers/net/wireless/orinoco/{orinoco.c => main.c} (99%)

diff --git a/drivers/net/wireless/orinoco/Makefile b/drivers/net/wireless/orinoco/Makefile
index 791366e..d2ac785 100644
--- a/drivers/net/wireless/orinoco/Makefile
+++ b/drivers/net/wireless/orinoco/Makefile
@@ -1,6 +1,7 @@
 #
 # Makefile for the orinoco wireless device drivers.
 #
+orinoco-objs := main.o
 
 obj-$(CONFIG_HERMES)		+= orinoco.o hermes.o hermes_dld.o
 obj-$(CONFIG_PCMCIA_HERMES)	+= orinoco_cs.o
diff --git a/drivers/net/wireless/orinoco/airport.c b/drivers/net/wireless/orinoco/airport.c
index 5582dca..8c4065f 100644
--- a/drivers/net/wireless/orinoco/airport.c
+++ b/drivers/net/wireless/orinoco/airport.c
@@ -3,7 +3,7 @@
  * A driver for "Hermes" chipset based Apple Airport wireless
  * card.
  *
- * Copyright notice & release notes in file orinoco.c
+ * Copyright notice & release notes in file main.c
  *
  * Note specific to airport stub:
  *
diff --git a/drivers/net/wireless/orinoco/orinoco.c b/drivers/net/wireless/orinoco/main.c
similarity index 99%
rename from drivers/net/wireless/orinoco/orinoco.c
rename to drivers/net/wireless/orinoco/main.c
index f6f93cd..d772e53 100644
--- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -1,4 +1,4 @@
-/* orinoco.c - (formerly known as dldwd_cs.c and orinoco_cs.c)
+/* main.c - (formerly known as dldwd_cs.c, orinoco_cs.c and orinoco.c)
  *
  * A driver for Hermes or Prism 2 chipset based PCMCIA wireless
  * adaptors, with Lucent/Agere, Intersil or Symbol firmware.
diff --git a/drivers/net/wireless/orinoco/orinoco_cs.c b/drivers/net/wireless/orinoco/orinoco_cs.c
index a3e82fd..b9bbd1e 100644
--- a/drivers/net/wireless/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco/orinoco_cs.c
@@ -7,7 +7,7 @@
  * Linksys, D-Link and Farallon Skyline. It should also work on Symbol
  * cards such as the 3Com AirConnect and Ericsson WLAN.
  *
- * Copyright notice & release notes in file orinoco.c
+ * Copyright notice & release notes in file main.c
  */
 
 #define DRIVER_NAME "orinoco_cs"
diff --git a/drivers/net/wireless/orinoco/orinoco_pci.h b/drivers/net/wireless/orinoco/orinoco_pci.h
index 88df3ee..c655b4a 100644
--- a/drivers/net/wireless/orinoco/orinoco_pci.h
+++ b/drivers/net/wireless/orinoco/orinoco_pci.h
@@ -4,7 +4,7 @@
  * both native PCI and PCMCIA-to-PCI bridges.
  *
  * Copyright (C) 2005, Pavel Roskin.
- * See orinoco.c for license.
+ * See main.c for license.
  */
 
 #ifndef _ORINOCO_PCI_H
diff --git a/drivers/net/wireless/orinoco/orinoco_tmd.c b/drivers/net/wireless/orinoco/orinoco_tmd.c
index e77c404..cda0e6e 100644
--- a/drivers/net/wireless/orinoco/orinoco_tmd.c
+++ b/drivers/net/wireless/orinoco/orinoco_tmd.c
@@ -27,7 +27,7 @@
  * provisions above, a recipient may use your version of this file
  * under either the MPL or the GPL.
  *
- * The actual driving is done by orinoco.c, this is just resource
+ * The actual driving is done by main.c, this is just resource
  * allocation stuff.
  *
  * This driver is modeled after the orinoco_plx driver. The main
diff --git a/drivers/net/wireless/orinoco/spectrum_cs.c b/drivers/net/wireless/orinoco/spectrum_cs.c
index 9aefe19..38e5198 100644
--- a/drivers/net/wireless/orinoco/spectrum_cs.c
+++ b/drivers/net/wireless/orinoco/spectrum_cs.c
@@ -4,7 +4,7 @@
  * Communications and Intel PRO/Wireless 2011B.
  *
  * The driver implements Symbol firmware download.  The rest is handled
- * in hermes.c and orinoco.c.
+ * in hermes.c and main.c.
  *
  * Utilities for downloading the Symbol firmware are available at
  * http://sourceforge.net/projects/orinoco/
@@ -15,7 +15,7 @@
  * Portions based on Spectrum24tDnld.c from original spectrum24 driver:
  * 	Copyright (C) Symbol Technologies.
  *
- * See copyright notice in file orinoco.c.
+ * See copyright notice in file main.c.
  */
 
 #define DRIVER_NAME "spectrum_cs"
-- 
1.6.0.6

