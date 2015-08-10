Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34980 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbbHJGsP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 02:48:15 -0400
Received: by iodd187 with SMTP id d187so160605601iod.2
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2015 23:48:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1439186304-3480-6-git-send-email-tony.cho@atmel.com>
References: <1439186304-3480-1-git-send-email-tony.cho@atmel.com> <1439186304-3480-6-git-send-email-tony.cho@atmel.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 10 Aug 2015 16:47:55 +1000
Message-ID: <CAGRGNgWVUM-4tTTdAsVfrD75YzUx=RPgQUnNMYqvLxcV9rJwnQ@mail.gmail.com> (sfid-20150810_084818_852535_4E59B276)
Subject: Re: [PATCH 5/5] staging: wilc1000: use id value as argument
To: Tony Cho <tony.cho@atmel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>, austin.shin@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com, jude.lee@atmel.com,
	robin.hwang@atmel.com, Nicolas.FERRE@atmel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tony and Johnny,

On Mon, Aug 10, 2015 at 3:58 PM, Tony Cho <tony.cho@atmel.com> wrote:
> From: Johnny Kim <johnny.kim@atmel.com>
>
> The driver communicates with the chipset via the address of handlers
> to distinguish async data frame. The SendConfigPkt function gets the
> pointer address indicating the handlers as the last argument, but this
> requires redundant typecasting and does not support the 64 bit machine.
>
> This patch adds the function which assigns ID values instead of pointer
> representing the driver handler to the address and then uses the ID
> instead of pointer as the last argument of SendConfigPkt. The driver
> also gets the handler's address from the ID in the data frame when it
> receives them.

Excellent work!

A couple of minor questions:

> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index c4e27c7..5a0277f 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -616,7 +680,8 @@ static s32 Handle_SetChannel(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetChan *pst
>
>         PRINT_D(HOSTINF_DBG, "Setting channel\n");
>         /*Sending Cfg*/
> -       s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
> +       s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
> +                                get_id_from_handler(pstrWFIDrv));

Would it make sense to call get_id_from_handler() inside
SendConfigPkt() instead?

>         if (s32Error) {
>                 PRINT_ER("Failed to set channel\n");
>                 WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
> @@ -653,7 +718,8 @@ static s32 Handle_SetWfiDrvHandler(tstrHostIfSetDrvHandler *pstrHostIfSetDrvHand
>
>         /*Sending Cfg*/
>
> -       s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
> +       s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,
> +                                pstrHostIfSetDrvHandler->u32Address);

Is this correct?

>
>
>         if ((pstrHostIfSetDrvHandler->u32Address) == (u32)NULL)
> @@ -6772,11 +6888,11 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
>  {
>         s32 s32Error = WILC_SUCCESS;
>         tstrHostIFmsg strHostIFmsg;
> -       u32 drvHandler;
> +       u32 id;
>         tstrWILC_WFIDrv *pstrWFIDrv = NULL;
>
> -       drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
> -       pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
> +       id = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));

Would be32_to_cpu() or something like that be able to help you do this?

> +       pstrWFIDrv = get_handler_from_id(id);
>
>
>

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
