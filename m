Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022Ab1AaJix (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 04:38:53 -0500
Date: Mon, 31 Jan 2011 10:38:43 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org, bruno randolf <br1@einfach.org>
Subject: Re: [BUG] iwlwifi need to correct channels info
Message-ID: <20110131093840.GA20613@redhat.com>
References: <20110128154100.GB2452@redhat.com>
 <1296237969.5118.12.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1296237969.5118.12.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 28, 2011 at 07:06:09PM +0100, Johannes Berg wrote:
> On Fri, 2011-01-28 at 16:41 +0100, Stanislaw Gruszka wrote:
> > After commit 59eb21a6504731fc16db4cf9463065dd61093e08
> > "cfg80211: Extend channel to frequency mapping for 802.11j"
> > 5GHz networks are not seen on scan results.
> > 
> > I think above commit is correct, but we have broken channel
> > information on iwlwifi (freq is 0 on 5GHz channels):
> 
> No, the above commit is buggy -- it assumes sband->band is set when it
> isn't. 
But it should be, no? It seems we initialize it nowhere, but it's
used in iwl-*-rs.c

BTW:
Is iwl_eeprom_band_2[] array correct? It have 7, 8, 11, 12 channels entries
on 5GHz.

Can we get rid of /* FIXME: might be removed if scan is OK */ ?

> Does this fix it?

I tested on 3945, it fix freq=0 on messages. But what about something
slightly different? Use ch->band already set in iwl_init_channel_map()
and initialize sband->band.

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 92724cb..1c1da6f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -190,6 +190,7 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 
 	/* 5.2GHz channels start after the 2.4GHz channels */
 	sband = &priv->bands[IEEE80211_BAND_5GHZ];
+	sband->band = IEEE80211_BAND_5GHZ;
 	sband->channels = &channels[ARRAY_SIZE(iwl_eeprom_band_1)];
 	/* just OFDM */
 	sband->bitrates = &rates[IWL_FIRST_OFDM_RATE];
@@ -200,6 +201,7 @@ int iwlcore_init_geos(struct iwl_priv *priv)
 					 IEEE80211_BAND_5GHZ);
 
 	sband = &priv->bands[IEEE80211_BAND_2GHZ];
+	sband->band = IEEE80211_BAND_2GHZ;
 	sband->channels = channels;
 	/* OFDM & CCK */
 	sband->bitrates = rates;
@@ -219,16 +221,12 @@ int iwlcore_init_geos(struct iwl_priv *priv)
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
