Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737Ab1AaMCF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 07:02:05 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwlwifi: correct frequency settings
Date: Mon, 31 Jan 2011 13:01:35 +0100
Message-Id: <1296475295-5420-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After commit 59eb21a6504731fc16db4cf9463065dd61093e08
"cfg80211: Extend channel to frequency mapping for 802.11j"
we use uninitialized sband->band when assign channel frequencies, what
results that 5GHz channels have erroneous (zero) center_freq value.

Patch fixes problem and simplifies code a bit.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 92724cb..4ad8938 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -219,16 +219,12 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 		if (!is_channel_valid(ch))
 			continue;
 
-		if (is_channel_a_band(ch))
-			sband =  &priv->bands[IEEE80211_BAND_5GHZ];
-		else
-			sband =  &priv->bands[IEEE80211_BAND_2GHZ];
+		sband =  &priv->bands[ch->band];
 
 		geo_ch = &sband->channels[sband->n_channels++];
 
 		geo_ch->center_freq =
-				ieee80211_channel_to_frequency(ch->channel,
-							       sband->band);
+			ieee80211_channel_to_frequency(ch->channel, ch->band);
 		geo_ch->max_power = ch->max_power_avg;
 		geo_ch->max_antenna_gain = 0xff;
 		geo_ch->hw_value = ch->channel;
-- 
1.7.1

