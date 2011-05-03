Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2331 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab1ECJgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 10/61] staging: brcm80211: replaced WL_ERROR in rest of
 softmac.
Date: Tue, 3 May 2011 11:35:10 +0200
Message-ID: <1304415361-7813-11-git-send-email-arend@broadcom.com> (sfid-20110503_113848_366262_118F611B)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Replaced proprietary function by wiphy_err(). Removed
WL_ERROR() on spots where struct wlc was not available and message
was redundant.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_dbg.h       |    2 -
 drivers/staging/brcm80211/brcmsmac/wlc_alloc.c    |    2 -
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c  |   29 ++++++++-------------
 drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c |    5 ++-
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c      |   12 ++++++---
 5 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h b/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
index 8705b40..bdc0f85 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
+++ b/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
@@ -28,7 +28,6 @@ do {						\
 
 #ifdef BCMDBG
 
-#define	WL_ERROR(fmt, args...)	WL_PRINT(WL_ERROR_VAL, fmt, ##args)
 #define	WL_TRACE(fmt, args...)	WL_PRINT(WL_TRACE_VAL, fmt, ##args)
 #define WL_AMPDU(fmt, args...)	WL_PRINT(WL_AMPDU_VAL, fmt, ##args)
 #define WL_FFPLD(fmt, args...)	WL_PRINT(WL_FFPLD_VAL, fmt, ##args)
@@ -76,7 +75,6 @@ do {						\
 
 #else				/* BCMDBG */
 
-#define	WL_ERROR(fmt, args...)		no_printk(fmt, ##args)
 #define	WL_TRACE(fmt, args...)		no_printk(fmt, ##args)
 #define WL_AMPDU(fmt, args...)		no_printk(fmt, ##args)
 #define WL_FFPLD(fmt, args...)		no_printk(fmt, ##args)
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
index e928fa1..d93bd6a 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
@@ -48,8 +48,6 @@ void *wlc_calloc(uint unit, uint size)
 	void *item;
 
 	item = kzalloc(size, GFP_ATOMIC);
-	if (item == NULL)
-		WL_ERROR("wl%d: %s: out of memory\n", unit, __func__);
 	return item;
 }
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
index e31b9b1..6f5e103 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
@@ -594,8 +594,6 @@ struct chan20_info chan20_info[] = {
 static const locale_info_t *wlc_get_locale_2g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_locale_2g_table)) {
-		WL_ERROR("%s: locale 2g index size out of range %d\n",
-			 __func__, locale_idx);
 		ASSERT(locale_idx < ARRAY_SIZE(g_locale_2g_table));
 		return NULL;
 	}
@@ -605,8 +603,6 @@ static const locale_info_t *wlc_get_locale_2g(u8 locale_idx)
 static const locale_info_t *wlc_get_locale_5g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_locale_5g_table)) {
-		WL_ERROR("%s: locale 5g index size out of range %d\n",
-			 __func__, locale_idx);
 		ASSERT(locale_idx < ARRAY_SIZE(g_locale_5g_table));
 		return NULL;
 	}
@@ -616,8 +612,6 @@ static const locale_info_t *wlc_get_locale_5g(u8 locale_idx)
 const locale_mimo_info_t *wlc_get_mimo_2g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_mimo_2g_table)) {
-		WL_ERROR("%s: mimo 2g index size out of range %d\n",
-			 __func__, locale_idx);
 		return NULL;
 	}
 	return g_mimo_2g_table[locale_idx];
@@ -626,8 +620,6 @@ const locale_mimo_info_t *wlc_get_mimo_2g(u8 locale_idx)
 const locale_mimo_info_t *wlc_get_mimo_5g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_mimo_5g_table)) {
-		WL_ERROR("%s: mimo 5g index size out of range %d\n",
-			 __func__, locale_idx);
 		return NULL;
 	}
 	return g_mimo_5g_table[locale_idx];
@@ -645,7 +637,8 @@ wlc_cm_info_t *wlc_channel_mgr_attach(struct wlc_info *wlc)
 
 	wlc_cm = kzalloc(sizeof(wlc_cm_info_t), GFP_ATOMIC);
 	if (wlc_cm == NULL) {
-		WL_ERROR("wl%d: %s: out of memory", pub->unit, __func__);
+		wiphy_err(wlc->wiphy, "wl%d: %s: out of memory", pub->unit,
+			  __func__);
 		return NULL;
 	}
 	wlc_cm->pub = pub;
