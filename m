Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:35760 "EHLO
	mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757399AbbLBPNB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2015 10:13:01 -0500
Received: by qkao63 with SMTP id o63so17119583qka.2
        for <linux-wireless@vger.kernel.org>; Wed, 02 Dec 2015 07:13:00 -0800 (PST)
Subject: Re: [PATCH 1/1] staging: cleanup: Fix incompatible type comparison in
 wilc1000/host_interface.c
To: Dan Carpenter <dan.carpenter@oracle.com>
References: <1448928544-3534-1-git-send-email-mrugiero@gmail.com>
 <20151202132923.GV18797@mwanda>
Cc: devel@driverdev.osuosl.org, chris.park@atmel.com,
	austin.shin@atmel.com, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com
From: "Mario J. Rugiero" <mrugiero@gmail.com>
Message-ID: <565F0A79.90100@gmail.com> (sfid-20151202_161305_836098_9F7C309D)
Date: Wed, 2 Dec 2015 12:12:57 -0300
MIME-Version: 1.0
In-Reply-To: <20151202132923.GV18797@mwanda>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK. Since the maintainers are CC'd, I guess I should wait for a 
clarification about this?

El 02/12/15 a las 10:29, Dan Carpenter escribió:
> Put v2 in the subject.  Also the subsystem prefix is:
>
> [PATCH v3] staging: wilc1000: ...
>
> On Mon, Nov 30, 2015 at 09:09:04PM -0300, Mario J. Rugiero wrote:
>> This patch replaces an "if (ptr > 0)" comparison that seems to be a
>> confusing way to check for null by a simpler "if (ptr)" check.
>>
>> Signed-off-by: Mario J. Rugiero <mrugiero@gmail.com>
>> ---
> v2: Remove the != NULL because checkpatch complains.
>
>>   drivers/staging/wilc1000/host_interface.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
>> index d5b7725..0c87f6c 100644
>> --- a/drivers/staging/wilc1000/host_interface.c
>> +++ b/drivers/staging/wilc1000/host_interface.c
>> @@ -2270,7 +2270,7 @@ static void Handle_AddBeacon(struct host_if_drv *hif_drv,
>>   	*pu8CurrByte++ = ((pstrSetBeaconParam->tail_len >> 16) & 0xFF);
>>   	*pu8CurrByte++ = ((pstrSetBeaconParam->tail_len >> 24) & 0xFF);
>>   
>> -	if (pstrSetBeaconParam->tail > 0)
>> +	if (pstrSetBeaconParam->tail)
> Probably the intention was to check if "pstrSetBeaconParam->tail_len > 0"
> but I'm not sure.  The wilc1000 maintainers are very responsive though
> so maybe they will know for sure.
>
> regards,
> dan carpenter
>
>

