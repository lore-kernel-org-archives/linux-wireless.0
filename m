Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f193.google.com ([209.85.213.193]:33075 "EHLO
	mail-ig0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbcA2Aza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 19:55:30 -0500
Received: by mail-ig0-f193.google.com with SMTP id h5so2997775igh.0
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jan 2016 16:55:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1453965226-6158-8-git-send-email-leo.kim@atmel.com>
References: <1453965226-6158-1-git-send-email-leo.kim@atmel.com> <1453965226-6158-8-git-send-email-leo.kim@atmel.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 29 Jan 2016 11:55:10 +1100
Message-ID: <CAGRGNgXxcZBzOkJa++pAHWZLAZs9wrD48cEiGhzKatmzd+usRw@mail.gmail.com> (sfid-20160129_015534_401284_D6D1574B)
Subject: Re: [PATCH 08/12] staging: wilc1000: rename variable s32Error
To: Leo Kim <leo.kim@atmel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <Chris.Park@atmel.com>, adham.abozaeid@atmel.com,
	Nicolas.FERRE@atmel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Leo,

On Thu, Jan 28, 2016 at 6:13 PM, Leo Kim <leo.kim@atmel.com> wrote:
> This patch renames variable s32Error to result
> to avoid CamelCase naming convention.
> Also, remove the unused variable s32Error and replace with direct return.
>
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
> index 2a4e324..88e5661 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.c
> +++ b/drivers/staging/wilc1000/coreconfigurator.c
> @@ -356,30 +356,29 @@ s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info)
>
>  s32 wilc_dealloc_network_info(tstrNetworkInfo *pstrNetworkInfo)
>  {
> -       s32 s32Error = 0;
> +       s32 result = 0;
>
>         if (pstrNetworkInfo) {
>                 if (pstrNetworkInfo->pu8IEs) {
>                         kfree(pstrNetworkInfo->pu8IEs);
>                         pstrNetworkInfo->pu8IEs = NULL;

I'm not sure it's necessary to set this to NULL here.

>                 } else {
> -                       s32Error = -EFAULT;
> +                       result = -EFAULT;
>                 }
>
>                 kfree(pstrNetworkInfo);
>                 pstrNetworkInfo = NULL;

Or this to NULL here.

Also, is the return value from this function actually checked? kfree()
can have NULL passed to it.

If the return value isn't checked, this entire function could be simplified to:

- - - - -

if (pstrNetworkInfo) {
    kfree(pstrNetworkInfo->pu8IEs);
    kfree(pstrNetworkInfo);
}

return 0;

- - - - -

Also, when tstrNetworkInfo structs are allocated, wouldn't the
allocating function fail if ->pu8IEs is NULL?

>         } else {
> -               s32Error = -EFAULT;
> +               result = -EFAULT;
>         }
>
> -       return s32Error;
> +       return result;
>  }
>
>  s32 wilc_parse_assoc_resp_info(u8 *pu8Buffer, u32 u32BufferLen,
>                                tstrConnectRespInfo **ppstrConnectRespInfo)
>  {
> -       s32 s32Error = 0;
>         tstrConnectRespInfo *pstrConnectRespInfo = NULL;
>         u16 u16AssocRespLen = 0;
>         u8 *pu8IEs = NULL;
> @@ -408,27 +407,27 @@ s32 wilc_parse_assoc_resp_info(u8 *pu8Buffer, u32 u32BufferLen,
>
>         *ppstrConnectRespInfo = pstrConnectRespInfo;
>
> -       return s32Error;
> +       return 0;
>  }
>
>  s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *pstrConnectRespInfo)
>  {
> -       s32 s32Error = 0;
> +       s32 result = 0;

All the comments above apply to this function as well.

>
>         if (pstrConnectRespInfo) {
>                 if (pstrConnectRespInfo->pu8RespIEs) {
>                         kfree(pstrConnectRespInfo->pu8RespIEs);
>                         pstrConnectRespInfo->pu8RespIEs = NULL;
>                 } else {
> -                       s32Error = -EFAULT;
> +                       result = -EFAULT;
>                 }
>
>                 kfree(pstrConnectRespInfo);
>                 pstrConnectRespInfo = NULL;
>
>         } else {
> -               s32Error = -EFAULT;
> +               result = -EFAULT;
>         }
>
> -       return s32Error;
> +       return result;
>  }

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
