Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:34660 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbbHMQz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 12:55:57 -0400
Received: by ykdt205 with SMTP id t205so46600424ykd.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2015 09:55:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1439456484.2114.6.camel@sipsolutions.net>
References: <1438292115-39495-1-git-send-email-filbranden@google.com>
	<1439456484.2114.6.camel@sipsolutions.net>
Date: Thu, 13 Aug 2015 09:55:56 -0700
Message-ID: <CADU+-uDS2C4w-dcbR8Rxx+jRfG7kNvu8JTncH-fxDnSp5NOBfQ@mail.gmail.com> (sfid-20150813_185604_792307_6D7B7C75)
Subject: Re: [PATCH 0/2] iw: fixes to Android.mk to include "iw" in AOSP builds
From: Filipe Brandenburger <filbranden@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
	Elliott Hughes <enh@google.com>,
	Christopher Wiley <wiley@google.com>,
	Ying Wang <wangying@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Thu, Aug 13, 2015 at 2:01 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> We have a very similar patch internally as well (that I was still
> evualating/reviewing) but it was less complete, so I've applied this
> despite Arik's objections.

Thank you!

> I think that if anyone needs to build against older Android, which is
> very well possible, we can partially revert this and maybe provide some
> environment variable they can control from their BSP, but until
> somebody really shows up with that I'll leave it as is and assume that
> older Android builds will also use older iw.

Short term, yes, whoever wants to build this against KitKat can just
revert this locally.

Long term, considering this is in AOSP and is part of eng/userdebug
builds, it's likely to be automatically available in future versions
of Android.

We ended up having to tweak the Android.mk again in the AOSP tree,
since the current one is doing an "include" of the external Makefile,
which in turns overrides the default "clean" rule and leaks some
pattern rules such as %.o, etc. which affect the rest of Android
build. For more details, please take a look at this Gerrit:
https://android-review.googlesource.com/166104

I'm cc'ing Ying who spotted the problem and suggested the changes.

One problem with the current approach is that there's duplication of
the names of the source files between Android.mk and Makefile, I was
thinking perhaps we could introduce a common.mk or sources.mk that's
included from both and only has the variables that can be used by
both? Suggestions are welcome.

As mentioned in the initial thread, one option is to drop Android.mk
from upstream altogether and maintain it in our AOSP downstream.

Thanks!
Filipe
