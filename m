Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:33767 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755433AbYKTPeb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 10:34:31 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH ] zd1211rw: enable master mode. (wireless-testing)
Date: Thu, 20 Nov 2008 16:33:59 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Rami Rosen <ramirose@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kune@deine-taler.de" <kune@deine-taler.de>,
	Jouni Malinen <j@w1.fi>
References: <eb3ff54b0811170751p56544c8fic38d046a868f3bb8@mail.gmail.com> <20081119210046.GC5900@tesla> <20081119211600.GE5900@tesla>
In-Reply-To: <20081119211600.GE5900@tesla>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811201633.59986.mb@bu3sch.de> (sfid-20081120_163435_923445_C371FCBE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 19 November 2008 22:16:00 Luis R. Rodriguez wrote:
> On Wed, Nov 19, 2008 at 01:00:46PM -0800, Luis Rodriguez wrote:
> > On Wed, Nov 19, 2008 at 12:30:19PM -0800, Johannes Berg wrote:
> > > On Wed, 2008-11-19 at 11:01 -0500, John W. Linville wrote:
> > >
> > > > Is there some way we could take that into account?  I'm sure there
> > > > are users who would prefer to have an AP (i.e. their laptop) that
> > > > can't support PS clients rather than not having an AP at all.
> > >
> > > That's a good question. The distinction here is between empowering users
> > > to do the wrong thing (AP without proper PS support) and enforcing the
> > > right thing (with the consequence of complete loss of AP functionality).
> > > The issue I see here is that users will see "ohh shiny, AP support"
> > > without knowing that it doesn't actually really support it. Not sure
> > > which side of the line we want to stand on, I prefer the correctness
> > > side but I can see arguments for the other side, would just like to have
> > > users know. Maybe we could have some way to tell hostapd this and then
> > > have hostapd print a huge warning about it when started up?
> > 
> > How about making it Kconfigable for broken AP support and add the
> > warning there?
> 
> That is have something like CONFIG_MAC80211_AP_HALF_ASSED

This is not acceptable, IMO, because distros will always enable it and users
still won't know about it.
We want _users_ to know.
So the idea of letting hostapd print a huge message is not that bad.

-- 
Greetings Michael.
