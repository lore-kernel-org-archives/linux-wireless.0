Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.comsound.de ([188.40.207.2]:51796 "EHLO mail.comsound.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab0IVKn3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 06:43:29 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.comsound.de (Postfix) with ESMTP id 1FBF06A279
	for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 12:36:18 +0200 (CEST)
Received: from mail.comsound.de ([127.0.0.1])
	by localhost (mail.comsound.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FfxyG+HNyDl0 for <linux-wireless@vger.kernel.org>;
	Wed, 22 Sep 2010 12:36:17 +0200 (CEST)
Received: from danmob (static.121.77.40.188.clients.your-server.de [188.40.77.121])
	by mail.comsound.de (Postfix) with ESMTPSA id CC6836A277
	for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 12:36:17 +0200 (CEST)
Date: Wed, 22 Sep 2010 12:36:28 +0200
From: Daniel Berger <daniel@dat-berger.de>
To: linux-wireless@vger.kernel.org
Subject: Manual Control about Sending ACKs
Message-ID: <20100922123628.61921924@danmob>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Op9L4qohRllC_5zrIVVf1rS"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/Op9L4qohRllC_5zrIVVf1rS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

im a Student in Germany currently working on a project concerning
wireless security.
For testing purposes we would like to send ACKs to packets, which
weren't adressed to us, or suppress sending normal ACKs.
I've looked through mac80211's code and found there much, what looks
like the ACK-sending-action is triggered in rx.c (we're checking CRC,
length, adressed to us, ...). But, one the other hand, tx.c states in a
comment
/* TODO: These control frames are not currently sent by
* mac80211, but should they be implemented, this function
* needs to be updated to support duration field calculation. *
[...]
* ACK: 0 if immediately previous directed data/mgmt had
*    more=3D0, with more=3D1 duration in ACK frame is duration
*    from previous frame minus time needed to transmit ACK
*    and its SIFS
*/
Furthermore ath9k e.g. write parameters for configuring the sending of
ACKs direct into hw's memory...

Thus I deduce ACK sending is completely done in hardware.
Is this right? Is there any possible solution to my problem of sending
ACKs to=20

--Sig_/Op9L4qohRllC_5zrIVVf1rS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyZ3CwACgkQ+JUYmR11gaAKsACaAh664GBar1EU7k36Un8V10Ht
6TEAoLcZr9rMz4USK3ncNc/Jd+sNXDCu
=/MKb
-----END PGP SIGNATURE-----

--Sig_/Op9L4qohRllC_5zrIVVf1rS--
