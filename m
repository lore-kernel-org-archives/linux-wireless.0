Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:48742 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752597AbeENMNu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 08:13:50 -0400
Message-ID: <1526300027.8070.0.camel@sipsolutions.net> (sfid-20180514_141405_188345_F4F0EB32)
Subject: Re: WARNING in dev_vprintk_emit
From: Johannes Berg <johannes@sipsolutions.net>
To: Eric Biggers <ebiggers3@gmail.com>, linux-wireless@vger.kernel.org
Cc: syzbot <syzbot+e64565577af34b3768dc@syzkaller.appspotmail.com>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Date: Mon, 14 May 2018 14:13:47 +0200
In-Reply-To: <20180513184714.GA677@sol.localdomain> (sfid-20180513_204509_876004_C99B826F)
References: <001a113a36724a053a0562f93c05@google.com>
         <20180513184714.GA677@sol.localdomain>
         (sfid-20180513_204509_876004_C99B826F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2018-05-13 at 11:47 -0700, Eric Biggers wrote:

> The bug is that mac80211_hwsim allows creating device names that are too long,
> via HWSIM_CMD_NEW_RADIO.  Commit a7cfebcb7594a2 ("cfg80211: limit wiphy names to
> 128 bytes") limited them to 128 bytes, but it's not enough because
> dev_vprintk_emit() needs the device name plus some other stuff to not exceed 128
> bytes.  Here's a reproducer that works on Linus' tree (commit ccda3c4b777),
> provided that CONFIG_MAC80211_HWSIM=y.  Note that you'll probably need to change
> the hardcoded MAC80211_HWSIM generic netlink family ID for it to work.
> Johannes, what would you say about limiting the name length to 64 bytes instead?

Don't really have any objections - care to send a patch?

johannes
