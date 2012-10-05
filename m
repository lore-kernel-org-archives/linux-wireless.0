Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:53421 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750Ab2JEPDy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 11:03:54 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Adrian Chadd <adrian@freebsd.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	lindner_marek@yahoo.de
Subject: Re: [ath9k-devel] [PATCHv2] ath9k_hw: Handle AR_INTR_SYNC_HOST1_FATAL on AR9003
Date: Fri, 05 Oct 2012 17:03:50 +0200
Message-ID: <1661867.OB0LbMnEW9@bentobox> (sfid-20121005_170358_236816_8478DC3D)
In-Reply-To: <506EDF89.5000805@openwrt.org>
References: <1348756862-8788-1-git-send-email-sven@narfation.org> <2475573.rN7d8lielt@bentobox> <506EDF89.5000805@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1832589.e3xUee7L3W"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart1832589.e3xUee7L3W
Content-Type: multipart/mixed; boundary="nextPart3171788.qEHCaxVSij"
Content-Transfer-Encoding: 7Bit


--nextPart3171788.qEHCaxVSij
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday 05 October 2012 15:24:25 Felix Fietkau wrote:
> On 2012-10-05 3:07 PM, Sven Eckelmann wrote:
> > On Friday 05 October 2012 14:34:28 Felix Fietkau wrote:
> >> On 2012-10-05 1:08 PM, Sven Eckelmann wrote:
> > [...]
> > 
> >> Please try this patch to see if it gets rid of these interrupts:
> >> ---
> >> --- a/drivers/net/wireless/ath/ath9k/ani.c
> >> +++ b/drivers/net/wireless/ath/ath9k/ani.c
> >> @@ -307,7 +307,8 @@ void ath9k_ani_reset(struct ath_hw *ah,
> >> 
> >>  		if (IS_CHAN_2GHZ(chan)) {
> >>  		
> >>  			ah->ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
> >>  			
> >>  					    ATH9K_ANI_FIRSTEP_LEVEL);
> >> 
> >> -			if (AR_SREV_9300_20_OR_LATER(ah))
> >> +			if (AR_SREV_9300_20_OR_LATER(ah) &&
> >> +			    ah->caps.rx_chainmask != 1)
> >> 
> >>  				ah->ani_function |= ATH9K_ANI_MRC_CCK;
> >>  		
> >>  		} else
> >>  		
> >>  			ah->ani_function = 0;
> > 
> > Looks partially good. At least this patch fixed parts my friday :D
> > 
> > I have more similar bugs, but at least this one is related to a bandwidth
> > problem which I also wanted to check today. But it didn't fix _this_
> > invalid register access on the client device (but I don't see it anymore
> > on the AP device).
> 
> Are you sure that it's still the same register access on the client
> side? I don't see how it could still access MRC related registers with
> this part masked out.

Yes, I am sure. Let's read some code:

	if (ah->opmode == NL80211_IFTYPE_AP) {
		if (IS_CHAN_2GHZ(chan)) {
			ah->ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
					    ATH9K_ANI_FIRSTEP_LEVEL);
			if (AR_SREV_9300_20_OR_LATER(ah) &&
			    ah->caps.rx_chainmask != 1)
				ah->ani_function |= ATH9K_ANI_MRC_CCK;
		} else
			ah->ani_function = 0;
	}

Now raise your hands when you see the "ah->opmode == NL80211_IFTYPE_AP". I've 
just added following after this block

	if (!AR_SREV_9300_20_OR_LATER(ah) || ah->caps.rx_chainmask == 1)
		ah->ani_function &= ~ATH9K_ANI_MRC_CCK;

But maybe it is better to fix the test in __ath9k_hw_init

	if (!AR_SREV_9300_20_OR_LATER(ah) || ah->caps.rx_chainmask == 1)
		ah->ani_function &= ~ATH9K_ANI_MRC_CCK;

The problem in __ath9k_hw_init is the value of ah->caps.rx_chainmask ... which 
is not yet initialized correctly (and therefore ends up as 0).

I've attached my "please don't enable MRC CCK" version of the patch. Feel free 
to submit it because you've submitted the initial version... or other things 
with it ;)

