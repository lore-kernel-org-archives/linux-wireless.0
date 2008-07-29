Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37605 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbYG2Lvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 07:51:31 -0400
Subject: Re: [PATCH] mac80211: partially fix skb->cb use
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217331773.6379.25.camel@localhost> (sfid-20080729_134300_214751_172329C5)
References: <1217323927.10489.9.camel@johannes.berg>
	 <1217330604.6379.12.camel@localhost>
	 (sfid-20080729_132329_995714_6D2C9701)  <1217330667.10489.19.camel@johannes.berg>
	 <1217331773.6379.25.camel@localhost> (sfid-20080729_134300_214751_172329C5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xQdQxQZQSYMOIc4zdN3V"
Date: Tue, 29 Jul 2008 13:51:28 +0200
Message-Id: <1217332288.10489.33.camel@johannes.berg> (sfid-20080729_135134_676997_82B7EB83)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xQdQxQZQSYMOIc4zdN3V
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 13:42 +0200, Luis Carlos Cobo wrote:

> One of the options I was thinking about when implemented that was to do
> the forwarding in what was once equivalent to ieee80211_data_to_8023()
> function. Then we do not have to do 802.11->802.3->802.11 series of
> conversions, and we would send the frames to be forwarded directly to
> the master device, speeding up things a bit.

That sounds sane to me, then you don't need the cb at all, do you? Can
just send it to the master dev with skb->do_not_encrypt set, right?

In fact, looking at the code, there seems to be a bug with promisc, are
you sure it's allowed to netif_rx/dev_queue_xmit the same frame?

> I think the most elegant solution would be to add a rx handler to be run
> before ieee80211_data_to_8023() dealing with forwarding and sending
> frames directly to the master device.=20

That sounds reasonable.

> Would it make sense to deal there
> too with the forwarding for APs and VLAN interfaces done in
> ieee80211_deliver_skb?

I don't think so. AP mode doesn't really forward MPDUs but MSDUs, which
should make a difference when encryption is enabled.

johannes

--=-xQdQxQZQSYMOIc4zdN3V
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjwQ9AAoJEKVg1VMiehFYNZAP/05XBaOogWuL2xzZ/RFcbXLL
f528QVTpgH8skklNhwUGKgTBI8xZktXDGi3vebgC3ilFhGx5vNzxJZvI/yir4I1y
teVaA3X5QVGu00tSiyPCXTk5Ffw0CzMyu1LI/vxV55quTjstfBGl0J4/WRjrj1AZ
05P/t9ks8K8EYrvugGNyzjUwvXULbiIKhv4oGaG3FNCZ4wD37S7mn0QP2KY/Ulid
Q5iV4jm0Hhj5oQwEC9P3HCy0Agf0PwMlFq2aaUyBRhsJrNFbjsDFm/0TJTyhdjp5
g4Nez1UDME7KCE9e4srN8xStDHgRMTikNwhgtZQqITxELcd3tvyPE2rvqrsesRyo
p4dYlvtuNBbDlXUuj1AoNUfm7pZ6wh4WYiOl2HBfloL/8kfDtnHW43oldyqcvSpG
S/sLSLjD8ZgJfGf84JaVLw0uZPNodkvuEFVE1McdF1jm4bNMIXHxxtdwWsWASaCc
XNPEo6gZs8nxOQhD/GLgeU+C0ym3be45Ifyw2dPWYmPugJiZKujUlJOiSVHwrMet
iS+K+VJsPq7JMlnZPC4RAki4JsdxoaPYpp3tijMWyptRTKaXYTGWAg2mL583J6mF
OR5xXjJbtpVk0kUwk723bXq0upv6htlAXXF9KhR5C4jL8oZcFZOV3i2+iQ/tjgpM
0TJfyhrQLIVm/rJ8AFrY
=VZ9z
-----END PGP SIGNATURE-----

--=-xQdQxQZQSYMOIc4zdN3V--

