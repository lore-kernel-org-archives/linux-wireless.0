Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f173.google.com ([209.85.210.173]:40384 "EHLO
	mail-yx0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbZFPUHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 16:07:41 -0400
Received: by yxe3 with SMTP id 3so177770yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 13:07:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A37E6F1.4080003@hauke-m.de>
References: <4A30CE70.4050605@web.de> <200906112305.33675.mb@bu3sch.de>
	<43e72e890906111410n3766ceb7t4b4efda05730c693@mail.gmail.com>
	<200906112314.29464.mb@bu3sch.de> <69e28c910906111439o798b3298p63bd44e88358ea8a@mail.gmail.com>
	<43e72e890906111443h5758b74dk6f788b327b1cfe4c@mail.gmail.com>
	<4A3368F9.6060509@web.de> <4A37E6F1.4080003@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 16 Jun 2009 13:07:23 -0700
Message-ID: <43e72e890906161307w1441e26dnec48bbb1f88c38fd@mail.gmail.com>
Subject: Re: [PATCH] Warp speed building
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Jan Kiszka <jan.kiszka@web.de>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 16, 2009 at 11:39 AM, Hauke Mehrtens<hauke@hauke-m.de> wrote:
> Jan Kiszka wrote:
>> Including config.mk again when kbuild called into the top level Makefile
>> slowed down the build process awfully. The reason for this were all the
>> dynamic, shell-based variable evaluations that were called over and over
>> again. Fortunately, including config.mk only in the outer Makefile run
>> appears to be enough. So let's remove this warp speed blocker.
>>
>> Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
>> ---
>>  Makefile |    2 --
>>  1 files changed, 0 insertions(+), 2 deletions(-)
>>
>> diff --git a/Makefile b/Makefile
>> index 0ab7d27..49a786a 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -13,8 +13,6 @@ OLD_IWL=$(shell $(MODPROBE) -l iwl4965)
>>
>>  ifneq ($(KERNELRELEASE),)
>>
>> -include $(M)/$(COMPAT_CONFIG)
>> -
>>  NOSTDINC_FLAGS := -I$(M)/include/ -include $(M)/include/net/compat.h $(CFLAGS)
>>
>>  obj-y := net/wireless/ net/mac80211/ net/rfkill/
>
> Hi Jan,
>
> I have tested this patch and it reduced the build time for me from 3:30
> to 2:40 minutes on a dual core system. I can not see any changes, expect
> the reduced build time on my system. The resulting modules are still the
> same.

Reason for including the config.mk is if your current kernel config
differs the makefiles won't pick up the new stuff.

  Luis
