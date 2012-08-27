Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-3.exch022.serverdata.net ([206.225.164.186]:8476 "EHLO
	HUB022-nj-3.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948Ab2H0MFc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 08:05:32 -0400
Message-ID: <503B627A.6060604@posedge.com> (sfid-20120827_140536_569067_618841E5)
Date: Mon, 27 Aug 2012 17:35:14 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH] cfg80211: VHT (11ac) Regulatory change
References: <502E85D9.5050301@posedge.com>   <1345480718.4459.37.camel@jlt3.sipsolutions.net>   <87d32k7kga.fsf@purkki.adurom.net> <20120821081839.GA2380@redhat.com>   <50338E84.3050709@posedge.com>   <1345564421.10280.9.camel@jlt3.sipsolutions.net>   <5033CE76.6040306@posedge.com>   <1345619008.4635.3.camel@jlt3.sipsolutions.net>   <20120822090104.GA4959@redhat.com>   <1345626282.4635.8.camel@jlt3.sipsolutions.net>   <20120822101252.GA6082@redhat.com> <50376671.7080007@posedge.com>  <1345809927.6991.0.camel@jlt3.sipsolutions.net>  <50377CD9.3090204@posedge.com> <1345970386.3622.5.camel@jlt4.sipsolutions.net>
In-Reply-To: <1345970386.3622.5.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/26/2012 02:09 PM, Johannes Berg wrote:
>
> We don't support 5/10 MHz (yet anyway), so we don't have to worry about
> that.
>
>
> Yes, but how's that related to how you specify the channel?
>
> joahnnes
>
Please review below function if its inline with our email discussion.
---

  include/net/cfg80211.h |   36 +++++++++++++++++
  net/wireless/reg.c     |  103 
++++++++++++++++++++++++++++++++++++++++++++++++
  2 files changed, 139 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4c518f1..9a17e3d 100644
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
@@ -144,6 +163,23 @@ struct ieee80211_channel {
  };

  /**
+ * struct ieee80211_channel_config - channel config definition
+ *
+ * This structure describes channel configuration
+ *
+ * @chan_width1: channel bandwidth
+ * @center_freq1: center frequency of 1 st frequency segment
+ * @center_freq2: center frequency of 2 nd frequency segment
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
index 2303ee7..dd13f70 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1124,6 +1124,109 @@ static void reg_process_beacons(struct wiphy *wiphy)
  	wiphy_update_beacon_reg(wiphy);
  }

+static bool reg_sec_chans_permitted(struct wiphy *wiphy,
+				    u32 center_freq)
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
+	 * by subtracting 10 MHZ from each of them.
+	 */
+	left_end_freq -= MHZ_TO_KHZ(10);
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
+bool reg_chan_use_permitted(struct wiphy *wiphy,
+			    struct ieee80211_chan_config *chan_config,
+			    const struct ieee80211_regdomain *regd)
+{
+	int r;
+	u32 desired_bw_khz = MHZ_TO_KHZ(20);
+	const struct ieee80211_reg_rule *reg_rule = NULL;
+	const struct ieee80211_freq_range *freq_range = NULL;
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
+		desired_bw_khz = MHZ_TO_KHZ(80);
+		break;
+
+	case IEEE80211_CHAN_WIDTH_160MHZ:
+	case IEEE80211_CHAN_WIDTH_80P80MHZ:
+		desired_bw_khz = MHZ_TO_KHZ(160);
+		break;
+	}
+
+	r = freq_reg_info_regd(wiphy,
+			       chan_config->prim_chan_freq,
+			       desired_bw_khz,
+			       &reg_rule,
+			       regd);
+
+	if (r) {
+		REG_DBG_PRINT("Disabling freq %d MHz as custom "
+			      "regd has no rule that fits a %d MHz "
+			      "wide channel\n",
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
+	if (chan_config->chan_width == IEEE80211_CHAN_WIDTH_80P80MHZ) {
+		ret = reg_sec_chans_permitted(wiphy,
+					      chan_config->center_freq1,
+					      desired_bw_khz/2);
+		if (ret == false)
+			return ret;
+		ret = reg_sec_chans_permitted(wiphy,
+					      chan_config->center_freq2,
+					      desired_bw_khz/2);
+	} else {
+		ret = reg_sec_chans_permitted(wiphy,
+					      chan_config->center_freq1,
+					      desired_bw_khz);
+	}
+	return ret;
+}
+
  static bool is_ht40_not_allowed(struct ieee80211_channel *chan)
  {
  	if (!chan)
