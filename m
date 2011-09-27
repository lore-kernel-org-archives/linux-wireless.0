Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4747 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab1I0Rpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 13:45:52 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 19/26] staging: brcm80211: change interface for
 common rssi compute function
Date: Tue, 27 Sep 2011 10:45:23 -0700
Message-ID: <1317145530-18839-20-git-send-email-frankyl@broadcom.com> (sfid-20110927_194636_928341_3B7435A0)
In-Reply-To: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The function wlc_phy_rssi_compute() now uses d11rxhdr struct as
purely input parameter and returns the computed rssi value.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c        |    4 +++-
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |    7 +++----
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h |    4 ++--
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index e34b511..ef96358 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -806,15 +806,17 @@ brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
 
 	/* process each frame */
 	while ((p = head) != NULL) {
+		struct d11rxhdr *rxh;
 		head = head->prev;
 		p->prev = NULL;
 
 		wlc_rxhdr = (struct brcms_d11rxhdr *) p->data;
+		rxh = (struct d11rxhdr *)p->data;
 
 		/*
 		 * compute the RSSI from d11rxhdr and record it in wlc_rxd11hr
 		 */
-		wlc_phy_rssi_compute(wlc_hw->band->pi, wlc_rxhdr);
+		wlc_rxhdr->rssi = wlc_phy_rssi_compute(wlc_hw->band->pi, rxh);
 
 		brcms_c_recv(wlc_hw->wlc, p);
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 8025247..c359a10 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -2610,10 +2610,9 @@ void wlc_phy_compute_dB(u32 *cmplx_pwr, s8 *p_cmplx_pwr_dB, u8 core)
 	}
 }
 
-void wlc_phy_rssi_compute(struct brcms_phy_pub *pih,
-			  struct brcms_d11rxhdr *wlc_rxhdr)
+int wlc_phy_rssi_compute(struct brcms_phy_pub *pih,
+			 struct d11rxhdr *rxh)
 {
-	struct d11rxhdr *rxh = &wlc_rxhdr->rxhdr;
 	int rssi = le16_to_cpu(rxh->PhyRxStatus_1) & PRXS1_JSSI_MASK;
 	uint radioid = pih->radioid;
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
@@ -2650,7 +2649,7 @@ void wlc_phy_rssi_compute(struct brcms_phy_pub *pih,
 	}
 
 end:
-	wlc_rxhdr->rssi = (s8) rssi;
+	return rssi;
 }
 
 void wlc_phy_freqtrack_start(struct brcms_phy_pub *pih)
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
index 1dbfaa3..39c3c22 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
@@ -212,8 +212,8 @@ extern void wlc_phy_chanspec_radio_set(struct brcms_phy_pub *ppi,
 extern u16 wlc_phy_bw_state_get(struct brcms_phy_pub *ppi);
 extern void wlc_phy_bw_state_set(struct brcms_phy_pub *ppi, u16 bw);
 
-extern void wlc_phy_rssi_compute(struct brcms_phy_pub *pih,
-				 struct brcms_d11rxhdr *wlc_rxhdr);
+extern int wlc_phy_rssi_compute(struct brcms_phy_pub *pih,
+				struct d11rxhdr *rxh);
 extern void wlc_phy_por_inform(struct brcms_phy_pub *ppi);
 extern void wlc_phy_noise_sample_intr(struct brcms_phy_pub *ppi);
 extern bool wlc_phy_bist_check_phy(struct brcms_phy_pub *ppi);
-- 
1.7.1


