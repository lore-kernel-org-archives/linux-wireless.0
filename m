Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:47118 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab1DKFa3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 01:30:29 -0400
MIME-Version: 1.0
In-Reply-To: <4DA20083.8050208@gmail.com>
References: <4DA20083.8050208@gmail.com>
Date: Mon, 11 Apr 2011 11:00:28 +0530
Message-ID: <BANLkTimMtN7swpCnwK-hqHqO3jO8oPq-sQ@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH 2/2] ath9k: index out of bounds
From: Mohammed Shafi <shafi.ath9k@gmail.com>
To: roel <roel.kluin@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 11, 2011 at 12:39 AM, roel <roel.kluin@gmail.com> wrote:
> Check whether index is within bounds before testing the element
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/rc.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
> index 4c0d36a..1809409 100644
> --- a/drivers/net/wireless/ath/ath9k/rc.c
> +++ b/drivers/net/wireless/ath/ath9k/rc.c
> @@ -1092,8 +1092,7 @@ static int ath_rc_get_rateindex(const struct ath_rate_table *rate_table,
>        if (!(rate->flags & IEEE80211_TX_RC_MCS))
>                return rate->idx;
>
> -       while (rate->idx > mcs_rix_off[i] &&
> -              i < ARRAY_SIZE(mcs_rix_off)) {
> +       while (i < ARRAY_SIZE(mcs_rix_off) && rate->idx > mcs_rix_off[i]) {
>                rix++; i++;
>        }
>
hi,
This looks correct. with the  current ath9k rate control, the MCS
index never exceeded 23 and thats why the out of bounds problem never
came.
thanks,
shafi
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>
