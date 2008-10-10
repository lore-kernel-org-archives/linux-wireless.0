Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49468 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbYJJJPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 05:15:04 -0400
Subject: iwlwifi TX reply bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BZFpAl1HfqyCYxaj7kVO"
Date: Fri, 10 Oct 2008 11:11:37 +0200
Message-Id: <1223629897.3930.69.camel@johannes.berg> (sfid-20081010_111518_226940_A17F2916)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BZFpAl1HfqyCYxaj7kVO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

	sta_id =3D iwl_get_ra_sta_id(priv, hdr);
        if (txq->sched_retry && unlikely(sta_id =3D=3D IWL_INVALID_STATION)=
) {
                IWL_ERROR("Station not known\n");
                return;
        }

        if (txq->sched_retry) {
[...]
        } else {
[...]
                if (index !=3D -1) {
                    int freed =3D iwl_tx_queue_reclaim(priv, txq_id, index)=
;
                    if (tid !=3D MAX_TID_COUNT)
                        priv->stations[sta_id].tid[tid].tfds_in_queue -=3D =
freed;
[...]


priv->stations has 32 entries, IWL_INVALID_STATION is 255.

Oops.

johannes

--=-BZFpAl1HfqyCYxaj7kVO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7xxFAAoJEKVg1VMiehFYujEP/iyUnbaNB0du9E4mwCsk+ouN
/YocH0LOEbtYD9wjsIHnuuCOI0aHSdsgVjvyg+xz22oW0p0tZg/+UoEh48Y2xLug
it+rOT+UJuHJPBm72NRl4d81YLenCtd8q00/BL/OpsToFi1usDzjrcqslHsS+Xnm
TSCrbSFfCzGtQyoXhQkAh8Rx+JYRYwkidwStln2p9kDrJpg+XWAP5LX2YUDIwTtj
lS488krIFYvOQKh1l/wpfQZ549PX/0uU+5eRhAsRTFPrI/UI6VU7fsDbfb7MzUAl
EqdTMDMrBph14acBogOFgTRDn2CUdxD/yID+5jCrHpAKNiamGG2S46bCa2HSfS4g
+rc6W4FK93Ot9ZCGxwSTUwJ3g1p4knUpvmlffrU9MZ0D2B6kree56KDGD652N19d
rfbDiUVVdhPAU4a15D+mBl8r8Cm6r+6gqzeCWOdX6/okDDRC+wWEOH7q8/1S6AhM
CeHEeXF/zx4hDrXdNHDd6no5QTt/tIlxiTfmZlQ8AAi18VjqMG+GgtMBGSAxzo68
jNpW5eRq2A9gyvB3YKaHO0sPOSxrc3JZBH2igoEAgmfsuGuV+hdaGtlp9VSkcMe5
93syuCr1bRN6kuAxeu1wSCNMqEFveqybuBeCDoqce5NzWi/pJ/mYmrgFx2CKPlGa
VgzRVwqdRL9wnIs9HZ4l
=ZjCG
-----END PGP SIGNATURE-----

--=-BZFpAl1HfqyCYxaj7kVO--