@@ -814,8 +807,8 @@ static const country_info_t *wlc_countrycode_map(wlc_cm_info_t *wlc_cm,
 
 	/* check for currently supported ccode size */
 	if (strlen(ccode) > (WLC_CNTRY_BUF_SZ - 1)) {
-		WL_ERROR("wl%d: %s: ccode \"%s\" too long for match\n",
-			 wlc->pub->unit, __func__, ccode);
+		wiphy_err(wlc->wiphy, "wl%d: %s: ccode \"%s\" too long for "
+			  "match\n", wlc->pub->unit, __func__, ccode);
 		return NULL;
 	}
 
@@ -830,7 +823,7 @@ static const country_info_t *wlc_countrycode_map(wlc_cm_info_t *wlc_cm,
 	if (!strcmp(srom_ccode, ccode)) {
 		*mapped_regrev = srom_regrev;
 		mapped = 0;
-		WL_ERROR("srom_code == ccode %s\n", __func__);
+		wiphy_err(wlc->wiphy, "srom_code == ccode %s\n", __func__);
 		ASSERT(0);
 	} else {
 		mapped =
@@ -882,7 +875,6 @@ static const country_info_t *wlc_country_lookup_direct(const char *ccode,
 		}
 	}
 
-	WL_ERROR("%s: Returning NULL\n", __func__);
 	ASSERT(0);
 	return NULL;
 }
@@ -961,9 +953,10 @@ static void wlc_channels_commit(wlc_cm_info_t *wlc_cm)
 	if (chan == INVCHANNEL) {
 		/* country/locale with no valid channels, set the radio disable bit */
 		mboolset(wlc->pub->radio_disabled, WL_RADIO_COUNTRY_DISABLE);
-		WL_ERROR("wl%d: %s: no valid channel for \"%s\" nbands %d bandlocked %d\n",
-			 wlc->pub->unit, __func__,
-			 wlc_cm->country_abbrev, NBANDS(wlc), wlc->bandlocked);
+		wiphy_err(wlc->wiphy, "wl%d: %s: no valid channel for \"%s\" "
+			  "nbands %d bandlocked %d\n", wlc->pub->unit,
+			  __func__, wlc_cm->country_abbrev, NBANDS(wlc),
+			  wlc->bandlocked);
 	} else
 	    if (mboolisset(wlc->pub->radio_disabled,
 		WL_RADIO_COUNTRY_DISABLE)) {
@@ -1514,8 +1507,8 @@ wlc_valid_chanspec_ext(wlc_cm_info_t *wlc_cm, chanspec_t chspec, bool dualband)
 
 	/* check the chanspec */
 	if (wf_chspec_malformed(chspec)) {
-		WL_ERROR("wl%d: malformed chanspec 0x%x\n",
-			 wlc->pub->unit, chspec);
+		wiphy_err(wlc->wiphy, "wl%d: malformed chanspec 0x%x\n",
+			wlc->pub->unit, chspec);
 		ASSERT(0);
 		return false;
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
index 96d3600..0c4780d 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
@@ -68,8 +68,9 @@ wlc_phy_shim_info_t *wlc_phy_shim_attach(struct wlc_hw_info *wlc_hw,
 
 	physhim = kzalloc(sizeof(wlc_phy_shim_info_t), GFP_ATOMIC);
 	if (!physhim) {
-		WL_ERROR("wl%d: wlc_phy_shim_attach: out of mem\n",
-			 wlc_hw->unit);
+		wiphy_err(wlc_hw->wlc->wiphy,
+			  "wl%d: wlc_phy_shim_attach: out of mem\n",
+			  wlc_hw->unit);
 		return NULL;
 	}
 	physhim->wlc_hw = wlc_hw;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
index 799b9ae..24b04da 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
@@ -275,15 +275,19 @@ int wlc_stf_txchain_set(struct wlc_info *wlc, s32 int_val, bool force)
 				if (RSPEC_STF(wlc->bandstate[i]->rspec_override)
 				    != PHY_TXC1_MODE_SISO) {
 					wlc->bandstate[i]->rspec_override = 0;
-					WL_ERROR("%s(): temp sense override non-SISO rspec_override\n",
-						 __func__);
+					wiphy_err(wlc->wiphy, "%s(): temp "
+						  "sense override non-SISO "
+						  "rspec_override\n",
+						  __func__);
 				}
 				if (RSPEC_STF
 				    (wlc->bandstate[i]->mrspec_override) !=
 				    PHY_TXC1_MODE_SISO) {
 					wlc->bandstate[i]->mrspec_override = 0;
-					WL_ERROR("%s(): temp sense override non-SISO mrspec_override\n",
-						 __func__);
+					wiphy_err(wlc->wiphy, "%s(): temp "
+						  "sense override non-SISO "
+						  "mrspec_override\n",
+						  __func__);
 				}
 			}
 	}
-- 
1.7.4.1


