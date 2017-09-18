Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38286 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752699AbdIRKDJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 06:03:09 -0400
Message-ID: <1505728987.13691.2.camel@sipsolutions.net> (sfid-20170918_120312_809493_49EB62C0)
Subject: Re: [PATCH 2/2] qtnfmac: abort scans on wireless interface changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Date: Mon, 18 Sep 2017 12:03:07 +0200
In-Reply-To: <20170918095713.mfn76hkdbo73k4fu@bars>
References: <20170918080446.21763-1-sergey.matyukevich.os@quantenna.com>
         <20170918080446.21763-3-sergey.matyukevich.os@quantenna.com>
         <1505724068.13691.0.camel@sipsolutions.net>
         <20170918095713.mfn76hkdbo73k4fu@bars>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > >  static int qtnf_netdev_close(struct net_device *ndev)
> > >  {
> > > -     netif_carrier_off(ndev);
> > >       qtnf_virtual_intf_cleanup(ndev);
> > >       qtnf_netdev_updown(ndev, 0);
> > > +     netif_carrier_off(ndev);
> > >       return 0;
> > >  }
> > 
> > This seems unrelated?
> 
> Hmm... The idea was to make sure that scan is canceled before
> cfg80211_netdev_notifier_call throws WARN when state is changed
> to NETDEV_DOWN. However this is not needed if scans are properly
> canceled in cfg80211_ops handlers. Thanks for catching, will remove.

Not sure how the carrier change is relevant though - that doesn't even
notify cfg80211? Anyway, I don't really know, it just didn't seem
related :)

> > > -     if (timer_pending(&mac->scan_timeout))
> > > -             del_timer_sync(&mac->scan_timeout);
> > >       qtnf_scan_done(mac, le32_to_cpu(status->flags) &
> > > QLINK_SCAN_ABORTED);
> > 
> > and that's related perhaps but not really explained in the
> > changelog,
> > not sure?
> 
> That was minor optimization: to remove pedning timer whenever scan
> is canceled. Sure, it worth mentioning in changelog, will do.

I realized (after sending my email) that it actually made a lot of
sense, so yeah - and in fact I'm not sure it's just an optimisation,
depends on where else you cancel the timer and if that could leave the
timer running until after the interface is removed or something.

Btw, I don't really see why you check pending first?

> By the way, is it ok to send corrected single patch in reply to this
> discussion ? Or the appropriate way is to resend the whole patch set
> ?

Good question. I think it's up to the specific maintainer, I know davem
wants a full resend, but Kalle might have his own preference. I for one
am willing to deal with both, though a full resend is somewhat easier.

johannes
