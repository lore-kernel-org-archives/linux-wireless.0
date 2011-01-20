Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36413 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab1ATGRE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 01:17:04 -0500
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
	"Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 1/3]staging: brcm80211 dhd.h Remove CONFIG_HAS_WAKELOCK
Date: Wed, 19 Jan 2011 22:16:04 -0800
Message-Id: <1295504166-1042-1-git-send-email-justinmattock@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Note:not sure if there is already something like this submitted or not.

The first two patches removes CONFIG_HAS_WAKELOCK since it is no longer in the kernel.
Please let me know, if this is the proper way of doing this and/or more needs
to be done..


Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/brcm80211/brcmfmac/dhd.h |   41 ------------------------------
 1 files changed, 0 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 69c6a02..6a382c8 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -33,9 +33,6 @@
 #include <linux/ethtool.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
-#if defined(CONFIG_HAS_WAKELOCK)
-#include <linux/wakelock.h>
-#endif			/* defined (CONFIG_HAS_WAKELOCK) */
 /* The kernel threading is sdio-specific */
 
 #include <wlioctl.h>
@@ -145,9 +142,6 @@ typedef struct dhd_pub {
 	u8 country_code[WLC_CNTRY_BUF_SZ];
 	char eventmask[WL_EVENTING_MASK_LEN];
 
-#if defined(CONFIG_HAS_WAKELOCK)
-	struct wake_lock wakelock[WAKE_LOCK_MAX];
-#endif		/*  defined (CONFIG_HAS_WAKELOCK) */
 } dhd_pub_t;
 
 #if defined(CONFIG_PM_SLEEP)
@@ -230,41 +224,6 @@ static inline void MUTEX_UNLOCK_WL_SCAN_SET(void)
 {
 }
 
-static inline void WAKE_LOCK_INIT(dhd_pub_t *dhdp, int index, char *y)
-{
-#if defined(CONFIG_HAS_WAKELOCK)
-	wake_lock_init(&dhdp->wakelock[index], WAKE_LOCK_SUSPEND, y);
-#endif	/* defined (CONFIG_HAS_WAKELOCK) */
-}
-
-static inline void WAKE_LOCK(dhd_pub_t *dhdp, int index)
-{
-#if defined(CONFIG_HAS_WAKELOCK)
-	wake_lock(&dhdp->wakelock[index]);
-#endif	/* defined (CONFIG_HAS_WAKELOCK) */
-}
-
-static inline void WAKE_UNLOCK(dhd_pub_t *dhdp, int index)
-{
-#if defined(CONFIG_HAS_WAKELOCK)
-	wake_unlock(&dhdp->wakelock[index]);
-#endif	/* defined (CONFIG_HAS_WAKELOCK) */
-}
-
-static inline void WAKE_LOCK_TIMEOUT(dhd_pub_t *dhdp, int index, long time)
-{
-#if defined(CONFIG_HAS_WAKELOCK)
-	wake_lock_timeout(&dhdp->wakelock[index], time);
-#endif	/* defined (CONFIG_HAS_WAKELOCK) */
-}
-
-static inline void WAKE_LOCK_DESTROY(dhd_pub_t *dhdp, int index)
-{
-#if defined(CONFIG_HAS_WAKELOCK)
-	wake_lock_destroy(&dhdp->wakelock[index]);
-#endif /* defined (CONFIG_HAS_WAKELOCK) */
-}
-
 typedef struct dhd_if_event {
 	u8 ifidx;
 	u8 action;
-- 
1.6.5.GIT

