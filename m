Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39379 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757374Ab2JZIql (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 04:46:41 -0400
Received: by mail-vb0-f46.google.com with SMTP id ff1so2850219vbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2012 01:46:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121025075138.GA2330@redhat.com>
References: <20121025075138.GA2330@redhat.com>
Date: Fri, 26 Oct 2012 10:46:40 +0200
Message-ID: <CAOZOX0W0E4YdD6C88muxpnYdYwLw1vLgtWiZsMoWT70c5=ZXVA@mail.gmail.com> (sfid-20121026_104648_072775_4937D0D1)
Subject: Re: [PATCH] rt2800: validate step value for temperature compensation
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Pavel Lucik <pavel.lucik@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 25, 2012 at 9:51 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Some hardware has correct (!= 0xff) value of tssi_bounds[4] in the
> EEPROM, but step is equal to 0xff. This results on ridiculous delta
> calculations and completely broke TX power settings.
>
> Reported-and-tested-by: Pavel Lucik <pavel.lucik@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 3bc206d..c0441a7 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -2449,7 +2449,7 @@ static int rt2800_get_gain_calibration_delta(struct rt2x00_dev *rt2x00dev)
>         /*
>          * Check if temperature compensation is supported.
>          */
> -       if (tssi_bounds[4] == 0xff)
> +       if (tssi_bounds[4] == 0xff || step == 0xff)
>                 return 0;
>
>         /*
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
