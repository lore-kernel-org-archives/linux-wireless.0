Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3107 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab1HHN7a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 15/82] staging: brcm80211: replaced typedef
 wlc_rateset_t
Date: Mon, 8 Aug 2011 15:57:59 +0200
Message-ID: <1312811946-16713-16-git-send-email-arend@broadcom.com> (sfid-20110808_160143_380791_BDCE07B4)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

By struct brcms_c_rateset. Struct brcms_c_rateset was renamed from
brcms_rateset, because there will be two rateset related structures that
should differ significantly in naming from each other. Struct wl_rateset
will be renamed to struct brcm_rateset in the next patch.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c  |   55 +++++++++++++++-------------
 drivers/staging/brcm80211/brcmsmac/main.h  |   14 ++++----
 drivers/staging/brcm80211/brcmsmac/pub.h   |    9 +++--
 drivers/staging/brcm80211/brcmsmac/rate.c  |   50 +++++++++++++------------
 drivers/staging/brcm80211/brcmsmac/rate.h  |   41 +++++++++++----------
 drivers/staging/brcm80211/brcmsmac/types.h |    1 -
 6 files changed, 89 insertions(+), 81 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 252cd3b..038115b 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -381,7 +381,8 @@ static void brcms_c_tx_prec_map_init(struct brcms_c_info *wlc);
 static void brcms_c_watchdog(void *arg);
 static void brcms_c_watchdog_by_timer(void *arg);
 static u16 brcms_c_rate_shm_offset(struct brcms_c_info *wlc, u8 rate);
-static int brcms_c_set_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs_arg);
+static int brcms_c_set_rateset(struct brcms_c_info *wlc,
+			       struct brcms_c_rateset *rs_arg);
 static u8 brcms_c_local_constraint_qdbm(struct brcms_c_info *wlc);
 
 /* send and receive */
@@ -3720,7 +3721,7 @@ void brcms_c_set_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 }
 
 u32 brcms_c_lowest_basic_rspec(struct brcms_c_info *wlc,
-				      wlc_rateset_t *rs)
+				      struct brcms_c_rateset *rs)
 {
 	u32 lowest_basic_rspec;
 	uint i;
@@ -3876,7 +3877,7 @@ static void brcms_c_ucode_mac_upd(struct brcms_c_info *wlc)
 static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
 				     u16 chanspec)
 {
-	wlc_rateset_t default_rateset;
+	struct brcms_c_rateset default_rateset;
 	uint parkband;
 	uint i, band_order[2];
 
@@ -5711,7 +5712,7 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 {
 	int ret = 0;
 	uint i;
-	wlc_rateset_t rs;
+	struct brcms_c_rateset rs;
 	/* Default to 54g Auto */
 	/* Advertise and use shortslot (-1/0/1 Auto/Off/On) */
 	s8 shortslot = BRCMS_SHORTSLOT_AUTO;
@@ -5750,10 +5751,10 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 		brcms_c_protection_upd(wlc, BRCMS_PROT_G_USER, gmode);
 
 	/* Clear supported rates filter */
-	memset(&wlc->sup_rates_override, 0, sizeof(wlc_rateset_t));
+	memset(&wlc->sup_rates_override, 0, sizeof(struct brcms_c_rateset));
 
 	/* Clear rateset override */
-	memset(&rs, 0, sizeof(wlc_rateset_t));
+	memset(&rs, 0, sizeof(struct brcms_c_rateset));
 
 	switch (gmode) {
 	case GMODE_LEGACY_B:
@@ -5938,12 +5939,13 @@ int brcms_c_set_nmode(struct brcms_c_info *wlc, s32 nmode)
 	return err;
 }
 
-static int brcms_c_set_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs_arg)
+static int
+brcms_c_set_rateset(struct brcms_c_info *wlc, struct brcms_c_rateset *rs_arg)
 {
-	wlc_rateset_t rs, new;
+	struct brcms_c_rateset rs, new;
 	uint bandunit;
 
-	memcpy(&rs, rs_arg, sizeof(wlc_rateset_t));
+	memcpy(&rs, rs_arg, sizeof(struct brcms_c_rateset));
 
 	/* check for bad count value */
 	if ((rs.count == 0) || (rs.count > BRCMS_NUMRATES))
@@ -5951,7 +5953,7 @@ static int brcms_c_set_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs_arg)
 
 	/* try the current band */
 	bandunit = wlc->band->bandunit;
-	memcpy(&new, &rs, sizeof(wlc_rateset_t));
+	memcpy(&new, &rs, sizeof(struct brcms_c_rateset));
 	if (brcms_c_rate_hwrs_filter_sort_validate
 	    (&new, &wlc->bandstate[bandunit]->hw_rateset, true,
 	     wlc->stf->txstreams))
@@ -5960,7 +5962,7 @@ static int brcms_c_set_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs_arg)
 	/* try the other band */
 	if (IS_MBAND_UNLOCKED(wlc)) {
 		bandunit = OTHERBANDUNIT(wlc);
-		memcpy(&new, &rs, sizeof(wlc_rateset_t));
+		memcpy(&new, &rs, sizeof(struct brcms_c_rateset));
 		if (brcms_c_rate_hwrs_filter_sort_validate(&new,
 						       &wlc->
 						       bandstate[bandunit]->
@@ -5973,9 +5975,10 @@ static int brcms_c_set_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs_arg)
 
  good:
 	/* apply new rateset */
-	memcpy(&wlc->default_bss->rateset, &new, sizeof(wlc_rateset_t));
+	memcpy(&wlc->default_bss->rateset, &new,
+	       sizeof(struct brcms_c_rateset));
 	memcpy(&wlc->bandstate[bandunit]->defrateset, &new,
-	       sizeof(wlc_rateset_t));
+	       sizeof(struct brcms_c_rateset));
 	return 0;
 }
 
