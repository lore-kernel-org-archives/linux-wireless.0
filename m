Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:53844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbYCIVvY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:51:24 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1676623fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:51:24 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 20/24] rt2x00: Fix basic rate initialization
Date: Sun, 9 Mar 2008 22:48:08 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092248.08862.IvDoorn@gmail.com> (sfid-20080309_222544_984904_263B40F1)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The basic rate which is configured in the register
should not match all supported rates, but only the _basic_ rates.

Fix this by adding a new flag to the rt2x00_rate structure
and whenever the mode is changed, loop over all available rates
for that band to get the basic rate mask.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h       |    4 +-
 drivers/net/wireless/rt2x00/rt2x00config.c |   19 +++++++++++--
 drivers/net/wireless/rt2x00/rt2x00dev.c    |   38 ++++++++++++++--------------
 drivers/net/wireless/rt2x00/rt2x00lib.h    |   14 +---------
 4 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index d71b3c4..c9fa613 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -441,8 +441,8 @@ struct rt2x00lib_conf {
 
 	enum ieee80211_band band;
 
-	int basic_rates;
-	int slot_time;
+	u32 basic_rates;
+	u32 slot_time;
 
 	short sifs;
 	short pifs;
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 7211169..5e2d81a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -145,12 +145,26 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 		rt2x00lib_toggle_rx(rt2x00dev, STATE_RADIO_RX_ON_LINK);
 }
 
