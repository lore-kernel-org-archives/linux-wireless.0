Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2953 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343Ab1GEWDM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:12 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/31] staging: brcm80211: removed unused #ifdef
 sections in fullmac
Date: Wed, 6 Jul 2011 00:02:30 +0200
Message-ID: <1309903378-29021-4-git-send-email-arend@broadcom.com> (sfid-20110706_000420_811721_10B2F212)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

CONFIG_MACH_SANDGATE2G, CONFIG_MMC_MSM7X00A,
CONFIG_HAS_EARLYSUSPEND and CONFIG_WIFI_CONTROL_FUNC were never
defined.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c  |  126 -----------------------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c   |    5 -
 drivers/staging/brcm80211/include/brcmu_utils.h |    4 -
 3 files changed, 0 insertions(+), 135 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index f62a3c0..423d5da 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -29,9 +29,6 @@
 #include <linux/fs.h>
 #include <linux/uaccess.h>
 #include <net/cfg80211.h>
-#if defined(CONFIG_HAS_EARLYSUSPEND)
-#include <linux/earlysuspend.h>
-#endif
 #include <defs.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
@@ -90,10 +87,6 @@ struct brcmf_info {
 	bool set_macaddress;
 	u8 macvalue[ETH_ALEN];
 	atomic_t pend_8021x_cnt;
-
-#ifdef CONFIG_HAS_EARLYSUSPEND
-	struct early_suspend early_suspend;
-#endif				/* CONFIG_HAS_EARLYSUSPEND */
 };
 
 /* Error bits */
@@ -180,108 +173,6 @@ static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktd
 			    struct brcmf_event_msg *event_ptr,
 			    void **data_ptr);
 
-#if defined(CONFIG_HAS_EARLYSUSPEND)
-static int brcmf_set_suspend(int value, struct brcmf_pub *drvr)
-{
-	int power_mode = PM_MAX;
-	/* struct wl_pkt_filter_enable       enable_parm; */
-	char iovbuf[32];
-	int bcn_li_dtim = 3;
-
-	DHD_TRACE(("%s: enter, value = %d in_suspend=%d\n",
-		   __func__, value, drvr->in_suspend));
-
-	if (drvr && drvr->up) {
-		if (value && drvr->in_suspend) {
-
-			/* Kernel suspended */
-			DHD_TRACE(("%s: force extra Suspend setting\n",
-				   __func__));
-
-			brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_PM,
-					 (char *)&power_mode,
-					 sizeof(power_mode));
-
-			/* Enable packet filter, only allow unicast
-				 packet to send up */
-			brcmf_set_packet_filter(1, drvr);
-
-			/* if dtim skip setup as default force it
-			 * to wake each third dtim
-			 * for better power saving.
-			 * Note that side effect is chance to miss BC/MC
-			 * packet
-			 */
-			if ((drvr->dtim_skip == 0) || (drvr->dtim_skip == 1))
-				bcn_li_dtim = 3;
-			else
-				bcn_li_dtim = drvr->dtim_skip;
-			brcmu_mkiovar("bcn_li_dtim", (char *)&bcn_li_dtim,
-				    4, iovbuf, sizeof(iovbuf));
-			brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR,
-						  iovbuf, sizeof(iovbuf));
-		} else {
-
-			/* Kernel resumed  */
-			DHD_TRACE(("%s: Remove extra suspend setting\n",
-				   __func__));
-
-			power_mode = PM_FAST;
-			brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_PM,
-						  (char *)&power_mode,
-						  sizeof(power_mode));
-
-			/* disable pkt filter */
-			brcmf_set_packet_filter(0, drvr);
-
-			/* restore pre-suspend setting for dtim_skip */
-			brcmu_mkiovar("bcn_li_dtim", (char *)&drvr->dtim_skip,
-				    4, iovbuf, sizeof(iovbuf));
-
-			brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR,
-						  iovbuf, sizeof(iovbuf));
-		}
-	}
-
-	return 0;
-}
-
-static void brcmf_suspend_resume_helper(struct brcmf_info *drvr_priv, int val)
-{
-	struct brcmf_pub *drvr = &drvr_priv->pub;
-
-	brcmf_os_proto_block(drvr);
-	/* Set flag when early suspend was called */
-	drvr->in_suspend = val;
-	if (!drvr->suspend_disable_flag)
-		brcmf_set_suspend(val, drvr);
-	brcmf_os_proto_unblock(drvr);
-}
-
-static void brcmf_early_suspend(struct early_suspend *h)
-{
-	struct brcmf_info *drvr_priv =
-			container_of(h, struct brcmf_info, early_suspend);
-
-	DHD_TRACE(("%s: enter\n", __func__));
-
-	if (drvr_priv)
-		brcmf_suspend_resume_helper(drvr_priv, 1);
-
-}
-
-static void brcmf_late_resume(struct early_suspend *h)
-{
-	struct brcmf_info *drvr_priv =
-			container_of(h, struct brcmf_info, early_suspend);
-
-	DHD_TRACE(("%s: enter\n", __func__));
-
-	if (drvr_priv)
-		brcmf_suspend_resume_helper(drvr_priv, 0);
-}
-#endif				/* defined(CONFIG_HAS_EARLYSUSPEND) */
-
 /*
  * Generalized timeout mechanism.  Uses spin sleep with exponential
  * back-off until
@@ -1479,20 +1370,9 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 	 */
 	memcpy(netdev_priv(net), &drvr_priv, sizeof(drvr_priv));
 
