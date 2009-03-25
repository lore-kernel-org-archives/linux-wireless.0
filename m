Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54463 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbZCYUGx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 16:06:53 -0400
Subject: Re: wireless powersaving (in NM?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Dan Williams <dcbw@redhat.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <87ab791isj.fsf@litku.valot.fi> (sfid-20090325_205334_758597_39212B61)
References: <1237891149.4320.73.camel@johannes.local>
	 <87ab7bqa21.fsf@litku.valot.fi> <1237978630.4320.150.camel@johannes.local>
	 <87ab791isj.fsf@litku.valot.fi> (sfid-20090325_205334_758597_39212B61)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ryaoy87Z8igrU3/O0Dmr"
Date: Wed, 25 Mar 2009 21:06:19 +0100
Message-Id: <1238011579.4320.169.camel@johannes.local> (sfid-20090325_210659_076895_F94E2630)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ryaoy87Z8igrU3/O0Dmr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-25 at 21:53 +0200, Kalle Valo wrote:

> > By the way, do you have any numbers on how the timeout affects actual
> > network latency?
>=20
> Nope. I would guess that there are academic studies about this and if
> someone finds anything, please share them here. I would interested as
> well.

Too bad :) I guess we could go measure some...

> > It's also related to the beacon interval and the listen interval, of
> > course.
>=20
> Yes. Also we need to consider are we willing to skip DTIM beacons and
> loose multicast/broadcast frames. We could save even more power with
> that.

Right -- iwlwifi seems to do that sometimes.

> > I'm just worried that we'll require a whole bunch of different
> > interfaces. Yes, in theory there isn't much to control, but iwlwifi
> > firmware for example can, as far as I interpret the code, dynamically
> > vary the listen interval.
>=20
> You mean the wakeup interval? For me, listen interval means the
> maximum time AP is willing to buffer frames for a STA.

No, I mean the listen interval in the assoc request frame.

> I assume you mean sleep_interval here:
>=20
> #define IWL_POWER_VEC_SIZE 5
>=20
> struct iwl_powertable_cmd {
> 	__le16 flags;
> 	u8 keep_alive_seconds;		/* 3945 reserved */
> 	u8 debug_flags;			/* 3945 reserved */
> 	__le32 rx_data_timeout;
> 	__le32 tx_data_timeout;
> 	__le32 sleep_interval[IWL_POWER_VEC_SIZE];
> 	__le32 keep_alive_beacons;
> } __attribute__ ((packed));
>=20
> So there's an array sleep/wakeup interval, which firmware most
> probably rotates periodically.=20

I don't actually know what the sleep interval here is...

> I think stlc45xx/p54 even had something
> similar. But honestly, I don't know if this kind of trickery is
> useful. Why not directly go to the longest wakeup interval
> immediately?

But listen interval * beacon interval determines latency.

> My view is that the decision to change wakeup interval should be done
> in host, preferably userspace. Userspace has the best knowledge, it
> should make the decision as well.

What's the wakeup interval?

> > Some of the decisions might also depend on the hardware, I could
> > imagine, the point where turning off power saving is required might be
> > different depending on hardware due to wakeup time maybe?
>=20
> Yes, there might be some differences.

How would we capture these?

johannes

--=-ryaoy87Z8igrU3/O0Dmr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyo65AAoJEKVg1VMiehFYkX8P/2rlkXXwertFAXJLmqotRG1n
jP9LTlbY+Wd5k/iDcxImD+FkwNif5kg3rq12TDMQoV/5bRaXdGurz8uyJ0DjGJxp
I0ouREIc5gVH21cnDEXe/ayQjsVj3TrH3gafRNmAu74x/+5j+eE/Id+x6VTBZGiT
v7GNHOqGi9hjGgFjmGUm8sH36Et7NGuE7JhqHC9tdaIR7eQDYgpXba45nv4YCv1y
Qcra062yZQl9N8eKMpHaepG+H++26mcyrPP+NwyBSEJkJef+LG7RCykGPnspzaZ2
Mxu9oyJlrqbB2sCrTK7BdIklr2QR9+oZ6Wlh57foaKkNUIDnFFXMRCg5GjAhkIe6
gtdwwUWYt+aweQ8XalrRxKCAWWNs3oDj9dieY3lF0TGrAfVCHuBvb7OvCiAYAMdF
HIVa+y5ZVtCeTbqM3QDHSKOZbU5+GlwM+MMCJZ7XGEwycCbf56/6rx3Vyih8Q2Sa
Ac77U07N6LiFDPeEqBtyXfanMOVZ1daYGn1Vqkm4UBA9exUeFubHoF9tt1RrFsYi
RSTQC+AXs8UuKBpvQiStf2kil+zsIn6x6dEXCT0jvAmRHQs10r7CUi++g/SwoXce
3OKnWgRekCDhr5z34rVf6WJLv3cElBKedRQrKoH9timPj1jwP2XR90DLhLorMcso
n5M6wcFuHhH5jSTlje/w
=z7HZ
-----END PGP SIGNATURE-----

--=-ryaoy87Z8igrU3/O0Dmr--

