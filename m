Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38517 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab2JDS6U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 14:58:20 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so801335pad.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Oct 2012 11:58:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121003232034.GA19388@localhost.arig>
References: <20121003232034.GA19388@localhost.arig>
Date: Thu, 4 Oct 2012 20:58:19 +0200
Message-ID: <CAOZOX0UWmtCddTB+UNQ+tDRE2jGzcZ0TE7tgQD4LBGxBOKCyBQ@mail.gmail.com> (sfid-20121004_205825_861122_93DE1C08)
Subject: Re: [PATCH] rt2x00/rt3352: Fix lnagain assignment to use register 66.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Daniel Golle <dgolle@allnet.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 4, 2012 at 1:20 AM, Daniel Golle <dgolle@allnet.de> wrote:
> This should be register 66 instead of 62.
> (probably happened by copy&past'ing from the lines below)
>
> Signed-off-by: Daniel Golle <dgolle@allnet.de>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 540c94f..01dc889 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -2252,9 +2252,9 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
>          */
>         if (rt2x00_rt(rt2x00dev, RT3352)) {
>                 rt2800_bbp_write(rt2x00dev, 27, 0x0);
> -               rt2800_bbp_write(rt2x00dev, 62, 0x26 + rt2x00dev->lna_gain);
> +               rt2800_bbp_write(rt2x00dev, 66, 0x26 + rt2x00dev->lna_gain);
>                 rt2800_bbp_write(rt2x00dev, 27, 0x20);
> -               rt2800_bbp_write(rt2x00dev, 62, 0x26 + rt2x00dev->lna_gain);
> +               rt2800_bbp_write(rt2x00dev, 66, 0x26 + rt2x00dev->lna_gain);
>         } else {
>                 rt2800_bbp_write(rt2x00dev, 62, 0x37 - rt2x00dev->lna_gain);
>                 rt2800_bbp_write(rt2x00dev, 63, 0x37 - rt2x00dev->lna_gain);
> --
> 1.7.12.2
>
