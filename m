Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vn0-f51.google.com ([209.85.216.51]:44002 "EHLO
	mail-vn0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbbGNXOJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2015 19:14:09 -0400
Received: by vnbf1 with SMTP id f1so2709514vnb.10
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2015 16:14:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150714211618.GB11675@kroah.com>
References: <1436838521-8200-1-git-send-email-chaehyun.lim@gmail.com>
	<1436838521-8200-2-git-send-email-chaehyun.lim@gmail.com>
	<20150714211618.GB11675@kroah.com>
Date: Wed, 15 Jul 2015 08:14:08 +0900
Message-ID: <CAKV=isu0C5i2Epjh51QQ3=GgDN9jqd9LDYQ0o1rO6cSBL_eVEQ@mail.gmail.com> (sfid-20150715_011833_799540_3BBF987A)
Subject: Re: [PATCH 2/2] staging: wilc1000: fix memory allocation error check
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 15, 2015 at 6:16 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Jul 14, 2015 at 10:48:41AM +0900, Chaehyun Lim wrote:
>> Remove WILC_ERRORREPORT macro. If memory allocation is failed,
>> jump to a label to return this function with WILC_NO_MEM.
>>
>> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
>> ---
>>  drivers/staging/wilc1000/host_interface.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
>> index ca97b70..f6ba7d1 100644
>> --- a/drivers/staging/wilc1000/host_interface.c
>> +++ b/drivers/staging/wilc1000/host_interface.c
>> @@ -7142,8 +7142,11 @@ s32 host_int_add_beacon(WILC_WFIDrvHandle hWFIDrv, u32 u32Interval,
>>       /* Bug 4599 : if tail length = 0 skip allocating & copying */
>>       if (u32TailLen > 0) {
>>               pstrSetBeaconParam->pu8Tail = (u8 *)WILC_MALLOC(u32TailLen);
>> -             if (pstrSetBeaconParam->pu8Tail == NULL)
>> -                     WILC_ERRORREPORT(s32Error, WILC_NO_MEM);
>> +             if (pstrSetBeaconParam->pu8Tail == NULL) {
>> +                     PRINT_ER("Failed to allocate memory\n");
>
> This message is redundant, the core already just told the user this, so
> it's not needed to tell them this again.
>
> And as an aside, the mess in WILC_MALLOC() needs to go as well, that's
> horrid, and wrong :(

Thank you for your comment. You think WILC_MALLOC() should be changed.
Could you give me a direction how this function should be changed?

thanks,
Chaehyun Lim
>
> thanks,
>
> greg k-h
