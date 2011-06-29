Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2003 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758037Ab1F2Xsy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:54 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 019/119] staging: brcm80211: get rid on
 IS_CFG80211_FAVORITE macro
Date: Wed, 29 Jun 2011 16:46:43 -0700
Message-ID: <1309391303-22741-20-git-send-email-frankyl@broadcom.com> (sfid-20110630_015115_472160_3CA25FA5)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

cfg80211 module is always favorite for the brcmfmac driver so the
macro is not needed to know the answer.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c |  108 +++++------------------
 1 files changed, 24 insertions(+), 84 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index d09706b..386955e 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -262,6 +262,10 @@ char nvram_path[MOD_PARAM_PATHLEN];
 module_param_string(firmware_path, firmware_path, MOD_PARAM_PATHLEN, 0);
 module_param_string(nvram_path, nvram_path, MOD_PARAM_PATHLEN, 0);
 
+/* No firmware required */
+bool dhd_no_fw_req;
+module_param(dhd_no_fw_req, bool, 0);
+
 /* Error bits */
 module_param(dhd_msg_level, int, 0);
 
@@ -339,10 +343,6 @@ module_param(dhd_idletime, int, 0);
 uint dhd_poll;
 module_param(dhd_poll, uint, 0);
 
-/* Use cfg80211 */
-uint dhd_cfg80211 = true;
-module_param(dhd_cfg80211, uint, 0);
-
 /* Use interrupts */
 uint dhd_intr = true;
 module_param(dhd_intr, uint, 0);
@@ -371,11 +371,6 @@ uint dhd_pktgen_len;
 module_param(dhd_pktgen_len, uint, 0);
 #endif
 
-#define FAVORITE_WIFI_CP	(!!dhd_cfg80211)
-#define IS_CFG80211_FAVORITE() FAVORITE_WIFI_CP
-#define DBG_CFG80211_GET() ((dhd_cfg80211 & WL_DBG_MASK) >> 1)
-#define NO_FW_REQ() (dhd_cfg80211 & 0x80)
-
 /* Version string to report */
 #ifdef DHD_DEBUG
 #define DHD_COMPILED "\nCompiled in " SRCBASE
@@ -398,32 +393,6 @@ static int dhd_toe_set(dhd_info_t *dhd, int idx, u32 toe_ol);
 static int dhd_wl_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
 			     wl_event_msg_t *event_ptr, void **data_ptr);
 
