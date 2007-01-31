Return-path: <wireless-bounces@tuxdriver.com>
Received: from annwn14.rutgers.edu (smtp.rutgers.edu [128.6.72.243])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0V3MAUW004366
	for <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 22:22:36 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: SIOCGIWRANGE and dscape
Date: Tue, 30 Jan 2007 22:21:05 -0500
References: <9e4733910701301636i18a21f31q421cc7d5c61f6c99@mail.gmail.com>
	<20070131025234.GB7061@jm.kir.nu>
	<9e4733910701301911p6c687565h65bce1aedf7e13a3@mail.gmail.com>
In-Reply-To: <9e4733910701301911p6c687565h65bce1aedf7e13a3@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200701302221.17544.flamingice@sourmilk.net>
Cc: wireless@lists.tuxdriver.org
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1552228038=="
Sender: wireless-bounces@tuxdriver.com
Errors-To: wireless-bounces@tuxdriver.com

--===============1552228038==
Content-Type: multipart/signed; boundary="nextPart6806833.HjrEdnNWPZ";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart6806833.HjrEdnNWPZ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 30 January 2007 22:11, you wrote:
> On 1/30/07, Jouni Malinen <jkmaline@cc.hut.fi> wrote:
> > On Tue, Jan 30, 2007 at 08:12:19PM -0500, Michael Wu wrote:
> > > Fixing up giwrange is currently on my d80211 blockers todo list since
> > > it is part of fixing wireless statistics reporting in d80211. Helper
> > > functions for filling the channel lists is also somewhere on the todo
> > > list, though it isn't on the blocker list. The driver currently has no
> > > way to indicate what regulatory domain the hardware has stored in
> > > eeprom, and d80211 just assumes FCC. (after all, d80211 isn't merge
> > > ready yet ;) Yes, basic driver regulatory domain support is on my
> > > blocker todo list.
> >
> > The simple workaround for client mode is indeed just assuming one
> > regulatory domain, but the original design of the Devicescape stack was
> > to use a user space component (hostapd in case of AP mode) to populate
> > the allowed channel information based on what the low-level driver
> > claims to support as far as channels are concerned and what is
> > configured for regulatory domain (in hostapd configuration).
>
> It seems like regulatory domain for an AP has to be controlled from
> user space. What about the simple case of someone with a US laptop
> that flies to Japan and runs hostap. Getting the value from the eeprom
> won't work in this case. If this is the case then the drivers just
> need to report up every channel they can handle.
>
Yes, of course. I've read 802.11d. :) However, we need to simple regulatory=
=20
domain stuff on the driver side for feature parity with existing drivers. I=
'm=20
not actually trying to solve the problem for good, but to fix it enough to=
=20
merge. Reporting every channel is what is currently done (except for ipw394=
5=20
which restricts channels in firmware due to their regulatory concerns), and=
 I=20
think the userspace interface for setting valid channels is still there.

=2DMichael Wu

--nextPart6806833.HjrEdnNWPZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBFwAstT3Oqt9AH4aERAnxWAJ4pO9R6jaM/M+Uyt91hqr5pCQohqwCeMHtc
qbDa4J+J65HM4q/jMEq44T8=
=3LiB
-----END PGP SIGNATURE-----

--nextPart6806833.HjrEdnNWPZ--

--===============1552228038==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless

--===============1552228038==--
