Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:33546 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751401AbeAOIWr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 03:22:47 -0500
Message-ID: <1516004561.410.3.camel@sipsolutions.net> (sfid-20180115_092302_052016_1787874E)
Subject: Re: WARNING in wiphy_register
From: Johannes Berg <johannes@sipsolutions.net>
To: syzbot <syzbot+8dd9051ff19940290931@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Date: Mon, 15 Jan 2018 09:22:41 +0100
In-Reply-To: <94eb2c05e11e2f85150562b007ef@google.com> (sfid-20180113_233740_281154_0AEBEE6F)
References: <94eb2c05e11e2f85150562b007ef@google.com>
         (sfid-20180113_233740_281154_0AEBEE6F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi syzbot maintainers,

Thanks for the report.

>   hwsim_new_radio_nl+0x5b7/0x7c0 drivers/net/wireless/mac80211_hwsim.c:3152
>   genl_family_rcv_msg+0x7b7/0xfb0 net/netlink/genetlink.c:599
>   genl_rcv_msg+0xb2/0x140 net/netlink/genetlink.c:624

You're getting into the kernel via generic netlink receive, so just as
an FYI - the generic netlink numbers aren't stable across systems, so
your reproducer has a quite good chance of not working without your
kernel .config and (virt) hardware environment.

I'll take a look at this and the rfkill one, I assume that there are
some sanity checks missing in hwsim generic netlink when it builds a
radio struct.

However, I can't really promise that I'll be able to validate the
changes against your reproducer.

johannes
