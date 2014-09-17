Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:5501 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835AbaIQPdz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2014 11:33:55 -0400
Message-ID: <5419AA01.50606@intel.com> (sfid-20140917_173400_399611_74A52C0D)
Date: Wed, 17 Sep 2014 17:34:25 +0200
From: Loic Poulain <loic.poulain@intel.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] net: rfkill: gpio: Fix clock status
References: <1410872038-4604-1-git-send-email-loic.poulain@intel.com> <20140917151142.GA13392@tuxdriver.com>
In-Reply-To: <20140917151142.GA13392@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If rfkill block/unblock are balanced, the following conditions are never 
true:
- if (!blocked && !rfkill->clk_enabled)
- if (blocked && rfkill->clk_enabled)

Then, clock is neither disabled nor enabled.
If clock is enabled by default, it does not cause any obvious issue.

Or maybe there's not much device with clock resource.

Regards,
Loic

On 17/09/2014 17:11, John W. Linville wrote:
> On Tue, Sep 16, 2014 at 02:53:58PM +0200, Loic Poulain wrote:
>> Clock is disabled when the device is blocked.
>> So, clock_enabled is the logical negation of "blocked".
>>
>> Signed-off-by: Loic Poulain <loic.poulain@intel.com>
>> ---
>>   net/rfkill/rfkill-gpio.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
>> index 14c98e4..408e51f 100644
>> --- a/net/rfkill/rfkill-gpio.c
>> +++ b/net/rfkill/rfkill-gpio.c
>> @@ -54,7 +54,7 @@ static int rfkill_gpio_set_power(void *data, bool blocked)
>>   	if (blocked && !IS_ERR(rfkill->clk) && rfkill->clk_enabled)
>>   		clk_disable(rfkill->clk);
>>   
>> -	rfkill->clk_enabled = blocked;
>> +	rfkill->clk_enabled = !blocked;
>>   
>>   	return 0;
>>   }
> This looks like the right fix, but...the code has been that way for
> a long time.  If this patch is correct, how has this gone undetected
> for so long?
>
> John

-- 
Intel Open Source Technology Center
http://oss.intel.com/

