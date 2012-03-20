Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46020 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab2CTWHO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 18:07:14 -0400
Date: Tue, 20 Mar 2012 17:07:06 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Problems with regulatory domain support and BCM43224
Message-ID: <20120320220706.GA17272@thinkpad-t410> (sfid-20120320_230719_182470_F0D8CD6F)
References: <20120307194001.GA2506@ubuntu-macmini>
 <20120308174101.GB28133@ubuntu-macmini>
 <CAB=NE6VapPfLjAh5Y+sCA4qA82s9HrQk_Mxr8FpKoCfjudMDig@mail.gmail.com>
 <4B96CD77D9161244899852B5F20DB5B70125BB72@nasanexd02d.na.qualcomm.com>
 <CAB=NE6U04a0XNrvt6HLCwqbHMtGL8CWh8No_=Bx0mwQZYEgGxQ@mail.gmail.com>
 <4B96CD77D9161244899852B5F20DB5B70125BC94@nasanexd02d.na.qualcomm.com>
 <CAB=NE6X9c1m63xayNsEf9XZ3AgPZDV2SiRivg3SV2Day83fPQA@mail.gmail.com>
 <20120308200734.GC28133@ubuntu-macmini>
 <4F591E14.4010000@broadcom.com>
 <CAB=NE6XnorRDEu976uMkPFNKHQjhRT0Craf3ZjL9dYysPjmQng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB=NE6XnorRDEu976uMkPFNKHQjhRT0Craf3ZjL9dYysPjmQng@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 08, 2012 at 01:06:57PM -0800, Luis R. Rodriguez wrote:
> > Hi, Seth
> >
> > Noticed your email yesterday, but did not get to chime into the
> > conversation. brcmsmac does indeed provide a regulatory hint, which is
> > either from SPROM or hard-coded to "US". Since "X0" is not a known
> > regulatory domain for crda it does not make sense to pass it as a regulatory
> > hint. However, the "full" story is told on linuxwireless.org (see [1]).
> 
> The Linux kernel allows you to define custom regulatory domains, the
> ath module uses these, it defines 13 of them. You can review that code
> for an example of how to use them. So your X0 can still be used, you
> just have to define the data structure.

I took a shot at implementing custom regulatory domain support for
brcmsmac. I've got it working to the point of letting me see APs on the
DFS channels at least. The patch is below. A number of issues
undoubtedly remain to be resolved. Some that I can think of:

 - I set up two custom domains, X0 and X2, which are identical. I'm not
   sure precisely how each needs to be set up, but I took a reasonable
   guess.

 - I tried to integrate with the existing X2 domain support, but this
   could probably be improved. I avoided making large changes because
   there's some complexity in the current code that doesn't seem to
   serve a purpose currently, but I assume it's there for a reason.

 - The flow of the initialization and organization of the code make it
   necessary to search through the list of custom regulatory domains
   many times. It would be nice to improve upon this.

Does this look to be on the right track?

Thanks,
Seth


diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 55e9f45..d9c755c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -16,6 +16,7 @@
 
 #include <linux/types.h>
 #include <net/mac80211.h>
+#include <net/regulatory.h>
 
 #include <defs.h>
 #include "pub.h"
@@ -24,6 +25,48 @@
 #include "stf.h"
 #include "channel.h"
 
