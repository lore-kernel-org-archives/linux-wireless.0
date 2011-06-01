Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4840 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161304Ab1FALq1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:27 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 35/83] staging: brcm80211: moved header files to more
 specific directory
Date: Wed, 1 Jun 2011 13:45:20 +0200
Message-ID: <1306928768-7501-35-git-send-email-rvossen@broadcom.com> (sfid-20110601_134656_356797_E98ED3B0)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Header files only used by the softmac were moved to the
brcmsmac dir, same approach for fullmac header files.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |    1 -
 .../brcm80211/{include => brcmfmac}/bcmsdpcm.h     |    0
 .../brcm80211/{include => brcmsmac}/bcmnvram.h     |    0
 .../brcm80211/{include => brcmsmac}/bcmotp.h       |    0
 drivers/staging/brcm80211/brcmsmac/bcmsrom.c       |    3 +++
 drivers/staging/brcm80211/util/bcmutils.c          |    1 -
 6 files changed, 3 insertions(+), 2 deletions(-)
 rename drivers/staging/brcm80211/{include => brcmfmac}/bcmsdpcm.h (100%)
 rename drivers/staging/brcm80211/{include => brcmsmac}/bcmnvram.h (100%)
 rename drivers/staging/brcm80211/{include => brcmsmac}/bcmotp.h (100%)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index e57dd00..d441500 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -24,7 +24,6 @@
 #include <linux/pci.h>
 #include <linux/completion.h>
 
-#include <pcicfg.h>
 #include <bcmdefs.h>
 #include <bcmdevs.h>
 #include <bcmutils.h>
diff --git a/drivers/staging/brcm80211/include/bcmsdpcm.h b/drivers/staging/brcm80211/brcmfmac/bcmsdpcm.h
similarity index 100%
rename from drivers/staging/brcm80211/include/bcmsdpcm.h
rename to drivers/staging/brcm80211/brcmfmac/bcmsdpcm.h
diff --git a/drivers/staging/brcm80211/include/bcmnvram.h b/drivers/staging/brcm80211/brcmsmac/bcmnvram.h
similarity index 100%
rename from drivers/staging/brcm80211/include/bcmnvram.h
rename to drivers/staging/brcm80211/brcmsmac/bcmnvram.h
diff --git a/drivers/staging/brcm80211/include/bcmotp.h b/drivers/staging/brcm80211/brcmsmac/bcmotp.h
similarity index 100%
rename from drivers/staging/brcm80211/include/bcmotp.h
rename to drivers/staging/brcm80211/brcmsmac/bcmotp.h
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
index d374673..311bc0c 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
+++ b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
@@ -362,6 +362,9 @@
 #define SRFL_LEDDC	0x40	/* value is an LED duty cycle */
 #define SRFL_NOVAR	0x80	/* do not generate a nvram param, entry is for mfgc */
 
+/* Max. nvram variable table size */
+#define	MAXSZ_NVRAM_VARS	4096
+
 typedef struct {
 	const char *name;
 	u32 revmask;
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index 63843bc..c23e9b5 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -24,7 +24,6 @@
 #include <bcmdefs.h>
 #include <stdarg.h>
 #include <bcmutils.h>
-#include <bcmnvram.h>
 #include <bcmdevs.h>
 
 MODULE_AUTHOR("Broadcom Corporation");
-- 
1.7.4.1


