Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:46080 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932252AbeAOJAo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 04:00:44 -0500
Received: by mail-pg0-f51.google.com with SMTP id s9so5837794pgq.13
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jan 2018 01:00:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1516004561.410.3.camel@sipsolutions.net>
References: <94eb2c05e11e2f85150562b007ef@google.com> <1516004561.410.3.camel@sipsolutions.net>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 15 Jan 2018 10:00:23 +0100
Message-ID: <CACT4Y+Yz2k+micpzkHwrcdssBWmdn=qmjytbyDFxVTv9Mgo-fw@mail.gmail.com> (sfid-20180115_100108_845178_0944AF14)
Subject: Re: WARNING in wiphy_register
To: Johannes Berg <johannes@sipsolutions.net>
Cc: syzbot <syzbot+8dd9051ff19940290931@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 15, 2018 at 9:22 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi syzbot maintainers,
>
> Thanks for the report.
>
>>   hwsim_new_radio_nl+0x5b7/0x7c0 drivers/net/wireless/mac80211_hwsim.c:3152
>>   genl_family_rcv_msg+0x7b7/0xfb0 net/netlink/genetlink.c:599
>>   genl_rcv_msg+0xb2/0x140 net/netlink/genetlink.c:624
>
> You're getting into the kernel via generic netlink receive, so just as
> an FYI - the generic netlink numbers aren't stable across systems, so
> your reproducer has a quite good chance of not working without your
> kernel .config and (virt) hardware environment.

Hi Johannes,

Thanks for the feeback.
syzbot tests within a net namespace (which is free of eth0 and other
stuff) and does setup of devices in that namespace. For bugs, it first
tries to reproduce them in that environment and if that succeeds it
tries to simplify the reproducer by stripping namespace/device setup
(which is quite verbose), and if that succeeds it provides this
simplified reproducer.
In this case it decided that namespace setup is not important. .config
is still important, but it is provided.

Are you able to reproduce the WARNING with the provided config? If
not, we can look as to how to improve this.


> I'll take a look at this and the rfkill one, I assume that there are
> some sanity checks missing in hwsim generic netlink when it builds a
> radio struct.
>
> However, I can't really promise that I'll be able to validate the
> changes against your reproducer.
>
> johannes
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/1516004561.410.3.camel%40sipsolutions.net.
> For more options, visit https://groups.google.com/d/optout.
