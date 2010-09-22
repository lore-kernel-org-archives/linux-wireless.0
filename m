Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.comsound.de ([188.40.207.2]:40699 "EHLO mail.comsound.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab0IVKsa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 06:48:30 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.comsound.de (Postfix) with ESMTP id 385F66A27A
	for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 12:39:52 +0200 (CEST)
Received: from mail.comsound.de ([127.0.0.1])
	by localhost (mail.comsound.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OcEX6IwPj57i for <linux-wireless@vger.kernel.org>;
	Wed, 22 Sep 2010 12:39:52 +0200 (CEST)
Received: from danmob (static.121.77.40.188.clients.your-server.de [188.40.77.121])
	by mail.comsound.de (Postfix) with ESMTPSA id E771C6A277
	for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 12:39:51 +0200 (CEST)
Date: Wed, 22 Sep 2010 12:39:53 +0200
From: Daniel Berger <daniel@dat-berger.de>
To: linux-wireless@vger.kernel.org
Subject: Manual Control about Sending ACKs
Message-ID: <20100922123953.67a4fc5e@danmob>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/odKj=Mqb0FkPLL/sc/NozQQ"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/odKj=Mqb0FkPLL/sc/NozQQ
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
ACKs directly into hw's memory... and doesn't do much more.

Thus I deduce ACK sending is completely done in hardware.
Is my conclusion and understanding right? Is there any possible solution
to my problem of sending ACKs manually? Would that be fast enough for
the SIFS and other stations' ACK timeout?

I would appreciate a short message to help me out.
Greetings from sunny Germany
Daniel Berger

--Sig_/odKj=Mqb0FkPLL/sc/NozQQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyZ3PkACgkQ+JUYmR11gaCi5wCgxpM6DbjFUC/EUqzNTUEcOkOa
PO0AoINqbZV229vyGQ3lhVzH1OSem/UA
=7R2R
-----END PGP SIGNATURE-----

--Sig_/odKj=Mqb0FkPLL/sc/NozQQ--
