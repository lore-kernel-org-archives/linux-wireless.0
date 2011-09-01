Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4208 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab1IAJRo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:44 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 22/30] staging: brcm80211: remove sparse warnings from
 mac80211_if.c
Date: Thu, 1 Sep 2011 11:17:12 +0200
Message-ID: <1314868640-9425-23-git-send-email-rvossen@broadcom.com> (sfid-20110901_111815_099278_1EF47169)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Some changes have been made to get rid of sparse warnings in the
source file mac80211_if.c.

Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    6 +++---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index bd989737..6ed80b2 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -96,7 +96,7 @@ struct firmware_hdr {
 	u32 idx;
 };
 
-char *brcms_firmwares[MAX_FW_IMAGES] = {
+static const char * const brcms_firmwares[MAX_FW_IMAGES] = {
 	"brcm/bcm43xx",
 	NULL
 };
@@ -1012,7 +1012,7 @@ static void brcms_free(struct brcms_info *wl)
 	 * after calling unregister_netdev() .
 	 */
 	if (wl->regsva)
-		iounmap((void *)wl->regsva);
+		iounmap(wl->regsva);
 
 	wl->regsva = NULL;
 }
@@ -1596,7 +1596,7 @@ struct brcms_timer *brcms_init_timer(struct brcms_info *wl,
 	if (!t) {
 		wiphy_err(wl->wiphy, "wl%d: brcms_init_timer: out of memory\n",
 			  wl->pub->unit);
-		return 0;
+		return NULL;
 	}
 
 	init_timer(&t->timer);
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
index 1d52803..1eb36ed 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
@@ -67,7 +67,7 @@ struct brcms_info {
 	spinlock_t isr_lock;	/* per-device ISR synchronization lock */
 
 	/* regsva for unmap in brcms_free() */
-	void *regsva;		/* opaque chip registers virtual address */
+	void __iomem *regsva;	/* opaque chip registers virtual address */
 
 	/* timer related fields */
 	atomic_t callbacks;	/* # outstanding callback functions */
-- 
1.7.4.1


