Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3216 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062Ab1EIOd3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 10:33:29 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Henry Ptasinski" <henryp@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 2/9] staging: brcm80211: move files only used by
 brcmsmac into appropriate dir
Date: Mon, 9 May 2011 16:33:03 +0200
Message-ID: <1304951590-2411-3-git-send-email-arend@broadcom.com> (sfid-20110509_163610_085531_38846EB0)
In-Reply-To: <1304951590-2411-1-git-send-email-arend@broadcom.com>
References: <1304951590-2411-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

A number of files in the util subdir are only used by the brcmsmac driver.
Move those files into the brcmsmac subdir instead, and do the necessary
Makefile updates to get the files from the new location.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/Makefile        |    9 ++++-----
 .../staging/brcm80211/{util => brcmsmac}/bcmotp.c  |    0
 .../staging/brcm80211/{util => brcmsmac}/bcmsrom.c |    0
 .../brcm80211/{util => brcmsmac}/bcmsrom_tbl.h     |    0
 .../staging/brcm80211/{util => brcmsmac}/hnddma.c  |    0
 .../staging/brcm80211/{util => brcmsmac}/nicpci.c  |    0
 6 files changed, 4 insertions(+), 5 deletions(-)
 rename drivers/staging/brcm80211/{util => brcmsmac}/bcmotp.c (100%)
 rename drivers/staging/brcm80211/{util => brcmsmac}/bcmsrom.c (100%)
 rename drivers/staging/brcm80211/{util => brcmsmac}/bcmsrom_tbl.h (100%)
 rename drivers/staging/brcm80211/{util => brcmsmac}/hnddma.c (100%)
 rename drivers/staging/brcm80211/{util => brcmsmac}/nicpci.c (100%)

diff --git a/drivers/staging/brcm80211/brcmsmac/Makefile b/drivers/staging/brcm80211/brcmsmac/Makefile
index 2179774..1cd3a1e 100644
--- a/drivers/staging/brcm80211/brcmsmac/Makefile
+++ b/drivers/staging/brcm80211/brcmsmac/Makefile
@@ -25,7 +25,6 @@ ccflags-y :=				\
 	-DBCMNVRAMR				\
 	-Idrivers/staging/brcm80211/brcmsmac \
 	-Idrivers/staging/brcm80211/brcmsmac/phy \
-	-Idrivers/staging/brcm80211/util \
 	-Idrivers/staging/brcm80211/include
 
 BRCMSMAC_OFILES := \
@@ -48,12 +47,12 @@ BRCMSMAC_OFILES := \
 	phy/wlc_phytbl_lcn.o \
 	phy/wlc_phytbl_n.o \
 	phy/wlc_phy_qmath.o \
+	bcmotp.o \
+	bcmsrom.o \
+	hnddma.o \
+	nicpci.o \
 	../util/bcmutils.o \
 	../util/bcmwifi.o \
-	../util/bcmotp.o \
-	../util/bcmsrom.o \
-	../util/hnddma.o \
-	../util/nicpci.o \
 	../util/nvram/nvram_ro.o
 
 MODULEPFX := brcmsmac
diff --git a/drivers/staging/brcm80211/util/bcmotp.c b/drivers/staging/brcm80211/brcmsmac/bcmotp.c
similarity index 100%
rename from drivers/staging/brcm80211/util/bcmotp.c
rename to drivers/staging/brcm80211/brcmsmac/bcmotp.c
diff --git a/drivers/staging/brcm80211/util/bcmsrom.c b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
similarity index 100%
rename from drivers/staging/brcm80211/util/bcmsrom.c
rename to drivers/staging/brcm80211/brcmsmac/bcmsrom.c
diff --git a/drivers/staging/brcm80211/util/bcmsrom_tbl.h b/drivers/staging/brcm80211/brcmsmac/bcmsrom_tbl.h
similarity index 100%
rename from drivers/staging/brcm80211/util/bcmsrom_tbl.h
rename to drivers/staging/brcm80211/brcmsmac/bcmsrom_tbl.h
diff --git a/drivers/staging/brcm80211/util/hnddma.c b/drivers/staging/brcm80211/brcmsmac/hnddma.c
similarity index 100%
rename from drivers/staging/brcm80211/util/hnddma.c
rename to drivers/staging/brcm80211/brcmsmac/hnddma.c
diff --git a/drivers/staging/brcm80211/util/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
similarity index 100%
rename from drivers/staging/brcm80211/util/nicpci.c
rename to drivers/staging/brcm80211/brcmsmac/nicpci.c
-- 
1.7.4.1


