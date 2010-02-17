Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40056 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933425Ab0BQAva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 19:51:30 -0500
Received: by pwj8 with SMTP id 8so1017288pwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2010 16:51:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e891002161645p627c123g9ac571e4802cd8bf@mail.gmail.com>
References: <43e72e891002121810g25d21eb5y254969458a9a58e7@mail.gmail.com>
	<1266124222.13902.42.camel@mj> <43e72e891002161323v70636defr2500784ffb44d775@mail.gmail.com>
	<1266358340.2659.37.camel@mj> <43e72e891002161459m4174654aj8d7985f32cb8678d@mail.gmail.com>
	<43e72e891002161645p627c123g9ac571e4802cd8bf@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 16 Feb 2010 16:51:09 -0800
Message-ID: <43e72e891002161651w4718431dqaf258151241f72fc@mail.gmail.com>
Subject: Re: compat-wireless + Linux 2.6.26.8 testing results
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 16, 2010 at 4:45 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:

> Hey OK so I propagated MQ support into compat-wireless based on
> linux-next. I just hit a snag I forgot about and explains more
> logically why I hadn't moved MQ support to bleeding edge:
> debugfs_remove_recursive() needs some backport work as well. Last I
> looked at it, I determined we could not directly backport it as it
> relied on two internal globals on fs/debugfs/inode.c. I did copy over
> the code onto compat/compat-2.6.26.c but ifdef'd it out for now.
>
> One option is to disable debugfs on compat-wireless for older kernels
> or if you figure out a way to backport that call without using a
> global even better. For now I just can't work on this but I do welcome
> patches if someone manages to pull off backporting it.
>
>  CC [M]  /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/rate.o
> /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/rate.c: In
> function ‘rate_control_release’:
> /home/mcgrof/devel/compat-wireless-2.6/net/mac80211/rate.c:190: error:
> implicit declaration of function ‘debugfs_remove_recursive’
> make[3]: *** [/home/mcgrof/devel/compat-wireless-2.6/net/mac80211/rate.o]
> Error 1
> make[2]: *** [/home/mcgrof/devel/compat-wireless-2.6/net/mac80211] Error 2
> make[1]: *** [_module_/home/mcgrof/devel/compat-wireless-2.6] Error 2
> make[1]: Leaving directory `/home/mcgrof/kernels/linux-2.6.26.8'

FWIW the two globals can be seen here:

simple_release_fs(&debugfs_mount, &debugfs_mount_count);

Not sure how to deal with that.

  Luis
