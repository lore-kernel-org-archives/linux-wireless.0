Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2423 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933208Ab1JDVTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 17/26] staging: brcm80211: cleanup of shared memory
 related wrapper functions
Date: Tue, 4 Oct 2011 23:19:03 +0200
Message-ID: <1317763152-17607-18-git-send-email-arend@broadcom.com> (sfid-20111004_231954_445759_8099770A)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

- removed brcms_c_read_shm and brcms_c_write_shm functions.
- removed redundant argument check from brcms_c_copyto_shm function.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/ampdu.c  |   10 ++--
 drivers/staging/brcm80211/brcmsmac/antsel.c |    4 +-
 drivers/staging/brcm80211/brcmsmac/main.c   |   78 ++++++++++++---------------
 drivers/staging/brcm80211/brcmsmac/main.h   |    2 -
 4 files changed, 41 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index e29c62e..506c392 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -369,7 +369,7 @@ static int brcms_c_ffpld_check_txfunfl(struct brcms_c_info *wlc, int fid)
 	u16 cur_txunfl;
 
 	/* return if we got here for a different reason than underflows */
-	cur_txunfl = brcms_c_read_shm(wlc,
+	cur_txunfl = brcms_b_read_shm(wlc->hw,
 				      M_UCODE_MACSTAT +
 				      offsetof(struct macstat, txfunfl[fid]));
 	new_txunfl = (u16) (cur_txunfl - fifo->prev_txfunfl);
@@ -1182,11 +1182,11 @@ void brcms_c_ampdu_shm_upd(struct ampdu_info *ampdu)
 	 */
 	if ((ampdu->rx_factor & IEEE80211_HT_AMPDU_PARM_FACTOR) ==
 	    IEEE80211_HT_MAX_AMPDU_64K) {
-		brcms_c_write_shm(wlc, M_MIMO_MAXSYM, MIMO_MAXSYM_MAX);
-		brcms_c_write_shm(wlc, M_WATCHDOG_8TU, WATCHDOG_8TU_MAX);
+		brcms_b_write_shm(wlc->hw, M_MIMO_MAXSYM, MIMO_MAXSYM_MAX);
+		brcms_b_write_shm(wlc->hw, M_WATCHDOG_8TU, WATCHDOG_8TU_MAX);
 	} else {
-		brcms_c_write_shm(wlc, M_MIMO_MAXSYM, MIMO_MAXSYM_DEF);
-		brcms_c_write_shm(wlc, M_WATCHDOG_8TU, WATCHDOG_8TU_DEF);
+		brcms_b_write_shm(wlc->hw, M_MIMO_MAXSYM, MIMO_MAXSYM_DEF);
+		brcms_b_write_shm(wlc->hw, M_WATCHDOG_8TU, WATCHDOG_8TU_DEF);
 	}
 }
 
