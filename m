Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39509 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbZGOQE3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 12:04:29 -0400
Subject: Re: [PATCH 4/5] mac80211: add WoW support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
In-Reply-To: <20090715152250.GD5682@mosca>
References: <1247617320-20163-1-git-send-email-lrodriguez@atheros.com>
	 <1247617320-20163-5-git-send-email-lrodriguez@atheros.com>
	 <1247659055.2477.0.camel@johannes.local>  <20090715152250.GD5682@mosca>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fMHoyiMxbBV/tMdP+Kbj"
Date: Wed, 15 Jul 2009 18:03:51 +0200
Message-Id: <1247673831.10754.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fMHoyiMxbBV/tMdP+Kbj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-15 at 08:22 -0700, Luis R. Rodriguez wrote:
> On Wed, Jul 15, 2009 at 04:57:35AM -0700, Johannes Berg wrote:
> > On Tue, 2009-07-14 at 20:21 -0400, Luis R. Rodriguez wrote:
> > > If we're associated and have not already gone into PS mode
> > > we ensure send a nullfunc frame before going to suspend. Upon
> > > resume we ensure we restore PS mode if it was enabled and inform
> > > the driver accordingly, also notify the AP we're awake.
> > >=20
> > > WoW requires the radio to be left on during suspend, to do this
> > > we inform drivers of the requested wow triggers on the mac80211
> > > stop callback.
> >=20
> > I don't think this patch would work if ath9k unprogrammed the hardware
> > correctly in ->remove_interface(), since you don't seem to skip that
> > call.
>=20
> We just stop ANI in remove interface and reclaim beacon resources.
> As per documentation it seems we are not correctly removing the MAC
> address in ath9k for the removed interface to stop sending ACKs back.
> I'd rather see that as a separate patch fix, but you do have a point.
> As is right now though this doesn't affect WoW.

You haven't understood my point -- it makes your WoW patch invalid
because drivers that implement remove_interface properly cannot possibly
implement WoW this way.

johannes

--=-fMHoyiMxbBV/tMdP+Kbj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXf3kAAoJEODzc/N7+Qmae0oP/2ei/D+O9i/WmSVsyXvZbu+q
S5lCob+WpkhkKxnTopa/q3arqfX19sDU9Tgdwrn4MVIvaQDSKHcQpQPil4WAzlzd
/5MQjXyYCHfhCPaaTmvGV9ysdeLjRPBbCXtQcA9lBQZwB1N32JvS8NikkUFwmFjx
Y3VJP18i8yZ/XMcPvXglAzG3NunYy/LYsw1K/erzsW+sQxlHOhlT6yGRL5GKitXE
mHhWkrJ4g9QzZHQ5BegPvPnNaTHxeI4Hw2WRknQQrhfvaAgVJILkig0u7w/5p5BE
4YZVhWXh4wxGh9bsDqE0bJYxVCQUckRP+0GedQIzhkGQvfwq3rUxGL3dhP8UOzEC
xIsp0VU5IZxh7VX6gw1e9dXDZbK0wpJB3cAXgGNsGM+gvpFoPc7MDzdlqGyPaWJe
yky41S3QTYDe0svrs/mrWfwoP1GeZtsnJPhitu90rRpYLS+vycjBzHav98iVvfC+
ypMXeuuEQ4jhHPBIKILGcpwCgffVwXEzbk5be2DvMBoGWqj0q+kt7gX2q5oWShPU
8c/53SmPSg85Ck/ri1SuUSvP/sMZQESd5prc+2WiwSP+QSnkN9ThYHbPO58emV70
G9Y5n+I3710Zc9dfsAZxKt8GJ1kPpmJMn7BT2ZIuDzqd8JC7gKXKctmQYJYHyuWz
OJkkcPnEDgMKSVDjDas8
=vm14
-----END PGP SIGNATURE-----

--=-fMHoyiMxbBV/tMdP+Kbj--

