Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41388 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1A1SGZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 13:06:25 -0500
Subject: Re: [BUG] iwlwifi need to correct channels info
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org, bruno randolf <br1@einfach.org>
In-Reply-To: <20110128154100.GB2452@redhat.com>
References: <20110128154100.GB2452@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 19:06:09 +0100
Message-ID: <1296237969.5118.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-01-28 at 16:41 +0100, Stanislaw Gruszka wrote:
> After commit 59eb21a6504731fc16db4cf9463065dd61093e08
> "cfg80211: Extend channel to frequency mapping for 802.11j"
> 5GHz networks are not seen on scan results.
> 
> I think above commit is correct, but we have broken channel
> information on iwlwifi (freq is 0 on 5GHz channels):

No, the above commit is buggy -- it assumes sband->band is set when it
isn't. Does this fix it?

Bruno can you please verify you haven't made that mistake elsewhere?

johannes

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2011-01-28 19:01:01.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.c	2011-01-28 19:04:43.000000000 +0100
@@ -213,6 +213,8 @@ int iwlcore_init_geos(struct iwl_priv *p
 	priv->ieee_rates = rates;
 
 	for (i = 0;  i < priv->channel_count; i++) {
+		enum ieee80211_band band;
+
 		ch = &priv->channel_info[i];
 
 		/* FIXME: might be removed if scan is OK */
@@ -220,15 +222,15 @@ int iwlcore_init_geos(struct iwl_priv *p
 			continue;
 
 		if (is_channel_a_band(ch))
-			sband =  &priv->bands[IEEE80211_BAND_5GHZ];
+			band = IEEE80211_BAND_5GHZ;
 		else
-			sband =  &priv->bands[IEEE80211_BAND_2GHZ];
+			band = IEEE80211_BAND_2GHZ;
+		sband =  &priv->bands[band];
 
 		geo_ch = &sband->channels[sband->n_channels++];
 
 		geo_ch->center_freq =
-				ieee80211_channel_to_frequency(ch->channel,
-							       sband->band);
+			ieee80211_channel_to_frequency(ch->channel, band);
 		geo_ch->max_power = ch->max_power_avg;
 		geo_ch->max_antenna_gain = 0xff;
 		geo_ch->hw_value = ch->channel;


