Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34856 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758428Ab1GKSq7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 14:46:59 -0400
Date: Mon, 11 Jul 2011 14:37:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH v2 1/8] ath5k: add missing checks for rfgain probe
Message-ID: <20110711183711.GD2650@tuxdriver.com> (sfid-20110711_204741_533262_22D3DE0B)
References: <1309835484-26653-1-git-send-email-nbd@openwrt.org>
 <CAFtRNNwK_LjP_2cAp0macP+8My4nzextWMNz9pLTKRW6V8tDjw@mail.gmail.com>
 <4E129788.4040803@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E129788.4040803@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 05, 2011 at 11:48:08AM +0700, Felix Fietkau wrote:
> On 2011-07-05 11:46 AM, Nick Kossifidis wrote:
> >2011/7/5 Felix Fietkau<nbd@openwrt.org>:
> >> rfgain probe is only necessary for OFDM operation on AR5111 and AR5112.
> >>
> >> Signed-off-by: Felix Fietkau<nbd@openwrt.org>
> >> ---
> >>   drivers/net/wireless/ath/ath5k/phy.c |   10 ++++++----
> >>   1 files changed, 6 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> >> index 5544191..d0bfcad 100644
> >> --- a/drivers/net/wireless/ath/ath5k/phy.c
> >> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> >> @@ -1604,11 +1604,13 @@ int ath5k_hw_phy_calibrate(struct ath5k_hw *ah,
> >>         int ret;
> >>
> >>         if (ah->ah_radio == AR5K_RF5110)
> >> -               ret = ath5k_hw_rf5110_calibrate(ah, channel);
> >> -       else {
> >> -               ret = ath5k_hw_rf511x_iq_calibrate(ah);
> >> +               return ath5k_hw_rf5110_calibrate(ah, channel);
> >> +
> >> +       ret = ath5k_hw_rf511x_iq_calibrate(ah);
> >> +
> >> +       if ((ah->ah_radio == AR5K_RF5112 || ah->ah_radio == AR5K_RF5112)&&
> >
> >You probably mean
> >ah->ah_radio == AR5K_RF5111 || ah->ah_radio == AR5K_RF5112
> You're right. I need to be more careful with copy&paste ;)
> Will send a v3 once you've looked over the other patches.
> 
> - Felix

Ping?  Time is running short...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
