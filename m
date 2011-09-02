Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4308 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab1IBOBB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 10:01:01 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 04/12] staging: brcm80211: remove sparse warning from
 main.c
Date: Fri, 2 Sep 2011 16:00:31 +0200
Message-ID: <1314972039-27098-5-git-send-email-rvossen@broadcom.com> (sfid-20110902_160116_164431_5BCADFF8)
In-Reply-To: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
References: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The source file main.c contained several sparse warnings which
have been cleaned up.

Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   19 +++++++++----------
 drivers/staging/brcm80211/brcmsmac/pub.h  |    5 +++--
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 6b694b1..9e73b42 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -880,7 +880,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 	/* name and offsets for dma_attach */
 	snprintf(name, sizeof(name), "wl%d", unit);
 
-	if (wlc_hw->di[0] == 0) {	/* Init FIFOs */
+	if (wlc_hw->di[0] == NULL) {	/* Init FIFOs */
 		int dma_attach_err = 0;
 
 		/*
@@ -5006,7 +5006,8 @@ static void brcms_c_update_mimo_band_bwcap(struct brcms_c_info *wlc, u8 bwcap)
  */
 struct brcms_c_info *
 brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
-	       bool piomode, void *regsva, struct pci_dev *btparam, uint *perr)
+	       bool piomode, void __iomem *regsva, struct pci_dev *btparam,
+	       uint *perr)
 {
 	struct brcms_c_info *wlc;
 	uint err = 0;
@@ -7096,8 +7097,8 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	int len, phylen, rts_phylen;
 	u16 mch, phyctl, xfts, mainrates;
 	u16 seq = 0, mcl = 0, status = 0, frameid = 0;
-	u32 rspec[2] = { BRCM_RATE_1M, BRCM_RATE_1M }, rts_rspec[2] = {
-	BRCM_RATE_1M, BRCM_RATE_1M};
+	u32 rspec[2] = { BRCM_RATE_1M, BRCM_RATE_1M };
+	u32 rts_rspec[2] = { BRCM_RATE_1M, BRCM_RATE_1M };
 	bool use_rts = false;
 	bool use_cts = false;
 	bool use_rifs = false;
@@ -7741,9 +7742,8 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	return 0;
 }
 
-bool
-brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
-		     struct ieee80211_hw *hw)
+void brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
+			      struct ieee80211_hw *hw)
 {
 	u8 prio;
 	uint fifo;
@@ -7760,10 +7760,9 @@ brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
 	if (unlikely
 	    (brcms_c_d11hdrs_mac80211(
 		wlc, hw, sdu, scb, 0, 1, fifo, 0, NULL, 0)))
-		return -EINVAL;
+		return;
 	brcms_c_txq_enq(wlc, scb, sdu, BRCMS_PRIO_TO_PREC(prio));
 	brcms_c_send_q(wlc);
-	return 0;
 }
 
 void brcms_c_send_q(struct brcms_c_info *wlc)
@@ -9100,7 +9099,7 @@ brcms_c_bcn_prb_template(struct brcms_c_info *wlc, u16 type,
 	return;
 }
 
-int brcms_c_get_header_len()
+int brcms_c_get_header_len(void)
 {
 	return TXOFF;
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index f4e47e8..5bca2fb 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -536,7 +536,8 @@ struct brcms_antselcfg {
 /* common functions for every port */
 struct brcms_c_info *
 brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
-	       bool piomode, void *regsva, struct pci_dev *btparam, uint *perr);
+	       bool piomode, void __iomem *regsva, struct pci_dev *btparam,
+	       uint *perr);
 extern uint brcms_c_detach(struct brcms_c_info *wlc);
 extern int brcms_c_up(struct brcms_c_info *wlc);
 extern uint brcms_c_down(struct brcms_c_info *wlc);
@@ -553,7 +554,7 @@ extern void brcms_c_intrsrestore(struct brcms_c_info *wlc, u32 macintmask);
 extern bool brcms_c_intrsupd(struct brcms_c_info *wlc);
 extern bool brcms_c_isr(struct brcms_c_info *wlc, bool *wantdpc);
 extern bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded);
-extern bool brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc,
+extern void brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc,
 				     struct sk_buff *sdu,
 				     struct ieee80211_hw *hw);
 extern int brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
-- 
1.7.4.1


