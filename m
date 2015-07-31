Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:33402 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbbGaQCA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 12:02:00 -0400
Received: by oig1 with SMTP id 1so6712051oig.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2015 09:02:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfegO1SoTkxYwT7Ne6f6eFxqEJXrvzR_ZOyz=Kso4QKUyQ@mail.gmail.com>
References: <1438292115-39495-1-git-send-email-filbranden@google.com>
 <1438292115-39495-3-git-send-email-filbranden@google.com> <CA+XVXfegO1SoTkxYwT7Ne6f6eFxqEJXrvzR_ZOyz=Kso4QKUyQ@mail.gmail.com>
From: enh <enh@google.com>
Date: Fri, 31 Jul 2015 09:01:40 -0700
Message-ID: <CAJgzZorOZ-HU2BUbWkssFzm++N-MEryxckPQRj7DyFEyMz0Jrg@mail.gmail.com> (sfid-20150731_180206_473621_8CAE46E2)
Subject: Re: [PATCH 2/2] iw: remove android-nl.c with unneeded workaround
To: Arik Nemtsov <arik@wizery.com>
Cc: Filipe Brandenburger <filbranden@google.com>,
	Johannes Berg <johannes.berg@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Christopher Wiley <wiley@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

no, because this is meant for the platform build system rather than
the NDK. although the NDK has a concept of target API level, the
platform only has "current".

On Thu, Jul 30, 2015 at 11:56 PM, Arik Nemtsov <arik@wizery.com> wrote:
> On Fri, Jul 31, 2015 at 12:35 AM, Filipe Brandenburger
> <filbranden@google.com> wrote:
>> The workaround might have been necessary in the past, however now it
>> produces the following error:
>>
>>   .../libnl.a(attr.o): multiple definition of 'nla_put_flag'
>>   .../android-nl.o: previous definition here
>>   collect2: error: ld returned 1 exit status
>
> Since this is required by earlier versions, can't you #ifdef the code
> according to version? Also for the makefile change..



-- 
Elliott Hughes - http://who/enh - http://jessies.org/~enh/
Android native code/tools questions? Mail me/drop by/add me as a reviewer.
