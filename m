Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1672 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344Ab2K1Uo1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 15:44:27 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/11] brcmsmac: cleanup in isr code
Date: Wed, 28 Nov 2012 21:44:06 +0100
Message-ID: <1354135454-7035-4-git-send-email-arend@broadcom.com> (sfid-20121128_214434_347072_76050648)
In-Reply-To: <1354135454-7035-1-git-send-email-arend@broadcom.com>
References: <1354135454-7035-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Piotr Haber <phaber@broadcom.com>

brcms_c_isr returns true if interrupt was for us
and if dpc should be scheduled which is the same thing.
Simplify it.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c    |   17 ++++++-----------
 drivers/net/wireless/brcm80211/brcmsmac/main.c       |   18 ++++++------------
 drivers/net/wireless/brcm80211/brcmsmac/pub.h        |    2 +-
 3 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index f917d62..976720c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -896,27 +896,22 @@ static void brcms_remove(struct bcma_device *pdev)
 static irqreturn_t brcms_isr(int irq, void *dev_id)
 {
 	struct brcms_info *wl;
-	bool ours, wantdpc;
+	irqreturn_t ret = IRQ_NONE;
 
 	wl = (struct brcms_info *) dev_id;
 
 	spin_lock(&wl->isr_lock);
 
 	/* call common first level interrupt handler */
-	ours = brcms_c_isr(wl->wlc, &wantdpc);
-	if (ours) {
-		/* if more to do... */
-		if (wantdpc) {
-
-			/* ...and call the second level interrupt handler */
-			/* schedule dpc */
-			tasklet_schedule(&wl->tasklet);
-		}
+	if (brcms_c_isr(wl->wlc)) {
+		/* schedule second level handler */
+		tasklet_schedule(&wl->tasklet);
+		ret = IRQ_HANDLED;
 	}
 
 	spin_unlock(&wl->isr_lock);
 
-	return IRQ_RETVAL(ours);
+	return ret;
 }
 
 /*
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 54ab2f7..054e1da 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -2546,10 +2546,6 @@ static inline u32 wlc_intstatus(struct brcms_c_info *wlc, bool in_isr)
 	if (macintstatus == 0)
 		return 0;
 
-	/* interrupts are already turned off for CFE build
-	 * Caution: For CFE Turning off the interrupts again has some undesired
-	 * consequences
-	 */
 	/* turn off the interrupts */
 	bcma_write32(core, D11REGOFFS(macintmask), 0);
 	(void)bcma_read32(core, D11REGOFFS(macintmask));
@@ -2592,33 +2588,31 @@ bool brcms_c_intrsupd(struct brcms_c_info *wlc)
 
 /*
  * First-level interrupt processing.
- * Return true if this was our interrupt, false otherwise.
- * *wantdpc will be set to true if further brcms_c_dpc() processing is required,
+ * Return true if this was our interrupt
+ * and if further brcms_c_dpc() processing is required,
  * false otherwise.
  */
-bool brcms_c_isr(struct brcms_c_info *wlc, bool *wantdpc)
+bool brcms_c_isr(struct brcms_c_info *wlc)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
 	u32 macintstatus;
 
-	*wantdpc = false;
-
 	if (!wlc_hw->up || !wlc->macintmask)
 		return false;
 
 	/* read and clear macintstatus and intstatus registers */
 	macintstatus = wlc_intstatus(wlc, true);
 
-	if (macintstatus == 0xffffffff)
+	if (macintstatus == 0xffffffff) {
 		brcms_err(wlc_hw->d11core,
 			  "DEVICEREMOVED detected in the ISR code path\n");
+		return false;
+	}
 
 	/* it is not for us */
 	if (macintstatus == 0)
 		return false;
 
-	*wantdpc = true;
-
 	/* save interrupt status bits */
 	wlc->macintstatus = macintstatus;
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 0d7af34..2aafe74 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -282,7 +282,7 @@ extern void brcms_c_intrson(struct brcms_c_info *wlc);
 extern u32 brcms_c_intrsoff(struct brcms_c_info *wlc);
 extern void brcms_c_intrsrestore(struct brcms_c_info *wlc, u32 macintmask);
 extern bool brcms_c_intrsupd(struct brcms_c_info *wlc);
-extern bool brcms_c_isr(struct brcms_c_info *wlc, bool *wantdpc);
+extern bool brcms_c_isr(struct brcms_c_info *wlc);
 extern bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded);
 extern bool brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc,
 				     struct sk_buff *sdu,
-- 
1.7.10.4


