Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43268 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757846AbZLNQsi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 11:48:38 -0500
Subject: Re: Ethernet bridging with wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <Pine.LNX.4.44L0.0912141131190.2685-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0912141131190.2685-100000@iolanthe.rowland.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Fd/JxOe8e8AFna+IpWp2"
Date: Mon, 14 Dec 2009 17:48:35 +0100
Message-ID: <1260809315.2442.408.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Fd/JxOe8e8AFna+IpWp2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-12-14 at 11:35 -0500, Alan Stern wrote:
> I just tried to set up ethernet bridging between the wireless interface
> and the wired ethernet interface on my laptop machine.  It didn't work. =20
> As far as I could tell from the tcpdump output, the wireless stack
> doesn't want to transmit packets with a foreign link-layer source
> address.
>=20
> Is there any way around this restriction?  Or must I resort to IP=20
> forwarding instead?

There's no standard way around this restriction, the on-air packets are
required to be transmitted with the correct TA (transmitter address) [1]
which also must be the SA (sender address) in the regular frame format,
since the DA (destination address) and RA (receiver address) must be
present and the format only has three addresses. In recent kernels (what
will be 2.6.33), we have added code to disallow such configurations
since they cannot work.

However, if you control both the AP and and the station (e.g. laptop),
and your AP and station both run mac80211, then you can use the
four-address hack that Felix has been developing. It will then use the
standardised four-address frame format that normally cannot be used
between a station and an AP to transfer different TA/SA. I'm not sure if
he has documentation on this yet.

There's also ebtables NAT, but I have no idea if/how that works.

johannes

[1] otherwise the ACK mechanism cannot work

--=-Fd/JxOe8e8AFna+IpWp2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLJmxfAAoJEODzc/N7+QmajFwP/RSoEn7sr1G1AM9OZmgInRLC
OcnfW2siw835PPk4F6Aniz25iQj0fSGQEyF6kDTILTBQ2uMj5TOMUWfhFl3UDWSn
sOPYosI4bpYSkOvclO1qMbTFvWl6YXpikNoL/fQWZMPlxjfD7T/Vhk3+gyH6VX16
Xu3K0Rq8SDzUk9luGChuZi+n84O52ZbPzGQGh62e5cDzjRgR+fT6FjWPYo5aeVIh
hY9Bz35yEzC4Y4Pf1v8OcFItRZRLhbO0w5iF44ExaWqNMXEq7eYLFRqV5tqmUq1g
lNy/VbRtSfE/9odOopUbln8XoEhrHfZR9NjXqjavjyCu8ghSg1tWnCgIAwWF854u
CfZG0FcPjqDSF/DpLXzzizuruzBPYDan6i0uxITIL2mTQuwz8adbUaFVM8IDXIbO
PqA5O8KJzTqBRcMBvLR6ZRtMQggb9UIJRSH6MDcLcjeXly7ChGuY7/HgI4g0DK1T
GbpBsVJ3uCg75hfA0mCbTsyRc25K0ucSEJ0YmrFm6anpjTr7YZH1fmXlbJmWE5UL
52IdiSgDS2lAdrLCGXpgzj03n8RX7wl9pHutbCPV6zQq7bIrP5LHPhl2qvmdTVT/
hKndFbLtnluDFr6maJ6d0wATJIPDU1dJaCvWSe5KyVUvwBVEsbXu4OmLgqsy0bzq
ihWh4iKkphSPo/pO1Yu1
=1JVO
-----END PGP SIGNATURE-----

--=-Fd/JxOe8e8AFna+IpWp2--

