Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:37770 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbbGNCc0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2015 22:32:26 -0400
Received: by igbpg9 with SMTP id pg9so2639717igb.0
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2015 19:32:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1436838521-8200-1-git-send-email-chaehyun.lim@gmail.com>
References: <1436838521-8200-1-git-send-email-chaehyun.lim@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 14 Jul 2015 12:32:06 +1000
Message-ID: <CAGRGNgVaA0gMmnTxEFuBKZSpHV+mWb8rNrztYcxw=1YdNdpBiQ@mail.gmail.com> (sfid-20150714_043229_469213_6654B66D)
Subject: Re: [PATCH 1/2] staging: wilc1000: fix uninitialized variablie warning
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chaehyun,

On Tue, Jul 14, 2015 at 11:48 AM, Chaehyun Lim <chaehyun.lim@gmail.com> wrote:
> When building this driver, I got a warning as below:
>
> host_interface.c: In function ‘host_int_add_beacon’:
> host_interface.c:7116:16: warning: ‘*((void *)&strHostIFmsg+8).pu8Head’ may be used
> uninitialized in this function [-Wmaybe-uninitialized]
>
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index c089e73..ca97b70 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -7131,8 +7131,11 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
>         pstrSetBeaconParam->u32DTIMPeriod = u32DTIMPeriod;
>         pstrSetBeaconParam->u32HeadLen = u32HeadLen;
>         pstrSetBeaconParam->pu8Head = (u8 *)WILC_MALLOC(u32HeadLen);
> -       if (pstrSetBeaconParam->pu8Head == NULL)
> -               WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
> +       if (pstrSetBeaconParam->pu8Head == NULL) {
> +               PRINT_ER("Failed to allocated memory\n");
> +               s32Error = WILC_NO_MEM;
> +               goto _fail_;

Why not just return WILC_NO_MEM here instead of jumping to the return below?

> +       }
>         WILC_memcpy(pstrSetBeaconParam->pu8Head, pu8Head, u32HeadLen);
>         pstrSetBeaconParam->u32TailLen = u32TailLen;
>
> @@ -7159,6 +7162,7 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
>                         WILC_FREE(pstrSetBeaconParam->pu8Tail);
>         }
>
> +_fail_:
>         return s32Error;
>
>  }

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
