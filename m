Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41997 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab2GJRb4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 13:31:56 -0400
Received: by pbbrp8 with SMTP id rp8so570587pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2012 10:31:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFub=KREsMQiY7Qo6e+KMFgzLvD7dQ5KJNKASOb3eiQL9uSFXw@mail.gmail.com>
References: <1341845663-24539-1-git-send-email-ozancag@gmail.com>
 <CAB=NE6UF57isp+z4j3c0JNyTKHKfUsbU1UhMYKbZdGfEaeLn3w@mail.gmail.com> <CAFub=KREsMQiY7Qo6e+KMFgzLvD7dQ5KJNKASOb3eiQL9uSFXw@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 10 Jul 2012 10:31:36 -0700
Message-ID: <CAB=NE6X75euFm_h-EAENhrx3t6H+jc_U99MscK+ELQbJk_m4Uw@mail.gmail.com> (sfid-20120710_193200_547842_B6A08149)
Subject: Re: [RFC] compat: Add ability to run as non-root
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 10, 2012 at 5:21 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
>>
>>> or ckmake with 'sudo'.
>>
>> How about instead having ckmake detect first if you have your
>> $HOME/ksrc/ and if so use that, otherwise go with the built in stuff ?
>
> This way, if you do not have $HOME/ksrc (which is the case when you
> first run get-compat-kernels on a clean system), you will fallback to
> the case where the script downloads and extracts the debs into
> /usr/src which will again make sure that you will not have $HOME/ksrc
> in the next run. How will we populate $HOME/ksrc?

What if get-compat-kernels runs differently depending on what user
runs it: if you are root, stuff into /usr/src, otherwise $HOME/ksrc/.
Then ckmake will simply check if $HOME/ksrc/ is there and use that if
its there, otherwise it will simply use whatever kernel headers you
have in place in /usr/src -- this is regardless of whether or not you
used get-compat-kernels as root or never used it at all.

  Luis
