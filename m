Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50862 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976AbYHGMcO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 08:32:14 -0400
Subject: RE: mac80211 aggregation (was: iwlwifi aggregation info)
From: Johannes Berg <johannes@sipsolutions.net>
To: Friedrich.Beckmann@infineon.com
Cc: tomasw@gmail.com, linux-wireless@vger.kernel.org, j@w1.fi
In-Reply-To: <8469FC7DDCBE054D9653D8506E1FF0F001F1FE2164@mucse406.eu.infineon.com>
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217431179.10489.134.camel@johannes.berg>
	 <1ba2fa240807300908x5489e3f8g54ff83e7e5912c0b@mail.gmail.com>
	 <1217509511.10489.140.camel@johannes.berg>
	 <1ba2fa240807311114t3e1b4fb3oe6643fbe28f2c2ac@mail.gmail.com>
	 <1217528597.10489.150.camel@johannes.berg>
	 <1ba2fa240807311216u1a45cf22j219046ab357b0910@mail.gmail.com>
	 <1217592554.8621.23.camel@johannes.berg>
	 <1ba2fa240808010540g660cdaa9p1158a27061e3fcd@mail.gmail.com>
	 <1217595279.8621.38.camel@johannes.berg>
	 <1ba2fa240808061531i9b71df5l21475455d8115f3f@mail.gmail.com>
	 (sfid-20080807_003152_933183_1A6EF13B) <1218107628.23048.130.camel@johannes.berg>
	 <8469FC7DDCBE054D9653D8506E1FF0F001F1FE2164@mucse406.eu.infineon.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-U8YNOJGx8H3yctGuSE14"
Date: Thu, 07 Aug 2008 14:31:37 +0200
Message-Id: <1218112297.23048.161.camel@johannes.berg> (sfid-20080807_143228_275024_DDC51497)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-U8YNOJGx8H3yctGuSE14
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-07 at 14:21 +0200, Friedrich.Beckmann@infineon.com
wrote:

> The aggregation is introduced in 802.11n and A-MPDU aggregation
> always comes together with block acknowledgement. The reason is that
> the component frames of an A-MPDU aggregate are individually subject
> to retransmission but not the aggregate itself.

Sure, but for the purpose of the discussion the actual aggregation
doesn't matter much, and the block-ack was introduced by 11e

> Block Acknowlegment allows to have a configurable number of
> outstanding packets (up to 128) which you can transmit before
> you require an acknowledgement. Therefore you also have to
> keep the packets for which you do not have already an
> acknowledgement. This is similar to TCP windows.

Sure, I can read 11e too :)

> The AC has first hand only to do with the access priority to the
> air, but as a consequence the order of packets is only guaranteed
> within each AC. So each AC needs an individual TID and as a result an
> individual sequence number counter in order to do
> the duplicate detection.

This is a bit confusing to me, I don't think each AC has a TID, rather
more than one TIDs map into a single AC.

> The atheros way is for sure possible but it comes with some constraints
> in building the aggregates.
>=20
> a) You can not dynamically adapt the A-MPDU to the remaining TXOP.
> b) You need to start a retransmission process of the aggregate packets in
>    the AC queue immediatly, because otherwise you cannot release the
>    buffers.

I wouldn't be so sure about either of these, Atheros hardware has an
elaborate scheme for suppressing frames and asking software to requeue
them to the hardware at a later time. I suspect they can use it here to
adapt the A-MPDU to the TXOP and suppress the remaining MPDUs if they
need to, and tell the driver which of the aggregate packets needs to be
retried later. I suppose that would need fairly shallow DMA queues, but
that's doable.

johannes

--=-U8YNOJGx8H3yctGuSE14
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImuslAAoJEKVg1VMiehFYg9kQAJdX8WbYBuq8K1FrJ29WFEme
MoZAuObMzhxju/h4AZjs5zXAWbPrt8bJGN6TawF1flgjZ9FW7Al37A+IzE72FWW1
WI4qzHaHydlyiBe3Rp+jpbi5daHMPXo6vXQuNPB4n0MpqWQYG6trOevIf36leDwZ
dxUq0YFvUbltBa43PZmqG8MGi9sZ5OkrPle7Kd7N3IYcToVQoayLupd0GD1+9RSg
lbSus9ukusYwKIdOHB0GkcgENmKxSYyn7IAuUDg3bBS5Of0jTtfAmZL7RFsYA/u0
sU/hOZR6iUL/8aK/0f4O0QldgsUpYgvFceGDSYmOcw9BslDyMPc38c9jDvXrC1/v
/fzd22e5pzElEoDdXAk2eFTbR6OVSbF3NkQOPIFs/X8ZhKYKOdL0c4r9F9y1hOEy
5QzGbyxBCPVwrVV+tqITkjMxRumkzpYC0GvXBjVM5xOyvyHpasnv7Dh4qb9NhSvj
wqJPIXk4b4dDqBoCFKPErolgEyAw934AJIVkPTnLr+qaF/umDMijxmH0od978w/E
8Y1OcJolvXmqi7BAkGa3XazTycZ6MqeC09ugoz4BXArpBAx/QNrTlSWOUdao51fX
ykJoTUg/aNDyPODbvpmt9XECdPwAoyhtZUWcgE2v8nUaSud3gZOUOc1mRyHirYGc
wzTGLdKsIc1G2N/yg5tD
=FboZ
-----END PGP SIGNATURE-----

--=-U8YNOJGx8H3yctGuSE14--

