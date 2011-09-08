Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310Ab1IHX3s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 19:29:48 -0400
Date: Thu, 8 Sep 2011 18:26:06 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Michael Witten <mfwitten@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Subject: Re: [PATCH] mac80211: fix suspend/resume races with unregister hw
Message-ID: <20110908162605.GD2195@redhat.com> (sfid-20110909_013007_948152_9D8BC7EC)
References: <1313150459-13234-1-git-send-email-sgruszka@redhat.com>
 <d9f6472975e34cb294831e32c8ce2346-mfwitten@gmail.com>
 <20110908064410.GA2195@redhat.com>
 <CAMOZ1BvsPok-AZVCwKnv0hWWXyV+np+nARjGRqwqsvC-du_GAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAMOZ1BvsPok-AZVCwKnv0hWWXyV+np+nARjGRqwqsvC-du_GAw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 08, 2011 at 04:04:28PM +0000, Michael Witten wrote:
> On Thu, Sep 8, 2011 at 06:44, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > On Wed, Sep 07, 2011 at 09:50:29PM -0000, Michael Witten wrote:
> >> My boot process is stalling proximate the following messages (after a period
> >> of time, some other message might show up, but the boot never progresses much
> >> further):
> >>
> >>   cfg80211: World regulatory domain updated:
> >>   cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> >>   cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> >>   cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> >>   cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> >>   cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> >>   cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> >>
> >> I bisected to this patch, namely via the following commit:
> >>
> >>   commit ecb4433550f0620f3d1471ae7099037ede30a91e
> >>   Author: Stanislaw Gruszka <sgruszka@redhat.com>
> >>   Date:   Fri Aug 12 14:00:59 2011 +0200
> >
> > Grr, crap.
> >
> >>
> >> Now, it may be the case that my system startup's scripts are doing something
> >> funny, as the stall described above occurs after Arch Linux outputs:
> >>
> >>   Waiting for UDev uevents to be processed
> >>
> >> At this point, that's all I know.
> >
> > What wireless driver are you using? If this is ipw2x00 please try
> > attached patch.
> 
> I am indeed using `ipw2200', and your patch seems to fix the problem.
> 
> How did you know what to do?

You are not the first person who hit this bug and did bisection :-/
Witold (CCed) did it. Can you also check if wireless network and rmmod
ipw2x00 works? I did not yet receive that information from Witold
regarding latest patch.

Thanks
Stanislaw

