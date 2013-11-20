Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:53415 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3KTL0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 06:26:11 -0500
Received: by mail-wg0-f54.google.com with SMTP id y10so8984136wgg.33
        for <linux-wireless@vger.kernel.org>; Wed, 20 Nov 2013 03:26:10 -0800 (PST)
Date: Wed, 20 Nov 2013 12:25:35 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Blaise Gassend <blaise@suitabletech.com>,
	linux-wireless@vger.kernel.org,
	Catalin Drula <catalin@suitabletech.com>,
	Alap Modi <amodi@arubanetworks.com>
Subject: Re: QoS Data packets causing massive packet loss in
 ieee80211_sta_manage_reorder_buf.
Message-ID: <20131120112535.GC6993@magnum.frso.rivierawaves.com> (sfid-20131120_122615_110981_E5FDB897)
References: <CAPvVjisu-xcZsqHgcTEKsCJFuESDFO-_0KwkgxffyejemHJZcA@mail.gmail.com>
 <1384937328.14295.3.camel@jlt4.sipsolutions.net>
 <CAPvVjiu55=nscHa-Mpff_LL-Y0v6XHEGx0K7rpCVU9nRiKfaXA@mail.gmail.com>
 <20131120110157.GA6993@magnum.frso.rivierawaves.com>
 <1384945569.14295.5.camel@jlt4.sipsolutions.net>
 <20131120111654.GB6993@magnum.frso.rivierawaves.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20131120111654.GB6993@magnum.frso.rivierawaves.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 20, 2013 at 12:16:54PM +0100, Karl Beldan wrote:
> On Wed, Nov 20, 2013 at 12:06:09PM +0100, Johannes Berg wrote:
> > On Wed, 2013-11-20 at 12:01 +0100, Karl Beldan wrote:
> > > On Wed, Nov 20, 2013 at 02:15:27AM -0800, Blaise Gassend wrote:
> > > > Hi Johannes,
> > > > 
> > > > Thanks for the quick reply!
> > > > 
> > > > > I think we just need to skip reorder processing for multicast, since
> > > > > they won't be aggregated anyway?
> > > > >
> > > > > http://p.sipsolutions.net/d00799dd2201676a.txt
> > > > 
> > > > This patch works like a charm for my current predicament. But is it
> > > > actually written somewhere that multicast packets can't be aggregated?
> > > > I can't find any place that says they can't, but I'm not authoritative
> > > > by any means.
> > > > 
> > > There's a chapter "A-MPDU aggregation of group addressed data frames" in
> > > the specs, however I haven't seen this yet.
> > 
> > Even then though, I don't think there would be any block-ack session,
> > and thus you wouldn't be able to use the reorder buffer anyway, right?
> > 
> I think so.
>  
Except maybe for 802.11aa GCR (groupcast with retries) ..
 
Karl
