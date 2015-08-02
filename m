Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:32825 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbbHBQLw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2015 12:11:52 -0400
Received: by oig1 with SMTP id 1so25992926oig.0
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2015 09:11:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXffMtXYMq_hFbaeD+Q6iJ2efQOYFkMuyTYL6b39WRVtgZA@mail.gmail.com>
References: <1438292115-39495-1-git-send-email-filbranden@google.com>
 <1438292115-39495-3-git-send-email-filbranden@google.com> <CA+XVXfegO1SoTkxYwT7Ne6f6eFxqEJXrvzR_ZOyz=Kso4QKUyQ@mail.gmail.com>
 <CAJgzZorOZ-HU2BUbWkssFzm++N-MEryxckPQRj7DyFEyMz0Jrg@mail.gmail.com> <CA+XVXffMtXYMq_hFbaeD+Q6iJ2efQOYFkMuyTYL6b39WRVtgZA@mail.gmail.com>
From: enh <enh@google.com>
Date: Sun, 2 Aug 2015 09:11:32 -0700
Message-ID: <CAJgzZopACyHt=kJmbfkXnfkMOTPiCUvQo2AVYZa8HhKTEV=yrw@mail.gmail.com> (sfid-20150802_181155_812528_065C70A9)
Subject: Re: [PATCH 2/2] iw: remove android-nl.c with unneeded workaround
To: Arik Nemtsov <arik@wizery.com>
Cc: Filipe Brandenburger <filbranden@google.com>,
	Johannes Berg <johannes.berg@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Christopher Wiley <wiley@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 1, 2015 at 11:57 PM, Arik Nemtsov <arik@wizery.com> wrote:
> On Fri, Jul 31, 2015 at 7:01 PM, enh <enh@google.com> wrote:
>> no, because this is meant for the platform build system rather than
>> the NDK. although the NDK has a concept of target API level, the
>> platform only has "current".
>
> Don't you have PLATFORM_VERSION?
> http://androidxref.com/5.1.1_r6/xref/build/core/version_defaults.mk

yes, but that's an arbitrary string.

> And I see it's already used in some places.

by OEM code that's expected to be obsolete anyway. if you only have to
list _past_ versions (and you only care about Google's Android, and
not, say, the Amazon fork), you can use PLATFORM_VERSION. but it
doesn't seem a good idea for general use.

> My 2c is that it's a bad idea to break older version compatibility
> when Android is not the owner of the project/git. Basically you don't
> really have the same level of control over where this is used.

my 2c is that it's a bad idea to have an Android.mk that doesn't work
right now. and because libnl isn't part of the platform API, there's
no correct version version check for you to use. some OEMs may have
have that function longer than others; some may still not have it.
saying that libnl 2.0 is a prerequisite and your project won't build
without it sounds perfectly reasonable to me.

if this is really the only thing preventing your project from working
with libnl_2 though, why don't we just add it?

-- 
Elliott Hughes - http://who/enh - http://jessies.org/~enh/
Android native code/tools questions? Mail me/drop by/add me as a reviewer.
