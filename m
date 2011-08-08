Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1771 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162Ab1HHN7d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:33 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 14/82] staging: brcm80211: replaced various typedefs
Date: Mon, 8 Aug 2011 15:57:58 +0200
Message-ID: <1312811946-16713-15-git-send-email-arend@broadcom.com> (sfid-20110808_160108_418454_074F7B8E)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |    6 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   10 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |    4 +-
 drivers/staging/brcm80211/brcmsmac/ampdu.c       |    4 +-
 drivers/staging/brcm80211/brcmsmac/channel.c     |  111 ++++++++++---------
 drivers/staging/brcm80211/brcmsmac/channel.h     |   10 +-
 drivers/staging/brcm80211/brcmsmac/dma.c         |   36 ++++---
 drivers/staging/brcm80211/brcmsmac/main.c        |  123 +++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/main.h        |   54 +++++-----
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |   46 ++++----
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h |   26 +++---
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h |   34 +++---
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c |   12 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |   18 ++--
 drivers/staging/brcm80211/brcmsmac/pub.h         |    4 +-
 drivers/staging/brcm80211/brcmsmac/rate.c        |    4 +-
 drivers/staging/brcm80211/brcmsmac/rate.h        |    4 +-
 drivers/staging/brcm80211/brcmsmac/stf.c         |   10 +-
 drivers/staging/brcm80211/brcmsmac/stf.h         |    6 +-
 drivers/staging/brcm80211/brcmsmac/types.h       |    5 -
 drivers/staging/brcm80211/brcmutil/wifi.c        |    4 +-
 drivers/staging/brcm80211/include/brcmu_wifi.h   |   36 +++---
 22 files changed, 286 insertions(+), 281 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 82bf04d..537eb00 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -376,7 +376,7 @@ struct brcmf_bss_info {
 		uint count;	/* # rates in this set */
 		u8 rates[16];	/* rates in 500kbps units w/hi bit set if basic */
 	} rateset;		/* supported rates */
-	chanspec_t chanspec;	/* chanspec for bss */
+	u16 chanspec;	/* chanspec for bss */
 	u16 atim_window;	/* units are Kusec */
 	u8 dtim_period;	/* DTIM period */
 	s16 RSSI;		/* receive signal strength (in dBm) */
@@ -464,10 +464,10 @@ struct brcmf_assoc_params {
 	s32 chanspec_num;	/* 0: all available channels,
 				 * otherwise count of chanspecs in chanspec_list
 				 */
-	chanspec_t chanspec_list[1];	/* list of chanspecs */
+	u16 chanspec_list[1];	/* list of chanspecs */
 };
 #define BRCMF_ASSOC_PARAMS_FIXED_SIZE \
