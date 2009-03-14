Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbZCNQM4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 12:12:56 -0400
Subject: Re: [PATCH] mac80211: don't drop null frames during software scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <1237046839.5235.86.camel@johannes.local> (sfid-20090314_170734_362051_D492D2DA)
References: <20090314144405.670.16447.stgit@tikku>
	 <1237043931.5235.67.camel@johannes.local>  <49BBCE18.4090606@nokia.com>
	 <1237046839.5235.86.camel@johannes.local>
	 (sfid-20090314_170734_362051_D492D2DA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xNTCz0Zh803TSYZe9rd9"
Date: Sat, 14 Mar 2009 17:12:49 +0100
Message-Id: <1237047169.5235.92.camel@johannes.local> (sfid-20090314_171258_947481_66B289CE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xNTCz0Zh803TSYZe9rd9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-14 at 17:07 +0100, Johannes Berg wrote:
> On Sat, 2009-03-14 at 17:32 +0200, Kalle Valo wrote:
> > Johannes Berg wrote:
> > > On Sat, 2009-03-14 at 16:44 +0200, Kalle Valo wrote:
> > >> ieee80211_tx_h_check_assoc() was dropping everything else than probe
> > >> requests during software scan. So the null frame with the power save
> > >> bit was dropped and AP never received it. This meant that AP never
> > >> buffered any frames for the station during software scan.
> > >>
> > >> Fix this by allowing to transmit both probe request and null frames
> > >> during software scan. Tested with stlc45xx.
> > >=20
> > > Would it make sense to reorder the scan code instead?
> >=20
> > Perhaps. I chose this path only because it was simple to implement :)=20
> > I'll take a look at the scan code in more detail and fix it there.
>=20
> You're kinda right too, we want to disable the queues first, then set
> sw_scanning/notify the driver, and then send the nullfunc, I think. So
> it's either this patch, or iterating the interface list twice.

Related to this, shouldn't the driver notification:

        if (local->ops->sw_scan_start)
                local->ops->sw_scan_start(local_to_hw(local));

be moved to _after_ we stop the subif queues, disable beacons and send
the nullfunc? The sw_scan_complete is done before we re-enable
everything, so it seems logical that the start should be after we
disable it all.

Michael?

johannes

--=-xNTCz0Zh803TSYZe9rd9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJu9d/AAoJEKVg1VMiehFYSaEQAMAk3atCToHHPIrnxmCDLbMr
mW1nO6ylens5lAgBrSdFsSTPoJesuBG/NOz9FBH7rJeE3F7rmi8/BhjbzVQBB/wp
xHvIsFZ+zDOCSQSNdCzMrlCXb+Vlaof1AFssGFViDqbwiEPA2Ya5sGblqfurz7dT
g2b7LJ3AWmfXXcpWqZwXCN3rnIl2cvmQa3Pgvj34YoHZLM1C855kqAoTOpGr/pps
U5LNcLJN8aJRqUoVgfpdFP8P8/g40k7xqNqRWp5m+Wbp/k1KO18Xmg0WB/YV6LZn
aT4vWV/53hJdQqWA1pl1g+zNqSN89HzNDt2fxesVaRFxKggJ7SAwbVARMtjXn82i
hrnDaJKXdqFS/T7nThQxW49ZY0JeF450JxPHss/kD7J1uNtY3EbUPu7loRkxUPhS
xQ980jrcrqTcLoIE7Y1oGW2QX1QA/u0UlRf982Xu7P2DBeWZlaZoGgl2wkorGlMx
fLxyTLLeFkI1UYHi0pGuLSAcyeKrkKcunCtzfjHbCUs9aHfZGbdk47YP5aVQrLby
x0WLvt4HSgqX16WBsxYvQXLukkgkFyxJ37+ewg2fIX00qJPeGfIw6sJIM/lcqGlg
dh7r0WFDIenVPeGKxpQouUISHAuGXdobOVRX65IQGqc7e7giVHFUvRB7n8TyjdYq
yQFIJ6EoXaDKYzyJn8GJ
=EhBP
-----END PGP SIGNATURE-----

--=-xNTCz0Zh803TSYZe9rd9--

