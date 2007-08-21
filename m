Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387AbXHUKNL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 06:13:11 -0400
Subject: Re: [PATCH 07/20] mac80211: remove unused ioctls (2)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070821031955.GO1415@jm.kir.nu>
References: <20070815144920.135826000@sipsolutions.net>
	 <20070815145044.386019000@sipsolutions.net>
	 <20070818040725.GG1415@jm.kir.nu> <1187601208.6090.46.camel@johannes.berg>
	 <20070821031955.GO1415@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YLFuc0erk0c4dlsuxikD"
Date: Tue, 21 Aug 2007 12:12:55 +0200
Message-Id: <1187691175.4288.4.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YLFuc0erk0c4dlsuxikD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-20 at 20:19 -0700, Jouni Malinen wrote:

> Agreed as far as debugfs is concerned. However, I thought a bit more
> about the test case where this used to be helpful and I think that the
> test can be implemented differently, so I'm fine with the
> send-group-when-no-associated-STAs option just go away.

Mind explaining the test case? I'm just curious :)

> > > Default WEP

> This is a very good example of something that should have been
> documented since it would take me some thinking to remember what exactly
> was the issue ;-).

Heh.

> I just know that there was one with a common wlan
> hardware design and the optimization was quite useful for some of the
> configurations we were hitting. Without knowing how the WEP keys are
> used, some of the optimizations were impossible to do in hwaccel and we
> had to do most of decryption in software (not a very nice thing on an AP
> with just barely fast enough CPU to handle open network at full transmit
> rate)..

That all makes sense. I've been reworking the set_key() callback though
so that the driver will be able to make most decisions without extra
information, for example I've removed the TKIP+WME=3Dbroken flag in favour
of telling the driver with each key whether it may be used with WME.

> Then again, I think I'm actually fine with removing this now and see if
> anyone complains.. If nothing else, that saves me having to figure out
> now what the configuration was that forced me to add this extra
> information.

:)

Now I only need to go through this patch and see what we agreed on and
what not. I'll do that later.

johannes

--=-YLFuc0erk0c4dlsuxikD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGyrqn/ETPhpq3jKURAquRAKCPjEis1cIoccCT3JnsVDukvXjsxQCeKj/K
B4Wrj/hD8Qd3lg6+7rXX0Kw=
=TDQZ
-----END PGP SIGNATURE-----

--=-YLFuc0erk0c4dlsuxikD--