+#define BRCM_2GHZ_2412_2462	REG_RULE(2412-10, 2462+10, 40, 0, 20, 0)
+#define BRCM_2GHZ_2467_2472	REG_RULE(2467-10, 2472+10, 20, 0, 20, \
+					 NL80211_RRF_PASSIVE_SCAN | \
+					 NL80211_RRF_NO_IBSS)
+#define BRCM_2GHZ_2484		REG_RULE(2484-10, 2484+10, 40, 0, 20, \
+					 NL80211_RRF_PASSIVE_SCAN | \
+					 NL80211_RRF_NO_OFDM)
+
+#define BRCM_5GHZ_5150_5240	REG_RULE(5150-10, 5240+10, 40, 0, 30, 0)
+#define BRCM_5GHZ_5260_5320	REG_RULE(5260-10, 5320+10, 40, 0, 30, \
+					 NL80211_RRF_PASSIVE_SCAN | \
+					 NL80211_RRF_NO_IBSS)
+#define BRCM_5GHZ_5470_5850	REG_RULE(5470-10, 5850+10, 40, 0, 30, \
+					 NL80211_RRF_PASSIVE_SCAN | \
+					 NL80211_RRF_NO_IBSS)
+
+/* Aggregate rules */
+#define BRCM_2GHZ_ALL		BRCM_2GHZ_2412_2462, \
+				BRCM_2GHZ_2467_2472, \
+				BRCM_2GHZ_2484
+#define BRCM_5GHZ_ALL		BRCM_5GHZ_5150_5240, \
+				BRCM_5GHZ_5260_5320, \
+				BRCM_5GHZ_5470_5850
+
+static const struct ieee80211_regdomain brcms_regdomain_x0 = {
+	.n_reg_rules = 6,
+	.alpha2 = "X0",
+	.reg_rules = {
+		BRCM_2GHZ_ALL,
+		BRCM_5GHZ_ALL,
+	}
+};
+
+static const struct ieee80211_regdomain brcms_regdomain_x2 = {
+	.n_reg_rules = 6,
+	.alpha2 = "X2",
+	.reg_rules = {
+		BRCM_2GHZ_ALL,
+		BRCM_5GHZ_ALL,
+	}
+};
+
 /* QDB() macro takes a dB value and converts to a quarter dB value */
 #define QDB(n) ((n) * BRCMS_TXPWR_DB_FACTOR)
 
@@ -504,14 +547,42 @@ static const struct locale_mimo_info *g_mimo_5g_table[] = {
 	&locale_11n
 };
 
-static const struct {
+struct brcms_regdomain {
 	char abbrev[BRCM_CNTRY_BUF_SZ];	/* country abbreviation */
 	struct country_info country;
-} cntry_locales[] = {
+	const struct ieee80211_regdomain *regdomain;
+};
+
+static const struct brcms_regdomain cntry_locales[] = {
+	/* Worldwide Row 0 */
+	{
+		.abbrev = "X0",
+		.country = LOCALES(i, 11, bn, 11n),
+		.regdomain = &brcms_regdomain_x0,
+	},
+	/* Worldwide Row 2 */
 	{
-	"X2", LOCALES(i, 11, bn, 11n)},	/* Worldwide RoW 2 */
+		.abbrev = "X2",
+		.country = LOCALES(i, 11, bn, 11n),
+		.regdomain = &brcms_regdomain_x2,
+	},
 };
 
