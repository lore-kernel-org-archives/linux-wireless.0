Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33868 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab2BRMXU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Feb 2012 07:23:20 -0500
Received: by vbjk17 with SMTP id k17so2782717vbj.19
        for <linux-wireless@vger.kernel.org>; Sat, 18 Feb 2012 04:23:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329421499-10237-1-git-send-email-juhosg@openwrt.org>
References: <1329421499-10237-1-git-send-email-juhosg@openwrt.org>
Date: Sat, 18 Feb 2012 13:23:20 +0100
Message-ID: <CAOZOX0U0=uufmEGS47gEiVYU6Kk-ZrsCMpatSF3RoX4P+=r29A@mail.gmail.com> (sfid-20120218_132350_537795_ABE0EC05)
Subject: Re: [PATCH] rt2x00: fix a possible NULL pointer dereference
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 16, 2012 at 8:44 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
> The 'rt2x00lib_probe_dev' function tries to
> allocate the workqueue. If the allocation
> fails, 'rt2x00_lib_remove_dev' is called on
> the error path. Because 'rt2x00dev->workqueue'
> is NULL in this case, the 'destroy_workqueue'
> call will cause a NULL pointer dereference.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index bae5b01..d62e64f 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -1232,7 +1232,8 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
>                cancel_work_sync(&rt2x00dev->rxdone_work);
>                cancel_work_sync(&rt2x00dev->txdone_work);
>        }
> -       destroy_workqueue(rt2x00dev->workqueue);
> +       if (rt2x00dev->workqueue)
> +               destroy_workqueue(rt2x00dev->workqueue);
>
>        /*
>         * Free the tx status fifo.
> --
> 1.7.2.1
>
