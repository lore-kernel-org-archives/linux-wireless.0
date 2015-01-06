Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:38678 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482AbbAFP7J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 10:59:09 -0500
Message-ID: <54AC064A.6090505@lwfinger.net> (sfid-20150106_165915_817881_D7BCEA92)
Date: Tue, 06 Jan 2015 09:59:06 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	kvalo@codeaurora.org
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 02/11] rtlwifi: rtl8723be: Improve modinfo output
References: <1420217908-1382-1-git-send-email-Larry.Finger@lwfinger.net> <1420217908-1382-3-git-send-email-Larry.Finger@lwfinger.net> <54A6E50E.8070205@cogentembedded.com>
In-Reply-To: <54A6E50E.8070205@cogentembedded.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/02/2015 12:35 PM, Sergei Shtylyov wrote:
> Hello.
>
> On 1/2/2015 7:58 PM, Larry Finger wrote:
>
>> The description of the power-save variables for this driver is not as
>> clear as for the others. The wording is changed to match the others.
>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>   drivers/net/wireless/rtlwifi/rtl8723be/sw.c | 11 ++++++-----
>>   1 file changed, 6 insertions(+), 5 deletions(-)
>
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
>> b/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
>> index 223eb42..52a6d90 100644
>> --- a/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8723be/sw.c
>> @@ -387,12 +387,13 @@ module_param_named(swlps,
>> rtl8723be_mod_params.swctrl_lps, bool, 0444);
>>   module_param_named(fwlps, rtl8723be_mod_params.fwctrl_lps, bool, 0444);
>>   module_param_named(disable_watchdog, rtl8723be_mod_params.disable_watchdog,
>>              bool, 0444);
>> -MODULE_PARM_DESC(swenc, "using hardware crypto (default 0 [hardware])\n");
>> -MODULE_PARM_DESC(ips, "using no link power save (default 1 is open)\n");
>> -MODULE_PARM_DESC(fwlps, "using linked fw control power save (default 1 is
>> open)\n");
>> -MODULE_PARM_DESC(msi, "Set to 1 to use MSI interrupts mode (default 0)\n");
>
>     You are completely removing this description. Is it intentional?
>
>> +MODULE_PARM_DESC(swenc, "Set to 1 for software crypto (default 0)\n");
>> +MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
>> +MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
>> +MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
>>   MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
>> -MODULE_PARM_DESC(disable_watchdog, "Set to 1 to disable the watchdog (default
>> 0)\n");
>> +MODULE_PARM_DESC(disable_watchdog,
>> +         "Set to 1 to disable the watchdog (default 0)\n");
>
> WBR, Sergei

Good catch. Fixed in V2.

Larry


