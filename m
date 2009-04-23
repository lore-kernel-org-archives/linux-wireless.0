Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48423 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbZDWR6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 13:58:15 -0400
Subject: Re: wl12xx: third submission
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	luciano.coelho@nokia.com, Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <874owf8dls.fsf@litku.valot.fi> (sfid-20090423_194953_137804_C7C87EC2)
References: <87ab67b9y2.fsf@litku.valot.fi>
	 <1240507929.30082.258.camel@johannes.local> <874owf8dls.fsf@litku.valot.fi>
	 (sfid-20090423_194953_137804_C7C87EC2)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QPQqg83F/yL7nC3qAowJ"
Date: Thu, 23 Apr 2009 19:57:33 +0200
Message-Id: <1240509453.30082.265.camel@johannes.local> (sfid-20090423_195819_077057_A4310B90)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QPQqg83F/yL7nC3qAowJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-23 at 20:49 +0300, Kalle Valo wrote:

> No problem, I can update wl12xx as soon as you finalise the interface.
> Just let me know.

Well, I just posted it earlier as [PATCH] :)

> > 	wl12xx_cmd_template_set(wl, CMD_PROBE_RESP, beacon->data,
> >
> > hmm. mac80211 doesn't deal with probe response offload right now.
>=20
> Yeah.

You're not setting the IBSS bit anyway though. ;) Might need to come up
with a patch to disable mac80211 probe responses, that would be much
more efficient...

> >         status->flag |=3D RX_FLAG_TSFT;
> >
> > You should set that only when it's actually completely filled I think.
> > p54 has a trick to keep track of the upper 32 bits in software,=20
>=20
> This would help.
>=20
> > that assumes getting a frame every 2**32 us though.
>=20
> But we can check that in driver and compensate, right?

Well, you can check against jiffies and then resync with the get_tsf
command, I guess.

> > how about IPv4 alignment? Could you read the packet header first,
> > memmove that and then read the rest, i.e. do two wl12xx_spi_mem_read
> > calls? Might or might not be more efficient...
>=20
> SPI access add latency, it would be faster to read as much as possible
> in one transaction.

Question is how it measures against the CPU doing memmove() on the
entire frame when necessary.

> Is there anything which in your opinion prevents inclusion to
> wireless-testing?

Give that you and Bob are working on it, I don't think so. Except the
API issue, which means it won't compile when John merges my patch.

johannes

--=-QPQqg83F/yL7nC3qAowJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ8KwFAAoJEKVg1VMiehFY2gkP/3E5y1MjE9TJ55eXqZa3PFZu
iHhEi8DM64jeUabibQEPPh9ETXHdzfPLRpEblk6Vo+lT0VFzqnKsc95x1rHWSrik
Mhn7HWjoxBrhxPLF+EAACzKWLHK83cWqJKIxfyyifLtqzdpIc0wI7ceRusjN2kk9
k4GqwtJBFeSvTfjwWhcjfCUD39CcxsMQhLgqkZkaEspPGNrLSt1hUdTgyIutf8SU
drNxxn6mxgMYkd9yTYv3wHJ9XFfA6IsjgwFKFLDDS5mALCuCYdtngpZEHtX3XXvk
m09Qu4e+0iURcM08pZ5wNIJI7c82OVfbcjjnTeGkjkuwY2L3iPxX4rnSt6bvziAm
SBFVuYaN40qrkGG+MIz1qioeKHx/SWBEFE7icE6XvwiCMXH0VAPUC5ybb3YVPmAn
mr65jn7JkvZS8ZMtp/zVgUZNvdWXDdAnNhQ0DqzTPUhN/8q33qYuZhOsT4CUBIRc
Q/HLC8CfqBof/FKauA034fDg5AgVk6q1LyxSZEoxek+ODnHEW3EubujWETYOWGvk
WpztvSHa6dLXpSn+DYGqmkFnFZLiOVNHAEtqbg+6WU6oSV88hVzLSfo4/z+XFh9N
hpWrWuFxeQb3vRKl1uIKA4zMP36selwBwb93rj0RPLJhMVW3+WAmPG55nSXAAD7D
5vS5INPEZ5Jq4BTwKpIR
=CPk9
-----END PGP SIGNATURE-----

--=-QPQqg83F/yL7nC3qAowJ--

