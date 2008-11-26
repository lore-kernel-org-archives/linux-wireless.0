Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48593 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYKZAvv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 19:51:51 -0500
Received: by ug-out-1314.google.com with SMTP id 39so1260397ugf.37
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2008 16:51:49 -0800 (PST)
Message-ID: <e38d12ff0811251651k32a66cd5r3de7f1d504b4723@mail.gmail.com> (sfid-20081126_015154_469123_B37B3D82)
Date: Tue, 25 Nov 2008 19:51:48 -0500
From: "Andrey Vul" <andrey.vul@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: cannot compile compat-wireless-2.6-old
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <e38d12ff0811251330x2b2d9a35h608b1619441f1252@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <e38d12ff0811250953p4dca0fe2kbc378f0184d4d4fa@mail.gmail.com>
	 <e38d12ff0811250957y16078303g8f8346d60c92ff4c@mail.gmail.com>
	 <20081125203244.GD5950@tesla>
	 <e38d12ff0811251330x2b2d9a35h608b1619441f1252@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 25, 2008 at 16:30, Andrey Vul <andrey.vul@gmail.com> wrote:
> On Tue, Nov 25, 2008 at 15:32, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
>> On Tue, Nov 25, 2008 at 09:57:57AM -0800, Andrey Vul wrote:
>>> I cannot compile the current compat tarball.
>>> Make log:
>>> ./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
>>> make -C /usr/src/linux-2.6.26.6-rt11/ M=/root/compat-wireless-2.6-old modules
>>> make[1]: Entering directory `/usr/src/linux-2.6.26.6-rt11'
>>>  CC [M]  /root/compat-wireless-2.6-old/drivers/net/wireless/mac80211_hwsim.o
>>> In file included from <command-line>:0:
>>> /root/compat-wireless-2.6-old/include/net/compat.h:877: error:
>>> redefinition of 'list_splice_tail'
>>> include/linux/list.h:356: error: previous definition of
>>> 'list_splice_tail' was here
>>> /root/compat-wireless-2.6-old/include/net/compat.h:892: error:
>>> redefinition of 'list_splice_tail_init'
>>> include/linux/list.h:379: error: previous definition of
>>> 'list_splice_tail_init' was here
>>
>> list_splice_tail was added as of 2.6.27, and you have 2.6.26. Which
>> means your kernel headers for your box are completely messed up. This
>> means you can expect a kernel panic if you were to successfully
>> compile external modules. Go fix that first.
>>
I have $(uname -r)/include/linux/list.h containing list_splice_tail,
where uname -r is 2.6.26.5-rt9.
Frankly, I need rt and the code for my wifi card is only in the compat tarball.
Is this a problem with .[56] or with -rt?

-- 
Andrey Vul
