Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50951 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbYEHWa7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 18:30:59 -0400
Subject: Re: iwlwifi and tx info in skb->cb
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240805081528t45d7810cjfd553bf99daff096@mail.gmail.com> (sfid-20080509_002739_976063_3ACD48DC)
References: <1210197711.3547.1.camel@johannes.berg>
	 <1ba2fa240805071629i6c7336f6y61a7c9690820ef5e@mail.gmail.com>
	 <1210203054.3547.12.camel@johannes.berg>
	 <1ba2fa240805071721i3d1e3258s1e8c024c4cae9239@mail.gmail.com>
	 <1210255522.3547.48.camel@johannes.berg>
	 <1ba2fa240805081507j7cf991ffo5bae443b0b77a39e@mail.gmail.com>
	 <1210284656.3547.76.camel@johannes.berg>
	 <1ba2fa240805081528t45d7810cjfd553bf99daff096@mail.gmail.com>
	 (sfid-20080509_002739_976063_3ACD48DC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OCejvnOtlKKnwM9B5/DO"
Date: Fri, 09 May 2008 00:30:45 +0200
Message-Id: <1210285845.3547.81.camel@johannes.berg> (sfid-20080509_002955_461830_0C87B015)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OCejvnOtlKKnwM9B5/DO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I've just scanned the thread that was explaining why is this necessary
> I will read it more carefully... I have just feeling that all this
> wlan stuff just fits very awkwardly into current networking stack.

That's not really related to wireless at all, if you want to do
zero-copy IO then you need to checksum when the stuff hits the wire
which means out of hardware buffers, which some hardware (including
802.11) doesn't support so you need to copy, nothing wireless specific
here :)

Anyway, with the changes davem and I are making to actually save the
*extra* copy we should be doing well. That's where you want to look for
improvements.

johannes

--=-OCejvnOtlKKnwM9B5/DO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCN/FKVg1VMiehFYAQKWwA//cRSAMmSpGf0i8u/WPses10DDpr5TOiN3
tOVmNjd/A7SZf6Fcz2x7CMQY0LEZf1c/LTluVyOmk1rUX6S5V3YA0fUAbgA6ZIBC
70PQedV3eBIrIb2SsvR4PQVtVWpBC3dRF7rpgO5hlopkYTwRfrytMFdE/jmTqeoI
koLh4qsaXJ5DQU/fZfd/RDP8GwgQiQtgunHF57cNj5afb/kKgZGsWiDOnm9ZEjXk
hoP/MvfnA92kzlMs8GrBuMJgfaV3QriCOMziqGqbEurPypV8g6tFfLnqPMGiUJsr
5M69EEFH31jWVhmRLWczWTzOSLWXjtZDr2sQf9xoBsDp7etZiuj8YYg0TIDN/ZnE
4u3v/mei1W+vrMvhX8TAwesBWCeLG37+OMBEzWLDgcVOV2r1R0BWmFbxj6XezHBx
JmDgS+sBIMFH5BLVdPjKuDw8Q+DfdlAOBmmydIv0M4xkCGXKTxskCLH+7mPsTEhE
DMJvmxxmmKxv4MAPIALbyy5ANyk0AcwKmp4bKeIaWCOjb/Ajbqmu5I1KVaovD3K0
vPX63bgS3L0FItZr7bnoSHyo3IxZgNxWta3ep6EtV/hi098aPi4SBFQ/TBJ/F6sc
m4C/M7uMEQtSRhNqV8iOsdZ9ntkMMmKY82JjbDrqeZyFkP/kxh9WvcNCvzwCB3Ie
dMj+uuLWSvU=
=gr+2
-----END PGP SIGNATURE-----

--=-OCejvnOtlKKnwM9B5/DO--

