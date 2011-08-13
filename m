Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from app1b.xlhost.de ([213.202.242.162]:57502 "EHLO app1b.xlhost.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab1HMJoP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 05:44:15 -0400
Message-ID: <4E46476B.5060608@kpanic.de> (sfid-20110813_114418_533502_E8A362C2)
Date: Sat, 13 Aug 2011 11:44:11 +0200
From: Stefan Assmann <sassmann@kpanic.de>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: add module parameter to set global debug level
References: <1313176963-17141-1-git-send-email-sassmann@kpanic.de> <4E458DFD.4060208@lwfinger.net>
In-Reply-To: <4E458DFD.4060208@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12.08.2011 22:33, Larry Finger wrote:
> On 08/12/2011 02:22 PM, Stefan Assmann wrote:
>> Adding a module parameter to allow setting the global debug level.
>> No need to recompile the module anymore to set the debug level.
>>
>> Signed-off-by: Stefan Assmann<sassmann@kpanic.de>
>> ---
>>   drivers/net/wireless/rtlwifi/debug.c |    6 +++++-
>>   1 files changed, 5 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rtlwifi/debug.c b/drivers/net/wireless/rtlwifi/debug.c
>> index 5fa7385..1d82639 100644
>> --- a/drivers/net/wireless/rtlwifi/debug.c
>> +++ b/drivers/net/wireless/rtlwifi/debug.c
>> @@ -28,12 +28,16 @@
>>
>>   #include "wifi.h"
>>
>> +static unsigned int debug = DBG_EMERG;
>> +module_param(debug, uint, 0);
>> +MODULE_PARM_DESC(debug, "Set global debug level for rtlwifi (uint)");
> 
> As the system puts a (uint) following the description when the modinfo command 
> is used, the one above is redundant. Replace it with (0,2-5) instead. I have no 
> idea why there is a hole in the debug levels, but I hesitate to close it. Also, 
> send patches to John Linville with Cc to wireless.
> 
> Thanks for doing this. I'll sign off on it when you send V2.

Snap, I missed that. Thanks for pointing it out. V2 should be coming
around shortly.

  Stefan
