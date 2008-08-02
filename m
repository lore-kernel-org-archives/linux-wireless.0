Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25758 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbYHBXtO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 19:49:14 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 16:49:14 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<jouni.malinen@atheros.com>,
	Sujith Manoharan <smanoharan@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 04/12] ath9k: Fix channel registration
Date: Sat, 2 Aug 2008 16:48:56 -0700
Message-ID: <1217720944-23234-5-git-send-email-lrodriguez@atheros.com> (sfid-20080803_014917_957433_85FC3FA6)
In-Reply-To: <1217720944-23234-4-git-send-email-lrodriguez@atheros.com>
References: <1217720944-23234-1-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-2-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-3-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-4-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <smanoharan@atheros.com>

Register channels in a cleaner way and
assign maxTxPower, minTxPower directly.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    4 --
 drivers/net/wireless/ath9k/core.c  |  102 ++++++++++++++++++++++-------------
 drivers/net/wireless/ath9k/core.h  |   13 -----
 drivers/net/wireless/ath9k/main.c  |   90 -------------------------------
 drivers/net/wireless/ath9k/phy.c   |   15 -----
 drivers/net/wireless/ath9k/regd.c  |   16 ++----
 6 files changed, 69 insertions(+), 171 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index de80a66..98466fd 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -955,7 +955,6 @@ struct ath_hal *ath9k_hw_attach(u_int16_t devid,
 				void __iomem *mem,
 				enum hal_status *error);
 bool ath9k_regd_init_channels(struct ath_hal *ah,
-			      struct hal_channel *chans,
 			      u_int maxchans, u_int *nchans,
 			      u_int8_t *regclassids,
 			      u_int maxregids, u_int *nregids,
@@ -1130,7 +1129,4 @@ void ath9k_hw_get_channel_centers(struct ath_hal *ah,
 bool ath9k_get_channel_edges(struct ath_hal *ah,
 			     u_int16_t flags, u_int16_t *low,
 			     u_int16_t *high);
-bool ath9k_hw_get_chip_power_limits(struct ath_hal *ah,
-				    struct hal_channel *chans,
-				    u_int32_t nchans);
 #endif
diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 6a61064..1849e03 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -168,60 +168,89 @@ static int ath_rate_setup(struct ath_softc *sc, enum wireless_mode mode)
 
 /*
  *  Set up channel list
- *
- *  Determines the proper set of channelflags based on the selected mode,
- *  allocates a channel array, and passes it to the HAL for initialization.
- *  If successful, the list is passed to the upper layer, then de-allocated.
-*/
-
-static int ath_getchannels(struct ath_softc *sc,
-			   u_int cc,
-			   bool outDoor,
-			   bool xchanMode)
+ */
+static int ath_setup_channels(struct ath_softc *sc)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	struct hal_channel *chans;
-	int nchan;
+	int nchan, i, a = 0, b = 0;
 	u_int8_t regclassids[ATH_REGCLASSIDS_MAX];
 	u_int nregclass = 0;
+	struct ieee80211_supported_band *band_2ghz;
+	struct ieee80211_supported_band *band_5ghz;
+	struct ieee80211_channel *chan_2ghz;
+	struct ieee80211_channel *chan_5ghz;
+	struct ath9k_channel *c;
 
-	chans = kmalloc(ATH_CHAN_MAX * sizeof(struct hal_channel), GFP_KERNEL);
-	if (chans == NULL) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to allocate channel table\n", __func__);
-		return -ENOMEM;
-	}
-
+	/* Fill in ah->ah_channels */
 	if (!ath9k_regd_init_channels(ah,
-				      chans,
 				      ATH_CHAN_MAX,
 				      (u_int *)&nchan,
 				      regclassids,
 				      ATH_REGCLASSIDS_MAX,
 				      &nregclass,
-				      cc,
+				      CTRY_DEFAULT,
 				      ATH9K_MODE_SEL_ALL,
-				      outDoor,
-				      xchanMode)) {
+				      false,
+				      1)) {
 		u_int32_t rd = ah->ah_currentRD;
 
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: unable to collect channel list from hal; "
+			"%s: unable to collect channel list; "
 			"regdomain likely %u country code %u\n",
-			__func__, rd, cc);
-		kfree(chans);
+			__func__, rd, CTRY_DEFAULT);
 		return -EINVAL;
 	}
 
