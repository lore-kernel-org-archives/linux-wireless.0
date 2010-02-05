Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from liberdade.minaslivre.org ([72.232.254.139]:38847 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933516Ab0BESAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 13:00:38 -0500
Date: Fri, 5 Feb 2010 15:55:56 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] nl80211: allow adding new station to devices in mesh
 mode
Message-ID: <20100205175556.GC1496@holoscopio.com>
References: <1265331642-27773-1-git-send-email-cascardo@holoscopio.com>
 <20100205165726.GA1496@holoscopio.com>
 <c1545bb51002050947q707bb5ebud5ec7b4680f49ac5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LTeJQqWS0MN7I/qa"
In-Reply-To: <c1545bb51002050947q707bb5ebud5ec7b4680f49ac5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--LTeJQqWS0MN7I/qa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 05, 2010 at 09:47:44AM -0800, Andrey Yurovsky wrote:
> Hi,
>=20
> On Fri, Feb 5, 2010 at 8:57 AM, Thadeu Lima de Souza Cascardo
> <cascardo@holoscopio.com> wrote:
> > After doing the "station new" command, I can do a "station dump" and get
> > my newly added station. So, I think this is ready for commit. And then,
> > we need to sort out both the WARNING and the panic for the Minstrel in
> > other patches too.
>=20
> Just to be clear, what are you trying to do here?  Are you manually
> populating the peer links (stations) list?  If so, why?  Thanks,
>=20
>   -Andrey

I did not get automatic plinks for a peer. So, I decided to look at the
code and see when they got added to the sta list. It does when it
receives some management frames and also when it's added manually with
the NEW_STATION nl80211 command.

I want automatic plinks to work. But since I've started to play with it,
why not make the command just work. It's there. If adding plinks
manually to mesh nodes is not permitted, I may just send another patch,
disallowing it entirely and making it explicit in code, comment and git
log.

Did you have anything in mind for the use of this command to mesh mode?
One use case I can think of is to set the block action before the node
appears nearby (since station set will not work without the plink).

Regards,
Cascardo.

--LTeJQqWS0MN7I/qa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktsW6sACgkQyTpryRcqtS3E7wCghxwpajOgRJG2clvaBCCH7nmE
YtQAnixK5iXcFbN74azq1ab9b7ae3mod
=kHab
-----END PGP SIGNATURE-----

--LTeJQqWS0MN7I/qa--