@@ -6132,7 +6135,7 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 
 	case BRCM_GET_CURR_RATESET:{
 			wl_rateset_t *ret_rs = (wl_rateset_t *) arg;
-			wlc_rateset_t *rs;
+			struct brcms_c_rateset *rs;
 
 			if (wlc->pub->associated)
 				rs = &current_bss->rateset;
@@ -6151,7 +6154,7 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 		}
 
 	case BRCM_SET_RATESET:{
-			wlc_rateset_t rs;
+			struct brcms_c_rateset rs;
 			wl_rateset_t *in_rs = (wl_rateset_t *) arg;
 
 			if (len < (int)(in_rs->count + sizeof(in_rs->count))) {
@@ -6164,7 +6167,7 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 				break;
 			}
 
-			memset(&rs, 0, sizeof(wlc_rateset_t));
+			memset(&rs, 0, sizeof(struct brcms_c_rateset));
 
 			/* Copy only legacy rateset section */
 			rs.count = in_rs->count;
@@ -8486,7 +8489,8 @@ brcms_c_calc_cts_time(struct brcms_c_info *wlc, u32 rspec,
 }
 
 /* derive wlc->band->basic_rate[] table from 'rateset' */
-void brcms_c_rate_lookup_init(struct brcms_c_info *wlc, wlc_rateset_t *rateset)
+void brcms_c_rate_lookup_init(struct brcms_c_info *wlc,
+			      struct brcms_c_rateset *rateset)
 {
 	u8 rate;
 	u8 mandatory;
@@ -8610,9 +8614,10 @@ static void brcms_c_write_rate_shm(struct brcms_c_info *wlc, u8 rate,
 	brcms_c_write_shm(wlc, (basic_table + index * 2), basic_ptr);
 }
 
-static const wlc_rateset_t *brcms_c_rateset_get_hwrs(struct brcms_c_info *wlc)
+static const struct brcms_c_rateset *
+brcms_c_rateset_get_hwrs(struct brcms_c_info *wlc)
 {
-	const wlc_rateset_t *rs_dflt;
+	const struct brcms_c_rateset *rs_dflt;
 
 	if (BRCMS_PHY_11N_CAP(wlc->band)) {
 		if (BAND_5G(wlc->band->bandtype))
@@ -8629,8 +8634,8 @@ static const wlc_rateset_t *brcms_c_rateset_get_hwrs(struct brcms_c_info *wlc)
 
 void brcms_c_set_ratetable(struct brcms_c_info *wlc)
 {
-	const wlc_rateset_t *rs_dflt;
-	wlc_rateset_t rs;
+	const struct brcms_c_rateset *rs_dflt;
+	struct brcms_c_rateset rs;
 	u8 rate, basic_rate;
 	uint i;
 
@@ -8665,7 +8670,7 @@ void brcms_c_set_ratetable(struct brcms_c_info *wlc)
 bool brcms_c_valid_rate(struct brcms_c_info *wlc, u32 rspec, int band,
 		    bool verbose)
 {
-	wlc_rateset_t *hw_rateset;
+	struct brcms_c_rateset *hw_rateset;
 	uint i;
 
 	if ((band == BRCM_BAND_AUTO) || (band == wlc->band->bandtype)) {
@@ -8723,8 +8728,8 @@ static void brcms_c_update_mimo_band_bwcap(struct brcms_c_info *wlc, u8 bwcap)
 
 void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
 {
-	const wlc_rateset_t *rs_dflt;
-	wlc_rateset_t rs;
+	const struct brcms_c_rateset *rs_dflt;
+	struct brcms_c_rateset rs;
 	u8 rate;
 	u16 entry_ptr;
 	u8 plcp[D11_PHY_HDR_LEN];
@@ -9037,7 +9042,7 @@ void brcms_c_bsscfg_reprate_init(struct brcms_bss_cfg *bsscfg)
 	memset((char *)bsscfg->txrspec, 0, sizeof(bsscfg->txrspec));
 }
 
-void brcms_default_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs)
+void brcms_default_rateset(struct brcms_c_info *wlc, struct brcms_c_rateset *rs)
 {
 	brcms_c_rateset_default(rs, NULL, wlc->band->phytype,
 		wlc->band->bandtype, false, BRCMS_RATE_MASK_FULL,
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 1feefcf..8cbb2d6 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -392,13 +392,15 @@ struct brcms_band {
 
 	struct scb *hwrs_scb;	/* permanent scb for hw rateset */
 
-	wlc_rateset_t defrateset;	/* band-specific copy of default_bss.rateset */
+	/* band-specific copy of default_bss.rateset */
+	struct brcms_c_rateset defrateset;
 
 	u32 rspec_override;	/* 802.11 rate override */
 	u32 mrspec_override;	/* multicast rate override */
 	u8 band_stf_ss_mode;	/* Configured STF type, 0:siso; 1:cdd */
 	s8 band_stf_stbc_tx;	/* STBC TX 0:off; 1:force on; -1:auto */
-	wlc_rateset_t hw_rateset;	/* rates supported by chip (phy-specific) */
+	/* rates supported by chip (phy-specific) */
+	struct brcms_c_rateset hw_rateset;
 	u8 basic_rate[BRCM_MAXRATE + 1]; /* basic rates indexed by rate */
 	bool mimo_cap_40;	/* 40 MHz cap enabled on this band */
 	s8 antgain;		/* antenna gain from srom */
@@ -751,10 +753,8 @@ struct brcms_c_info {
 	u16 prb_resp_timeout;	/* do not send prb resp if request older than this,
 					 * 0 = disable
 					 */
-
-	wlc_rateset_t sup_rates_override;	/* use only these rates in 11g supported rates if
-						 * specifed
-						 */
+	/* use only these rates in 11g supported rates if specified */
+	struct brcms_c_rateset sup_rates_override;
 
 	u16 home_chanspec;	/* shared home chanspec */
 
@@ -1040,7 +1040,7 @@ extern void brcms_c_beacon_phytxctl_txant_upd(struct brcms_c_info *wlc,
 extern void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc,
 					   uint frame_len);
 extern u32 brcms_c_lowest_basic_rspec(struct brcms_c_info *wlc,
-					     wlc_rateset_t *rs);
+					     struct brcms_c_rateset *rs);
 extern void brcms_c_radio_disable(struct brcms_c_info *wlc);
 extern void brcms_c_bcn_li_upd(struct brcms_c_info *wlc);
 extern void brcms_c_set_home_chanspec(struct brcms_c_info *wlc,
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index a5d91df..9b847b3 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -125,7 +125,7 @@ struct brcms_tunables {
 	int memreserved;	/* memory reserved for BMAC's USB dma rx */
 };
 
-struct brcms_rateset {
+struct brcms_c_rateset {
 	uint count;		/* number of rates in rates[] */
 	 /* rates in 500kbps units w/hi bit set if basic */
 	u8 rates[BRCMS_NUMRATES];
@@ -173,7 +173,7 @@ struct brcms_bss_info {
 	u16 atim_window;	/* units are Kusec */
 	u16 chanspec;	/* Channel num, bw, ctrl_sb and band */
 	s8 infra;		/* 0=IBSS, 1=infrastructure, 2=unknown */
-	wlc_rateset_t rateset;	/* supported rates */
+	struct brcms_c_rateset rateset;	/* supported rates */
 	u8 dtim_period;	/* DTIM period */
 	s8 phy_noise;		/* noise right after tx (in dBm) */
 	u16 capability;	/* Capability information */
@@ -592,8 +592,9 @@ extern struct brcms_pub *brcms_c_pub(void *wlc);
 extern void brcms_c_mhf(struct brcms_c_info *wlc, u8 idx, u16 mask, u16 val,
 		    int bands);
 extern void brcms_c_rate_lookup_init(struct brcms_c_info *wlc,
-				     wlc_rateset_t *rateset);
-extern void brcms_default_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs);
+				     struct brcms_c_rateset *rateset);
+extern void brcms_default_rateset(struct brcms_c_info *wlc,
+				  struct brcms_c_rateset *rs);
 
 extern void brcms_c_ampdu_flush(struct brcms_c_info *wlc,
 			    struct ieee80211_sta *sta, u16 tid);
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.c b/drivers/staging/brcm80211/brcmsmac/rate.c
index dac285e..86d47c8 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/rate.c
@@ -179,7 +179,7 @@ legacy_phycfg legacy_phycfg_table[LEGACY_PHYCFG_TABLE_SIZE] = {
 
 /* Hardware rates (also encodes default basic rates) */
 
-const wlc_rateset_t cck_ofdm_mimo_rates = {
+const struct brcms_c_rateset cck_ofdm_mimo_rates = {
 	12,
 	{			/*    1b,   2b,   5.5b, 6,    9,    11b,  12,   18,   24,   36,   48,   54 Mbps */
 	 0x82, 0x84, 0x8b, 0x0c, 0x12, 0x96, 0x18, 0x24, 0x30, 0x48, 0x60,
@@ -189,7 +189,7 @@ const wlc_rateset_t cck_ofdm_mimo_rates = {
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-const wlc_rateset_t ofdm_mimo_rates = {
+const struct brcms_c_rateset ofdm_mimo_rates = {
 	8,
 	{			/*    6b,   9,    12b,  18,   24b,  36,   48,   54 Mbps */
 	 0x8c, 0x12, 0x98, 0x24, 0xb0, 0x48, 0x60, 0x6c},
@@ -199,7 +199,7 @@ const wlc_rateset_t ofdm_mimo_rates = {
 };
 
 /* Default ratesets that include MCS32 for 40BW channels */
-const wlc_rateset_t cck_ofdm_40bw_mimo_rates = {
+const struct brcms_c_rateset cck_ofdm_40bw_mimo_rates = {
 	12,
 	{			/*    1b,   2b,   5.5b, 6,    9,    11b,  12,   18,   24,   36,   48,   54 Mbps */
 	 0x82, 0x84, 0x8b, 0x0c, 0x12, 0x96, 0x18, 0x24, 0x30, 0x48, 0x60,
@@ -209,7 +209,7 @@ const wlc_rateset_t cck_ofdm_40bw_mimo_rates = {
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-const wlc_rateset_t ofdm_40bw_mimo_rates = {
+const struct brcms_c_rateset ofdm_40bw_mimo_rates = {
 	8,
 	{			/*    6b,   9,    12b,  18,   24b,  36,   48,   54 Mbps */
 	 0x8c, 0x12, 0x98, 0x24, 0xb0, 0x48, 0x60, 0x6c},
@@ -218,7 +218,7 @@ const wlc_rateset_t ofdm_40bw_mimo_rates = {
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-const wlc_rateset_t cck_ofdm_rates = {
+const struct brcms_c_rateset cck_ofdm_rates = {
 	12,
 	{			/*    1b,   2b,   5.5b, 6,    9,    11b,  12,   18,   24,   36,   48,   54 Mbps */
 	 0x82, 0x84, 0x8b, 0x0c, 0x12, 0x96, 0x18, 0x24, 0x30, 0x48, 0x60,
@@ -228,7 +228,7 @@ const wlc_rateset_t cck_ofdm_rates = {
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-const wlc_rateset_t gphy_legacy_rates = {
+const struct brcms_c_rateset gphy_legacy_rates = {
 	4,
 	{			/*    1b,   2b,   5.5b,  11b Mbps */
 	 0x82, 0x84, 0x8b, 0x96},
@@ -237,7 +237,7 @@ const wlc_rateset_t gphy_legacy_rates = {
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-const wlc_rateset_t ofdm_rates = {
+const struct brcms_c_rateset ofdm_rates = {
 	8,
 	{			/*    6b,   9,    12b,  18,   24b,  36,   48,   54 Mbps */
 	 0x8c, 0x12, 0x98, 0x24, 0xb0, 0x48, 0x60, 0x6c},
@@ -246,7 +246,7 @@ const wlc_rateset_t ofdm_rates = {
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-const wlc_rateset_t cck_rates = {
+const struct brcms_c_rateset cck_rates = {
 	4,
 	{			/*    1b,   2b,   5.5,  11 Mbps */
 	 0x82, 0x84, 0x0b, 0x16},
@@ -258,7 +258,7 @@ const wlc_rateset_t cck_rates = {
 /* check if rateset is valid.
  * if check_brate is true, rateset without a basic rate is considered NOT valid.
  */
-static bool brcms_c_rateset_valid(wlc_rateset_t *rs, bool check_brate)
+static bool brcms_c_rateset_valid(struct brcms_c_rateset *rs, bool check_brate)
 {
 	uint idx;
 
@@ -276,7 +276,7 @@ static bool brcms_c_rateset_valid(wlc_rateset_t *rs, bool check_brate)
 	return false;
 }
 
-void brcms_c_rateset_mcs_upd(wlc_rateset_t *rs, u8 txstreams)
+void brcms_c_rateset_mcs_upd(struct brcms_c_rateset *rs, u8 txstreams)
 {
 	int i;
 	for (i = txstreams; i < MAX_STREAMS_SUPPORTED; i++)
@@ -287,8 +287,8 @@ void brcms_c_rateset_mcs_upd(wlc_rateset_t *rs, u8 txstreams)
  * and check if resulting rateset is valid.
 */
 bool
-brcms_c_rate_hwrs_filter_sort_validate(wlc_rateset_t *rs,
-				   const wlc_rateset_t *hw_rs,
+brcms_c_rate_hwrs_filter_sort_validate(struct brcms_c_rateset *rs,
+				   const struct brcms_c_rateset *hw_rs,
 				   bool check_brate, u8 txstreams)
 {
 	u8 rateset[BRCM_MAXRATE + 1];
@@ -377,9 +377,10 @@ u32 brcms_c_compute_rspec(struct d11rxhdr *rxh, u8 *plcp)
 }
 
 /* copy rateset src to dst as-is (no masking or sorting) */
-void brcms_c_rateset_copy(const wlc_rateset_t *src, wlc_rateset_t *dst)
+void brcms_c_rateset_copy(const struct brcms_c_rateset *src,
+			  struct brcms_c_rateset *dst)
 {
-	memcpy(dst, src, sizeof(wlc_rateset_t));
+	memcpy(dst, src, sizeof(struct brcms_c_rateset));
 }
 
 /*
@@ -392,8 +393,8 @@ void brcms_c_rateset_copy(const wlc_rateset_t *src, wlc_rateset_t *dst)
  * 'xmask' is the copy mask (typically 0x7f or 0xff).
  */
 void
-brcms_c_rateset_filter(wlc_rateset_t *src, wlc_rateset_t *dst, bool basic_only,
-		   u8 rates, uint xmask, bool mcsallow)
+brcms_c_rateset_filter(struct brcms_c_rateset *src, struct brcms_c_rateset *dst,
+		       bool basic_only, u8 rates, uint xmask, bool mcsallow)
 {
 	uint i;
 	uint r;
@@ -423,12 +424,13 @@ brcms_c_rateset_filter(wlc_rateset_t *src, wlc_rateset_t *dst, bool basic_only,
  * and fill rs_tgt with result
  */
 void
-brcms_c_rateset_default(wlc_rateset_t *rs_tgt, const wlc_rateset_t *rs_hw,
-		    uint phy_type, int bandtype, bool cck_only, uint rate_mask,
-		    bool mcsallow, u8 bw, u8 txstreams)
+brcms_c_rateset_default(struct brcms_c_rateset *rs_tgt,
+			const struct brcms_c_rateset *rs_hw,
+			uint phy_type, int bandtype, bool cck_only,
+			uint rate_mask, bool mcsallow, u8 bw, u8 txstreams)
 {
-	const wlc_rateset_t *rs_dflt;
-	wlc_rateset_t rs_sel;
+	const struct brcms_c_rateset *rs_dflt;
+	struct brcms_c_rateset rs_sel;
 	if ((PHYTYPE_IS(phy_type, PHY_TYPE_HT)) ||
 	    (PHYTYPE_IS(phy_type, PHY_TYPE_N)) ||
 	    (PHYTYPE_IS(phy_type, PHY_TYPE_LCN)) ||
@@ -475,21 +477,21 @@ s16 brcms_c_rate_legacy_phyctl(uint rate)
 	return -1;
 }
 
-void brcms_c_rateset_mcs_clear(wlc_rateset_t *rateset)
+void brcms_c_rateset_mcs_clear(struct brcms_c_rateset *rateset)
 {
 	uint i;
 	for (i = 0; i < MCSSET_LEN; i++)
 		rateset->mcs[i] = 0;
 }
 
-void brcms_c_rateset_mcs_build(wlc_rateset_t *rateset, u8 txstreams)
+void brcms_c_rateset_mcs_build(struct brcms_c_rateset *rateset, u8 txstreams)
 {
 	memcpy(&rateset->mcs[0], &cck_ofdm_mimo_rates.mcs[0], MCSSET_LEN);
 	brcms_c_rateset_mcs_upd(rateset, txstreams);
 }
 
 /* Based on bandwidth passed, allow/disallow MCS 32 in the rateset */
-void brcms_c_rateset_bw_mcs_filter(wlc_rateset_t *rateset, u8 bw)
+void brcms_c_rateset_bw_mcs_filter(struct brcms_c_rateset *rateset, u8 bw)
 {
 	if (bw == BRCMS_40_MHZ)
 		setbit(rateset->mcs, 32);
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.h b/drivers/staging/brcm80211/brcmsmac/rate.h
index 9903bb5..9fb187e 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.h
+++ b/drivers/staging/brcm80211/brcmsmac/rate.h
@@ -20,14 +20,14 @@
 #include "types.h"
 
 extern const u8 rate_info[];
-extern const struct brcms_rateset cck_ofdm_mimo_rates;
-extern const struct brcms_rateset ofdm_mimo_rates;
-extern const struct brcms_rateset cck_ofdm_rates;
-extern const struct brcms_rateset ofdm_rates;
-extern const struct brcms_rateset cck_rates;
-extern const struct brcms_rateset gphy_legacy_rates;
-extern const struct brcms_rateset wlc_lrs_rates;
-extern const struct brcms_rateset rate_limit_1_2;
+extern const struct brcms_c_rateset cck_ofdm_mimo_rates;
+extern const struct brcms_c_rateset ofdm_mimo_rates;
+extern const struct brcms_c_rateset cck_ofdm_rates;
+extern const struct brcms_c_rateset ofdm_rates;
+extern const struct brcms_c_rateset cck_rates;
+extern const struct brcms_c_rateset gphy_legacy_rates;
+extern const struct brcms_c_rateset wlc_lrs_rates;
+extern const struct brcms_c_rateset rate_limit_1_2;
 
 struct brcms_mcs_info {
 	u32 phy_rate_20;	/* phy rate in kbps [20Mhz] */
@@ -142,32 +142,33 @@ extern const u8 ofdm_rate_lookup[];
 
 /* sanitize, and sort a rateset with the basic bit(s) preserved, validate rateset */
 extern bool
-brcms_c_rate_hwrs_filter_sort_validate(struct brcms_rateset *rs,
-				       const struct brcms_rateset *hw_rs,
+brcms_c_rate_hwrs_filter_sort_validate(struct brcms_c_rateset *rs,
+				       const struct brcms_c_rateset *hw_rs,
 				       bool check_brate, u8 txstreams);
 /* copy rateset src to dst as-is (no masking or sorting) */
-extern void brcms_c_rateset_copy(const struct brcms_rateset *src,
-			     struct brcms_rateset *dst);
+extern void brcms_c_rateset_copy(const struct brcms_c_rateset *src,
+			     struct brcms_c_rateset *dst);
 
 /* would be nice to have these documented ... */
 extern u32 brcms_c_compute_rspec(struct d11rxhdr *rxh, u8 *plcp);
 
-extern void brcms_c_rateset_filter(struct brcms_rateset *src,
-	struct brcms_rateset *dst, bool basic_only, u8 rates, uint xmask,
+extern void brcms_c_rateset_filter(struct brcms_c_rateset *src,
+	struct brcms_c_rateset *dst, bool basic_only, u8 rates, uint xmask,
 	bool mcsallow);
 
 extern void
-brcms_c_rateset_default(struct brcms_rateset *rs_tgt,
-			const struct brcms_rateset *rs_hw, uint phy_type,
+brcms_c_rateset_default(struct brcms_c_rateset *rs_tgt,
+			const struct brcms_c_rateset *rs_hw, uint phy_type,
 			int bandtype, bool cck_only, uint rate_mask,
 			bool mcsallow, u8 bw, u8 txstreams);
 
 extern s16 brcms_c_rate_legacy_phyctl(uint rate);
 
-extern void brcms_c_rateset_mcs_upd(struct brcms_rateset *rs, u8 txstreams);
-extern void brcms_c_rateset_mcs_clear(struct brcms_rateset *rateset);
-extern void brcms_c_rateset_mcs_build(struct brcms_rateset *rateset,
+extern void brcms_c_rateset_mcs_upd(struct brcms_c_rateset *rs, u8 txstreams);
+extern void brcms_c_rateset_mcs_clear(struct brcms_c_rateset *rateset);
+extern void brcms_c_rateset_mcs_build(struct brcms_c_rateset *rateset,
 				      u8 txstreams);
-extern void brcms_c_rateset_bw_mcs_filter(struct brcms_rateset *rateset, u8 bw);
+extern void brcms_c_rateset_bw_mcs_filter(struct brcms_c_rateset *rateset,
+					  u8 bw);
 
 #endif				/* _BRCM_RATE_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index 23ce168..c70c9e6 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -385,7 +385,6 @@ typedef volatile struct fifo64 fifo64_t;
 typedef volatile struct d11regs d11regs_t;
 typedef volatile struct dma32diag dma32diag_t;
 typedef volatile struct dma64regs dma64regs_t;
-typedef struct brcms_rateset wlc_rateset_t;
 typedef volatile union pmqreg pmqreg_t;
 
 /* brcm_msg_level is a bit vector with defs in defs.h */
-- 
1.7.4.1


