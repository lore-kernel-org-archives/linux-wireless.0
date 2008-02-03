Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:42008 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763559AbYBCOvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 09:51:55 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1586229fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 06:51:54 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/19] rt2x00: Remove HWMODE_{A,B,G}
Date: Sun, 3 Feb 2008 15:51:13 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802031541.52167.IvDoorn@gmail.com>
In-Reply-To: <200802031541.52167.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802031551.13254.IvDoorn@gmail.com> (sfid-20080203_145159_277241_EE1A8375)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2500usb initialized the SIFS and EIFS without using the
values coming from rt2x000lib. After this is fixed HWMODE_{A,B,G}
is now unused and can be removed in favour of the ieee80211_band
enumeration which could still be usefull later.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c    |   14 +++-----------
 drivers/net/wireless/rt2x00/rt2500usb.h    |    2 +-
 drivers/net/wireless/rt2x00/rt2x00.h       |    6 +-----
 drivers/net/wireless/rt2x00/rt2x00config.c |   17 ++---------------
 drivers/net/wireless/rt2x00/rt2x00dev.c    |    6 +++---
 5 files changed, 10 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 0b902c8..e348582 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -358,18 +358,9 @@ static int rt2500usb_config_preamble(struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt2500usb_config_phymode(struct rt2x00_dev *rt2x00dev,
-				     const int phymode,
 				     const int basic_rate_mask)
 {
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR11, basic_rate_mask);
-
-	if (phymode == HWMODE_B) {
-		rt2500usb_register_write(rt2x00dev, MAC_CSR11, 0x000b);
-		rt2500usb_register_write(rt2x00dev, MAC_CSR12, 0x0040);
-	} else {
-		rt2500usb_register_write(rt2x00dev, MAC_CSR11, 0x0005);
-		rt2500usb_register_write(rt2x00dev, MAC_CSR12, 0x016c);
-	}
 }
 
 static void rt2500usb_config_channel(struct rt2x00_dev *rt2x00dev,
@@ -507,6 +498,8 @@ static void rt2500usb_config_duration(struct rt2x00_dev *rt2x00dev,
 	u16 reg;
 
 	rt2500usb_register_write(rt2x00dev, MAC_CSR10, libconf->slot_time);
+	rt2500usb_register_write(rt2x00dev, MAC_CSR11, libconf->sifs);
+	rt2500usb_register_write(rt2x00dev, MAC_CSR12, libconf->eifs);
 
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR18, &reg);
 	rt2x00_set_field16(&reg, TXRX_CSR18_INTERVAL,
@@ -519,8 +512,7 @@ static void rt2500usb_config(struct rt2x00_dev *rt2x00dev,
 			     const unsigned int flags)
 {
 	if (flags & CONFIG_UPDATE_PHYMODE)
-		rt2500usb_config_phymode(rt2x00dev, libconf->phymode,
-					 libconf->basic_rates);
+		rt2500usb_config_phymode(rt2x00dev, libconf->basic_rates);
 	if (flags & CONFIG_UPDATE_CHANNEL)
 		rt2500usb_config_channel(rt2x00dev, &libconf->rf,
 					 libconf->conf->power_level);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index 23ba0c1..647cd2d 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -135,7 +135,7 @@
  * Misc MAC_CSR registers.
  * MAC_CSR9: Timer control.
  * MAC_CSR10: Slot time.
- * MAC_CSR11: IFS.
+ * MAC_CSR11: SIFS.
  * MAC_CSR12: EIFS.
  * MAC_CSR13: Power mode0.
  * MAC_CSR14: Power mode1.
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 01cf9e6..6c30bae 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -390,10 +390,6 @@ static inline struct rt2x00_intf* vif_to_intf(struct ieee80211_vif *vif)
 	return (struct rt2x00_intf *)vif->drv_priv;
 }
 
-#define HWMODE_B	0
-#define HWMODE_G	1
-#define HWMODE_A	2
-
 /*
  * Details about the supported modes, rates and channels
  * of a particular chipset. This is used by rt2x00lib
@@ -433,7 +429,7 @@ struct rt2x00lib_conf {
 
 	struct antenna_setup ant;
 
-	int phymode;
+	enum ieee80211_band band;
 
 	int basic_rates;
 	int slot_time;
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index b39d816..46888f9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -225,23 +225,10 @@ config:
 	memset(&libconf, 0, sizeof(libconf));
 
 	if (flags & CONFIG_UPDATE_PHYMODE) {
-		switch (conf->channel->band) {
-		case IEEE80211_BAND_5GHZ:
-			libconf.phymode = HWMODE_A;
-			break;
-		case IEEE80211_BAND_2GHZ:
-			/* Uh oh. what about B? */
-			libconf.phymode = HWMODE_G;
-			break;
-		default:
-			ERROR(rt2x00dev,
-			      "Attempt to configure unsupported mode (%d)"
-			      "Defaulting to 802.11b", conf->channel->band);
-			libconf.phymode = HWMODE_B;
-		}
-
 		band = &rt2x00dev->bands[conf->channel->band];
 		rate = &band->bitrates[band->n_bitrates - 1];
+
+		libconf.band = conf->channel->band;
 		libconf.basic_rates = rt2x00_get_rate(rate->hw_value)->ratemask;
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 4fb6c58..644a09a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -903,7 +903,7 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 	 * Rates: CCK.
 	 * Channels: 2.4 GHz
 	 */
-	if (spec->num_modes > HWMODE_B) {
+	if (spec->num_modes > 0) {
 		sbands[IEEE80211_BAND_2GHZ].n_channels = 14;
 		sbands[IEEE80211_BAND_2GHZ].n_bitrates = 4;
 		sbands[IEEE80211_BAND_2GHZ].channels = channels;
@@ -916,7 +916,7 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 	 * Rates: CCK, OFDM.
 	 * Channels: 2.4 GHz
 	 */
-	if (spec->num_modes > HWMODE_G) {
+	if (spec->num_modes > 1) {
 		sbands[IEEE80211_BAND_2GHZ].n_channels = 14;
 		sbands[IEEE80211_BAND_2GHZ].n_bitrates = spec->num_rates;
 		sbands[IEEE80211_BAND_2GHZ].channels = channels;
@@ -929,7 +929,7 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 	 * Rates: OFDM.
 	 * Channels: OFDM, UNII, HiperLAN2.
 	 */
-	if (spec->num_modes > HWMODE_A) {
+	if (spec->num_modes > 2) {
 		sbands[IEEE80211_BAND_5GHZ].n_channels = spec->num_channels - 14;
 		sbands[IEEE80211_BAND_5GHZ].n_bitrates = spec->num_rates - 4;
 		sbands[IEEE80211_BAND_5GHZ].channels = &channels[14];
-- 
1.5.3.8

