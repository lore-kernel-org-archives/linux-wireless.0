Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:34041 "EHLO
	mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbbJECtL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 22:49:11 -0400
Received: by vkat63 with SMTP id t63so88181789vka.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2015 19:49:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKV=isvdAcmXO6Zzk=V=Vww=SCZeEaWAXVT1VaFkMt_T36TivQ@mail.gmail.com>
References: <1444010843-16796-1-git-send-email-chaehyun.lim@gmail.com>
	<1444010843-16796-3-git-send-email-chaehyun.lim@gmail.com>
	<CAGRGNgVkMaXtPA6nRY8-hcCYHdvX6pHoswtMFi1TPemHPMpJzA@mail.gmail.com>
	<CAKV=isvdAcmXO6Zzk=V=Vww=SCZeEaWAXVT1VaFkMt_T36TivQ@mail.gmail.com>
Date: Mon, 5 Oct 2015 11:49:10 +0900
Message-ID: <CAKV=issxcDLuA=+--o0-GdbRu7CRNuMjvN72=8YL9x4yc+TA8g@mail.gmail.com> (sfid-20151005_044918_362768_D1139471)
Subject: Re: [PATCH 3/3] staging: wilc1000: return error code direclty in host_int_wait_msg_queue_idle
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, glen.lee@atmel.com,
	leo.kim@atmel.com, linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Greg

Please ignore this patch.

Thanks
Chaehyun Lim

On Mon, Oct 5, 2015 at 11:48 AM, Chaehyun Lim <chaehyun.lim@gmail.com> wrote:
> On Mon, Oct 5, 2015 at 11:41 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
>> Hi Chaehyun,
>>
>> On Mon, Oct 5, 2015 at 1:07 PM, Chaehyun Lim <chaehyun.lim@gmail.com> wrote:
>>> There is no need to pass the error code to the variable 'result'.
>>> Just return the error directly when error occurs.
>>> Return 0 at the end of this function when error is not happened.
>>
>> We can't do this.
>>
>>> Suggested-by: Julian Calaby <julian.calaby@gmail.com>
>>> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
>>> ---
>>>  drivers/staging/wilc1000/host_interface.c | 6 +++---
>>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
>>> index b1aa7dd..427fbaa 100644
>>> --- a/drivers/staging/wilc1000/host_interface.c
>>> +++ b/drivers/staging/wilc1000/host_interface.c
>>> @@ -5343,7 +5343,7 @@ int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *wfi_drv, u8 channel)
>>>
>>>  int host_int_wait_msg_queue_idle(void)
>>>  {
>>> -       int result = 0;
>>> +       int result;
>>>
>>>         struct host_if_msg msg;
>>>
>>> @@ -5354,13 +5354,13 @@ int host_int_wait_msg_queue_idle(void)
>>>         result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
>>>         if (result) {
>>>                 PRINT_ER("wilc mq send fail\n");
>>> -               result = -EINVAL;
>>> +               return -EINVAL;
>>
>> Returning here means that we don't call down:
>>
>>>         }
>>>
>>>         /* wait untill MSG Q is empty */
>>>         down(&hWaitResponse);
>>
>> here.
>>
>> Sorry for the confusion.
>>
>> Thanks,
>>
>
> Thank you for your comment. I also did not see what you're indicating.
>
> regards
> Chaehyun Lim
>> --
>> Julian Calaby
>>
>> Email: julian.calaby@gmail.com
>> Profile: http://www.google.com/profiles/julian.calaby/
