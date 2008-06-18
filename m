Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59679 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbYFRPnU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 11:43:20 -0400
Subject: Re: BUG: mac80211: Some connections hanging in 2.6.26-rc6...
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Price <andy@andrewprice.me.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <g3b7l1$t1o$1@ger.gmane.org> (sfid-20080618_165548_538551_7C9BA1D8)
References: <g38o2j$1uh$1@ger.gmane.org>
	 (sfid-20080617_181742_447297_198DA5E5) <1213773749.3803.155.camel@johannes.berg>
	 <g3b7l1$t1o$1@ger.gmane.org> (sfid-20080618_165548_538551_7C9BA1D8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EbrMpse7ZAyp9Jhe7Loc"
Date: Wed, 18 Jun 2008 17:42:41 +0200
Message-Id: <1213803761.1312.29.camel@johannes.berg> (sfid-20080618_174323_804226_F901A061)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EbrMpse7ZAyp9Jhe7Loc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-06-18 at 15:55 +0100, Andrew Price wrote:
> On 18/06/08 08:22, Johannes Berg wrote:
> >> This also affects some http requests such as loading slashdot but not
> >> others (perhaps small ones?) such as twitter API http requests. It doe=
s
> >> not seem to affect connections to other machines on my LAN, only ones
> >> over the internet.
> >>
> >> I've tried tcpdumping to get more info but when I run tcpdump the
> >> connections work again (if a tiny bit slower).
> >=20
> > Can you try tcpdump with the -p flag? promisc mode might affect things.
>=20
> I tried using -p and it made the bug go away again. However, I have some
> packet captures from running tcpdump on the router while the bug was
> occuring and from loading them into wireshark it seems there are some
> (suspected) retransmissions with bad checksums. I've posted my packet
> captures here:
>=20
> http://sucs.org/~welshbyte/lw/tcpdump_bad0.pcap
> http://sucs.org/~welshbyte/lw/tcpdump_bad1.pcap
> http://sucs.org/~welshbyte/lw/tcpdump_good0.pcap
>=20
> The two 'bad' ones were captured on the router while the bug was
> occuring. The 'good' one is for comparison and was captured on the
> router like the others but while running tcpdump on my laptop made the
> bug go away (I hope that makes sense).
>=20
> In all cases, the test was to ssh to a remote server. The two bad cases
> were closed before the password prompt was reached and the good case was
> ^C'd at the password prompt.
>=20
> I hope this helps,

Thanks. Unfortunately, it's very hard to tell what is causing the bug,
but Dave Miller and I analysed the problem and found it to be caused by
a disconnect in thinking -- I assumed skb_header_cloned() would check
for the full skb data (which seems to be called 'head' in some places),
not just the header; he, on the other hand, wasn't aware of software
encryption mangling it all so we never noticed that the commit you
bisected it down to was wrong to start with.

Hence, that commit is now reverted, see
http://git.kernel.org/?p=3Dlinux/kernel/git/davem/net-2.6.git;a=3Dcommit;h=
=3D3a5be7d4b079f3a9ce1e8ce4a93ba15ae6d00111

johannes

--=-EbrMpse7ZAyp9Jhe7Loc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWSztAAoJEKVg1VMiehFY2xsP/2SxqisC4MQq+ypPkvEbOw7v
xC+aVP0wYT+R23k9ByUoDDDwNcfx6s/hWK546GBwxcnpNewKi8/2R+fUR2pcdJ4f
AamzID8rSfQLa1oqMi6n+YDCIDpvoB+7XETH/BTu7aThzIQdDnFhoGy6zL3vQb5L
vlS2hkKEXOE9s2d4kK6aT8gUDlbqdYAYxTnsX0VV2+6VtOeVV3pmIFA/xwnhaXZL
devZ+4ZiSjx6+70UCySuV0zp7Nr5OVHxohmdhu65pMbbR3z94MIfR3iowj2SL50F
H1CKCeW4FsDxDGjbHe6pexH9ODah70rlJ0tk5qHDhBEDr+GfG2GcEBTpR3MwhEwJ
hlu0cYlgokKlFomhhGNV9/QfwF1v3mkWixez869gyKzAzA5eoiUps69pQZxe7wBp
1wMKs+Ibg9tljKlrypT8rZa/7MG+3iXC7he+GsTU+kKXpxm8Yj5tnDrzond441GV
crNfZhuAR8bFDqEHyrapAEUZchUqoYCWb+mxvBrN6/Rkq5iQl0P/mSNQEtKbzuZ4
Dihldnv1AJ3fnmB2hI3YBGYVPCbblHBm3PQCHHjolrlmMrfa6P5cuUVKacNZZgKG
3C/oQsWjZPwuO3GA8P8jhER8lowy6zkLJsQ9FVCkmWFNL7Q/v95SOYCWUJj2wCGr
L19gvYQr/hXp35mfVplU
=I7Oc
-----END PGP SIGNATURE-----

--=-EbrMpse7ZAyp9Jhe7Loc--

