Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:46472 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752140AbdJ3NeN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 09:34:13 -0400
MIME-Version: 1.0
In-Reply-To: <f50c8edf-834d-9003-5a3c-dc83ec4016ce@users.sourceforge.net>
References: <dc2b8a7c-b4a9-2f92-12b4-a1d0d6911d7c@users.sourceforge.net> <f50c8edf-834d-9003-5a3c-dc83ec4016ce@users.sourceforge.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 31 Oct 2017 00:33:51 +1100
Message-ID: <CAGRGNgUEFpva3ct-idAzip97eVgoDDTeEArAPcjvf90VSORA2g@mail.gmail.com> (sfid-20171030_143511_518967_AE500A0B)
Subject: Re: [PATCH 4/5] wlcore: Use common error handling code in wlcore_set_beacon_template()
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

On Mon, Oct 30, 2017 at 7:14 AM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 29 Oct 2017 20:16:22 +0100
>
> Adjust jump targets so that a bit of exception handling can be better
> reused at the end of this function.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

However,

> ---
>  drivers/net/wireless/ti/wlcore/main.c | 18 +++++++-----------
>  1 file changed, 7 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index 0365b5e40a8d..12a9d6509382 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -4081,9 +4078,8 @@ static int wlcore_set_beacon_template(struct wl1271 *wl,
>                                               beacon->data,
>                                               beacon->len, 0,
>                                               min_rate);
> -end_bcn:
> +free_skb:

Why rename the label?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