-	ath_setup_channel_list(sc,
-			       CLIST_UPDATE,
-			       chans,
-			       nchan,
-			       regclassids,
-			       nregclass,
-			       CTRY_DEFAULT);
+	band_2ghz = &sc->sbands[IEEE80211_BAND_2GHZ];
+	band_5ghz = &sc->sbands[IEEE80211_BAND_5GHZ];
+	chan_2ghz = sc->channels[IEEE80211_BAND_2GHZ];
+	chan_5ghz = sc->channels[IEEE80211_BAND_5GHZ];
+
+	for (i = 0; i < nchan; i++) {
+		c = &ah->ah_channels[i];
+		if (IS_CHAN_2GHZ(c)) {
+			chan_2ghz[a].band = IEEE80211_BAND_2GHZ;
+			chan_2ghz[a].center_freq = c->channel;
+			chan_2ghz[a].max_power = c->maxTxPower;
+
+			if (c->privFlags & CHANNEL_DISALLOW_ADHOC)
+				chan_2ghz[a].flags |=
+					IEEE80211_CHAN_NO_IBSS;
+			if (c->channelFlags & CHANNEL_PASSIVE)
+				chan_2ghz[a].flags |=
+					IEEE80211_CHAN_PASSIVE_SCAN;
+
+			band_2ghz->n_channels = ++a;
+
+			DPRINTF(sc, ATH_DBG_CONFIG,
+				"%s: 2MHz channel: %d, "
+				"channelFlags: 0x%x\n",
+				__func__,
+				c->channel,
+				c->channelFlags);
+		} else if (IS_CHAN_5GHZ(c)) {
+			chan_5ghz[b].band = IEEE80211_BAND_5GHZ;
+			chan_5ghz[b].center_freq = c->channel;
+			chan_5ghz[b].max_power = c->maxTxPower;
+
+			if (c->privFlags & CHANNEL_DISALLOW_ADHOC)
+				chan_5ghz[b].flags |=
+					IEEE80211_CHAN_NO_IBSS;
+			if (c->channelFlags & CHANNEL_PASSIVE)
+				chan_5ghz[b].flags |=
+					IEEE80211_CHAN_PASSIVE_SCAN;
+
+			band_5ghz->n_channels = ++b;
+
+			DPRINTF(sc, ATH_DBG_CONFIG,
+				"%s: 5MHz channel: %d, "
+				"channelFlags: 0x%x\n",
+				__func__,
+				c->channel,
+				c->channelFlags);
+		}
+	}
 
-	kfree(chans);
 	return 0;
 }
 
@@ -1175,10 +1204,7 @@ int ath_init(u_int16_t devid, struct ath_softc *sc)
 	 */
 	rd = ah->ah_currentRD;
 
-	error = ath_getchannels(sc,
-				CTRY_DEFAULT,
-				ath_outdoor,
-				1);
+	error = ath_setup_channels(sc);
 	if (error)
 		goto bad;
 
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index e2b42f2..281dc76 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -907,12 +907,6 @@ enum PROT_MODE {
 	PROT_M_CTSONLY
 };
 
