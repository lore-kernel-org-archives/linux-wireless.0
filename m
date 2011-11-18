Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49258 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184Ab1KRTc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 14:32:27 -0500
Received: by yenq3 with SMTP id q3so2843753yen.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 11:32:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EC6B10A.5020907@hauke-m.de>
References: <1321490374-24529-1-git-send-email-linville@tuxdriver.com> <4EC6B10A.5020907@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Date: Fri, 18 Nov 2011 11:32:05 -0800
Message-ID: <CAB=NE6X69-2QyxJjUx6_O9JrfWTBf=WzVO-vgdykPeMg34Egig@mail.gmail.com> (sfid-20111118_203230_014696_8004FAA9)
Subject: Re: [PATCH 1/2] compat: avoid warning in compat_system_workqueue_create
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 18, 2011 at 11:24 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 11/17/2011 01:39 AM, John W. Linville wrote:
>> The check in the WARN_ON is inverted.
>>
> Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
>> Signed-off-by: John W. Linville <linville@tuxdriver.com>
>> ---
>>  compat/compat-2.6.36.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/compat/compat-2.6.36.c b/compat/compat-2.6.36.c
>> index aab25df..fe24da8 100644
>> --- a/compat/compat-2.6.36.c
>> +++ b/compat/compat-2.6.36.c
>> @@ -99,7 +99,7 @@ EXPORT_SYMBOL_GPL(system_nrt_wq);
>>  void compat_system_workqueue_create()
>>  {
>>       system_nrt_wq = create_singlethread_workqueue("events_nrt");
>> -     WARN_ON(system_nrt_wq);
>> +     WARN_ON(!system_nrt_wq);
>>  }
>>
>>  void compat_system_workqueue_destroy()
>
> That was my fault, please apply this patch.

Odd, I thought I had applied this already, sorry for the delay,
applied and pushed, I also applied this patch on the linux-3.2.y
branch, I'll make another stable release based on 3.2 for this as
otherwise people will get these warnings for their backports.

  Luis
