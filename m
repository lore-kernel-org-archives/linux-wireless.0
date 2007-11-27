Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:28453 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbXK0A2E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 19:28:04 -0500
Received: by py-out-1112.google.com with SMTP id u77so1802856pyb
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2007 16:28:02 -0800 (PST)
Message-ID: <43e72e890711261628j3aa9325ch8ea4284de18beb30@mail.gmail.com> (sfid-20071127_002809_176683_2F5E8ECB)
Date: Mon, 26 Nov 2007 19:28:02 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 1/3] ath5k: fix noise floor calibration
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com
In-Reply-To: <1195815123-22375-2-git-send-email-bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1195815123-22375-1-git-send-email-bruno@thinktube.com>
	 <1195815123-22375-2-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 23, 2007 5:52 AM, Bruno Randolf <bruno@thinktube.com> wrote:

> diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
> index 3c2a67c..9b91121 100644
> --- a/drivers/net/wireless/ath5k/phy.c
> +++ b/drivers/net/wireless/ath5k/phy.c
> @@ -1519,6 +1519,51 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
>  /*****************\
>    PHY calibration
>  \*****************/
> +int
> +ath5k_hw_noise_floor_calibration(struct ath5k_hw *ah, short freq)
> +{

Good idea :) Mind adding kdoc for this? I hope we can add kdoc for
more hw stuff to eventually export this automatically as developer
documentation.

> +       int ret;
> +       unsigned int i;
> +       s32 noise_floor;
> +
> +       /*
> +        * Enable noise floor calibration and wait until completion
> +        */
> +       AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL,
> +                               AR5K_PHY_AGCCTL_NF);

This is minor but you probably noticed ath5k_hw_rf511x_calibrate()
only enables noise floor calibration but does not actually wait and
check for the value. I am not sure why. Anyone? Anyway, until we do
how about wrapping the AR5K_REG_ENABLE_BITS for noise floor into a
small static inline ath5k_hw_enable_noise_floor(). Then your new
routine can call it and so can ath5k_hw_rf511x_calibrate().

> +       ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_CALIBRATE,
> +               "noise floor %d, %d\n", noise_floor, AR5K_TUNE_NOISE_FLOOR);

This relies on your previous debug.[ch] patches which are pending.
Just a note, next time you may want to mention this, just so that if
someone wants to test this they'll know how to get to test it without
compilation problems. It'll also help John know if he can apply this
or if he has to wait for pending patches.

  Luis
