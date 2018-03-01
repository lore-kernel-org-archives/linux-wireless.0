Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53282 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966650AbeCAJal (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 04:30:41 -0500
Message-ID: <1519896638.2292.7.camel@sipsolutions.net> (sfid-20180301_103150_382055_50446BBA)
Subject: Re: KASAN: use-after-free Read in mac80211_hwsim_del_radio
From: Johannes Berg <johannes@sipsolutions.net>
To: syzbot <syzbot+70ce058e01259de7bb1d@syzkaller.appspotmail.com>,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Date: Thu, 01 Mar 2018 10:30:38 +0100
In-Reply-To: <001a113ecf342db684056655e097@google.com> (sfid-20180301_094507_144777_9C69AA6F)
References: <001a113ecf342db684056655e097@google.com>
         (sfid-20180301_094507_144777_9C69AA6F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> syzbot hit the following crash on upstream commit
> f3afe530d644488a074291da04a69a296ab63046 (Tue Feb 27 22:02:39 2018 +0000)
> Merge branch 'fixes-v4.16-rc4' of  
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security
> 
> So far this crash happened 4 times on upstream.
> Unfortunately, I don't have any reproducer for this crash yet.
> Raw console output is attached.

That's ... a pretty complex scenario.

Looks like we have a race between destroying a network namespace, which
moves everything back into the init_ns and may have to rename objects
asynchronously (cleanup_net), with destroying the radio in hwsim that's
also asynchronous (destroy_radio).

Benjamin, would you be able to take a look at this? I'm preparing for a
trip and will leave Saturday for a week so I don't think I'll be able
to really dig into this before mid-March.

johannes
