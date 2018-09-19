Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:60168 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbeITB5Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 21:57:16 -0400
Message-ID: <1537388251.10305.89.camel@sipsolutions.net> (sfid-20180919_221746_905682_6E8C1D4B)
Subject: Re: Help with ath10k related circular locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 19 Sep 2018 22:17:31 +0200
In-Reply-To: <923b8022-0e92-0ce3-4c11-baa0d6d6918b@candelatech.com> (sfid-20180919_175338_578962_EAD8E691)
References: <923b8022-0e92-0ce3-4c11-baa0d6d6918b@candelatech.com>
         (sfid-20180919_175338_578962_EAD8E691)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-09-19 at 08:53 -0700, Ben Greear wrote:
> Hello,
> 
> I see this lockdep splat on a modified 4.16.18+ kernel when the ath10k
> firmware crashes early.
> 
> I am having a hard time figuring out how to go about fixing this, and would welcome
> some suggestions.

Not really sure how to fix it - it basically means that "ath10k_wq"
contains code that acquires the RTNL:

>                                      -> #2 (rtnl_mutex){+.+.}:
> Sep 19 08:38:51 lf0313-6477 kernel:        wiphy_register+0x1120/0x1f90 [cfg80211]
> Sep 19 08:38:51 lf0313-6477 kernel:        ieee80211_register_hw+0x114e/0x2d20 [mac80211]
> Sep 19 08:38:51 lf0313-6477 kernel:        ath10k_mac_register+0x1b2f/0x2ff0 [ath10k_core]
> Sep 19 08:38:51 lf0313-6477 kernel:        ath10k_core_register_work+0x2365/0x30e0 [ath10k_core]
> Sep 19 08:38:51 lf0313-6477 kernel:        process_one_work+0x5f7/0x14d0
> Sep 19 08:38:51 lf0313-6477 kernel:        worker_thread+0xdc/0x12d0
> Sep 19 08:38:51 lf0313-6477 kernel:        kthread+0x2cf/0x3c0
> Sep 19 08:38:51 lf0313-6477 kernel:        ret_from_fork+0x24/0x30

but something on the workqueue is also flushed while holding rtnl.

The solution might be as simple as making it not be an ordered/single-
threaded workqueue (which can spawn extra threads if needed), but I
don't know how it's used.


Then again, ath10k_stop() only calls cancel_work_sync() and
cancel_delayed_work_sync() ... which I think means you're running into
the lockdep annotation bug I fixed recently!

See upstream commits
87915adc3f0ac ("workqueue: re-add lockdep dependencies for flushing")
d6e89786bed97 ("workqueue: skip lockdep wq dependency in cancel_work_sync()")

johannes
