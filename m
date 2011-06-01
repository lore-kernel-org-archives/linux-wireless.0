Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4837 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758890Ab1FALqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:51 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 03/83] staging: brcm80211: cleanup struct wl_info
Date: Wed, 1 Jun 2011 13:44:48 +0200
Message-ID: <1306928768-7501-3-git-send-email-rvossen@broadcom.com> (sfid-20110601_134816_409722_9F81DAFA)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

removed unused field piomode from struct wl_info definition.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |    7 ++-----
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.h |    6 +++++-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 3deb903..f951f22 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -739,7 +739,6 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 {
 	struct wl_info *wl = NULL;
 	int unit, err;
-
 	unsigned long base_addr;
 	struct ieee80211_hw *hw;
 	u8 perm[ETH_ALEN];
@@ -768,9 +767,7 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 
 	base_addr = regs;
 
-	if (bustype == PCI_BUS) {
-		wl->piomode = false;
-	} else if (bustype == RPC_BUS) {
+	if (bustype == PCI_BUS || bustype == RPC_BUS) {
 		/* Do nothing */
 	} else {
 		bustype = PCI_BUS;
@@ -796,7 +793,7 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 	}
 
 	/* common load-time initialization */
-	wl->wlc = wlc_attach((void *)wl, vendor, device, unit, wl->piomode,
+	wl->wlc = wlc_attach((void *)wl, vendor, device, unit, false,
 			     wl->regsva, wl->bcm_bustype, btparam, &err);
 	wl_release_fw(wl);
 	if (!wl->wlc) {
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
index e703d8b..c878690 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
@@ -57,11 +57,15 @@ struct wl_info {
 
 	spinlock_t lock;	/* per-device perimeter lock */
 	spinlock_t isr_lock;	/* per-device ISR synchronization lock */
+
+	/* bus type and regsva for unmap in wl_free() */
 	uint bcm_bustype;	/* bus type */
-	bool piomode;		/* set from insmod argument */
 	void *regsva;		/* opaque chip registers virtual address */
+
+	/* timer related fields */
 	atomic_t callbacks;	/* # outstanding callback functions */
 	struct wl_timer *timers;	/* timer cleanup queue */
+
 	struct tasklet_struct tasklet;	/* dpc tasklet */
 	bool resched;		/* dpc needs to be and is rescheduled */
 #ifdef LINUXSTA_PS
-- 
1.7.4.1


