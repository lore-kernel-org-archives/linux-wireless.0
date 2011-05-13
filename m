Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4898 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758728Ab1EMKAK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:10 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 07/32] staging: brcm80211: remove unused functions and
 prototypes
Date: Fri, 13 May 2011 11:59:27 +0200
Message-ID: <1305280792-9475-7-git-send-email-arend@broadcom.com> (sfid-20110513_120105_789999_AA4A7B37)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several functions in wlc_bmac.c are not used in the driver and
prototypes in wlc_pub.h that have no implementation. These have
been removed.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c |   48 -------------------------
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.h |    5 ---
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h  |   25 -------------
 3 files changed, 0 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index b94f376..e7f47eb 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -1562,33 +1562,6 @@ static void wlc_ucode_mute_override_clear(struct wlc_hw_info *wlc_hw)
 }
 
 /*
- * Write a MAC address to the rcmta structure
- */
-void
-wlc_bmac_set_rcmta(struct wlc_hw_info *wlc_hw, int idx,
-		   const u8 *addr)
-{
-	d11regs_t *regs = wlc_hw->regs;
-	volatile u16 *objdata16 = (volatile u16 *)&regs->objdata;
-	u32 mac_hm;
-	u16 mac_l;
-
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
-
-	mac_hm =
-	    (addr[3] << 24) | (addr[2] << 16) |
-	    (addr[1] << 8) | addr[0];
-	mac_l = (addr[5] << 8) | addr[4];
-
-	W_REG(&regs->objaddr, (OBJADDR_RCMTA_SEL | (idx * 2)));
-	(void)R_REG(&regs->objaddr);
-	W_REG(&regs->objdata, mac_hm);
-	W_REG(&regs->objaddr, (OBJADDR_RCMTA_SEL | ((idx * 2) + 1)));
-	(void)R_REG(&regs->objaddr);
-	W_REG(objdata16, mac_l);
-}
-
-/*
  * Write a MAC address to the given match reg offset in the RXE match engine.
  */
 void
@@ -3481,22 +3454,6 @@ void wlc_bmac_write_shm(struct wlc_hw_info *wlc_hw, uint offset, u16 v)
 	wlc_bmac_write_objmem(wlc_hw, offset, v, OBJADDR_SHM_SEL);
 }
 
-/* Set a range of shared memory to a value.
- * SHM 'offset' needs to be an even address and
- * Buffer length 'len' must be an even number of bytes
- */
-void wlc_bmac_set_shm(struct wlc_hw_info *wlc_hw, uint offset, u16 v, int len)
-{
-	int i;
-
-	if (len <= 0 || (offset & 1) || (len & 1))
-		return;
-
-	for (i = 0; i < len; i += 2) {
-		wlc_bmac_write_objmem(wlc_hw, offset + i, v, OBJADDR_SHM_SEL);
-	}
-}
-
 static u16
 wlc_bmac_read_objmem(struct wlc_hw_info *wlc_hw, uint offset, u32 sel)
 {
@@ -3604,11 +3561,6 @@ void wlc_bmac_retrylimit_upd(struct wlc_hw_info *wlc_hw, u16 SRL, u16 LRL)
 	}
 }
 
