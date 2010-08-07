Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59684 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab0HGTEw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 15:04:52 -0400
Received: by bwz3 with SMTP id 3so557261bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 Aug 2010 12:04:51 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Odd BUG on wireless-testing master-2010-08-05
Date: Sat, 7 Aug 2010 21:04:43 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <AANLkTinwbLXVHmC9eUczoe-ntT=adyFFx6C6Q=GcBc79@mail.gmail.com> <20100806135057.GA2753@tuxdriver.com> <AANLkTi=Q6K1xeDn6zmBD5co5aMgvDMyUqGE3vLoo4_2+@mail.gmail.com>
In-Reply-To: <AANLkTi=Q6K1xeDn6zmBD5co5aMgvDMyUqGE3vLoo4_2+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201008072104.43784.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 06 August 2010 21:05:05 Luis R. Rodriguez wrote:
> On Fri, Aug 6, 2010 at 6:50 AM, John W. Linville <linville@tuxdriver.com> wrote:
> > On Thu, Aug 05, 2010 at 03:31:06PM -0700, Luis R. Rodriguez wrote:
> >> I just ran into this. My first load of master-2010-08-05 was fine but
> >> I started getting a lot of disconnects on AR9003 hardware after a
> >> period of RX'ing data over an encrypted legacy network. Instead of
> >> checking dmesg I just rebooted though. After that I connected to the
> >> same AP again, started Rx'ing for a while and then shortly got this:
> >>
> >>
> >> [  818.749585] BUG: unable to handle kernel paging request at 00003f3f00000000
> >> [  818.749594] IP: [<ffffffff814ee0d8>] unix_stream_recvmsg+0x3f8/0x790
> >
> >> After a reboot I got a hard hang which I could not capture any logs
> >> for. I rebooted and am up now but not seeing these issues yet. John,
> >> does this smell like what you were seeing or is this different?
> >
> > Yeah, I'm seeing that too.  There is some netdev stuff in
> > wireless-testing at the moment that I suspect was undercooked...
> >
> > Sorry for the inconvenience while this gets sorted-out!
> 
> Ah no problem, just wanted to see if I should dig into ath9k or not,
> sounds like I don't. FWIW I had a hang overnight as well.
> 
>   Luis
> --

I got this from slub_debug:

[ 2857.899976] phy2: device now idle
[ 2857.904032] =============================================================================
[ 2857.909760] cfg80211: Calling CRDA to update world regulatory domain
[ 2857.917337] BUG kmalloc-4096: Object already free
[ 2857.917337] -----------------------------------------------------------------------------
[ 2857.917337] 
[ 2857.917337] INFO: Allocated in wireless_send_event+0x22a/0x34a age=4 cpu=1 pid=7527
[ 2857.917337] INFO: Freed in __kfree_skb+0x11/0x73 age=4 cpu=0 pid=14852
[ 2857.917337] INFO: Slab 0xffffea0002512e80 objects=7 used=5 fp=0xffff8800a97b0000 flags=0x40000000000040c3
[ 2857.917337] INFO: Object 0xffff8800a97b0000 @offset=0 fp=0xffff8800a97b1048
[ 2857.917337] 
[ 2857.917337]   Object 0xffff8800a97b0000:  6b 6b 6b 6b 6b 6b [...]
[ 2857.917337] Pid: 9472, comm: avahi-daemon Tainted: P         C  2.6.35-wl+ #3
[ 2857.917337] Call Trace:
[ 2857.917337]  [<ffffffff810971f0>] ? __slab_free+0x27a/0x34e
[ 2857.917337]  [<ffffffff810983f9>] ? kfree+0x94/0x9a
[ 2857.917337]  [<ffffffff812fe93c>] ? __kfree_skb+0x11/0x73
[ 2857.917337]  [<ffffffff8131f126>] ? netlink_recvmsg+0xd5/0x377
[ 2857.917337]  [<ffffffff810ab63a>] ? pollwake+0x0/0x4e
[ 2857.917337]  [<ffffffff812f690a>] ? sock_recvmsg+0xc9/0xe6
[ 2857.917337]  [<ffffffff810ab63a>] ? pollwake+0x0/0x4e
[ 2857.917337]  [<ffffffff810ab63a>] ? pollwake+0x0/0x4e
[ 2857.917337]  [<ffffffff81300a74>] ? verify_iovec+0x46/0x82
[ 2857.917337]  [<ffffffff812f7cc0>] ? __sys_recvmsg+0x138/0x20e
[ 2857.917337]  [<ffffffff812f8ef9>] ? sock_ioctl+0x1f3/0x1fc
[ 2857.917337]  [<ffffffff810a9552>] ? vfs_ioctl+0x23/0x93
[ 2857.917337]  [<ffffffff81048075>] ? ktime_get_ts+0x66/0xab
[ 2857.917337]  [<ffffffff812f803b>] ? sys_recvmsg+0x39/0x5b
[ 2857.917337]  [<ffffffff81001f2b>] ? system_call_fastpath+0x16/0x1b
[ 2857.917337] FIX kmalloc-4096: Object at 0xffff8800a97b0000 not freed

It looks somewhat similar to Luis bug-report, but it would point to a
double-free bug in cfg80211?!
