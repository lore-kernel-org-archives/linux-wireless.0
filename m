Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46963 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756259AbdGLCXE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Jul 2017 22:23:04 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6C2ImuY116516
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jul 2017 22:23:04 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bn0mwg5ew-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jul 2017 22:23:03 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-wireless@vger.kernel.org> from <rui.teng@linux.vnet.ibm.com>;
        Tue, 11 Jul 2017 22:23:02 -0400
Subject: Re: [PATCH] drivers/staging/wilc1000: fix sparse warning: right shift
 by bigger than source value
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20170710085731.28397-1-rui.teng@linux.vnet.ibm.com>
 <20170711170449.GA30362@kroah.com>
Cc: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Rui Teng <rui.teng@linux.vnet.ibm.com>
Date: Wed, 12 Jul 2017 10:23:02 +0800
MIME-Version: 1.0
In-Reply-To: <20170711170449.GA30362@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Message-Id: <f31c5818-7ba3-4708-3fda-5bfbe0c4c1da@linux.vnet.ibm.com> (sfid-20170712_042336_371276_A3BACCA4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/07/2017 1:04 AM, Greg Kroah-Hartman wrote:
> On Mon, Jul 10, 2017 at 04:57:31PM +0800, Rui Teng wrote:
>> This patch sets memory to zero directly to avoid unnecessary shift and
>> bitwise operations on bool type, which can fix a sparse warning and also
>> improve performance.
>
> It does?  How did you measure the performance impact?  What was now
> faster?

It can avoid 3 times right shift and 3 times bitwise operations.
And once memory set should also faster than 4 times copy operations.
And add number 4 once should also faster than 4 times plus plus.

>
> thanks,
>
> greg k-h
>
>
>>
>> Signed-off-by: Rui Teng <rui.teng@linux.vnet.ibm.com>
>> ---
>>  drivers/staging/wilc1000/host_interface.c | 7 +++----
>>  1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
>> index 2568dfc15181..036c5c19a016 100644
>> --- a/drivers/staging/wilc1000/host_interface.c
>> +++ b/drivers/staging/wilc1000/host_interface.c
>> @@ -2416,10 +2416,9 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
>>  		goto ERRORHANDLER;
>>
>>  	pu8CurrByte = wid.val;
>> -	*pu8CurrByte++ = (strHostIfSetMulti->enabled & 0xFF);
>> -	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 8) & 0xFF);
>> -	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 16) & 0xFF);
>> -	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 24) & 0xFF);
>> +	memset(pu8CurrByte, 0, 4);
>> +	*pu8CurrByte = (strHostIfSetMulti->enabled & 0xFF);
>> +	pu8CurrByte += 4;
>
> Are you sure enabled isn't larger than 8 bits?

The size of bool may larger than 8 bits. But when we assign any value
to bool type, the value of bool type will only be 1 or 0.
For example, the following output will be 1 other than 0x100.
	bool b = 0x100;
	printf("b: %d\n", b);

Or I think it should change 'enabled' type from bool to u32, to make 
sure that the right shift operation can take effect.

>
> thanks,
>
> greg k-h
>
