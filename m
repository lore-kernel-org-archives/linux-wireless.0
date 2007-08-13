Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38632 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940471AbXHML0G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 07:26:06 -0400
Subject: Re: [PATCH] hostapd: work with monitor interface
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Andy Green <andy@warmcat.com>
In-Reply-To: <1186992004.27916.53.camel@johannes.berg>
References: <1186992004.27916.53.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9n9jHOnaxeSYBFCPE+ED"
Date: Mon, 13 Aug 2007 13:28:31 +0200
Message-Id: <1187004511.27916.95.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9n9jHOnaxeSYBFCPE+ED
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-13 at 10:00 +0200, Johannes Berg wrote:
> So here it is. hostapd using monitor interfaces instead of the
> management interface. It now uses the AP mode ethernet interface to get
> at EAPOL frames instead of the management interface.

So there are a few more todo items now:
 1) adjust wpa_supplicant accordingly; I don't quite understand the
    structure. Why is there src/drivers/* (for wpa_supplicant) and
    src/hostapd/drivers* for hostapd?
 2) make sure that we don't copy each packet before stuffing it into a
    monitor interface. we now throw away packets with BPF but we've
    already copied them, that's rather wasteful. We should be able to
    get by using clones.

johannes

--=-9n9jHOnaxeSYBFCPE+ED
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwEBf/ETPhpq3jKURAk1dAKCWWe1pF/HUKL+fmu+LViotqEHFWgCcDhdl
pfBaA0/knPTIIefN74CRnOs=
=dN82
-----END PGP SIGNATURE-----

--=-9n9jHOnaxeSYBFCPE+ED--

