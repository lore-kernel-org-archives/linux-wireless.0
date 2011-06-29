Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4614 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758123Ab1F2XtE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:04 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 075/119] staging: brcm80211: rename EPI_VERSION_STR
 macro
Date: Wed, 29 Jun 2011 16:47:39 -0700
Message-ID: <1309391303-22741-76-git-send-email-frankyl@broadcom.com> (sfid-20110630_015141_150151_37556380)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The fullmac version macro has been renamed and moved to dhd.h to
get rid of having it defined in two separate c source files.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h        |    2 ++
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |    5 ++---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c  |    3 +--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 87c65f1..7e19d80 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -21,6 +21,8 @@
 #ifndef _dhd_h_
 #define _dhd_h_
 
+#define BRCMF_VERSION_STR		"4.218.248.5"
+
 #define	BRCMF_C_IOCTL_SMLEN	256	/* "small" ioctl buffer required */
 #define BRCMF_C_IOCTL_MEDLEN	1536	/* "med" ioctl buffer required */
 #define	BRCMF_C_IOCTL_MAXLEN	8192
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 22739f0..5207fa9 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -36,15 +36,14 @@ int brcmf_msg_level;
 char brcmf_fw_path[MOD_PARAM_PATHLEN];
 char brcmf_nv_path[MOD_PARAM_PATHLEN];
 
-#define EPI_VERSION_STR         "4.218.248.5"
 #define MSGTRACE_VERSION	1
 
 #ifdef BCMDBG
 const char brcmf_version[] =
-"Dongle Host Driver, version " EPI_VERSION_STR "\nCompiled on " __DATE__
+"Dongle Host Driver, version " BRCMF_VERSION_STR "\nCompiled on " __DATE__
 " at " __TIME__;
 #else
-const char brcmf_version[] = "Dongle Host Driver, version " EPI_VERSION_STR;
+const char brcmf_version[] = "Dongle Host Driver, version " BRCMF_VERSION_STR;
 #endif
 
 /* IOVar table */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 5327941..19e09bd 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -43,7 +43,6 @@
 #include "dhd_dbg.h"
 #include "wl_cfg80211.h"
 
-#define EPI_VERSION_STR		"4.218.248.5"
 #define ETH_P_BRCM			0x886c
 
 /* Global ASSERT type flag */
@@ -1278,7 +1277,7 @@ static int brcmf_ethtool(dhd_info_t *dhd, void *uaddr)
 		/* if dhd requested, identify ourselves */
 		if (strcmp(drvname, "?dhd") == 0) {
 			sprintf(info.driver, "dhd");
-			strcpy(info.version, EPI_VERSION_STR);
+			strcpy(info.version, BRCMF_VERSION_STR);
 		}
 
 		/* otherwise, require dongle to be up */
-- 
1.7.1


