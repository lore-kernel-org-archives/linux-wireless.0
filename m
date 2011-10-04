Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2393 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933201Ab1JDVTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 19/26] staging: brcm80211: cleanup of several wrapper
 functions
Date: Tue, 4 Oct 2011 23:19:05 +0200
Message-ID: <1317763152-17607-20-git-send-email-arend@broadcom.com> (sfid-20111004_232030_517999_66EA88B8)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

- removed brcms_c_write_template_ram function.
- removed brcms_c_mctrl function.
- removed brcms_c_pllreq function.
- removed brcms_c_mhf function.
- removed brcms_c_rate_shm_offset function.
- removed brcms_c_write_hw_bcntemplates function.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/ampdu.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/main.c  |   51 ++++++---------------------
 drivers/staging/brcm80211/brcmsmac/main.h  |    3 --
 3 files changed, 13 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index fc49900..7f27dbd 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -1162,7 +1162,7 @@ void brcms_c_ampdu_macaddr_upd(struct brcms_c_info *wlc)
 	/* driver needs to write the ta in the template; ta is at offset 16 */
 	memset(template, 0, sizeof(template));
 	memcpy(template, wlc->pub->cur_etheraddr, ETH_ALEN);
-	brcms_c_write_template_ram(wlc, (T_BA_TPL_BASE + 16),
+	brcms_b_write_template_ram(wlc->hw, (T_BA_TPL_BASE + 16),
 				  (T_RAM_ACCESS_SZ * 2),
 				  template);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index cbed10c..bd38f33 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -3846,9 +3846,9 @@ void brcms_c_mac_bcn_promisc_change(struct brcms_c_info *wlc, bool promisc)
 void brcms_c_mac_bcn_promisc(struct brcms_c_info *wlc)
 {
 	if (wlc->bcnmisc_monitor)
-		brcms_c_mctrl(wlc, MCTL_BCNS_PROMISC, MCTL_BCNS_PROMISC);
+		brcms_b_mctrl(wlc->hw, MCTL_BCNS_PROMISC, MCTL_BCNS_PROMISC);
 	else
-		brcms_c_mctrl(wlc, MCTL_BCNS_PROMISC, 0);
+		brcms_b_mctrl(wlc->hw, MCTL_BCNS_PROMISC, 0);
 }
 
 /* set or clear maccontrol bits MCTL_PROMISC and MCTL_KEEPCONTROL */
@@ -3872,7 +3872,7 @@ void brcms_c_mac_promisc(struct brcms_c_info *wlc)
 	if (wlc->monitor)
 		promisc_bits |= MCTL_PROMISC | MCTL_KEEPCONTROL;
 
-	brcms_c_mctrl(wlc, MCTL_PROMISC | MCTL_KEEPCONTROL, promisc_bits);
+	brcms_b_mctrl(wlc->hw, MCTL_PROMISC | MCTL_KEEPCONTROL, promisc_bits);
 }
 
 /* push sw hps and wake state through hardware */
@@ -3891,7 +3891,7 @@ void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc)
 	if (hps)
 		v2 |= MCTL_HPS;
 
-	brcms_c_mctrl(wlc, MCTL_WAKE | MCTL_HPS, v2);
+	brcms_b_mctrl(wlc->hw, MCTL_WAKE | MCTL_HPS, v2);
 
 	awake_before = ((v1 & MCTL_WAKE) || ((v1 & MCTL_HPS) == 0));
 
@@ -4301,8 +4301,8 @@ static void brcms_c_down_led_upd(struct brcms_c_info *wlc)
 	 * maintain LEDs while in down state, turn on sbclk if
 	 * not available yet. Turn on sbclk if necessary
 	 */
-	brcms_c_pllreq(wlc, true, BRCMS_PLLREQ_FLIP);
-	brcms_c_pllreq(wlc, false, BRCMS_PLLREQ_FLIP);
+	brcms_b_pllreq(wlc->hw, true, BRCMS_PLLREQ_FLIP);
+	brcms_b_pllreq(wlc->hw, false, BRCMS_PLLREQ_FLIP);
 }
 
 static void brcms_c_radio_monitor_start(struct brcms_c_info *wlc)
@@ -4312,7 +4312,7 @@ static void brcms_c_radio_monitor_start(struct brcms_c_info *wlc)
 		return;
 
 	wlc->radio_monitor = true;
-	brcms_c_pllreq(wlc, true, BRCMS_PLLREQ_RADIO_MON);
+	brcms_b_pllreq(wlc->hw, true, BRCMS_PLLREQ_RADIO_MON);
 	brcms_add_timer(wlc->wl, wlc->radio_timer, TIMER_INTERVAL_RADIOCHK,
 			true);
 }
@@ -4345,7 +4345,7 @@ bool brcms_c_radio_monitor_stop(struct brcms_c_info *wlc)
 		return true;
 
 	wlc->radio_monitor = false;