-void wlc_bmac_set_noreset(struct wlc_hw_info *wlc_hw, bool noreset_flag)
-{
-	wlc_hw->noreset = noreset_flag;
-}
-
 void wlc_bmac_pllreq(struct wlc_hw_info *wlc_hw, bool set, mbool req_bit)
 {
 	if (set) {
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.h b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.h
index 29785fe..a5dccc2 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.h
@@ -130,8 +130,6 @@ extern int wlc_bmac_state_get(struct wlc_hw_info *wlc_hw,
 			      wlc_bmac_state_t *state);
 extern void wlc_bmac_write_shm(struct wlc_hw_info *wlc_hw, uint offset, u16 v);
 extern u16 wlc_bmac_read_shm(struct wlc_hw_info *wlc_hw, uint offset);
-extern void wlc_bmac_set_shm(struct wlc_hw_info *wlc_hw, uint offset, u16 v,
-			     int len);
 extern void wlc_bmac_write_template_ram(struct wlc_hw_info *wlc_hw, int offset,
 					int len, void *buf);
 extern void wlc_bmac_copyfrom_vars(struct wlc_hw_info *wlc_hw, char **buf,
@@ -151,8 +149,6 @@ extern void wlc_ucode_wake_override_set(struct wlc_hw_info *wlc_hw,
 extern void wlc_ucode_wake_override_clear(struct wlc_hw_info *wlc_hw,
 					  u32 override_bit);
 
-extern void wlc_bmac_set_rcmta(struct wlc_hw_info *wlc_hw, int idx,
-			       const u8 *addr);
 extern void wlc_bmac_set_addrmatch(struct wlc_hw_info *wlc_hw,
 				   int match_reg_offset,
 				   const u8 *addr);
@@ -163,7 +159,6 @@ extern void wlc_bmac_read_tsf(struct wlc_hw_info *wlc_hw, u32 *tsf_l_ptr,
 			      u32 *tsf_h_ptr);
 extern void wlc_bmac_set_cwmin(struct wlc_hw_info *wlc_hw, u16 newmin);
 extern void wlc_bmac_set_cwmax(struct wlc_hw_info *wlc_hw, u16 newmax);
-extern void wlc_bmac_set_noreset(struct wlc_hw_info *wlc, bool noreset_flag);
 
 extern void wlc_bmac_retrylimit_upd(struct wlc_hw_info *wlc_hw, u16 SRL,
 				    u16 LRL);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
index 90d471d..9334dea 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
@@ -505,8 +505,6 @@ extern void wlc_intrsrestore(struct wlc_info *wlc, u32 macintmask);
 extern bool wlc_intrsupd(struct wlc_info *wlc);
 extern bool wlc_isr(struct wlc_info *wlc, bool *wantdpc);
 extern bool wlc_dpc(struct wlc_info *wlc, bool bounded);
-extern bool wlc_send80211_raw(struct wlc_info *wlc, struct wlc_if *wlcif,
-			      void *p, uint ac);
 extern bool wlc_sendpkt_mac80211(struct wlc_info *wlc, struct sk_buff *sdu,
 				 struct ieee80211_hw *hw);
 extern int wlc_iovar_op(struct wlc_info *wlc, const char *name, void *params,
@@ -529,16 +527,8 @@ extern void wlc_wme_setparams(struct wlc_info *wlc, u16 aci,
 extern struct wlc_pub *wlc_pub(void *wlc);
 
 /* common functions for every port */
-extern int wlc_bmac_up_prep(struct wlc_hw_info *wlc_hw);
-extern int wlc_bmac_up_finish(struct wlc_hw_info *wlc_hw);
-extern int wlc_bmac_down_prep(struct wlc_hw_info *wlc_hw);
-extern int wlc_bmac_down_finish(struct wlc_hw_info *wlc_hw);
-
-extern u32 wlc_reg_read(struct wlc_info *wlc, void *r, uint size);
-extern void wlc_reg_write(struct wlc_info *wlc, void *r, u32 v, uint size);
 extern void wlc_mhf(struct wlc_info *wlc, u8 idx, u16 mask, u16 val,
 		    int bands);
-extern u32 wlc_delta_txfunfl(struct wlc_info *wlc, int fifo);
 extern void wlc_rate_lookup_init(struct wlc_info *wlc, wlc_rateset_t *rateset);
 extern void wlc_default_rateset(struct wlc_info *wlc, wlc_rateset_t *rs);
 
@@ -549,11 +539,8 @@ extern void wlc_ampdu_flush(struct wlc_info *wlc, struct ieee80211_sta *sta,
 /* wlc_phy.c helper functions */
 extern void wlc_set_ps_ctrl(struct wlc_info *wlc);
 extern void wlc_mctrl(struct wlc_info *wlc, u32 mask, u32 val);
-extern void wlc_scb_ratesel_init_all(struct wlc_info *wlc);
 
 /* ioctl */
-extern int wlc_iovar_gets8(struct wlc_info *wlc, const char *name,
-			     s8 *arg);
 extern int wlc_iovar_check(struct wlc_pub *pub, const bcm_iovar_t *vi,
 			   void *arg,
 			   int len, bool set);
@@ -571,18 +558,6 @@ extern void wlc_scan_stop(struct wlc_info *wlc);
 extern int wlc_get_curband(struct wlc_info *wlc);
 extern void wlc_wait_for_tx_completion(struct wlc_info *wlc, bool drop);
 
-static inline int wlc_iovar_getuint(struct wlc_info *wlc, const char *name,
-				    uint *arg)
-{
-	return wlc_iovar_getint(wlc, name, (int *)arg);
-}
-
-static inline int wlc_iovar_setuint(struct wlc_info *wlc, const char *name,
-				    uint arg)
-{
-	return wlc_iovar_setint(wlc, name, (int)arg);
-}
-
 #if defined(BCMDBG)
 extern int wlc_iocregchk(struct wlc_info *wlc, uint band);
 #endif
-- 
1.7.4.1


