Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53411 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab2FZTix (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 15:38:53 -0400
Date: Tue, 26 Jun 2012 14:38:44 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] brcmsmac: fix NULL pointer crash in brcms_c_regd_init()
Message-ID: <20120626193844.GA20509@thinkpad-t410> (sfid-20120626_213856_809833_2E3C62F4)
References: <1340286553-12053-1-git-send-email-arend@broadcom.com>
 <20120625165345.GB4495@thinkpad-t410>
 <4FE984F9.2060502@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FE984F9.2060502@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 26, 2012 at 11:46:33AM +0200, Arend van Spriel wrote:
> > This looks fine, but it strikes me that it might simplify things a bit
> > to change the loop to iterate over over wlc->pub->_nbands instead. The
> > difference is pretty minor though, and since John has already applied
> > this patch there's probably no reason to change it.
> 
> I considered that but the iterator is used as index in the wiphy.band[]
> array further in the loop. So that would require a bit more rework of
> the loop

It's really not that bad though. I pasted an (untested) patch below.
But like I said before, the difference is pretty minor so I'm okay with
either.

> (although the internal band index and the one from cfg80211 match).

While this is true, I wouldn't want to build that assumption into the
code. Maybe there should be macros to map between the internal and
cfg80211 band indices.


diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 2d365d3..2c10bbe 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -760,23 +760,17 @@ void brcms_c_regd_init(struct brcms_c_info *wlc)
 	struct ieee80211_channel *ch;
 	struct brcms_chanvec sup_chan;
 	struct brcms_band *band;
-	int band_idx, i;
+	uint band_idx, i;
 
 	/* Disable any channels not supported by the phy */
-	for (band_idx = 0; band_idx < IEEE80211_NUM_BANDS; band_idx++) {
-		if (band_idx == IEEE80211_BAND_2GHZ)
-			band = wlc->bandstate[BAND_2G_INDEX];
-		else
-			band = wlc->bandstate[BAND_5G_INDEX];
-
-		/* skip if band not initialized */
-		if (band->pi == NULL)
-			continue;
+	for (band_idx = 0; band_idx < wlc->pub->_nbands; band_idx++) {
+		band = wlc->bandstate[band_idx];
+		sband = wiphy->bands[band_idx == BAND_2G_INDEX ?
+				     IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ];
 
 		wlc_phy_chanspec_band_validch(band->pi, band->bandtype,
 					      &sup_chan);
 
-		sband = wiphy->bands[band_idx];
 		for (i = 0; i < sband->n_channels; i++) {
 			ch = &sband->channels[i];
 			if (!isset(sup_chan.vec, ch->hw_value))
