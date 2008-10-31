Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:6268 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbYJaNfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 09:35:30 -0400
Received: by ey-out-2122.google.com with SMTP id 6so437369eyi.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Oct 2008 06:35:27 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: arvidjaar@mail.ru, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH] orinoco: Move sources to a subdirectory
Date: Fri, 31 Oct 2008 13:35:21 +0000
Message-Id: <1225460121-16033-1-git-send-email-kilroyd@googlemail.com> (sfid-20081031_143558_885406_5F8FE2E0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Keeping all the orinoco drivers in a common directory will make
maintenance easier.

Signed-off by: David Kilroy <kilroyd@googlemail.com>
---

Intended for -testing/-next. Please apply after any pending patches that
touch orinoco. I'll take care of rebasing the orinoco pm_notifier RFC as
appropriate.

Part of the rationale behind the move is to allow refactoring of
orinoco.c without further polluting the wireless directory.

---
 drivers/net/wireless/Makefile                      |    9 +--------
 drivers/net/wireless/orinoco/Makefile              |   12 ++++++++++++
 drivers/net/wireless/{ => orinoco}/airport.c       |    0 
 drivers/net/wireless/{ => orinoco}/hermes.c        |    0 
 drivers/net/wireless/{ => orinoco}/hermes.h        |    0 
 drivers/net/wireless/{ => orinoco}/hermes_dld.c    |    0 
 drivers/net/wireless/{ => orinoco}/hermes_dld.h    |    0 
 drivers/net/wireless/{ => orinoco}/hermes_rid.h    |    0 
 drivers/net/wireless/{ => orinoco}/orinoco.c       |    0 
 drivers/net/wireless/{ => orinoco}/orinoco.h       |    0 
 drivers/net/wireless/{ => orinoco}/orinoco_cs.c    |    0 
 .../net/wireless/{ => orinoco}/orinoco_nortel.c    |    0 
 drivers/net/wireless/{ => orinoco}/orinoco_pci.c   |    0 
 drivers/net/wireless/{ => orinoco}/orinoco_pci.h   |    0 
 drivers/net/wireless/{ => orinoco}/orinoco_plx.c   |    0 
 drivers/net/wireless/{ => orinoco}/orinoco_tmd.c   |    0 
 drivers/net/wireless/{ => orinoco}/spectrum_cs.c   |    0 
 17 files changed, 13 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/wireless/orinoco/Makefile
 rename drivers/net/wireless/{ => orinoco}/airport.c (100%)
 rename drivers/net/wireless/{ => orinoco}/hermes.c (100%)
 rename drivers/net/wireless/{ => orinoco}/hermes.h (100%)
 rename drivers/net/wireless/{ => orinoco}/hermes_dld.c (100%)
 rename drivers/net/wireless/{ => orinoco}/hermes_dld.h (100%)
 rename drivers/net/wireless/{ => orinoco}/hermes_rid.h (100%)
 rename drivers/net/wireless/{ => orinoco}/orinoco.c (100%)
 rename drivers/net/wireless/{ => orinoco}/orinoco.h (100%)
 rename drivers/net/wireless/{ => orinoco}/orinoco_cs.c (100%)
 rename drivers/net/wireless/{ => orinoco}/orinoco_nortel.c (100%)
 rename drivers/net/wireless/{ => orinoco}/orinoco_pci.c (100%)
 rename drivers/net/wireless/{ => orinoco}/orinoco_pci.h (100%)
 rename drivers/net/wireless/{ => orinoco}/orinoco_plx.c (100%)
 rename drivers/net/wireless/{ => orinoco}/orinoco_tmd.c (100%)
 rename drivers/net/wireless/{ => orinoco}/spectrum_cs.c (100%)

diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 59d2d80..7882084 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -16,14 +16,7 @@ obj-$(CONFIG_WAVELAN)		+= wavelan.o
 obj-$(CONFIG_PCMCIA_NETWAVE)	+= netwave_cs.o
 obj-$(CONFIG_PCMCIA_WAVELAN)	+= wavelan_cs.o
 
-obj-$(CONFIG_HERMES)		+= orinoco.o hermes.o hermes_dld.o
-obj-$(CONFIG_PCMCIA_HERMES)	+= orinoco_cs.o
-obj-$(CONFIG_APPLE_AIRPORT)	+= airport.o
-obj-$(CONFIG_PLX_HERMES)	+= orinoco_plx.o
-obj-$(CONFIG_PCI_HERMES)	+= orinoco_pci.o
-obj-$(CONFIG_TMD_HERMES)	+= orinoco_tmd.o
-obj-$(CONFIG_NORTEL_HERMES)	+= orinoco_nortel.o
-obj-$(CONFIG_PCMCIA_SPECTRUM)	+= spectrum_cs.o
+obj-$(CONFIG_HERMES)		+= orinoco/
 
 obj-$(CONFIG_AIRO)		+= airo.o
 obj-$(CONFIG_AIRO_CS)		+= airo_cs.o airo.o
diff --git a/drivers/net/wireless/orinoco/Makefile b/drivers/net/wireless/orinoco/Makefile
new file mode 100644
index 0000000..791366e
--- /dev/null
+++ b/drivers/net/wireless/orinoco/Makefile
@@ -0,0 +1,12 @@
+#
+# Makefile for the orinoco wireless device drivers.
+#
+
+obj-$(CONFIG_HERMES)		+= orinoco.o hermes.o hermes_dld.o
+obj-$(CONFIG_PCMCIA_HERMES)	+= orinoco_cs.o
+obj-$(CONFIG_APPLE_AIRPORT)	+= airport.o
+obj-$(CONFIG_PLX_HERMES)	+= orinoco_plx.o
+obj-$(CONFIG_PCI_HERMES)	+= orinoco_pci.o
+obj-$(CONFIG_TMD_HERMES)	+= orinoco_tmd.o
+obj-$(CONFIG_NORTEL_HERMES)	+= orinoco_nortel.o
+obj-$(CONFIG_PCMCIA_SPECTRUM)	+= spectrum_cs.o
diff --git a/drivers/net/wireless/airport.c b/drivers/net/wireless/orinoco/airport.c
similarity index 100%
rename from drivers/net/wireless/airport.c
rename to drivers/net/wireless/orinoco/airport.c
diff --git a/drivers/net/wireless/hermes.c b/drivers/net/wireless/orinoco/hermes.c
similarity index 100%
rename from drivers/net/wireless/hermes.c
rename to drivers/net/wireless/orinoco/hermes.c
diff --git a/drivers/net/wireless/hermes.h b/drivers/net/wireless/orinoco/hermes.h
similarity index 100%
rename from drivers/net/wireless/hermes.h
rename to drivers/net/wireless/orinoco/hermes.h
diff --git a/drivers/net/wireless/hermes_dld.c b/drivers/net/wireless/orinoco/hermes_dld.c
similarity index 100%
rename from drivers/net/wireless/hermes_dld.c
rename to drivers/net/wireless/orinoco/hermes_dld.c
diff --git a/drivers/net/wireless/hermes_dld.h b/drivers/net/wireless/orinoco/hermes_dld.h
similarity index 100%
rename from drivers/net/wireless/hermes_dld.h
rename to drivers/net/wireless/orinoco/hermes_dld.h
diff --git a/drivers/net/wireless/hermes_rid.h b/drivers/net/wireless/orinoco/hermes_rid.h
similarity index 100%
rename from drivers/net/wireless/hermes_rid.h
rename to drivers/net/wireless/orinoco/hermes_rid.h
diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco/orinoco.c
similarity index 100%
rename from drivers/net/wireless/orinoco.c
rename to drivers/net/wireless/orinoco/orinoco.c
diff --git a/drivers/net/wireless/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
similarity index 100%
rename from drivers/net/wireless/orinoco.h
rename to drivers/net/wireless/orinoco/orinoco.h
diff --git a/drivers/net/wireless/orinoco_cs.c b/drivers/net/wireless/orinoco/orinoco_cs.c
similarity index 100%
rename from drivers/net/wireless/orinoco_cs.c
rename to drivers/net/wireless/orinoco/orinoco_cs.c
diff --git a/drivers/net/wireless/orinoco_nortel.c b/drivers/net/wireless/orinoco/orinoco_nortel.c
similarity index 100%
rename from drivers/net/wireless/orinoco_nortel.c
rename to drivers/net/wireless/orinoco/orinoco_nortel.c
diff --git a/drivers/net/wireless/orinoco_pci.c b/drivers/net/wireless/orinoco/orinoco_pci.c
similarity index 100%
rename from drivers/net/wireless/orinoco_pci.c
rename to drivers/net/wireless/orinoco/orinoco_pci.c
diff --git a/drivers/net/wireless/orinoco_pci.h b/drivers/net/wireless/orinoco/orinoco_pci.h
similarity index 100%
rename from drivers/net/wireless/orinoco_pci.h
rename to drivers/net/wireless/orinoco/orinoco_pci.h
diff --git a/drivers/net/wireless/orinoco_plx.c b/drivers/net/wireless/orinoco/orinoco_plx.c
similarity index 100%
rename from drivers/net/wireless/orinoco_plx.c
rename to drivers/net/wireless/orinoco/orinoco_plx.c
diff --git a/drivers/net/wireless/orinoco_tmd.c b/drivers/net/wireless/orinoco/orinoco_tmd.c
similarity index 100%
rename from drivers/net/wireless/orinoco_tmd.c
rename to drivers/net/wireless/orinoco/orinoco_tmd.c
diff --git a/drivers/net/wireless/spectrum_cs.c b/drivers/net/wireless/orinoco/spectrum_cs.c
similarity index 100%
rename from drivers/net/wireless/spectrum_cs.c
rename to drivers/net/wireless/orinoco/spectrum_cs.c
-- 
1.5.6.4

