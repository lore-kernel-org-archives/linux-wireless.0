Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57134 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbaGWO3z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 10:29:55 -0400
Message-ID: <1406125788.14675.0.camel@jlt4.sipsolutions.net> (sfid-20140723_162958_556613_47034D33)
Subject: Re: [PATCH 1/2] cfg80211: add enable_dynack API
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Philippe Duchein <wireless-dev@duchein.net>
Date: Wed, 23 Jul 2014 16:29:48 +0200
In-Reply-To: <CAA2SeNKL1ZQq_G6My1Fz+vmptML1RwjTjzxBM5v8sbXCq8C0nQ@mail.gmail.com> (sfid-20140723_005608_412420_2DDCEA67)
References: <1405859555-31806-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1405859555-31806-2-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1405937608.32255.15.camel@jlt4.sipsolutions.net>
	 <CAA2SeNKL1ZQq_G6My1Fz+vmptML1RwjTjzxBM5v8sbXCq8C0nQ@mail.gmail.com>
	 (sfid-20140723_005608_412420_2DDCEA67)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-07-23 at 00:56 +0200, Lorenzo Bianconi wrote:

> > I think it may be better to handle this in the call that's normally used
> > (coverage class setting), but allow the other attribute to make a sort
> > of "dynamic coverage class". And internally, calling drivers, it seems
> > fine to pass -1 or so since you can extend the datatype there, instead
> > of introducing a new internal callback. External/internal doesn't always
> > have to match perfectly.
> >
> 
> So we can pass coverage class equal to -1 to lower drivers in order to
> enable ack timeout estimation. In this case I have to modify driver
> routine signature in p54, ath5k and ath9k drivers. Moreover in
> cfg80211/mac80211 stack we can take into account dynamic coverage
> class using s16 datatype instead of u8 for coverage_class in wiphy
> data structure.

Right. But that seems reasonable, no?

johannes

