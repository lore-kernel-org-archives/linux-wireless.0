Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nasmtp02.atmel.com ([204.2.163.16]:49358 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753048AbbGJILf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 04:11:35 -0400
Message-ID: <559F7E1F.7070407@atmel.com> (sfid-20150710_101149_849275_6623C555)
Date: Fri, 10 Jul 2015 17:11:11 +0900
From: Johnny Kim <johnny.kim@atmel.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Chris Park <chris.park@atmel.com>,
	"Rachel Kim" <rachel.kim@atmel.com>, <tony.cho@atmel.com>,
	<Nicolas.FERRE@atmel.com>, Dean Lee <dean.lee@atmel.com>,
	<austin.shin@atmel.com>
Subject: Re: [PATCH 2/3] staging: wilc1000: wilc_wlan_cfg_get(): replace integer
 with void pointer
References: <1436507759-4546-1-git-send-email-johnny.kim@atmel.com> <1436507759-4546-3-git-send-email-johnny.kim@atmel.com> <CAGRGNgVwVKq2JQ5FypdAZvLUoYPEL+MQ=yPsMJo3onOfWin7vQ@mail.gmail.com>
In-Reply-To: <CAGRGNgVwVKq2JQ5FypdAZvLUoYPEL+MQ=yPsMJo3onOfWin7vQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 2015년 07월 10일 15:25, Julian Calaby wrote:
> Hi Johnny,
>
> On Fri, Jul 10, 2015 at 3:55 PM, Johnny Kim <johnny.kim@atmel.com> wrote:
>> Last argument of wilc_wlan_cfg_get function is actually structure's address.
>> This should be changed to be compatible with 64bit machine.
>> Because wilc_wlan_cfg_get function is mapped by function pointer later,
>> wilc_wlan_oup_t.wlan_cfg_get should be changed together.
>>
>> tstrWILC_WFIDrv structure is defined after wilc_wlan_oup_t.wlan_cfg_get
>> is defined. So, this patch changes the argument to void type pointer.
> Why not add a patch moving the structure definition before
> wilc_wlan_oup_t.wlan_cfg_get is defined?
Current patch focus on accessing 64bit address rightly.
The define order you and I mentioned should be repaired with another subject
because of complexity among files.
>> Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
>> ---
>>   drivers/staging/wilc1000/coreconfigurator.c | 2 +-
>>   drivers/staging/wilc1000/wilc_wlan.c        | 2 +-
>>   drivers/staging/wilc1000/wilc_wlan_if.h     | 2 +-
>>   3 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
>> index b069614..141d7b4 100644
>> --- a/drivers/staging/wilc1000/coreconfigurator.c
>> +++ b/drivers/staging/wilc1000/coreconfigurator.c
>> @@ -2094,7 +2094,7 @@ s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
>>                                     (counter == u32WIDsCount - 1));
>>                          if (!gpstrWlanOps->wlan_cfg_get(!counter,
>>                                                          pstrWIDs[counter].u16WIDid,
>> -                                                       (counter == u32WIDsCount - 1), drvHandler)) {
>> +                                                       (counter == u32WIDsCount - 1), (void *)drvHandler)) {
> If I recall correctly, you shouldn't need void * casts.
>
> Thanks,
>
Thanks.
Johnny.
