Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4463 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965262Ab1GOJlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 05:41:20 -0400
Message-ID: <4E200B2F.3060108@broadcom.com> (sfid-20110715_114126_716540_CCA051D2)
Date: Fri, 15 Jul 2011 11:41:03 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Julian Calaby" <julian.calaby@gmail.com>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 05/35] staging: brcm80211: removed function
 declaration typedefs from aiutils.h
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
 <1310678971-28952-6-git-send-email-frankyl@broadcom.com>
 <CAGRGNgWx5-8cbU3zSnHQbbCdbf5xOGjYEnkcxnz5M4kB1s0nUQ@mail.gmail.com>
In-Reply-To: <CAGRGNgWx5-8cbU3zSnHQbbCdbf5xOGjYEnkcxnz5M4kB1s0nUQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Julian,

>> Signed-off-by: Roland Vossen<rvossen@broadcom.com>
>> Reviewed-by: Arend van Spriel<arend@broadcom.com>
>> ---
>> diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
>> index a25901e..5a5fc4b 100644
>> --- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
>> +++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
>> @@ -1279,9 +1279,9 @@ ai_register_intr_callback(struct si_pub *sih, void *intrsoff_fn,
>>
>>         sii = SI_INFO(sih);
>>         sii->intr_arg = intr_arg;
>> -       sii->intrsoff_fn = (si_intrsoff_t) intrsoff_fn;
>> -       sii->intrsrestore_fn = (si_intrsrestore_t) intrsrestore_fn;
>> -       sii->intrsenabled_fn = (si_intrsenabled_t) intrsenabled_fn;
>> +       sii->intrsoff_fn = (u32 (*)(void *)) intrsoff_fn;
>> +       sii->intrsrestore_fn = (void (*) (void *, u32)) intrsrestore_fn;
>> +       sii->intrsenabled_fn = (bool (*)(void *)) intrsenabled_fn;
>>         /* save current core id.  when this function called, the current core
>>          * must be the core which provides driver functions(il, et, wl, etc.)
>>          */
>
> Are these casts necessary - as in could better types be chosen for
> these function pointers and the underlying functions themselves?
> I see the same issue in patches 6 - 10.

The first goal was to replace the typedefs, in a way that is obvious to 
the reviewer. The next step is to get rid of void* where possible (I 
agree with you that it is ugly).

Is it ok with you if we submit a separate patch train for that (since 
there are quite some void* to be replaced) ?

Thanks, Roland.

