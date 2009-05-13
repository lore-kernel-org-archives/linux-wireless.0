Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45714 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbZEMW1g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 18:27:36 -0400
Subject: Re: [RFC v2 2/5] mac80211: inform devices when we are suspending
 on the stop callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <bcopeland@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <b6c5339f0905131100v5ea764cejf005734ce9289290@mail.gmail.com>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
	 <1242206461-30793-3-git-send-email-lrodriguez@atheros.com>
	 <1242208388.14227.46.camel@johannes.local>
	 <43e72e890905131020y66111b1nb89a3f17596efca6@mail.gmail.com>
	 <b6c5339f0905131100v5ea764cejf005734ce9289290@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7R363jYp49Di5FMTFK8h"
Date: Thu, 14 May 2009 00:27:06 +0200
Message-Id: <1242253626.10076.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7R363jYp49Di5FMTFK8h
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-13 at 14:00 -0400, Bob Copeland wrote:
> On Wed, May 13, 2009 at 1:20 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Wed, May 13, 2009 at 2:53 AM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> >> On Wed, 2009-05-13 at 05:20 -0400, Luis R. Rodriguez wrote:
> >>> We inform the drivers so they can take appropriate actions during
> >>> suspend for WoW support.
> >>
> >>> -static void ar9170_op_stop(struct ieee80211_hw *hw)
> >>> +static void ar9170_op_stop(struct ieee80211_hw *hw, bool suspend)
>=20
> Just curious, why can't the bus suspend method just turn the radio back o=
n?
> You have to set up the wow parameters later anyway.
>=20
> I think it'd be cleaner if the stack knew about WoW somehow rather than
> doing stuff behind its back in the driver.  Then suspend/resume could do
> the right thing (e.g. ops->wow_enable() instead of stop) if the driver wa=
s
> WoW-capable.

That's a good point. Somehow I thought this was intimately tied to
suspend. And I think for cfg80211 that makes sense, since cfg80211
doesn't do much for suspend. But for mac80211 you're right in that it
would make sense to
 * keep the radio on
 * not call stop
 * maybe not remove all the sta info structs
 * and whatever else may be necessary -- that might even depend on the
   wow mode

johannes

--=-7R363jYp49Di5FMTFK8h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKC0k2AAoJEODzc/N7+Qmaa2oP/1GZLC3uVzENVmd2eL2kFUy8
HS8vc5u8nfgxw4/Ht8UqchO/t3bw0MQgkFPb1qu6lDB4bIdzvVBQzo/w/fRUywuo
bWhRu02qJYXExwwxuZksX0rmTkEPTkROtedhxyfrISJ+48L5Q2SaEIxSB2SwqP/B
Fz3Stlx0QCcJFt4uliyarx/ZNlTfXckjfpFpNrJY+pyFfmWbS4Qf/4K10F61+Wdp
96TLp2tYYTEA/G9jVEhKofm6jG3PRZb4pn7/7kvsiZdKG+NtuncLGb6BYPGxUBgo
GpaF5/WXjeBS1LRvP3WdEIlRHuDRIpERo5cl8IFXG6DzI1NEKTg3sjvEZvTdtGBR
olO7WrR0nmuUItHWR5rcXrAcTTOsBRfCJTewv25UYbRYJnXQqRSkRFijjQwPi1xe
nN51KuUzHA/O6HfoLAkKXpS7O23uCfQ3OTyczPiyJbgpCr1knWWWfKbk5dCxPNMV
dFRydayZtvSmz7xfTGfllF0/heLLGRgzqvhv0jH483Z5WSfrHP4an++Xks35JL7E
0IrDB6JDiISB+Y4ro5c9XjPq9kgcZ8Rtx7EVVldfXxNbrDGN446o0TaBfmGretHo
N+WQozYqFE3OSULL2REclzE3TibUtNsULYcL42WfVC9n9M1KNnBTuSuVoAmzjClU
XWe2ZzPJakXOSzQMjg1v
=Uw5M
-----END PGP SIGNATURE-----

--=-7R363jYp49Di5FMTFK8h--

