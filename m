Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2013 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756277Ab1I2We6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 18:34:58 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v3 06/25] staging: brcm80211: removed global vars in
 softmac ucode handling
Date: Thu, 29 Sep 2011 15:34:17 -0700
Message-ID: <1317335676-3424-7-git-send-email-frankyl@broadcom.com> (sfid-20110930_003520_573776_3096B902)
In-Reply-To: <1317335676-3424-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
 <1317335676-3424-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Moved global vars into a per-device structure.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c  |    4 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h  |    3 +-
 drivers/staging/brcm80211/brcmsmac/main.c         |   27 ++++--
 drivers/staging/brcm80211/brcmsmac/ucode_loader.c |  121 ++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/ucode_loader.h |   46 +++++----
 5 files changed, 106 insertions(+), 95 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 32d7abf..9bd4b83 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -894,7 +894,7 @@ static int brcms_request_fw(struct brcms_info *wl, struct pci_dev *pdev)
 		    wl->fw.fw_hdr[i]->size / (sizeof(struct firmware_hdr));
 	}
 	wl->fw.fw_cnt = i;
-	return brcms_ucode_data_init(wl);
+	return brcms_ucode_data_init(wl, &wl->ucode);
 }
 
 /*
@@ -925,7 +925,7 @@ static void brcms_free(struct brcms_info *wl)
 
 	/* free ucode data */
 	if (wl->fw.fw_cnt)
-		brcms_ucode_data_free();
+		brcms_ucode_data_free(&wl->ucode);
 	if (wl->irq)
 		free_irq(wl->irq, wl);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
index 1eb36ed..2bdcd4c 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
@@ -19,7 +19,7 @@
 
 #include <linux/timer.h>
 #include <linux/interrupt.h>
-
+#include "ucode_loader.h"
 /*
  * Starting index for 5G rates in the
  * legacy rate table.
@@ -77,6 +77,7 @@ struct brcms_info {
 	bool resched;		/* dpc needs to be and is rescheduled */
 	struct brcms_firmware fw;
 	struct wiphy *wiphy;
+	struct brcms_ucode ucode;
 };
 
 /* misc callbacks */
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index ee9c322..4d5c842 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -342,6 +342,12 @@ static u16 frametype(u32 rspec, u8 mimoframe)
 /* Starting corerev for the fifo size table */
 #define XMTFIFOTBL_STARTREV	20
 
+struct d11init {
+	u16 addr;
+	u16 size;
+	u32 value;
+};
+
 /* currently the best mechanism for determining SIFS is the band in use */
 static u16 get_sifs(struct brcms_band *band)
 {
@@ -349,6 +355,7 @@ static u16 get_sifs(struct brcms_band *band)
 				 BPHY_SIFS_TIME;
 }
 
+
 /*
  * Detect Card removed.
  * Even checking an sbconfig register read will not false trigger when the core
@@ -694,6 +701,7 @@ static void brcms_c_write_mhf(struct brcms_hardware *wlc_hw, u16 *mhfs)
 static void brcms_c_ucode_bsinit(struct brcms_hardware *wlc_hw)
 {
 	struct wiphy *wiphy = wlc_hw->wlc->wiphy;
+	struct brcms_ucode *ucode = &wlc_hw->wlc->wl->ucode;
 
 	/* init microcode host flags */
 	brcms_c_write_mhf(wlc_hw, wlc_hw->band->mhfs);
