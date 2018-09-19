Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56498 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731235AbeISSZI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 14:25:08 -0400
Date: Wed, 19 Sep 2018 14:47:18 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] rt2x00: set registers based on current band
Message-ID: <20180919124717.GA26590@redhat.com> (sfid-20180919_144723_065648_7D99E52B)
References: <20180919110540.GC22689@redhat.com>
 <1537359450-8843-1-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1537359450-8843-1-git-send-email-pozega.tomislav@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 19, 2018 at 02:17:30PM +0200, Tomislav Požega wrote:
> On Wed, 19 Sep 2018 13:05:41 +0200, Stanislaw Gruszka wrote:
> 
> >Driver should provide on what channels are supported to mac80211, but
> >user space decide what channel to use and that imply band 2.4GHz or
> >5GHz. ->curr_band is just shortcut for band of current channel. Is set 
> >in rt2x00lib_config() after we call rt2x00dev->ops->lib->config()
> >[rt2800_config() for rt2800] . So patch is wrong. Either ->curr_band 
> >should be set before ->config call or we need to consistently use
> >rf->channel <= 14 for band check in any rt2800_config() function and
> >all it's subroutines. I prefer the second solution (i.e. rf->channel)
> >and now I can see few places when we use ->curr_band, what is a bug.
> 
> Works fine, no any kind of regression, especially not performance ones.
Did you test on dual band devices ?

> So I don't see a reason to claim it is wrong or bug just because you
> prefer current solution.
It's not wrong bacause I prefer current solution. It's because 
->curr_band is not updated when you call rt2800_config().

> >It's because ->curr_band initialize to 0 and NL80211_BAND_2GHZ
> >happen to be 0. Also problem will not trigger on single band
> >2.4GHz devices.
> 
> Can you show us how will the problem trigger on dual band devices?

When you switch from some 2.4GHz channel to 5GHz channel (or vice versa)
->curr_band will point to old band not the new one. To fix that you 
have to move curr_band assignemt before ->config() in
rt2x00lib_config() i.e:

rt2x00dev->curr_band = conf->chandef.chan->band; 
rt2x00dev->ops->lib->config(rt2x00dev, &libconf, ieee80211_flags);

However I do not see the point of replacyng rf->channel check 
to ->curr_band check. What you can do is oposite thing, replace
wrong usage of ->curr_band in very few places in rt2800_config()
subroutines to rf->channel check.

Also replacing spec->num_channels is wrong because this will
stop reporting device support 5GHz band.

Regards
Stanislaw 
