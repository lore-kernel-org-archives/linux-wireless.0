Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1683 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab1HHN7W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:22 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 06/82] staging: brcm80211: removed function
 declaration typedefs from aiutils.h
Date: Mon, 8 Aug 2011 15:57:50 +0200
Message-ID: <1312811946-16713-7-git-send-email-arend@broadcom.com> (sfid-20110808_160236_546755_AFB079C6)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Softmac related code cleanup. Typedefs are undesirable according to the
CodingStyle document.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c |    6 +++---
 drivers/staging/brcm80211/brcmsmac/aiutils.h |   16 ++++++----------
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index a25901e..5a5fc4b 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -1279,9 +1279,9 @@ ai_register_intr_callback(struct si_pub *sih, void *intrsoff_fn,
 
 	sii = SI_INFO(sih);
 	sii->intr_arg = intr_arg;
-	sii->intrsoff_fn = (si_intrsoff_t) intrsoff_fn;
-	sii->intrsrestore_fn = (si_intrsrestore_t) intrsrestore_fn;
-	sii->intrsenabled_fn = (si_intrsenabled_t) intrsenabled_fn;
+	sii->intrsoff_fn = (u32 (*)(void *)) intrsoff_fn;
+	sii->intrsrestore_fn = (void (*) (void *, u32)) intrsrestore_fn;
+	sii->intrsenabled_fn = (bool (*)(void *)) intrsenabled_fn;
 	/* save current core id.  when this function called, the current core
 	 * must be the core which provides driver functions(il, et, wl, etc.)
 	 */
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index e245c27..f881b44 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -425,8 +425,6 @@ struct si_pub {
 #define CCPLL_ENAB(sih)		((sih)->cccaps & CC_CAP_PLL_MASK)
 #endif
 
-typedef void (*gpio_handler_t) (u32 stat, void *arg);
-
 /* External PA enable mask */
 #define GPIO_CTRL_EPA_EN_MASK 0x40
 
@@ -444,14 +442,10 @@ typedef void (*gpio_handler_t) (u32 stat, void *arg);
 #define	IS_SIM(chippkg)	\
 	((chippkg == HDLSIM_PKG_ID) || (chippkg == HWSIM_PKG_ID))
 
-typedef u32(*si_intrsoff_t) (void *intr_arg);
-typedef void (*si_intrsrestore_t) (void *intr_arg, u32 arg);
-typedef bool(*si_intrsenabled_t) (void *intr_arg);
-
 struct gpioh_item {
 	void *arg;
 	bool level;
-	gpio_handler_t handler;
+	void (*handler) (u32 stat, void *arg);
 	u32 event;
 	struct gpioh_item *next;
 };
@@ -462,9 +456,11 @@ struct si_info {
 	void *pbus;		/* handle to bus (pci/sdio/..) */
 	uint dev_coreid;	/* the core provides driver functions */
 	void *intr_arg;		/* interrupt callback function arg */
-	si_intrsoff_t intrsoff_fn;	/* turns chip interrupts off */
-	si_intrsrestore_t intrsrestore_fn; /* restore chip interrupts */
-	si_intrsenabled_t intrsenabled_fn; /* check if interrupts are enabled */
+	u32 (*intrsoff_fn) (void *intr_arg); /* turns chip interrupts off */
+	/* restore chip interrupts */
+	void (*intrsrestore_fn) (void *intr_arg, u32 arg);
+	/* check if interrupts are enabled */
+	bool (*intrsenabled_fn) (void *intr_arg);
 
 	void *pch;		/* PCI/E core handle */
 
-- 
1.7.4.1


