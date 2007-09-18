Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42436 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbXIRKOF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 06:14:05 -0400
Subject: Re: iwlist and network-manager bug report
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070918003628.GA28939@bougret.hpl.hp.com>
References: <1189526874.6161.30.camel@johannes.berg>
	 <1189610572.5644.28.camel@xo-3E-67-34.localdomain>
	 <20070912170153.GA25785@bougret.hpl.hp.com>
	 <1189667496.6161.77.camel@johannes.berg>
	 <20070918003628.GA28939@bougret.hpl.hp.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EpwyozYXg9i2F4VLBzyz"
Date: Tue, 18 Sep 2007 12:15:22 +0200
Message-Id: <1190110522.23521.36.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EpwyozYXg9i2F4VLBzyz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-17 at 17:36 -0700, Jean Tourrilhes wrote:

> > Yeah, I don't think they cared for non-ascii at the time.
>=20
> 	There were not concerned about UI, witness the mess in
> specifying WEP keys (do you want passphrase with that ?).

Is passphrase actually specified in 802.11? I always thought it was some
external hashing but didn't look it up. But yes, I don't think in 1999
many people cared about general UIs...

> 	I'm talking of all driver that have their own private API :
> --------------------------------
> # cat /proc/driver/aironet/eth0/SSID=20
> MY_ESSID
> --------------------------------

Oh. I didn't think that existed. Is there any point in that or could we
just remove it?

> 	I forgot one little issue.
> 	Remember all the fuss about the ESSID API change a long while
> back ? The goal was to support ESSID a array of char as opposed to
> ASCII strings in the API. There was a big fuss, and at that time John
> did a backward compatibility hack to support the old API in the
> kernel.
> 	Well, the hack of John is broken on the receive side. It
> basically prevents us to implement what you want, amongst other
> things. This is what you currently get :
> ---------------------------------------
> >./iwconfig eth0
> eth0      IEEE 802.11b  ESSID:"my_essid\x00"  Nickname:"HERMES I"
>           Mode:Managed  Frequency:2.422 GHz  Access Point: Not-Associated=
  =20
>           Bit Rate:11 Mb/s   Sensitivity:1/3 =20
> ---------------------------------------

Hmmm. So we already \x00-escape the trailing NUL?

> 	I've already sent the patch to fix that to John, don't know
> where it went :
> 		http://marc.info/?t=3D118401941300001&r=3D1&w=3D2
> 	I can resend you a copy if you want. I feel this patch ought
> to go also in the various stable series.

Probably got lost, you should probably resend and to -stable as well.

johannes

--=-EpwyozYXg9i2F4VLBzyz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG76U6/ETPhpq3jKURAuKfAKC1DEeV5ncTNEmibcVZRAqnHt/BZwCfahZw
K3SvRjzmomZ8x73kNTrnFjM=
=dlAj
-----END PGP SIGNATURE-----

--=-EpwyozYXg9i2F4VLBzyz--