-	(sizeof(struct brcmf_assoc_params) - sizeof(chanspec_t))
+	(sizeof(struct brcmf_assoc_params) - sizeof(u16))
 
 /* used for join with or without a specific bssid and channel list */
 struct brcmf_join_params {
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 821206d..a9494e7 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2190,7 +2190,7 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *dev,
 			 struct cfg80211_pmksa *pmksa)
 {
 	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
-	struct _pmkid_list *pmkids = &cfg_priv->pmk_list->pmkids;
+	struct pmkid_list *pmkids = &cfg_priv->pmk_list->pmkids;
 	s32 err = 0;
 	int i;
 
@@ -2224,7 +2224,7 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
 		      struct cfg80211_pmksa *pmksa)
 {
 	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
-	struct _pmkid_list pmkid;
+	struct pmkid_list pmkid;
 	s32 err = 0;
 	int i;
 
@@ -2247,7 +2247,7 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *dev,
 	if ((cfg_priv->pmk_list->pmkids.npmkid > 0)
 	    && (i < cfg_priv->pmk_list->pmkids.npmkid)) {
 		memset(&cfg_priv->pmk_list->pmkids.pmkid[i], 0,
-		       sizeof(pmkid_t));
+		       sizeof(struct pmkid));
 		for (; i < (cfg_priv->pmk_list->pmkids.npmkid - 1); i++) {
 			memcpy(&cfg_priv->pmk_list->pmkids.pmkid[i].BSSID,
 			       &cfg_priv->pmk_list->pmkids.pmkid[i + 1].BSSID,
@@ -2780,7 +2780,7 @@ static void brcmf_clear_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
 static void brcmf_ch_to_chanspec(int ch, struct brcmf_join_params *join_params,
 	size_t *join_params_size)
 {
-	chanspec_t chanspec = 0;
+	u16 chanspec = 0;
 
 	if (ch != 0) {
 		join_params->params.chanspec_num = 1;
@@ -2795,7 +2795,7 @@ static void brcmf_ch_to_chanspec(int ch, struct brcmf_join_params *join_params,
 		chanspec |= WL_CHANSPEC_CTL_SB_NONE;
 
 		*join_params_size += BRCMF_ASSOC_PARAMS_FIXED_SIZE +
-			join_params->params.chanspec_num * sizeof(chanspec_t);
+			join_params->params.chanspec_num * sizeof(u16);
 
 		join_params->params.chanspec_list[0] &= WL_CHANSPEC_CHAN_MASK;
 		join_params->params.chanspec_list[0] |= chanspec;
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index f26d087..48f10d0 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -272,8 +272,8 @@ struct brcmf_cfg80211_assoc_ielen {
 
 /* wpa2 pmk list */
 struct brcmf_cfg80211_pmk_list {
-	pmkid_list_t pmkids;
-	pmkid_t foo[MAXPMKID - 1];
+	struct pmkid_list pmkids;
+	struct pmkid foo[MAXPMKID - 1];
 };
 
 /* dongle private data of cfg80211 interface */
diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index fcaf61e..5d09038 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -460,8 +460,8 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 	struct scb_ampdu_tid_ini *ini;
 	u8 mcs = 0;
 	bool use_rts = false, use_cts = false;
-	ratespec_t rspec = 0, rspec_fallback = 0;
-	ratespec_t rts_rspec = 0, rts_rspec_fallback = 0;
+	u32 rspec = 0, rspec_fallback = 0;
+	u32 rts_rspec = 0, rts_rspec_fallback = 0;
 	u16 mimo_ctlchbw = PHY_TXC1_BW_20MHZ;
 	struct ieee80211_rts *rts;
 	u8 rr_retry_limit;
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index eb61713..807df6a 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -30,10 +30,14 @@
 #define	VALID_CHANNEL20(wlc, val) brcms_c_valid_channel20((wlc)->cmi, val)
 
 struct brcms_cm_band {
-	u8 locale_flags;	/* struct locale_info flags */
-	chanvec_t valid_channels;	/* List of valid channels in the country */
-	const chanvec_t *restricted_channels;	/* List of restricted use channels */
-	const chanvec_t *radar_channels;	/* List of radar sensitive channels */
+	/* struct locale_info flags */
+	u8 locale_flags;
+	/* List of valid channels in the country */
+	struct brcms_chanvec valid_channels;
+	/* List of restricted use channels */
+	const struct brcms_chanvec *restricted_channels;
+	/* List of radar sensitive channels */
+	const struct brcms_chanvec *radar_channels;
 	u8 PAD[8];
 };
 
@@ -49,7 +53,8 @@ struct brcms_cm_info {
 	/* per-band state (one per phy/radio) */
 	struct brcms_cm_band bandstate[MAXBANDS];
 	/* quiet channels currently for radar sensitivity or 11h support */
-	chanvec_t quiet_channels;	/* channels on which we cannot transmit */
+	/* channels on which we cannot transmit */
+	struct brcms_chanvec quiet_channels;
 };
 
 static int brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
@@ -78,7 +83,7 @@ brcms_c_countrycode_map(struct brcms_cm_info *wlc_cm,
 static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm);
 static void brcms_c_quiet_channels_reset(struct brcms_cm_info *wlc_cm);
 static bool brcms_c_quiet_chanspec(struct brcms_cm_info *wlc_cm,
-				   chanspec_t chspec);
+				   u16 chspec);
 static bool brcms_c_valid_channel20_db(struct brcms_cm_info *wlc_cm, uint val);
 static bool brcms_c_valid_channel20_in_band(struct brcms_cm_info *wlc_cm,
 					    uint bandunit, uint val);
@@ -88,7 +93,7 @@ static const struct country_info *
 brcms_c_country_lookup(struct brcms_c_info *wlc, const char *ccode);
 
 static void brcms_c_locale_get_channels(const struct locale_info *locale,
-				    chanvec_t *valid_channels);
+				    struct brcms_chanvec *valid_channels);
 static const struct locale_info *brcms_c_get_locale_2g(u8 locale_idx);
 static const struct locale_info *brcms_c_get_locale_5g(u8 locale_idx);
 static bool brcms_c_japan(struct brcms_c_info *wlc);
@@ -96,8 +101,8 @@ static bool brcms_c_japan_ccode(const char *ccode);
 static void brcms_c_channel_min_txpower_limits_with_local_constraint(
 	struct brcms_cm_info *wlc_cm, struct txpwr_limits *txpwr,
 	u8 local_constraint_qdbm);
-static void brcms_c_locale_add_channels(chanvec_t *target,
-				    const chanvec_t *channels);
+static void brcms_c_locale_add_channels(struct brcms_chanvec *target,
+				    const struct brcms_chanvec *channels);
 static const struct locale_mimo_info *brcms_c_get_mimo_2g(u8 locale_idx);
 static const struct locale_mimo_info *brcms_c_get_mimo_5g(u8 locale_idx);
 
@@ -114,7 +119,7 @@ static const struct locale_mimo_info *brcms_c_get_mimo_5g(u8 locale_idx);
  */
 
 /* No channels */
-static const chanvec_t chanvec_none = {
+static const struct brcms_chanvec chanvec_none = {
 	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -122,7 +127,7 @@ static const chanvec_t chanvec_none = {
 };
 
 /* All 2.4 GHz HW channels */
-const chanvec_t chanvec_all_2G = {
+const struct brcms_chanvec chanvec_all_2G = {
 	{0xfe, 0x7f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -130,7 +135,7 @@ const chanvec_t chanvec_all_2G = {
 };
 
 /* All 5 GHz HW channels */
-const chanvec_t chanvec_all_5G = {
+const struct brcms_chanvec chanvec_all_5G = {
 	{0x00, 0x00, 0x00, 0x00, 0x54, 0x55, 0x11, 0x11,
 	 0x01, 0x00, 0x00, 0x00, 0x10, 0x11, 0x11, 0x11,
 	 0x11, 0x11, 0x20, 0x22, 0x22, 0x00, 0x00, 0x11,
@@ -144,7 +149,8 @@ const chanvec_t chanvec_all_5G = {
 /* No radar */
 #define radar_set_none chanvec_none
 
-static const chanvec_t radar_set1 = {	/* Channels 52 - 64, 100 - 140 */
+/* Channels 52 - 64, 100 - 140 */
+static const struct brcms_chanvec radar_set1 = {
 	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x11,	/* 52 - 60 */
 	 0x01, 0x00, 0x00, 0x00, 0x10, 0x11, 0x11, 0x11,	/* 64, 100 - 124 */
 	 0x11, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	/* 128 - 140 */
@@ -158,7 +164,7 @@ static const chanvec_t radar_set1 = {	/* Channels 52 - 64, 100 - 140 */
 #define restricted_set_none chanvec_none
 
 /* Channels 34, 38, 42, 46 */
-static const chanvec_t restricted_set_japan_legacy = {
+static const struct brcms_chanvec restricted_set_japan_legacy = {
 	{0x00, 0x00, 0x00, 0x00, 0x44, 0x44, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -166,7 +172,7 @@ static const chanvec_t restricted_set_japan_legacy = {
 };
 
 /* Channels 12, 13 */
-static const chanvec_t restricted_set_2g_short = {
+static const struct brcms_chanvec restricted_set_2g_short = {
 	{0x00, 0x30, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -174,7 +180,7 @@ static const chanvec_t restricted_set_2g_short = {
 };
 
 /* Channel 165 */
-static const chanvec_t restricted_chan_165 = {
+static const struct brcms_chanvec restricted_chan_165 = {
 	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00,
@@ -182,7 +188,7 @@ static const chanvec_t restricted_chan_165 = {
 };
 
 /* Channels 36 - 48 & 149 - 165 */
-static const chanvec_t restricted_low_hi = {
+static const struct brcms_chanvec restricted_low_hi = {
 	{0x00, 0x00, 0x00, 0x00, 0x10, 0x11, 0x01, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x20, 0x22, 0x22, 0x00, 0x00, 0x00,
@@ -190,7 +196,7 @@ static const chanvec_t restricted_low_hi = {
 };
 
 /* Channels 12 - 14 */
-static const chanvec_t restricted_set_12_13_14 = {
+static const struct brcms_chanvec restricted_set_12_13_14 = {
 	{0x00, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -239,12 +245,12 @@ static const chanvec_t restricted_set_12_13_14 = {
 
 /* global memory to provide working buffer for expanded locale */
 
-static const chanvec_t *g_table_radar_set[] = {
+static const struct brcms_chanvec *g_table_radar_set[] = {
 	&chanvec_none,
 	&radar_set1
 };
 
-static const chanvec_t *g_table_restricted_chan[] = {
+static const struct brcms_chanvec *g_table_restricted_chan[] = {
 	&chanvec_none,		/* restricted_set_none */
 	&restricted_set_2g_short,
 	&restricted_chan_165,
@@ -256,119 +262,119 @@ static const chanvec_t *g_table_restricted_chan[] = {
 	&restricted_set_12_13_14
 };
 
-static const chanvec_t locale_2g_01_11 = {
+static const struct brcms_chanvec locale_2g_01_11 = {
 	{0xfe, 0x0f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-static const chanvec_t locale_2g_12_13 = {
+static const struct brcms_chanvec locale_2g_12_13 = {
 	{0x00, 0x30, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-static const chanvec_t locale_2g_14 = {
+static const struct brcms_chanvec locale_2g_14 = {
 	{0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-static const chanvec_t locale_5g_LOW_JP1 = {
+static const struct brcms_chanvec locale_5g_LOW_JP1 = {
 	{0x00, 0x00, 0x00, 0x00, 0x54, 0x55, 0x01, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-static const chanvec_t locale_5g_LOW_JP2 = {
+static const struct brcms_chanvec locale_5g_LOW_JP2 = {
 	{0x00, 0x00, 0x00, 0x00, 0x44, 0x44, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-static const chanvec_t locale_5g_LOW1 = {
+static const struct brcms_chanvec locale_5g_LOW1 = {
 	{0x00, 0x00, 0x00, 0x00, 0x10, 0x11, 0x01, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-static const chanvec_t locale_5g_LOW2 = {
+static const struct brcms_chanvec locale_5g_LOW2 = {
 	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-static const chanvec_t locale_5g_LOW3 = {
+static const struct brcms_chanvec locale_5g_LOW3 = {
 	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x11,
 	 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-static const chanvec_t locale_5g_MID1 = {
+static const struct brcms_chanvec locale_5g_MID1 = {
 	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x10, 0x11, 0x11, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-static const chanvec_t locale_5g_MID2 = {
+static const struct brcms_chanvec locale_5g_MID2 = {
 	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x11,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-static const chanvec_t locale_5g_MID3 = {
+static const struct brcms_chanvec locale_5g_MID3 = {
 	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-static const chanvec_t locale_5g_HIGH1 = {
+static const struct brcms_chanvec locale_5g_HIGH1 = {
 	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x10, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-static const chanvec_t locale_5g_HIGH2 = {
+static const struct brcms_chanvec locale_5g_HIGH2 = {
 	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x20, 0x22, 0x02, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-static const chanvec_t locale_5g_HIGH3 = {
+static const struct brcms_chanvec locale_5g_HIGH3 = {
 	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-static const chanvec_t locale_5g_52_140_ALL = {
+static const struct brcms_chanvec locale_5g_52_140_ALL = {
 	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x11,
 	 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11,
 	 0x11, 0x11, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-static const chanvec_t locale_5g_HIGH4 = {
+static const struct brcms_chanvec locale_5g_HIGH4 = {
 	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x11,
 	 0x11, 0x11, 0x11, 0x11}
 };
 
-static const chanvec_t *g_table_locale_base[] = {
+static const struct brcms_chanvec *g_table_locale_base[] = {
 	&locale_2g_01_11,
 	&locale_2g_12_13,
 	&locale_2g_14,
@@ -387,21 +393,20 @@ static const chanvec_t *g_table_locale_base[] = {
 	&locale_5g_HIGH4
 };
 
-static void brcms_c_locale_add_channels(chanvec_t *target,
-				    const chanvec_t *channels)
+static void brcms_c_locale_add_channels(struct brcms_chanvec *target,
+				    const struct brcms_chanvec *channels)
 {
 	u8 i;
-	for (i = 0; i < sizeof(chanvec_t); i++) {
+	for (i = 0; i < sizeof(struct brcms_chanvec); i++)
 		target->vec[i] |= channels->vec[i];
-	}
 }
 
 static void brcms_c_locale_get_channels(const struct locale_info *locale,
-				    chanvec_t *channels)
+				    struct brcms_chanvec *channels)
 {
 	u8 i;
 
-	memset(channels, 0, sizeof(chanvec_t));
+	memset(channels, 0, sizeof(struct brcms_chanvec));
 
 	for (i = 0; i < ARRAY_SIZE(g_table_locale_base); i++) {
 		if (locale->valid_channels & (1 << i)) {
@@ -870,7 +875,7 @@ brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
 	uint i, j;
 	struct brcms_band *band;
 	const struct locale_info *li;
-	chanvec_t sup_chan;
+	struct brcms_chanvec sup_chan;
 	const struct locale_mimo_info *li_mimo;
 
 	band = wlc->band;
@@ -902,7 +907,7 @@ brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
 		brcms_c_locale_get_channels(li,
 					&wlc_cm->bandstate[band->bandunit].
 					valid_channels);
-		for (j = 0; j < sizeof(chanvec_t); j++)
+		for (j = 0; j < sizeof(struct brcms_chanvec); j++)
 			wlc_cm->bandstate[band->bandunit].valid_channels.
 			    vec[j] &= sup_chan.vec[j];
 	}
@@ -969,9 +974,9 @@ static void brcms_c_quiet_channels_reset(struct brcms_cm_info *wlc_cm)
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 	uint i, j;
 	struct brcms_band *band;
-	const chanvec_t *chanvec;
+	const struct brcms_chanvec *chanvec;
 
-	memset(&wlc_cm->quiet_channels, 0, sizeof(chanvec_t));
+	memset(&wlc_cm->quiet_channels, 0, sizeof(struct brcms_chanvec));
 
 	band = wlc->band;
 	for (i = 0; i < NBANDS(wlc);
@@ -979,14 +984,14 @@ static void brcms_c_quiet_channels_reset(struct brcms_cm_info *wlc_cm)
 
 		/* initialize quiet channels for restricted channels */
 		chanvec = wlc_cm->bandstate[band->bandunit].restricted_channels;
-		for (j = 0; j < sizeof(chanvec_t); j++)
+		for (j = 0; j < sizeof(struct brcms_chanvec); j++)
 			wlc_cm->quiet_channels.vec[j] |= chanvec->vec[j];
 
 	}
 }
 
 static bool
-brcms_c_quiet_chanspec(struct brcms_cm_info *wlc_cm, chanspec_t chspec)
+brcms_c_quiet_chanspec(struct brcms_cm_info *wlc_cm, u16 chspec)
 {
 	return N_ENAB(wlc_cm->wlc->pub) && CHSPEC_IS40(chspec) ?
 		(isset
@@ -1117,7 +1122,7 @@ brcms_c_channel_min_txpower_limits_with_local_constraint(
 }
 
 void
-brcms_c_channel_set_chanspec(struct brcms_cm_info *wlc_cm, chanspec_t chanspec,
+brcms_c_channel_set_chanspec(struct brcms_cm_info *wlc_cm, u16 chanspec,
 			 u8 local_constraint_qdbm)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
@@ -1261,7 +1266,7 @@ static void wlc_phy_txpower_limits_dump(struct txpwr_limits *txpwr)
 #endif				/* POWER_DBG */
 
 void
-brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, chanspec_t chanspec,
+brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 		       struct txpwr_limits *txpwr)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
@@ -1490,7 +1495,7 @@ static bool brcms_c_japan_ccode(const char *ccode)
  * are valid 20MZH channels in this locale and they are also a legal HT combination
  */
 static bool
-brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, chanspec_t chspec,
+brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, u16 chspec,
 			   bool dualband)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
@@ -1552,7 +1557,7 @@ brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, chanspec_t chspec,
 	return false;
 }
 
-bool brcms_c_valid_chanspec_db(struct brcms_cm_info *wlc_cm, chanspec_t chspec)
+bool brcms_c_valid_chanspec_db(struct brcms_cm_info *wlc_cm, u16 chspec)
 {
 	return brcms_c_valid_chanspec_ext(wlc_cm, chspec, true);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.h b/drivers/staging/brcm80211/brcmsmac/channel.h
index d22f2f5..c9452be 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.h
+++ b/drivers/staging/brcm80211/brcmsmac/channel.h
@@ -98,8 +98,8 @@ struct locale_mimo_info {
 	u8 flags;
 };
 
-extern const chanvec_t chanvec_all_2G;
-extern const chanvec_t chanvec_all_5G;
+extern const struct brcms_chanvec chanvec_all_2G;
+extern const struct brcms_chanvec chanvec_all_5G;
 
 /*
  * Country names and abbreviations with locale defined from ISO 3166
@@ -120,13 +120,13 @@ extern u8 brcms_c_channel_locale_flags_in_band(struct brcms_cm_info *wlc_cm,
 					   uint bandunit);
 
 extern bool brcms_c_valid_chanspec_db(struct brcms_cm_info *wlc_cm,
-				      chanspec_t chspec);
+				      u16 chspec);
 
 extern void brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm,
-				   chanspec_t chanspec,
+				   u16 chanspec,
 				   struct txpwr_limits *txpwr);
 extern void brcms_c_channel_set_chanspec(struct brcms_cm_info *wlc_cm,
-				     chanspec_t chanspec,
+				     u16 chanspec,
 				     u8 local_constraint_qdbm);
 
 #endif				/* _WLC_CHANNEL_H */
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 517dc61..84b5d80 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -180,7 +180,6 @@
 
 #define	DMA_NONE(args)
 
-typedef unsigned long dmaaddr_t;
 #define PHYSADDRHI(_pa) (0)
 #define PHYSADDRHISET(_pa, _val)
 #define PHYSADDRLO(_pa) ((_pa))
@@ -206,7 +205,7 @@ static uint dma_msg_level;
 
 /* One physical DMA segment */
 struct dma_seg {
-	dmaaddr_t addr;
+	unsigned long addr;
 	u32 length;
 };
 
@@ -257,8 +256,10 @@ struct dma_info {
 	u16 txout;		/* index of next descriptor to post */
 	void **txp;		/* pointer to parallel array of pointers to packets */
 	struct dma_seg_map *txp_dmah;	/* DMA MAP meta-data handle */
-	dmaaddr_t txdpa;	/* Aligned physical address of descriptor ring */
-	dmaaddr_t txdpaorig;	/* Original physical address of descriptor ring */
+	/* Aligned physical address of descriptor ring */
+	unsigned long txdpa;
+	/* Original physical address of descriptor ring */
+	unsigned long txdpaorig;
 	u16 txdalign;	/* #bytes added to alloc'd mem to align txd */
 	u32 txdalloc;	/* #bytes allocated for the ring */
 	u32 xmtptrbase;	/* When using unaligned descriptors, the ptr register
@@ -271,8 +272,10 @@ struct dma_info {
 	u16 rxout;		/* index of next descriptor to post */
 	void **rxp;		/* pointer to parallel array of pointers to packets */
 	struct dma_seg_map *rxp_dmah;	/* DMA MAP meta-data handle */
-	dmaaddr_t rxdpa;	/* Aligned physical address of descriptor ring */
-	dmaaddr_t rxdpaorig;	/* Original physical address of descriptor ring */
+	/* Aligned physical address of descriptor ring */
+	unsigned long rxdpa;
+	/* Original physical address of descriptor ring */
+	unsigned long rxdpaorig;
 	u16 rxdalign;	/* #bytes added to alloc'd mem to align rxd */
 	u32 rxdalloc;	/* #bytes allocated for the ring */
 	u32 rcvptrbase;	/* Base for ptr reg when using unaligned descriptors */
@@ -331,7 +334,7 @@ static bool _dma_descriptor_align(struct dma_info *di);
 static bool _dma_alloc(struct dma_info *di, uint direction);
 static void _dma_detach(struct dma_info *di);
 static void _dma_ddtable_init(struct dma_info *di, uint direction,
-			      dmaaddr_t pa);
+			      unsigned long pa);
 static void _dma_rxinit(struct dma_info *di);
 static void *_dma_rx(struct dma_info *di);
 static bool _dma_rxfill(struct dma_info *di);
@@ -357,7 +360,7 @@ static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags);
 static u8 dma_align_sizetobits(uint size);
 static void *dma_ringalloc(struct dma_info *di, u32 boundary, uint size,
 			   u16 *alignbits, uint *alloced,
-			   dmaaddr_t *descpa);
+			   unsigned long *descpa);
 
 /* Prototypes for 64-bit routines */
 static bool dma64_alloc(struct dma_info *di, uint direction);
@@ -623,7 +626,7 @@ static inline u32 parity32(u32 data)
 
 static inline void
 dma64_dd_upd(struct dma_info *di, struct dma64desc *ddring,
-	     dmaaddr_t pa, uint outidx, u32 *flags, u32 bufcount)
+	     unsigned long pa, uint outidx, u32 *flags, u32 bufcount)
 {
 	u32 ctrl2 = bufcount & D64_CTRL2_BC_MASK;
 
@@ -754,7 +757,8 @@ static bool _dma_isaddrext(struct dma_info *di)
 }
 
 /* initialize descriptor table base address */
-static void _dma_ddtable_init(struct dma_info *di, uint direction, dmaaddr_t pa)
+static void
+_dma_ddtable_init(struct dma_info *di, uint direction, unsigned long pa)
 {
 	if (!di->aligndesc_4k) {
 		if (direction == DMA_TX)
@@ -943,7 +947,7 @@ static bool _dma_rxfill(struct dma_info *di)
 	u32 flags = 0;
 	uint n;
 	uint i;
-	dmaaddr_t pa;
+	unsigned long pa;
 	uint extra_offset = 0;
 	bool ring_empty;
 
@@ -1194,7 +1198,7 @@ u8 dma_align_sizetobits(uint size)
  */
 static void *dma_ringalloc(struct dma_info *di, u32 boundary, uint size,
 			   u16 *alignbits, uint *alloced,
-			   dmaaddr_t *descpa)
+			   unsigned long *descpa)
 {
 	void *va;
 	u32 desc_strtaddr;
@@ -1487,7 +1491,7 @@ dma64_txunframed(struct dma_info *di, void *buf, uint len, bool commit)
 {
 	u16 txout;
 	u32 flags = 0;
-	dmaaddr_t pa;		/* phys addr */
+	unsigned long pa;		/* phys addr */
 
 	txout = di->txout;
 
@@ -1544,7 +1548,7 @@ static int dma64_txfast(struct dma_info *di, struct sk_buff *p0,
 	uint len;
 	u16 txout;
 	u32 flags = 0;
-	dmaaddr_t pa;
+	unsigned long pa;
 
 	DMA_TRACE(("%s: dma_txfast\n", di->name));
 
@@ -1702,7 +1706,7 @@ static void *dma64_getnexttxp(struct dma_info *di, enum txd_range range)
 		goto bogus;
 
 	for (i = start; i != end && !txp; i = NEXTTXD(i)) {
-		dmaaddr_t pa;
+		unsigned long pa;
 		struct dma_seg_map *map = NULL;
 		uint size, j, nsegs;
 
@@ -1753,7 +1757,7 @@ static void *dma64_getnextrxp(struct dma_info *di, bool forceall)
 {
 	uint i, curr;
 	void *rxp;
-	dmaaddr_t pa;
+	unsigned long pa;
 
 	i = di->rxin;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 66de7ef..252cd3b 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -324,7 +324,7 @@ static void brcms_b_retrylimit_upd(struct brcms_hardware *wlc_hw, u16 SRL,
 static void brcms_b_fifoerrors(struct brcms_hardware *wlc_hw);
 
 static void brcms_b_pllreq(struct brcms_hardware *wlc_hw, bool set,
-			    mbool req_bit);
+			   u32 req_bit);
 static void brcms_b_antsel_set(struct brcms_hardware *wlc_hw,
 			       u32 antsel_avail);
 static int brcms_b_bandtype(struct brcms_hardware *wlc_hw);
@@ -344,8 +344,7 @@ static bool brcms_b_validate_chip_access(struct brcms_hardware *wlc_hw);
 static char *brcms_c_get_macaddr(struct brcms_hardware *wlc_hw);
 static void brcms_c_mhfdef(struct brcms_c_info *wlc, u16 *mhfs, u16 mhf2_init);
 static void brcms_c_mctrl_write(struct brcms_hardware *wlc_hw);
-static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool want,
-			 mbool flags);
+static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool want, u32 flags);
 static void brcms_c_ucode_mute_override_set(struct brcms_hardware *wlc_hw);
 static void brcms_c_ucode_mute_override_clear(struct brcms_hardware *wlc_hw);
 static u32 brcms_c_wlintrsoff(struct brcms_c_info *wlc);
@@ -355,10 +354,10 @@ static void brcms_c_write_hw_bcntemplate0(struct brcms_hardware *wlc_hw,
 					  void *bcn, int len);
 static void brcms_c_write_hw_bcntemplate1(struct brcms_hardware *wlc_hw,
 					  void *bcn, int len);
-static void brcms_b_bsinit(struct brcms_c_info *wlc, chanspec_t chanspec);
+static void brcms_b_bsinit(struct brcms_c_info *wlc, u16 chanspec);
 static u32 brcms_c_setband_inact(struct brcms_c_info *wlc, uint bandunit);
 static void brcms_b_setband(struct brcms_hardware *wlc_hw, uint bandunit,
-			     chanspec_t chanspec);
+			     u16 chanspec);
 static void brcms_b_update_slot_timing(struct brcms_hardware *wlc_hw,
 					bool shortslot);
 static void brcms_upd_ofdm_pctl1_table(struct brcms_hardware *wlc_hw);
@@ -372,10 +371,10 @@ static u16 brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc,
 					       uint nfrags, uint queue,
 					       uint next_frag_len,
 					       struct wsec_key *key,
-					       ratespec_t rspec_override);
+					       u32 rspec_override);
 static void brcms_c_bss_default_init(struct brcms_c_info *wlc);
 static void brcms_c_ucode_mac_upd(struct brcms_c_info *wlc);
-static ratespec_t mac80211_wlc_set_nrate(struct brcms_c_info *wlc,
+static u32 mac80211_wlc_set_nrate(struct brcms_c_info *wlc,
 					 struct brcms_band *cur_band,
 					 u32 int_val);
 static void brcms_c_tx_prec_map_init(struct brcms_c_info *wlc);
@@ -393,27 +392,27 @@ static void brcms_c_txflowcontrol_signal(struct brcms_c_info *wlc,
 				     struct brcms_txq_info *qi,
 				     bool on, int prio);
 static void brcms_c_txflowcontrol_reset(struct brcms_c_info *wlc);
-static void brcms_c_compute_cck_plcp(struct brcms_c_info *wlc, ratespec_t rate,
+static void brcms_c_compute_cck_plcp(struct brcms_c_info *wlc, u32 rate,
 				 uint length, u8 *plcp);
-static void brcms_c_compute_ofdm_plcp(ratespec_t rate, uint length, u8 *plcp);
-static void brcms_c_compute_mimo_plcp(ratespec_t rate, uint length, u8 *plcp);
-static u16 brcms_c_compute_frame_dur(struct brcms_c_info *wlc, ratespec_t rate,
+static void brcms_c_compute_ofdm_plcp(u32 rate, uint length, u8 *plcp);
+static void brcms_c_compute_mimo_plcp(u32 rate, uint length, u8 *plcp);
+static u16 brcms_c_compute_frame_dur(struct brcms_c_info *wlc, u32 rate,
 				    u8 preamble_type, uint next_frag_len);
 static u64 brcms_c_recover_tsf64(struct brcms_c_info *wlc,
 			     struct brcms_d11rxhdr *rxh);
 static void brcms_c_recvctl(struct brcms_c_info *wlc,
 			struct d11rxhdr *rxh, struct sk_buff *p);
-static uint brcms_c_calc_frame_len(struct brcms_c_info *wlc, ratespec_t rate,
+static uint brcms_c_calc_frame_len(struct brcms_c_info *wlc, u32 rate,
 			       u8 preamble_type, uint dur);
-static uint brcms_c_calc_ack_time(struct brcms_c_info *wlc, ratespec_t rate,
+static uint brcms_c_calc_ack_time(struct brcms_c_info *wlc, u32 rate,
 			      u8 preamble_type);
-static uint brcms_c_calc_cts_time(struct brcms_c_info *wlc, ratespec_t rate,
+static uint brcms_c_calc_cts_time(struct brcms_c_info *wlc, u32 rate,
 			      u8 preamble_type);
 /* interrupt, up/down, band */
 static void brcms_c_setband(struct brcms_c_info *wlc, uint bandunit);
-static chanspec_t brcms_c_init_chanspec(struct brcms_c_info *wlc);
+static u16 brcms_c_init_chanspec(struct brcms_c_info *wlc);
 static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
-				     chanspec_t chanspec);
+				     u16 chanspec);
 static void brcms_c_bsinit(struct brcms_c_info *wlc);
 static int brcms_c_duty_cycle_set(struct brcms_c_info *wlc, int duty_cycle,
 			      bool isOFDM, bool writeToShm);
@@ -424,7 +423,7 @@ static void brcms_c_radio_enable(struct brcms_c_info *wlc);
 static void brcms_c_radio_upd(struct brcms_c_info *wlc);
 
 /* scan, association, BSS */
-static uint brcms_c_calc_ba_time(struct brcms_c_info *wlc, ratespec_t rate,
+static uint brcms_c_calc_ba_time(struct brcms_c_info *wlc, u32 rate,
 			     u8 preamble_type);
 static void brcms_c_update_mimo_band_bwcap(struct brcms_c_info *wlc, u8 bwcap);
 static void brcms_c_ht_update_sgi_rx(struct brcms_c_info *wlc, int val);
@@ -1407,7 +1406,7 @@ static void brcms_b_upd_synthpu(struct brcms_hardware *wlc_hw)
 }
 
 /* band-specific init */
-static void brcms_b_bsinit(struct brcms_c_info *wlc, chanspec_t chanspec)
+static void brcms_b_bsinit(struct brcms_c_info *wlc, u16 chanspec)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
 
@@ -1550,7 +1549,7 @@ void brcms_b_phy_reset(struct brcms_hardware *wlc_hw)
 
 /* switch to and initialize new band */
 static void brcms_b_setband(struct brcms_hardware *wlc_hw, uint bandunit,
-			    chanspec_t chanspec) {
+			    u16 chanspec) {
 	struct brcms_c_info *wlc = wlc_hw->wlc;
 	u32 macintmask;
 
@@ -2226,7 +2225,7 @@ static void brcms_b_tx_fifo_suspend(struct brcms_hardware *wlc_hw,
 	}
 }
 
-static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool on, mbool flags)
+static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool on, u32 flags)
 {
 	u8 null_ether_addr[ETH_ALEN] = {0, 0, 0, 0, 0, 0};
 
@@ -2924,7 +2923,7 @@ void brcms_b_retrylimit_upd(struct brcms_hardware *wlc_hw, u16 SRL, u16 LRL)
 	}
 }
 
-void brcms_b_pllreq(struct brcms_hardware *wlc_hw, bool set, mbool req_bit)
+void brcms_b_pllreq(struct brcms_hardware *wlc_hw, bool set, u32 req_bit)
 {
 	if (set) {
 		if (mboolisset(wlc_hw->pllreq, req_bit))
@@ -3031,9 +3030,9 @@ void brcms_c_fatal_error(struct brcms_c_info *wlc)
  * if other configurations are in conflict (bandlocked, 11n mode disabled,
  * invalid channel for current country, etc.)
  */
-static chanspec_t brcms_c_init_chanspec(struct brcms_c_info *wlc)
+static u16 brcms_c_init_chanspec(struct brcms_c_info *wlc)
 {
-	chanspec_t chanspec =
+	u16 chanspec =
 	    1 | WL_CHANSPEC_BW_20 | WL_CHANSPEC_CTL_SB_NONE |
 	    WL_CHANSPEC_BAND_2G;
 
@@ -3236,7 +3235,7 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 }
 
 void
-brcms_b_init(struct brcms_hardware *wlc_hw, chanspec_t chanspec,
+brcms_b_init(struct brcms_hardware *wlc_hw, u16 chanspec,
 			  bool mute) {
 	u32 macintmask;
 	bool fastclk;
@@ -3290,7 +3289,7 @@ brcms_b_init(struct brcms_hardware *wlc_hw, chanspec_t chanspec,
 void brcms_c_init(struct brcms_c_info *wlc)
 {
 	d11regs_t *regs;
-	chanspec_t chanspec;
+	u16 chanspec;
 	int i;
 	struct brcms_bss_cfg *bsscfg;
 	bool mute = false;
@@ -3582,7 +3581,7 @@ static u8 brcms_c_local_constraint_qdbm(struct brcms_c_info *wlc)
 }
 
 /* propagate home chanspec to all bsscfgs in case bsscfg->current_bss->chanspec is referenced */
-void brcms_c_set_home_chanspec(struct brcms_c_info *wlc, chanspec_t chanspec)
+void brcms_c_set_home_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 {
 	if (wlc->home_chanspec != chanspec) {
 		int idx;
@@ -3601,7 +3600,7 @@ void brcms_c_set_home_chanspec(struct brcms_c_info *wlc, chanspec_t chanspec)
 }
 
 static void brcms_c_set_phy_chanspec(struct brcms_c_info *wlc,
-				     chanspec_t chanspec)
+				     u16 chanspec)
 {
 	/* Save our copy of the chanspec */
 	wlc->chanspec = chanspec;
@@ -3621,7 +3620,7 @@ static void brcms_c_set_phy_chanspec(struct brcms_c_info *wlc,
 }
 
 void
-brcms_b_set_chanspec(struct brcms_hardware *wlc_hw, chanspec_t chanspec,
+brcms_b_set_chanspec(struct brcms_hardware *wlc_hw, u16 chanspec,
 		      bool mute, struct txpwr_limits *txpwr)
 {
 	uint bandunit;
@@ -3664,11 +3663,11 @@ brcms_b_set_chanspec(struct brcms_hardware *wlc_hw, chanspec_t chanspec,
 	}
 }
 
-void brcms_c_set_chanspec(struct brcms_c_info *wlc, chanspec_t chanspec)
+void brcms_c_set_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 {
 	uint bandunit;
 	bool switchband = false;
-	chanspec_t old_chanspec = wlc->chanspec;
+	u16 old_chanspec = wlc->chanspec;
 
 	if (!brcms_c_valid_chanspec_db(wlc->cmi, chanspec)) {
 		wiphy_err(wlc->wiphy, "wl%d: %s: Bad channel %d\n",
@@ -3720,10 +3719,10 @@ void brcms_c_set_chanspec(struct brcms_c_info *wlc, chanspec_t chanspec)
 	brcms_c_ucode_mac_upd(wlc);
 }
 
-ratespec_t brcms_c_lowest_basic_rspec(struct brcms_c_info *wlc,
+u32 brcms_c_lowest_basic_rspec(struct brcms_c_info *wlc,
 				      wlc_rateset_t *rs)
 {
-	ratespec_t lowest_basic_rspec;
+	u32 lowest_basic_rspec;
 	uint i;
 
 	/* Use the lowest basic rate */
@@ -3750,7 +3749,7 @@ ratespec_t brcms_c_lowest_basic_rspec(struct brcms_c_info *wlc,
  *		OFDM		ant = 3
  */
 void brcms_c_beacon_phytxctl_txant_upd(struct brcms_c_info *wlc,
-				       ratespec_t bcn_rspec)
+				       u32 bcn_rspec)
 {
 	u16 phyctl;
 	u16 phytxant = wlc->stf->phytxant;
@@ -3875,7 +3874,7 @@ static void brcms_c_ucode_mac_upd(struct brcms_c_info *wlc)
 }
 
 static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
-				     chanspec_t chanspec)
+				     u16 chanspec)
 {
 	wlc_rateset_t default_rateset;
 	uint parkband;
@@ -6068,7 +6067,7 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 	switch (cmd) {
 
 	case BRCM_SET_CHANNEL:{
-			chanspec_t chspec = CH20MHZ_CHSPEC(val);
+			u16 chspec = CH20MHZ_CHSPEC(val);
 
 			if (val < 0 || val > MAXCHANNEL) {
 				bcmerror = -EINVAL;
@@ -6859,7 +6858,7 @@ brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
 }
 
 void
-brcms_c_compute_plcp(struct brcms_c_info *wlc, ratespec_t rspec,
+brcms_c_compute_plcp(struct brcms_c_info *wlc, u32 rspec,
 		     uint length, u8 *plcp)
 {
 	if (IS_MCS(rspec)) {
@@ -6873,7 +6872,7 @@ brcms_c_compute_plcp(struct brcms_c_info *wlc, ratespec_t rspec,
 }
 
 /* Rate: 802.11 rate code, length: PSDU length in octets */
-static void brcms_c_compute_mimo_plcp(ratespec_t rspec, uint length, u8 *plcp)
+static void brcms_c_compute_mimo_plcp(u32 rspec, uint length, u8 *plcp)
 {
 	u8 mcs = (u8) (rspec & RSPEC_RATE_MASK);
 	plcp[0] = mcs;
@@ -6888,7 +6887,7 @@ static void brcms_c_compute_mimo_plcp(ratespec_t rspec, uint length, u8 *plcp)
 
 /* Rate: 802.11 rate code, length: PSDU length in octets */
 static void
-brcms_c_compute_ofdm_plcp(ratespec_t rspec, u32 length, u8 *plcp)
+brcms_c_compute_ofdm_plcp(u32 rspec, u32 length, u8 *plcp)
 {
 	u8 rate_signal;
 	u32 tmp = 0;
@@ -6961,7 +6960,7 @@ static void brcms_c_cck_plcp_set(struct brcms_c_info *wlc, int rate_500,
 }
 
 /* Rate: 802.11 rate code, length: PSDU length in octets */
-static void brcms_c_compute_cck_plcp(struct brcms_c_info *wlc, ratespec_t rspec,
+static void brcms_c_compute_cck_plcp(struct brcms_c_info *wlc, u32 rspec,
 				 uint length, u8 *plcp)
 {
 	int rate = RSPEC2RATE(rspec);
@@ -6980,7 +6979,7 @@ static void brcms_c_compute_cck_plcp(struct brcms_c_info *wlc, ratespec_t rspec,
  * preamble_type	use short/GF or long/MM PLCP header
  */
 static u16
-brcms_c_compute_frame_dur(struct brcms_c_info *wlc, ratespec_t rate,
+brcms_c_compute_frame_dur(struct brcms_c_info *wlc, u32 rate,
 		      u8 preamble_type, uint next_frag_len)
 {
 	u16 dur, sifs;
@@ -7015,8 +7014,8 @@ brcms_c_compute_frame_dur(struct brcms_c_info *wlc, ratespec_t rate,
  */
 u16
 brcms_c_compute_rtscts_dur(struct brcms_c_info *wlc, bool cts_only,
-			   ratespec_t rts_rate,
-			   ratespec_t frame_rate, u8 rts_preamble_type,
+			   u32 rts_rate,
+			   u32 frame_rate, u8 rts_preamble_type,
 			   u8 frame_preamble_type, uint frame_len, bool ba)
 {
 	u16 dur, sifs;
@@ -7046,7 +7045,7 @@ brcms_c_compute_rtscts_dur(struct brcms_c_info *wlc, bool cts_only,
 	return dur;
 }
 
-u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, ratespec_t rspec)
+u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, u32 rspec)
 {
 	u16 phyctl1 = 0;
 	u16 bw;
@@ -7093,11 +7092,11 @@ u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, ratespec_t rspec)
 	return phyctl1;
 }
 
-ratespec_t
-brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, ratespec_t rspec,
+u32
+brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, u32 rspec,
 			   bool use_rspec, u16 mimo_ctlchbw)
 {
-	ratespec_t rts_rspec = 0;
+	u32 rts_rspec = 0;
 
 	if (use_rspec) {
 		/* use frame rate as rts rate */
@@ -7153,7 +7152,7 @@ static u16
 brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		     struct sk_buff *p, struct scb *scb, uint frag,
 		     uint nfrags, uint queue, uint next_frag_len,
-		     struct wsec_key *key, ratespec_t rspec_override)
+		     struct wsec_key *key, u32 rspec_override)
 {
 	struct ieee80211_hdr *h;
 	struct d11txh *txh;
@@ -7161,7 +7160,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	int len, phylen, rts_phylen;
 	u16 mch, phyctl, xfts, mainrates;
 	u16 seq = 0, mcl = 0, status = 0, frameid = 0;
-	ratespec_t rspec[2] = { BRCM_RATE_1M, BRCM_RATE_1M }, rts_rspec[2] = {
+	u32 rspec[2] = { BRCM_RATE_1M, BRCM_RATE_1M }, rts_rspec[2] = {
 	BRCM_RATE_1M, BRCM_RATE_1M};
 	bool use_rts = false;
 	bool use_cts = false;
@@ -8062,7 +8061,7 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 	struct brcms_d11rxhdr *wlc_rxh = (struct brcms_d11rxhdr *) rxh;
 	int preamble;
 	int channel;
-	ratespec_t rspec;
+	u32 rspec;
 	unsigned char *plcp;
 
 	/* fill in TSF and flag its presence */
@@ -8287,7 +8286,7 @@ void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p)
  *   len = 3(nsyms + nstream + 3) - 3
  */
 u16
-brcms_c_calc_lsig_len(struct brcms_c_info *wlc, ratespec_t ratespec,
+brcms_c_calc_lsig_len(struct brcms_c_info *wlc, u32 ratespec,
 		      uint mac_len)
 {
 	uint nsyms, len = 0, kNdps;
@@ -8328,7 +8327,7 @@ brcms_c_calc_lsig_len(struct brcms_c_info *wlc, ratespec_t ratespec,
 
 /* calculate frame duration of a given rate and length, return time in usec unit */
 uint
-brcms_c_calc_frame_time(struct brcms_c_info *wlc, ratespec_t ratespec,
+brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
 			u8 preamble_type, uint mac_len)
 {
 	uint nsyms, dur = 0, Ndps, kNdps;
@@ -8397,7 +8396,7 @@ brcms_c_calc_frame_time(struct brcms_c_info *wlc, ratespec_t ratespec,
 
 /* The opposite of brcms_c_calc_frame_time */
 static uint
-brcms_c_calc_frame_len(struct brcms_c_info *wlc, ratespec_t ratespec,
+brcms_c_calc_frame_len(struct brcms_c_info *wlc, u32 ratespec,
 		   u8 preamble_type, uint dur)
 {
 	uint nsyms, mac_len, Ndps, kNdps;
@@ -8443,7 +8442,7 @@ brcms_c_calc_frame_len(struct brcms_c_info *wlc, ratespec_t ratespec,
 }
 
 static uint
-brcms_c_calc_ba_time(struct brcms_c_info *wlc, ratespec_t rspec,
+brcms_c_calc_ba_time(struct brcms_c_info *wlc, u32 rspec,
 		     u8 preamble_type)
 {
 	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, "
@@ -8459,7 +8458,7 @@ brcms_c_calc_ba_time(struct brcms_c_info *wlc, ratespec_t rspec,
 }
 
 static uint
-brcms_c_calc_ack_time(struct brcms_c_info *wlc, ratespec_t rspec,
+brcms_c_calc_ack_time(struct brcms_c_info *wlc, u32 rspec,
 		      u8 preamble_type)
 {
 	uint dur = 0;
@@ -8478,7 +8477,7 @@ brcms_c_calc_ack_time(struct brcms_c_info *wlc, ratespec_t rspec,
 }
 
 static uint
-brcms_c_calc_cts_time(struct brcms_c_info *wlc, ratespec_t rspec,
+brcms_c_calc_cts_time(struct brcms_c_info *wlc, u32 rspec,
 		      u8 preamble_type)
 {
 	BCMMSG(wlc->wiphy, "wl%d: ratespec 0x%x, preamble_type %d\n",
@@ -8663,7 +8662,7 @@ void brcms_c_set_ratetable(struct brcms_c_info *wlc)
  * Return true if the specified rate is supported by the specified band.
  * BRCM_BAND_AUTO indicates the current band.
  */
-bool brcms_c_valid_rate(struct brcms_c_info *wlc, ratespec_t rspec, int band,
+bool brcms_c_valid_rate(struct brcms_c_info *wlc, u32 rspec, int band,
 		    bool verbose)
 {
 	wlc_rateset_t *hw_rateset;
@@ -8776,7 +8775,7 @@ void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
  */
 static void
 brcms_c_bcn_prb_template(struct brcms_c_info *wlc, u16 type,
-			 ratespec_t bcn_rspec,
+			 u32 bcn_rspec,
 			 struct brcms_bss_cfg *cfg, u16 *buf, int *len)
 {
 	static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
@@ -9049,7 +9048,7 @@ void brcms_default_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs)
 
 static void brcms_c_bss_default_init(struct brcms_c_info *wlc)
 {
-	chanspec_t chanspec;
+	u16 chanspec;
 	struct brcms_band *band;
 	struct brcms_bss_info *bi = wlc->default_bss;
 
@@ -9079,13 +9078,13 @@ static void brcms_c_bss_default_init(struct brcms_c_info *wlc)
 		bi->flags |= BRCMS_BSS_HT;
 }
 
-static ratespec_t
+static u32
 mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 		       u32 int_val)
 {
 	u8 stf = (int_val & NRATE_STF_MASK) >> NRATE_STF_SHIFT;
 	u8 rate = int_val & NRATE_RATE_MASK;
-	ratespec_t rspec;
+	u32 rspec;
 	bool ismcs = ((int_val & NRATE_MCS_INUSE) == NRATE_MCS_INUSE);
 	bool issgi = ((int_val & NRATE_SGI_MASK) >> NRATE_SGI_SHIFT);
 	bool override_mcs_only = ((int_val & NRATE_OVERRIDE_MCS_ONLY)
@@ -9093,7 +9092,7 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 	int bcmerror = 0;
 
 	if (!ismcs) {
-		return (ratespec_t) rate;
+		return (u32) rate;
 	}
 
 	/* validate the combination of rate/mcs/stf is allowed */
@@ -9301,7 +9300,7 @@ brcms_c_set_addrmatch(struct brcms_c_info *wlc, int match_reg_offset,
 		memcpy(wlc->cfg->BSSID, addr, ETH_ALEN);
 }
 
-void brcms_c_pllreq(struct brcms_c_info *wlc, bool set, mbool req_bit)
+void brcms_c_pllreq(struct brcms_c_info *wlc, bool set, u32 req_bit)
 {
 	brcms_b_pllreq(wlc->hw, set, req_bit);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index e61f047..1feefcf 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -394,8 +394,8 @@ struct brcms_band {
 
 	wlc_rateset_t defrateset;	/* band-specific copy of default_bss.rateset */
 
-	ratespec_t rspec_override;	/* 802.11 rate override */
-	ratespec_t mrspec_override;	/* multicast rate override */
+	u32 rspec_override;	/* 802.11 rate override */
+	u32 mrspec_override;	/* multicast rate override */
 	u8 band_stf_ss_mode;	/* Configured STF type, 0:siso; 1:cdd */
 	s8 band_stf_stbc_tx;	/* STBC TX 0:off; 1:force on; -1:auto */
 	wlc_rateset_t hw_rateset;	/* rates supported by chip (phy-specific) */
@@ -557,12 +557,12 @@ struct brcms_hardware {
 	bool up;		/* d11 hardware up and running */
 	uint now;		/* # elapsed seconds */
 	uint _nbands;		/* # bands supported */
-	chanspec_t chanspec;	/* bmac chanspec shadow */
+	u16 chanspec;	/* bmac chanspec shadow */
 
 	uint *txavail[NFIFO];	/* # tx descriptors available */
 	u16 *xmtfifo_sz;	/* fifo size in 256B for each xmt fifo */
 
-	mbool pllreq;		/* pll requests to keep PLL on */
+	u32 pllreq;		/* pll requests to keep PLL on */
 
 	u8 suspended_fifos;	/* Which TX fifo to remain awake for */
 	u32 maccontrol;	/* Cached value of maccontrol */
@@ -700,7 +700,7 @@ struct brcms_c_info {
 	u32 WDlast;		/* last time wlc_watchdog() was called */
 
 	/* WME */
-	ac_bitmap_t wme_dp;	/* Discard (oldest first) policy per AC */
+	u8 wme_dp;	/* AC bitmap. Discard (oldest first) policy per AC */
 	u16 edcf_txop[AC_COUNT];	/* current txop for each ac */
 
 	/*
@@ -756,10 +756,10 @@ struct brcms_c_info {
 						 * specifed
 						 */
 
-	chanspec_t home_chanspec;	/* shared home chanspec */
+	u16 home_chanspec;	/* shared home chanspec */
 
 	/* PHY parameters */
-	chanspec_t chanspec;	/* target operational channel */
+	u16 chanspec;	/* target operational channel */
 	u16 usr_fragthresh;	/* user configured fragmentation threshold */
 	u16 fragthresh[NFIFO];	/* per-fifo fragmentation thresholds */
 	u16 RTSThresh;	/* 802.11 dot11RTSThreshold */
@@ -778,7 +778,7 @@ struct brcms_c_info {
 
 	struct brcms_stf *stf;
 
-	ratespec_t bcn_rspec;	/* save bcn ratespec purpose */
+	u32 bcn_rspec;	/* save bcn ratespec purpose */
 
 	uint tempsense_lasttime;
 
@@ -865,9 +865,9 @@ struct brcms_bss_cfg {
 
 	int auth_atmptd;	/* auth type (open/shared) attempted */
 
-	pmkid_cand_t pmkid_cand[MAXPMKID];	/* PMKID candidate list */
+	struct pmkid_cand pmkid_cand[MAXPMKID];	/* PMKID candidate list */
 	uint npmkid_cand;	/* num PMKID candidates */
-	pmkid_t pmkid[MAXPMKID];	/* PMKID cache */
+	struct pmkid pmkid[MAXPMKID];	/* PMKID cache */
 	uint npmkid;		/* num cached PMKIDs */
 
 	struct brcms_bss_info *current_bss; /* BSS parms in ASSOCIATED state */
@@ -886,8 +886,8 @@ struct brcms_bss_cfg {
 	/* 'unique' ID of this bsscfg, assigned at bsscfg allocation */
 	u16 ID;
 
-	uint txrspecidx;	/* index into tx rate circular buffer */
-	ratespec_t txrspec[NTXRATE][2];	/* circular buffer of prev MPDUs tx rates */
+	uint txrspecidx;	 /* index into tx rate circular buffer */
+	u32 txrspec[NTXRATE][2]; /* circular buffer of prev MPDUs tx rates */
 };
 
 #define	CHANNEL_BANDUNIT(wlc, ch) (((ch) <= CH_MAX_2G_CHANNEL) ? BAND_2G_INDEX : BAND_5G_INDEX)
@@ -932,7 +932,7 @@ extern void brcms_c_write_template_ram(struct brcms_c_info *wlc, int offset,
 				       int len, void *buf);
 extern void brcms_c_write_hw_bcntemplates(struct brcms_c_info *wlc, void *bcn,
 					  int len, bool both);
-extern void brcms_c_pllreq(struct brcms_c_info *wlc, bool set, mbool req_bit);
+extern void brcms_c_pllreq(struct brcms_c_info *wlc, bool set, u32 req_bit);
 extern void brcms_c_reset_bmac_done(struct brcms_c_info *wlc);
 
 #if defined(BCMDBG)
@@ -945,7 +945,7 @@ extern void brcms_c_print_txdesc(struct d11txh *txh);
 extern void brcms_c_setxband(struct brcms_hardware *wlc_hw, uint bandunit);
 extern void brcms_c_coredisable(struct brcms_hardware *wlc_hw);
 
-extern bool brcms_c_valid_rate(struct brcms_c_info *wlc, ratespec_t rate,
+extern bool brcms_c_valid_rate(struct brcms_c_info *wlc, u32 rate,
 			       int band, bool verbose);
 extern void brcms_c_ap_upd(struct brcms_c_info *wlc);
 
@@ -971,14 +971,14 @@ extern void brcms_c_send_q(struct brcms_c_info *wlc);
 extern int brcms_c_prep_pdu(struct brcms_c_info *wlc, struct sk_buff *pdu,
 			    uint *fifo);
 
-extern u16 brcms_c_calc_lsig_len(struct brcms_c_info *wlc, ratespec_t ratespec,
+extern u16 brcms_c_calc_lsig_len(struct brcms_c_info *wlc, u32 ratespec,
 				uint mac_len);
-extern ratespec_t brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc,
-					     ratespec_t rspec,
+extern u32 brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc,
+					     u32 rspec,
 					     bool use_rspec, u16 mimo_ctlchbw);
 extern u16 brcms_c_compute_rtscts_dur(struct brcms_c_info *wlc, bool cts_only,
-				      ratespec_t rts_rate,
-				      ratespec_t frame_rate,
+				      u32 rts_rate,
+				      u32 frame_rate,
 				      u8 rts_preamble_type,
 				      u8 frame_preamble_type, uint frame_len,
 				      bool ba);
@@ -1012,15 +1012,15 @@ extern bool brcms_c_prec_enq(struct brcms_c_info *wlc, struct pktq *q,
 			     void *pkt, int prec);
 extern bool brcms_c_prec_enq_head(struct brcms_c_info *wlc, struct pktq *q,
 			      struct sk_buff *pkt, int prec, bool head);
-extern u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, ratespec_t rspec);
-extern void brcms_c_compute_plcp(struct brcms_c_info *wlc, ratespec_t rate,
+extern u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, u32 rspec);
+extern void brcms_c_compute_plcp(struct brcms_c_info *wlc, u32 rate,
 				 uint length, u8 *plcp);
 extern uint brcms_c_calc_frame_time(struct brcms_c_info *wlc,
-				    ratespec_t ratespec,
+				    u32 ratespec,
 				    u8 preamble_type, uint mac_len);
 
 extern void brcms_c_set_chanspec(struct brcms_c_info *wlc,
-				 chanspec_t chanspec);
+				 u16 chanspec);
 
 extern bool brcms_c_timers_init(struct brcms_c_info *wlc, int unit);
 
@@ -1036,15 +1036,15 @@ extern void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend);
 extern void brcms_c_set_ratetable(struct brcms_c_info *wlc);
 extern int brcms_c_set_mac(struct brcms_bss_cfg *cfg);
 extern void brcms_c_beacon_phytxctl_txant_upd(struct brcms_c_info *wlc,
-					  ratespec_t bcn_rate);
+					  u32 bcn_rate);
 extern void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc,
 					   uint frame_len);
-extern ratespec_t brcms_c_lowest_basic_rspec(struct brcms_c_info *wlc,
+extern u32 brcms_c_lowest_basic_rspec(struct brcms_c_info *wlc,
 					     wlc_rateset_t *rs);
 extern void brcms_c_radio_disable(struct brcms_c_info *wlc);
 extern void brcms_c_bcn_li_upd(struct brcms_c_info *wlc);
 extern void brcms_c_set_home_chanspec(struct brcms_c_info *wlc,
-				      chanspec_t chanspec);
+				      u16 chanspec);
 extern bool brcms_c_ps_allowed(struct brcms_c_info *wlc);
 extern bool brcms_c_stay_awake(struct brcms_c_info *wlc);
 extern void brcms_c_wme_initparams_sta(struct brcms_c_info *wlc,
@@ -1055,7 +1055,7 @@ extern void brcms_b_antsel_type_set(struct brcms_hardware *wlc_hw,
 
 /* chanspec, ucode interface */
 extern void brcms_b_set_chanspec(struct brcms_hardware *wlc_hw,
-				  chanspec_t chanspec,
+				  u16 chanspec,
 				  bool mute, struct txpwr_limits *txpwr);
 
 extern void brcms_b_write_shm(struct brcms_hardware *wlc_hw, uint offset,
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index f4224ef..13a447f 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -136,7 +136,9 @@ static void wlc_phy_noise_sample_request(struct brcms_phy_pub *pih, u8 reason,
 					 u8 ch);
 
 static void wlc_phy_txpower_reg_limit_calc(struct brcms_phy *pi,
-					   struct txpwr_limits *tp, chanspec_t);
+					   struct txpwr_limits *tp,
+					   u16 chanspec);
+
 static bool wlc_phy_cal_txpower_recalc_sw(struct brcms_phy *pi);
 
 static s8 wlc_user_txpwr_antport_to_rfport(struct brcms_phy *pi, uint chan,
@@ -862,7 +864,7 @@ void wlc_phy_hw_state_upd(struct brcms_phy_pub *pih, bool newstate)
 	pi->sh->up = newstate;
 }
 
-void wlc_phy_init(struct brcms_phy_pub *pih, chanspec_t chanspec)
+void wlc_phy_init(struct brcms_phy_pub *pih, u16 chanspec)
 {
 	u32 mc;
 	void (*phy_init) (struct brcms_phy *) = NULL;
@@ -1207,7 +1209,7 @@ void wlc_phy_do_dummy_tx(struct brcms_phy *pi, bool ofdm, bool pa_on)
 	}
 }
 
-void wlc_phy_hold_upd(struct brcms_phy_pub *pih, mbool id, bool set)
+void wlc_phy_hold_upd(struct brcms_phy_pub *pih, u32 id, bool set)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
@@ -1220,7 +1222,7 @@ void wlc_phy_hold_upd(struct brcms_phy_pub *pih, mbool id, bool set)
 	return;
 }
 
-void wlc_phy_mute_upd(struct brcms_phy_pub *pih, bool mute, mbool flags)
+void wlc_phy_mute_upd(struct brcms_phy_pub *pih, bool mute, u32 flags)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
@@ -1311,25 +1313,25 @@ void wlc_phy_bw_state_set(struct brcms_phy_pub *ppi, u16 bw)
 	pi->bw = bw;
 }
 
-void wlc_phy_chanspec_radio_set(struct brcms_phy_pub *ppi, chanspec_t newch)
+void wlc_phy_chanspec_radio_set(struct brcms_phy_pub *ppi, u16 newch)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	pi->radio_chanspec = newch;
 
 }
 
-chanspec_t wlc_phy_chanspec_get(struct brcms_phy_pub *ppi)
+u16 wlc_phy_chanspec_get(struct brcms_phy_pub *ppi)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	return pi->radio_chanspec;
 }
 
-void wlc_phy_chanspec_set(struct brcms_phy_pub *ppi, chanspec_t chanspec)
+void wlc_phy_chanspec_set(struct brcms_phy_pub *ppi, u16 chanspec)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	u16 m_cur_channel;
-	void (*chanspec_set) (struct brcms_phy *, chanspec_t) = NULL;
+	void (*chanspec_set) (struct brcms_phy *, u16) = NULL;
 	m_cur_channel = CHSPEC_CHANNEL(chanspec);
 	if (CHSPEC_IS5G(chanspec))
 		m_cur_channel |= D11_CURCHANNEL_5G;
@@ -1359,7 +1361,7 @@ int wlc_phy_chanspec_freq2bandrange_lpssn(uint freq)
 	return range;
 }
 
-int wlc_phy_chanspec_bandrange_get(struct brcms_phy *pi, chanspec_t chanspec)
+int wlc_phy_chanspec_bandrange_get(struct brcms_phy *pi, u16 chanspec)
 {
 	int range = -1;
 	uint channel = CHSPEC_CHANNEL(chanspec);
@@ -1395,13 +1397,13 @@ int wlc_phy_channel2freq(uint channel)
 
 void
 wlc_phy_chanspec_band_validch(struct brcms_phy_pub *ppi, uint band,
-			      chanvec_t *channels)
+			      struct brcms_chanvec *channels)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	uint i;
 	uint channel;
 
-	memset(channels, 0, sizeof(chanvec_t));
+	memset(channels, 0, sizeof(struct brcms_chanvec));
 
 	for (i = 0; i < ARRAY_SIZE(chan_info_all); i++) {
 		channel = chan_info_all[i].chan;
@@ -1416,12 +1418,12 @@ wlc_phy_chanspec_band_validch(struct brcms_phy_pub *ppi, uint band,
 	}
 }
 
-chanspec_t wlc_phy_chanspec_band_firstch(struct brcms_phy_pub *ppi, uint band)
+u16 wlc_phy_chanspec_band_firstch(struct brcms_phy_pub *ppi, uint band)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	uint i;
 	uint channel;
-	chanspec_t chspec;
+	u16 chspec;
 
 	for (i = 0; i < ARRAY_SIZE(chan_info_all); i++) {
 		channel = chan_info_all[i].chan;
@@ -1458,7 +1460,7 @@ chanspec_t wlc_phy_chanspec_band_firstch(struct brcms_phy_pub *ppi, uint band)
 			return chspec;
 	}
 
-	return (chanspec_t) INVCHANSPEC;
+	return (u16) INVCHANSPEC;
 }
 
 int wlc_phy_txpower_get(struct brcms_phy_pub *ppi, uint *qdbm, bool *override)
@@ -1668,7 +1670,7 @@ void wlc_phy_txpower_recalc_target(struct brcms_phy *pi)
 	u8 tx_pwr_max_rate_ind = 0;
 	u8 max_num_rate;
 	u8 start_rate = 0;
-	chanspec_t chspec;
+	u16 chspec;
 	u32 band = CHSPEC2BAND(pi->radio_chanspec);
 	void (*txpwr_recalc_fn)(struct brcms_phy *) = NULL;
 
@@ -1779,7 +1781,7 @@ void wlc_phy_txpower_recalc_target(struct brcms_phy *pi)
 
 void
 wlc_phy_txpower_reg_limit_calc(struct brcms_phy *pi, struct txpwr_limits *txpwr,
-			       chanspec_t chanspec)
+			       u16 chanspec)
 {
 	u8 tmp_txpwr_limit[2 * BRCMS_NUM_RATES_OFDM];
 	u8 *txpwr_ptr1 = NULL, *txpwr_ptr2 = NULL;
@@ -1974,7 +1976,7 @@ void wlc_phy_runbist_config(struct brcms_phy_pub *ppi, bool start_end)
 
 void
 wlc_phy_txpower_limit_set(struct brcms_phy_pub *ppi, struct txpwr_limits *txpwr,
-			  chanspec_t chanspec)
+			  u16 chanspec)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
@@ -2847,7 +2849,7 @@ wlc_phy_papd_decode_epsilon(u32 epsilon, s32 *eps_real, s32 *eps_imag)
 		*eps_real -= 0x2000;
 }
 
-static const fixed AtanTbl[] = {
+static const s32 AtanTbl[] = {
 	2949120,
 	1740967,
 	919879,
@@ -2868,9 +2870,9 @@ static const fixed AtanTbl[] = {
 	29
 };
 
-void wlc_phy_cordic(fixed theta, cs32 *val)
+void wlc_phy_cordic(s32 theta, struct cs32 *val)
 {
-	fixed angle, valtmp;
+	s32 angle, valtmp;
 	unsigned iter;
 	int signx = 1;
 	int signtheta;
@@ -3094,7 +3096,7 @@ u8 wlc_phy_stf_chain_active_get(struct brcms_phy_pub *pih)
 	return active_bitmap;
 }
 
-s8 wlc_phy_stf_ssmode_get(struct brcms_phy_pub *pih, chanspec_t chanspec)
+s8 wlc_phy_stf_ssmode_get(struct brcms_phy_pub *pih, u16 chanspec)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	u8 siso_mcs_id, cdd_mcs_id;
@@ -3207,7 +3209,7 @@ wlc_phy_get_pwrdet_offsets(struct brcms_phy *pi, s8 *cckoffset, s8 *ofdmoffset)
 	*ofdmoffset = 0;
 }
 
-s8 wlc_phy_upd_rssi_offset(struct brcms_phy *pi, s8 rssi, chanspec_t chanspec)
+s8 wlc_phy_upd_rssi_offset(struct brcms_phy *pi, s8 rssi, u16 chanspec)
 {
 
 	return rssi;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
index e27d9e9..bc0cc59 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
@@ -126,8 +126,8 @@ struct txpwr_limits {
 
 struct tx_power {
 	u32 flags;
-	chanspec_t chanspec;	/* txpwr report for this channel */
-	chanspec_t local_chanspec;	/* channel on which we are associated */
+	u16 chanspec;	/* txpwr report for this channel */
+	u16 local_chanspec;	/* channel on which we are associated */
 	u8 local_max;	/* local max according to the AP */
 	u8 local_constraint;	/* local constraint according to the AP */
 	s8 antgain[2];	/* Ant gain for each band - from SROM */
@@ -150,7 +150,7 @@ struct tx_inst_power {
 	u8 txpwr_est_Pout_gofdm;	/* Pwr estimate for 2.4 OFDM */
 };
 
-struct chanvec {
+struct brcms_chanvec {
 	u8 vec[MAXCHANNEL / NBBY];
 };
 
@@ -189,7 +189,7 @@ extern u32 wlc_phy_get_coreflags(struct brcms_phy_pub *pih);
 
 extern void wlc_phy_hw_clk_state_upd(struct brcms_phy_pub *ppi, bool newstate);
 extern void wlc_phy_hw_state_upd(struct brcms_phy_pub *ppi, bool newstate);
-extern void wlc_phy_init(struct brcms_phy_pub *ppi, chanspec_t chanspec);
+extern void wlc_phy_init(struct brcms_phy_pub *ppi, u16 chanspec);
 extern void wlc_phy_watchdog(struct brcms_phy_pub *ppi);
 extern int wlc_phy_down(struct brcms_phy_pub *ppi);
 extern u32 wlc_phy_clk_bwbits(struct brcms_phy_pub *pih);
@@ -197,10 +197,10 @@ extern void wlc_phy_cal_init(struct brcms_phy_pub *ppi);
 extern void wlc_phy_antsel_init(struct brcms_phy_pub *ppi, bool lut_init);
 
 extern void wlc_phy_chanspec_set(struct brcms_phy_pub *ppi,
-				 chanspec_t chanspec);
-extern chanspec_t wlc_phy_chanspec_get(struct brcms_phy_pub *ppi);
+				 u16 chanspec);
+extern u16 wlc_phy_chanspec_get(struct brcms_phy_pub *ppi);
 extern void wlc_phy_chanspec_radio_set(struct brcms_phy_pub *ppi,
-				       chanspec_t newch);
+				       u16 newch);
 extern u16 wlc_phy_bw_state_get(struct brcms_phy_pub *ppi);
 extern void wlc_phy_bw_state_set(struct brcms_phy_pub *ppi, u16 bw);
 
@@ -220,8 +220,8 @@ extern void wlc_phy_BSSinit(struct brcms_phy_pub *ppi, bool bonlyap, int rssi);
 extern void wlc_phy_chanspec_ch14_widefilter_set(struct brcms_phy_pub *ppi,
 						 bool wide_filter);
 extern void wlc_phy_chanspec_band_validch(struct brcms_phy_pub *ppi, uint band,
-					  chanvec_t *channels);
-extern chanspec_t wlc_phy_chanspec_band_firstch(struct brcms_phy_pub *ppi,
+					  struct brcms_chanvec *channels);
+extern u16 wlc_phy_chanspec_band_firstch(struct brcms_phy_pub *ppi,
 						uint band);
 
 extern void wlc_phy_txpower_sromlimit(struct brcms_phy_pub *ppi, uint chan,
@@ -232,7 +232,7 @@ extern void wlc_phy_txpower_boardlimit_band(struct brcms_phy_pub *ppi,
 					    uint band, s32 *, s32 *, u32 *);
 extern void wlc_phy_txpower_limit_set(struct brcms_phy_pub *ppi,
 				      struct txpwr_limits *,
-				      chanspec_t chanspec);
+				      u16 chanspec);
 extern int wlc_phy_txpower_get(struct brcms_phy_pub *ppi, uint *qdbm,
 			       bool *override);
 extern int wlc_phy_txpower_set(struct brcms_phy_pub *ppi, uint qdbm,
@@ -254,7 +254,7 @@ extern void wlc_phy_stf_chain_get(struct brcms_phy_pub *pih, u8 *txchain,
 				  u8 *rxchain);
 extern u8 wlc_phy_stf_chain_active_get(struct brcms_phy_pub *pih);
 extern s8 wlc_phy_stf_ssmode_get(struct brcms_phy_pub *pih,
-				 chanspec_t chanspec);
+				 u16 chanspec);
 extern void wlc_phy_ldpc_override_set(struct brcms_phy_pub *ppi, bool val);
 
 extern void wlc_phy_cal_perical(struct brcms_phy_pub *ppi, u8 reason);
@@ -264,8 +264,8 @@ extern void wlc_phy_cal_papd_recal(struct brcms_phy_pub *ppi);
 
 extern void wlc_phy_ant_rxdiv_set(struct brcms_phy_pub *ppi, u8 val);
 extern void wlc_phy_clear_tssi(struct brcms_phy_pub *ppi);
-extern void wlc_phy_hold_upd(struct brcms_phy_pub *ppi, mbool id, bool val);
-extern void wlc_phy_mute_upd(struct brcms_phy_pub *ppi, bool val, mbool flags);
+extern void wlc_phy_hold_upd(struct brcms_phy_pub *ppi, u32 id, bool val);
+extern void wlc_phy_mute_upd(struct brcms_phy_pub *ppi, bool val, u32 flags);
 
 extern void wlc_phy_antsel_type_set(struct brcms_phy_pub *ppi, u8 antsel_type);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index 7dae802..6d468e7 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -570,7 +570,7 @@ struct brcms_phy_pub {
 struct phy_func_ptr {
 	void (*init) (struct brcms_phy *);
 	void (*calinit) (struct brcms_phy *);
-	void (*chanset) (struct brcms_phy *, chanspec_t);
+	void (*chanset) (struct brcms_phy *, u16 chanspec);
 	void (*txpwrrecalc) (struct brcms_phy *);
 	int (*longtrn) (struct brcms_phy *, int);
 	void (*txiqccget) (struct brcms_phy *, u16 *, u16 *);
@@ -602,7 +602,7 @@ struct brcms_phy {
 	bool phytest_on;
 	bool ofdm_rateset_war;
 	bool bf_preempt_4306;
-	chanspec_t radio_chanspec;
+	u16 radio_chanspec;
 	u8 antsel_type;
 	u16 bw;
 	u8 txpwr_percent;
@@ -618,7 +618,7 @@ struct brcms_phy {
 	int phynoise_chan_watchdog;
 	bool phynoise_polling;
 	bool disable_percal;
-	mbool measure_hold;
+	u32 measure_hold;
 
 	s16 txpa_2g[PWRTBL_NUM_COEFF];
 	s16 txpa_2g_low_temp[PWRTBL_NUM_COEFF];
@@ -829,11 +829,11 @@ struct brcms_phy {
 	u8 mphase_txcal_cmdidx;
 	u8 mphase_txcal_numcmds;
 	u16 mphase_txcal_bestcoeffs[11];
-	chanspec_t nphy_txiqlocal_chanspec;
-	chanspec_t nphy_iqcal_chanspec_2G;
-	chanspec_t nphy_iqcal_chanspec_5G;
-	chanspec_t nphy_rssical_chanspec_2G;
-	chanspec_t nphy_rssical_chanspec_5G;
+	u16 nphy_txiqlocal_chanspec;
+	u16 nphy_iqcal_chanspec_2G;
+	u16 nphy_iqcal_chanspec_5G;
+	u16 nphy_rssical_chanspec_2G;
+	u16 nphy_rssical_chanspec_5G;
 	struct wlapi_timer *phycal_timer;
 	bool use_int_tx_iqlo_cal_nphy;
 	bool internal_tx_iqlo_cal_tapoff_intpa_nphy;
@@ -926,9 +926,9 @@ struct brcms_phy {
 	struct wiphy *wiphy;
 };
 
-struct _cs32 {
-	fixed q;
-	fixed i;
+struct cs32 {
+	s32 q;
+	s32 i;
 };
 
 struct radio_regs {
@@ -1011,7 +1011,7 @@ extern void wlc_phy_table_data_write(struct brcms_phy *pi, uint width, u32 val);
 extern void write_phy_channel_reg(struct brcms_phy *pi, uint val);
 extern void wlc_phy_txpower_update_shm(struct brcms_phy *pi);
 
-extern void wlc_phy_cordic(fixed theta, cs32 *val);
+extern void wlc_phy_cordic(s32 theta, struct cs32 *val);
 extern u8 wlc_phy_nbits(s32 value);
 extern void wlc_phy_compute_dB(u32 *cmplx_pwr, s8 *p_dB, u8 core);
 
@@ -1042,14 +1042,14 @@ extern void wlc_phy_cal_init_nphy(struct brcms_phy *pi);
 extern void wlc_phy_cal_init_lcnphy(struct brcms_phy *pi);
 
 extern void wlc_phy_chanspec_set_nphy(struct brcms_phy *pi,
-				      chanspec_t chanspec);
+				      u16 chanspec);
 extern void wlc_phy_chanspec_set_lcnphy(struct brcms_phy *pi,
-					chanspec_t chanspec);
+					u16 chanspec);
 extern void wlc_phy_chanspec_set_fixup_lcnphy(struct brcms_phy *pi,
-					      chanspec_t chanspec);
+					      u16 chanspec);
 extern int wlc_phy_channel2freq(uint channel);
 extern int wlc_phy_chanspec_freq2bandrange_lpssn(uint);
-extern int wlc_phy_chanspec_bandrange_get(struct brcms_phy *, chanspec_t);
+extern int wlc_phy_chanspec_bandrange_get(struct brcms_phy *, u16 chanspec);
 
 extern void wlc_lcnphy_set_tx_pwr_ctrl(struct brcms_phy *pi, u16 mode);
 extern s8 wlc_lcnphy_get_current_tx_pwr_idx(struct brcms_phy *pi);
@@ -1218,7 +1218,7 @@ extern void wlc_phy_nphy_tkip_rifs_war(struct brcms_phy *pi, u8 rifs);
 void wlc_phy_get_pwrdet_offsets(struct brcms_phy *pi, s8 *cckoffset,
 				s8 *ofdmoffset);
 extern s8 wlc_phy_upd_rssi_offset(struct brcms_phy *pi, s8 rssi,
-				    chanspec_t chanspec);
+				    u16 chanspec);
 
 extern bool wlc_phy_n_txpower_ipa_ison(struct brcms_phy *pih);
 #endif				/* _BRCM_PHY_INT_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index 6a3fbe6..c232f50 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -1008,7 +1008,7 @@ static void wlc_lcnphy_a1(struct brcms_phy *pi, int cal_type,
 static void wlc_lcnphy_tx_iqlo_soft_cal_full(struct brcms_phy *pi);
 
 static void wlc_lcnphy_set_chanspec_tweaks(struct brcms_phy *pi,
-					   chanspec_t chanspec);
+					   u16 chanspec);
 static void wlc_lcnphy_agc_temp_init(struct brcms_phy *pi);
 static void wlc_lcnphy_temp_adj(struct brcms_phy *pi);
 static void wlc_lcnphy_clear_papd_comptable(struct brcms_phy *pi);
@@ -1200,7 +1200,7 @@ wlc_lcnphy_txrx_spur_avoidance_mode(struct brcms_phy *pi, bool enable)
 	wlapi_switch_macfreq(pi->sh->physhim, enable);
 }
 
-void wlc_phy_chanspec_set_lcnphy(struct brcms_phy *pi, chanspec_t chanspec)
+void wlc_phy_chanspec_set_lcnphy(struct brcms_phy *pi, u16 chanspec)
 {
 	u8 channel = CHSPEC_CHANNEL(chanspec);
 
@@ -2714,8 +2714,8 @@ wlc_lcnphy_start_tx_tone(struct brcms_phy *pi, s32 f_kHz, u16 max_val,
 	u8 phy_bw;
 	u16 num_samps, t, k;
 	u32 bw;
-	fixed theta = 0, rot = 0;
-	cs32 tone_samp;
+	s32 theta = 0, rot = 0;
+	struct cs32 tone_samp;
 	u32 data_buf[64];
 	u16 i_samp, q_samp;
 	struct phytbl_info tab;
@@ -3592,7 +3592,7 @@ void wlc_phy_cal_init_lcnphy(struct brcms_phy *pi)
 }
 
 static void
-wlc_lcnphy_set_chanspec_tweaks(struct brcms_phy *pi, chanspec_t chanspec)
+wlc_lcnphy_set_chanspec_tweaks(struct brcms_phy *pi, u16 chanspec)
 {
 	u8 channel = CHSPEC_CHANNEL(chanspec);
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
@@ -4841,7 +4841,7 @@ wlc_lcnphy_radio_2064_channel_tune_4313(struct brcms_phy *pi, u8 channel)
 	const struct chan_info_2064_lcnphy *ci;
 	u8 rfpll_doubler = 0;
 	u8 pll_pwrup, pll_pwrup_ovr;
-	fixed qFxtal, qFref, qFvco, qFcal;
+	s32 qFxtal, qFref, qFvco, qFcal;
 	u8 d15, d16, f16, e44, e45;
 	u32 div_int, div_frac, fvco3, fpfd, fref3, fcal_div;
 	u16 loop_bw, d30, setCount;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index f8e4192..b4ac0d1 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -14090,7 +14090,7 @@ static bool wlc_phy_chan2freq_nphy(struct brcms_phy *pi, uint channel, int *f,
 				   struct chan_info_nphy_radio205x **t1,
 				   struct chan_info_nphy_radio2057_rev5 **t2,
 				   struct chan_info_nphy_2055 **t3);
-static void wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, chanspec_t chans,
+static void wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chans,
 					const struct nphy_sfo_cfg *c);
 
 static void wlc_phy_adjust_rx_analpfbw_nphy(struct brcms_phy *pi,
@@ -14188,8 +14188,8 @@ static u16 wlc_phy_radio2057_rccal(struct brcms_phy *pi);
 static u16 wlc_phy_gen_load_samples_nphy(struct brcms_phy *pi, u32 f_kHz,
 					    u16 max_val,
 					    u8 dac_test_mode);
-static void wlc_phy_loadsampletable_nphy(struct brcms_phy *pi, cs32 *tone_buf,
-					 u16 num_samps);
+static void wlc_phy_loadsampletable_nphy(struct brcms_phy *pi,
+					 struct cs32 *tone_buf, u16 num_samps);
 static void wlc_phy_runsamples_nphy(struct brcms_phy *pi, u16 n, u16 lps,
 				    u16 wait, u8 iq, u8 dac_test_mode,
 				    bool modify_bbmult);
@@ -18912,7 +18912,7 @@ static void wlc_phy_spurwar_nphy(struct brcms_phy *pi)
 }
 
 static void
-wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, chanspec_t chanspec,
+wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chanspec,
 			    const struct nphy_sfo_cfg *ci)
 {
 	u16 val;
@@ -19047,7 +19047,7 @@ wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, chanspec_t chanspec,
 	wlc_phy_spurwar_nphy(pi);
 }
 
-void wlc_phy_chanspec_set_nphy(struct brcms_phy *pi, chanspec_t chanspec)
+void wlc_phy_chanspec_set_nphy(struct brcms_phy *pi, u16 chanspec)
 {
 	int freq;
 	struct chan_info_nphy_radio2057 *t0 = NULL;
@@ -22241,9 +22241,9 @@ wlc_phy_gen_load_samples_nphy(struct brcms_phy *pi, u32 f_kHz, u16 max_val,
 {
 	u8 phy_bw, is_phybw40;
 	u16 num_samps, t, spur;
-	fixed theta = 0, rot = 0;
+	s32 theta = 0, rot = 0;
 	u32 tbl_len;
-	cs32 *tone_buf = NULL;
+	struct cs32 *tone_buf = NULL;
 
 	is_phybw40 = CHSPEC_IS40(pi->radio_chanspec);
 	phy_bw = (is_phybw40 == 1) ? 40 : 20;
@@ -22258,7 +22258,7 @@ wlc_phy_gen_load_samples_nphy(struct brcms_phy *pi, u32 f_kHz, u16 max_val,
 		tbl_len = (phy_bw << 1);
 	}
 
-	tone_buf = kmalloc(sizeof(cs32) * tbl_len, GFP_ATOMIC);
+	tone_buf = kmalloc(sizeof(struct cs32) * tbl_len, GFP_ATOMIC);
 	if (tone_buf == NULL) {
 		return 0;
 	}
@@ -22305,7 +22305,7 @@ wlc_phy_tx_tone_nphy(struct brcms_phy *pi, u32 f_kHz, u16 max_val,
 }
 
 static void
-wlc_phy_loadsampletable_nphy(struct brcms_phy *pi, cs32 *tone_buf,
+wlc_phy_loadsampletable_nphy(struct brcms_phy *pi, struct cs32 *tone_buf,
 			     u16 num_samps)
 {
 	u16 t;
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 8ec398a..a5d91df 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -171,7 +171,7 @@ struct brcms_bss_info {
 	s16 SNR;		/* receive signal SNR in dB */
 	u16 beacon_period;	/* units are Kusec */
 	u16 atim_window;	/* units are Kusec */
-	chanspec_t chanspec;	/* Channel num, bw, ctrl_sb and band */
+	u16 chanspec;	/* Channel num, bw, ctrl_sb and band */
 	s8 infra;		/* 0=IBSS, 1=infrastructure, 2=unknown */
 	wlc_rateset_t rateset;	/* supported rates */
 	u8 dtim_period;	/* DTIM period */
@@ -265,7 +265,7 @@ struct brcms_pub {
 
 	int bcmerror;		/* last bcm error */
 
-	mbool radio_disabled;	/* bit vector for radio disabled reasons */
+	u32 radio_disabled;	/* bit vector for radio disabled reasons */
 	bool radio_active;	/* radio on/off state */
 	u16 roam_time_thresh;	/* Max. # secs. of not hearing beacons
 					 * before roaming.
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.c b/drivers/staging/brcm80211/brcmsmac/rate.c
index f0e4b99..dac285e 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/rate.c
@@ -328,10 +328,10 @@ brcms_c_rate_hwrs_filter_sort_validate(wlc_rateset_t *rs,
 }
 
 /* calculate the rate of a rx'd frame and return it as a ratespec */
-ratespec_t brcms_c_compute_rspec(struct d11rxhdr *rxh, u8 *plcp)
+u32 brcms_c_compute_rspec(struct d11rxhdr *rxh, u8 *plcp)
 {
 	int phy_type;
-	ratespec_t rspec = PHY_TXC1_BW_20MHZ << RSPEC_BW_SHIFT;
+	u32 rspec = PHY_TXC1_BW_20MHZ << RSPEC_BW_SHIFT;
 
 	phy_type =
 	    ((rxh->RxChan & RXS_CHAN_PHYTYPE_MASK) >> RXS_CHAN_PHYTYPE_SHIFT);
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.h b/drivers/staging/brcm80211/brcmsmac/rate.h
index dbfd3e5..9903bb5 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.h
+++ b/drivers/staging/brcm80211/brcmsmac/rate.h
@@ -111,7 +111,7 @@ extern const struct brcms_mcs_info mcs_table[];
 #define PLCP3_STC_MASK          0x30
 #define PLCP3_STC_SHIFT         4
 
-/* Rate info table; takes a legacy rate or ratespec_t */
+/* Rate info table; takes a legacy rate or u32 */
 #define	IS_MCS(r)	(r & RSPEC_MIMORATE)
 #define	IS_OFDM(r)	(!IS_MCS(r) && (rate_info[(r) & RSPEC_RATE_MASK] & \
 					BRCMS_RATE_FLAG))
@@ -150,7 +150,7 @@ extern void brcms_c_rateset_copy(const struct brcms_rateset *src,
 			     struct brcms_rateset *dst);
 
 /* would be nice to have these documented ... */
-extern ratespec_t brcms_c_compute_rspec(struct d11rxhdr *rxh, u8 *plcp);
+extern u32 brcms_c_compute_rspec(struct d11rxhdr *rxh, u8 *plcp);
 
 extern void brcms_c_rateset_filter(struct brcms_rateset *src,
 	struct brcms_rateset *dst, bool basic_only, u8 rates, uint xmask,
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index 84fca47..f6a4b66 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -37,7 +37,7 @@ static void brcms_c_stf_stbc_rx_ht_update(struct brcms_c_info *wlc, int val);
 
 static void _brcms_c_stf_phy_txant_upd(struct brcms_c_info *wlc);
 static u16 _brcms_c_stf_phytxchain_sel(struct brcms_c_info *wlc,
-				       ratespec_t rspec);
+				       u32 rspec);
 
 #define NSTS_1	1
 #define NSTS_2	2
@@ -94,7 +94,7 @@ void brcms_c_tempsense_upd(struct brcms_c_info *wlc)
 
 void
 brcms_c_stf_ss_algo_channel_get(struct brcms_c_info *wlc, u16 *ss_algo_channel,
-			    chanspec_t chanspec)
+			    u16 chanspec)
 {
 	struct tx_power power;
 	u8 siso_mcs_id, cdd_mcs_id, stbc_mcs_id;
@@ -444,7 +444,7 @@ void brcms_c_stf_phy_chain_calc(struct brcms_c_info *wlc)
 }
 
 static u16 _brcms_c_stf_phytxchain_sel(struct brcms_c_info *wlc,
-				       ratespec_t rspec)
+				       u32 rspec)
 {
 	u16 phytxant = wlc->stf->phytxant;
 
@@ -456,12 +456,12 @@ static u16 _brcms_c_stf_phytxchain_sel(struct brcms_c_info *wlc,
 	return phytxant;
 }
 
-u16 brcms_c_stf_phytxchain_sel(struct brcms_c_info *wlc, ratespec_t rspec)
+u16 brcms_c_stf_phytxchain_sel(struct brcms_c_info *wlc, u32 rspec)
 {
 	return _brcms_c_stf_phytxchain_sel(wlc, rspec);
 }
 
-u16 brcms_c_stf_d11hdrs_phyctl_txant(struct brcms_c_info *wlc, ratespec_t rspec)
+u16 brcms_c_stf_d11hdrs_phyctl_txant(struct brcms_c_info *wlc, u32 rspec)
 {
 	u16 phytxant = wlc->stf->phytxant;
 	u16 mask = PHY_TXC_ANT_MASK;
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.h b/drivers/staging/brcm80211/brcmsmac/stf.h
index 06c2a39..19f6580 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.h
+++ b/drivers/staging/brcm80211/brcmsmac/stf.h
@@ -25,7 +25,7 @@ extern void brcms_c_stf_detach(struct brcms_c_info *wlc);
 extern void brcms_c_tempsense_upd(struct brcms_c_info *wlc);
 extern void brcms_c_stf_ss_algo_channel_get(struct brcms_c_info *wlc,
 					u16 *ss_algo_channel,
-					chanspec_t chanspec);
+					u16 chanspec);
 extern int brcms_c_stf_ss_update(struct brcms_c_info *wlc,
 			     struct brcms_band *band);
 extern void brcms_c_stf_phy_txant_upd(struct brcms_c_info *wlc);
@@ -35,8 +35,8 @@ extern bool brcms_c_stf_stbc_rx_set(struct brcms_c_info *wlc, s32 int_val);
 extern void brcms_c_stf_phy_txant_upd(struct brcms_c_info *wlc);
 extern void brcms_c_stf_phy_chain_calc(struct brcms_c_info *wlc);
 extern u16 brcms_c_stf_phytxchain_sel(struct brcms_c_info *wlc,
-				      ratespec_t rspec);
+				      u32 rspec);
 extern u16 brcms_c_stf_d11hdrs_phyctl_txant(struct brcms_c_info *wlc,
-					ratespec_t rspec);
+					u32 rspec);
 
 #endif				/* _BRCM_STF_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index 823b5e4..23ce168 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -351,7 +351,6 @@ do {						\
 		W_REG((r), ((R_REG(r) & ~(mask)) | (val)))
 
 /* multi-bool data type: set of bools, mbool is true if any is set */
-typedef u32 mbool;
 #define mboolset(mb, bit)		((mb) |= (bit))	/* set one bool */
 #define mboolclr(mb, bit)		((mb) &= ~(bit))	/* clear one bool */
 #define mboolisset(mb, bit)		(((mb) & (bit)) != 0)	/* true if one bool is set */
@@ -387,10 +386,6 @@ typedef volatile struct d11regs d11regs_t;
 typedef volatile struct dma32diag dma32diag_t;
 typedef volatile struct dma64regs dma64regs_t;
 typedef struct brcms_rateset wlc_rateset_t;
-typedef u32 ratespec_t;
-typedef struct chanvec chanvec_t;
-typedef s32 fixed;
-typedef struct _cs32 cs32;
 typedef volatile union pmqreg pmqreg_t;
 
 /* brcm_msg_level is a bit vector with defs in defs.h */
diff --git a/drivers/staging/brcm80211/brcmutil/wifi.c b/drivers/staging/brcm80211/brcmutil/wifi.c
index b9ffe86..e8f7f56 100644
--- a/drivers/staging/brcm80211/brcmutil/wifi.c
+++ b/drivers/staging/brcm80211/brcmutil/wifi.c
@@ -21,7 +21,7 @@
  * combination could be legal given any set of circumstances.
  * RETURNS: true is the chanspec is malformed, false if it looks good.
  */
-bool brcmu_chspec_malformed(chanspec_t chanspec)
+bool brcmu_chspec_malformed(u16 chanspec)
 {
 	/* must be 2G or 5G band */
 	if (!CHSPEC_IS5G(chanspec) && !CHSPEC_IS2G(chanspec))
@@ -48,7 +48,7 @@ EXPORT_SYMBOL(brcmu_chspec_malformed);
  * channels this is just the channel number, for 40MHZ channels it is the upper or lowre 20MHZ
  * sideband depending on the chanspec selected
  */
-u8 brcmu_chspec_ctlchan(chanspec_t chspec)
+u8 brcmu_chspec_ctlchan(u16 chspec)
 {
 	u8 ctl_chan;
 
diff --git a/drivers/staging/brcm80211/include/brcmu_wifi.h b/drivers/staging/brcm80211/include/brcmu_wifi.h
index fde592b..949349f 100644
--- a/drivers/staging/brcm80211/include/brcmu_wifi.h
+++ b/drivers/staging/brcm80211/include/brcmu_wifi.h
@@ -20,8 +20,10 @@
 #include <linux/if_ether.h>		/* for ETH_ALEN */
 #include <linux/ieee80211.h>		/* for WLAN_PMKID_LEN */
 
-/* A chanspec holds the channel number, band, bandwidth and control sideband */
-typedef u16 chanspec_t;
+/*
+ * A chanspec (u16) holds the channel number, band, bandwidth and control
+ * sideband
+ */
 
 /* channel defines */
 #define CH_UPPER_SB			0x01
@@ -69,12 +71,12 @@ typedef u16 chanspec_t;
 				((channel) + CH_10MHZ_APART) : 0)
 #define CHSPEC_BANDUNIT(chspec)	(CHSPEC_IS5G(chspec) ? BAND_5G_INDEX : \
 						       BAND_2G_INDEX)
-#define CH20MHZ_CHSPEC(channel)	(chanspec_t)((chanspec_t)(channel) | WL_CHANSPEC_BW_20 | \
+#define CH20MHZ_CHSPEC(channel)	(u16)((u16)(channel) | WL_CHANSPEC_BW_20 | \
 				WL_CHANSPEC_CTL_SB_NONE | (((channel) <= CH_MAX_2G_CHANNEL) ? \
 				WL_CHANSPEC_BAND_2G : WL_CHANSPEC_BAND_5G))
 #define NEXT_20MHZ_CHAN(channel)	(((channel) < (MAXCHANNEL - CH_20MHZ_APART)) ? \
 					((channel) + CH_20MHZ_APART) : 0)
-#define CH40MHZ_CHSPEC(channel, ctlsb)	(chanspec_t) \
+#define CH40MHZ_CHSPEC(channel, ctlsb)	(u16) \
 					((channel) | (ctlsb) | WL_CHANSPEC_BW_40 | \
 					((channel) <= CH_MAX_2G_CHANNEL ? WL_CHANSPEC_BAND_2G : \
 					WL_CHANSPEC_BAND_5G))
@@ -142,14 +144,14 @@ typedef u16 chanspec_t;
  * combination could be legal given any set of circumstances.
  * RETURNS: true is the chanspec is malformed, false if it looks good.
  */
-extern bool brcmu_chspec_malformed(chanspec_t chanspec);
+extern bool brcmu_chspec_malformed(u16 chanspec);
 
 /*
  * This function returns the channel number that control traffic is being sent on, for legacy
  * channels this is just the channel number, for 40MHZ channels it is the upper or lowre 20MHZ
  * sideband depending on the chanspec selected
  */
-extern u8 brcmu_chspec_ctlchan(chanspec_t chspec);
+extern u8 brcmu_chspec_ctlchan(u16 chspec);
 
 /*
  * Return the channel number for a given frequency and base frequency.
@@ -218,26 +220,24 @@ extern int brcmu_mhz2channel(uint freq, uint start_factor);
 #define HT_CAP_RX_STBC_NO		0x0
 #define HT_CAP_RX_STBC_ONE_STREAM	0x1
 
-typedef struct _pmkid {
+struct pmkid {
 	u8 BSSID[ETH_ALEN];
 	u8 PMKID[WLAN_PMKID_LEN];
-} pmkid_t;
+};
 
-typedef struct _pmkid_list {
+struct pmkid_list {
 	u32 npmkid;
-	pmkid_t pmkid[1];
-} pmkid_list_t;
+	struct pmkid pmkid[1];
+};
 
-typedef struct _pmkid_cand {
+struct pmkid_cand {
 	u8 BSSID[ETH_ALEN];
 	u8 preauth;
-} pmkid_cand_t;
+};
 
-typedef struct _pmkid_cand_list {
+struct pmkid_cand_list {
 	u32 npmkid_cand;
-	pmkid_cand_t pmkid_cand[1];
-} pmkid_cand_list_t;
-
-typedef u8 ac_bitmap_t;
+	struct pmkid_cand pmkid_cand[1];
+};
 
 #endif				/* _BRCMU_WIFI_H_ */
-- 
1.7.4.1


