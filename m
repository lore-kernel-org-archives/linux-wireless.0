Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:53522 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbZBQVJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 16:09:28 -0500
Subject: Re: Missing link quality with wireless-testing
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1234904111.29785.44.camel@johannes.local>
References: <1234896777.4678.7.camel@californication>
	 (sfid-20090217_195251_321967_5E2E0AB8)  <1234899806.29785.35.camel@johannes.local>
	 <1234902294.4678.12.camel@californication>
	 <1234904111.29785.44.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 22:09:38 +0100
Message-Id: <1234904978.4678.31.camel@californication> (sfid-20090217_220933_773016_3BE14CB9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > What exactly is broken by this? Wext never guaranteed that 'qual' values
> > > be present, and thus any application that breaks from not having 'qual'
> > > is broken anyway.
> > 
> > that be it, but I would still consider this a regression. Since when do
> > we just start removing API details without any proper warning or grace
> > period?
> 
> Why not? The API even contains whether or not the values are valid, and
> after discussing with many of the stakeholders (network manager,
> wpa_supplicant) we've decided that there's little use in the qual.qual
> value. Especially since you want to compare the 'quality' of the AP
> against the one you're associated to, so qual isn't really useful at all
> due to the various factors it can contain.
> 
> So hey, if you want to scream "regression" then we can add a 'qual.qual'
> value back. It'll still be entirely pointless, and I'll still be against
> it, but I'm not going to risk anyone reverting this patch, it's way too
> useful. And if you're going to scream regression then please keep in
> mind that then you're going to scream about the wext limit again... I
> can't fix it up in the next couple of weeks anyway.

remember that I am all for replacing WEXT and getting rid of it, but we
need to be careful with just removing parts of the API in the middle
without people noticing. At least I missed it. So you can argue that it
is my fault, but I think it is not really clear to everybody that this
value is missing now with future kernel versions.

And that WEXT doesn't guarantee that qual.qual is present is not a
really good point since cfg80211 in the past did fill in this value.

So if you really wanna remove this value (and I agree with the argument
that it is not useful), then we should do this gracefully. Using the
feature-removal-schedule.txt document comes to my mind.

Regards

Marcel