And thanks a lot for the help.

> Maybe it would make sense to come up with a debugging patch that checks
> the IRQ status register on every register access to see if an error was
> reported by the last one, and if there is an error, throw a stack trace.

Already done that. But got not enough useful information from this spam of 
half backed stackdumps. But storing the value of the sync_cause register 
helped a lot.

Kind regards,
	Sven
--nextPart3171788.qEHCaxVSij
Content-Disposition: attachment; filename="991-ani_mrc_cck.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="991-ani_mrc_cck.patch"

--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -307,12 +307,16 @@ void ath9k_ani_reset(struct ath_hw *ah,
 		if (IS_CHAN_2GHZ(chan)) {
 			ah->ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
 					    ATH9K_ANI_FIRSTEP_LEVEL);
-			if (AR_SREV_9300_20_OR_LATER(ah))
+			if (AR_SREV_9300_20_OR_LATER(ah) &&
+			    ah->caps.rx_chainmask != 1)
 				ah->ani_function |= ATH9K_ANI_MRC_CCK;
 		} else
 			ah->ani_function = 0;
 	}
 
+	if (!AR_SREV_9300_20_OR_LATER(ah) || ah->caps.rx_chainmask == 1)
+		ah->ani_function &= ~ATH9K_ANI_MRC_CCK;
+
 	/* always allow mode (on/off) to be controlled */
 	ah->ani_function |= ATH9K_ANI_MODE;
 
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -674,7 +674,7 @@ static int __ath9k_hw_init(struct ath_hw
 	ah->ani_function = ATH9K_ANI_ALL;
 	if (AR_SREV_9280_20_OR_LATER(ah) && !AR_SREV_9300_20_OR_LATER(ah))
 		ah->ani_function &= ~ATH9K_ANI_NOISE_IMMUNITY_LEVEL;
-	if (!AR_SREV_9300_20_OR_LATER(ah))
+	if (!AR_SREV_9300_20_OR_LATER(ah) || ah->caps.rx_chainmask == 1)
 		ah->ani_function &= ~ATH9K_ANI_MRC_CCK;
 
 	ath9k_hw_init_mode_regs(ah);

--nextPart3171788.qEHCaxVSij--

--nextPart1832589.e3xUee7L3W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQbvbWAAoJEF2HCgfBJntGkDkQAMeS4itFg8tz2KYDPwvyYcCw
OB2SGHwNQ9WRJRuGhQRbcjHVPf+Rq/YqIjvOo5LVaFuP1x08pXJywTeaMxNQ1HB2
kZl72U1CBeq5sfLusp8sB6riXDh+jcw6tws6nOWZ/tYQfavr+o6FJ+pbVcBG7O2h
+6lzgj22nKYqpdlevN8HnrAzhrMhSkLoCYfIw7AuTJNuPOcT6D5B/ujLvQeIcqfG
rw2PPMGsRmi+2umLTOSDNPaw6ozqAk18mXhZAGAQrvaOFGmdXeSds4HZoFDLr3+0
CMzEm/lYLUYKDRepbdS2ApyYS9FzY77tmtmGcI6luCyqgjhbyP6/oRfO8njXfc48
y+yEfOZ+EE4A8D+m424cq/7g/XaN10joWHjgR2FFK7do2vwf3kT7knxTKZAbPoSs
LsvQmZDSKCoMT7cRj2HKBlVWwxazq18FthKg2BiKQcAjymSyMyrQ+ZGopci8oso0
br/lu2ZZlx4D5o2SkoRtoHPQaVAJiSuW2iwPmqYLII3Ik3bzTrQxxGD9Nqmc80FW
me+g3QvA8Fb4QPIycDcqi12SIYaZdIVWjyxmcPsqr7d8hPnWTn5yTd7kildLCTrT
en8aLQ7KZRSnU0sO4tWPaxwQKXw99kedFU99pCDp6S/e5OsUq9M+CwDQp1NICJRW
Bt9HefI4WBpJE9pLSJH7
=9Vhv
-----END PGP SIGNATURE-----

--nextPart1832589.e3xUee7L3W--

