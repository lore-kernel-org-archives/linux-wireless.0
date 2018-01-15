Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f43.google.com ([209.85.160.43]:34333 "EHLO
        mail-pl0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932230AbeAOJM1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 04:12:27 -0500
Received: by mail-pl0-f43.google.com with SMTP id d21so3240574pll.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jan 2018 01:12:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1516006661.410.6.camel@sipsolutions.net>
References: <089e08282cc03493040562b0079c@google.com> <1516006661.410.6.camel@sipsolutions.net>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 15 Jan 2018 10:12:06 +0100
Message-ID: <CACT4Y+aO8kwS+ketv3rr0x3EecZ6j+7ep8Ag6PuTirO00SqRtw@mail.gmail.com> (sfid-20180115_101311_424928_B75D9CEC)
Subject: Re: WARNING in rfkill_alloc
To: Johannes Berg <johannes@sipsolutions.net>
Cc: syzbot <syzbot+1ddfb3357e1d7bb5b5d3@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 15, 2018 at 9:57 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi,
>
>> RIP: 0010:rfkill_alloc+0x2c0/0x380 net/rfkill/core.c:930
>
> This seems pretty obvious - there's no name given.
>
>>   wiphy_new_nm+0x159c/0x21d0 net/wireless/core.c:487
>>   ieee80211_alloc_hw_nm+0x4b4/0x2140 net/mac80211/main.c:531
>
> which is strange, because we try to validate the name here.
>
> Can you help me read this?
>
> sendmsg$nl_generic(r1, &(0x7f0000b3e000-0x38)={&(0x7f0000d4a000-
> 0xc)={0x10, 0x0, 0x0, 0x0}, 0xc,
> &(0x7f0000007000)={&(0x7f00001ca000)={0x14, 0x1c, 0x109,
> 0xffffffffffffffff, 0xffffffffffffffff, {0x4, 0x0, 0x0}, []}, 0x14},
> 0x1, 0x0, 0x0, 0x0}, 0x0)
>
> I've reformatted it as
>
> sendmsg$nl_generic(
> r1,
> &(0x7f0000b3e000-0x38)={
> addr=   &(0x7f0000d4a000-0xc)={
>                 0x10, 0x0, 0x0, 0x0
>         },
> addrlen=0xc,
> vec=    &(0x7f0000007000)={
>         ptr=    &(0x7f00001ca000)={
>                         0x14, 0x1c, 0x109, 0xffffffffffffffff,
> 0xffffffffffffffff, {0x4, 0x0, 0x0}, []
>                 },
>         len=    0x14
>         },
> vlen=   0x1,
> ctrl=   0x0,
> ctrllen=0x0,
> f=      0x0
> },
> 0x0
> )
>
> but am still getting lost - what exactly is the *byte* sequence inside
> the (full) message (including headers)?

Hi,

I think you decoded it correctly. The netlink message is:

{0x14, 0x1c, 0x109, 0xffffffffffffffff, 0xffffffffffffffff, {0x4, 0x0, 0x0}, []}

0x14 length, 0x1c is type, etc

These numbers are input data for there descriptions:
https://github.com/google/syzkaller/blob/master/sys/linux/socket_netlink.txt
which generally match C structures as you expect.

However, there can be some surprising things, for example, executing
one ioctl/setsockopt with data meant for another one, or these
0xffffffffffffffff are actually mean 0 (for involved reasons), or we
can simply have bugs in these descriptions so they don't match C
structures and then all data is messed/shifted.

If this representation does not make sense to you right away, your
best bet is looking at/running the C reproducer where you can see true
data layout:

  *(uint64_t*)0x20b3dfc8 = 0x20d49ff4;
  *(uint32_t*)0x20b3dfd0 = 0xc;
  *(uint64_t*)0x20b3dfd8 = 0x20007000;
  *(uint64_t*)0x20b3dfe0 = 1;
  *(uint64_t*)0x20b3dfe8 = 0;
  *(uint64_t*)0x20b3dff0 = 0;
  *(uint32_t*)0x20b3dff8 = 0;
  *(uint16_t*)0x20d49ff4 = 0x10;
  *(uint16_t*)0x20d49ff6 = 0;
  *(uint32_t*)0x20d49ff8 = 0;
  *(uint32_t*)0x20d49ffc = 0;
  *(uint64_t*)0x20007000 = 0x201ca000;
  *(uint64_t*)0x20007008 = 0x14;
  *(uint32_t*)0x201ca000 = 0x14;
  *(uint16_t*)0x201ca004 = 0x1c;
  *(uint16_t*)0x201ca006 = 0x109;
  *(uint32_t*)0x201ca008 = 0;
  *(uint32_t*)0x201ca00c = 0;
  *(uint8_t*)0x201ca010 = 4;
  *(uint8_t*)0x201ca011 = 0;
  *(uint16_t*)0x201ca012 = 0;
  syscall(__NR_sendmsg, r[1], 0x20b3dfc8, 0);


> Ah, then again, now I see the fault injection - I guess dev_set_name()
> just failed and we didn't check the return value, will fix that.

Yes, it's highly likely the root cause. The raw.log file shows there
there was an immediately preceding fault in kmalloc in the same
process, in a close stack.
