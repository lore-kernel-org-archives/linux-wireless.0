Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2322 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab1ECJgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 13/61] staging: brcm80211: rename rate related
 definitions
Date: Tue, 3 May 2011 11:35:13 +0200
Message-ID: <1304415361-7813-14-git-send-email-arend@broadcom.com> (sfid-20110503_113846_121934_FD5D0B62)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added prefix WLC_ to the rate related definition.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c |   36 ++++++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/wlc_rate.c |    8 +++---
 drivers/staging/brcm80211/brcmsmac/wlc_rate.h |   17 +++++++-----
 4 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index 8c17518..558f71d 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -3752,7 +3752,7 @@ u16 wlc_bmac_rate_shm_offset(struct wlc_hw_info *wlc_hw, u8 rate)
 	/* for a given rate, the LS-nibble of the PLCP SIGNAL field is
 	 * the index into the rate table.
 	 */
-	phy_rate = rate_info[rate] & RATE_MASK;
+	phy_rate = rate_info[rate] & WLC_RATE_MASK;
 	index = phy_rate & 0xf;
 
 	/* Find the SHM pointer to the rate table entry by looking in the
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index c76d401..05ce854 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -1106,10 +1106,10 @@ ratespec_t wlc_lowest_basic_rspec(struct wlc_info *wlc, wlc_rateset_t *rs)
 	uint i;
 
 	/* Use the lowest basic rate */
-	lowest_basic_rspec = rs->rates[0] & RATE_MASK;
+	lowest_basic_rspec = rs->rates[0] & WLC_RATE_MASK;
 	for (i = 0; i < rs->count; i++) {
 		if (rs->rates[i] & WLC_RATE_FLAG) {
-			lowest_basic_rspec = rs->rates[i] & RATE_MASK;
+			lowest_basic_rspec = rs->rates[i] & WLC_RATE_MASK;
 			break;
 		}
 	}
@@ -1289,7 +1289,7 @@ static void wlc_bandinit_ordered(struct wlc_info *wlc, chanspec_t chanspec)
 
 		/* fill in hw_rate */
 		wlc_rateset_filter(&default_rateset, &wlc->band->hw_rateset,
-				   false, WLC_RATES_CCK_OFDM, RATE_MASK,
+				   false, WLC_RATES_CCK_OFDM, WLC_RATE_MASK,
 				   (bool) N_ENAB(wlc->pub));
 
 		/* init basic rate lookup */
@@ -1825,7 +1825,7 @@ void *wlc_attach(struct wl_info *wl, u16 vendor, u16 device, uint unit,
 		/* fill in hw_rateset (used early by WLC_SET_RATESET) */
 		wlc_rateset_filter(&wlc->band->defrateset,
 				   &wlc->band->hw_rateset, false,
-				   WLC_RATES_CCK_OFDM, RATE_MASK,
+				   WLC_RATES_CCK_OFDM, WLC_RATE_MASK,
 				   (bool) N_ENAB(wlc->pub));
 	}
 
@@ -3971,9 +3971,13 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 				break;
 			}
 
