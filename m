Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1435 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312Ab1GEWDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:21 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/31] staging: brcm80211: removed remains of assert
 mechanism in fullmac
Date: Wed, 6 Jul 2011 00:02:37 +0200
Message-ID: <1309903378-29021-11-git-send-email-arend@broadcom.com> (sfid-20110706_000409_002301_CAB585D4)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h       |    9 ----
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   50 ------------------------
 2 files changed, 0 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 229a702..b4d786f 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -703,7 +703,6 @@ extern uint brcmf_pktgen_len;
 #define BRCMF_MAX_PKTGEN_LEN 1800
 #endif
 
-extern u32 g_assert_type;
 extern const struct bcmevent_name bcmevent_names[];
 extern const int bcmevent_names_size;
 
@@ -815,14 +814,6 @@ extern void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg);
 extern void brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg,
 					     int enable, int master_mode);
 
-#ifdef BCMDBG
-#define ASSERT(exp) \
-	  do { if (!(exp)) osl_assert(#exp, __FILE__, __LINE__); } while (0)
-extern void osl_assert(char *exp, char *file, int line);
-#else
-#define ASSERT(exp)	do {} while (0)
-#endif  /* defined(BCMDBG) */
-
 /* Linux network driver ioctl encoding */
 struct brcmf_c_ioctl {
 	uint cmd;		/* common ioctl definition */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 0ea8084..1a7752d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -41,9 +41,6 @@
 #include "wl_cfg80211.h"
 #include "bcmchip.h"
 
-/* Global ASSERT type flag */
-u32 g_assert_type;
-
 #if defined(CONFIG_PM_SLEEP)
 #include <linux/suspend.h>
 atomic_t brcmf_mmc_suspend;
@@ -1739,50 +1736,3 @@ exit:
 	return ret;
 }
 #endif				/* BCMDBG */
-
-#if defined(BCMDBG)
-void osl_assert(char *exp, char *file, int line)
-{
-	char tempbuf[256];
-	char *basename;
-
-	basename = strrchr(file, '/');
-	/* skip the '/' */
-	if (basename)
-		basename++;
-
-	if (!basename)
-		basename = file;
-
-	snprintf(tempbuf, 256,
-		 "assertion \"%s\" failed: file \"%s\", line %d\n", exp,
-		 basename, line);
-
-	/*
-	 * Print assert message and give it time to
-	 * be written to /var/log/messages
-	 */
-	if (!in_interrupt()) {
-		const int delay = 3;
-		printk(KERN_ERR "%s", tempbuf);
-		printk(KERN_ERR "panic in %d seconds\n", delay);
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(delay * HZ);
-	}
-
-	switch (g_assert_type) {
-	case 0:
-		panic(KERN_ERR "%s", tempbuf);
-		break;
-	case 1:
-		printk(KERN_ERR "%s", tempbuf);
-		BUG();
-		break;
-	case 2:
-		printk(KERN_ERR "%s", tempbuf);
-		break;
-	default:
-		break;
-	}
-}
-#endif				/* defined(BCMDBG) */
-- 
1.7.4.1


