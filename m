Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37034 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751451AbdJLIiP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 04:38:15 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: Two rtlwifi drivers?
References: <20170824100832.lcmbwcjhzwlgozeh@mwanda>
        <87h8wxw4bq.fsf@kamboji.qca.qualcomm.com>
        <652d42ad-a077-530b-743f-d38ddf3ff677@lwfinger.net>
        <87k202qcjr.fsf@kamboji.qca.qualcomm.com>
        <20171011131310.GF32250@kroah.com>
Date: Thu, 12 Oct 2017 11:38:06 +0300
In-Reply-To: <20171011131310.GF32250@kroah.com> (Greg Kroah-Hartman's message
        of "Wed, 11 Oct 2017 15:13:10 +0200")
Message-ID: <87h8v4pxqp.fsf@kamboji.qca.qualcomm.com> (sfid-20171012_103820_650537_9ABCD1C2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

>> >> I'm getting slightly annoyed that we now apparently have two duplicate
>> >> rtlwifi drivers (with the same name!) and I'm being spammed by staging
>> >> patches. Was this really a smart thing to do? And what will be the
>> >> future of these two drivers?
>> >>
>> >> (Of course this is not directed to Dan, he is just fixing bugs found by
>> >> smatch, but more like a general question.)
>> >
>> > That was the decision that you and Greg made. The version in
>> > wireless-drivers needs many patches to handle the new device. The
>> > progress in applying these to wireless-drivers was very slow for many
>> > reasons. Keeping a single version of that code would have required
>> > coordination between you and Greg, which was discouraged.
>> 
>> I don't recall deciding anything, all I did was asking for more info
>> about the new code. I was against the idea since I first saw your mail
>> but I tried to be diplomatic and not shot it down immeadiately. Shows
>> that diplomacy is not really my thing...
>> 
>> We always take extra measures to avoid forking code, why is it now all
>> of sudden ok? Also this gives the wrong message to Realtek, and other
>> vendors, that they can just fork the driver and push all sort of crap to
>> staging.
>> 
>> So just to make clear to everyone: I think forking drivers like this is
>> a HORRIBLE idea and I do not want to have anything to do with that. If
>> schedule goes over quality then a much better approach is to move to the
>> whole driver to staging than to have duplicated drivers like we have
>> now.
>
> I think it's horrid too.  But, if no one is able to do the real work
> here, we hurt users who just need to use their hardware to get things
> done.
>
> And it seems like the company isn't willing to do the real work, so
> dumping this in staging is the best we can do at the moment.

I understand that this decision was made because of the users. But I
just think that if Realtek is not interested to follow our way of
working then we should dump the whole rtlwifi driver to staging, not
duplicate the driver like this and get everyone confused (and introduce
more work everyone, especially for Larry).

We already have great vendor support. For example, Intel is awesome as
they support in iwlwifi even before the users get the hardware. Also
Marvell, Quantenna and RSI are improving all the time. I admit that
Realtek is trying but mostly it's because of Larry's tireless efforts.

But my point here is that if Realtek wants to have good support for
their hardware in rtlwifi they need to submit the patches in advance,
preferably months before their deadline. Not like "the deadline for
these patches were last week" type of philosophy they have now.

> However, if this causes you problems, that's not good at all either.
> Getting "real" support for this hardware is key, and hopefully can
> happen somehow.  But fixing up the staging driver is almost never the
> way to do it, as you know :)

I can manage for now, but if we don't react and fix this it can get
messy soon. And what I fear the most is that other vendors want to start
duplicating drivers like this to meet their schedules, we should make it
clear that this is not acceptable.

> So what to do?  Any ideas?  What makes your life easier?  You can just
> ignore the staging tree, as it should not affect your portion of the
> kernel at all, right?

Yes, I automatically ignore anything staging related. But the problem is
that we now have two drivers with the same name and people don't always
remember to prefix the patch with "staging: ". So on a bad day I might
accidentally apply a patch which was meant for your tree. Of course I
immediately revert it as soon as I, or someone else, catches that but
annoying still.

I think we have two options here:

1) We set a deadline (like 12 months or something) for the
   drivers/staging/rtlwifi and after that you refuse to take any patches
   for it. Hopefully this makes it clear for everyone that this fork is
   just temporary. I think Larry is trying to do this, which is great.

2) We move the whole rtlwifi driver to staging. A very bad option but
   still better than forking the drivers.

-- 
Kalle Valo
