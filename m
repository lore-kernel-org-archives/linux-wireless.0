Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1997 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757601Ab1F2Xsm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:42 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 020/119] staging: brcm80211: move assert function to
 dhd_linux.c
Date: Wed, 29 Jun 2011 16:46:44 -0700
Message-ID: <1309391303-22741-21-git-send-email-frankyl@broadcom.com> (sfid-20110630_014907_940795_85D0EF2A)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The source file wl_iw.c is primarily intended to provide wireless
extensions functionality, which is to be removed from the driver.
The assert function is moved to another source file.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |   50 +++++++++++++++++++++++
 drivers/staging/brcm80211/brcmfmac/wl_iw.c     |   51 ------------------------
 2 files changed, 50 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 386955e..e0cd8e1 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -46,6 +46,9 @@
 #define EPI_VERSION_STR		"4.218.248.5"
 #define ETH_P_BRCM			0x886c
 
+/* Global ASSERT type flag */
+u32 g_assert_type;
+
 #if defined(CUSTOMER_HW2) && defined(CONFIG_WIFI_CONTROL_FUNC)
 #include <linux/wifi_tiwlan.h>
 
@@ -2766,3 +2769,50 @@ exit:
 	return ret;
 }
 #endif				/* DHD_DEBUG */
+
+#if defined(BCMDBG)
+void osl_assert(char *exp, char *file, int line)
+{
+	char tempbuf[256];
+	char *basename;
+
+	basename = strrchr(file, '/');
+	/* skip the '/' */
+	if (basename)
+		basename++;
+
+	if (!basename)
+		basename = file;
+
+	snprintf(tempbuf, 256,
+		 "assertion \"%s\" failed: file \"%s\", line %d\n", exp,
+		 basename, line);
+
+	/*
+	 * Print assert message and give it time to
+	 * be written to /var/log/messages
+	 */
+	if (!in_interrupt()) {
+		const int delay = 3;
+		printk(KERN_ERR "%s", tempbuf);
+		printk(KERN_ERR "panic in %d seconds\n", delay);
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule_timeout(delay * HZ);
+	}
+
+	switch (g_assert_type) {
+	case 0:
+		panic(KERN_ERR "%s", tempbuf);
+		break;
+	case 1:
+		printk(KERN_ERR "%s", tempbuf);
+		BUG();
+		break;
+	case 2:
+		printk(KERN_ERR "%s", tempbuf);
+		break;
+	default:
+		break;
+	}
+}
+#endif				/* defined(BCMDBG) */
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index e8b45ae..ef407ec 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -130,9 +130,6 @@ typedef enum sup_auth_status {
 
 static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
 
-/* Global ASSERT type flag */
-u32 g_assert_type;
-
 static void wl_iw_timerfunc(unsigned long data);
 static void wl_iw_set_event_mask(struct net_device *dev);
 static int wl_iw_iscan(iscan_info_t *iscan, wlc_ssid_t *ssid, u16 action);
@@ -3659,53 +3656,5 @@ void wl_iw_detach(void)
 #endif				/* WL_IW_USE_ISCAN */
 
 	kfree(g_scan);
-
 	g_scan = NULL;
 }
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
1.7.1


