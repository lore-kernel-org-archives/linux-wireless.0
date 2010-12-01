Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37372 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab0LAOEZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 09:04:25 -0500
Received: by wyb28 with SMTP id 28so6980784wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 06:04:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291202302-9698-1-git-send-email-helmut.schaa@googlemail.com>
References: <1291202302-9698-1-git-send-email-helmut.schaa@googlemail.com>
Date: Wed, 1 Dec 2010 19:34:23 +0530
Message-ID: <AANLkTi=_61HVmSBR-9v3ukVw-mpouoaFwYE8cpfa96wH@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Update last_tx_rate only for data frames
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 1, 2010 at 4:48 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> The last_tx_rate field was also updated for non-data frames that are
> often sent with a lower rate (for example management frames at 1 Mbps).
> This is confusing when the data rate is actually much higher.
>
> Hence, only update the last_tx_rate field with tx rate information
> gathered from the last data frames.
Hi Helmut,
            I have a doubt,ideally should not this be taken care by the driver ?
thanks,
shafi
>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
>
> Not sure if there are any reasons why somebody would like to see the "real"
> last tx rate including management frames?
>
>  net/mac80211/tx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index e694836..f753081 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -669,7 +669,7 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
>        if (txrc.reported_rate.idx < 0)
>                txrc.reported_rate = info->control.rates[0];
>
> -       if (tx->sta)
> +       if (tx->sta && ieee80211_is_data(hdr->frame_control))
>                tx->sta->last_tx_rate = txrc.reported_rate;
>
>        if (unlikely(!info->control.rates[0].count))
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
