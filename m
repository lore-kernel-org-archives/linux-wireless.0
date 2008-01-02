Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44995 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYABRpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 12:45:41 -0500
Subject: Re: [PATCH v2] mac80211: better rate control algorithm selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20080102172505.GA9772@uranus.ravnborg.org>
References: <1199283424.4172.88.camel@johannes.berg>
	 <20080102172505.GA9772@uranus.ravnborg.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rp94jLPlDm7gNZXis5Sc"
Date: Wed, 02 Jan 2008 18:45:01 +0100
Message-Id: <1199295901.4172.111.camel@johannes.berg> (sfid-20080102_174544_140233_E11E3E61)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rp94jLPlDm7gNZXis5Sc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > +# objects for PID algorithm
> > +rc80211_pid-y :=3D rc80211_pid_algo.o
> > +rc80211_pid-$(CONFIG_MAC80211_DEBUGFS) +=3D rc80211_pid_debugfs.o

> > +# build helper for PID algorithm
> > +rc-pid-y :=3D $(rc80211_pid-y)
>=20
> Is this extra indirection ( rc80211_pid-y ) a preparation
> for future rate algorithms or was it just coped from my proposal?
> It is not needed and it does not help readability.

As far as I can tell rc80211_pid-y is needed to build rc80211_pid.o from
rc80211_pid_algo.o and rc80211_pid_debugfs.o for the modular case, no?
Hence, I just wanted to keep it symmetric for the non-modular case.

> A second note - but more as a personal taste..
> I prefer +=3D assignment in preference of continued lines.
> So=20
> +mac80211-y :=3D \
>  	ieee80211.o \
>   	ieee80211_ioctl.o \
>  	sta_info.o \
>=20
> would become:
> +mac80211-y :=3D ieee80211.o ieee80211_ioctl.o
> +mac80211-y +=3D sta_info.o

Yeah, I was hoping the diff would be smaller this way because it was
already this way before.

johannes

--=-rp94jLPlDm7gNZXis5Sc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3vNnKVg1VMiehFYAQLp3Q//fzx7wVOEWGkgs+b3b1tZxRa94ffXvZHY
iEG6ST+DLD3RP5gK9hiGkvEYH6qgPtCyEX7VC8jjPFZ2S1LeHIPajQqT/1/6787a
vLj74pLol1J0V5ehWy8b2nJq5eQB3qFqfL2KOtMyNYSLEbKk4RQedsoREkrCIrPu
B8A32f6XPzvwEBFF/iKWFZJruPP2Dk+q3LoRSOiZaFMKV/LlgYtOEQEUQFQexEQW
ORTevssqwSli8mIJynJPtMoDWduc3KThTPCBGZezSvxVutgkwxTH5f1glEf9T2it
S+siTLUKZRifTEiG5i3FD8aP9kgQMbckyUzMjVv3r4m4Ij/p0dUsT3QAUomeO+k2
tOPCZjOk0790OXjFaTvCu8ahwegt9+camvTF44pAV7Mz5KSh38AjqG6kgYMZwj5Y
P4EttNk1lhC413hoJV9YkZGNjDfl/TXu0aphp69vZvQCVEuQ/q9248SIWgTdlNCV
UywteygcdpN/BNGZQNmigmeSn0gV68bA6val45/X9NpcTJz42Tn503w/eYN2HVRE
XUVakP54evkLPe+heE2k+sKlW/hn6b//h1goYPuYuJIw1qgUg0IU82t6C/kjRHOI
BluyHYi+zunoVIzsZlY6H84JFoUS0Ph/WAzorbN6AF5V8UvW++wgp5008/NAp0/u
stmpJe4txoY=
=UAKm
-----END PGP SIGNATURE-----

--=-rp94jLPlDm7gNZXis5Sc--

