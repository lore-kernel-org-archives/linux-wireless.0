Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55028 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab2ECTeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 15:34:37 -0400
Message-ID: <1336073675.5167.14.camel@jlt3.sipsolutions.net> (sfid-20120503_213440_587840_78A18FAD)
Subject: Re: [PATCH/RFC] mac80211: wake queues if ieee80211_suspend failed
From: Johannes Berg <johannes@sipsolutions.net>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
Date: Thu, 03 May 2012 21:34:35 +0200
In-Reply-To: <CAMJBoFN7qhwwmYgmoaks2kue-ERVvRonKWGvyERtym==A6qDPA@mail.gmail.com> (sfid-20120502_213014_197928_DBA1B037)
References: <4F956DD2.2020309@gmail.com>
	 <CAB3XZEefFCdcGVp3MS4GrJCavMb87RKAXkhO7CmettD1_G=xHQ@mail.gmail.com>
	 <CAMJBoFN7qhwwmYgmoaks2kue-ERVvRonKWGvyERtym==A6qDPA@mail.gmail.com>
	 (sfid-20120502_213014_197928_DBA1B037)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-02 at 21:29 +0200, Vitaly Wool wrote:
> Hi Eliad,
> 
> On Mon, Apr 23, 2012 at 5:30 PM, Eliad Peller <eliad@wizery.com> wrote:
> > hi Vitaly,
> >
> > On Mon, Apr 23, 2012 at 5:57 PM, Vitaly Wool <vitalywool@gmail.com> wrote:
> >> Sometimes I'm seeing that after a rejected suspend which was
> >> rejected by the driver's suspend routine, the device can not
> >> associate to any AP any more. Investigation shows that it's
> >> due to the fact that the queues are left stopped with the
> >> reason IEEE80211_QUEUE_STOP_REASON_SUSPEND.
> >>
> >> With that known, it looks like we need to wake queues on an
> >> unsuccessful suspend attempt explicitly.
> >>
> >> ---
> >>  net/mac80211/pm.c           |    2 ++
> >>  1 file changed, 2 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
> >> index 844cefb..fd57913 100644
> >> --- a/net/mac80211/pm.c
> >> +++ b/net/mac80211/pm.c
> >> @@ -96,6 +96,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct
> >> cfg80211_wowlan *wowlan)
> >>                int err = drv_suspend(local, wowlan);
> >>                if (err) {
> >>                        local->quiescing = false;
> >> +                       ieee80211_wake_queues_by_reason(hw,
> >> +
> >> IEEE80211_QUEUE_STOP_REASON_SUSPEND);
> >>                        return err;
> >>                }
> >
> > it seems right.
> > looks like there's a similar issue with WLAN_STA_BLOCK_BA being set
> > for all the stations and not cleared on error..
> 
> thanks for the feedback. Johannes, any objections/additions? Should I
> resubmit the patch?

No, no objections -- as for resubmitting I don't know, I've been on
vacation (and really still am until Monday)

johannes

