Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33352 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbYCQMvf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 08:51:35 -0400
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request
	a Phase 2 key
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1ba2fa240803170540n2e6fb398p84abfb34e4124042@mail.gmail.com> (sfid-20080317_124044_732543_890912DE)
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
	 <1205591906.15910.44.camel@johannes.berg>
	 <1ba2fa240803161721q5d01bve2292f99d3fe9eb8@mail.gmail.com>
	 <1205747912.1614.19.camel@johannes.berg>
	 <1ba2fa240803170320i4805e055ofebbbd9928a59354@mail.gmail.com>
	 <1205751455.1614.25.camel@johannes.berg>
	 <1ba2fa240803170540n2e6fb398p84abfb34e4124042@mail.gmail.com>
	 (sfid-20080317_124044_732543_890912DE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-g+FaiSgfmuEJrt06McIm"
Date: Mon, 17 Mar 2008 13:51:16 +0100
Message-Id: <1205758276.1614.45.camel@johannes.berg> (sfid-20080317_125155_504145_5FA3F686)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-g+FaiSgfmuEJrt06McIm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Actually I've misled you a bit. This is defined by IEEE 802.11i in
> section TSN Transition Security Network. Where legacy WEP-only STA and
> RSN-enabled station can coexists.  In this case Legacy stations use
> static WEP key and RSN enabled station uses more advanced security
> setting. RSN enabled station will be configured with WEP as a group
> cipher  (spec name)
>=20
> Here is a quote from the spec.. there is much more about it it's a bit
> spread in the spec.
>=20
> 3.123 Transition Security Network (TSN): A Security Network which
> allows the creation of Pre-Robust
> Security Network Associations as well as Robust Security Network
> Associations. A TSN can be identified
> by the indication in the RSN IE of Beacons that the group cipher suite
> in use is WEP.

Huh ok. But how would the WEP legacy station be able to determine that?
Or does it just try to use WEP and succeed? TBH, I was unaware that this
existed, this does make it a bit more of a problem than I thought then.

> >  > >  Note that there's another case in AP mode where bc/mc keys are TX=
-only,
> >  > >  those are added with a zeroed MAC address.
>=20
> >  > I would prefer also in this case a clear flag rather then playing wi=
th
> >  > ambiguity of destination address.
>=20
> On second thought is that AP has only TX group key while STA has only
> RX group key so I
> m not seeing here any need for flag.

Hm, well, I didn't really want to require the driver to keep track of
the current operating mode, so that's why I used 00:...:00 vs. FF:...:FF
for the group keys.

> >  Yes, that would indeed help. Except that WEXT can't actually give you
> >  the distinction so discussing these points right now is pretty moot wh=
en
> >  we can't even do it properly as far as I can tell. Might be possible t=
o
> >  infer the information with the key management enabled flag thing...
>=20
> You have encode ioctl which is called only for static/legacy WEP or
> you use CIPHER_NONE  for when using encodeext
> For WEP in Pairwise and Group Key you use WEP40/104

Is that really done though? I mean, does wpa_supplicant not also use
encodeext for WEP keys?

> /* IW_AUTH_PAIRWISE_CIPHER and IW_AUTH_GROUP_CIPHER values (bit field) */
> #define IW_AUTH_CIPHER_NONE	0x00000001
> #define IW_AUTH_CIPHER_WEP40	0x00000002
> #define IW_AUTH_CIPHER_TKIP	0x00000004
> #define IW_AUTH_CIPHER_CCMP	0x00000008
> #define IW_AUTH_CIPHER_WEP104	0x00000010
>=20
> It's not well defined in wext but we can at least define the interface
> from mac80211 point of view.

True. So what change do we need?

johannes

--=-g+FaiSgfmuEJrt06McIm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR95pQ6Vg1VMiehFYAQKI5RAAi+Jqzj9oyNohO/Xh+DXuHcpafxDZsUiA
UrIp8PTnU7gxDeHibzIn2hC8StikJHpejkFXbvy2SVQ5Yw2qA76Jl28g12+T3MuC
+gKAVc8bGq0TiOVWRizqHV/I9asKSQhGKxGmp8WYYdLRXabgkjwSrVr1i4DN2LMH
bNN7uYzbJfyQvCtVvSna923he5XdYnqAQvtjiHRmBswcY6phUZjw2STCkl89JATv
wZiVYzgU57Fx9k7w06agAvPbsiljSG07HjvP9IOcRWmDAWE3Zw9yoIYHP8cYXOC7
ddK4Ma5hK3wyOxBavf9avRc7DlkhCfPqDtwlN6S1NC9HTwXM7C2wi1mfTj8j2KMB
LmzQ9ljFHuQddzYPjz3XYAiXvIFD+Hn/tHHwvfrN+vVmDn8te38ilJ9Vc2j1O+lR
gMfEs8cSmAAapIIZwLKOyofE4b5xEYqMqG2vYagnCyfSSIg9hpRzhoirUSy1yfqP
W1A92/CdBYEpM0R8LELLC7dLZGUnJbTA/Fblc3vBDYfORlsd8HzePpU1MMJjutfC
A2yDRBt7W8MZBYaWpnTEC1crqK9NoPSY7h+Ivql2K6GPCsK5b7giuq1w+OP0GGTY
ZYCOSS4KMZINegKTD83mkoUvEFCpArVB4uE8uw3tv8XyWAh2gk5/4J6fgrkNEQhy
U/qZPHfiOJw=
=IfKd
-----END PGP SIGNATURE-----

--=-g+FaiSgfmuEJrt06McIm--

