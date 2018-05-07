Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:58908 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752315AbeEGInN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 04:43:13 -0400
Message-ID: <1525682589.6049.4.camel@sipsolutions.net> (sfid-20180507_104333_108027_A575ECA4)
Subject: Re: WARNING in kernfs_add_one
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg KH <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org,
        syzbot <syzbot+df47f81c226b31d89fb1@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tj@kernel.org
Date: Mon, 07 May 2018 10:43:09 +0200
In-Reply-To: <20180505220721.GA10829@kroah.com> (sfid-20180506_000758_042156_C31EA22A)
References: <0000000000000390eb056b77596d@google.com>
         <20180505164041.GD7746@kroah.com>
         <095bc684-0029-0b2e-5e28-23376174ca02@gmail.com>
         <20180505220721.GA10829@kroah.com> (sfid-20180506_000758_042156_C31EA22A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-05-05 at 15:07 -0700, Greg KH wrote:

> > > > syzbot found the following crash on:

Maybe it should learn to differentiate warnings, if it's going to set
panic_on_warn :-)

I get why, but still, at least differentiating in the emails wouldn't be
bad.

> > > > kernfs: ns required in 'ieee80211' for 'phy3'

Huh. What does that even mean?

> > > > RIP: 0010:kernfs_add_one+0x406/0x4d0 fs/kernfs/dir.c:758
> > > > RSP: 0018:ffff8801ca9eece0 EFLAGS: 00010286
> > > > RAX: 000000000000002d RBX: ffffffff87d5cee0 RCX: ffffffff8160ba7d
> > > > RDX: 0000000000000000 RSI: ffffffff81610731 RDI: ffff8801ca9ee840
> > > > RBP: ffff8801ca9eed20 R08: ffff8801d9538500 R09: 0000000000000006
> > > > R10: ffff8801d9538500 R11: 0000000000000000 R12: ffff8801ad1cb6c0
> > > > R13: ffffffff885da640 R14: 0000000000000020 R15: 0000000000000000
> > > >  kernfs_create_link+0x112/0x180 fs/kernfs/symlink.c:41
> > > >  sysfs_do_create_link_sd.isra.2+0x90/0x130 fs/sysfs/symlink.c:43
> > > >  sysfs_do_create_link fs/sysfs/symlink.c:79 [inline]
> > > >  sysfs_create_link+0x65/0xc0 fs/sysfs/symlink.c:91
> > > >  device_add_class_symlinks drivers/base/core.c:1612 [inline]
> > > >  device_add+0x7a0/0x16d0 drivers/base/core.c:1810
> > > >  wiphy_register+0x178a/0x2430 net/wireless/core.c:806
> > > >  ieee80211_register_hw+0x13cd/0x35d0 net/mac80211/main.c:1047
> > > >  mac80211_hwsim_new_radio+0x1d9b/0x3410
> > > > drivers/net/wireless/mac80211_hwsim.c:2772
> > > >  hwsim_new_radio_nl+0x7a7/0xa60 drivers/net/wireless/mac80211_hwsim.c:3246
> > > >  genl_family_rcv_msg+0x889/0x1120 net/netlink/genetlink.c:599

Basically we're creating a new virtual radio, which in turn creates a
new device, which we have to register.

Something is going on with the context here that makes sysfs unhappy,
but TBH I have no idea what.

johannes
