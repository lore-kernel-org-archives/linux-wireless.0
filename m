Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38589 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZDRMYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 08:24:34 -0400
Subject: Re: rfkill rewrite bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <49E9A0C7.8040602@tuffmail.co.uk> (sfid-20090418_114338_695917_3CBF9024)
References: <49DCA88E.6060400@tuffmail.co.uk>
	 (sfid-20090408_153722_059382_FB44D658) <1239204090.16477.1.camel@johannes.local>
	 <49DCDD2E.80705@tuffmail.co.uk>  <49E38BBC.5010708@tuffmail.co.uk>
	 (sfid-20090413_205524_915082_56358705) <1239741968.4205.1.camel@johannes.local>
	 <49E98C86.2040308@tuffmail.co.uk>
	 (sfid-20090418_101208_980691_83127E2F) <1240043283.5792.0.camel@johannes.local>
	 <49E9A0C7.8040602@tuffmail.co.uk> (sfid-20090418_114338_695917_3CBF9024)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-WkB/zmp4dwrO1oEyqJzb"
Date: Sat, 18 Apr 2009 14:24:30 +0200
Message-Id: <1240057470.4755.7.camel@johannes.local> (sfid-20090418_142437_518454_1FA2FCB8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WkB/zmp4dwrO1oEyqJzb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-04-18 at 10:43 +0100, Alan Jenkins wrote:

> >> When I looked at the code earlier, I saw no obvious replacement for=20
> >> rfkill_set_default().  So I tried disabling the wireless and rebooting=
=20
> >> to see what happened.  It didn't like that :-).
> >>    =20
> >
> > Ok that wasn't too hard -- try this on top if you get a chance:
> >  =20
>=20
> Great, that fixes the crash.
>=20
>=20
> 1) I think we need to add a resume method to eeepc-laptop.
>=20
> Without this, funny things happen when I hibernate, disable wireless in
> the BIOS, and resume:
>=20
>     ath5k phy0: failed to wake up the MAC chip
>=20
> It's an really stupid thing to do, but it can happen.  It's bad from a
> UI point of view.  E.g. in network-manager, you can see a "wlan0"
> device, but it doesn't work.
>=20
> The EEE rfkill is unusual in that it hotplugs the PCI device, making
> eeepc-laptop something like a custom pci hotplug driver.  With your
> rewrite, eeepc-laptop doesn't notice the state change on resume.=20
> Previously, the rfkill-core would restore the pre-hibernation state,
> which would sort everything out.  I don't think anything else does this,
> so we can just add a resume method to eeepc-laptop.  The resume method
> would re-check the state and do the PCI hotplug dance if necessary.
>=20
> If you agree, I can do the patch for this and send it to you.

Sounds good to me, yeah.

I could make the rfkill core do that at resume, but I'm not really sure
it's what we want -- there are too many cases imho:
 * hard rfkill might have changed
 * soft rfkill might still be ok in hw
 * soft rfkill might need reconfiguring
etc. I think generally it's saner to let the driver sort it out -- it
can always ask for the current state by using set_hw_state() or so.

> 2) Do you have any thoughts about an rfkill_set_default() equivalent?=20
> AFAICS your current patch simply removes it.
>=20
> This means that when I boot linux, it doesn't respect the previous
> rfkill state.  I can no longer disable the wireless in the BIOS setup
> screen, and the rfkill state won't be preserved over reboots.
>=20
> I don't have a strong feeling about reboots _on their own_.  But I would
> be annoyed if the option in the BIOS setup screen stopped working in a
> future version of linux.  Admittedly it's only a matter of principle /
> nostalgia - since the eeepc-laptop was fixed to implement rfkill
> properly, I've never used the BIOS option in anger.

That's odd, I thought I added a set_sw_state() to rfkill which would
disable that rfkill. But there's rfkill_set_global_sw_state() which
should do what you want -- can you try replacing the EEE set_sw_state
call with that?

johannes

--=-WkB/zmp4dwrO1oEyqJzb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6cZ7AAoJEKVg1VMiehFYL9IP/3pY1Hz+3LlY+pnqWWFMQmJM
K/PdIAwMJy3XqILXn4GGuyuwY477Olxp/JqYMo/+dNkNQCOQ2V4o08gkblZo93l7
NtWTUrnhQzJfy8V1+L6S7n2t/BuOkQQzquuJKyorYO/kkkzKGljVsisgO9Q9JDlA
UnLf3w4U1R6gtyWPHkcBBguXT/eKmYLZxsvgj/fyR6S87ufjhxzqDbXSEIwlM8mT
5z/Zxs19rOpPPQOWZJ0IMxkf78oUyb3n1856kre/eGg1L4SfEzye7qtg9m3gXIdx
dNFHK2p0FTdv8f2QJ/hzgO5hTszWfuNYb7a6QzWLjn/yajp1jkr2ichchuIq3EDl
rur1JNyHRwXDnXIGtNxuauwwZMddXztzGqQxcZwpRqYGIaosmnmGZtoLx7ckhZiM
/DFCnMHbTzJ1mvR6iFFVIWSjHmDSQ8av5x1VRTKLeqVLD8vW7lVhrX+z7iQ0aRjE
TO7EyZhTMc79Za+0vlGa/fo8shSDMzrLGcs3fnL0Xj6oHppD934CqpWoNlxMOVbB
dP6A0pTkny5iR4W8Ln2WCnlDKNuThY0OeLQI88jgM02VJI/8YcIn7/dGsQ0jOTSo
DRx3yf2/PUb/xYWZDQEWUQFK5bHgzjT2PenYrIgUM8FNWoV/ug00YH64Fak60wan
nta7aV2gvjN8iYAsjo0c
=LdtT
-----END PGP SIGNATURE-----

--=-WkB/zmp4dwrO1oEyqJzb--

