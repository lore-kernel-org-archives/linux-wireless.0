Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f18.google.com ([209.85.217.18]:48198 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbYJ1Mdv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 08:33:51 -0400
Message-ID: <bc64b4640810280533x445e7869m444dac909f8be1d2@mail.gmail.com> (sfid-20081028_133356_815951_4EEDD859)
Date: Tue, 28 Oct 2008 15:33:49 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [PATCH] RFKILL: fix input layer initialisation
Cc: linux-wireless@vger.kernel.org, linux-input@vger.kernel.org
In-Reply-To: <200810221905.58169.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1224694375-29318-1-git-send-email-dbaryshkov@gmail.com>
	 <200810221905.58169.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/22 Ivo van Doorn <ivdoorn@gmail.com>:
> On Wednesday 22 October 2008, Dmitry Baryshkov wrote:
>> Initialise correctly last fields, so tasks can be actually executed.
>> On some architectures the initial jiffies value is not zero, so later
>> all rfkill incorrectly decides that rfkill_*.last is in future.
>>
>> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
>> ---
>>  net/rfkill/rfkill-input.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
>> index e5b6955..cd93f48 100644
>> --- a/net/rfkill/rfkill-input.c
>> +++ b/net/rfkill/rfkill-input.c
>> @@ -255,6 +255,11 @@ static struct input_handler rfkill_handler = {
>>
>>  static int __init rfkill_handler_init(void)
>>  {
>> +     unsigned long last_run = jiffies - msecs_to_jiffies(500);
>> +     rfkill_wlan.last = last_run;
>> +     rfkill_bt.last = last_run;
>> +     rfkill_uwb.last = last_run;
>> +     rfkill_wimax.last = last_run;
>>       return input_register_handler(&rfkill_handler);
>>  }
>
> I believe Dmitry Torokhov recently moved the rfkill structures for wlan, bt, etc
> into an array which allowed for easy looping through all structures. That would
> make updating all entries easier (and less prone to errors when a new structure
> is added).

I can't find the patch in question. Could you please point me to it?

>
> Could you rebase thise patch on top of that one?
> Thanks,

-- 
With best wishes
Dmitry
