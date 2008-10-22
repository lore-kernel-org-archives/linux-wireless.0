Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:59512 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbYJVTlu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 15:41:50 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 12:41:50 -0700
Date: Wed, 22 Oct 2008 05:41:39 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] wireless: remove struct regdom hinting
Message-ID: <20081022124139.GK6190@tesla> (sfid-20081022_214152_963712_0C862864)
References: <1224585042.5521.7.camel@johannes.berg> <20081022113950.GE6190@tesla> <1224701496.30459.50.camel@johannes.berg> <20081022122914.GH6190@tesla> <1224703869.30459.63.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1224703869.30459.63.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2008 at 12:31:09PM -0700, Johannes Berg wrote:
> On Wed, 2008-10-22 at 05:29 -0700, Luis R. Rodriguez wrote:
> > On Wed, Oct 22, 2008 at 11:51:36AM -0700, Johannes Berg wrote:
> > > -/* wiphy is set if this request's initiator is REGDOM_SET_BY_DRIVER */
> > > +/* wiphy is set if this request's initiator is REGDOM_SET_BY_COUNTRY_IE */
> > 
> > Why don't we want to keep track of the wiphy if the driver set it?
> 
> Why would we? I removed it from the hinting functions so that we don't
> need to have a valid wiphy to call a hint, which seems quite possible?

Well, the alpha2 hint from country IE we'd built it from the IE
and then try call an rd hint routine, I take it now it would be the new
struct one. OK -- in that one we have the wiphy. In that case that
routine needs to be updated to check to see if the initiator is
country IE and if so mark XXX do to intersection.

Then the reason I kept the wiphy around for the regular alpha2 case is
you will want to keep track if a different wiphy sent this new alpha2
request. If so I think we do interesection then, or let the user disable
one or something.

But yea its useful to keep track of I think. I thought you didn't remove
it from ignore_request(), hm.. that's where we use it to do all these
checks.

  Luis