-			/* validate rateset by comparing pre and post sorted against 11g hw rates */
-			wlc_rateset_filter(&rs, &new, false, WLC_RATES_CCK_OFDM,
-					   RATE_MASK, BSS_N_ENAB(wlc, bsscfg));
+			/*
+			 * validate rateset by comparing pre and
+			 * post sorted against 11g hw rates
+			 */
+			wlc_rateset_filter(&rs, &new, false,
+					   WLC_RATES_CCK_OFDM, WLC_RATE_MASK,
+					   BSS_N_ENAB(wlc, bsscfg));
 			wlc_rate_hwrs_filter_sort_validate(&new,
 							   &cck_ofdm_rates,
 							   false,
@@ -5355,7 +5359,7 @@ wlc_compute_ofdm_plcp(ratespec_t rspec, u32 length, u8 *plcp)
 	ASSERT(IS_OFDM(rspec));
 
 	/* encode rate per 802.11a-1999 sec 17.3.4.1, with lsb transmitted first */
-	rate_signal = rate_info[rate] & RATE_MASK;
+	rate_signal = rate_info[rate] & WLC_RATE_MASK;
 	ASSERT(rate_signal != 0);
 
 	memset(plcp, 0, D11_PHY_HDR_LEN);
@@ -7272,7 +7276,7 @@ void wlc_rate_lookup_init(struct wlc_info *wlc, wlc_rateset_t *rateset)
 			continue;
 
 		/* mask off basic bit */
-		rate = (rateset->rates[i] & RATE_MASK);
+		rate = (rateset->rates[i] & WLC_RATE_MASK);
 
 		if (rate > WLC_MAXRATE) {
 			wiphy_err(wlc->wiphy, "wlc_rate_lookup_init: invalid "
@@ -7359,8 +7363,8 @@ static void wlc_write_rate_shm(struct wlc_info *wlc, u8 rate, u8 basic_rate)
 	 * for a given rate, the LS-nibble of the PLCP SIGNAL field is
 	 * the index into the rate table.
 	 */
-	phy_rate = rate_info[rate] & RATE_MASK;
-	basic_phy_rate = rate_info[basic_rate] & RATE_MASK;
+	phy_rate = rate_info[rate] & WLC_RATE_MASK;
+	basic_phy_rate = rate_info[basic_rate] & WLC_RATE_MASK;
 	index = phy_rate & 0xf;
 	basic_index = basic_phy_rate & 0xf;
 
@@ -7407,7 +7411,7 @@ void wlc_set_ratetable(struct wlc_info *wlc)
 
 	/* walk the phy rate table and update SHM basic rate lookup table */
 	for (i = 0; i < rs.count; i++) {
-		rate = rs.rates[i] & RATE_MASK;
+		rate = rs.rates[i] & WLC_RATE_MASK;
 
 		/* for a given rate WLC_BASIC_RATE returns the rate at
 		 * which a response ACK/CTS should be sent.
@@ -7417,7 +7421,7 @@ void wlc_set_ratetable(struct wlc_info *wlc)
 			/* This should only happen if we are using a
 			 * restricted rateset.
 			 */
-			basic_rate = rs.rates[0] & RATE_MASK;
+			basic_rate = rs.rates[0] & WLC_RATE_MASK;
 		}
 
 		wlc_write_rate_shm(wlc, rate, basic_rate);
@@ -7510,7 +7514,7 @@ void wlc_mod_prb_rsp_rate_table(struct wlc_info *wlc, uint frame_len)
 
 	/* walk the phy rate table and update MAC core SHM basic rate table entries */
 	for (i = 0; i < rs.count; i++) {
-		rate = rs.rates[i] & RATE_MASK;
+		rate = rs.rates[i] & WLC_RATE_MASK;
 
 		entry_ptr = wlc_rate_shm_offset(wlc, rate);
 
@@ -7874,7 +7878,7 @@ int wlc_get_revision_info(struct wlc_info *wlc, void *buf, uint len)
 void wlc_default_rateset(struct wlc_info *wlc, wlc_rateset_t *rs)
 {
 	wlc_rateset_default(rs, NULL, wlc->band->phytype, wlc->band->bandtype,
-			    false, RATE_MASK_FULL, (bool) N_ENAB(wlc->pub),
+			    false, WLC_RATE_MASK_FULL, (bool) N_ENAB(wlc->pub),
 			    CHSPEC_WLC_BW(wlc->default_bss->chanspec),
 			    wlc->stf->txstreams);
 }
@@ -7907,7 +7911,7 @@ static void wlc_bss_default_init(struct wlc_info *wlc)
 
 	/* init bss rates to the band specific default rate set */
 	wlc_rateset_default(&bi->rateset, NULL, band->phytype, band->bandtype,
-			    false, RATE_MASK_FULL, (bool) N_ENAB(wlc->pub),
+			    false, WLC_RATE_MASK_FULL, (bool) N_ENAB(wlc->pub),
 			    CHSPEC_WLC_BW(chanspec), wlc->stf->txstreams);
 
 	if (N_ENAB(wlc->pub))
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c b/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
index d284f1a..8c1b8f0 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
@@ -304,7 +304,7 @@ wlc_rate_hwrs_filter_sort_validate(wlc_rateset_t *rs,
 
 	for (i = 0; i < count; i++) {
 		/* mask off "basic rate" bit, WLC_RATE_FLAG */
-		r = (int)rs->rates[i] & RATE_MASK;
+		r = (int)rs->rates[i] & WLC_RATE_MASK;
 		if ((r > WLC_MAXRATE) || (rate_info[r] == 0)) {
 			continue;
 		}
@@ -314,7 +314,7 @@ wlc_rate_hwrs_filter_sort_validate(wlc_rateset_t *rs,
 	/* fill out the rates in order, looking at only supported rates */
 	count = 0;
 	for (i = 0; i < hw_rs->count; i++) {
-		r = hw_rs->rates[i] & RATE_MASK;
+		r = hw_rs->rates[i] & WLC_RATE_MASK;
 		ASSERT(r <= WLC_MAXRATE);
 		if (rateset[r])
 			rs->rates[count++] = rateset[r];
@@ -407,9 +407,9 @@ wlc_rateset_filter(wlc_rateset_t *src, wlc_rateset_t *dst, bool basic_only,
 		r = src->rates[i];
 		if (basic_only && !(r & WLC_RATE_FLAG))
 			continue;
-		if ((rates == WLC_RATES_CCK) && IS_OFDM((r & RATE_MASK)))
+		if ((rates == WLC_RATES_CCK) && IS_OFDM((r & WLC_RATE_MASK)))
 			continue;
-		if ((rates == WLC_RATES_OFDM) && IS_CCK((r & RATE_MASK)))
+		if ((rates == WLC_RATES_OFDM) && IS_CCK((r & WLC_RATE_MASK)))
 			continue;
 		dst->rates[count++] = r & xmask;
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_rate.h b/drivers/staging/brcm80211/brcmsmac/wlc_rate.h
index 25ba2a4..f406a79 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_rate.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_rate.h
@@ -54,11 +54,12 @@ extern const mcs_info_t mcs_table[];
 	(_is40 ? mcs_table[_mcs].phy_rate_40 : mcs_table[_mcs].phy_rate_20))
 #define VALID_MCS(_mcs)	((_mcs < MCS_TABLE_SIZE))
 
-#define	WLC_RATE_FLAG	0x80	/* Rate flag: basic or ofdm */
+/* rate related definitions */
+#define	WLC_RATE_FLAG	0x80	/* Rate flag to indicate it is a basic rate */
+#define	WLC_RATE_MASK	0x7f	/* Rate value mask w/o basic rate flag */
 
-/* Macros to use the rate_info table */
-#define	RATE_MASK	0x7f	/* Rate value mask w/o basic rate flag */
-#define	RATE_MASK_FULL	0xff	/* Rate value mask with basic rate flag */
+/* Macro to use in the rate_info table */
+#define	WLC_RATE_MASK_FULL	0xff /* Rate value mask with basic rate flag */
 
 #define WLC_RATE_500K_TO_BPS(rate)	((rate) * 500000)	/* convert 500kbps to bps */
 
@@ -115,9 +116,11 @@ typedef u32 ratespec_t;
 /* Rate info table; takes a legacy rate or ratespec_t */
 #define	IS_MCS(r)     	(r & RSPEC_MIMORATE)
 #define	IS_OFDM(r)     	(!IS_MCS(r) && (rate_info[(r) & RSPEC_RATE_MASK] & WLC_RATE_FLAG))
-#define	IS_CCK(r)	(!IS_MCS(r) && (((r) & RATE_MASK) == WLC_RATE_1M || \
-			 ((r) & RATE_MASK) == WLC_RATE_2M || \
-			 ((r) & RATE_MASK) == WLC_RATE_5M5 || ((r) & RATE_MASK) == WLC_RATE_11M))
+#define	IS_CCK(r)	(!IS_MCS(r) && ( \
+			 ((r) & WLC_RATE_MASK) == WLC_RATE_1M || \
+			 ((r) & WLC_RATE_MASK) == WLC_RATE_2M || \
+			 ((r) & WLC_RATE_MASK) == WLC_RATE_5M5 || \
+			 ((r) & WLC_RATE_MASK) == WLC_RATE_11M))
 #define IS_SINGLE_STREAM(mcs)	(((mcs) <= HIGHEST_SINGLE_STREAM_MCS) || ((mcs) == 32))
 #define CCK_RSPEC(cck)		((cck) & RSPEC_RATE_MASK)
 #define OFDM_RSPEC(ofdm)	(((ofdm) & RSPEC_RATE_MASK) |\
-- 
1.7.4.1