-#if defined(CUSTOMER_HW2) && defined(CONFIG_WIFI_CONTROL_FUNC)
-	g_bus = bus;
-#endif
 #if defined(CONFIG_PM_SLEEP)
 	atomic_set(&brcmf_mmc_suspend, false);
 #endif	/* defined(CONFIG_PM_SLEEP) */
-	/* Init lock suspend to prevent kernel going to suspend */
-#ifdef CONFIG_HAS_EARLYSUSPEND
-	drvr_priv->early_suspend.level = EARLY_SUSPEND_LEVEL_BLANK_SCREEN + 20;
-	drvr_priv->early_suspend.suspend = brcmf_early_suspend;
-	drvr_priv->early_suspend.resume = brcmf_late_resume;
-	register_early_suspend(&drvr_priv->early_suspend);
-#endif
-
 	return &drvr_priv->pub;
 
 fail:
@@ -1664,12 +1544,6 @@ void brcmf_detach(struct brcmf_pub *drvr)
 			struct brcmf_if *ifp;
 			int i;
 
-#if defined(CONFIG_HAS_EARLYSUSPEND)
-			if (drvr_priv->early_suspend.suspend)
-				unregister_early_suspend(
-					&drvr_priv->early_suspend);
-#endif				/* defined(CONFIG_HAS_EARLYSUSPEND) */
-
 			for (i = 1; i < BRCMF_MAX_IFS; i++)
 				if (drvr_priv->iflist[i])
 					brcmf_del_if(drvr_priv, i);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index c5552f1..4c801e7 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -166,13 +166,8 @@ struct rte_console {
 
 #define TXRETRIES	2	/* # of retries for tx frames */
 
-#if defined(CONFIG_MACH_SANDGATE2G)
-#define BRCMF_RXBOUND	250	/* Default for max rx frames in
-				 one scheduling */
-#else
 #define BRCMF_RXBOUND	50	/* Default for max rx frames in
 				 one scheduling */
-#endif				/* defined(CONFIG_MACH_SANDGATE2G) */
 
 #define BRCMF_TXBOUND	20	/* Default for max tx frames in
 				 one scheduling */
diff --git a/drivers/staging/brcm80211/include/brcmu_utils.h b/drivers/staging/brcm80211/include/brcmu_utils.h
index d0039d7..2d54cc5 100644
--- a/drivers/staging/brcm80211/include/brcmu_utils.h
+++ b/drivers/staging/brcm80211/include/brcmu_utils.h
@@ -205,12 +205,8 @@ extern int brcmu_iovar_lencheck(const struct brcmu_iovar *table, void *arg,
 #define	ISPOWEROF2(x)		((((x)-1)&(x)) == 0)
 
 /* map physical to virtual I/O */
-#if !defined(CONFIG_MMC_MSM7X00A)
 #define REG_MAP(pa, size)       ioremap_nocache((unsigned long)(pa), \
 					(unsigned long)(size))
-#else
-#define REG_MAP(pa, size)       (void *)(0)
-#endif
 
 /* the largest reasonable packet buffer driver uses for ethernet MTU in bytes */
 #define	PKTBUFSZ	2048
-- 
1.7.4.1


