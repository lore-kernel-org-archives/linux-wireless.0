Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.191]:57786 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbYKYVay (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 16:30:54 -0500
Received: by gv-out-0910.google.com with SMTP id e6so97701gvc.37
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2008 13:30:52 -0800 (PST)
Message-ID: <e38d12ff0811251330x2b2d9a35h608b1619441f1252@mail.gmail.com> (sfid-20081125_223057_901500_7130DD5F)
Date: Tue, 25 Nov 2008 16:30:51 -0500
From: "Andrey Vul" <andrey.vul@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: cannot compile compat-wireless-2.6-old
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081125203244.GD5950@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <e38d12ff0811250953p4dca0fe2kbc378f0184d4d4fa@mail.gmail.com>
	 <e38d12ff0811250957y16078303g8f8346d60c92ff4c@mail.gmail.com>
	 <20081125203244.GD5950@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 25, 2008 at 15:32, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
> On Tue, Nov 25, 2008 at 09:57:57AM -0800, Andrey Vul wrote:
>> I cannot compile the current compat tarball.
>> Make log:
>> ./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
>> make -C /usr/src/linux-2.6.26.6-rt11/ M=/root/compat-wireless-2.6-old modules
>> make[1]: Entering directory `/usr/src/linux-2.6.26.6-rt11'
>>  CC [M]  /root/compat-wireless-2.6-old/drivers/net/wireless/mac80211_hwsim.o
>> In file included from <command-line>:0:
>> /root/compat-wireless-2.6-old/include/net/compat.h:877: error:
>> redefinition of 'list_splice_tail'
>> include/linux/list.h:356: error: previous definition of
>> 'list_splice_tail' was here
>> /root/compat-wireless-2.6-old/include/net/compat.h:892: error:
>> redefinition of 'list_splice_tail_init'
>> include/linux/list.h:379: error: previous definition of
>> 'list_splice_tail_init' was here
>
> list_splice_tail was added as of 2.6.27, and you have 2.6.26. Which
> means your kernel headers for your box are completely messed up. This
> means you can expect a kernel panic if you were to successfully
> compile external modules. Go fix that first.
>
>  Luis
>

Ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooh, it
used /usr/include/* , not KLIB_BUILD/include/*

I now see what happened. I had 2.6.27 headers installed because the
default kernel was 2.6.27.
Should I have done the following: # cd KLIB_BUILD && make
headers_check && make headers_install && cp -Rv include/* /usr/include
?
-- 
Andrey Vul
