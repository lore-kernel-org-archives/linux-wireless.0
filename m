Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:30720 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbZAVRgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 12:36:46 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1976151yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 09:36:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1232631861-6028-4-git-send-email-me@bobcopeland.com>
References: <1232631861-6028-4-git-send-email-me@bobcopeland.com>
Date: Thu, 22 Jan 2009 19:36:45 +0200
Message-ID: <40f31dec0901220936n27736162vade7e7c53e35a490@mail.gmail.com> (sfid-20090122_183649_106872_A96F7D83)
Subject: Re: [PATCH 3/6] ath5k: continue reset sequence if gain calibration
	fails
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/1/22 Bob Copeland <me@bobcopeland.com>:
> If gain calibration fails, then ath5k_hw_reset will skip writing some
> important registers like the interrupt mask.  In legacy_hal, only an
> error is emitted in this case but the reset proceeds, so follow suit
> here.
>
> Changes to reset.c
> Changes-licensed-under: ISC
>
> Changes to base.c
> Changes-licensed-under: 3-Clause-BSD
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath5k/reset.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/reset.c b/drivers/net/wireless/ath5k/reset.c
> index c7cd380..3c8d3d6 100644
> --- a/drivers/net/wireless/ath5k/reset.c
> +++ b/drivers/net/wireless/ath5k/reset.c
> @@ -829,7 +829,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
>                        AR5K_PHY_AGCCTL_CAL, 0, false)) {
>                ATH5K_ERR(ah->ah_sc, "gain calibration timeout (%uMHz)\n",
>                        channel->center_freq);
> -               return -EAGAIN;
>        }
>
>        /*

Again i've already fixed that on my local branch (i said i'll update
reset code and i did, i just have to make some tests first), it's what
both HALs do. Notice that if offset calibration has not completed, i/q
calibration can't work (according to patent doc) and  noise floor
calibration always fails on some chips. IMHO we must check if the bit
got cleared while calling phy_calibrate because if it's not cleared
there is no meaning to perform i/q and nf calibration. That's why i
haven't removed that return yet. I always believe that the best thing
to do is to find a sane timeout interval that works on most cases
instead of just ignoring the fact that calibration timed out of
failed.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
