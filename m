Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:23346 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbYJNIYM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 04:24:12 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1985386wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 14 Oct 2008 01:24:11 -0700 (PDT)
Message-ID: <40f31dec0810140124o3e513811gafcbecaf63115c08@mail.gmail.com> (sfid-20081014_102419_279745_90E96C71)
Date: Tue, 14 Oct 2008 11:24:11 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH 3/3] ath5k: correct ath5k signal quality
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1223932090-9274-4-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1223932090-9274-1-git-send-email-lrodriguez@atheros.com>
	 <1223932090-9274-2-git-send-email-lrodriguez@atheros.com>
	 <1223932090-9274-3-git-send-email-lrodriguez@atheros.com>
	 <1223932090-9274-4-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/14 Luis R. Rodriguez <lrodriguez@atheros.com>:
> This adjusts ath5k's signal quality reporting taking into
> consideration received beacons at an RSSI of 35 should indicate
> you can use of 54 Mbps on a single stream card (all ath5k cards)
> reliably.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/ath5k/base.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 1a24a22..c7f46e9 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -1798,7 +1798,17 @@ accept:
>
>                rxs.noise = sc->ah->ah_noise_floor;
>                rxs.signal = rxs.noise + rs.rs_rssi;
> -               rxs.qual = rs.rs_rssi * 100 / 64;
> +
> +               /* An rssi of 35 indicates you should be able use
> +                * 54 Mbps reliably. A more elaborate scheme can be used
> +                * here but it requires a map of SNR/throughput for each
> +                * possible mode used */
> +               rxs.qual = rs.rs_rssi * 100 / 35;
> +
> +               /* rssi can be more than 35 though, anything above that
> +                * should be considered at 100% */
> +               if (rxs.qual > 100)
> +                       rxs.qual = 100;
>
>                rxs.antenna = rs.rs_antenna;
>                rxs.rate_idx = ath5k_hw_to_driver_rix(sc, rs.rs_rate);

Acked-by: Nick Kossifidis <mickflemm@gmail.com>



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
