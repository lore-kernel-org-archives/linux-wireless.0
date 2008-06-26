Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.228]:3566 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbYFZSTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 14:19:35 -0400
Received: by wr-out-0506.google.com with SMTP id 69so126288wri.5
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jun 2008 11:19:34 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: make workqueue freezable
Date: Thu, 26 Jun 2008 20:21:05 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1214503196.3783.13.camel@johannes.berg> <200806262014.27907.IvDoorn@gmail.com>
In-Reply-To: <200806262014.27907.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200806262021.05324.IvDoorn@gmail.com> (sfid-20080626_201939_651438_E69619B7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 26 June 2008, Ivo van Doorn wrote:
> On Thursday 26 June 2008, Johannes Berg wrote:
> > This patch makes the mac80211 workqueue freezable making it
> > interact a bit better with system suspend and not try to ping
> > the AP while the hardware is down.
> >=20
> > This doesn't really help with implementing proper suspend in
> > any way but makes some bad things trigger less.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> > I'm not sure whether we should put this into 2.6.26 or not, while i=
t
> > might help a bit it doesn't really do much over what the tx bugs fi=
nder
> > already does except avoid sending out the packets that froze b43 in=
 the
> > first place...
> >=20
> > Ivo, you might consider using =EF=BB=BFcreate_freezeable_workqueue =
for your
> > rt2x00 patch though.
>=20
> Will do. Thanks for the tip.

Ehm, on second thought I keep it as it is. Currently the rt2x00 will al=
ready shut
down all work tasks during suspend and resumes them when the device is =
restored.

The only task that needs to survive the suspend and resume task is the =
link tuner,
and that one is automatically started when the radio is reenabled. And =
not stopping
it manually during suspend, will cause problems (aka race conditions, w=
hich have
appeared in the past when the link tuner continues running while the ra=
dio is down)

Ivo

> >  net/mac80211/main.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > --- everything.orig/net/mac80211/main.c	2008-06-26 18:21:14.0000000=
00 +0200
> > +++ everything/net/mac80211/main.c	2008-06-26 18:21:16.000000000 +0=
200
> > @@ -1774,7 +1774,7 @@ int ieee80211_register_hw(struct ieee802
> >  	list_add_tail(&sdata->list, &local->interfaces);
> > =20
> >  	name =3D wiphy_dev(local->hw.wiphy)->driver->name;
> > -	local->hw.workqueue =3D create_singlethread_workqueue(name);
> > +	local->hw.workqueue =3D create_freezeable_workqueue(name);
> >  	if (!local->hw.workqueue) {
> >  		result =3D -ENOMEM;
> >  		goto fail_workqueue;
> >=20
> >=20
> >=20
>=20
>=20
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
