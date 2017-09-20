Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34250 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbdITLrj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 07:47:39 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Ganapathi Bhat <gbhat@marvell.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: Re: [PATCH 2/2] mwifiex: use get_random_mask_addr() helper
References: <1505720537-13362-1-git-send-email-gbhat@marvell.com>
        <87o9q8kuy4.fsf@purkki.adurom.net>
        <3f3f5c9672a5421db05337a00d9578f2@SC-EXCH02.marvell.com>
        <87tvzyahht.fsf@kamboji.qca.qualcomm.com>
        <20170919164316.GA4617@google.com>
Date: Wed, 20 Sep 2017 14:47:31 +0300
In-Reply-To: <20170919164316.GA4617@google.com> (Brian Norris's message of
        "Tue, 19 Sep 2017 09:43:17 -0700")
Message-ID: <87a81pa8x8.fsf@kamboji.qca.qualcomm.com> (sfid-20170920_134742_506470_EF75B83C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> writes:

> Hi,
>
> On Tue, Sep 19, 2017 at 05:30:06PM +0300, Kalle Valo wrote:
>> Ganapathi Bhat <gbhat@marvell.com> writes:
>> 
>> > Hi Kalle,
>> >> 
>> >> > Avoid calculating random MAC address in driver. Instead make use of
>> >> > 'get_random_mask_addr()' function.
>> >> >
>> >> > Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
>> >> 
>> >> I don't see 1/2 anywhere. Did it get lost?
>> >
>> > Actually there is no 1/2. What I did is: 'git send-email'; CTRL + C
>
> It's dependent on this patch though, which kinda should be '1/2':
>
> [PATCH] mwifiex: avoid storing random_mac in private

Thanks for pointing out, I'll make sure that I commit these in correct
order.

>> > (to correct a typo); and then tried sending it again. I think that
>> > created some problem here. Kindly let me know how to proceed.
>> 
>> Ok. I'll wait for review comments and if all goes well I'll apply it in
>> few days.
>
> FWIW, this looks OK to me:
>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
>
> It's just a bit strange that we have to keep our own on-stack temporary
> buffer for this. Maybe this could use an in-place helper too? Or (if
> it's really legal for us to modify the cfg80211_scan_request in-place)
> why doesn't the upper-layer nl80211 code do the randomization for us?
> Many (all?) drivers I see implementing randomization have to do this
> anyway; they don't use request->mac_addr directly. (Or I suppose some
> firmware could implement the randomization on its own someday...but
> would we really trust it?)

Good questions and I was wondering the same when looking at this patch.
But I wasn't involved in the interface design so I don't really know the
background here.

I'm planning to apply this patch anyway, any improvements can be done as
a followup patch.

-- 
Kalle Valo
