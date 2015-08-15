Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61023 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190AbbHOTkw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2015 15:40:52 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 8/9] mac80211: avoid VHT usage with no 80MHz chans allowed
Date: Sat, 15 Aug 2015 22:39:53 +0300
Message-Id: <1439667594-13632-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150815_214055_356039_9F328248)
In-Reply-To: <1439667594-13632-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1439667594-13632-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Currently if 80MHz channels are not allowed for use, the VHT IE is not
included in the probe request for an AP. This is not good enough if the
AP is configured with the wrong regulatory and supports VHT even where
prohibited or in TDLS scenarios.
Mark the ifmgd with the DISABLE_VHT flag for the misbehaving-AP case, and
unset VHT support from the peer-station entry for the TDLS case.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/mlme.c | 16 ++++++++++++++++
 net/mac80211/vht.c  | 15 +++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 705ef1d..cd7e55e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4267,6 +4267,8 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_supported_band *sband;
 	struct cfg80211_chan_def chandef;
 	int ret;
+	u32 i;
+	bool have_80mhz;
 
 	sband = local->hw.wiphy->bands[cbss->channel->band];
 
@@ -4317,6 +4319,20 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	/* Allow VHT if at least one channel on the sband supports 80 MHz */
+	have_80mhz = false;
+	for (i = 0; i < sband->n_channels; i++) {
+		if (sband->channels[i].flags & (IEEE80211_CHAN_DISABLED |
+						IEEE80211_CHAN_NO_80MHZ))
+			continue;
+
+		have_80mhz = true;
+		break;
+	}
+
+	if (!have_80mhz)
+		ifmgd->flags |= IEEE80211_STA_DISABLE_VHT;
+
 	ifmgd->flags |= ieee80211_determine_chantype(sdata, sband,
 						     cbss->channel,
 						     ht_cap, ht_oper, vht_oper,
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 834ccdb..ff1c798 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -120,6 +120,7 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_sta_vht_cap *vht_cap = &sta->sta.vht_cap;
 	struct ieee80211_sta_vht_cap own_cap;
 	u32 cap_info, i;
+	bool have_80mhz;
 
 	memset(vht_cap, 0, sizeof(*vht_cap));
 
@@ -129,6 +130,20 @@ ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 	if (!vht_cap_ie || !sband->vht_cap.vht_supported)
 		return;
 
+	/* Allow VHT if at least one channel on the sband supports 80 MHz */
+	have_80mhz = false;
+	for (i = 0; i < sband->n_channels; i++) {
+		if (sband->channels[i].flags & (IEEE80211_CHAN_DISABLED |
+						IEEE80211_CHAN_NO_80MHZ))
+			continue;
+
+		have_80mhz = true;
+		break;
+	}
+
+	if (!have_80mhz)
+		return;
+
 	/*
 	 * A VHT STA must support 40 MHz, but if we verify that here
 	 * then we break a few things - some APs (e.g. Netgear R6300v2
-- 
2.1.4

