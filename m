Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:46966 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbZBDXHL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:07:11 -0500
Received: by fg-out-1718.google.com with SMTP id 16so1379710fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 15:07:09 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH v2 15/16] orinoco: hermes_dld does not need to be a module
Date: Wed,  4 Feb 2009 23:05:57 +0000
Message-Id: <1233788758-9850-16-git-send-email-kilroyd@googlemail.com> (sfid-20090205_000724_927685_0B1AEC04)
In-Reply-To: <1233788758-9850-15-git-send-email-kilroyd@googlemail.com>
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/Makefile     |    4 +-
 drivers/net/wireless/orinoco/hermes_dld.c |   33 +---------------------------
 2 files changed, 4 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/orinoco/Makefile b/drivers/net/wireless/orinoco/Makefile
index 431ba39..2f3e0dd 100644
--- a/drivers/net/wireless/orinoco/Makefile
+++ b/drivers/net/wireless/orinoco/Makefile
@@ -1,9 +1,9 @@
 #
 # Makefile for the orinoco wireless device drivers.
 #
-orinoco-objs := main.o fw.o hw.o mic.o scan.o wext.o
+orinoco-objs := main.o fw.o hw.o mic.o scan.o wext.o hermes_dld.o
 
-obj-$(CONFIG_HERMES)		+= orinoco.o hermes.o hermes_dld.o
+obj-$(CONFIG_HERMES)		+= orinoco.o hermes.o
 obj-$(CONFIG_PCMCIA_HERMES)	+= orinoco_cs.o
 obj-$(CONFIG_APPLE_AIRPORT)	+= airport.o
 obj-$(CONFIG_PLX_HERMES)	+= orinoco_plx.o
diff --git a/drivers/net/wireless/orinoco/hermes_dld.c b/drivers/net/wireless/orinoco/hermes_dld.c
index 45aed14..5260ceb 100644
--- a/drivers/net/wireless/orinoco/hermes_dld.c
+++ b/drivers/net/wireless/orinoco/hermes_dld.c
@@ -1,13 +1,7 @@
 /*
- * Hermes download helper driver.
+ * Hermes download helper.
  *
- * This could be entirely merged into hermes.c.
- *
- * I'm keeping it separate to minimise the amount of merging between
- * kernel upgrades. It also means the memory overhead for drivers that
- * don't need firmware download low.
- *
- * This driver:
+ * This helper:
  *  - is capable of writing to the volatile area of the hermes device
  *  - is currently not capable of writing to non-volatile areas
  *  - provide helpers to identify and update plugin data
@@ -50,10 +44,6 @@
 #include "hermes.h"
 #include "hermes_dld.h"
 
-MODULE_DESCRIPTION("Download helper for Lucent Hermes chipset");
-MODULE_AUTHOR("David Kilroy <kilroyd@gmail.com>");
-MODULE_LICENSE("Dual MPL/GPL");
-
 #define PFX "hermes_dld: "
 
 /*
@@ -347,7 +337,6 @@ int hermes_read_pda(hermes_t *hw,
 
 	return 0;
 }
-EXPORT_SYMBOL(hermes_read_pda);
 
 /* Parse PDA and write the records into the adapter
  *
@@ -376,7 +365,6 @@ int hermes_apply_pda(hermes_t *hw,
 	}
 	return 0;
 }
-EXPORT_SYMBOL(hermes_apply_pda);
 
 /* Identify the total number of bytes in all blocks
  * including the header data.
@@ -398,7 +386,6 @@ hermes_blocks_length(const char *first_block)
 
 	return total_len;
 }
-EXPORT_SYMBOL(hermes_blocks_length);
 
 /*** Hermes programming ***/
 
@@ -452,7 +439,6 @@ int hermesi_program_init(hermes_t *hw, u32 offset)
 
 	return err;
 }
-EXPORT_SYMBOL(hermesi_program_init);
 
 /* Done programming data (Hermes I)
  *
@@ -488,7 +474,6 @@ int hermesi_program_end(hermes_t *hw)
 
 	return rc ? rc : err;
 }
-EXPORT_SYMBOL(hermesi_program_end);
 
 /* Program the data blocks */
 int hermes_program(hermes_t *hw, const char *first_block, const char *end)
@@ -550,19 +535,6 @@ int hermes_program(hermes_t *hw, const char *first_block, const char *end)
 	}
 	return 0;
 }
-EXPORT_SYMBOL(hermes_program);
-
-static int __init init_hermes_dld(void)
-{
-	return 0;
-}
-
-static void __exit exit_hermes_dld(void)
-{
-}
-
-module_init(init_hermes_dld);
-module_exit(exit_hermes_dld);
 
 /*** Default plugging data for Hermes I ***/
 /* Values from wl_lkm_718/hcf/dhf.c */
@@ -727,4 +699,3 @@ int hermes_apply_pda_with_defaults(hermes_t *hw,
 	}
 	return 0;
 }
-EXPORT_SYMBOL(hermes_apply_pda_with_defaults);
-- 
1.6.0.6

