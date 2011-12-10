Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36063 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab1LJPdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 10:33:32 -0500
Received: by iaeh11 with SMTP id h11so354666iae.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2011 07:33:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323523783-536-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1323523783-536-1-git-send-email-rmanohar@qca.qualcomm.com>
Date: Sat, 10 Dec 2011 07:33:31 -0800
Message-ID: <CAMcMvsg6MAYqk8=-T8VXHqKQ6-OXdUF0yf1RJ7MDuJ=QWuQ9_A@mail.gmail.com> (sfid-20111210_163335_381745_2CC5186F)
Subject: Re: [PATCH] ath9k: fix max phy rate at rate control init
From: Paul Stewart <pstew@google.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rajkumar,

On Sat, Dec 10, 2011 at 5:29 AM, Rajkumar Manoharan
<rmanohar@qca.qualcomm.com> wrote:
> The stations always chooses 1Mbps for all trasmitting frames,
> whenever the AP is configured to lock the supported rates.
> As the max phy rate is always set with the 4th from highest phy rate,
> this assumption might be wrong if we have less than that. Fix that.
>
> Cc: stable@kernel.org
> Cc: Paul Stewart <pstew@google.com>
> Reported-by: Ajay Gummalla <agummalla@google.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/rc.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
> index 888abc2..528d5f3 100644
> --- a/drivers/net/wireless/ath/ath9k/rc.c
> +++ b/drivers/net/wireless/ath/ath9k/rc.c
> @@ -1271,7 +1271,9 @@ static void ath_rc_init(struct ath_softc *sc,
>
>        ath_rc_priv->max_valid_rate = k;
>        ath_rc_sort_validrates(rate_table, ath_rc_priv);
> -       ath_rc_priv->rate_max_phy = ath_rc_priv->valid_rate_index[k-4];
> +       ath_rc_priv->rate_max_phy = (k > 4) ?
> +                                       ath_rc_priv->valid_rate_index[k-4] :
> +                                       ath_rc_priv->valid_rate_index[k-1];

Is k guaranteed > 1 here?  Some test equipment export only one rate so
we lock in to a single rate. I'm not sure how this would factor into
the k value here.

>        ath_rc_priv->rate_table = rate_table;
>
>        ath_dbg(common, ATH_DBG_CONFIG,
> --
> 1.7.8
>
