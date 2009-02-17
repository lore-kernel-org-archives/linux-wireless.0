Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42567 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766AbZBQX1Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 18:27:25 -0500
Subject: Re: Missing link quality with wireless-testing
From: Dan Williams <dcbw@redhat.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1234904978.4678.31.camel@californication>
References: <1234896777.4678.7.camel@californication>
	 (sfid-20090217_195251_321967_5E2E0AB8)  <1234899806.29785.35.camel@johannes.local>
	 <1234902294.4678.12.camel@californication>
	 <1234904111.29785.44.camel@johannes.local>
	 <1234904978.4678.31.camel@californication>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 18:25:32 -0500
Message-Id: <1234913132.11832.10.camel@70-5-246-164.pools.spcsdns.net> (sfid-20090218_002741_981878_94003192)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-02-17 at 22:09 +0100, Marcel Holtmann wrote:
> Hi Johannes,
> 
> > > > What exactly is broken by this? Wext never guaranteed that 'qual' values
> > > > be present, and thus any application that breaks from not having 'qual'
> > > > is broken anyway.
> > > 
> > > that be it, but I would still consider this a regression. Since when do
> > > we just start removing API details without any proper warning or grace
> > > period?
> > 
> > Why not? The API even contains whether or not the values are valid, and
> > after discussing with many of the stakeholders (network manager,
> > wpa_supplicant) we've decided that there's little use in the qual.qual
> > value. Especially since you want to compare the 'quality' of the AP
> > against the one you're associated to, so qual isn't really useful at all
> > due to the various factors it can contain.
> > 
> > So hey, if you want to scream "regression" then we can add a 'qual.qual'
> > value back. It'll still be entirely pointless, and I'll still be against
> > it, but I'm not going to risk anyone reverting this patch, it's way too
> > useful. And if you're going to scream regression then please keep in
> > mind that then you're going to scream about the wext limit again... I
> > can't fix it up in the next couple of weeks anyway.
> 
> remember that I am all for replacing WEXT and getting rid of it, but we
> need to be careful with just removing parts of the API in the middle
> without people noticing. At least I missed it. So you can argue that it
> is my fault, but I think it is not really clear to everybody that this
> value is missing now with future kernel versions.
> 
> And that WEXT doesn't guarantee that qual.qual is present is not a
> really good point since cfg80211 in the past did fill in this value.

Would setting qual->updated |= IW_QUAL_QUAL_INVALID; work for you?  If
some app doesn't handle that, it's totally, completely broken.

>From wireless.h:

#define IW_QUAL_QUAL_INVALID    0x10    /* Driver doesn't provide value */

I don't think the docs can get much clearer than that...  There are
still some drivers that will set INVALID on qual because they simply
don't provide it.

Dan


