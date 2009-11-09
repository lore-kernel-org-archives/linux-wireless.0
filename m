Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:57531 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbZKISHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 13:07:54 -0500
Received: by fxm21 with SMTP id 21so387039fxm.21
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 10:07:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1257787187.21134.22331.camel@rc-desk>
References: <cb0375e10911081130k5d8f8347y999cf66a98e6898a@mail.gmail.com>
	 <1257787187.21134.22331.camel@rc-desk>
Date: Mon, 9 Nov 2009 13:07:58 -0500
Message-ID: <cb0375e10911091007w45fa5653y8ed4f043f37074b6@mail.gmail.com>
Subject: Re: [PATCH] iwlcore: Allow runtime configuration of
	no_sleep_autoadjust
From: Andrew Lutomirski <andy@luto.us>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 9, 2009 at 12:19 PM, reinette chatre
<reinette.chatre@intel.com> wrote:
> On Sun, 2009-11-08 at 11:30 -0800, Andrew Lutomirski wrote:
>> Runtime adjustment of no_sleep_autoadjust seems fine, both looking at
>> the code and in practice.  This makes it easier to test.
>>
>> Signed-off-by: Andy Lutomirski <luto@mit.edu>
>> ---
>> I've been running this patch (and twiddling the setting) for a couple
>> months now, and it seems to work fine.  I think it's a bit late for
>> 2.6.32, even though it's pretty much impossible for this to cause any
>> regressions, but it would be nice to see it go in for 2.6.33 until
>> no_sleep_autoadjust goes away.
>>
>> diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c
>> b/drivers/net/wireless/iwlwifi/iwl-power.c
>> index 60be976..4eba1ab 100644
>> --- a/drivers/net/wireless/iwlwifi/iwl-power.c
>> +++ b/drivers/net/wireless/iwlwifi/iwl-power.c
>> @@ -54,7 +54,7 @@
>>   * adjusting ...
>>   */
>>  bool no_sleep_autoadjust = true;
>> -module_param(no_sleep_autoadjust, bool, S_IRUGO);
>> +module_param(no_sleep_autoadjust, bool, S_IRUGO | S_IWUSR);
>>  MODULE_PARM_DESC(no_sleep_autoadjust,
>>                "don't automatically adjust sleep level "
>>                "according to maximum network latency");
>
> I think this change is a bit deceiving since making this writable does
> not result in what you write to it at runtime being communicated to the
> device.

Hmm.  It looks like sleep_level_override in debugfs can do exactly what I want.

Is there any reason that no_sleep_autoadjust doesn't just make
sleep_level_override default to 1?

--Andy
