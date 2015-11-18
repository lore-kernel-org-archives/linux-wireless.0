Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37389 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbbKRLaf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 06:30:35 -0500
Date: Wed, 18 Nov 2015 12:30:16 +0100
From: Bogicevic Sasa <brutallesale@gmail.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: gregkh@linuxfoundation.org, johnny.kim@atmel.com,
	austin.shin@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:staging:wilc1000 Fix comparison to NULL messages
Message-ID: <20151118113016.GA26728@gmail.com> (sfid-20151118_123052_416900_C88F17E4)
References: <1447790488-17742-1-git-send-email-brutallesale@gmail.com>
 <20151118061927.GA6229@sudip-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
In-Reply-To: <20151118061927.GA6229@sudip-pc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18, Sudip Mukherjee wrote:
>On Tue, Nov 17, 2015 at 09:01:28PM +0100, Bogicevic Sasa wrote:
>> This fixes all "Comparison to NULL could be written like..."
>> messages from checkpatch.pl
>>
>> Signed-off-by: Bogicevic Sasa <brutallesale@gmail.com>
>> ---
>>  drivers/staging/wilc1000/coreconfigurator.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
>> index fd7240c..a31ac55 100644
>> --- a/drivers/staging/wilc1000/coreconfigurator.c
>> +++ b/drivers/staging/wilc1000/coreconfigurator.c
>> @@ -434,7 +434,7 @@ s32 parse_network_info(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
>>
>>  		/* Get DTIM Period */
>>  		pu8TimElm = get_tim_elm(pu8msa, u16RxLen + FCS_LEN, u8index);
>> -		if (pu8TimElm != NULL)
>> +		if (!pu8TimElm)
>
>You are now checking for -  if (pu8TimElm == NULL)	
>It should actually be: if (pu8TimElm)
>
>regards
>sudip
Right, so stuped, Ill resend it
