Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:47611 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751837AbdJ3Nkm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 09:40:42 -0400
MIME-Version: 1.0
In-Reply-To: <5c4844e8-b519-888d-c772-4f925a4f2a66@users.sourceforge.net>
References: <dc2b8a7c-b4a9-2f92-12b4-a1d0d6911d7c@users.sourceforge.net> <5c4844e8-b519-888d-c772-4f925a4f2a66@users.sourceforge.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 31 Oct 2017 00:40:20 +1100
Message-ID: <CAGRGNgUt05VmCEAiZwv4y7bQz_X_8F39irsQhgfJJh+dapYEZw@mail.gmail.com> (sfid-20171030_144129_390994_175C7EA1)
Subject: Re: [PATCH 5/5] wlcore: Use common error handling code in wl1271_op_suspend()
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Eyal Reizer <eyalr@ti.com>, Iain Hunter <drhunter95@gmail.com>,
        James Minor <james.minor@ni.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Markus,

On Mon, Oct 30, 2017 at 7:16 AM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 29 Oct 2017 20:36:39 +0100
>
> Add a jump target so that a specific error message is stored only once
> at the end of this function implementation.
> Replace two calls of the macro "wl1271_warning" by goto statements.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

This patch is bogus, moving error messages around like this is just bizarre.

These are both reporting different failures, so the error messages
should be different.

> ---
>  drivers/net/wireless/ti/wlcore/main.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index 12a9d6509382..a110f61110d5 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -1732,8 +1732,7 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
>                 ret = wl1271_configure_suspend(wl, wlvif, wow);
>                 if (ret < 0) {
>                         mutex_unlock(&wl->mutex);
> -                       wl1271_warning("couldn't prepare device to suspend");

"couldn't configure device for suspend"?

> -                       return ret;
> +                       goto report_preparation_failure;
>                 }
>         }
>
> @@ -1752,10 +1751,8 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
>         wl1271_ps_elp_sleep(wl);
>         mutex_unlock(&wl->mutex);
>
> -       if (ret < 0) {
> -               wl1271_warning("couldn't prepare device to suspend");

"couldn't enable power saving"?

> -               return ret;
> -       }
> +       if (ret < 0)
> +               goto report_preparation_failure;
>
>         /* flush any remaining work */
>         wl1271_debug(DEBUG_MAC80211, "flushing remaining works");

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
