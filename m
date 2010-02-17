Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f191.google.com ([209.85.216.191]:39696 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933772Ab0BQApr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 19:45:47 -0500
Received: by pxi29 with SMTP id 29so2228368pxi.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2010 16:45:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e891002161459m4174654aj8d7985f32cb8678d@mail.gmail.com>
References: <43e72e891002121810g25d21eb5y254969458a9a58e7@mail.gmail.com>
	<1266124222.13902.42.camel@mj> <43e72e891002161323v70636defr2500784ffb44d775@mail.gmail.com>
	<1266358340.2659.37.camel@mj> <43e72e891002161459m4174654aj8d7985f32cb8678d@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 16 Feb 2010 16:45:25 -0800
Message-ID: <43e72e891002161645p627c123g9ac571e4802cd8bf@mail.gmail.com>
Subject: Re: compat-wireless + Linux 2.6.26.8 testing results
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 16, 2010 at 2:59 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, Feb 16, 2010 at 2:12 PM, Pavel Roskin <proski@gnu.org> wrote:
>> On Tue, 2010-02-16 at 13:23 -0800, Luis R. Rodriguez wrote:
>>
>>> > It looks like compat-wireless-2.6.33-rc8 and compat-wireless-2010-02-13
>>> > don't have the patches to deal with the lack of netif_tx_wake_queue and
>>> > select_queue in Linux 2.6.26.  compat-wireless-2.6.32.8 has such
>>> > patches.
>>>
>>> Oh right, so I was hoping to get some reports on results of MQ
>>> backport on 2.6.32.y, I guess its OK enough to merge now and if its
>>> borked we can remove older kernel support or something.
>>
>> I confirm that ath5k and ath9k actually work on that kernel, so the
>> results are good.
>
> Sweet!

Hey OK so I propagated MQ support into compat-wireless based on
linux-next. I just hit a snag I forgot about and explains more
logically why I hadn't moved MQ support to bleeding edge:
debugfs_remove_recursive() needs some backport work as well. Last I
looked at it, I determined we could not directly backport it as it
relied on two internal globals on fs/debugfs/inode.c. I did copy over
the code onto compat/compat-2.6.26.c but ifdef'd it out for now.

One option is to disable debugfs on compat-wireless for older kernels
or if you figure out a way to backport that call without using a
global even better. For now I just can't work on this but I do welcome
patches if someone manages to pull off backporting it.

  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/rate.o
/home/mcgrof/devel/compat-wireless-2.6/net/mac80211/rate.c: In
function ‘rate_control_release’:
/home/mcgrof/devel/compat-wireless-2.6/net/mac80211/rate.c:190: error:
implicit declaration of function ‘debugfs_remove_recursive’
make[3]: *** [/home/mcgrof/devel/compat-wireless-2.6/net/mac80211/rate.o]
Error 1
make[2]: *** [/home/mcgrof/devel/compat-wireless-2.6/net/mac80211] Error 2
make[1]: *** [_module_/home/mcgrof/devel/compat-wireless-2.6] Error 2
make[1]: Leaving directory `/home/mcgrof/kernels/linux-2.6.26.8'

  Luis
