Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41250 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739AbYFJPL5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 11:11:57 -0400
Subject: Re: mac80211_hwsim - simulator of 802.11 radios for mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080610150227.GA4913@jm.kir.nu>
References: <20080610105058.GA6961@jm.kir.nu>
	 <1213096575.3668.6.camel@johannes.berg> <20080610124724.GB6961@jm.kir.nu>
	 <1213103378.3668.10.camel@johannes.berg>  <20080610150227.GA4913@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-b9xh6ko17k1J4Y/lFxwa"
Date: Tue, 10 Jun 2008 17:11:21 +0200
Message-Id: <1213110681.3668.30.camel@johannes.berg> (sfid-20080610_171224_716881_06E8203D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-b9xh6ko17k1J4Y/lFxwa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > You should probably use the _irqsafe versions of rx and txstatus too.
>=20
> Hmm.. That was interesting.. Changing txstatus to use _irqsafe is was
> fine, but changing ieee80211_rx to ieee80211_rx_irqsafe triggers
> something bad.. Loadavg jumps sky high the moment I kill hostapd and
> ksoftirqd/0 and rmmod (which I ran after killing hostapd) are taking all
> CPU.. I can hardly type a command at that point. Looks like something
> goes horribly wrong with the extra queuing with ieee80211_rx_irqsafe.
> Maybe sending something to a netdev that is down ends up in a busy loop
> with a frame or something. In other words, I did not change to use
> _irqsafe yet, but will do once I have more time to figure out what on
> earth is going on here.

Hmm. I suspect you called rx_irqsafe _after_ the radio was stopped (via
mac80211's stop callback), and at stop time we also disable the tasklet,
so something probably goes haywire if you tasklet_schedule a disabled
tasklet.

> Yes, I added the global radiotap monitor to hwsim (ifname=3Dhwsim#) and
> left the hard_xmit function empty with a TODO comment.. The netdev from
> outside mac80211 is quite useful since it can be set up before any of
> the mac80211 netdevs and it is possible to capture all frames from the
> beginning.. If needed, we could add some more flags to the radiotap
> header for indicating what was done with the frame, but that is
> something that can easily be added later.

Yeah, true, good to have the simpler code in place first anyway.

> > The design I had come up with a long time ago allowed userspace to
> > control each radio by having each _radio_ have a raw netdev like this
> > and not doing forwarding in the kernel but relying on some userspace
> > tool, but I guess that much more complicated.
>=20
> That might be useful for some of the tests. I was interested in adding
> some kind of interface to make it easy to design test cases from user
> space, but the current code was so simple that I did not want to make it
> any more complex in the first version. Anyway, it might make sense to
> provide option mechanism to allow more user space control since I'm also
> interested in things like testing rate control with a programmable
> signal strength/channel quality and I do not really want to see the
> controller for that simulation in the kernel..

Heh, yeah. I'd like to have it more dynamically configurable too, but we
can add that later as well. Maybe some debugfs stuff or so that allows
disconnecting a radio from the "virtual air" at which point a hwsim
per-radio netdev shows up for that one. Anyway, future, when needed.

johannes

--=-b9xh6ko17k1J4Y/lFxwa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITpmWAAoJEKVg1VMiehFYLtAP/2UTw+NmfhK7INpN0rvFUYDw
BnvHm4s+Po30IyY5EHgUKCXTXfUTmnPzqPE5TkndTqZG+1i+NK9Rz0QtS4oX23ik
vfBsSG1EKIvEOmMCn44ZLsLRSW7ZnYmSASEr90LqJYjtqOVaRNx1E3VXYifNpAnE
JpqGwCm4sHu1Gc03UbNbwDkVU0eul9akV+4gbuY3RZ/R53hzdYkxtjQJOuyI20T5
pb2k1u2xxzf4Ht3vzd7kj3B+5WI2hrOeernpabmddQYG6Pm8grbkyRMfjg4Rfnq0
cSZfHhLZ1p0SyWqXaxhMXdbbQjA+MohaZXZYNWKV+kqInHjNvDu76pfanDisTiMx
gU8zxpJCjdToXYa4EdlS8RIDwvoo4LBWaHJUYAXUQ2dbnqNARmQNHQdjys5zR3db
lbh6J+77zf7IWgFwIJzSYYEn7Bfj2h3lH1wxwlYygRJBE9CXHCJwre+7CSbBChKC
CvlE3fLySnzGOgI4VE5J1eJHJYGhsN5JZRW/4+FzG6kw6Z0ov3wmx5G5zm1skWIM
9jqwdm0rtoN5iqN2Ji6/+UJ8wiNwV05hDV+/B1p5uxiNdBiSfa1O9YMwnLNglsUA
SGEmARowrmtQ7Zq1Xt5cuEiQFuPgtgoT1Cmye5XruUkhlK3NQwo1bMvtFzBWRkSy
oD8qhsTXD0zdP3eb6XDQ
=ato1
-----END PGP SIGNATURE-----

--=-b9xh6ko17k1J4Y/lFxwa--

