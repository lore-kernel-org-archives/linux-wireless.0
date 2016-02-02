Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f195.google.com ([209.85.213.195]:33688 "EHLO
	mail-ig0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbcBBXNJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 18:13:09 -0500
Received: by mail-ig0-f195.google.com with SMTP id ks5so1576628igb.0
        for <linux-wireless@vger.kernel.org>; Tue, 02 Feb 2016 15:13:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1454414556-9822-2-git-send-email-leo.kim@atmel.com>
References: <1454414556-9822-1-git-send-email-leo.kim@atmel.com> <1454414556-9822-2-git-send-email-leo.kim@atmel.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 3 Feb 2016 10:12:49 +1100
Message-ID: <CAGRGNgXsB+hqX=u74vSTazc6jDdR50Kf+H-gT4au3og7kWD_Wg@mail.gmail.com> (sfid-20160203_001313_932648_199B6E4E)
Subject: Re: [PATCH 02/26] staging: wilc1000: removes function 'wilc_dealloc_assoc_resp_info()'
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
> This patch removes function wilc_dealloc_assoc_resp_info()'.
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
> index 81dd22e..c86278d 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.c
> +++ b/drivers/staging/wilc1000/coreconfigurator.c
> @@ -386,25 +386,3 @@ s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
>
>         return 0;
>  }
> -
> -s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *connect_resp_info)
> -{
> -       s32 result = 0;
> -
> -       if (connect_resp_info) {
> -               if (connect_resp_info->pu8RespIEs) {
> -                       kfree(connect_resp_info->pu8RespIEs);
> -                       connect_resp_info->pu8RespIEs = NULL;
> -               } else {
> -                       result = -EFAULT;
> -               }
> -
> -               kfree(connect_resp_info);
> -               connect_resp_info = NULL;
> -
> -       } else {
> -               result = -EFAULT;
> -       }
> -
> -       return result;
> -}
> diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
> index 23775e4..d42f47c 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.h
> +++ b/drivers/staging/wilc1000/coreconfigurator.h
> @@ -123,7 +123,6 @@ typedef struct {
>  s32 wilc_parse_network_info(u8 *msg_buffer, tstrNetworkInfo **ret_network_info);
>  s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
>                                tstrConnectRespInfo **ret_connect_resp_info);
> -s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *connect_resp_info);
>  void wilc_scan_complete_received(struct wilc *wilc, u8 *pu8Buffer,
>                                  u32 u32Length);
>  void wilc_network_info_received(struct wilc *wilc, u8 *pu8Buffer,
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 3ce3a7c..15c266b 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -1505,8 +1505,8 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
>                                                 }
>
>                                                 if (pstrConnectRespInfo) {
> -                                                       wilc_dealloc_assoc_resp_info(pstrConnectRespInfo);
> -                                                       pstrConnectRespInfo = NULL;
> +                                                       kfree(pstrConnectRespInfo->pu8RespIEs);
> +                                                       kfree(pstrConnectRespInfo);
>                                                 }
>                                         }
>                                 }
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