@@ -701,7 +709,7 @@ static void brcms_c_ucode_bsinit(struct brcms_hardware *wlc_hw)
 	/* do band-specific ucode IHR, SHM, and SCR inits */
 	if (D11REV_IS(wlc_hw->corerev, 23)) {
 		if (BRCMS_ISNPHY(wlc_hw->band))
-			brcms_c_write_inits(wlc_hw, d11n0bsinitvals16);
+			brcms_c_write_inits(wlc_hw, ucode->d11n0bsinitvals16);
 		else
 			wiphy_err(wiphy, "%s: wl%d: unsupported phy in corerev"
 				  " %d\n", __func__, wlc_hw->unit,
@@ -710,7 +718,7 @@ static void brcms_c_ucode_bsinit(struct brcms_hardware *wlc_hw)
 		if (D11REV_IS(wlc_hw->corerev, 24)) {
 			if (BRCMS_ISLCNPHY(wlc_hw->band))
 				brcms_c_write_inits(wlc_hw,
-						    d11lcn0bsinitvals24);
+						    ucode->d11lcn0bsinitvals24);
 			else
 				wiphy_err(wiphy, "%s: wl%d: unsupported phy in"
 					  " core rev %d\n", __func__,
@@ -2457,6 +2465,8 @@ static void brcms_ucode_write(struct brcms_hardware *wlc_hw, const u32 ucode[],
 static void brcms_ucode_download(struct brcms_hardware *wlc_hw)
 {
 	struct brcms_c_info *wlc;
+	struct brcms_ucode *ucode = &wlc_hw->wlc->wl->ucode;
+
 	wlc = wlc_hw->wlc;
 
 	if (wlc_hw->ucode_loaded)
@@ -2464,8 +2474,8 @@ static void brcms_ucode_download(struct brcms_hardware *wlc_hw)
 
 	if (D11REV_IS(wlc_hw->corerev, 23)) {
 		if (BRCMS_ISNPHY(wlc_hw->band)) {
-			brcms_ucode_write(wlc_hw, bcm43xx_16_mimo,
-					bcm43xx_16_mimosz);
+			brcms_ucode_write(wlc_hw, ucode->bcm43xx_16_mimo,
+					  ucode->bcm43xx_16_mimosz);
 			wlc_hw->ucode_loaded = true;
 		} else
 			wiphy_err(wlc->wiphy, "%s: wl%d: unsupported phy in "
@@ -2473,8 +2483,8 @@ static void brcms_ucode_download(struct brcms_hardware *wlc_hw)
 				  __func__, wlc_hw->unit, wlc_hw->corerev);
 	} else if (D11REV_IS(wlc_hw->corerev, 24)) {
 		if (BRCMS_ISLCNPHY(wlc_hw->band)) {
-			brcms_ucode_write(wlc_hw, bcm43xx_24_lcn,
-					bcm43xx_24_lcnsz);
+			brcms_ucode_write(wlc_hw, ucode->bcm43xx_24_lcn,
+					  ucode->bcm43xx_24_lcnsz);
 			wlc_hw->ucode_loaded = true;
 		} else {
 			wiphy_err(wlc->wiphy, "%s: wl%d: unsupported phy in "
@@ -3372,6 +3382,7 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 	int err = 0;
 	u16 buf[NFIFO];
 	struct wiphy *wiphy = wlc->wiphy;
+	struct brcms_ucode *ucode = &wlc_hw->wlc->wl->ucode;
 
 	regs = wlc_hw->regs;
 
@@ -3404,14 +3415,14 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 
 	if (D11REV_IS(wlc_hw->corerev, 23)) {
 		if (BRCMS_ISNPHY(wlc_hw->band))
-			brcms_c_write_inits(wlc_hw, d11n0initvals16);
+			brcms_c_write_inits(wlc_hw, ucode->d11n0initvals16);
 		else
 			wiphy_err(wiphy, "%s: wl%d: unsupported phy in corerev"
 				  " %d\n", __func__, wlc_hw->unit,
 				  wlc_hw->corerev);
 	} else if (D11REV_IS(wlc_hw->corerev, 24)) {
 		if (BRCMS_ISLCNPHY(wlc_hw->band))
-			brcms_c_write_inits(wlc_hw, d11lcn0initvals24);
+			brcms_c_write_inits(wlc_hw, ucode->d11lcn0initvals24);
 		else
 			wiphy_err(wiphy, "%s: wl%d: unsupported phy in corerev"
 				  " %d\n", __func__, wlc_hw->unit,
diff --git a/drivers/staging/brcm80211/brcmsmac/ucode_loader.c b/drivers/staging/brcm80211/brcmsmac/ucode_loader.c
index c14bce8..80e3ccf 100644
--- a/drivers/staging/brcm80211/brcmsmac/ucode_loader.c
+++ b/drivers/staging/brcm80211/brcmsmac/ucode_loader.c
@@ -37,80 +37,73 @@ enum {
 	D11UCODE_OVERSIGHT_BOMMINOR
 };
 
-struct d11init *d11lcn0bsinitvals24;
-struct d11init *d11lcn0initvals24;
-struct d11init *d11lcn1bsinitvals24;
-struct d11init *d11lcn1initvals24;
-struct d11init *d11lcn2bsinitvals24;
-struct d11init *d11lcn2initvals24;
-struct d11init *d11n0absinitvals16;
-struct d11init *d11n0bsinitvals16;
-struct d11init *d11n0initvals16;
-u32 *bcm43xx_16_mimo;
-u32 bcm43xx_16_mimosz;
-u32 *bcm43xx_24_lcn;
-u32 bcm43xx_24_lcnsz;
-
-static u32 *bcm43xx_bommajor;
-static u32 *bcm43xx_bomminor;
-
-int brcms_ucode_data_init(struct brcms_info *wl)
+int brcms_ucode_data_init(struct brcms_info *wl, struct brcms_ucode *ucode)
 {
 	int rc;
+
 	rc = brcms_check_firmwares(wl);
 
 	rc = rc < 0 ? rc :
-		brcms_ucode_init_buf(wl, (void **)&d11lcn0bsinitvals24,
+		brcms_ucode_init_buf(wl, (void **)&ucode->d11lcn0bsinitvals24,
 				     D11LCN0BSINITVALS24);
-	rc = rc < 0 ? rc : brcms_ucode_init_buf(wl, (void **)&d11lcn0initvals24,
-					     D11LCN0INITVALS24);
+	rc = rc < 0 ?
+	     rc : brcms_ucode_init_buf(wl, (void **)&ucode->d11lcn0initvals24,
+				       D11LCN0INITVALS24);
+	rc = rc < 0 ?
+	     rc : brcms_ucode_init_buf(wl, (void **)&ucode->d11lcn1bsinitvals24,
+				       D11LCN1BSINITVALS24);
+	rc = rc < 0 ?
+	     rc : brcms_ucode_init_buf(wl, (void **)&ucode->d11lcn1initvals24,
+				       D11LCN1INITVALS24);
 	rc = rc < 0 ? rc :
-		brcms_ucode_init_buf(wl, (void **)&d11lcn1bsinitvals24,
-				     D11LCN1BSINITVALS24);
-	rc = rc < 0 ? rc : brcms_ucode_init_buf(wl, (void **)&d11lcn1initvals24,
-					     D11LCN1INITVALS24);
-	rc = rc < 0 ? rc :
-		brcms_ucode_init_buf(wl, (void **)&d11lcn2bsinitvals24,
+		brcms_ucode_init_buf(wl, (void **)&ucode->d11lcn2bsinitvals24,
 				     D11LCN2BSINITVALS24);
-	rc = rc < 0 ? rc : brcms_ucode_init_buf(wl, (void **)&d11lcn2initvals24,
-					     D11LCN2INITVALS24);
-	rc = rc < 0 ? rc :
-		brcms_ucode_init_buf(wl, (void **)&d11n0absinitvals16,
-				     D11N0ABSINITVALS16);
-	rc = rc < 0 ? rc : brcms_ucode_init_buf(wl, (void **)&d11n0bsinitvals16,
-					     D11N0BSINITVALS16);
-	rc = rc < 0 ? rc : brcms_ucode_init_buf(wl, (void **)&d11n0initvals16,
-					     D11N0INITVALS16);
-	rc = rc < 0 ? rc : brcms_ucode_init_buf(wl, (void **)&bcm43xx_16_mimo,
-					     D11UCODE_OVERSIGHT16_MIMO);
-	rc = rc < 0 ? rc : brcms_ucode_init_uint(wl, &bcm43xx_16_mimosz,
-					      D11UCODE_OVERSIGHT16_MIMOSZ);
-	rc = rc < 0 ? rc : brcms_ucode_init_buf(wl, (void **)&bcm43xx_24_lcn,
-					     D11UCODE_OVERSIGHT24_LCN);
-	rc = rc < 0 ? rc : brcms_ucode_init_uint(wl, &bcm43xx_24_lcnsz,
-					      D11UCODE_OVERSIGHT24_LCNSZ);
-	rc = rc < 0 ? rc : brcms_ucode_init_buf(wl, (void **)&bcm43xx_bommajor,
-					     D11UCODE_OVERSIGHT_BOMMAJOR);
-	rc = rc < 0 ? rc : brcms_ucode_init_buf(wl, (void **)&bcm43xx_bomminor,
-					     D11UCODE_OVERSIGHT_BOMMINOR);
+	rc = rc < 0 ?
+	     rc : brcms_ucode_init_buf(wl, (void **)&ucode->d11lcn2initvals24,
+				       D11LCN2INITVALS24);
+	rc = rc < 0 ?
+	     rc : brcms_ucode_init_buf(wl, (void **)&ucode->d11n0absinitvals16,
+				       D11N0ABSINITVALS16);
+	rc = rc < 0 ?
+	     rc : brcms_ucode_init_buf(wl, (void **)&ucode->d11n0bsinitvals16,
+				       D11N0BSINITVALS16);
+	rc = rc < 0 ?
+	     rc : brcms_ucode_init_buf(wl, (void **)&ucode->d11n0initvals16,
+				       D11N0INITVALS16);
+	rc = rc < 0 ?
+	     rc : brcms_ucode_init_buf(wl, (void **)&ucode->bcm43xx_16_mimo,
+				       D11UCODE_OVERSIGHT16_MIMO);
+	rc = rc < 0 ?
+	     rc : brcms_ucode_init_uint(wl, &ucode->bcm43xx_16_mimosz,
+					D11UCODE_OVERSIGHT16_MIMOSZ);
+	rc = rc < 0 ?
+	     rc : brcms_ucode_init_buf(wl, (void **)&ucode->bcm43xx_24_lcn,
+				       D11UCODE_OVERSIGHT24_LCN);
+	rc = rc < 0 ?
+	     rc : brcms_ucode_init_uint(wl, &ucode->bcm43xx_24_lcnsz,
+					D11UCODE_OVERSIGHT24_LCNSZ);
+	rc = rc < 0 ?
+	     rc : brcms_ucode_init_buf(wl, (void **)&ucode->bcm43xx_bommajor,
+				       D11UCODE_OVERSIGHT_BOMMAJOR);
+	rc = rc < 0 ?
+	     rc : brcms_ucode_init_buf(wl, (void **)&ucode->bcm43xx_bomminor,
+				       D11UCODE_OVERSIGHT_BOMMINOR);
 	return rc;
 }
 
-void brcms_ucode_data_free(void)
+void brcms_ucode_data_free(struct brcms_ucode *ucode)
 {
-	brcms_ucode_free_buf((void *)d11lcn0bsinitvals24);
-	brcms_ucode_free_buf((void *)d11lcn0initvals24);
-	brcms_ucode_free_buf((void *)d11lcn1bsinitvals24);
-	brcms_ucode_free_buf((void *)d11lcn1initvals24);
-	brcms_ucode_free_buf((void *)d11lcn2bsinitvals24);
-	brcms_ucode_free_buf((void *)d11lcn2initvals24);
-	brcms_ucode_free_buf((void *)d11n0absinitvals16);
-	brcms_ucode_free_buf((void *)d11n0bsinitvals16);
-	brcms_ucode_free_buf((void *)d11n0initvals16);
-	brcms_ucode_free_buf((void *)bcm43xx_16_mimo);
-	brcms_ucode_free_buf((void *)bcm43xx_24_lcn);
-	brcms_ucode_free_buf((void *)bcm43xx_bommajor);
-	brcms_ucode_free_buf((void *)bcm43xx_bomminor);
-
-	return;
+	brcms_ucode_free_buf((void *)ucode->d11lcn0bsinitvals24);
+	brcms_ucode_free_buf((void *)ucode->d11lcn0initvals24);
+	brcms_ucode_free_buf((void *)ucode->d11lcn1bsinitvals24);
+	brcms_ucode_free_buf((void *)ucode->d11lcn1initvals24);
+	brcms_ucode_free_buf((void *)ucode->d11lcn2bsinitvals24);
+	brcms_ucode_free_buf((void *)ucode->d11lcn2initvals24);
+	brcms_ucode_free_buf((void *)ucode->d11n0absinitvals16);
+	brcms_ucode_free_buf((void *)ucode->d11n0bsinitvals16);
+	brcms_ucode_free_buf((void *)ucode->d11n0initvals16);
+	brcms_ucode_free_buf((void *)ucode->bcm43xx_16_mimo);
+	brcms_ucode_free_buf((void *)ucode->bcm43xx_24_lcn);
+	brcms_ucode_free_buf((void *)ucode->bcm43xx_bommajor);
+	brcms_ucode_free_buf((void *)ucode->bcm43xx_bomminor);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/ucode_loader.h b/drivers/staging/brcm80211/brcmsmac/ucode_loader.h
index ca53dec..438675a 100644
--- a/drivers/staging/brcm80211/brcmsmac/ucode_loader.h
+++ b/drivers/staging/brcm80211/brcmsmac/ucode_loader.h
@@ -13,6 +13,8 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
+#ifndef	_BRCM_UCODE_H_
+#define	_BRCM_UCODE_H_
 
 #include "types.h"		/* forward structure declarations */
 
@@ -21,28 +23,30 @@
 
 #define UCODE_LOADER_API_VER 0
 
-struct d11init {
-	u16 addr;
-	u16 size;
-	u32 value;
+struct d11init;
+
+struct brcms_ucode {
+	struct d11init *d11lcn0bsinitvals24;
+	struct d11init *d11lcn0initvals24;
+	struct d11init *d11lcn1bsinitvals24;
+	struct d11init *d11lcn1initvals24;
+	struct d11init *d11lcn2bsinitvals24;
+	struct d11init *d11lcn2initvals24;
+	struct d11init *d11n0absinitvals16;
+	struct d11init *d11n0bsinitvals16;
+	struct d11init *d11n0initvals16;
+	u32 *bcm43xx_16_mimo;
+	u32 bcm43xx_16_mimosz;
+	u32 *bcm43xx_24_lcn;
+	u32 bcm43xx_24_lcnsz;
+	u32 *bcm43xx_bommajor;
+	u32 *bcm43xx_bomminor;
 };
 
-extern struct d11init *d11lcn0bsinitvals24;
-extern struct d11init *d11lcn0initvals24;
-extern struct d11init *d11lcn1bsinitvals24;
-extern struct d11init *d11lcn1initvals24;
-extern struct d11init *d11lcn2bsinitvals24;
-extern struct d11init *d11lcn2initvals24;
-extern struct d11init *d11n0absinitvals16;
-extern struct d11init *d11n0bsinitvals16;
-extern struct d11init *d11n0initvals16;
-extern u32 *bcm43xx_16_mimo;
-extern u32 bcm43xx_16_mimosz;
-extern u32 *bcm43xx_24_lcn;
-extern u32 bcm43xx_24_lcnsz;
-
-extern int brcms_ucode_data_init(struct brcms_info *wl);
-extern void brcms_ucode_data_free(void);
+extern int
+brcms_ucode_data_init(struct brcms_info *wl, struct brcms_ucode *ucode);
+
+extern void brcms_ucode_data_free(struct brcms_ucode *ucode);
 
 extern int brcms_ucode_init_buf(struct brcms_info *wl, void **pbuf,
 				unsigned int idx);
@@ -50,3 +54,5 @@ extern int brcms_ucode_init_uint(struct brcms_info *wl, unsigned *data,
 			      unsigned int idx);
 extern void brcms_ucode_free_buf(void *);
 extern int  brcms_check_firmwares(struct brcms_info *wl);
+
+#endif	/* _BRCM_UCODE_H_ */
-- 
1.7.1


