Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43680 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbZEEOMR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 10:12:17 -0400
Subject: Re: rfkill rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <9b2b86520905050704p34e87d38gccfe78940ee95c2e@mail.gmail.com>
References: <9b2b86520905010242q443eb19bnc9e2c86a23605c2d@mail.gmail.com>
	 <1241511307.25807.6.camel@johannes.local>
	 <9b2b86520905050704p34e87d38gccfe78940ee95c2e@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-boVDPpHiqioZjX/VeCio"
Date: Tue, 05 May 2009 16:11:41 +0200
Message-Id: <1241532702.28069.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-boVDPpHiqioZjX/VeCio
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> >> I just realized or remembered something non-obvious.  This means _all_
> >> rfkill drivers need a resume handler.  They don't at the moment, so
> >> this would need to be fixed and documented.  In which case, it's
> >> probably simpler for the core to do it.
> >
> > Only those that have a hard-rfkill line, which I think isn't all.
>=20
> My scenario quoted below affects soft-rfkill only.

Ah, you're thinking of that.

> > But yes. However, how would the core handle it?
>=20
> I was thinking of calling set_block() on resume to restore the
> pre-suspend state.  That's what the old rfkill does, and why
> eeepc-laptop got away without a resume handler.

That makes sense.

> > So we would need to add a query_resume() method like query that is
> > called at resume time, and needs to call rfkill_set{,_hw,_sw}_state as
> > appopriate. Thoughts? We can enforce that much easier by making it a
> > required method.
>=20
> That would certainly follow your existing model.  (BTW the kerneldoc
> for "query" is out of sync in v8; it says "return true for blocked"
> even though the prototype returns void :-).

Yeah, I noticed already and fixed it yesterday but didn't post v9 yet
(will also amend v9 with the outcome of this discussion)

> It's debatable as to what behaviour is more user-friendly for my nasty
> corner-case.  query_resume() would allow the radio to always come back
> in the same state as it was in the moment the laptop went to sleep, if
> the hardware supports it.  But the _global_ rfkill state will then be
> out of sync, and that means the next time you press the wireless
> toggle key it does nothing, which is disconcerting.  Plus, it means
> the corner-case behaviour varies depending on whether the soft-rfkill
> line state survives over hibernation - which may even vary on the same
> machine (S5 versus S4? whether you remove the laptop's battery? weird
> firmware bugs?).
>=20
> All I'm trying to do is selfishly preserve eeepc-laptop across this
> re-write, for which purpose it seems easier to have set_block() called
> on resume :-).  I don't know if that makes rfkill more awkward in
> wireless drivers (as opposed to platform drivers), or drivers which
> have a hardware rfkill line.

No, should be fine. I can add that and remove the resume code from
eeepc.

johannes

--=-boVDPpHiqioZjX/VeCio
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJKAEkaAAoJEKVg1VMiehFYeKAQALesmaJkHCmJqasCn2FCFguh
M7vAiXAO/t7lN1EzA4VxTjFHgrpS2694mF2g9YwHDwA0qbxbKDlaXPO8bdnA4Omc
zUMHCmQnpUnL1DdnAdAi3pgLsu3ua0+DnqGSwX/1Gc9VVAkEwm0PTTSGppdKQ62/
tYmVQsQd54hleEOSkz9hk/+eTLqS+EClmypbWfZ7MJK5KWADdYhjmq4nBGvAQggt
2qTEZDqOVvdZKX7FqnNxISF2KGQUuETfTpfPoTVpd6YFqeiHl5M8Kn/WXS9JO+IU
07XSrXtL1VxlPnML+Y6a/pEiQrItsT401CprHmjnJsPc0YtIivx7pm4kwsaAnWae
u2y1RWwIthrY5Tf3GjDjI7KiehPmwkK7GcjnYU5Epx/1ksLCZJoZ4tU3sKiLJxNS
5Qy8If9lRcaimE7AYdNbbyLxpgNwPezFRn7SGNIgpA1dpDtoBIlHleWJR8WbGm5x
veaWoIvTEPFRnSnDLpBD0Ys6Bk7xRbpQo4mPgcoN9JMZy7MgyzS8PvjVCn9sSUS3
rDKp4XKXJvN7kOWaMrbZj60JJUoRVIbC51xPE0GMVDskWyGxz+841buWQMEy9NXF
Owxq5Vh8AHQgFMXTu1W61n5dR9eQlfiD7mcKFVJMczgeWUYyfyguHdlml+O5nUfF
7GYxKq94VKBQIknyOKks
=ZsMq
-----END PGP SIGNATURE-----

--=-boVDPpHiqioZjX/VeCio--

