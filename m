Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52228 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbcBBEey (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 23:34:54 -0500
Date: Tue, 2 Feb 2016 05:34:49 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Ross Green <rgkernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: linux-4.5-rc1 TI pandboard-es wifi wlcore locks and reset
Message-ID: <20160202043448.GA9514@earth> (sfid-20160202_053558_932580_E4A749B5)
References: <CANfgCY2nHh+vZ=JOimJdKKKs2JgM-c7m+3ePZtS3XhqyXNkDUQ@mail.gmail.com>
 <CANfgCY2zVXrLGv=YDpNvqhhoj5U2kgqZ_VV1EBPVK78grra84Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
In-Reply-To: <CANfgCY2zVXrLGv=YDpNvqhhoj5U2kgqZ_VV1EBPVK78grra84Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Feb 01, 2016 at 11:38:38PM +1100, Ross Green wrote:
> On Mon, Jan 25, 2016 at 11:47 PM, Ross Green <rgkernel@gmail.com> wrote:
> > Just tried the new kernel release on faithful pandaboard es with the
> > new 4.5-rc1 release.
> >
> > There is a problem with the wifi modules once the modules are loaded.
> > Looks like the wifi firmware gets loaded put no response after that
> > causing recovery action.
> >
> > the kernel 4.4 works quite happily with this board.
> >
> > Here is a dmesg dump in the attachment.
> >
> > Anyone have any ideas here?
>
> Just updated to the latest linux-4.5-rc2 and same result as rc1.
>=20
> The wireless module loads firmware and then stalls causing a reset of
> the device and then continues to go through a stall and reset cycle.
>=20
> please find enclosed a copy of the dmesg output.
>=20
> Is there anyone else testing a pandaboard with linux-4.5-rc2?
>=20
> Just for completeness also tested the latest linux-4.4.1 kernel and
> found no problems with the wireless modules.

I can see the same problem with Nokia N950 (which uses spi connected
wl1271). v4.4 + wl12xx spi DT patches from Uri Mashiach worked, v4.5
 + the same patches does not work. I currently suspect 133b7326e960
or 3719c17e1816 to be the culprit. I have not yet verified it, though.

Have you tried to bisect the problem?

-- Sebastian

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJWsDHkAAoJENju1/PIO/qaU/wQAIOaPHexDr8vqIpZIqmhM6Os
mfuEmzwa7DakXDRfY28xaUtcQDRBsnbtgYHNixBB+ovdPTRCxOnIyqQIpfHeZxD1
6OmQd10MeL4q1aLn0wfX1VntnbBELmCW1+sn4YW6O07pckg/vvSJ4tEMTwz0635B
I1n78kAQFbr0wX9o9J2f3gF7xIlvaP+pAAMjC+ygLjNlbMEKB6I/scDow62Gp1RU
aBSkZYNeseHu//YSaRx03SrUhgFdZuiOloxTmL+RBAZkFJlKpb9NbI2jj7k4XPcU
n+TRnVmSPA1IZSxJP6/xxN5IbgcxMJxroNWuFaY2Sjx9a9yV+DXcLzrjXBY6orMq
ilboFD+uTW/ZdcxsVJLZdlVM8R8yMV6D6Jmiu3sKhf/PZQ0QLfYlxPeK68CABrE7
uk3DbmlUclqPilYJ9b9nmaiG3Yvb5v2lg2iKoTgzZOhE982ZdGqj4naDOc9Xcr27
qvi4+Qlh9r3iOVtgaRZyq81HZgnQLehrRc5qsPwwnJzJowjT5r2Q49JuPxT2t+wK
nsvpZlPhhZH7AyB9aSBbkW/ZaMMUi7HPBHr9tfQYMe5PttnmyxaGMjhYSper4WGV
lwGYurGjFqBvTG79fsBRcTgZLufFWwfA4eLF3+ffuV6Ak/iuRbydSX1LJlEbnr5k
Tk+UaxR46x/H8XWxU3jJ
=c71I
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
