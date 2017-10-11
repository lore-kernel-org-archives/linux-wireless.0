Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51352 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752050AbdJKNND (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 09:13:03 -0400
Date: Wed, 11 Oct 2017 15:13:10 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: Two rtlwifi drivers?
Message-ID: <20171011131310.GF32250@kroah.com> (sfid-20171011_151326_173775_FBB7641C)
References: <20170824100832.lcmbwcjhzwlgozeh@mwanda>
 <87h8wxw4bq.fsf@kamboji.qca.qualcomm.com>
 <652d42ad-a077-530b-743f-d38ddf3ff677@lwfinger.net>
 <87k202qcjr.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87k202qcjr.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 11, 2017 at 12:06:00PM +0300, Kalle Valo wrote:
> (Sorry for taking so long with the reply, I wanted first to check what
> the rtlwifi in staging contains.)
> 
> Larry Finger <Larry.Finger@lwfinger.net> writes:
> 
> > On 08/24/2017 07:14 AM, Kalle Valo wrote:
> >> Dan Carpenter <dan.carpenter@oracle.com> writes:
> >>
> >>> Smatch is distrustful of the "capab" value and marks it as user
> >>> controlled.  I think it actually comes from the firmware?  Anyway, I
> >>> looked at other drivers and they added a bounds check and it seems like
> >>> a harmless thing to have so I have added it here as well.
> >>>
> >>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> >>>
> >>> diff --git a/drivers/staging/rtlwifi/base.c b/drivers/staging/rtlwifi/base.c
> >>> index f7f207cbaee3..a30b928d5ee1 100644
> >>> --- a/drivers/staging/rtlwifi/base.c
> >>> +++ b/drivers/staging/rtlwifi/base.c
> >>
> >> I'm getting slightly annoyed that we now apparently have two duplicate
> >> rtlwifi drivers (with the same name!) and I'm being spammed by staging
> >> patches. Was this really a smart thing to do? And what will be the
> >> future of these two drivers?
> >>
> >> (Of course this is not directed to Dan, he is just fixing bugs found by
> >> smatch, but more like a general question.)
> >
> > That was the decision that you and Greg made. The version in
> > wireless-drivers needs many patches to handle the new device. The
> > progress in applying these to wireless-drivers was very slow for many
> > reasons. Keeping a single version of that code would have required
> > coordination between you and Greg, which was discouraged.
> 
> I don't recall deciding anything, all I did was asking for more info
> about the new code. I was against the idea since I first saw your mail
> but I tried to be diplomatic and not shot it down immeadiately. Shows
> that diplomacy is not really my thing...
> 
> We always take extra measures to avoid forking code, why is it now all
> of sudden ok? Also this gives the wrong message to Realtek, and other
> vendors, that they can just fork the driver and push all sort of crap to
> staging.
> 
> So just to make clear to everyone: I think forking drivers like this is
> a HORRIBLE idea and I do not want to have anything to do with that. If
> schedule goes over quality then a much better approach is to move to the
> whole driver to staging than to have duplicated drivers like we have
> now.

I think it's horrid too.  But, if no one is able to do the real work
here, we hurt users who just need to use their hardware to get things
done.

And it seems like the company isn't willing to do the real work, so
dumping this in staging is the best we can do at the moment.

However, if this causes you problems, that's not good at all either.
Getting "real" support for this hardware is key, and hopefully can
happen somehow.  But fixing up the staging driver is almost never the
way to do it, as you know :)

So what to do?  Any ideas?  What makes your life easier?  You can just
ignore the staging tree, as it should not affect your portion of the
kernel at all, right?

thanks,

greg k-h