+static u32 rt2x00lib_get_basic_rates(struct ieee80211_supported_band *band)
+{
+	const struct rt2x00_rate *rate;
+	unsigned int i;
+	u32 mask = 0;
+
+	for (i = 0; i < band->n_bitrates; i++) {
+		rate = rt2x00_get_rate(band->bitrates[i].hw_value);
+		if (rate->flags & DEV_RATE_BASIC)
+			mask |= rate->ratemask;
+	}
+
+	return mask;
+}
+
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 		      struct ieee80211_conf *conf, const int force_config)
 {
 	struct rt2x00lib_conf libconf;
 	struct ieee80211_supported_band *band;
-	struct ieee80211_rate *rate;
 	struct antenna_setup *default_ant = &rt2x00dev->default_ant;
 	struct antenna_setup *active_ant = &rt2x00dev->link.ant.active;
 	int flags = 0;
@@ -227,10 +241,9 @@ config:
 
 	if (flags & CONFIG_UPDATE_PHYMODE) {
 		band = &rt2x00dev->bands[conf->channel->band];
-		rate = &band->bitrates[band->n_bitrates - 1];
 
 		libconf.band = conf->channel->band;
-		libconf.basic_rates = rt2x00_get_rate(rate->hw_value)->ratemask;
+		libconf.basic_rates = rt2x00lib_get_basic_rates(band);
 	}
 
 	if (flags & CONFIG_UPDATE_CHANNEL) {
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index eeb39e8..18abf65 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -766,75 +766,75 @@ EXPORT_SYMBOL_GPL(rt2x00lib_write_tx_desc);
  */
 const struct rt2x00_rate rt2x00_supported_rates[12] = {
 	{
-		.flags = DEV_RATE_CCK,
+		.flags = DEV_RATE_CCK | DEV_RATE_BASIC,
 		.bitrate = 10,
-		.ratemask = DEV_RATEMASK_1MB,
+		.ratemask = BIT(0),
 		.plcp = 0x00,
 	},
 	{
-		.flags = DEV_RATE_CCK | DEV_RATE_SHORT_PREAMBLE,
+		.flags = DEV_RATE_CCK | DEV_RATE_SHORT_PREAMBLE | DEV_RATE_BASIC,
 		.bitrate = 20,
-		.ratemask = DEV_RATEMASK_2MB,
+		.ratemask = BIT(1),
 		.plcp = 0x01,
 	},
 	{
-		.flags = DEV_RATE_CCK | DEV_RATE_SHORT_PREAMBLE,
+		.flags = DEV_RATE_CCK | DEV_RATE_SHORT_PREAMBLE | DEV_RATE_BASIC,
 		.bitrate = 55,
-		.ratemask = DEV_RATEMASK_5_5MB,
+		.ratemask = BIT(2),
 		.plcp = 0x02,
 	},
 	{
-		.flags = DEV_RATE_CCK | DEV_RATE_SHORT_PREAMBLE,
+		.flags = DEV_RATE_CCK | DEV_RATE_SHORT_PREAMBLE | DEV_RATE_BASIC,
 		.bitrate = 110,
-		.ratemask = DEV_RATEMASK_11MB,
+		.ratemask = BIT(3),
 		.plcp = 0x03,
 	},
 	{
-		.flags = DEV_RATE_OFDM,
+		.flags = DEV_RATE_OFDM | DEV_RATE_BASIC,
 		.bitrate = 60,
-		.ratemask = DEV_RATEMASK_6MB,
+		.ratemask = BIT(4),
 		.plcp = 0x0b,
 	},
 	{
 		.flags = DEV_RATE_OFDM,
 		.bitrate = 90,
-		.ratemask = DEV_RATEMASK_9MB,
+		.ratemask = BIT(5),
 		.plcp = 0x0f,
 	},
 	{
-		.flags = DEV_RATE_OFDM,
+		.flags = DEV_RATE_OFDM | DEV_RATE_BASIC,
 		.bitrate = 120,
-		.ratemask = DEV_RATEMASK_12MB,
+		.ratemask = BIT(6),
 		.plcp = 0x0a,
 	},
 	{
 		.flags = DEV_RATE_OFDM,
 		.bitrate = 180,
-		.ratemask = DEV_RATEMASK_18MB,
+		.ratemask = BIT(7),
 		.plcp = 0x0e,
 	},
 	{
-		.flags = DEV_RATE_OFDM,
+		.flags = DEV_RATE_OFDM | DEV_RATE_BASIC,
 		.bitrate = 240,
-		.ratemask = DEV_RATEMASK_24MB,
+		.ratemask = BIT(8),
 		.plcp = 0x09,
 	},
 	{
 		.flags = DEV_RATE_OFDM,
 		.bitrate = 360,
-		.ratemask = DEV_RATEMASK_36MB,
+		.ratemask = BIT(9),
 		.plcp = 0x0d,
 	},
 	{
 		.flags = DEV_RATE_OFDM,
 		.bitrate = 480,
-		.ratemask = DEV_RATEMASK_48MB,
+		.ratemask = BIT(10),
 		.plcp = 0x08,
 	},
 	{
 		.flags = DEV_RATE_OFDM,
 		.bitrate = 540,
-		.ratemask = DEV_RATEMASK_54MB,
+		.ratemask = BIT(11),
 		.plcp = 0x0c,
 	},
 };
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 1596aa3..fd25797 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -41,22 +41,10 @@ struct rt2x00_rate {
 #define DEV_RATE_CCK			0x0001
 #define DEV_RATE_OFDM			0x0002
 #define DEV_RATE_SHORT_PREAMBLE		0x0004
+#define DEV_RATE_BASIC			0x0008
 
 	unsigned short bitrate; /* In 100kbit/s */
-
 	unsigned short ratemask;
-#define DEV_RATEMASK_1MB	( (1 << 1) - 1 )
-#define DEV_RATEMASK_2MB	( (1 << 2) - 1 )
-#define DEV_RATEMASK_5_5MB	( (1 << 3) - 1 )
-#define DEV_RATEMASK_11MB	( (1 << 4) - 1 )
-#define DEV_RATEMASK_6MB	( (1 << 5) - 1 )
-#define DEV_RATEMASK_9MB	( (1 << 6) - 1 )
-#define DEV_RATEMASK_12MB	( (1 << 7) - 1 )
-#define DEV_RATEMASK_18MB	( (1 << 8) - 1 )
-#define DEV_RATEMASK_24MB	( (1 << 9) - 1 )
-#define DEV_RATEMASK_36MB	( (1 << 10) - 1 )
-#define DEV_RATEMASK_48MB	( (1 << 11) - 1 )
-#define DEV_RATEMASK_54MB	( (1 << 12) - 1 )
 
 	unsigned short plcp;
 };
-- 
1.5.4.3

