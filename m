Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:35952 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbcBYBCM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 20:02:12 -0500
Received: by mail-ig0-f180.google.com with SMTP id xg9so3256435igb.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 17:02:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456358932-23114-4-git-send-email-afenkart@gmail.com>
References: <1456358932-23114-1-git-send-email-afenkart@gmail.com> <1456358932-23114-4-git-send-email-afenkart@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 25 Feb 2016 12:01:51 +1100
Message-ID: <CAGRGNgVSvbETDnEAs2ZMPRuRVU-BG=hyymg+qpP_hJJD2T7GgA@mail.gmail.com> (sfid-20160225_020215_938078_FA49304E)
Subject: Re: [PATCH 3/7] mwifiex: scan: simplify ternary operators using gnu extension
To: Andreas Fenkart <afenkart@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

On Thu, Feb 25, 2016 at 11:08 AM, Andreas Fenkart <afenkart@gmail.com> wrote:
> "x ? x : y" can be simplified as "x ? : y"
> https://gcc.gnu.org/onlinedocs/gcc/Conditionals.html#Conditionals
>
> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>

I'm not sure people are 100% happy with changes like these, however
they are correct, so

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

> ---
>  drivers/net/wireless/marvell/mwifiex/scan.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
> index 276382e..f612c1b 100644
> --- a/drivers/net/wireless/marvell/mwifiex/scan.c
> +++ b/drivers/net/wireless/marvell/mwifiex/scan.c
> @@ -845,14 +845,11 @@ mwifiex_config_scan(struct mwifiex_private *priv,
>                 /* Set the BSS type scan filter, use Adapter setting if
>                    unset */
>                 scan_cfg_out->bss_mode =
> -                       (user_scan_in->bss_mode ? (u8) user_scan_in->
> -                        bss_mode : (u8) adapter->scan_mode);
> +                       (u8)(user_scan_in->bss_mode ?: adapter->scan_mode);
>
>                 /* Set the number of probes to send, use Adapter setting
>                    if unset */
> -               num_probes =
> -                       (user_scan_in->num_probes ? user_scan_in->
> -                        num_probes : adapter->scan_probes);
> +               num_probes = user_scan_in->num_probes ?: adapter->scan_probes;
>
>                 /*
>                  * Set the BSSID filter to the incoming configuration,
> --
> 2.7.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
