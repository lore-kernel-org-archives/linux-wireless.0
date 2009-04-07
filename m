Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60662 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760445AbZDGQKh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 12:10:37 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 07 Apr 2009 09:10:37 -0700
Date: Tue, 7 Apr 2009 09:10:33 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] cfg80211: Process regulatory max bandwidth
	checks for HT40
Message-ID: <20090407161033.GB5758@tesla> (sfid-20090407_181050_747866_1358A557)
References: <1239048958-11775-1-git-send-email-lrodriguez@atheros.com> <1239048958-11775-2-git-send-email-lrodriguez@atheros.com> <1239098925.22453.10.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1239098925.22453.10.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 07, 2009 at 03:08:45AM -0700, Johannes Berg wrote:
> On Mon, 2009-04-06 at 16:15 -0400, Luis R. Rodriguez wrote:
> 
> > +static bool is_ht40_not_allowed(struct ieee80211_channel *chan)
> 
> I think it would be nicer on the reader to remove the not?
> 
> > +{
> > +	if (!chan)
> > +		return true;
> > +	if (chan->flags & IEEE80211_CHAN_DISABLED)
> > +		return true;
> > +	/* This would happen when regulatory rules disallow HT40 completely */
> > +	if (IEEE80211_CHAN_NO_HT40 == (chan->flags & (IEEE80211_CHAN_NO_HT40)))
> > +		return true;
> 
> How would that happen at this point?

Due to the regulatory freq rule.

> /me stops reading.
> 
> Ok, whatever, I know I want to rewrite most of this anyway.

:)
