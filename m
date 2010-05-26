Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49485 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab0EZRxV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 13:53:21 -0400
Received: by fxm5 with SMTP id 5so4707728fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 10:53:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274895211-11438-1-git-send-email-linville@tuxdriver.com>
References: <1274895211-11438-1-git-send-email-linville@tuxdriver.com>
Date: Wed, 26 May 2010 19:53:20 +0200
Message-ID: <AANLkTilsaTZP0MkCvbfraO6YOhroq7SkTNe97_VnXgcM@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: do not shortcut rt2x00lib_config_antenna
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, gwingerde@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 26, 2010 at 7:33 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> This function was exiting early if the existing diversity settings
> were unchanged.  Unfortunately, in some cases the antenna configuration
> is not initialized at all.
>
> https://bugzilla.kernel.org/show_bug.cgi?id=14751
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00config.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
> index 098315a..14a817d 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00config.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00config.c
> @@ -124,11 +124,6 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
>         * ANTENNA_SW_DIVERSITY state to the driver.
>         * If that happens, fallback to hardware defaults,
>         * or our own default.
> -        * If diversity handling is active for a particular antenna,
> -        * we shouldn't overwrite that antenna.
> -        * The calls to rt2x00lib_config_antenna_check()
> -        * might have caused that we restore back to the already
> -        * active setting. If that has happened we can quit.
>         */
>        if (!(ant->flags & ANTENNA_RX_DIVERSITY))
>                config.rx = rt2x00lib_config_antenna_check(config.rx, def->rx);
> @@ -140,9 +135,6 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
>        else
>                config.tx = active->tx;
>
> -       if (config.rx == active->rx && config.tx == active->tx)
> -               return;
> -
>        /*
>         * Antenna setup changes require the RX to be disabled,
>         * else the changes will be ignored by the device.
> --
> 1.6.6.1
>
>
