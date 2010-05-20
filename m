Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:48468 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab0ETMsx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 08:48:53 -0400
Received: by ewy8 with SMTP id 8so3002849ewy.28
        for <linux-wireless@vger.kernel.org>; Thu, 20 May 2010 05:48:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100519013055.22206.21675.stgit@tt-desk>
References: <20100519012528.22206.77550.stgit@tt-desk>
	 <20100519013055.22206.21675.stgit@tt-desk>
Date: Thu, 20 May 2010 15:48:51 +0300
Message-ID: <AANLkTikHkEJQcP7iNaIWDR6nfzayMHhTKPD05HukGM5B@mail.gmail.com>
Subject: Re: [PATCH v2 03/20] ath5k: initialize calibration timers
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/5/19 Bruno Randolf <br1@einfach.org>:
> Initialize calibration timers on reset, since otherwise they might be in the
> future and the calibration tasklet might not be scheduled for a long time.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 9f9107b..de59a6e 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -2926,6 +2926,8 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
>
>        ath5k_ani_init(ah, ah->ah_sc->ani_state.ani_mode);
>
> +       ah->ah_cal_next_full = jiffies;
> +       ah->ah_cal_next_ani = jiffies;
>        /*
>         * Change channels and update the h/w rate map if we're switching;
>         * e.g. 11a to 11b/g.
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
