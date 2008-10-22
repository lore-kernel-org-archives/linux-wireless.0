Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13743 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbYJVVlD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 17:41:03 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 14:41:03 -0700
Date: Wed, 22 Oct 2008 07:40:56 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless: update regulatory sample code
Message-ID: <20081022144056.GM6190@tesla> (sfid-20081022_234129_944431_869F7DA2)
References: <1224701752.30459.53.camel@johannes.berg> <20081022123505.GI6190@tesla> <1224704488.30459.69.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1224704488.30459.69.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2008 at 12:41:28PM -0700, Johannes Berg wrote:
> On Wed, 2008-10-22 at 05:35 -0700, Luis R. Rodriguez wrote:
> > On Wed, Oct 22, 2008 at 11:55:52AM -0700, Johannes Berg wrote:
> > > Update the same code for the recent changes. I did this as a
> > > separate patch to avoid removing a lot of sample code only
> > > to add it back again in the next patch.
> > > 
> > > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > > ---
> > >  Documentation/networking/regulatory.txt |   19 ++++++++-----------
> > >  1 file changed, 8 insertions(+), 11 deletions(-)
> > > 
> > > --- everything.orig/Documentation/networking/regulatory.txt     2008-10-22 20:51:50.000000000 +0200
> > > +++ everything/Documentation/networking/regulatory.txt  2008-10-22 20:54:12.000000000 +0200
> > > @@ -131,7 +131,7 @@ are expected to do this during initializ
> > > 
> > >         r = zd_reg2alpha2(mac->regdomain, alpha2);
> > >         if (!r)
> > > -               regulatory_hint(hw->wiphy, alpha2, NULL);
> > > +               regulatory_hint(alpha2);
> > > 
> > >  Example code - drivers providing a built in regulatory domain:
> > 
> > Should we mention how currently this should be avoided unless
> > your regulatory definition is also intersected with hw capabilities
> > and that the same channels are the ones that are registered to cfg80211?

Well rd hint for when we provide a structure, that code right now
disregards when initiator == USER, and this works well only for
when the driver sending the rd struct hint also only registered
to cfg80211 the channels its legally capable of. If a driver
which does not use reg_notifier() and registers *all* of its channels
uses this then the USER set regdom will be used and *all* channels
will be left intact.

  Luis
