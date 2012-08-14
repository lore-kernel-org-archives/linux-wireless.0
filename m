Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-1.exch022.serverdata.net ([206.225.164.184]:22230
	"EHLO HUB022-nj-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752428Ab2HNHcP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2012 03:32:15 -0400
Message-ID: <5029FEF3.3010707@posedge.com> (sfid-20120814_093253_434659_1B8ED4EB)
Date: Tue, 14 Aug 2012 13:02:03 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] cfg80211: VHT (11ac) Regulatory change
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handling of 80 MHz, 160 MHz channel bandwidths for VHT (11ac) Regulatory 
and setting channel flags for allowed bandwidths.

Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
---

  include/net/cfg80211.h |   64 +++++++++++++++--
  net/wireless/reg.c     |  183 
+++++++++++++++++++++++++++++++++++++++++++++++-
  net/wireless/reg.h     |    5 ++
  3 files changed, 244 insertions(+), 8 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 493fa0c..552c9ed 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -96,19 +96,71 @@ enum ieee80211_band {
   * 	is not permitted.
   * @IEEE80211_CHAN_NO_HT40MINUS: extension channel below this channel
   * 	is not permitted.
+ * @IEEE80211_CHAN_NO_VHT80_80PLUS: 3 extension channels above this channel
+ * 	are not permitted.
+ * @IEEE80211_CHAN_NO_VHT80_40MINUS_60PLUS: 1 extension channel below 
this chan
+ * 	2 ext chans above this chan are not permitted.
+ * @IEEE80211_CHAN_NO_VHT80_60MINUS_40PLUS: 2 extension channels below 
this chan
+ * 	1 ext chan above this chan are not permitted.
+ * @IEEE80211_CHAN_NO_VHT80_80MINUS: 3 extension channels below this 
channel
+ * 	are not permitted.
+ * @IEEE80211_CHAN_NO_VHT160_160PLUS: 7 extension channels above this 
channel
+ * 	are not permitted.
+ * @IEEE80211_CHAN_NO_VHT160_40MINUS_140PLUS: 1 extension channel below 
this chan
+ * 	6 ext chan above this chan are not permitted.
+ * @IEEE80211_CHAN_NO_VHT160_60MINUS_120PLUS: 2 extension channels 
below this chan
+ * 	5 ext chan above this chan are not permitted.
+ * @IEEE80211_CHAN_NO_VHT160_80MINUS_100PLUS: 3 extension channels 
below this chan
+ * 	4 ext chan above this chan are not permitted.
+ * @IEEE80211_CHAN_NO_VHT160_100MINUS_80PLUS: 4 extension channels 
below this chan
+ * 	3 ext chan above this chan are not permitted.
+ * @IEEE80211_CHAN_NO_VHT160_120MINUS_60PLUS: 5 extension channels 
below this chan
+ * 	2 ext chan above this chan are not permitted.
+ * @IEEE80211_CHAN_NO_VHT160_140MINUS_40PLUS: 6 extension channel below 
this chan
+ * 	1 ext chan above this chan are not permitted.
+ * @IEEE80211_CHAN_NO_VHT160_160MINUS: 7 extension channels below this 
channel
+ * 	are not permitted.
   */
  enum ieee80211_channel_flags {
-	IEEE80211_CHAN_DISABLED		= 1<<0,
-	IEEE80211_CHAN_PASSIVE_SCAN	= 1<<1,
-	IEEE80211_CHAN_NO_IBSS		= 1<<2,
-	IEEE80211_CHAN_RADAR		= 1<<3,
-	IEEE80211_CHAN_NO_HT40PLUS	= 1<<4,
-	IEEE80211_CHAN_NO_HT40MINUS	= 1<<5,
+	IEEE80211_CHAN_DISABLED				= 1<<0,
+	IEEE80211_CHAN_PASSIVE_SCAN			= 1<<1,
+	IEEE80211_CHAN_NO_IBSS				= 1<<2,
+	IEEE80211_CHAN_RADAR				= 1<<3,
+	IEEE80211_CHAN_NO_HT40PLUS			= 1<<4,
+	IEEE80211_CHAN_NO_HT40MINUS			= 1<<5,
+	IEEE80211_CHAN_NO_VHT80_80PLUS			= 1<<6,
+	IEEE80211_CHAN_NO_VHT80_60PLUS_40MINUS		= 1<<7,
+	IEEE80211_CHAN_NO_VHT80_40PLUS_60MINUS		= 1<<8,
+	IEEE80211_CHAN_NO_VHT80_80MINUS			= 1<<9,
+	IEEE80211_CHAN_NO_VHT160_160PLUS		= 1<<10,
+	IEEE80211_CHAN_NO_VHT160_140PLUS_40MINUS	= 1<<11,
+	IEEE80211_CHAN_NO_VHT160_120PLUS_60MINUS	= 1<<12,
+	IEEE80211_CHAN_NO_VHT160_100PLUS_80MINUS	= 1<<13,
+	IEEE80211_CHAN_NO_VHT160_80PLUS_100MINUS	= 1<<14,
+	IEEE80211_CHAN_NO_VHT160_60PLUS_120MINUS	= 1<<15,
+	IEEE80211_CHAN_NO_VHT160_40PLUS_140MINUS	= 1<<16,
+	IEEE80211_CHAN_NO_VHT160_160MINUS		= 1<<17,
  };

  #define IEEE80211_CHAN_NO_HT40 \
  	(IEEE80211_CHAN_NO_HT40PLUS | IEEE80211_CHAN_NO_HT40MINUS)

+#define IEEE80211_CHAN_NO_VHT80 \
+	(IEEE80211_CHAN_NO_VHT80_80PLUS | \
+	 IEEE80211_CHAN_NO_VHT80_60PLUS_40MINUS | \
+	 IEEE80211_CHAN_NO_VHT80_40PLUS_60MINUS | \
+	 IEEE80211_CHAN_NO_VHT80_80MINUS)
+
+#define IEEE80211_CHAN_NO_VHT160 \
+	(IEEE80211_CHAN_NO_VHT160_160PLUS	| \
+	 IEEE80211_CHAN_NO_VHT160_140PLUS_40MINUS | \
+	 IEEE80211_CHAN_NO_VHT160_120PLUS_60MINUS | \
+	 IEEE80211_CHAN_NO_VHT160_100PLUS_80MINUS | \
+	 IEEE80211_CHAN_NO_VHT160_80PLUS_100MINUS | \
+	 IEEE80211_CHAN_NO_VHT160_60PLUS_120MINUS | \
+	 IEEE80211_CHAN_NO_VHT160_40PLUS_140MINUS | \
+	 IEEE80211_CHAN_NO_VHT160_160MINUS)
+
  /**
   * struct ieee80211_channel - channel definition
   *
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2303ee7..4bb2641 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -877,7 +877,16 @@ static void handle_channel(struct wiphy *wiphy,
  	freq_range = &reg_rule->freq_range;

  	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
-		bw_flags = IEEE80211_CHAN_NO_HT40;
+		bw_flags = IEEE80211_CHAN_NO_HT40 |
+			   IEEE80211_CHAN_NO_VHT80 |
+			   IEEE80211_CHAN_NO_VHT160;
+
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(80))
+		bw_flags = IEEE80211_CHAN_NO_VHT80 |
+			   IEEE80211_CHAN_NO_VHT160;
+
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(160))
+		bw_flags = IEEE80211_CHAN_NO_VHT160;

  	if (last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
  	    request_wiphy && request_wiphy == wiphy &&
@@ -1124,6 +1133,166 @@ static void reg_process_beacons(struct wiphy *wiphy)
  	wiphy_update_beacon_reg(wiphy);
  }

+static bool is_vht_not_allowed(struct ieee80211_channel *chan, u32 
vht_chbw)
+{
+	u32	flags;
+	if (!chan)
+		return true;
+	if (chan->flags & IEEE80211_CHAN_DISABLED)
+		return true;
+	/* This would happen when regulatory rules disallow 80/160 completely */
+
+	if (vht_chbw == VHT_CHBW_80)
+		flags = IEEE80211_CHAN_NO_VHT80;
+	else if (vht_chbw == VHT_CHBW_160)
+		flags = IEEE80211_CHAN_NO_VHT160;
+	else
+		return true;
+
+	if (flags == (chan->flags & (flags)))
+		return true;
+	return false;
+}
+
+static void reg_process_vht_flags_channel(struct wiphy *wiphy,
+					  unsigned int chan_idx,
+					  u32 vht_chbw)
+{
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *channel;
+	struct ieee80211_channel *ext_channels[EXT_CHANS_MAX] =
+					{NULL, NULL, NULL, NULL,
+					 NULL, NULL, NULL, NULL,
+					 NULL, NULL, NULL, NULL,
+					 NULL, NULL};
+	unsigned int i,j;
+	int ext_chan_offset;
+	u32 vht80_flags[VHT_CHBW_80/CHWIDTH_5G] = {
+		IEEE80211_CHAN_NO_VHT80_80MINUS,
+		IEEE80211_CHAN_NO_VHT80_40PLUS_60MINUS,
+		IEEE80211_CHAN_NO_VHT80_60PLUS_40MINUS,
+		IEEE80211_CHAN_NO_VHT80_80PLUS
+		};
+	u32 vht160_flags[VHT_CHBW_160/CHWIDTH_5G] = {
+		IEEE80211_CHAN_NO_VHT160_160MINUS,
+		IEEE80211_CHAN_NO_VHT160_40PLUS_140MINUS,
+		IEEE80211_CHAN_NO_VHT160_60PLUS_120MINUS,
+		IEEE80211_CHAN_NO_VHT160_80PLUS_100MINUS,
+		IEEE80211_CHAN_NO_VHT160_100PLUS_80MINUS,
+		IEEE80211_CHAN_NO_VHT160_120PLUS_60MINUS,
+		IEEE80211_CHAN_NO_VHT160_140PLUS_40MINUS,
+		IEEE80211_CHAN_NO_VHT160_160PLUS
+		};
+	assert_cfg80211_lock();
+
+	sband = wiphy->bands[IEEE80211_BAND_5GHZ];
+	BUG_ON(chan_idx >= sband->n_channels);
+	BUG_ON((vht_chbw != VHT_CHBW_80) && (vht_chbw != VHT_CHBW_160));
+	channel = &sband->channels[chan_idx];
+
+	if (is_vht_not_allowed(channel, vht_chbw)) {
+		if (vht_chbw == VHT_CHBW_80)
+			channel->flags |= IEEE80211_CHAN_NO_VHT80;
+		else if (vht_chbw == VHT_CHBW_160)
+			channel->flags |= IEEE80211_CHAN_NO_VHT160;
+		return;
+	}
+
+	/*
+	 * We need to ensure the multiple extension channels exist
+	 * to be able to use 80 or 160 MHz bw, this finds them (or not)
+	 *
+	 * Start with extreme below ext channel.
+	 * extreme below for 80 MHz BW will be 80-, 160 MHz BW will be 160-
+	 * extreme above for 80 MHz BW will be 80+, 160 MHz BW will be 160+
+	 */
+
+	for (i = 0; i < sband->n_channels; i++) {
+		struct ieee80211_channel *c = &sband->channels[i];
+
+		/*
+		 * start with either 80- or 160-
+		 * ext_channels[] array stores all possible ext channels
+		 * for a given VHT channel and channel bandwidth
+		 */
+		ext_chan_offset = (CHWIDTH_5G - vht_chbw);
+		for (j=0; ext_chan_offset <= (vht_chbw - CHWIDTH_5G);
+		     ext_chan_offset += CHWIDTH_5G, j++) {
+			if (ext_chan_offset == 0)
+				continue;
+			if(c->center_freq ==
+			   channel->center_freq + ext_chan_offset)
+				ext_channels[j] = c;
+		}
+	}
+
+	/*
+	 * Now that we have found all possible extension channels for
+	 * a given channel and BW, set the channel flags if valid ext channels
+	 * exists.
+	 *
+	 * For 80 Mhz BW, valid ext channels are
+	 * 80- 60- 40- 40+ 60+ 80+
+	 *
+	 * For 160 MHz BW, valid ext channels are
+	 * 160- 140- 120- 100- 80- 60- 40- 40+ 60+ 80+ 100+ 120+ 140+ 160+.
+	 */
+	for (j=0; j < (vht_chbw/CHWIDTH_5G); j++) {
+		if (vht_chbw == VHT_CHBW_80) {
+			/*
+			 * For 80 MHz channel bandwidth, ext_channels
+			 * 80-, 60- 40- i.e ext_channels[0], ext_channels[1],
+			 * ext_channels[2] should exist. Next 60-, 40-, 40+
+			 * should exist and so on.
+			 */
+			if (is_vht_not_allowed(ext_channels[j], vht_chbw) &&
+			    is_vht_not_allowed(ext_channels[j+1], vht_chbw) &&
+			    is_vht_not_allowed(ext_channels[j+2], vht_chbw))
+				channel->flags |= vht80_flags[j];
+			else
+				channel->flags &= vht80_flags[j];
+		}
+
+		if (vht_chbw == VHT_CHBW_160) {
+			/*
+			 * For 160 MHz channel bandwidth, ext_channels
+			 * 160-, 140-, 120-, 100-, 80-, 60- 40- means
+			 * ext_channels[0], ext_channels[1], ext_channels[3]
+			 * ext_channels[2], ext_channels[4], ext_channels[5]
+			 * should exist. Next 140-, 120-, 100-, 80-, 60-,
+			 * 40-, 40+ should exist and so on.
+			 */
+			if (is_vht_not_allowed(ext_channels[j], vht_chbw) &&
+			    is_vht_not_allowed(ext_channels[j+1], vht_chbw) &&
+			    is_vht_not_allowed(ext_channels[j+2], vht_chbw) &&
+			    is_vht_not_allowed(ext_channels[j+3], vht_chbw) &&
+			    is_vht_not_allowed(ext_channels[j+4], vht_chbw) &&
+			    is_vht_not_allowed(ext_channels[j+5], vht_chbw))
+				channel->flags |= vht160_flags[j];
+			else
+				channel->flags &= vht160_flags[j];
+		}
+	}
+}
+
+static void reg_process_vht_flags(struct wiphy *wiphy)
+{
+	unsigned int i;
+	struct ieee80211_supported_band *sband;
+
+	if(!wiphy->bands[IEEE80211_BAND_5GHZ]) {
+		/* 5GHz band is not supported, which is
+		 * mandatory for VHT. so simply return */
+		return;
+	}
+	sband = wiphy->bands[IEEE80211_BAND_5GHZ];
+
+	for (i = 0; i < sband->n_channels; i++) {
+		reg_process_vht_flags_channel(wiphy, i, VHT_CHBW_80);
+		reg_process_vht_flags_channel(wiphy, i, VHT_CHBW_160);
+	}
+}
+
  static bool is_ht40_not_allowed(struct ieee80211_channel *chan)
  {
  	if (!chan)
@@ -1230,6 +1399,7 @@ static void wiphy_update_regulatory(struct wiphy 
*wiphy,

  	reg_process_beacons(wiphy);
  	reg_process_ht_flags(wiphy);
+	reg_process_vht_flags(wiphy);
  	if (wiphy->reg_notifier)
  		wiphy->reg_notifier(wiphy, last_request);
  }
@@ -1296,7 +1466,16 @@ static void handle_channel_custom(struct wiphy 
*wiphy,
  	freq_range = &reg_rule->freq_range;

  	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
-		bw_flags = IEEE80211_CHAN_NO_HT40;
+		bw_flags = IEEE80211_CHAN_NO_HT40 |
+			   IEEE80211_CHAN_NO_VHT80 |
+			   IEEE80211_CHAN_NO_VHT160;
+
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(80))
+		bw_flags = IEEE80211_CHAN_NO_VHT80 |
+			   IEEE80211_CHAN_NO_VHT160;
+
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(160))
+		bw_flags = IEEE80211_CHAN_NO_VHT160;

  	chan->flags |= map_regdom_flags(reg_rule->flags) | bw_flags;
  	chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index f023c8a..f2ba79a 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -16,6 +16,11 @@
   * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
   */

+#define VHT_CHBW_80	80
+#define VHT_CHBW_160	160
+#define CHWIDTH_5G	20
+#define EXT_CHANS_MAX	(2*VHT_CHBW_160/CHWIDTH_5G)-2
+
  extern const struct ieee80211_regdomain *cfg80211_regdomain;

  bool is_world_regdom(const char *alpha2);

