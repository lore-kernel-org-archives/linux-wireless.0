Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49436 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab1AHNIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Jan 2011 08:08:43 -0500
Received: by qwa26 with SMTP id 26so18580897qwa.19
        for <linux-wireless@vger.kernel.org>; Sat, 08 Jan 2011 05:08:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201101081243.56629.br1@einfach.org>
References: <20110107052600.18730.98168.stgit@localhost6.localdomain6>
	<AANLkTikfUb+-Phy4nwdr-Vsf2Sg8dxO7-YepbqnfwyYt@mail.gmail.com>
	<AANLkTimesMqYthXLSU2RBF=9=5bDXv3QtnOZapCjCquG@mail.gmail.com>
	<201101081243.56629.br1@einfach.org>
Date: Sat, 8 Jan 2011 08:08:41 -0500
Message-ID: <AANLkTimYjvJbm9DPPDWWCsD76_DnFcBG3a2Z_B8Mhpzm@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: Extend channel to frequency mapping for 802.11j
From: Brian Prodoehl <bprodoehl@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 7, 2011 at 10:43 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Friday 07 January 2011 21:53:25 Brian Prodoehl wrote:
>> > Do all drivers still build with this patch?  I applied the previous
>> > RFC version of this patch to a late-December cut of compat-wireless,
>> > and had to touch the receive-handling code in a half-dozen or so
>> > drivers due to the API changes.
>
> I have to confess, I didn't check the drivers. Just tested with ath5k. Before
> this gets merged we have to fix all drivers which use these functions, true. I
> will try to do that next week...
>
>> Ah, I see.  All the driver changes I needed were because
>> ieee80211_channel_to_frequency() changed with the RFC patch, and this
>> patch keeps ieee80211_channel_to_frequency() the same.  Good stuff.
>
> Uh? This patch also changes ieee80211_channel_to_frequency(). Bad stuff. ;)
>
> bruno

I guess I saw what I wanted to see when I took a second look at the
re-posted patch.  Here are compile-fixes to all the affected drivers.
The following drivers are affected: mwl8k, iwlwifi, iwmc3200wifi,
libertas, rt2x00, wl1251 and wl12xx.  So I guess these driver fixes
need to be split into seven patches.  I don't use any of these
drivers, so I can't really vouch for if I'm pulling the band the
correct way for each.  I'm happy to split and submit, but I wouldn't
mind another set of eyes on these changes.


Index: compat-wireless-2011-01-07/drivers/net/wireless/mwl8k.c
===================================================================
--- compat-wireless-2011-01-07.orig/drivers/net/wireless/mwl8k.c	2011-01-07
15:04:00.000000000 -0500
+++ compat-wireless-2011-01-07/drivers/net/wireless/mwl8k.c	2011-01-08
07:51:23.843290770 -0500
@@ -834,7 +834,7 @@
 	} else {
 		status->band = IEEE80211_BAND_2GHZ;
 	}
-	status->freq = ieee80211_channel_to_frequency(rxd->channel);
+	status->freq = ieee80211_channel_to_frequency(rxd->channel, status->band);

 	*qos = rxd->qos_control;

@@ -931,7 +931,7 @@
 	} else {
 		status->band = IEEE80211_BAND_2GHZ;
 	}
-	status->freq = ieee80211_channel_to_frequency(rxd->channel);
+	status->freq = ieee80211_channel_to_frequency(rxd->channel, status->band);

 	*qos = rxd->qos_control;

Index: compat-wireless-2011-01-07/drivers/net/wireless/iwlwifi/iwl-3945.c
===================================================================
--- compat-wireless-2011-01-07.orig/drivers/net/wireless/iwlwifi/iwl-3945.c	2011-01-07
15:03:59.000000000 -0500
+++ compat-wireless-2011-01-07/drivers/net/wireless/iwlwifi/iwl-3945.c	2011-01-08
07:51:23.867290769 -0500
@@ -594,10 +594,10 @@

 	rx_status.flag = 0;
 	rx_status.mactime = le64_to_cpu(rx_end->timestamp);
