Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52486 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZDPKEr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 06:04:47 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <87fxg8apgo.fsf@litku.valot.fi> (sfid-20090416_120023_501021_5425BB89)
References: <1239837672.11795.46.camel@violet>
	 <1239841291.25334.18.camel@johannes.local> <87ocuxf7kv.fsf@litku.valot.fi>
	 <1239873166.9737.4.camel@johannes.local>  <87fxg8apgo.fsf@litku.valot.fi>
	 (sfid-20090416_120023_501021_5425BB89)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HY7fPYmPXlkdrj5JSG51"
Date: Thu, 16 Apr 2009 12:04:13 +0200
Message-Id: <1239876253.9737.12.camel@johannes.local> (sfid-20090416_120451_661281_75495086)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HY7fPYmPXlkdrj5JSG51
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-16 at 12:59 +0300, Kalle Valo wrote:

> >> I have been thinking two ways to fix this, either disabling the timer
> >> for the duration of the scan or add a check for scan scan in
> >> ieee80211_associated(). I started implementing the former but haven't
> >> finished it yet. It would be great if someone else can fix it.
> >
> > But that doesn't make sense to me now. ieee80211_associated() is only
> > run from the station work (ieee80211_sta_work) which doesn't do anythin=
g
> > when we're scanning (and gets restarted on scan end). So even if last_r=
x
> > or last_beacon isn't updated we should only run the evaluation of that
> > after the scan finishes.
>=20
> ifmgd->timer is run every two seconds, even then scanning and it calls
> like this:
>=20
> ieee80211_sta_timer() -> ieee80211_sta_work() -> ieee80211_associated()
>=20
> And to my knowledge the timer is run even when scanning. Or am I missing
> something?

But ieee80211_sta_work() checks if we're scanning and aborts if we are.

> Like you have sometime ago said, this MLME code we would need a rewrite.
> It's getting messier all the time.

Heh, yeah.

johannes

--=-HY7fPYmPXlkdrj5JSG51
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ5wKaAAoJEKVg1VMiehFYfQsP/2vEoHAaDIit70O6z4gu1vsC
4Gr1q7QzHnojIQuXiXaYJ5wNLXhFOYk2GbHrCYM0TS9RWBB/A0gkH0mf+0pDx/AJ
cZ3v04vsoHyatv7IaoJ+wUKHjhWH6x7bz4XzEXTUUqHbkOLCMQOWzap7Px0iFGgU
jCv9yS5lUxj0/W15eNK3AxXuYwIQGSQ4lQaoLjycfaizsHcTds7aq6GQ0RWsFnry
+wQVM5WGYXJqrqPme0jdRgnd28PhwTN9tkafwJ9RiwZb84pgRhAiD25zPehq5ONG
ru3+xCdQvuXeKK5wVkohzZQAG5CbN9FYXkC/imvma+jrJUYK6oWnyhqwtVhVf3Zw
qCAP6GlInv0+/9D6dQJThAJl0xE/zPMfiUDE94mLVfxZPJwWtc2LrM4oOuAw7a3v
hHLSuG1XN4/6C7ysBy519XrWEIrQMA62jbB8HVh7mz71oQ1PbjhGKZSWwIkcc5zf
ebhzMxsF8dwKEkBTqsQ01NF1dZnRPVnqpcIXTmy5VGQDqpX9+5SLwLVS1eNragoR
PGyNyMDH5ccx2EkXFtsb7FzmYYdmsriuBGI+h+xydblUsI/pF0dQxDr7Q5Bi04CD
CmO27pulMzBa74X5Q+gSNOAsOsA48zKqbhyjF8P54B254ZAQ/+Zx6jhikDXhzrQ2
lNqwXljdxSAc3sUmlBlJ
=9oyu
-----END PGP SIGNATURE-----

--=-HY7fPYmPXlkdrj5JSG51--

