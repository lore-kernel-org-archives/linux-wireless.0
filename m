Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:11445 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751093AbXGaFIN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 01:08:13 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: [PATCH] zd1211rw-mac80211: debug output for mac80211 ops
Date: Mon, 30 Jul 2007 22:06:20 -0700
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org
References: <20070730023128.99E927B409F@zog.reactivated.net> <20070730145125.GC6586@tuxdriver.com> <20070730225205.GA17252@deine-taler.de>
In-Reply-To: <20070730225205.GA17252@deine-taler.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1803131.Q9oTZoZgYN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200707302206.25489.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1803131.Q9oTZoZgYN
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 30 July 2007 15:52, Ulrich Kunitz wrote:
> John W. Linville wrote:
> > On Sun, Jul 29, 2007 at 08:21:31PM -0700, Michael Wu wrote:
> > > On Sunday 29 July 2007 19:31, Daniel Drake wrote:
> > > > This patch adds debug output to mac80211 operations. This is
> > > > intended to sort out the issues with the interface semantics.
> > >
> > > Ugh. I really hate enter/exit and especially these since they are open
> > > coded. What do you need clarified about mac80211 interface semantics?
> >
> > I agree, these are a bit ugly.  Do you intend them to be permanent?
>
> Guys, actually I looked into iwl-base.c and there are also leave
> and enter statements for exactly the same mac80211 operations. I
> would appreciate, if somebody could explain me the difference.
>
None. I didn't like the ones in iwlwifi either.

> Please notify that the messages will only be compiled into the
> driver if ZD1211_DEBUG is set. I could agree to take them out,
> after we have fixed the multiple interface issues, but right now
> they help to make the logfile quite readable. They help also to
> check my understanding of the struct ieee80211_ops functions.
>
I would prefer if you kept it in your tree.

> Asked what I don't understand about the mac80211 interfaces, I
> have following questions:
>
> Why does WIPHY has only a single MAC address?
>
That is for the mac address stored in the eeprom.

> Though ZD1211 has only one RF chip and one baseband processor --
> which represents a single PHY device in my opinion -- it can
> support two MAC addresses. Sure MAC80211 can give different IP
> addresses to different interfaces, but currently I'm not sure, how
> they relate to the address in the WIPHY.
>
The proper address to use is given in add_interface. Don't worry about the=
=20
address in wiphy.

=2DMichael Wu

--nextPart1803131.Q9oTZoZgYN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGrsNRT3Oqt9AH4aERAhZrAJ4quIB38f7nD/ACVwzH12GjT70YuACfWhRS
cZKTqxoh7gCIYiv7I9Q6O4k=
=wOFL
-----END PGP SIGNATURE-----

--nextPart1803131.Q9oTZoZgYN--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
