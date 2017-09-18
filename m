Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0050.outbound.protection.outlook.com ([104.47.37.50]:64032
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753614AbdIRJ51 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 05:57:27 -0400
Date: Mon, 18 Sep 2017 12:57:13 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 2/2] qtnfmac: abort scans on wireless interface changes
Message-ID: <20170918095713.mfn76hkdbo73k4fu@bars> (sfid-20170918_115737_657708_65E639F2)
References: <20170918080446.21763-1-sergey.matyukevich.os@quantenna.com>
 <20170918080446.21763-3-sergey.matyukevich.os@quantenna.com>
 <1505724068.13691.0.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1505724068.13691.0.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 18, 2017 at 10:41:08AM +0200, Johannes Berg wrote:

Hello Johannes,

> On Mon, 2017-09-18 at 11:04 +0300, Sergey Matyukevich wrote:
> >
> >   */
> >  static int qtnf_netdev_close(struct net_device *ndev)
> >  {
> > -     netif_carrier_off(ndev);
> >       qtnf_virtual_intf_cleanup(ndev);
> >       qtnf_netdev_updown(ndev, 0);
> > +     netif_carrier_off(ndev);
> >       return 0;
> >  }
> 
> This seems unrelated?

Hmm... The idea was to make sure that scan is canceled before
cfg80211_netdev_notifier_call throws WARN when state is changed
to NETDEV_DOWN. However this is not needed if scans are properly
canceled in cfg80211_ops handlers. Thanks for catching, will remove.

> > -     if (timer_pending(&mac->scan_timeout))
> > -             del_timer_sync(&mac->scan_timeout);
> >       qtnf_scan_done(mac, le32_to_cpu(status->flags) &
> > QLINK_SCAN_ABORTED);
> 
> and that's related perhaps but not really explained in the changelog,
> not sure?

That was minor optimization: to remove pedning timer whenever scan
is canceled. Sure, it worth mentioning in changelog, will do.

By the way, is it ok to send corrected single patch in reply to this
discussion ? Or the appropriate way is to resend the whole patch set ?

Regards,
Sergey
