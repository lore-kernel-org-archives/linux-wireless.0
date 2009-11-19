Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42040 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940AbZKSW2a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 17:28:30 -0500
Subject: Re: scanning question
From: Johannes Berg <johannes@sipsolutions.net>
To: Chuck Tuffli <ctuffli@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <8999a3120911190749q3b12a712yd88b4f5aeb521291@mail.gmail.com>
References: <8999a3120911181742y364c763j3b5b88e50890332c@mail.gmail.com>
	 <1258628197.7094.3.camel@johannes.local>
	 <8999a3120911190749q3b12a712yd88b4f5aeb521291@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Apj6eqh3sEoa4zNNTOkV"
Date: Thu, 19 Nov 2009 23:28:33 +0100
Message-ID: <1258669713.7094.26.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Apj6eqh3sEoa4zNNTOkV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-11-19 at 07:49 -0800, Chuck Tuffli wrote:

> > No, you can't assume that right now, unfortunately. We've been wanting
> > to implement a flush_tx() callback for a long time now but nobody did s=
o
> > far. Some drivers might flush in the pre_scan() callback, but I think
> > that isn't actually correct because the nullfunc frame we might send
> > might pass other frames on the hw queues/fifos.
>=20
> OK. I agree that flushing isn't ideal, so the alternative is for
> someone to wait until IO finishes.

I think we should actually flush the queues.

> Can the driver sleep until it is ready to scan (I'm guessing no)?

Yes, pre_scan() can sleep, and a flush() callback would also be able to
sleep.

johannes

--=-Apj6eqh3sEoa4zNNTOkV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLBcaOAAoJEODzc/N7+QmaKCAP/AtcU7EpQdRSSnn2w+gtQyN3
lvMJXhCE1yYGTdEYjcaNnRQWeDde7DQmGjuWT37Y/bruch/OMTrnI39gM4cc/Gz1
v9eg79vb4IN+dl9fQuZ8WwDqt2VTSWnqDP1vwR0dtimzfNKZf4uRZLVqHQtlsHFn
oECiB65Xcw9G236L2OOpEwBj3fjSS7t3BiJbq4RChQXE/6Hf/igClTkNlE/0kj1R
9TLH7+iF9NCSdTMN2yk50nejNTzt25dbQsc8WHhQCQJWrw4d1c+5FeapFjZqqww7
qc0jnqogVc9y5WC/kXs7FFk9Dvlsz7ns+um5/al7inw2vO6T+saKbcCn2p0zUjSb
liidP4DntBQAWKBv3hRZE7IDGviUUnQlhWgz6S67SC+iD+Uhkd5scXtHC0jhYpfd
NvJEz1h1wS04sf9J1tYy+1PS+yizzXd57+w8pO93nbYFeQvq2trmPDshgaTh0qEv
q9jorti4urKgtEuRZPlMKWsJTvnLa+9KzLFoluk0PJ23+TuFyKc//EGcL6Z/emku
sOfehMp5/dZRWEM6DXTa+lgyxH9TQmoxxjZOiNwHTUoazCnLEjMgwh8IvaDHPlFC
vZZooZ1vgly9pt7GZQLc5xH9VAjaMjrM0MEaBSXMVZhuHs8SedG3m8e80owxxPOX
WXYBGvxFq9UCBRIBQtIL
=O0LK
-----END PGP SIGNATURE-----

--=-Apj6eqh3sEoa4zNNTOkV--

