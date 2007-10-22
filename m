Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbXJVPqq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2007 11:46:46 -0400
Subject: Re: [PATCH] ipw2100: send WEXT scan events
From: Dan Williams <dcbw@redhat.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org, ipw2100-devel@lists.sourceforge.net
In-Reply-To: <1193041255.3069.164.camel@debian.sh.intel.com>
References: <1192033687.9739.39.camel@localhost.localdomain>
	 <1193041255.3069.164.camel@debian.sh.intel.com>
Content-Type: text/plain
Date: Mon, 22 Oct 2007 11:46:27 -0400
Message-Id: <1193067987.30205.11.camel@localhost.localdomain> (sfid-20071022_164649_110074_A7555F4A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-10-22 at 16:20 +0800, Zhu Yi wrote:
> On Wed, 2007-10-10 at 12:28 -0400, Dan Williams wrote:
> > ipw2100 wasn't sending WEXT scan events at all on scan completion.
> > And
> > like ipw2200, the driver aggressively auto-scans, requiring
> > non-user-requested scan events to be batched together and sent at
> > specific intervals instead of many times per seconds.
> > 
> > Signed-off-by: Dan Williams <dcbw@redhat.com>
> 
> Sorry for the late response. Please see my comments below.
> 
> > +                       queue_delayed_work(priv->workqueue,
> > +                                       &priv->scan_event_later,
> > +                              round_jiffies(msecs_to_jiffies(4000)));
> 
> round_jiffies_relative instead?

Yeah, that patch hit after I posted mine.  Can fix up.

> > @@ -6118,6 +6153,8 @@ static struct net_device
> > *ipw2100_alloc_device(struct pci_dev *pci_dev,
> >         INIT_DELAYED_WORK(&priv->wx_event_work,
> > ipw2100_wx_event_work);
> >         INIT_DELAYED_WORK(&priv->hang_check, ipw2100_hang_check);
> >         INIT_DELAYED_WORK(&priv->rf_kill, ipw2100_rf_kill);
> > +       INIT_WORK(&priv->scan_event_now, ipw2100_scan_event_now);
> > +       INIT_DELAYED_WORK(&priv->scan_event_later,
> > ipw2100_scan_event_later);
> 
> Except the work vs. delayed_work, they are doing the same thing. So you
> can replace scan_event_now by scan_event_later with delay = 0.

Good catch, will post update.

Thanks!
Dan


