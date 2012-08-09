Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:55056 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab2HIJWg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 05:22:36 -0400
Message-ID: <50238158.2000809@neratec.com> (sfid-20120809_112239_805496_10EBF134)
Date: Thu, 09 Aug 2012 11:22:32 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] compat: fix endless recursion in flush_scheduled_work
References: <1343924881-31418-1-git-send-email-hauke@hauke-m.de> <1343924881-31418-2-git-send-email-hauke@hauke-m.de> <CAB=NE6UTm9WyHZX-Ve5TZcKVfWf52caGhBWY_3q9RQuD8KcnZQ@mail.gmail.com>
In-Reply-To: <CAB=NE6UTm9WyHZX-Ve5TZcKVfWf52caGhBWY_3q9RQuD8KcnZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/06/2012 08:52 PM, Luis R. Rodriguez wrote:
> On Thu, Aug 2, 2012 at 9:28 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> The hader file defines flush_scheduled_work(a)
>> compat_flush_scheduled_work(a), which causes flush_scheduled_work() and
>> compat_flush_scheduled_work() to be the same function.
>>
>> With this patch it calls the actual function in the kernel.
>>
>> This fixes problems when unloading mac80211 from compat-wireless.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  compat/compat-2.6.36.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/compat/compat-2.6.36.c b/compat/compat-2.6.36.c
>> index 8f25be0..05b41c2 100644
>> --- a/compat/compat-2.6.36.c
>> +++ b/compat/compat-2.6.36.c
>> @@ -133,6 +133,7 @@ int compat_schedule_delayed_work_on(int cpu,
>>  }
>>  EXPORT_SYMBOL_GPL(compat_schedule_delayed_work_on);
>>
>> +#undef flush_scheduled_work(a)
>>  void compat_flush_scheduled_work(void)
> 
> Hah! Nice. I'll add this and push... Zefir can you see if after
> getting today's compat.git and then by reverting your patch
> 3da0495cf863288b on compat.git if the unloading issues still happens.
> Likely this was the *real* cause, although it is odd to me you ended
> up removing the flush_workqueue() and not the flush_scheduled_work().
> 
>   Luis
> 
Yep, works. Thanks Hauke for the proper fix.

As for why I removed the wrong line, I got the macro mapping wrong,
assuming it ended in calling flush_workqueue() - and chose to remove the
wrong one.

Still curious why it is not crashing with my quick hack, that remained
recursion intact...


Thanks


