Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60300 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbZEEIPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 04:15:40 -0400
Subject: Re: rfkill rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <9b2b86520905010242q443eb19bnc9e2c86a23605c2d@mail.gmail.com>
References: <9b2b86520905010242q443eb19bnc9e2c86a23605c2d@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6kS/jLHG58M3wtR3tVqz"
Date: Tue, 05 May 2009 10:15:07 +0200
Message-Id: <1241511307.25807.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6kS/jLHG58M3wtR3tVqz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Sorry for the long wait.

> > I could make the rfkill core do that at resume, but I'm not really sure
> > it's what we want -- there are too many cases imho:
> >  * hard rfkill might have changed
> >  * soft rfkill might still be ok in hw
> >  * soft rfkill might need reconfiguring
> > etc. I think generally it's saner to let the driver sort it out -- it
> > can always ask for the current state by using set_hw_state() or so.
>=20
> I just realized or remembered something non-obvious.  This means _all_
> rfkill drivers need a resume handler.  They don't at the moment, so
> this would need to be fixed and documented.  In which case, it's
> probably simpler for the core to do it.

Only those that have a hard-rfkill line, which I think isn't all. But
yes. However, how would the core handle it?

> You need this to handle hibernation.  If the rfkill state persists
> across hibernation (which mine does, even in S5), you can always cause
> the state to change, by pressing the wireless toggle key _while the
> hibernation image is being written to disk_.  At that stage, all
> devices are active, so that s2disk can interact with the user and
> write the image wherever it chooses.  The kernel will not "remember"
> the state change on resume, since it happened after the kernel image
> was snapshotted.

Good scenario, yes, it's definitely possible.

> If the rfkill state does _not_ persist over hibernation, then clearly
> the state can change on resume and you will again need a resume
> handler,
>=20
> On my EeePC, this is just more dramatic because it can de-power a PCI
> device without notifying the driver.  But the new rfkill design will
> require all devices to have a resume method, because there is no
> get_state() callback.  Otherwise, reading  of
> /sys/class/rfkill/rfkill*/state after resume from hibernation may
> return an incorrect result.  I don't think we should allow that to
> happen.

So we would need to add a query_resume() method like query that is
called at resume time, and needs to call rfkill_set{,_hw,_sw}_state as
appopriate. Thoughts? We can enforce that much easier by making it a
required method.

johannes

--=-6kS/jLHG58M3wtR3tVqz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ//WJAAoJEKVg1VMiehFY2gwP/RRCbTRKD9buZtlE0cGlNRjq
loXUtoidU+amcoYYl/Kv8g795Feypvaeeb9iqq2L33duLvOugC0sJkrJMlu8B551
ih3a1rXIC+UnREXWaynVZsepVK/W0PgpXLkR37bvS339fhBy1Dbzo2BgGQKDQS+F
Afaa9JUPse+XvsuvRppdoyjN/Wg5jlrnqCaqZUJ/C5Mey/XLhPtjFcCFWrMYTRhR
pEWmjMW5bexxpfmuVP3R3TzQAPoTDw9Ume0A+bA4dHaiTm6R+QBjxMbaIAwSJnrF
lGDLpWG1yFJGaXe/k5wrUEKTXO/GYL/yIum4FI1+6YLf2XvQR7xbt+beEbaHKefF
oxCwxDHINDCy7pdYfBwIIwdlsNKyCpIb6rjsEMim2wIOxcSee5MRFfE42tPAeoLG
NM5wxxqmrmCGBpnXGDZtHGh7LI+H3uiHju7mHgL6bXnSEttTN3kW2rC8K7SBVQO6
MIowImhbmU+alBJU648/idngd095QnNT0EHaYT4Bu1/T2xSC4QIor8jz+Dd9j9QD
FMGc23/sdzNCdFjduiCZo2yK0rk/pIoqHG1a0wKn3/yN4j4uXlcyDH93jM2RxKjR
iBcvgljhIgRvRqQ5+dUQBr68My2ELItdh3XpxNteirDdUkFhEt5UTnybYct/CY9B
Sli5IbqEHWmqlti+G88V
=BQo5
-----END PGP SIGNATURE-----

--=-6kS/jLHG58M3wtR3tVqz--

