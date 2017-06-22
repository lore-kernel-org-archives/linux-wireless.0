Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:34185 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753118AbdFVKH6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 06:07:58 -0400
Received: by mail-wr0-f169.google.com with SMTP id 77so16490769wrb.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jun 2017 03:07:57 -0700 (PDT)
Subject: Re: net_device::destructor patch for brcmfmac
To: Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <3f81fbd3-2896-2b09-1d59-ae5ec88045c9@broadcom.com>
 <1498124992.2246.6.camel@sipsolutions.net>
 <871sqctk5l.fsf@kamboji.qca.qualcomm.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <232d7915-f02e-246e-8a98-b0d07346fce5@broadcom.com> (sfid-20170622_120900_844945_D1813E83)
Date: Thu, 22 Jun 2017 12:07:54 +0200
MIME-Version: 1.0
In-Reply-To: <871sqctk5l.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 22-06-17 12:02, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
>> On Thu, 2017-06-22 at 11:45 +0200, Arend van Spriel wrote:
>>> Hi Kalle,
>>>
>>> I have a fix for brcmfmac, which is related to a change Dave made in
>>> struct net_device, ie. commit cf124db566e6 ("net: Fix inconsistent
>>> teardown and release of private netdev state.").
> 
> Is there a report from users or is this more like a theoretical issue?

Well, it a real issue but not reported by users. It only occurs when
register_netdevice() fails which does not happen often enough(?).

> We are quite late in 4.12 cycle so I would prefer to push this via
> wireless-drivers-next and stable tree to 4.12.x, unless it's really
> critical of course.

That was my idea.

>>> This change is not in wireless-drivers-next, but it is in
>>> mac80211-next and thus in wireless-testing. What should I do? Submit
>>> to net-next, or mac80211-next, or will you merge net-next into
>>> wireless-drivers-next?
>>
>> Actually, it's even in *net* I believe, so you should submit it to
>> there, or Kalle should integrate (fast-forward, rebase?) that into
>> wireless-drivers.
> 
> My plan is to send a pull request to Dave this week still (unless
> Midsummer celebrations last too long, knowing Finland's weather that's
> unlikely) and I could fast forward then. I have also other patches
> waiting for stuff in net-next.
> 
> Arend, I think the best is that you use wireless-testing as baseline and
> clearly document what commit your patch depends on. Once I have fast
> forwarded wireless-drivers-next to latest net-next it _should_ apply
> just fine.

That works for me. Thanks,
Arend
