Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45596 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbYG2Lgu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 07:36:50 -0400
Subject: Re: iwlwifi aggregation info
From: Johannes Berg <johannes@sipsolutions.net>
To: tomasw <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217331138.10489.24.camel@johannes.berg> (sfid-20080729_133224_832207_85DF1976)
References: <1217331138.10489.24.camel@johannes.berg>
	 (sfid-20080729_133224_832207_85DF1976)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ktde1t4MOOSzsCG/2Z5+"
Date: Tue, 29 Jul 2008 13:36:48 +0200
Message-Id: <1217331408.10489.26.camel@johannes.berg> (sfid-20080729_133653_598683_754D9EC1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ktde1t4MOOSzsCG/2Z5+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Say a station enables aggregation on a low-priority TID, manages to fill
> the hw queue because high-prio frames are eating up all the airtime and
> then disables aggregation again. Now another station enables aggregation
> on a high-priority TID, and gets assigned to the same hw queue. Now
> frames for that station will be stalled, no? Seems like a bug to me.

Never mind, the queue won't get reassigned. I was just confused by a
bunch of superfluous code in iwl-tx.c. You cannot ever run into having
IWL_EMPTYING_HW_QUEUE_ADDBA set because you wait for the queue to drain
before fully disabling it.

johannes

--=-ktde1t4MOOSzsCG/2Z5+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjwDMAAoJEKVg1VMiehFYZOMQALmMyGLwwYOb/HZ0HMCT5xtu
zUadJIJ1zfxP7v+/R+RtxlDB1X9M4+/5LL9hOdZjNDnfJbqSeTDUD65qRdHbOGdt
gHHgBVEonpn2mJ5p+J/X8sgS8t/E3ikMXF+Q5DHUKn9oxmUsvMb+9whMFjwMKPql
8039sL2FO0/Dj8oiJqnzv6lOhFCOhYPiHRo/ESTbUqAQCcJI8M1csvMXDVQsEc/k
HLjgPo2K+8uZREl7aYfgzKmIPgJrTEotLRmeMPhEBcFl4bQCFhsj8zXJk2XgEuy8
knFmLAmG8zeM7dTYN/zSma802Vid1D2W8l3wTnndAMZ0xpoAejfFwDPX/JLhvd+G
pV0Z4YJPVxATBpAufj7cMXmA7wfehYy02aR3lyu6RvCVNR/p3aIXvmoaXK9f1a9n
qb/i5e1W2PIpZRXHH1NiHxk1yRO82IRNk38spCFxV/qXdEa3PUeD5SGMSedV+EMy
+6NOGmhDvOZcKHztm4ec+2z3kvxqqCeCL7aYXU56BKRzty9Dln+o5Cn4fCjdDUzX
mqywIJxq/Abdi0yh5WvfonvMcmAjVk2q5R+nZ9DfwDo81qdqFELoKboaBJ8Ejbpw
hox7DAkYJzzlx7pnuyJfUU6/unzQMVL7mmz/OGtHAv0tehXqMr9jQksnb/k6U1gZ
AkSrg2S4ZD1YWzJ98Tn+
=P3kb
-----END PGP SIGNATURE-----

--=-ktde1t4MOOSzsCG/2Z5+--

