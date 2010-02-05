Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from liberdade.minaslivre.org ([72.232.254.139]:55968 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab0BERCL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 12:02:11 -0500
Date: Fri, 5 Feb 2010 14:57:27 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, andrey@cozybit.com
Subject: Re: [PATCH] nl80211: allow adding new station to devices in mesh
 mode
Message-ID: <20100205165726.GA1496@holoscopio.com>
References: <1265331642-27773-1-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
In-Reply-To: <1265331642-27773-1-git-send-email-cascardo@holoscopio.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 04, 2010 at 11:00:42PM -0200, Thadeu Lima de Souza Cascardo wro=
te:
> Hello.
>=20
> I was trying to use iw station set in mesh mode and found out I wanted
> to call NEW_STATION. I've quickly added a station new command to iw. I
> am experimenting with mesh mode with a mac80211 driver. Then, I
> realized nl80211_new_station requires STA_SUPPORTED_RATES to be set and,
> then, requires it not to be set for mesh mode. I've patched it to
> require STA_SUPPORTED_RATES only for AP mode. But now, I get a warning
> on rate_lowest_index (from include/net/mac80211.h) and kernel panics
> right after that. I've done it on top of latest rc and I am currently
> building a version on top of wireless-testing/master.
>=20

It warns and panics in wireless-testing/master too.

However, I did found out that it does not panic when using PID rate
control instead of Minstreal. The same warning still occurs, since both
minstreal and PID rate_init functions call rate_lowest_index, which is
the responsible inline function for the WARNING.

After doing the "station new" command, I can do a "station dump" and get
my newly added station. So, I think this is ready for commit. And then,
we need to sort out both the WARNING and the panic for the Minstrel in
other patches too.

I'll resend a signed-off patch soon. Just wait a little for Andrey's
feedback.

Regards,
Cascardo.

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktsTfYACgkQyTpryRcqtS3RNACeMRJcqEBZMI4pWZGDlsxnNxkE
qLwAnir99wx/htVMVcOTWX4ew46/0pBF
=s2bk
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