-#if defined(CONFIG_PM_SLEEP)
-static int dhd_sleep_pm_callback(struct notifier_block *nfb,
-				 unsigned long action, void *ignored)
-{
-	switch (action) {
-	case PM_HIBERNATION_PREPARE:
-	case PM_SUSPEND_PREPARE:
-		atomic_set(&dhd_mmc_suspend, true);
-		return NOTIFY_OK;
-	case PM_POST_HIBERNATION:
-	case PM_POST_SUSPEND:
-		atomic_set(&dhd_mmc_suspend, false);
-		return NOTIFY_OK;
-	}
-	return 0;
-}
-
-static struct notifier_block dhd_sleep_pm_notifier = {
-	.notifier_call = dhd_sleep_pm_callback,
-	.priority = 0
-};
-
-extern int register_pm_notifier(struct notifier_block *nb);
-extern int unregister_pm_notifier(struct notifier_block *nb);
-#endif	/* defined(CONFIG_PM_SLEEP) */
-	/* && defined(DHD_GPL) */
 static void dhd_set_packet_filter(int value, dhd_pub_t *dhd)
 {
 #ifdef PKT_FILTER_SUPPORT
@@ -1740,9 +1709,7 @@ static int dhd_stop(struct net_device *net)
 	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(net);
 
 	DHD_TRACE(("%s: Enter\n", __func__));
-	if (IS_CFG80211_FAVORITE()) {
-		wl_cfg80211_down();
-	}
+	wl_cfg80211_down();
 	if (dhd->pub.up == 0)
 		return 0;
 
@@ -1792,12 +1759,10 @@ static int dhd_open(struct net_device *net)
 	/* Allow transmit calls */
 	netif_start_queue(net);
 	dhd->pub.up = 1;
-	if (IS_CFG80211_FAVORITE()) {
-		if (unlikely(wl_cfg80211_up())) {
-			DHD_ERROR(("%s: failed to bring up cfg80211\n",
-				   __func__));
-			return -1;
-		}
+	if (unlikely(wl_cfg80211_up())) {
+		DHD_ERROR(("%s: failed to bring up cfg80211\n",
+			   __func__));
+		return -1;
 	}
 
 	return ret;
@@ -1937,15 +1902,13 @@ dhd_pub_t *dhd_attach(struct dhd_bus *bus, uint bus_hdrlen)
 #endif	/* defined(CONFIG_WIRELESS_EXT) */
 
 	/* Attach and link in the cfg80211 */
-	if (IS_CFG80211_FAVORITE()) {
-		if (unlikely(wl_cfg80211_attach(net, &dhd->pub))) {
-			DHD_ERROR(("wl_cfg80211_attach failed\n"));
-			goto fail;
-		}
-		if (!NO_FW_REQ()) {
-			strcpy(fw_path, wl_cfg80211_get_fwname());
-			strcpy(nv_path, wl_cfg80211_get_nvramname());
-		}
+	if (unlikely(wl_cfg80211_attach(net, &dhd->pub))) {
+		DHD_ERROR(("wl_cfg80211_attach failed\n"));
+		goto fail;
+	}
+	if (!dhd_no_fw_req) {
+		strcpy(fw_path, wl_cfg80211_get_fwname());
+		strcpy(nv_path, wl_cfg80211_get_nvramname());
 	}
 
 	/* Set up the watchdog timer */
@@ -2011,8 +1974,6 @@ dhd_pub_t *dhd_attach(struct dhd_bus *bus, uint bus_hdrlen)
 #endif
 #if defined(CONFIG_PM_SLEEP)
 	atomic_set(&dhd_mmc_suspend, false);
-	if (!IS_CFG80211_FAVORITE())
-		register_pm_notifier(&dhd_sleep_pm_notifier);
 #endif	/* defined(CONFIG_PM_SLEEP) */
 	/* && defined(DHD_GPL) */
 	/* Init lock suspend to prevent kernel going to suspend */
@@ -2302,13 +2263,8 @@ void dhd_detach(dhd_pub_t *dhdp)
 			wl_iw_detach();
 #endif				/* (CONFIG_WIRELESS_EXT) */
 
-			if (IS_CFG80211_FAVORITE())
-				wl_cfg80211_detach();
+			wl_cfg80211_detach();
 
-#if defined(CONFIG_PM_SLEEP)
-			if (!IS_CFG80211_FAVORITE())
-				unregister_pm_notifier(&dhd_sleep_pm_notifier);
-#endif	/* defined(CONFIG_PM_SLEEP) */
 			/* && defined(DHD_GPL) */
 			free_netdev(ifp->net);
 			kfree(ifp);
@@ -2509,7 +2465,7 @@ void *dhd_os_open_image(char *filename)
 {
 	struct file *fp;
 
-	if (IS_CFG80211_FAVORITE() && !NO_FW_REQ())
+	if (!dhd_no_fw_req)
 		return wl_cfg80211_request_fw(filename);
 
 	fp = filp_open(filename, O_RDONLY, 0);
@@ -2530,7 +2486,7 @@ int dhd_os_get_image_block(char *buf, int len, void *image)
 	struct file *fp = (struct file *)image;
 	int rdlen;
 
-	if (IS_CFG80211_FAVORITE() && !NO_FW_REQ())
+	if (!dhd_no_fw_req)
 		return wl_cfg80211_read_fw(buf, len);
 
 	if (!image)
@@ -2545,7 +2501,7 @@ int dhd_os_get_image_block(char *buf, int len, void *image)
 
 void dhd_os_close_image(void *image)
 {
-	if (IS_CFG80211_FAVORITE() && !NO_FW_REQ())
+	if (!dhd_no_fw_req)
 		return wl_cfg80211_release_fw();
 	if (image)
 		filp_close((struct file *)image, NULL);
@@ -2587,26 +2543,10 @@ dhd_wl_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
 	if (bcmerror != 0)
 		return bcmerror;
 
-#if defined(CONFIG_WIRELESS_EXT)
-	if (!IS_CFG80211_FAVORITE()) {
-		if ((dhd->iflist[*ifidx] == NULL)
-		    || (dhd->iflist[*ifidx]->net == NULL)) {
-			DHD_ERROR(("%s Exit null pointer\n", __func__));
-			return bcmerror;
-		}
-
-		if (dhd->iflist[*ifidx]->net)
-			wl_iw_event(dhd->iflist[*ifidx]->net, event, *data);
-	}
-#endif				/* defined(CONFIG_WIRELESS_EXT)  */
-
-	if (IS_CFG80211_FAVORITE()) {
-		ASSERT(dhd->iflist[*ifidx] != NULL);
-		ASSERT(dhd->iflist[*ifidx]->net != NULL);
-		if (dhd->iflist[*ifidx]->net)
-			wl_cfg80211_event(dhd->iflist[*ifidx]->net, event,
-					  *data);
-	}
+	ASSERT(dhd->iflist[*ifidx] != NULL);
+	ASSERT(dhd->iflist[*ifidx]->net != NULL);
+	if (dhd->iflist[*ifidx]->net)
+		wl_cfg80211_event(dhd->iflist[*ifidx]->net, event, *data);
 
 	return bcmerror;
 }
-- 
1.7.1


