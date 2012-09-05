Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-1.exch022.serverdata.net ([206.225.164.184]:1025 "EHLO
	HUB022-nj-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991Ab2IEHME (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 03:12:04 -0400
Message-ID: <5046FB3D.6090803@posedge.com> (sfid-20120905_091208_227127_B90C3C2A)
Date: Wed, 5 Sep 2012 12:41:57 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC v2] cfg80211: VHT regulatory
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

VHT (11ac) regulatory new design. VHT channel center freq, bandwidth and 
primary channel are used to decide if that channel config is permitted 
in current regulatory domain.

Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
---
Implementation of review comments by Johannes.

include/net/cfg80211.h |   37 +++++++++++++++++
net/wireless/reg.c     |  105 ++++++++++++++++++++++++++++++++++++++++++
  2 files changed, 142 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4c518f1..edc743f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -83,6 +83,25 @@ enum ieee80211_band {
  };

  /**
+ * enum ieee80211_chan_width - channel bandwidths
+ *
+ * @IEEE80211_CHAN_WIDTH_20MHZ_NOHT: 20 MHz chan bandwidth No HT
+ * @IEEE80211_CHAN_WIDTH_20MHZ: 20 MHz chan bandwidth
+ * @IEEE80211_CHAN_WIDTH_40MHZ: 40 MHz chan bandwidth
+ * @IEEE80211_CHAN_WIDTH_80MHZ: 80 MHz chan bandwidth
+ * @IEEE80211_CHAN_WIDTH_160MHZ: 160 MHz chan bandwidth
+ * @IEEE80211_CHAN_WIDTH_80P80MHZ: 80+80 MHz chan bandwidth
+ */
+enum ieee80211_chan_width {
+	IEEE80211_CHAN_WIDTH_20MHZ_NOHT,
+	IEEE80211_CHAN_WIDTH_20MHZ,
+	IEEE80211_CHAN_WIDTH_40MHZ,
+	IEEE80211_CHAN_WIDTH_80MHZ,
+	IEEE80211_CHAN_WIDTH_160MHZ,
+	IEEE80211_CHAN_WIDTH_80P80MHZ
+};
+
+/**
   * enum ieee80211_channel_flags - channel flags
   *
   * Channel flags set by the regulatory control code.
@@ -144,6 +163,24 @@ struct ieee80211_channel {
  };

  /**
+ * struct ieee80211_channel_config - channel config definition
+ *
+ * This structure describes channel configuration
+ *
+ * @chan_width1: channel bandwidth
+ * @center_freq1: center frequency of 1 st frequency segment
+ * @center_freq2: center frequency of 2 nd frequency segment
+ * 	Used only for 80+80 MHz combination
+ * @prim_chan_freq: primary channel frequency
+ */
+struct ieee80211_channel_config {
+	enum ieee80211_chan_width chan_width;
+	u16 center_freq1;
+	u16 center_freq2;
+	u16 prim_chan_freq;
+};
+
+/**
   * enum ieee80211_rate_flags - rate flags
   *
   * Hardware/specification flags for rates. These are structured
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2303ee7..f491f7b 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1124,6 +1124,111 @@ static void reg_process_beacons(struct wiphy *wiphy)
  	wiphy_update_beacon_reg(wiphy);
  }

+static bool reg_sec_chans_permitted(struct wiphy *wiphy,
+				    u32 center_freq,
+				    u32 bw_khz)
+{
+	struct ieee80211_channel *chan;
+	u32 left_end_freq, right_end_freq;
+
+	if (center_freq == 0 || bw_khz == 0)
+		return false;
+
+	/* find left and right arms of center freq */
+	left_end_freq = center_freq - (bw_khz/2);
+	right_end_freq = center_freq + (bw_khz/2);
+
+	/* left_end_freq and right_end_freq are edge of left and right
+	 * channels. Get center freq of left and right channels
+	 * by adding 10MHz to left_end_freq and subtracting 10 MHZ from
+	 * right_end_freq.
+	 */
+	left_end_freq += MHZ_TO_KHZ(10);
+	right_end_freq -= MHZ_TO_KHZ(10);
+
+	/* find out all possible secondary channels */
+	while (left_end_freq < right_end_freq) {
+		chan = ieee80211_get_channel(wiphy, left_end_freq);
+		if (chan == NULL ||
+		    chan->flags & IEEE80211_CHAN_DISABLED) {
+			return false;
+		}
+		left_end_freq -= MHZ_TO_KHZ(20);
+	}
+
+	return true;
+}
+
+bool reg_chan_use_permitted(struct wiphy *wiphy,
+			    struct ieee80211_channel_config *chan_config,
+			    const struct ieee80211_regdomain *regd)
+{
+	int r;
+	u32 desired_bw_khz = MHZ_TO_KHZ(20);
+	const struct ieee80211_reg_rule *reg_rule;
+	const struct ieee80211_freq_range *freq_range;
+	bool ret;
+
+	assert_reg_lock();
+
+	// get chan BW from config
+	switch (chan_config->chan_width) {
+	case IEEE80211_CHAN_WIDTH_20MHZ_NOHT:
+	case IEEE80211_CHAN_WIDTH_20MHZ:
+		desired_bw_khz = MHZ_TO_KHZ(20);
+		break;
+
+	case IEEE80211_CHAN_WIDTH_40MHZ:
+		desired_bw_khz = MHZ_TO_KHZ(40);
+		break;
+
+	case IEEE80211_CHAN_WIDTH_80MHZ:
+	case IEEE80211_CHAN_WIDTH_80P80MHZ:
+		desired_bw_khz = MHZ_TO_KHZ(80);
+		break;
+
+	case IEEE80211_CHAN_WIDTH_160MHZ:
+		desired_bw_khz = MHZ_TO_KHZ(160);
+		break;
+	default:
+		REG_DBG_PRINT("Invalid channel width %d\n",
+			      chan_config->chan_width);
+		return false;
+	}
+
+	r = freq_reg_info_regd(wiphy,
+			       chan_config->prim_chan_freq,
+			       desired_bw_khz,
+			       &reg_rule,
+			       regd);
+
+	if (r) {
+		REG_DBG_PRINT("Couldn't find reg rule for freq %d KHz"
+			      "and %d MHz wide channel\n",
+			      chan_config->prim_chan_freq,
+			      KHZ_TO_MHZ(desired_bw_khz));
+		return false;
+	}
+
+	freq_range = &reg_rule->freq_range;
+
+	if (freq_range->max_bandwidth_khz < desired_bw_khz)
+		return false;
+
+	ret = reg_sec_chans_permitted(wiphy,
+				      chan_config->center_freq1,
+				      desired_bw_khz);
+	if (ret == false)
+		return ret;
+
+	if (chan_config->chan_width == IEEE80211_CHAN_WIDTH_80P80MHZ) {
+		ret = reg_sec_chans_permitted(wiphy,
+					      chan_config->center_freq2,
+					      desired_bw_khz);
+	}
+	return ret;
+}
+
  static bool is_ht40_not_allowed(struct ieee80211_channel *chan)
  {
  	if (!chan)
