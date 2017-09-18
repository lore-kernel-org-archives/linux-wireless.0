Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0066.outbound.protection.outlook.com ([104.47.41.66]:14584
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750998AbdIRKRF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 06:17:05 -0400
Date: Mon, 18 Sep 2017 13:16:54 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 2/2] qtnfmac: abort scans on wireless interface changes
Message-ID: <20170918101654.5zukak72wvmpm6pp@bars> (sfid-20170918_121709_804828_CFE56481)
References: <20170918080446.21763-1-sergey.matyukevich.os@quantenna.com>
 <20170918080446.21763-3-sergey.matyukevich.os@quantenna.com>
 <1505724068.13691.0.camel@sipsolutions.net>
 <20170918095713.mfn76hkdbo73k4fu@bars>
 <1505728987.13691.2.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1505728987.13691.2.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 18, 2017 at 12:03:07PM +0200, Johannes Berg wrote:

> > > > -     if (timer_pending(&mac->scan_timeout))
> > > > -             del_timer_sync(&mac->scan_timeout);
> > > >       qtnf_scan_done(mac, le32_to_cpu(status->flags) &
> > > > QLINK_SCAN_ABORTED);
> > >
> > > and that's related perhaps but not really explained in the
> > > changelog,
> > > not sure?
> >
> > That was minor optimization: to remove pedning timer whenever scan
> > is canceled. Sure, it worth mentioning in changelog, will do.
> 
> I realized (after sending my email) that it actually made a lot of
> sense, so yeah - and in fact I'm not sure it's just an optimisation,
> depends on where else you cancel the timer and if that could leave the
> timer running until after the interface is removed or something.
> 
> Btw, I don't really see why you check pending first?

I don't quite understand the question. Do you mean it makes sense to call
cfg80211_scan_done first and then cancel timer ?

> > By the way, is it ok to send corrected single patch in reply to this
> > discussion ? Or the appropriate way is to resend the whole patch set
> > ?
> 
> Good question. I think it's up to the specific maintainer, I know davem
> wants a full resend, but Kalle might have his own preference. I for one
> am willing to deal with both, though a full resend is somewhat easier.

Ok, understood.

Regards,
Sergey
