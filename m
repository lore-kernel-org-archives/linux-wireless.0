Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36994 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758836AbaD3Sr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2014 14:47:27 -0400
Message-ID: <53614528.1010600@candelatech.com> (sfid-20140430_204731_457906_3C7F0B3C)
Date: Wed, 30 Apr 2014 11:47:04 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k:  Prevent divide by zero kernel crash.
References: <1397695240-13710-1-git-send-email-greearb@candelatech.com> <534F870E.80209@openwrt.org>
In-Reply-To: <534F870E.80209@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/17/2014 12:47 AM, Felix Fietkau wrote:
> On 2014-04-17 02:40, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Make sure we cannot ever assign beacon interval to zero.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/beacon.c | 4 ++++
>>  drivers/net/wireless/ath/ath9k/recv.c   | 3 ++-
>>  2 files changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
>> index 2e8bba0..5391f01 100644
>> --- a/drivers/net/wireless/ath/ath9k/beacon.c
>> +++ b/drivers/net/wireless/ath/ath9k/beacon.c
>> @@ -443,6 +443,8 @@ static u32 ath9k_mod_tsf64_tu(u64 tsf, u32 div_tu)
>>  {
>>  	u32 tsf_mod, tsf_hi, tsf_lo, mod_hi, mod_lo;
>>  
>> +	if (WARN_ON_ONCE(div_tu == 0))
>> +		div_tu = 100;
>>  	tsf_mod = tsf & (BIT(10) - 1);
>>  	tsf_hi = tsf >> 32;
>>  	tsf_lo = ((u32) tsf) >> 10;
> Why add this warning here if you already have the additions below? We
> don't need multiple layers of defensive checks for the same thing.

I am not sure I can find all cases that can send bad data to this
call, and in other places, it seems having an invalid beacon interval
might mess up other calculations, so better to check and set it to
a better value there as well.

So, I'd prefer to leave all three warnings in, and if we ever see
the one hit down in mod_tsf64_tu, then probably more protection
is needed elsewhere.

Or, just treat this patch as bug report and maybe someone will
fix it better...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

