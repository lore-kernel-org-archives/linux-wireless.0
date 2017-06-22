Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51188 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752188AbdFVKCg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 06:02:36 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: net_device::destructor patch for brcmfmac
References: <3f81fbd3-2896-2b09-1d59-ae5ec88045c9@broadcom.com>
        <1498124992.2246.6.camel@sipsolutions.net>
Date: Thu, 22 Jun 2017 13:02:30 +0300
In-Reply-To: <1498124992.2246.6.camel@sipsolutions.net> (Johannes Berg's
        message of "Thu, 22 Jun 2017 11:49:52 +0200")
Message-ID: <871sqctk5l.fsf@kamboji.qca.qualcomm.com> (sfid-20170622_120240_435287_087368F6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2017-06-22 at 11:45 +0200, Arend van Spriel wrote:
>> Hi Kalle,
>> 
>> I have a fix for brcmfmac, which is related to a change Dave made in
>> struct net_device, ie. commit cf124db566e6 ("net: Fix inconsistent
>> teardown and release of private netdev state.").

Is there a report from users or is this more like a theoretical issue?

We are quite late in 4.12 cycle so I would prefer to push this via
wireless-drivers-next and stable tree to 4.12.x, unless it's really
critical of course.

>> This change is not in wireless-drivers-next, but it is in
>> mac80211-next and thus in wireless-testing. What should I do? Submit
>> to net-next, or mac80211-next, or will you merge net-next into
>> wireless-drivers-next?
>
> Actually, it's even in *net* I believe, so you should submit it to
> there, or Kalle should integrate (fast-forward, rebase?) that into
> wireless-drivers.

My plan is to send a pull request to Dave this week still (unless
Midsummer celebrations last too long, knowing Finland's weather that's
unlikely) and I could fast forward then. I have also other patches
waiting for stuff in net-next.

Arend, I think the best is that you use wireless-testing as baseline and
clearly document what commit your patch depends on. Once I have fast
forwarded wireless-drivers-next to latest net-next it _should_ apply
just fine.

-- 
Kalle Valo
