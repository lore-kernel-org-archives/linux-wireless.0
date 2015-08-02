Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37949 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbbHBG5g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2015 02:57:36 -0400
Received: by wibxm9 with SMTP id xm9so77146118wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2015 23:57:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJgzZorOZ-HU2BUbWkssFzm++N-MEryxckPQRj7DyFEyMz0Jrg@mail.gmail.com>
References: <1438292115-39495-1-git-send-email-filbranden@google.com>
 <1438292115-39495-3-git-send-email-filbranden@google.com> <CA+XVXfegO1SoTkxYwT7Ne6f6eFxqEJXrvzR_ZOyz=Kso4QKUyQ@mail.gmail.com>
 <CAJgzZorOZ-HU2BUbWkssFzm++N-MEryxckPQRj7DyFEyMz0Jrg@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 2 Aug 2015 09:57:20 +0300
Message-ID: <CA+XVXffMtXYMq_hFbaeD+Q6iJ2efQOYFkMuyTYL6b39WRVtgZA@mail.gmail.com> (sfid-20150802_085740_013161_4C7A11E2)
Subject: Re: [PATCH 2/2] iw: remove android-nl.c with unneeded workaround
To: enh <enh@google.com>
Cc: Filipe Brandenburger <filbranden@google.com>,
	Johannes Berg <johannes.berg@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Christopher Wiley <wiley@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2015 at 7:01 PM, enh <enh@google.com> wrote:
> no, because this is meant for the platform build system rather than
> the NDK. although the NDK has a concept of target API level, the
> platform only has "current".

Don't you have PLATFORM_VERSION?
http://androidxref.com/5.1.1_r6/xref/build/core/version_defaults.mk

And I see it's already used in some places.

My 2c is that it's a bad idea to break older version compatibility
when Android is not the owner of the project/git. Basically you don't
really have the same level of control over where this is used.

Arik
