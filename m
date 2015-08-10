Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:11159 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbbHJHxl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 03:53:41 -0400
Message-ID: <55C85867.90903@atmel.com> (sfid-20150810_095344_715911_5B3097C0)
Date: Mon, 10 Aug 2015 16:53:11 +0900
From: Johnny Kim <johnny.kim@atmel.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>,
	Tony Cho <tony.cho@atmel.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Chris Park <chris.park@atmel.com>,
	"Rachel Kim" <rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<glen.lee@atmel.com>, <leo.kim@atmel.com>, <jude.lee@atmel.com>,
	<robin.hwang@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: Re: [PATCH 5/5] staging: wilc1000: use id value as argument
References: <1439186304-3480-1-git-send-email-tony.cho@atmel.com> <1439186304-3480-6-git-send-email-tony.cho@atmel.com> <CAGRGNgWVUM-4tTTdAsVfrD75YzUx=RPgQUnNMYqvLxcV9rJwnQ@mail.gmail.com>
In-Reply-To: <CAGRGNgWVUM-4tTTdAsVfrD75YzUx=RPgQUnNMYqvLxcV9rJwnQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Julian.

On 2015년 08월 10일 15:47, Julian Calaby wrote:
> Hi Tony and Johnny,
>
> On Mon, Aug 10, 2015 at 3:58 PM, Tony Cho <tony.cho@atmel.com> wrote:
>> From: Johnny Kim <johnny.kim@atmel.com>
>>
>> The driver communicates with the chipset via the address of handlers
>> to distinguish async data frame. The SendConfigPkt function gets the
>> pointer address indicating the handlers as the last argument, but this
>> requires redundant typecasting and does not support the 64 bit machine.
>>
>> This patch adds the function which assigns ID values instead of pointer
>> representing the driver handler to the address and then uses the ID
>> instead of pointer as the last argument of SendConfigPkt. The driver
>> also gets the handler's address from the ID in the data frame when it
>> receives them.
> Excellent work!
>
> A couple of minor questions:
>
>> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
>> index c4e27c7..5a0277f 100644
>> --- a/drivers/staging/wilc1000/host_interface.c
>> +++ b/drivers/staging/wilc1000/host_interface.c
>> @@ -616,7 +680,8 @@ static s32 Handle_SetChannel(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetChan *pst
>>
>>          PRINT_D(HOSTINF_DBG, "Setting channel\n");
>>          /*Sending Cfg*/
>> -       s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
>> +       s32Error = (SET_CFG, &strWID, 1, true,
>> +                                get_id_from_handler(pstrWFIDrv));
> Would it make sense to call get_id_from_handler() inside
> SendConfigPkt() instead?
SendConfigPkt function can't be aware of tstrWILC_WFIDrv type
because SendConfigPkt is defined before tstrWILC_WFIDrv.

>>          if (s32Error) {
>>                  PRINT_ER("Failed to set channel\n");
>>                  WILC_ERRORREPORT(s32Error, WILC_INVALID_STATE);
>> @@ -653,7 +718,8 @@ static s32 Handle_SetWfiDrvHandler(tstrHostIfSetDrvHandler *pstrHostIfSetDrvHand
>>
>>          /*Sending Cfg*/
>>
>> -       s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
>> +       s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true,host_int_set_wfi_drv_handler
>> +                                pstrHostIfSetDrvHandler->u32Address);
> Is this correct?
pstrHostIfSetDrvHandler->u32Address value which is input as argument 
isn't pointer address  but ID value.
The value was filled in host_int_set_wfi_drv_handler function.

>>
>>          if ((pstrHostIfSetDrvHandler->u32Address) == (u32)NULL)
>> @@ -6772,11 +6888,11 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
>>   {
>>          s32 s32Error = WILC_SUCCESS;
>>          tstrHostIFmsg strHostIFmsg;
>> -       u32 drvHandler;
>> +       u32 id;
>>          tstrWILC_WFIDrv *pstrWFIDrv = NULL;
>>
>> -       drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
>> -       pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
>> +       id = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
> Would be32_to_cpu() or something like that be able to help you do this?
Thank for your comment. I will fix it on another subject.

>> +       pstrWFIDrv = get_handler_from_id(id);
>>
>>
>>
> Thanks,
>

