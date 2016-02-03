Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34900 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbcBCEAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 23:00:15 -0500
Received: by mail-io0-f194.google.com with SMTP id m139so1861666ioe.2
        for <linux-wireless@vger.kernel.org>; Tue, 02 Feb 2016 20:00:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
References: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 3 Feb 2016 14:59:55 +1100
Message-ID: <CAGRGNgW0p-7gULRNyYX9A_hDNvQPzAzg2y3GG1CRYxBsKcmL9w@mail.gmail.com> (sfid-20160203_050021_114971_2123D878)
Subject: Re: [PATCH 01/26] staging: wilc1000: removes function 'wilc_dealloc_network_info()'
To: Leo Kim <leo.kim@atmel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <Chris.Park@atmel.com>,
	"Abozaeid, Adham" <adham.abozaeid@atmel.com>,
	"Ferre, Nicolas" <Nicolas.FERRE@atmel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Leo,

On Tue, Feb 2, 2016 at 11:02 PM, Leo Kim <leo.kim@atmel.com> wrote:
> This patch removes function 'wilc_dealloc_network_info()'.
> Does not need this function which only free memory.
> Therefore, this function is removed and changed directly with kfree.
>
> Signed-off-by: Leo Kim <leo.kim@atmel.com>

Nice work!

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

> ---
>  drivers/staging/wilc1000/coreconfigurator.c | 22 ----------------------
>  drivers/staging/wilc1000/coreconfigurator.h |  1 -
>  drivers/staging/wilc1000/host_interface.c   |  4 ++--
>  3 files changed, 2 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
> index 11e3ce0..81dd22e 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.c
> +++ b/drivers/staging/wilc1000/coreconfigurator.c
> @@ -353,28 +353,6 @@ s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info)
>         return 0;
>  }
>
> -s32 wilc_dealloc_network_info(tstrNetworkInfo *network_info)
> -{
> -       s32 result = 0;
> -
> -       if (network_info) {
> -               if (network_info->pu8IEs) {
> -                       kfree(network_info->pu8IEs);
> -                       network_info->pu8IEs = NULL;
> -               } else {
> -                       result = -EFAULT;
> -               }
> -
> -               kfree(network_info);
> -               network_info = NULL;
> -
> -       } else {
> -               result = -EFAULT;
> -       }
> -
> -       return result;
> -}
> -
>  s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
>                                tstrConnectRespInfo **ret_connect_resp_info)
>  {
> diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
> index d801e58..23775e4 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.h
> +++ b/drivers/staging/wilc1000/coreconfigurator.h
> @@ -121,7 +121,6 @@ typedef struct {
>  } tstrDisconnectNotifInfo;
>
>  s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info);
> -s32 wilc_dealloc_network_info(tstrNetworkInfo *network_info);
>  s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
>                                tstrConnectRespInfo **ret_connect_resp_info);
>  s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *connect_resp_info);
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index e6a6a03..3ce3a7c 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -1414,8 +1414,8 @@ done:
>         pstrRcvdNetworkInfo->buffer = NULL;
>
>         if (pstrNetworkInfo) {
> -               wilc_dealloc_network_info(pstrNetworkInfo);
> -               pstrNetworkInfo = NULL;
> +               kfree(pstrNetworkInfo->pu8IEs);
> +               kfree(pstrNetworkInfo);
>         }
>
>         return result;
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
