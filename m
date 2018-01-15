Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:34190 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932252AbeAOI5r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 03:57:47 -0500
Message-ID: <1516006661.410.6.camel@sipsolutions.net> (sfid-20180115_095808_008568_EA3E132D)
Subject: Re: WARNING in rfkill_alloc
From: Johannes Berg <johannes@sipsolutions.net>
To: syzbot <syzbot+1ddfb3357e1d7bb5b5d3@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Date: Mon, 15 Jan 2018 09:57:41 +0100
In-Reply-To: <089e08282cc03493040562b0079c@google.com> (sfid-20180113_233741_097318_E11B1EAC)
References: <089e08282cc03493040562b0079c@google.com>
         (sfid-20180113_233741_097318_E11B1EAC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> RIP: 0010:rfkill_alloc+0x2c0/0x380 net/rfkill/core.c:930

This seems pretty obvious - there's no name given.

>   wiphy_new_nm+0x159c/0x21d0 net/wireless/core.c:487
>   ieee80211_alloc_hw_nm+0x4b4/0x2140 net/mac80211/main.c:531

which is strange, because we try to validate the name here.

Can you help me read this?

sendmsg$nl_generic(r1, &(0x7f0000b3e000-0x38)={&(0x7f0000d4a000-
0xc)={0x10, 0x0, 0x0, 0x0}, 0xc,
&(0x7f0000007000)={&(0x7f00001ca000)={0x14, 0x1c, 0x109,
0xffffffffffffffff, 0xffffffffffffffff, {0x4, 0x0, 0x0}, []}, 0x14},
0x1, 0x0, 0x0, 0x0}, 0x0)

I've reformatted it as

sendmsg$nl_generic(
r1,
&(0x7f0000b3e000-0x38)={
addr=   &(0x7f0000d4a000-0xc)={
                0x10, 0x0, 0x0, 0x0
        },
addrlen=0xc,
vec=    &(0x7f0000007000)={
        ptr=    &(0x7f00001ca000)={
                        0x14, 0x1c, 0x109, 0xffffffffffffffff,
0xffffffffffffffff, {0x4, 0x0, 0x0}, []
                },
        len=    0x14
        },
vlen=   0x1,
ctrl=   0x0,
ctrllen=0x0,
f=      0x0
},
0x0
)

but am still getting lost - what exactly is the *byte* sequence inside
the (full) message (including headers)?


Ah, then again, now I see the fault injection - I guess dev_set_name()
just failed and we didn't check the return value, will fix that.

johannes
