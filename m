Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16496 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129AbZGOQdv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 12:33:51 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2009 09:33:51 -0700
Date: Wed, 15 Jul 2009 09:33:50 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH 3/5] cfg80211: add WoW support
Message-ID: <20090715163349.GH5682@mosca>
References: <1247617320-20163-1-git-send-email-lrodriguez@atheros.com>
 <1247617320-20163-4-git-send-email-lrodriguez@atheros.com>
 <1247658322.2302.1.camel@johannes.local>
 <20090715151425.GC5682@mosca>
 <1247673906.10754.14.camel@johannes.local>
 <20090715161600.GF5682@mosca>
 <1247674829.10754.21.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1247674829.10754.21.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 15, 2009 at 09:20:29AM -0700, Johannes Berg wrote:
> On Wed, 2009-07-15 at 09:16 -0700, Luis R. Rodriguez wrote:
> > On Wed, Jul 15, 2009 at 09:05:06AM -0700, Johannes Berg wrote:
> > > On Wed, 2009-07-15 at 08:14 -0700, Luis R. Rodriguez wrote:
> > > > > > +	if (!(wiphy->wow_triggers_supported & triggers_requested)) {
> > > > > > +		err = -EOPNOTSUPP;
> > > > > > +		goto out;
> > > > > 
> > > > > This seems wrong, should be "requested & supported != requested", I
> > > > > think.
> > > > 
> > > > The above one won't return -EOPNOTSUPP when you add additional junk, you're
> > > > right, better to just inform userspace of that.
> > > 
> > > Your version also disallows turning off WoW again, afaict.
> > 
> > That is something we do want, as otherwise we'll keep the device powered on.
> > Will consider both.
> 
> Huh? There has to be a way to turn off wow again after you've actually
> resumed for other reasons, or whatever.

Yes, we want that.

  Luis
