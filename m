Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:38479 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbYK0BEq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 20:04:46 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 17:04:46 -0800
Date: Wed, 26 Nov 2008 17:04:43 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Andrey Vul <andrey.vul@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: cannot compile compat-wireless-2.6-old
Message-ID: <20081127010443.GC13226@tesla> (sfid-20081127_020451_774172_07D76456)
References: <e38d12ff0811250953p4dca0fe2kbc378f0184d4d4fa@mail.gmail.com> <e38d12ff0811250957y16078303g8f8346d60c92ff4c@mail.gmail.com> <20081125203244.GD5950@tesla> <e38d12ff0811251330x2b2d9a35h608b1619441f1252@mail.gmail.com> <e38d12ff0811251651k32a66cd5r3de7f1d504b4723@mail.gmail.com> <20081126173453.GC6515@tesla> <e38d12ff0811261554o1a918853x21bc192e8488be85@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <e38d12ff0811261554o1a918853x21bc192e8488be85@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 26, 2008 at 03:54:14PM -0800, Andrey Vul wrote:
> On Wed, Nov 26, 2008 at 12:34, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
> > On Tue, Nov 25, 2008 at 04:51:48PM -0800, Andrey Vul wrote:
> >> On Tue, Nov 25, 2008 at 16:30, Andrey Vul <andrey.vul@gmail.com> wrote:
> >> > On Tue, Nov 25, 2008 at 15:32, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
> >> >> On Tue, Nov 25, 2008 at 09:57:57AM -0800, Andrey Vul wrote:
> >> >>> I cannot compile the current compat tarball.
> >> >>> Make log:
> >> >>> ./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
> >> >>> make -C /usr/src/linux-2.6.26.6-rt11/ M=/root/compat-wireless-2.6-old modules
> >> >>> make[1]: Entering directory `/usr/src/linux-2.6.26.6-rt11'
> >> >>>  CC [M]  /root/compat-wireless-2.6-old/drivers/net/wireless/mac80211_hwsim.o
> >> >>> In file included from <command-line>:0:
> >> >>> /root/compat-wireless-2.6-old/include/net/compat.h:877: error:
> >> >>> redefinition of 'list_splice_tail'
> >> >>> include/linux/list.h:356: error: previous definition of
> >> >>> 'list_splice_tail' was here
> >> >>> /root/compat-wireless-2.6-old/include/net/compat.h:892: error:
> >> >>> redefinition of 'list_splice_tail_init'
> >> >>> include/linux/list.h:379: error: previous definition of
> >> >>> 'list_splice_tail_init' was here
> >> >>
> >> >> list_splice_tail was added as of 2.6.27, and you have 2.6.26. Which
> >> >> means your kernel headers for your box are completely messed up. This
> >> >> means you can expect a kernel panic if you were to successfully
> >> >> compile external modules. Go fix that first.
> >> >>
> >> I have $(uname -r)/include/linux/list.h containing list_splice_tail,
> >> where uname -r is 2.6.26.5-rt9.
> >> Frankly, I need rt and the code for my wifi card is only in the compat tarball.
> >> Is this a problem with .[56] or with -rt?
> >
> > Ah, yeah RT had their own list_splice_tail(), try this. BTW what driver
> > are you going to be using?
> >
> 
> I'm going to be using iwl5000 which depends on iwlwifi, iwlcore,
> iwlwifi-leds, and iwlwifi-rfkill .
> 
> So, in short, all I have to do is this?
> #!/bin/bash
> for a in `find ~/compat-wireless-2.6-old -name '*.c' -or -name '*.h'`; do
> sed -e 's/list_splice_tail/list_splice_tail27/' -i $a;
> done
> 
> The only thing I see as possibly problematic is
> list_splice_tail27_init() (sed is regex after all).

Yup, but since there are some RT 2.6.26 kernels out there if we want
this fixed in compat-wireless-old I'd rather apply a patch there too.
Anyway list_splice_tail() is only used for ath9k.

  Luis
