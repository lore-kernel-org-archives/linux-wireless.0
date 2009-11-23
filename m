Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:60949 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328AbZKWWSm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 17:18:42 -0500
Received: by fxm5 with SMTP id 5so5222291fxm.28
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 14:18:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1259012694-14869-2-git-send-email-gwingerde@gmail.com>
References: <1259012694-14869-1-git-send-email-gwingerde@gmail.com>
	 <1259012694-14869-2-git-send-email-gwingerde@gmail.com>
Date: Mon, 23 Nov 2009 17:18:47 -0500
Message-ID: <30353c3d0911231418s4aedc5c3vc9cfead334a02c3f@mail.gmail.com>
Subject: Re: [rt2x00-users] [PATCH v2 1/8] rt2x00: Only initialize HT on
	rt2800 devices that support it.
From: David Ellingsworth <david@identd.dyndns.org>
To: rt2x00 Users List <users@rt2x00.serialmonkey.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 23, 2009 at 4:44 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> Some RT28xx/RT30xx devices don't support 802.11n, when they are combined with
> the RF2020 chipset. Ensure that HT is disabled for these devices.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index e94f1e1..fcd0c88 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -2072,7 +2072,11 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>        /*
>         * Initialize HT information.
>         */
> -       spec->ht.ht_supported = true;
> +       if (!rt2x00_rf(chip, RF2020))
> +               spec->ht.ht_supported = true;
> +       else
> +               spec->ht.ht_supported = false;
> +

Maybe I'm the only one, but I hate conditional statements with no
meaning. Maybe this instead?

spec->ht.ht_supported = !rt2x00_rf(chip, RF2020);

>        spec->ht.cap =
>            IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
>            IEEE80211_HT_CAP_GRN_FLD |
> --
> 1.6.5.3
>
>
> _______________________________________________
> users mailing list
> users@rt2x00.serialmonkey.com
> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
>
