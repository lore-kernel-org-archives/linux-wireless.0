Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53043 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbXIJLrl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 07:47:41 -0400
Subject: Re: A-MSDU deaggregation support
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: mohamed salim abbas <mabbaswireless@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <1ba2fa240709100441o421653fbre410df615e7d9e10@mail.gmail.com>
References: <1189354526.4506.25.camel@johannes.berg>
	 <1ba2fa240709100441o421653fbre410df615e7d9e10@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YiUILEQzSPbbkW0JEKxT"
Date: Mon, 10 Sep 2007 13:49:12 +0200
Message-Id: <1189424952.4506.68.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YiUILEQzSPbbkW0JEKxT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-10 at 14:41 +0300, Tomas Winkler wrote:

> There is difference between receiving and destination address. AP is
> receiving address but not the destination. If station sends packets to
> multiple stations it still go through one AP (receiving address). The
> only restriction is that all the packets in A-MSDU belongs to one TID
> stream.

Good point. However, shouldn't we be checking the SA/TA?

> There is actually different problem with the A-MSDU deaggregation and
> this is EPOL filtering. One of the packets might belong to EAPOL
> handshake

Good point as well. Also, there's still the headroom reservation thing I
haven't really walked through.

But I would like to ask you to not work on this at this time, I'm going
to make some larger changes in this area that may end up doing
deaggregation in a loop and pushing the remaining packets through some
more rx handling.

Michael had the idea to introduce a type of interface that would see all
frames not destined for other interfaces including those eapol packets
etc. to run the userspace mlme (wpa_supplicant or hostapd) on such an
interface to avoid copying all data packets. This will most likely
require framing the packet to 802.3 before it is cloned for each
interface (currently we copy for each interface!), and hence the
deaggregation would be done along with reframing regular packets,
eapol/802.1X filtering would move behind that.

johannes

--=-YiUILEQzSPbbkW0JEKxT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG5S84/ETPhpq3jKURAkdlAKC0N7+ZH1j0Pqt8lGllyE+R6vpEQgCgiIPt
VDBybEtVi7rg7aOlFQ8L77E=
=3VWD
-----END PGP SIGNATURE-----

--=-YiUILEQzSPbbkW0JEKxT--

