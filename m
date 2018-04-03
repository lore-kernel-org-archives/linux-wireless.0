Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53868 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932101AbeDCMeK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 08:34:10 -0400
Message-ID: <1522758845.2961.3.camel@sipsolutions.net> (sfid-20180403_143438_119148_64DE2FD1)
Subject: Re: WARNING in add_uevent_var
From: Johannes Berg <johannes@sipsolutions.net>
To: syzbot <syzbot+230d9e642a85d3fec29c@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Date: Tue, 03 Apr 2018 14:34:05 +0200
In-Reply-To: <000000000000a010b80568d75018@google.com> (sfid-20180402_080105_275284_9D0A53D3)
References: <000000000000a010b80568d75018@google.com>
         (sfid-20180402_080105_275284_9D0A53D3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2018-04-01 at 23:01 -0700, syzbot wrote:

> So far this crash happened 5 times on net-next, upstream.
> C reproducer: https://syzkaller.appspot.com/x/repro.c?id=6614377067184128
> 

Huh, fun. Looks like you're basically creating a new HWSIM radio with an
insanely long name (4k!) and nothing stops you, until we try to generate
an rfkill instance which sends a uevent and only has a 2k buffer for the
environment variables, where we put the name ...

But yeah, we should probably limit the phy name to something sane, I'll
pick 128 and send a patch.

johannes
