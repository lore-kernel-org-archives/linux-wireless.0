Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43303 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1GSUu3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 16:50:29 -0400
Received: by pvg12 with SMTP id 12so4175562pvg.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2011 13:50:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110719204246.GB2477@tuxdriver.com>
References: <1310857566-2876-1-git-send-email-zajec5@gmail.com>
	<1310857566-2876-2-git-send-email-zajec5@gmail.com>
	<20110719204246.GB2477@tuxdriver.com>
Date: Tue, 19 Jul 2011 22:50:28 +0200
Message-ID: <CACna6rxZMFnFiYFkrW9xTkL_eXTXH91sEO-W=HZqoiUYLMNumQ@mail.gmail.com> (sfid-20110719_225032_062136_16E2C9BB)
Subject: Re: [PATCH 2/4] bcma: allow setting FAST clockmode for a core
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 19 lipca 2011 22:42 użytkownik John W. Linville
<linville@tuxdriver.com> napisał:
>  CC [M]  drivers/bcma/core.o
> drivers/bcma/core.c: In function ‘bcma_core_set_clockmode’:
> drivers/bcma/core.c:65:22: error: ‘BCMA_CLKCTLST’ undeclared (first use in this function)
> drivers/bcma/core.c:65:22: note: each undeclared identifier is reported only once for each function it appears in
> drivers/bcma/core.c:65:73: error: ‘BCMA_CLKCTLST_FORCEHT’ undeclared (first use in this function)
> drivers/bcma/core.c:69:8: error: ‘BCMA_CLKCTLST_HAVEHT’ undeclared (first use in this function)
> drivers/bcma/core.c: In function ‘bcma_core_pll_ctl’:
> drivers/bcma/core.c:89:35: error: ‘BCMA_CLKCTLST_EXTRESREQ’ undeclared (first use in this function)
> drivers/bcma/core.c:90:38: error: ‘BCMA_CLKCTLST_EXTRESST’ undeclared (first use in this function)
> drivers/bcma/core.c:93:22: error: ‘BCMA_CLKCTLST’ undeclared (first use in this function)
> make[2]: *** [drivers/bcma/core.o] Error 1
> make[1]: *** [drivers/bcma] Error 2
> make: *** [drivers] Error 2

I'm sorry, that's quite normal you could lost order&dependency with
the amount of patches I've sent.

As nobody objected, please apply
[RFC][PATCH] bcma: move define of BCMA_CLKCTLST register
It should be applied before this one.


> On Sun, Jul 17, 2011 at 01:06:04AM +0200, Rafał Miłecki wrote:
>>
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>>  drivers/bcma/core.c       |   31 +++++++++++++++++++++++++++++++
>>  include/linux/bcma/bcma.h |    8 +++++++-
>>  2 files changed, 38 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/bcma/core.c b/drivers/bcma/core.c
>> index 1ec7d45..0686b1b 100644
>> --- a/drivers/bcma/core.c
>> +++ b/drivers/bcma/core.c
>> @@ -50,3 +50,34 @@ int bcma_core_enable(struct bcma_device *core, u32 flags)
>>       return 0;
>>  }
>>  EXPORT_SYMBOL_GPL(bcma_core_enable);
>> +
>> +void bcma_core_set_clockmode(struct bcma_device *core,
>> +                          enum bcma_clkmode clkmode)
>> +{
>> +     u16 i;
>> +
>> +     WARN_ON(core->id.id != BCMA_CORE_CHIPCOMMON &&
>> +             core->id.id != BCMA_CORE_PCIE &&
>> +             core->id.id != BCMA_CORE_80211);
>> +
>> +     switch (clkmode) {
>> +     case BCMA_CLKMODE_FAST:
>> +             bcma_set32(core, BCMA_CLKCTLST, BCMA_CLKCTLST_FORCEHT);
>> +             udelay(64);
>> +             for (i = 0; i < 1500; i++) {
>> +                     if (bcma_read32(core, BCMA_CLKCTLST) &
>> +                         BCMA_CLKCTLST_HAVEHT) {
>> +                             i = 0;
>> +                             break;
>> +                     }
>> +                     udelay(10);
>> +             }
>> +             if (i)
>> +                     pr_err("HT force timeout\n");
>> +             break;
>> +     case BCMA_CLKMODE_DYNAMIC:
>> +             pr_warn("Dynamic clockmode not supported yet!\n");
>> +             break;
>> +     }
>> +}
>> +EXPORT_SYMBOL_GPL(bcma_core_set_clockmode);
>> diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
>> index 6e5dc7b..37017c1 100644
>> --- a/include/linux/bcma/bcma.h
>> +++ b/include/linux/bcma/bcma.h
>> @@ -25,6 +25,11 @@ struct bcma_chipinfo {
>>       u8 pkg;
>>  };
>>
>> +enum bcma_clkmode {
>> +     BCMA_CLKMODE_FAST,
>> +     BCMA_CLKMODE_DYNAMIC,
>> +};
>> +
>>  struct bcma_host_ops {
>>       u8 (*read8)(struct bcma_device *core, u16 offset);
>>       u16 (*read16)(struct bcma_device *core, u16 offset);
>> @@ -253,6 +258,7 @@ void bcma_awrite32(struct bcma_device *core, u16 offset, u32 value)
>>  extern bool bcma_core_is_enabled(struct bcma_device *core);
>>  extern void bcma_core_disable(struct bcma_device *core, u32 flags);
>>  extern int bcma_core_enable(struct bcma_device *core, u32 flags);
>> -
>> +extern void bcma_core_set_clockmode(struct bcma_device *core,
>> +                                 enum bcma_clkmode clkmode);
>>
>>  #endif /* LINUX_BCMA_H_ */
>> --
>> 1.7.3.4

-- 
Rafał