+static const struct brcms_regdomain *brcms_world_regd(const char *regdom)
+{
+	const struct brcms_regdomain *regd = NULL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cntry_locales); i++) {
+		if (!strcmp(regdom, cntry_locales[i].abbrev)) {
+			regd = &cntry_locales[i];
+			break;
+		}
+	}
+
+	return regd;
+}
+
 #ifdef SUPPORT_40MHZ
 /* 20MHz channel info for 40MHz pairing support */
 struct chan20_info {
@@ -634,7 +705,7 @@ brcms_c_country_aggregate_map(struct brcms_cm_info *wlc_cm, const char *ccode,
 static const struct country_info *
 brcms_c_country_lookup_direct(const char *ccode, uint regrev)
 {
-	uint size, i;
+	const struct brcms_regdomain *regd;
 
 	/* Should just return 0 for single locale driver. */
 	/* Keep it this way in case we add more locales. (for now anyway) */
@@ -646,13 +717,8 @@ brcms_c_country_lookup_direct(const char *ccode, uint regrev)
 	if (regrev > 0)
 		return NULL;
 
-	/* find matched table entry from country code */
-	size = ARRAY_SIZE(cntry_locales);
-	for (i = 0; i < size; i++) {
-		if (strcmp(ccode, cntry_locales[i].abbrev) == 0)
-			return &cntry_locales[i].country;
-	}
-	return NULL;
+	regd = brcms_world_regd(ccode);
+	return regd ? &regd->country : NULL;
 }
 
 static const struct country_info *
@@ -1073,8 +1139,7 @@ brcms_c_set_countrycode(struct brcms_cm_info *wlc_cm, const char *ccode)
 struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
 {
 	struct brcms_cm_info *wlc_cm;
-	char country_abbrev[BRCM_CNTRY_BUF_SZ];
-	const struct country_info *country;
+	const struct brcms_regdomain *regd = NULL;
 	struct brcms_pub *pub = wlc->pub;
 	char *ccode;
 
@@ -1089,24 +1154,34 @@ struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
 
 	/* store the country code for passing up as a regulatory hint */
 	ccode = getvar(wlc->hw->sih, BRCMS_SROM_CCODE);
-	if (ccode)
+	if (ccode) {
 		strncpy(wlc->pub->srom_ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
+		regd = brcms_world_regd(ccode);
+	}
 
 	/*
-	 * internal country information which must match
-	 * regulatory constraints in firmware
+	 * If no custom world domain is found in the SROM, use the
+	 * default "X2" domain.
 	 */
-	memset(country_abbrev, 0, BRCM_CNTRY_BUF_SZ);
-	strncpy(country_abbrev, "X2", sizeof(country_abbrev) - 1);
-	country = brcms_c_country_lookup(wlc, country_abbrev);
+	if (!regd) {
+		ccode = "X2";
+		regd = brcms_world_regd(ccode);
+	}
+
+	if (WARN_ON(!regd)) {
+		wiphy_err(wlc->wiphy, "No world regulatory domain found\n");
+		wlc->cmi = NULL;
+		kfree(wlc_cm);
+		return NULL;
+	}
 
 	/* save default country for exiting 11d regulatory mode */
-	strncpy(wlc->country_default, country_abbrev, BRCM_CNTRY_BUF_SZ - 1);
+	strncpy(wlc->country_default, ccode, BRCM_CNTRY_BUF_SZ - 1);
 
 	/* initialize autocountry_default to driver default */
-	strncpy(wlc->autocountry_default, "X2", BRCM_CNTRY_BUF_SZ - 1);
+	strncpy(wlc->autocountry_default, ccode, BRCM_CNTRY_BUF_SZ - 1);
 
-	brcms_c_set_countrycode(wlc_cm, country_abbrev);
+	brcms_c_set_countrycode(wlc_cm, ccode);
 
 	return wlc_cm;
 }
@@ -1471,3 +1546,23 @@ bool brcms_c_valid_chanspec_db(struct brcms_cm_info *wlc_cm, u16 chspec)
 {
 	return brcms_c_valid_chanspec_ext(wlc_cm, chspec, true);
 }
+
+bool brcms_is_world_regd(const char *regdom)
+{
+	return !!brcms_world_regd(regdom);
+}
+
+void brcms_c_regd_init(struct brcms_c_info *wlc)
+{
+	const struct brcms_regdomain *regd = NULL;
+	const char *ccode = wlc->pub->srom_ccode;
+
+	if (!ccode[0])
+		return;
+
+	regd = brcms_world_regd(ccode);
+	if (regd) {
+		wlc->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
+		wiphy_apply_custom_regulatory(wlc->wiphy, regd->regdomain);
+	}
+}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.h b/drivers/net/wireless/brcm80211/brcmsmac/channel.h
index 808cb4f..a9251cd 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.h
@@ -50,4 +50,8 @@ extern void brcms_c_channel_set_chanspec(struct brcms_cm_info *wlc_cm,
 				     u16 chanspec,
 				     u8 local_constraint_qdbm);
 
+extern bool brcms_is_world_regd(const char *regdom);
+
+extern void brcms_c_regd_init(struct brcms_c_info *wlc);
+
 #endif				/* _WLC_CHANNEL_H */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 569ab8a..db1d277 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -727,7 +727,9 @@ static const struct ieee80211_ops brcms_ops = {
  */
 static int brcms_set_hint(struct brcms_info *wl, char *abbrev)
 {
-	return regulatory_hint(wl->pub->ieee_hw->wiphy, abbrev);
+	if (!brcms_is_world_regd(abbrev))
+		return regulatory_hint(wl->pub->ieee_hw->wiphy, abbrev);
+	return 0;
 }
 
 void brcms_dpc(unsigned long data)
@@ -1059,6 +1061,8 @@ static struct brcms_info *brcms_attach(struct bcma_device *pdev)
 		goto fail;
 	}
 
+	brcms_c_regd_init(wl->wlc);
+
 	memcpy(perm, &wl->pub->cur_etheraddr, ETH_ALEN);
 	if (WARN_ON(!is_valid_ether_addr(perm)))
 		goto fail;
@@ -1071,8 +1075,6 @@ static struct brcms_info *brcms_attach(struct bcma_device *pdev)
 
 	if (wl->pub->srom_ccode[0])
 		err = brcms_set_hint(wl, wl->pub->srom_ccode);
-	else
-		err = brcms_set_hint(wl, "US");
 	if (err)
 		wiphy_err(wl->wiphy, "%s: regulatory_hint failed, status %d\n",
 			  __func__, err);