-	rx_status.freq =
-		ieee80211_channel_to_frequency(le16_to_cpu(rx_hdr->channel));
 	rx_status.band = (rx_hdr->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
 				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+	rx_status.freq =
+		ieee80211_channel_to_frequency(le16_to_cpu(rx_hdr->channel), rx_status.band);

 	rx_status.rate_idx = iwl3945_hwrate_to_plcp_idx(rx_hdr->rate);
 	if (rx_status.band == IEEE80211_BAND_5GHZ)
Index: compat-wireless-2011-01-07/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
===================================================================
--- compat-wireless-2011-01-07.orig/drivers/net/wireless/iwlwifi/iwl-agn-lib.c	2011-01-07
15:03:59.000000000 -0500
+++ compat-wireless-2011-01-07/drivers/net/wireless/iwlwifi/iwl-agn-lib.c	2011-01-08
07:51:23.883290769 -0500
@@ -1157,10 +1157,10 @@

 	/* rx_status carries information about the packet to mac80211 */
 	rx_status.mactime = le64_to_cpu(phy_res->timestamp);
-	rx_status.freq =
-		ieee80211_channel_to_frequency(le16_to_cpu(phy_res->channel));
 	rx_status.band = (phy_res->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
 				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
+	rx_status.freq =
+		ieee80211_channel_to_frequency(le16_to_cpu(phy_res->channel),
rx_status.band);
 	rx_status.rate_idx =
 		iwlagn_hwrate_to_mac80211_idx(rate_n_flags, rx_status.band);
 	rx_status.flag = 0;
Index: compat-wireless-2011-01-07/drivers/net/wireless/iwlwifi/iwl-core.c
===================================================================
--- compat-wireless-2011-01-07.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2011-01-07
15:04:00.000000000 -0500
+++ compat-wireless-2011-01-07/drivers/net/wireless/iwlwifi/iwl-core.c	2011-01-08
07:51:23.903290769 -0500
@@ -227,7 +227,10 @@
 		geo_ch = &sband->channels[sband->n_channels++];

 		geo_ch->center_freq =
-				ieee80211_channel_to_frequency(ch->channel);
+				ieee80211_channel_to_frequency(ch->channel,
+				                               is_channel_a_band(ch) ?
+				                            		   IEEE80211_BAND_5GHZ :
+				                                       IEEE80211_BAND_2GHZ);
 		geo_ch->max_power = ch->max_power_avg;
 		geo_ch->max_antenna_gain = 0xff;
 		geo_ch->hw_value = ch->channel;
Index: compat-wireless-2011-01-07/drivers/net/wireless/iwmc3200wifi/rx.c
===================================================================
--- compat-wireless-2011-01-07.orig/drivers/net/wireless/iwmc3200wifi/rx.c	2011-01-07
15:04:00.000000000 -0500
+++ compat-wireless-2011-01-07/drivers/net/wireless/iwmc3200wifi/rx.c	2011-01-08
07:51:23.919290769 -0500
@@ -536,6 +536,7 @@
 	struct ieee80211_channel *chan;
 	struct iwm_umac_notif_assoc_complete *complete =
 		(struct iwm_umac_notif_assoc_complete *)buf;
+	u8 band = complete->band;

 	IWM_DBG_MLME(iwm, INFO, "Association with %pM completed, status: %d\n",
 		     complete->bssid, complete->status);
@@ -543,7 +544,9 @@
 	switch (le32_to_cpu(complete->status)) {
 	case UMAC_ASSOC_COMPLETE_SUCCESS:
 		chan = ieee80211_get_channel(wiphy,
-			ieee80211_channel_to_frequency(complete->channel));
+			ieee80211_channel_to_frequency(complete->channel,
+			(band == UMAC_BAND_2GHZ) ?
+					IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ));
 		if (!chan || chan->flags & IEEE80211_CHAN_DISABLED) {
 			/* Associated to a unallowed channel, disassociate. */
 			__iwm_invalidate_mlme_profile(iwm);
@@ -841,7 +844,9 @@
 		goto err;
 	}

-	freq = ieee80211_channel_to_frequency(umac_bss->channel);
+	freq = ieee80211_channel_to_frequency(umac_bss->channel,
+			umac_bss->band == UMAC_BAND_2GHZ ?
+					IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ);
 	channel = ieee80211_get_channel(wiphy, freq);
 	signal = umac_bss->rssi * 100;

Index: compat-wireless-2011-01-07/drivers/net/wireless/iwmc3200wifi/cfg80211.c
===================================================================
--- compat-wireless-2011-01-07.orig/drivers/net/wireless/iwmc3200wifi/cfg80211.c	2011-01-07
15:04:00.000000000 -0500
+++ compat-wireless-2011-01-07/drivers/net/wireless/iwmc3200wifi/cfg80211.c	2011-01-08
07:51:23.927290769 -0500
@@ -287,7 +287,9 @@
 			return -EINVAL;
 		}

-		freq = ieee80211_channel_to_frequency(umac_bss->channel);
+		freq = ieee80211_channel_to_frequency(umac_bss->channel,
+			umac_bss->band == UMAC_BAND_2GHZ ?
+			                  IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ);
 		channel = ieee80211_get_channel(wiphy, freq);
 		signal = umac_bss->rssi * 100;

Index: compat-wireless-2011-01-07/drivers/net/wireless/libertas/cfg.c
===================================================================
--- compat-wireless-2011-01-07.orig/drivers/net/wireless/libertas/cfg.c	2011-01-07
15:03:59.000000000 -0500
+++ compat-wireless-2011-01-07/drivers/net/wireless/libertas/cfg.c	2011-01-08
07:51:23.947290769 -0500
@@ -607,7 +607,8 @@
 		/* No channel, no luck */
 		if (chan_no != -1) {
 			struct wiphy *wiphy = priv->wdev->wiphy;
-			int freq = ieee80211_channel_to_frequency(chan_no);
+			int freq = ieee80211_channel_to_frequency(chan_no,
+					chan_no <= 14 ? IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ);
 			struct ieee80211_channel *channel =
 				ieee80211_get_channel(wiphy, freq);

@@ -1597,7 +1598,8 @@
 	lbs_deb_enter(LBS_DEB_CFG80211);

 	survey->channel = ieee80211_get_channel(wiphy,
-		ieee80211_channel_to_frequency(priv->channel));
+		ieee80211_channel_to_frequency(priv->channel,
+			priv->channel <= 14 ? IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ));

 	ret = lbs_get_rssi(priv, &signal, &noise);
 	if (ret == 0) {
Index: compat-wireless-2011-01-07/drivers/net/wireless/rt2x00/rt2x00dev.c
===================================================================
--- compat-wireless-2011-01-07.orig/drivers/net/wireless/rt2x00/rt2x00dev.c	2011-01-07
15:03:59.000000000 -0500
+++ compat-wireless-2011-01-07/drivers/net/wireless/rt2x00/rt2x00dev.c	2011-01-08
07:51:23.971290769 -0500
@@ -649,7 +649,8 @@
 			      const int channel, const int tx_power,
 			      const int value)
 {
-	entry->center_freq = ieee80211_channel_to_frequency(channel);
+	entry->center_freq = ieee80211_channel_to_frequency(channel,
+			channel <= 14 ? IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ);
 	entry->hw_value = value;
 	entry->max_power = tx_power;
 	entry->max_antenna_gain = 0xff;
Index: compat-wireless-2011-01-07/drivers/net/wireless/wl1251/rx.c
===================================================================
--- compat-wireless-2011-01-07.orig/drivers/net/wireless/wl1251/rx.c	2011-01-07
15:04:00.000000000 -0500
+++ compat-wireless-2011-01-07/drivers/net/wireless/wl1251/rx.c	2011-01-08
07:51:23.987290769 -0500
@@ -78,7 +78,7 @@
 	 */
 	wl->noise = desc->rssi - desc->snr / 2;

-	status->freq = ieee80211_channel_to_frequency(desc->channel);
+	status->freq = ieee80211_channel_to_frequency(desc->channel, status->band);

 	status->flag |= RX_FLAG_TSFT;

Index: compat-wireless-2011-01-07/drivers/net/wireless/wl12xx/rx.c
===================================================================
--- compat-wireless-2011-01-07.orig/drivers/net/wireless/wl12xx/rx.c	2011-01-07
15:04:00.000000000 -0500
+++ compat-wireless-2011-01-07/drivers/net/wireless/wl12xx/rx.c	2011-01-08
07:51:24.003290769 -0500
@@ -76,7 +76,7 @@
 	 */
 	wl->noise = desc->rssi - (desc->snr >> 1);

-	status->freq = ieee80211_channel_to_frequency(desc->channel);
+	status->freq = ieee80211_channel_to_frequency(desc->channel, desc_band);

 	if (desc->flags & WL1271_RX_DESC_ENCRYPT_MASK) {
 		status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED;
