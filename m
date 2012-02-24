Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:45661 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158Ab2BXFZZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 00:25:25 -0500
Message-ID: <4F471F40.8060503@posedge.com> (sfid-20120224_062537_147181_89990429)
Date: Fri, 24 Feb 2012 10:55:20 +0530
From: Mahesh <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [RFCv2] cfg80211: 80Mhz Bandwidth channel flags in 5Gig band
References: <f17c700977012ada368da4f339b9c639@posedge.com>  (sfid-20120222_185112_125868_ED7DF18C)  <1329933458.4657.2.camel@jlt3.sipsolutions.net>  (sfid-20120222_185746_860409_0CF57D5F) <1329937072.4657.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1329937072.4657.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 02/23/2012 12:27 AM, Johannes Berg wrote:
> On Wed, 2012-02-22 at 18:57 +0100, Johannes Berg wrote:
>> On Wed, 2012-02-22 at 23:21 +0530, Mahesh wrote:
>>> This change is for marking 80Mhz bandwidth supported channel flags in
>>> 5Gig band.
>>
>> This patch is not only completely mangled, it also neglects to actually
>> support this in the regdb etc. What's the point?
>
> I should elaborate. Something like this code is needed, but right now
> the regulatory database contains things like
>
>          (5150 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
>
> which means at most 40 MHz can be used.
>
> In your patch, you don't even check this maximum bandwidth, which is a
> bug, but even if you did the database would have to be changed.
>
> Also, we probably really need to introduce handling of spectral power
> limits to make this worthwhile?
>
> johannes
>

Agree. we will work towards updating regulatory database with 80Mhz 
bandwidth in 5Gig band. I had modified code to check maximum bandwidth 
as well. Please find the updated change below.

Signed-of-by: Mahesh Palivela (maheshp@posedge.com)
---

  include/net/cfg80211.h |   20 ++++++++---
  net/wireless/reg.c     |   87 
+++++++++++++++++++++++++++++++++++++++++++++--
  2 files changed, 97 insertions(+), 10 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 755a770..ddc0524 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -93,18 +93,26 @@ enum ieee80211_band {
   * 	is not permitted.
   * @IEEE80211_CHAN_NO_HT40MINUS: extension channel below this channel
   * 	is not permitted.
+ * @IEEE80211_CHAN_NO_VHT80PLUS: extension channel above this channel
+ * 	is not permitted.
+ * @IEEE80211_CHAN_NO_VHT80MINUS: extension channel below this channel
+ * 	is not permitted.
   */
  enum ieee80211_channel_flags {
-	IEEE80211_CHAN_DISABLED		= 1<<0,
-	IEEE80211_CHAN_PASSIVE_SCAN	= 1<<1,
-	IEEE80211_CHAN_NO_IBSS		= 1<<2,
-	IEEE80211_CHAN_RADAR		= 1<<3,
-	IEEE80211_CHAN_NO_HT40PLUS	= 1<<4,
-	IEEE80211_CHAN_NO_HT40MINUS	= 1<<5,
+	IEEE80211_CHAN_DISABLED		    = 1<<0,
+	IEEE80211_CHAN_PASSIVE_SCAN	    = 1<<1,
+	IEEE80211_CHAN_NO_IBSS		    = 1<<2,
+	IEEE80211_CHAN_RADAR		    = 1<<3,
+	IEEE80211_CHAN_NO_HT40PLUS	    = 1<<4,
+	IEEE80211_CHAN_NO_HT40MINUS	    = 1<<5,
+	IEEE80211_CHAN_NO_VHT80PLUS	    = 1<<6,
+	IEEE80211_CHAN_NO_VHT80MINUS	= 1<<7,
  };

  #define IEEE80211_CHAN_NO_HT40 \
  	(IEEE80211_CHAN_NO_HT40PLUS | IEEE80211_CHAN_NO_HT40MINUS)
+#define IEEE80211_CHAN_NO_VHT80 \
+	(IEEE80211_CHAN_NO_VHT80PLUS | IEEE80211_CHAN_NO_VHT80MINUS)

  /**
   * struct ieee80211_channel - channel definition
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e9a0ac8..c0c905e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -858,8 +858,11 @@ static void handle_channel(struct wiphy *wiphy,
  	power_rule = &reg_rule->power_rule;
  	freq_range = &reg_rule->freq_range;

-	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
-		bw_flags = IEEE80211_CHAN_NO_HT40;
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40)) {
+		bw_flags = IEEE80211_CHAN_NO_HT40 | IEEE80211_CHAN_NO_VHT80;
+    } else if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(80)) {
+		bw_flags = IEEE80211_CHAN_NO_VHT80;
+    }

  	if (last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
  	    request_wiphy && request_wiphy == wiphy &&
@@ -1048,6 +1051,77 @@ static void reg_process_beacons(struct wiphy *wiphy)
  	wiphy_update_beacon_reg(wiphy);
  }

+static bool is_vht80_not_allowed(struct ieee80211_channel *chan)
+{
+	if (!chan)
+		return true;
+	if (chan->flags & IEEE80211_CHAN_DISABLED)
+		return true;
+	/* This would happen when regulatory rules disallow VHT80 completely */
+	if (IEEE80211_CHAN_NO_VHT80 == (chan->flags & (IEEE80211_CHAN_NO_VHT80)))
+		return true;
+	return false;
+}
+
+static void reg_process_vht_flags_channel(struct wiphy *wiphy,
+					 unsigned int chan_idx)
+{
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *channel;
+	struct ieee80211_channel *channel_before = NULL, *channel_after = NULL;
+	unsigned int i;
+
+	assert_cfg80211_lock();
+
+	sband = wiphy->bands[IEEE80211_BAND_5GHZ];
+	BUG_ON(chan_idx >= sband->n_channels);
+	channel = &sband->channels[chan_idx];
+
+	if (is_vht80_not_allowed(channel)) {
+		channel->flags |= IEEE80211_CHAN_NO_VHT80;
+		return;
+	}
+
+	/*
+	 * We need to ensure the extension channels exist to
+	 * be able to use VHT80- or VHT80+, this finds them (or not)
+	 */
+	for (i = 0; i < sband->n_channels; i++) {
+		struct ieee80211_channel *c = &sband->channels[i];
+		if (c->center_freq == (channel->center_freq - 40))
+			channel_before = c;
+		if (c->center_freq == (channel->center_freq + 40))
+			channel_after = c;
+	}
+
+	/*
+	 * Please note that this assumes target bandwidth is 40 MHz,
+	 * if that ever changes we also need to change the below logic
+	 * to include that as well.
+	 */
+	if (is_vht80_not_allowed(channel_before))
+		channel->flags |= IEEE80211_CHAN_NO_VHT80MINUS;
+	else
+		channel->flags &= ~IEEE80211_CHAN_NO_VHT80MINUS;
+
+	if (is_vht80_not_allowed(channel_after))
+		channel->flags |= IEEE80211_CHAN_NO_VHT80PLUS;
+	else
+		channel->flags &= ~IEEE80211_CHAN_NO_VHT80PLUS;
+}
+
+static void reg_process_vht_flags(struct wiphy *wiphy)
+{
+	unsigned int i;
+	struct ieee80211_supported_band *sband;
+
+	BUG_ON(!wiphy->bands[IEEE80211_BAND_5GHZ]);
+	sband = wiphy->bands[IEEE80211_BAND_5GHZ];
+
+	for (i = 0; i < sband->n_channels; i++)
+		reg_process_vht_flags_channel(wiphy, i);
+}
+
  static bool is_ht40_not_allowed(struct ieee80211_channel *chan)
  {
  	if (!chan)
@@ -1154,6 +1228,8 @@ static void wiphy_update_regulatory(struct wiphy 
*wiphy,

  	reg_process_beacons(wiphy);
  	reg_process_ht_flags(wiphy);
+	reg_process_vht_flags(wiphy);
+
  	if (wiphy->reg_notifier)
  		wiphy->reg_notifier(wiphy, last_request);
  }
@@ -1227,8 +1303,11 @@ static void handle_channel_custom(struct wiphy 
*wiphy,
  	power_rule = &reg_rule->power_rule;
  	freq_range = &reg_rule->freq_range;

-	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
-		bw_flags = IEEE80211_CHAN_NO_HT40;
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40)) {
+		bw_flags = IEEE80211_CHAN_NO_HT40 | IEEE80211_CHAN_NO_VHT80;
+    } else if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(80)) {
+		bw_flags = IEEE80211_CHAN_NO_VHT80;
+    }

  	chan->flags |= map_regdom_flags(reg_rule->flags) | bw_flags;
  	chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