-enum ieee80211_clist_cmd {
-	CLIST_UPDATE,
-	CLIST_DFS_UPDATE,
-	CLIST_NEW_COUNTRY
-};
-
 enum RATE_TYPE {
 	NORMAL_RATE = 0,
 	HALF_RATE,
@@ -1064,13 +1058,6 @@ int ath_reset(struct ath_softc *sc);
 void ath_scan_start(struct ath_softc *sc);
 void ath_scan_end(struct ath_softc *sc);
 int ath_set_channel(struct ath_softc *sc, struct hal_channel *hchan);
-void ath_setup_channel_list(struct ath_softc *sc,
-			    enum ieee80211_clist_cmd cmd,
-			    const struct hal_channel *chans,
-			    int nchan,
-			    const u_int8_t *regclassids,
-			    u_int nregclass,
-			    int countrycode);
 void ath_setup_rate(struct ath_softc *sc,
 		    enum wireless_mode wMode,
 		    enum RATE_TYPE type,
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index c47ef50..a5ece47 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -41,20 +41,6 @@ static struct pci_device_id ath_pci_id_table[] __devinitdata = {
 	{ 0 }
 };
 
-static int test_update_chan(enum ieee80211_band band,
-			    const struct hal_channel *chan,
-			    struct ath_softc *sc)
-{
-	int i;
-
-	for (i = 0; i < sc->sbands[band].n_channels; i++) {
-		if (sc->channels[band][i].center_freq == chan->channel)
-			return 1;
-	}
-
-	return 0;
-}
-
 static int ath_check_chanflags(struct ieee80211_channel *chan,
 			       u_int32_t mode,
 			       struct ath_softc *sc)
@@ -1036,82 +1022,6 @@ u_int32_t ath_chan2flags(struct ieee80211_channel *chan,
 	}
 }
 
-void ath_setup_channel_list(struct ath_softc *sc,
-			    enum ieee80211_clist_cmd cmd,
-			    const struct hal_channel *chans,
-			    int nchan,
-			    const u_int8_t *regclassids,
-			    u_int nregclass,
-			    int countrycode)
-{
-	const struct hal_channel *c;
-	int i, a = 0, b = 0, flags;
-
-	if (countrycode == CTRY_DEFAULT) {
-		for (i = 0; i < nchan; i++) {
-			c = &chans[i];
-			flags = 0;
-			/* XXX: Ah! make more readable, and
-			 * idententation friendly */
-			if (IS_CHAN_2GHZ(c) &&
-			    !test_update_chan(IEEE80211_BAND_2GHZ, c, sc)) {
-				sc->channels[IEEE80211_BAND_2GHZ][a].band =
-					IEEE80211_BAND_2GHZ;
-				sc->channels[IEEE80211_BAND_2GHZ][a].
-					center_freq =
-					c->channel;
-				sc->channels[IEEE80211_BAND_2GHZ][a].max_power =
-					c->maxTxPower;
-				sc->channels[IEEE80211_BAND_2GHZ][a].hw_value =
-					c->channelFlags;
-
-				if (c->privFlags & CHANNEL_DISALLOW_ADHOC)
-					flags |= IEEE80211_CHAN_NO_IBSS;
-				if (IS_CHAN_PASSIVE(c))
-					flags |= IEEE80211_CHAN_PASSIVE_SCAN;
-
-				sc->channels[IEEE80211_BAND_2GHZ][a].flags =
-					flags;
-				sc->sbands[IEEE80211_BAND_2GHZ].n_channels++;
-				a++;
-				DPRINTF(sc, ATH_DBG_CONFIG,
-					"%s: 2MHz channel: %d, "
-					"channelFlags: 0x%x\n",
-					__func__,
-					c->channel,
-					c->channelFlags);
-			} else if (IS_CHAN_5GHZ(c) &&
-			 !test_update_chan(IEEE80211_BAND_5GHZ, c, sc)) {
-				sc->channels[IEEE80211_BAND_5GHZ][b].band =
-					IEEE80211_BAND_5GHZ;
-				sc->channels[IEEE80211_BAND_5GHZ][b].
-					center_freq =
-					c->channel;
-				sc->channels[IEEE80211_BAND_5GHZ][b].max_power =
-					c->maxTxPower;
-				sc->channels[IEEE80211_BAND_5GHZ][b].hw_value =
-					c->channelFlags;
-
-				if (c->privFlags & CHANNEL_DISALLOW_ADHOC)
-					flags |= IEEE80211_CHAN_NO_IBSS;
-				if (IS_CHAN_PASSIVE(c))
-					flags |= IEEE80211_CHAN_PASSIVE_SCAN;
-
-				sc->channels[IEEE80211_BAND_5GHZ][b].
-					flags = flags;
-				sc->sbands[IEEE80211_BAND_5GHZ].n_channels++;
-				b++;
-				DPRINTF(sc, ATH_DBG_CONFIG,
-					"%s: 5MHz channel: %d, "
-					"channelFlags: 0x%x\n",
-					__func__,
-					c->channel,
-					c->channelFlags);
-			}
-		}
-	}
-}
-
 void ath_get_beaconconfig(struct ath_softc *sc,
 			  int if_id,
 			  struct ath_beacon_config *conf)
diff --git a/drivers/net/wireless/ath9k/phy.c b/drivers/net/wireless/ath9k/phy.c
index 0e70f47..28953a8 100644
--- a/drivers/net/wireless/ath9k/phy.c
+++ b/drivers/net/wireless/ath9k/phy.c
@@ -312,21 +312,6 @@ ath9k_hw_rfdetach(struct ath_hal *ah)
 	}
 }
 
