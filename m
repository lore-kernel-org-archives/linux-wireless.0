Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2388 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933193Ab1JDVTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/26] staging: brcm80211: fixed function returns
Date: Tue, 4 Oct 2011 23:18:58 +0200
Message-ID: <1317763152-17607-13-git-send-email-arend@broadcom.com> (sfid-20111004_232012_589507_715E7C36)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

- removed unneeded return statements at end of functions.
- changed return value of brcms_c_radio_monitor_start to void.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   23 ++---------------------
 1 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index b6c4361..dc95ba0 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -1572,8 +1572,6 @@ void brcms_c_ucode_wake_override_set(struct brcms_hardware *wlc_hw,
 
 	brcms_c_mctrl_write(wlc_hw);
 	brcms_b_wait_for_wake(wlc_hw);
-
-	return;
 }
 
 void brcms_c_ucode_wake_override_clear(struct brcms_hardware *wlc_hw,
@@ -1585,8 +1583,6 @@ void brcms_c_ucode_wake_override_clear(struct brcms_hardware *wlc_hw,
 		return;
 
 	brcms_c_mctrl_write(wlc_hw);
-
-	return;
 }
 
 /* When driver needs ucode to stop beaconing, it has to make sure that
@@ -1607,8 +1603,6 @@ static void brcms_c_ucode_mute_override_set(struct brcms_hardware *wlc_hw)
 		return;
 
 	brcms_c_mctrl_write(wlc_hw);
-
-	return;
 }
 
 /* Clear the override on AP and INFRA bits */
@@ -3217,8 +3211,6 @@ static void brcms_b_pllreq(struct brcms_hardware *wlc_hw, bool set, u32 req_bit)
 				brcms_b_xtal(wlc_hw, OFF);
 		}
 	}
-
-	return;
 }
 
 static void brcms_b_antsel_set(struct brcms_hardware *wlc_hw, u32 antsel_avail)
@@ -4308,17 +4300,16 @@ static void brcms_c_down_led_upd(struct brcms_c_info *wlc)
 	brcms_c_pllreq(wlc, false, BRCMS_PLLREQ_FLIP);
 }
 
-static bool brcms_c_radio_monitor_start(struct brcms_c_info *wlc)
+static void brcms_c_radio_monitor_start(struct brcms_c_info *wlc)
 {
 	/* Don't start the timer if HWRADIO feature is disabled */
 	if (wlc->radio_monitor)
-		return true;
+		return;
 
 	wlc->radio_monitor = true;
 	brcms_c_pllreq(wlc, true, BRCMS_PLLREQ_RADIO_MON);
 	brcms_add_timer(wlc->wl, wlc->radio_timer, TIMER_INTERVAL_RADIOCHK,
 			true);
-	return true;
 }
 
 void brcms_c_radio_disable(struct brcms_c_info *wlc)
@@ -6123,8 +6114,6 @@ static void brcms_c_ofdm_rateset_war(struct brcms_c_info *wlc)
 		r = wlc->default_bss->rateset.rates[0];
 
 	wlc_phy_ofdm_rateset_war(wlc->band->pi, war);
-
-	return;
 }
 
 int brcms_c_set_channel(struct brcms_c_info *wlc, u16 channel)
@@ -7785,8 +7774,6 @@ brcms_c_compute_ofdm_plcp(u32 rspec, u32 length, u8 *plcp)
 	plcp[2] |= (tmp >> 16) & 0xff;
 	plcp[1] |= (tmp >> 8) & 0xff;
 	plcp[0] |= tmp & 0xff;
-
-	return;
 }
 
 /* Rate: 802.11 rate code, length: PSDU length in octets */
@@ -7808,7 +7795,6 @@ brcms_c_compute_plcp(struct brcms_c_info *wlc, u32 rspec,
 		brcms_c_compute_ofdm_plcp(rspec, length, plcp);
 	else
 		brcms_c_compute_cck_plcp(wlc, rspec, length, plcp);
-	return;
 }
 
 /* brcms_c_compute_rtscts_dur()
@@ -7997,8 +7983,6 @@ brcms_b_read_tsf(struct brcms_hardware *wlc_hw, u32 *tsf_l_ptr,
 	/* read the tsf timer low, then high to get an atomic read */
 	*tsf_l_ptr = R_REG(&regs->tsf_timerlow);
 	*tsf_h_ptr = R_REG(&regs->tsf_timerhigh);
-
-	return;
 }
 
 /*
@@ -8175,7 +8159,6 @@ brcms_c_recvctl(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 
 	memcpy(IEEE80211_SKB_RXCB(p), &rx_status, sizeof(rx_status));
 	ieee80211_rx_irqsafe(wlc->pub->ieee_hw, p);
-	return;
 }
 
 /* Process received frames */
@@ -8683,8 +8666,6 @@ brcms_c_bcn_prb_template(struct brcms_c_info *wlc, u16 type,
 	memcpy(&h->bssid, &cfg->BSSID, ETH_ALEN);
 
 	/* SEQ filled in by MAC */
-
-	return;
 }
 
 int brcms_c_get_header_len(void)
-- 
1.7.4.1


