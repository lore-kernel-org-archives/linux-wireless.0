Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40586 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbZDPJNW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 05:13:22 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <87ocuxf7kv.fsf@litku.valot.fi> (sfid-20090416_081529_723461_015362DA)
References: <1239837672.11795.46.camel@violet>
	 <1239841291.25334.18.camel@johannes.local>  <87ocuxf7kv.fsf@litku.valot.fi>
	 (sfid-20090416_081529_723461_015362DA)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-m/qBc7so6iF9O1rcHwaY"
Date: Thu, 16 Apr 2009 11:12:46 +0200
Message-Id: <1239873166.9737.4.camel@johannes.local> (sfid-20090416_111325_836393_8280C8A7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-m/qBc7so6iF9O1rcHwaY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-16 at 09:14 +0300, Kalle Valo wrote:

> Basically the problem is that if you scan in an area where there are no
> or very few APs and scan takes more than two seconds (like abg band
> scans usually take), sta->last_rx won't get updated because mac80211 is
> not receiving any frames. This is why the beacon loss check will trigger
> in ieee80211_associated().
>=20
> The problem won't happen if there are lot of APs in the neighbourhood
> distributed throughout the channels because then sta->last_rx is updated
> often enough and the beacon loss check won't trigger.

That doesn't make sense, why would our AP sta->last_rx be updated for
other APs? I think you mean sdata->u.mgd.last_beacon, which is, probably
wrongly, updated for all beacons.

> I have been thinking two ways to fix this, either disabling the timer
> for the duration of the scan or add a check for scan scan in
> ieee80211_associated(). I started implementing the former but haven't
> finished it yet. It would be great if someone else can fix it.

But that doesn't make sense to me now. ieee80211_associated() is only
run from the station work (ieee80211_sta_work) which doesn't do anything
when we're scanning (and gets restarted on scan end). So even if last_rx
or last_beacon isn't updated we should only run the evaluation of that
after the scan finishes.

I'll try to reproduce this.

johannes

--=-m/qBc7so6iF9O1rcHwaY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ5vaLAAoJEKVg1VMiehFYgXMP/2fud9JvJLwUjRtLgZFTZ9vA
CSpkct+qlpjbz6fvLCcSYORHwSTXkYozmc8cRHQtwltntRnL9VOK6Sepw1q3foGb
2Kxf6yDJQptT/WARBoWUPsJsbqasVW501kNKn4zNI2ozL4uExmqpbsIETBut01oX
UQRMnG8+FHEIsBr+MUuNa+u0175Z3bA9DEozjrbJPrR5MZDpnopIGn5fAgcSQXE8
8urfwfMgKgNlLrerMtg9KrpKGotLV005yEO6OlagMDe7BMApsZl/tLxl+ZDwlReZ
lJTA0QV6+1FP9pphdiUPsEOP8mJoIJ4MOgdaCVWb+U1VsCwNhDlVakeon4mDS1Mk
RYUdqdIYqyglq9oSLB2aFwVXGAvQNdsPs2oWS3pLmQiBf9UQDVOi3XalRUow5bRe
9CjjsJnj7+vnuZNnjeJJ2jLw16E7lGa6oTNK7KKsMGCWZJZgQ8t/UmydCSo8A635
ERlLrf+PGpNNL6fpTFTD5tQduIFAVkm+IaPR6riPfb3OVz+pbzxfiLTp3ZeaCwHY
wgCqjUmnLNe6VCmb4UbjLlDUYFrRTshweQRx9lp+m1IB2JewOCXSDUjFPu5+YMPw
lUgNbLA3SE5HwtCQylFIiiEbqvjCtDxYOM+bht+wEMBcU0RWVV8L9BQZaeVqiw7C
OtkpcbgdmtG0vl3HCYnB
=mTzx
-----END PGP SIGNATURE-----

--=-m/qBc7so6iF9O1rcHwaY--

