Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43165 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbZEZSIq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 14:08:46 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 May 2009 11:08:48 -0700
Date: Tue, 26 May 2009 11:08:53 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Rob van Rijen <Rijen2004@hotmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>, <vasanth@atheros.com>
Subject: Re: [ath9k-devel] EEE PC with AR9280 using N mode with WPA2
Message-ID: <20090526180853.GE9370@tesla>
References: <BAY118-W504A562EAA1897CAA2E309B35D0@phx.gbl> <20090518160053.GD20637@tesla> <BLU0-SMTP51AE280656D73570BC12FEB3570@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <BLU0-SMTP51AE280656D73570BC12FEB3570@phx.gbl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 23, 2009 at 03:34:52PM -0700, Rob van Rijen wrote:
> Hi Luis
> 
> I managed to get the output you asked for.
> 
> System  EEE PC 1000H with AR9280
> Linux           OpenSuse 11.1, using KNetworkmanager / KDE4
> Kernel  2.6.30-rc6-git3-25-default
> Ath9k   compat-wireless-2009-05-23
> 
> The system freeze occurs within a few seconds after I connect to a WPA2
> wireless N router (Linksys WAG160N).
> With versions < compat-wireless-2009-05-17 I never could connect
> (disassociating by local choice (reason=3))
> 
> Regards
> Rob
> 
> ============================================================================
> =========
> [  132.542465] console [netcon0] enabled
> [  132.542527] netconsole: network logging started
> [  357.092325] wlan0: authenticate with AP 00:21:29:79:c0:84
> [  357.109905] wlan0: authenticated
> [  357.109962] wlan0: associate with AP 00:21:29:79:c0:84
> [  357.114820] wlan0: RX AssocResp from 00:21:29:79:c0:84 (capab=0x431
> status=0 aid=1)
> [  357.114893] wlan0: associated
> [  358.311927] padlock: VIA PadLock not detected.
> [  412.422746] ------------[ cut here ]------------
> [  412.422809] kernel BUG at
> /home/robvr/Downloads/compat-wireless-2009-05-23/drivers/net/wireless/ath/at
> h9k/rc.c:747!

Thanks, yes, I have seen this as well, please try this patch, it splits out
the ASSERT into 3 pieces and also downgrades it to a WARN_ON.

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index ba06e78..a372e35 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -741,10 +741,27 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 	if (rate > (ath_rc_priv->rate_table_size - 1))
 		rate = ath_rc_priv->rate_table_size - 1;
 
-	ASSERT((rate_table->info[rate].valid &&
-		(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG)) ||
-	       (rate_table->info[rate].valid_single_stream &&
+	/*
+	 * Getting any of these warnings would indicate an incorrect assumption
+	 * is currently being made with our rate control code. It would
+	 * indicate, most likely, that the incorrect rate table is being used.
+	 */
+
+	/* We shouldn't be passing up invalid rates */
+	WARN_ON(!rate_table->info[rate].valid &&
+		!rate_table->info[rate].valid_single_stream);
+	/*
+	 * We warn if the rate is deemed to be valid and yet
+	 * not suitable for dual stream.
+	 */
+	WARN_ON((rate_table->info[rate].valid &&
 		!(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG)));
+	/*
+	 * We also warn if the rate has been marked valid for single
+	 * stream but also dual stream...
+	 */
+	WARN_ON((rate_table->info[rate].valid_single_stream &&
+		(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG)));
 
 	return rate;
 }