diff --git a/drivers/staging/brcm80211/brcmsmac/antsel.c b/drivers/staging/brcm80211/brcmsmac/antsel.c
index c61c520..c2aa47b 100644
--- a/drivers/staging/brcm80211/brcmsmac/antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/antsel.c
@@ -206,7 +206,7 @@ static int brcms_c_antsel_cfgupd(struct antsel_info *asi,
 	 */
 	ant_cfg = antsel->ant_config[ANT_SELCFG_TX_DEF];
 	mimo_antsel = brcms_c_antsel_antcfg2antsel(asi, ant_cfg);
-	brcms_c_write_shm(wlc, M_MIMO_ANTSEL_TXDFLT, mimo_antsel);
+	brcms_b_write_shm(wlc->hw, M_MIMO_ANTSEL_TXDFLT, mimo_antsel);
 	/*
 	 * Update driver stats for currently selected
 	 * default tx/rx antenna config
@@ -218,7 +218,7 @@ static int brcms_c_antsel_cfgupd(struct antsel_info *asi,
 	 */
 	ant_cfg = antsel->ant_config[ANT_SELCFG_RX_DEF];
 	mimo_antsel = brcms_c_antsel_antcfg2antsel(asi, ant_cfg);
-	brcms_c_write_shm(wlc, M_MIMO_ANTSEL_RXDFLT, mimo_antsel);
+	brcms_b_write_shm(wlc->hw, M_MIMO_ANTSEL_RXDFLT, mimo_antsel);
 	/*
 	 * Update driver stats for currently selected
 	 * default tx/rx antenna config
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 9988e03..5d3bfda 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -3104,17 +3104,26 @@ brcms_b_write_objmem(struct brcms_hardware *wlc_hw, uint offset, u16 v,
 		W_REG(objdata_lo, v);
 }
 
+/*
+ * Read a single u16 from shared memory.
+ * SHM 'offset' needs to be an even address
+ */
 u16 brcms_b_read_shm(struct brcms_hardware *wlc_hw, uint offset)
 {
 	return brcms_b_read_objmem(wlc_hw, offset, OBJADDR_SHM_SEL);
 }
 
+/*
+ * Write a single u16 to shared memory.
+ * SHM 'offset' needs to be an even address
+ */
 void brcms_b_write_shm(struct brcms_hardware *wlc_hw, uint offset, u16 v)
 {
 	brcms_b_write_objmem(wlc_hw, offset, v, OBJADDR_SHM_SEL);
 }
 
-/* Copy a buffer to shared memory of specified type .
+/*
+ * Copy a buffer to shared memory of specified type .
  * SHM 'offset' needs to be an even address and
  * Buffer length 'len' must be an even number of bytes
  * 'sel' selects the type of memory
@@ -3136,7 +3145,8 @@ brcms_b_copyto_objmem(struct brcms_hardware *wlc_hw, uint offset,
 	}
 }
 
-/* Copy a piece of shared memory of specified type to a buffer .
+/*
+ * Copy a piece of shared memory of specified type to a buffer .
  * SHM 'offset' needs to be an even address and
  * Buffer length 'len' must be an even number of bytes
  * 'sel' selects the type of memory
@@ -3627,7 +3637,8 @@ static void brcms_c_ucode_mac_upd(struct brcms_c_info *wlc)
 			 * inits to populate a bogus beacon.
 			 */
 			if (BRCMS_PHY_11N_CAP(wlc->band))
-				brcms_c_write_shm(wlc, M_BCN_TXTSF_OFFSET, 0);
+				brcms_b_write_shm(wlc->hw,
+						M_BCN_TXTSF_OFFSET, 0);
 		}
 	} else {
 		/* disable an active IBSS if we are not on the home channel */
@@ -3673,7 +3684,7 @@ brcms_c_duty_cycle_set(struct brcms_c_info *wlc, int duty_cycle, bool isOFDM,
 		idle_busy_ratio_x_16 = (100 - duty_cycle) * 16 / duty_cycle;
 	/* Only write to shared memory  when wl is up */
 	if (writeToShm)
-		brcms_c_write_shm(wlc, offset, (u16) idle_busy_ratio_x_16);
+		brcms_b_write_shm(wlc->hw, offset, (u16) idle_busy_ratio_x_16);
 
 	if (isOFDM)
 		wlc->tx_duty_cycle_ofdm = (u16) duty_cycle;
@@ -3766,10 +3777,10 @@ void brcms_c_init(struct brcms_c_info *wlc)
 	brcms_c_bandinit_ordered(wlc, chanspec);
 
 	/* init probe response timeout */
-	brcms_c_write_shm(wlc, M_PRS_MAXTIME, wlc->prb_resp_timeout);
+	brcms_b_write_shm(wlc->hw, M_PRS_MAXTIME, wlc->prb_resp_timeout);
 
 	/* init max burst txop (framebursting) */
-	brcms_c_write_shm(wlc, M_MBURST_TXOP,
+	brcms_b_write_shm(wlc->hw, M_MBURST_TXOP,
 		      (wlc->
 		       _rifs ? (EDCF_AC_VO_TXOP_AP << 5) : MAXFRAMEBURST_TXOP));
 
@@ -3796,8 +3807,8 @@ void brcms_c_init(struct brcms_c_info *wlc)
 	/* read the ucode version if we have not yet done so */
 	if (wlc->ucode_rev == 0) {
 		wlc->ucode_rev =
-		    brcms_c_read_shm(wlc, M_BOM_REV_MAJOR) << NBITS(u16);
-		wlc->ucode_rev |= brcms_c_read_shm(wlc, M_BOM_REV_MINOR);
+		    brcms_b_read_shm(wlc->hw, M_BOM_REV_MAJOR) << NBITS(u16);
+		wlc->ucode_rev |= brcms_b_read_shm(wlc->hw, M_BOM_REV_MINOR);
 	}
 
 	/* ..now really unleash hell (allow the MAC out of suspend) */
@@ -3822,7 +3833,7 @@ void brcms_c_init(struct brcms_c_info *wlc)
 
 		for (ac = 0; ac < AC_COUNT; ac++)
 			wlc->wme_retries[ac] =
-			    brcms_c_read_shm(wlc, M_AC_TXLMT_ADDR(ac));
+			    brcms_b_read_shm(wlc->hw, M_AC_TXLMT_ADDR(ac));
 	}
 }
 
@@ -4110,9 +4121,9 @@ void brcms_c_beacon_phytxctl_txant_upd(struct brcms_c_info *wlc,
 	if (BRCMS_PHY_11N_CAP(wlc->band))
 		phytxant = brcms_c_stf_phytxchain_sel(wlc, bcn_rspec);
 
-	phyctl = brcms_c_read_shm(wlc, M_BCN_PCTLWD);
+	phyctl = brcms_b_read_shm(wlc->hw, M_BCN_PCTLWD);
 	phyctl = (phyctl & ~mask) | phytxant;
-	brcms_c_write_shm(wlc, M_BCN_PCTLWD, phyctl);
+	brcms_b_write_shm(wlc->hw, M_BCN_PCTLWD, phyctl);
 }
 
 /*
@@ -4223,7 +4234,7 @@ void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 		    R_REG(&wlc->regs->tsf_random) & acp_shm.cwcur;
 		acp_shm.reggap = acp_shm.bslots + acp_shm.aifs;
 		/* Indicate the new params to the ucode */
-		acp_shm.status = brcms_c_read_shm(wlc, (M_EDCF_QINFO +
+		acp_shm.status = brcms_b_read_shm(wlc->hw, (M_EDCF_QINFO +
 						  wme_ac2fifo[aci] *
 						  M_EDCF_QLEN +
 						  M_EDCF_STATUS_OFF));
@@ -4232,7 +4243,7 @@ void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 		/* Fill in shm acparam table */
 		shm_entry = (u16 *) &acp_shm;
 		for (i = 0; i < (int)sizeof(struct shm_acparams); i += 2)
-			brcms_c_write_shm(wlc,
+			brcms_b_write_shm(wlc->hw,
 					  M_EDCF_QINFO +
 					  wme_ac2fifo[aci] * M_EDCF_QLEN + i,
 					  *shm_entry++);
@@ -5642,7 +5653,7 @@ static void brcms_c_wme_retries_write(struct brcms_c_info *wlc)
 		return;
 
 	for (ac = 0; ac < AC_COUNT; ac++)
-		brcms_c_write_shm(wlc, M_AC_TXLMT_ADDR(ac),
+		brcms_b_write_shm(wlc->hw, M_AC_TXLMT_ADDR(ac),
 				  wlc->wme_retries[ac]);
 }
 
@@ -7955,9 +7966,9 @@ void brcms_c_bcn_li_upd(struct brcms_c_info *wlc)
 {
 	/* wake up every DTIM is the default */
 	if (wlc->bcn_li_dtim == 1)
-		brcms_c_write_shm(wlc, M_BCN_LI, 0);
+		brcms_b_write_shm(wlc->hw, M_BCN_LI, 0);
 	else
-		brcms_c_write_shm(wlc, M_BCN_LI,
+		brcms_b_write_shm(wlc->hw, M_BCN_LI,
 			      (wlc->bcn_li_dtim << 8) | wlc->bcn_li_bcn);
 }
 
@@ -8453,12 +8464,12 @@ static void brcms_c_write_rate_shm(struct brcms_c_info *wlc, u8 rate,
 	/* Find the SHM pointer to the ACK rate entry by looking in the
 	 * Direct-map Table
 	 */
-	basic_ptr = brcms_c_read_shm(wlc, (dir_table + basic_index * 2));
+	basic_ptr = brcms_b_read_shm(wlc->hw, (dir_table + basic_index * 2));
 
 	/* Update the SHM BSS-basic-rate-set mapping table with the pointer
 	 * to the correct basic rate for the given incoming rate
 	 */
-	brcms_c_write_shm(wlc, (basic_table + index * 2), basic_ptr);
+	brcms_b_write_shm(wlc->hw, (basic_table + index * 2), basic_ptr);
 }
 
 static const struct brcms_c_rateset *
@@ -8584,11 +8595,11 @@ void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
 		dur += sifs;
 
 		/* Update the SHM Rate Table entry Probe Response values */
-		brcms_c_write_shm(wlc, entry_ptr + M_RT_PRS_PLCP_POS,
+		brcms_b_write_shm(wlc->hw, entry_ptr + M_RT_PRS_PLCP_POS,
 			      (u16) (plcp[0] + (plcp[1] << 8)));
-		brcms_c_write_shm(wlc, entry_ptr + M_RT_PRS_PLCP_POS + 2,
+		brcms_b_write_shm(wlc->hw, entry_ptr + M_RT_PRS_PLCP_POS + 2,
 			      (u16) (plcp[2] + (plcp[3] << 8)));
-		brcms_c_write_shm(wlc, entry_ptr + M_RT_PRS_DUR_POS, dur);
+		brcms_b_write_shm(wlc->hw, entry_ptr + M_RT_PRS_DUR_POS, dur);
 	}
 }
 
@@ -8684,7 +8695,7 @@ void brcms_c_shm_ssid_upd(struct brcms_c_info *wlc, struct brcms_bss_cfg *cfg)
 	memcpy(ssidbuf, ssidptr, cfg->SSID_len);
 
 	brcms_c_copyto_shm(wlc, base, ssidbuf, IEEE80211_MAX_SSID_LEN);
-	brcms_c_write_shm(wlc, M_SSIDLEN, (u16) cfg->SSID_len);
+	brcms_b_write_shm(wlc->hw, M_SSIDLEN, (u16) cfg->SSID_len);
 }
 
 void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
@@ -8721,7 +8732,7 @@ brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
 				    (len + 3) & ~3, prb_resp);
 
 	/* write the length of the probe response frame (+PLCP/-FCS) */
-	brcms_c_write_shm(wlc, M_PRB_RESP_FRM_LEN, (u16) len);
+	brcms_b_write_shm(wlc->hw, M_PRB_RESP_FRM_LEN, (u16) len);
 
 	/* write the SSID and SSID length */
 	brcms_c_shm_ssid_upd(wlc, cfg);
@@ -8777,22 +8788,6 @@ void brcms_default_rateset(struct brcms_c_info *wlc, struct brcms_c_rateset *rs)
 		wlc->stf->txstreams);
 }
 
-/* Read a single u16 from shared memory.
- * SHM 'offset' needs to be an even address
- */
-u16 brcms_c_read_shm(struct brcms_c_info *wlc, uint offset)
-{
-	return brcms_b_read_shm(wlc->hw, offset);
-}
-
-/* Write a single u16 to shared memory.
- * SHM 'offset' needs to be an even address
- */
-void brcms_c_write_shm(struct brcms_c_info *wlc, uint offset, u16 v)
-{
-	brcms_b_write_shm(wlc->hw, offset, v);
-}
-
 /* Copy a buffer to shared memory.
  * SHM 'offset' needs to be an even address and
  * Buffer length 'len' must be an even number of bytes
@@ -8800,12 +8795,7 @@ void brcms_c_write_shm(struct brcms_c_info *wlc, uint offset, u16 v)
 void brcms_c_copyto_shm(struct brcms_c_info *wlc, uint offset, const void *buf,
 			int len)
 {
-	/* offset and len need to be even */
-	if (len <= 0 || (offset & 1) || (len & 1))
-		return;
-
 	brcms_b_copyto_objmem(wlc->hw, offset, buf, len, OBJADDR_SHM_SEL);
-
 }
 
 /* wrapper BMAC functions to for HIGH driver access */
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 5a2ec53..6512e7a 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -732,8 +732,6 @@ extern void brcms_c_inval_dma_pkts(struct brcms_hardware *hw,
 			       void (*dma_callback_fn));
 
 /* Shared memory access */
-extern void brcms_c_write_shm(struct brcms_c_info *wlc, uint offset, u16 v);
-extern u16 brcms_c_read_shm(struct brcms_c_info *wlc, uint offset);
 extern void brcms_c_copyto_shm(struct brcms_c_info *wlc, uint offset,
 			       const void *buf, int len);
 
-- 
1.7.4.1