-bool
-ath9k_hw_get_chip_power_limits(struct ath_hal *ah,
-			       struct hal_channel *chans, u_int32_t nchans)
-{
-	bool retVal = true;
-	int i;
-
-	for (i = 0; i < nchans; i++) {
-		chans[i].maxTxPower = AR5416_MAX_RATE_POWER;
-		chans[i].minTxPower = AR5416_MAX_RATE_POWER;
-	}
-	return retVal;
-}
-
-
 bool ath9k_hw_init_rf(struct ath_hal *ah, enum hal_status *status)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index 425450d..f40cd66 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include "core.h"
+#include "hw.h"
 #include "regd.h"
 #include "regd_common.h"
 
@@ -495,6 +496,9 @@ ath9k_regd_add_channel(struct ath_hal *ah,
 	icv.antennaMax = fband->antennaMax;
 	icv.regDmnFlags = rd->flags;
 	icv.conformanceTestLimit = ctl;
+	icv.maxTxPower = AR5416_MAX_RATE_POWER;
+	icv.minTxPower = AR5416_MAX_RATE_POWER;
+
 	if (fband->usePassScan & rd->pscan)
 		icv.channelFlags |= CHANNEL_PASSIVE;
 	else
@@ -575,7 +579,7 @@ static bool ath9k_regd_japan_check(struct ath_hal *ah,
 
 bool
 ath9k_regd_init_channels(struct ath_hal *ah,
-			 struct hal_channel *chans, u_int maxchans,
+			 u_int maxchans,
 			 u_int *nchans, u_int8_t *regclassids,
 			 u_int maxregids, u_int *nregids, u_int16_t cc,
 			 u_int32_t modeSelect, bool enableOutdoor,
@@ -853,16 +857,6 @@ done:
 				"chan: %d flags: 0x%x\n",
 				ichans[i].channel,
 				ichans[i].channelFlags);
-			chans[i].channel = ichans[i].channel;
-			chans[i].channelFlags = ichans[i].channelFlags;
-			chans[i].privFlags = ichans[i].privFlags;
-			chans[i].maxRegTxPower = ichans[i].maxRegTxPower;
-		}
-
-		ath9k_hw_get_chip_power_limits(ah, chans, next);
-		for (i = 0; i < next; i++) {
-			ichans[i].maxTxPower = chans[i].maxTxPower;
-			ichans[i].minTxPower = chans[i].minTxPower;
 		}
 	}
 	*nchans = next;
-- 
1.5.6.rc2.15.g457bb.dirty

