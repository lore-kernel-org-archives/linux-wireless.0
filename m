Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:52696 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932626Ab2JUWUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2012 18:20:52 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so641228eaa.19
        for <linux-wireless@vger.kernel.org>; Sun, 21 Oct 2012 15:20:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201210202000.42173.chunkeey@googlemail.com>
References: <201210202000.42173.chunkeey@googlemail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 22 Oct 2012 09:20:30 +1100
Message-ID: <CAGRGNgW2pBq54zbcX85ALTxFeXsv5fFcqhPo-Uzz43_zsZ=9eg@mail.gmail.com> (sfid-20121022_002105_854625_1A26CA36)
Subject: Re: [PATCH] carl9170: split up carl9170_handle_mpdu
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	jlopex@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

On Sun, Oct 21, 2012 at 5:00 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
> index 9cd93f1..887a4ae 100644
> --- a/drivers/net/wireless/ath/carl9170/rx.c
> +++ b/drivers/net/wireless/ath/carl9170/rx.c
> @@ -660,6 +660,38 @@ static bool carl9170_ampdu_check(struct ar9170 *ar, u8 *buf, u8 ms,
>         return false;
>  }
>
> +static int carl9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len,
> +                               struct ieee80211_rx_status *status)
> +{
> +       struct sk_buff *skb;
> +       int err = 0;

Personally, I hate the style of error handling where you have an
explicit variable for a return value

> +
> +       /* (driver) frame trap handler
> +        *
> +        * Because power-saving mode handing has to be implemented by
> +        * the driver/firmware. We have to check each incoming beacon
> +        * from the associated AP, if there's new data for us (either
> +        * broadcast/multicast or unicast) we have to react quickly.
> +        *
> +        * So, if you have you want to add additional frame trap
> +        * handlers, this would be the perfect place!
> +        */
> +
> +       carl9170_ps_beacon(ar, buf, len);
> +
> +       carl9170_ba_check(ar, buf, len);
> +
> +       skb = carl9170_rx_copy_data(buf, len);
> +       if (skb) {
> +               memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
> +               ieee80211_rx(ar->hw, skb);
> +       } else {
> +               err = -ENOMEM;

and then only set it

> +       }
> +
> +       return err;

immediately before you return it.

> +}
> +

That said, this is my personal preference on the matter - however that
style does make the "err" variable somewhat unnecessary as it's only
used once. (yes, gcc will optimise it away, but that's not the point)

If you eliminated it, everything from if (skb) { on could be replaced by:

    if (!skb)
        return -ENOMEM;

    memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
    ieee80211_rx(ar->hw, skb);

    return 0;
}

which, IMHO, is much cleaner.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
