Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56672 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbXHNL7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 07:59:22 -0400
Subject: Re: [PATCH] hostapd: also get outgoing EAPOL frames from monitor  iface
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Andy Green <andy@warmcat.com>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <1187088787.4069.1.camel@johannes.berg>
References: <1186992004.27916.53.camel@johannes.berg>
	 <1187046852.32435.36.camel@johannes.berg>
	 <1187088787.4069.1.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FCYrTnOljHKoLTzH5qen"
Date: Tue, 14 Aug 2007 14:01:41 +0200
Message-Id: <1187092901.4069.14.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FCYrTnOljHKoLTzH5qen
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-14 at 12:53 +0200, Johannes Berg wrote:

> +	/*
> +	 * Accept EAPOL frames
> +	 */
> +	BPF_STMT(BPF_LD  | BPF_W | BPF_IND, 0),
> +	BPF_JUMP(BPF_JMP | BPF_JEQ, 0xAAAA0300, 0, FAIL),
> +	BPF_STMT(BPF_LD  | BPF_W | BPF_IND, 4),
> +	BPF_JUMP(BPF_JMP | BPF_JEQ, 0x0000888E, PASS, FAIL),

Hmm... This isn't going to work without hardware crypto. Ideas anyone?

johannes

--=-FCYrTnOljHKoLTzH5qen
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwZml/ETPhpq3jKURAr1AAJsEnFhs9N99zzR/pIx12VP/LmGGZwCfe0TD
rzMTAJe+YkjnhRYfJr0YVUk=
=8wOT
-----END PGP SIGNATURE-----

--=-FCYrTnOljHKoLTzH5qen--

