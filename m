Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:53408 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbaFLHfs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2014 03:35:48 -0400
Received: by mail-oa0-f52.google.com with SMTP id j17so942347oag.11
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2014 00:35:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1402558118-25777-1-git-send-email-zajec5@gmail.com>
References: <1402558118-25777-1-git-send-email-zajec5@gmail.com>
Date: Thu, 12 Jun 2014 10:35:47 +0300
Message-ID: <CANUX_P1RA6PUDiFrT0wta57BNW9oRVAkNstT5ieiBjA9sHWnfw@mail.gmail.com> (sfid-20140612_093553_327663_4D3AA052)
Subject: Re: [RFC: which stable kernels?] b43: fix frequency reported on G-PHY
 with /new/ firmware
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev@lists.infradead.org, Aaro Koskinen <aaro.koskinen@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> ---
> This bug was there for years, however didn't cause any problems. It was
> exposed recently by the 3.15 release by the:
>
> commit 3afc2167f60a327a2c1e1e2600ef209a3c2b75b7
> Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Date:   Tue Mar 4 16:50:13 2014 +0200
>
>     cfg80211/mac80211: ignore signal if the frame was heard on wrong channel
>
> Should we mark it for stable for 3.15 only? Or all olders kernels as well?

Up to you - my patch is in 3.15 only I think.

> ---
>  drivers/net/wireless/b43/xmit.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
> index 4f38f19..6e6ef3f 100644
> --- a/drivers/net/wireless/b43/xmit.c
> +++ b/drivers/net/wireless/b43/xmit.c
> @@ -811,9 +811,13 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
>                 break;
>         case B43_PHYTYPE_G:
>                 status.band = IEEE80211_BAND_2GHZ;
> -               /* chanid is the radio channel cookie value as used
> -                * to tune the radio. */
> -               status.freq = chanid + 2400;
> +               /* Somewhere between 478.104 and 508.1084 firmware for G-PHY
> +                * has been modified to be compatible with N-PHY and others.
> +                */
> +               if (dev->fw.rev >= 508)
> +                       status.freq = ieee80211_channel_to_frequency(chanid, status.band);
> +               else
> +                       status.freq = chanid + 2400;
>                 break;
>         case B43_PHYTYPE_N:
>         case B43_PHYTYPE_LP:
> --
> 1.8.4.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
