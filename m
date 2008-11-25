Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22137 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbYKYUcp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 15:32:45 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2008 12:32:45 -0800
Date: Tue, 25 Nov 2008 12:32:44 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Andrey Vul <andrey.vul@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: cannot compile compat-wireless-2.6-old
Message-ID: <20081125203244.GD5950@tesla> (sfid-20081125_213248_248486_21BADA04)
References: <e38d12ff0811250953p4dca0fe2kbc378f0184d4d4fa@mail.gmail.com> <e38d12ff0811250957y16078303g8f8346d60c92ff4c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <e38d12ff0811250957y16078303g8f8346d60c92ff4c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 25, 2008 at 09:57:57AM -0800, Andrey Vul wrote:
> I cannot compile the current compat tarball.
> Make log:
> ./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
> make -C /usr/src/linux-2.6.26.6-rt11/ M=/root/compat-wireless-2.6-old modules
> make[1]: Entering directory `/usr/src/linux-2.6.26.6-rt11'
>  CC [M]  /root/compat-wireless-2.6-old/drivers/net/wireless/mac80211_hwsim.o
> In file included from <command-line>:0:
> /root/compat-wireless-2.6-old/include/net/compat.h:877: error:
> redefinition of 'list_splice_tail'
> include/linux/list.h:356: error: previous definition of
> 'list_splice_tail' was here
> /root/compat-wireless-2.6-old/include/net/compat.h:892: error:
> redefinition of 'list_splice_tail_init'
> include/linux/list.h:379: error: previous definition of
> 'list_splice_tail_init' was here

list_splice_tail was added as of 2.6.27, and you have 2.6.26. Which
means your kernel headers for your box are completely messed up. This
means you can expect a kernel panic if you were to successfully
compile external modules. Go fix that first.

  Luis
