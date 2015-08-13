Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33947 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbbHMTsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 15:48:45 -0400
Received: by oip136 with SMTP id 136so32597644oip.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2015 12:48:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1439490787.2114.36.camel@sipsolutions.net>
References: <1438292115-39495-1-git-send-email-filbranden@google.com>
 <1439456484.2114.6.camel@sipsolutions.net> <CADU+-uDS2C4w-dcbR8Rxx+jRfG7kNvu8JTncH-fxDnSp5NOBfQ@mail.gmail.com>
 <1439490787.2114.36.camel@sipsolutions.net>
From: enh <enh@google.com>
Date: Thu, 13 Aug 2015 12:48:24 -0700
Message-ID: <CAJgzZoo3ifnocO84uMLa1=LKQjGWm_J3WTsw0xO2skPG9gDtng@mail.gmail.com> (sfid-20150813_214848_214634_E98AA6D6)
Subject: Re: [PATCH 0/2] iw: fixes to Android.mk to include "iw" in AOSP builds
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Filipe Brandenburger <filbranden@google.com>,
	Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
	Christopher Wiley <wiley@google.com>,
	Ying Wang <wangying@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 13, 2015 at 11:33 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2015-08-13 at 09:55 -0700, Filipe Brandenburger wrote:
>
>> Long term, considering this is in AOSP and is part of eng/userdebug
>> builds, it's likely to be automatically available in future versions
>> of Android.
>
> Yeah, but most vendors don't actually build/run/ship AOSP nor
> necessarily an unmodified iw, so it's likely not all that helpful.

i think you misunderstand what AOSP is. this code is currently in AOSP
master, and thus in internal master, and thus in a future release.

>> We ended up having to tweak the Android.mk again in the AOSP tree,
>> since the current one is doing an "include" of the external Makefile,
>> which in turns overrides the default "clean" rule and leaks some
>> pattern rules such as %.o, etc. which affect the rest of Android
>> build. For more details, please take a look at this Gerrit:
>> https://android-review.googlesource.com/166104
>>
>> I'm cc'ing Ying who spotted the problem and suggested the changes.
>
> Thanks, but I'm not going to apply that patch in my tree - I don't want
> to have to worry about the duplication of LOCAL_SRC_FILES.
>
>> One problem with the current approach is that there's duplication of
>> the names of the source files between Android.mk and Makefile, I was
>> thinking perhaps we could introduce a common.mk or sources.mk that's
>> included from both and only has the variables that can be used by
>> both? Suggestions are welcome.
>
> That seems reasonable.
>
>> As mentioned in the initial thread, one option is to drop Android.mk
>> from upstream altogether and maintain it in our AOSP downstream.
>
> Given what I just said above about vendor builds etc. not being AOSP,
> that probably wouldn't be all that helpful; I'm pretty sure it'd make
> our life more difficult so I don't really like that idea much.
>
> johannes



-- 
Elliott Hughes - http://who/enh - http://jessies.org/~enh/
Android native code/tools questions? Mail me/drop by/add me as a reviewer.
