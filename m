Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37442 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755474AbcIRMth (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Sep 2016 08:49:37 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, Nicolai Stange <nicstange@gmail.com>,
        Ben Greear <greearb@candelatech.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 2/4] carl9170: fix debugfs crashes
Date: Sun, 18 Sep 2016 14:49:33 +0200
Message-ID: <2731122.i7AxIUFRZe@debian64> (sfid-20160918_144949_967479_F03F0105)
In-Reply-To: <20160918101455.GA8410@kroah.com>
References: <48411543620969bebb37a1a9ea7b8f451cdfdd31.1474140477.git.chunkeey@gmail.com> <87d1k17idx.fsf@kamboji.qca.qualcomm.com> <20160918101455.GA8410@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, September 18, 2016 12:14:55 PM CEST Greg KH wrote:
> On Sun, Sep 18, 2016 at 10:54:18AM +0300, Kalle Valo wrote:
> > Greg KH <gregkh@linuxfoundation.org> writes:
> > 
> > > On Sat, Sep 17, 2016 at 09:43:02PM +0200, Christian Lamparter wrote:
> > >> Ben Greear reported:
> > >> > I see lots of instability as soon as I load up the carl9710 NIC.
> > >> > My application is going to be poking at it's debugfs files...
> > >> >
> > >> > BUG: KASAN: slab-out-of-bounds in carl9170_debugfs_read+0xd5/0x2a0
> > >> > [carl9170] at addr ffff8801bc1208b0
> > >> > Read of size 8 by task btserver/5888
> > >> > =======================================================================
> > >> > BUG kmalloc-256 (Tainted: G        W      ): kasan: bad access detected
> > >> > -----------------------------------------------------------------------
> > >> >
> > >> > INFO: Allocated in seq_open+0x50/0x100 age=2690 cpu=2 pid=772
> > >> >...
> > >> 
> > >> This breakage was caused by the introduction of intermediate
> > >> fops in debugfs by commit 9fd4dcece43a
> > >> ("debugfs: prevent access to possibly dead file_operations at file open")
> > >
> > > Because of this, these should all be backported to 4.7-stable, and
> > > 4.8-stable, right?
Ok, only b43legacy has debugfs enabled by default. For b43 and carl9170 
debugfs support is usually disabled.

Greg, would you take these four patches "as is" for -stable
or do you want a "minimal version" which just replaces the

dfops = container_of(file->f_op, ...

with

dfops = container_of(file->f_path.dentry->d_fsdata, ...

in the three drivers for -stable?

> > Via which tree should these go, Greg's or mine?
> 
> I'll take it if you ack it, as it's a debugfs issue.
For carl9170: Ben Greear has reported:
"I have verified this fixes my problem in the 4.7 kernel."

But this was with a preliminary/minimal version so I didn't
add the tested-by tag.

As for b43, I'll see if I have a working b43 in my collection
somewhere to confirm the issue and the fix. Question is, do
you want to wait or not?

Regards,
Christian