-	brcms_c_pllreq(wlc, false, BRCMS_PLLREQ_RADIO_MON);
+	brcms_b_pllreq(wlc->hw, false, BRCMS_PLLREQ_RADIO_MON);
 	return brcms_del_timer(wlc->wl, wlc->radio_timer);
 }
 
@@ -5675,10 +5675,10 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	    && (wlc->pub->sih->chip == BCM4313_CHIP_ID)) {
 		if (wlc->pub->boardrev >= 0x1250
 		    && (wlc->pub->boardflags & BFL_FEM_BT))
-			brcms_c_mhf(wlc, MHF5, MHF5_4313_GPIOCTRL,
+			brcms_b_mhf(wlc->hw, MHF5, MHF5_4313_GPIOCTRL,
 				MHF5_4313_GPIOCTRL, BRCM_BAND_ALL);
 		else
-			brcms_c_mhf(wlc, MHF4, MHF4_EXTPA_ENABLE,
+			brcms_b_mhf(wlc->hw, MHF4, MHF4_EXTPA_ENABLE,
 				    MHF4_EXTPA_ENABLE, BRCM_BAND_ALL);
 	}
 
@@ -5720,7 +5720,7 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	brcms_c_radio_monitor_stop(wlc);
 
 	/* Set EDCF hostflags */
-	brcms_c_mhf(wlc, MHF1, MHF1_EDCF, MHF1_EDCF, BRCM_BAND_ALL);
+	brcms_b_mhf(wlc->hw, MHF1, MHF1_EDCF, MHF1_EDCF, BRCM_BAND_ALL);
 
 	brcms_init(wlc->wl);
 	wlc->pub->up = true;
@@ -6578,11 +6578,6 @@ u16 brcms_b_rate_shm_offset(struct brcms_hardware *wlc_hw, u8 rate)
 	return 2 * brcms_b_read_shm(wlc_hw, table_ptr + (index * 2));
 }
 
-static u16 brcms_c_rate_shm_offset(struct brcms_c_info *wlc, u8 rate)
-{
-	return brcms_b_rate_shm_offset(wlc->hw, rate);
-}
-
 /* Callback for device removed */
 
 /*
@@ -8581,7 +8576,7 @@ void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
 	for (i = 0; i < rs.count; i++) {
 		rate = rs.rates[i] & BRCMS_RATE_MASK;
 
-		entry_ptr = brcms_c_rate_shm_offset(wlc, rate);
+		entry_ptr = brcms_b_rate_shm_offset(wlc->hw, rate);
 
 		/* Calculate the Probe Response PLCP for the given rate */
 		brcms_c_compute_plcp(wlc, rate, frame_len, plcp);
@@ -8798,17 +8793,6 @@ void brcms_c_copyto_shm(struct brcms_c_info *wlc, uint offset, const void *buf,
 	brcms_b_copyto_objmem(wlc->hw, offset, buf, len, OBJADDR_SHM_SEL);
 }
 
-/* wrapper BMAC functions to for HIGH driver access */
-void brcms_c_mctrl(struct brcms_c_info *wlc, u32 mask, u32 val)
-{
-	brcms_b_mctrl(wlc->hw, mask, val);
-}
-
-void brcms_c_mhf(struct brcms_c_info *wlc, u8 idx, u16 mask, u16 val, int bands)
-{
-	brcms_b_mhf(wlc->hw, idx, mask, val, bands);
-}
-
 int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
 			   uint *blocks)
 {
@@ -8820,12 +8804,6 @@ int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
 	return 0;
 }
 
-void brcms_c_write_template_ram(struct brcms_c_info *wlc, int offset, int len,
-			    void *buf)
-{
-	brcms_b_write_template_ram(wlc->hw, offset, len, buf);
-}
-
 void
 brcms_c_set_addrmatch(struct brcms_c_info *wlc, int match_reg_offset,
 		  const u8 *addr)
@@ -8835,11 +8813,6 @@ brcms_c_set_addrmatch(struct brcms_c_info *wlc, int match_reg_offset,
 		memcpy(wlc->bsscfg->BSSID, addr, ETH_ALEN);
 }
 
-void brcms_c_pllreq(struct brcms_c_info *wlc, bool set, u32 req_bit)
-{
-	brcms_b_pllreq(wlc->hw, set, req_bit);
-}
-
 /* check for the particular priority flow control bit being set */
 bool
 brcms_c_txflowcontrol_prio_isset(struct brcms_c_info *wlc,
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index a71c509..99d5c60 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -674,9 +674,6 @@ extern void brcms_c_info_init(struct brcms_c_info *wlc, int unit);
 extern void brcms_c_print_txstatus(struct tx_status *txs);
 extern int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
 		   uint *blocks);
-extern void brcms_c_write_template_ram(struct brcms_c_info *wlc, int offset,
-				       int len, void *buf);
-extern void brcms_c_pllreq(struct brcms_c_info *wlc, bool set, u32 req_bit);
 
 #if defined(BCMDBG)
 extern void brcms_c_print_rxh(struct d11rxhdr *rxh);
-- 
1.7.4.1


