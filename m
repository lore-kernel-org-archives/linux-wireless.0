Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:33250 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996Ab0ASXxs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 18:53:48 -0500
Received: by pxi12 with SMTP id 12so5055750pxi.33
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2010 15:53:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B560AB6.7090405@openwrt.org>
References: <4B547031.60600@openwrt.org> <4B547076.5060006@openwrt.org>
	<20100119193545.GA8069@bombadil.infradead.org> <4B560AB6.7090405@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 19 Jan 2010 15:53:28 -0800
Message-ID: <43e72e891001191553h48bb23fcscb41c9e045d5f424@mail.gmail.com>
Subject: Re: [PATCH 2/2] compat: fix compile errors with CONFIG_FW_LOADER
	unset
To: Felix Fietkau <nbd@openwrt.org>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 19, 2010 at 11:40 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2010-01-19 8:35 PM, Luis R. Rodriguez wrote:
>> what about something like this? This is not tested on a system without
>> FW_LOADER  yet, not sure if it works:
>>
>> diff --git a/Makefile b/Makefile
>> index 4843869..ad8a602 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -19,8 +19,13 @@ $(foreach ver,$(COMPAT_VERSIONS),$(eval export CONFIG_COMPAT_KERNEL_$(ver)=y))
>>  endif
>>
>>  ifeq ($(CONFIG_COMPAT_KERNEL_33),y)
>> +ifeq ($(CONFIG_FW_LOADER),y)
>>   export CONFIG_COMPAT_FIRMWARE_CLASS=m
>>  endif
>> +ifeq ($(CONFIG_FW_LOADER_MODULE),y)
>> + export CONFIG_COMPAT_FIRMWARE_CLASS=m
>> +endif
>> +endif
>>
>>  obj-y += compat/
>>
>>
>> Oh well this is just for compat.git but we'd do something similar on config.mk
>> Testing to build compat.git should suffice though I think.
> Sounds good.

OK tested against a kernel without CONFIG_FW_LOADER and it works. Only
thing is CONFIG_FW_LOADER can actually be m too so will handle that as
well and push a new release of stuff. Thanks for the patches.

  Luis
