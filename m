Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40559 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbZLFScU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 13:32:20 -0500
Subject: Re: WMM classification guideline for applications?
From: Johannes Berg <johannes@sipsolutions.net>
To: David Acker <dacker@roinet.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	patrik.flykt@nokia.com
In-Reply-To: <4B1BF399.1020103@roinet.com>
References: <87d42u6dnd.fsf@purkki.valot.fi> <4B19276F.5080604@roinet.com>
	 <878wdi69u9.fsf@purkki.valot.fi>  <4B1933F5.2010408@roinet.com>
	 <1260096387.3461.2.camel@johannes.local>  <4B1BF399.1020103@roinet.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QGazNcSwMudUqY/qZOH2"
Date: Sun, 06 Dec 2009 19:32:21 +0100
Message-ID: <1260124341.3461.22.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QGazNcSwMudUqY/qZOH2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-12-06 at 13:10 -0500, David Acker wrote:
> Johannes Berg wrote:
> > On Fri, 2009-12-04 at 11:08 -0500, David Acker wrote:
> >=20
> >> I am not an expert on how the kernel handles vlans, but it appears tha=
t=20
> >> the priority field's value is set by the user space VLAN creation tool=
s=20
> >> through an ioctl with SET_VLAN_EGRESS_PRIORITY_CMD which calls=20
> >> vlan_dev_set_egress_priority to map an skb priority to a vlan priority=
.
> >> vlan_dev_hard_header then uses this information to populate the vlan=20
> >> priority field based on the skb priority field.
> >>
> >> In this case it would seem that skb priority and the vlan priority are=
=20
> >> both set and there may be a non-trivial mapping between the two.=20
> >=20
> > But doesn't that also mean that mac80211 can happily ignore the VLAN
> > priority in the packet, because the vlan code will have propagated it t=
o
> > the skb->priority, if the administrator wishes to use it?
>=20
> You are correct on rx.

I don't see how RX matters at all, to mac80211?

>   The tricky part is the non-trivial mapping on=20
> tx.  If mac80211 only looks at the skb->priority and assumes priority 0=20
> means best effort, the code could be missing that skb->priority 0 maps=20
> to vlan priority 7.  If we define that mac80211 only looks at=20
> skb->priority, perhaps we should allow user space control of the mapping=20
> of the skb->priority to WMM priority queue.  This could be similar to=20
> the mapping capabilities in the VLAN code.  That way, an admin can make=20
> sure that the skb priority is mapped to both an appropriate vlan=20
> priority and an appropriate WMM priority queue.

I don't understand. If I TX a packet, on a specific VLAN, then it'll go
through the VLAN code first, get 802.1q tags and then be passed to
mac80211, which ought be be fine with just looking at the priority value
the packet now got.

johannes

--=-QGazNcSwMudUqY/qZOH2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLG/ixAAoJEODzc/N7+QmaslUP/0IkQEnD/N6gaDODXpxiytb0
tJog4iHPex53NBE7cDGqwOU4YQ2NGFw0fIfbdXBQv5VK4t9APPHwsQpO82zEWwyQ
O5Yguf+blFENLAde+16Oi+6L3wNFu3dTtyvwcQpru+HTy6eqRACjMEwOkAjoT1Yu
PEZN6d/WFeeisYhMhRb442DRa1Sa/Y9M0e5aMNgZSUBGEVrERa/gT2Mi3lXN62Xf
Z0ZamD9dUvWoIY/kWgNWAJUF2eA7DfZusZdUYkM6BJvwPbMtgP+QitegmqCJpfAt
fIeLsloDE9t0/CxrFaZYK59I/X8iC0RS78nqfuMEpM7dYzFPUwl9AdUhv8k0BLgz
e3wAAMf33M1ROBvIYwu5dkCkd+ZwSB6EIxaAWXYEfUeOXBs/aD+4XjXjtaOEzN2F
8VnEG02mPmxn3T3iBqCKtG/2+nGQpCmNEccIQlBpF5vZ7DwvaNniSJN94Rp8HO6+
goCvUvnIrKmtTpGMTLmAb2CH2RuAoK9q2piaJoESm2Dgyh1164WWB9RKbD+AasyV
IEdGE5CkSfaOY0P4mHSf0LG949XZKX97/7R71Iyvlh38y2oZXpvHVbw9PnvpXK10
1g5OnJINjjtsQoAIJLr0oBBbInBLZV+QdA0kZrBugA6ZU6QpGVJqGCJetAztDtit
ZcVEu/XKhFXH/pU9wL+y
=/Qw5
-----END PGP SIGNATURE-----

--=-QGazNcSwMudUqY/qZOH2--

