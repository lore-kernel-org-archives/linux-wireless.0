Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48454 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751058AbdAEJ45 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 04:56:57 -0500
Message-ID: <1483610213.4394.4.camel@sipsolutions.net> (sfid-20170105_105719_151900_5D760467)
Subject: Re: [PATCH v4] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 05 Jan 2017 10:56:53 +0100
In-Reply-To: <CAOq732KZrpsjK96uwwe3hna2DPkwbN3CvJz+LFxJzXxWw08wRA@mail.gmail.com> (sfid-20170104_213512_217745_81F57ADF)
References: <20161218002554.6362-1-andrew.zaborowski@intel.com>
         <1483544433.7312.13.camel@sipsolutions.net>
         <CAOq732KZrpsjK96uwwe3hna2DPkwbN3CvJz+LFxJzXxWw08wRA@mail.gmail.com>
         (sfid-20170104_213512_217745_81F57ADF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-01-04 at 15:35 -0500, Andrew Zaborowski wrote:
> On 4 January 2017 at 10:40, Johannes Berg <johannes@sipsolutions.net>
> wrote:
> > > +++ b/net/wireless/mlme.c
> > > @@ -340,6 +340,8 @@ int cfg80211_mlme_deauth(struct
> > > cfg80211_registered_device *rdev,
> > > 
> > >       ASSERT_WDEV_LOCK(wdev);
> > > 
> > > +     wdev->conn_owner_nlportid = 0;
> > 
> > Is this really correct? The deauth might not be to the current_bss,
> > as you can see in the following if statement:
> > 
> > >       if (local_state_change &&
> > >           (!wdev->current_bss ||
> > >            !ether_addr_equal(wdev->current_bss->pub.bssid,
> > > bssid)))
> > 
> > It seems that perhaps this should go into some other place, perhaps
> > only be reset when current_bss is also reset to NULL?
> 
> In this case yes, I think I should perform the same bssid comparison.
> But elsewhere we want conn_owner_nlportid to be set earlier than
> current_bss, and reset earlier than current_bss because (1) we want
> to be able to interrupt an ongoing attempt, and (2) we also don't
> want to trigger another disconnect / deauth if one is already in
> progress.

Right, makes sense.

> > > @@ -14539,13 +14554,21 @@ static int
> > > nl80211_netlink_notify(struct
> > > notifier_block * nb,
> > >                               spin_unlock(&rdev-
> > > > destroy_list_lock);
> > > 
> > >                               schedule_work(&rdev->destroy_work);
> > >                       }
> > > -             } else if (schedule_scan_stop) {
> > > +
> > > +                     continue;
> > > +             }
> > 
> > This also doesn't seem right - the same socket could possibly own
> > both
> > an interface and a connection? If the connection is on the same
> > interface you might not really want to do both - though it
> > shouldn't
> > hurt if all the cancel_work is in the right place - but it could be
> > a
> > different interface?
> 
> This is only a syntactic change though.  The "continue" is now in the
> "if (schedule_destroy_work)" block so the other actions will not be
> scheduled is the interface is being destroyed.

Yes, this part is only syntactic, but you added something new
afterwards, and that new thing should happen even if another interface
is going to be scheduled for destruction.

I actually think that the code right now is already wrong though, since
schedule_destroy_work and schedule_scan_stop shouldn't be mutually
exclusive, a single socket could own both a sched scan and a different
interface.

I'll fix that bug, and we'll have to deal with the conflicts when
merging this.

johannes
