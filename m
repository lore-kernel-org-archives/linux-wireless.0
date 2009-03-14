Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57816 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZCNRSG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 13:18:06 -0400
Subject: Re: [RFC PATCH v2 1/4] mac80211: decrease execution of the
	associated timer
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <20090314171431.11126.51242.stgit@tikku>
References: <20090314171234.11126.21125.stgit@tikku>
	 <20090314171431.11126.51242.stgit@tikku>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-c7qfXS6nXrZnAsh4l0uv"
Date: Sat, 14 Mar 2009 18:18:04 +0100
Message-Id: <1237051084.5235.97.camel@johannes.local> (sfid-20090314_181810_563016_370179DE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-c7qfXS6nXrZnAsh4l0uv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-14 at 19:14 +0200, Kalle Valo wrote:

> +void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
> +			     struct ieee80211_hdr *hdr)
> +{
> +	/* timer triggers only when there is no unicast traffic */
> +	if (!is_multicast_ether_addr(hdr->addr1))
> +		mod_timer(&sdata->u.mgd.timer,
> +			  jiffies + IEEE80211_MONITORING_INTERVAL);
> +}

Do we really need the multicast check? The frame will be coming from the
AP in managed mode in both cases, so why regard the data path as idle
when we're receiving multicast traffic?

johannes

--=-c7qfXS6nXrZnAsh4l0uv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJu+bJAAoJEKVg1VMiehFYljgP/2nifddlUEMs9DOzt686T8Pe
t0cjGS7YfzC6yyHjoADCN6C2noFBp3FRYljJJplER8TNJ2dxi4mGZSlqal0ZHH8a
wX3MOgZv+4acvtuRWPbsTWn8eAYyc5yotPY5osNF7SkREyBOnmRCJG17zOSeyFbP
SlVL2A7yVi+YkJ1xVABAxct+FGsX5J00EPvjJOBgIVSrviG95G9A35+nfS/jL3/q
e+dHY9hmIxBx3N3wtDDnzd3UcT3OP7GeOEs7PhzlbN1M/u7U3GQ4gCO+9ntrV3Ry
7mCWdT7/mfRhLxdD9CMMxwHtRwdyZ2/DbDxUHSEixmCcOWJsUnD7G+cNzcMrxWgi
GrSLcuWmrrnOaMj+6BQlsm05koZRENXdXtzB44IEORt4ml4KNjGc5ujJxrT1L6dC
ak9/DIXsqr/O6Jj2pf8rvnq0AJJVzJD3Sysx8Nru6FlkUHa9VeKplAaLEMi7IRQ8
19sVja5sLCadEeAELbJItY6AFH2afoucyeoJ8Cp1aPplCVLs7P7siRA3VNLLE9BQ
stit6hrXbNKjUdpuyyBTxuPwYg0aVKgR1OrqtoOnR8LgS22e7EKp+KUXi26efksf
7nzcquLjDcOdCBVMNtoOUi4Y4drxePeqqaE3zDadVTbnCb2F9LRJuCUh9QVugvo/
OuIeuxWKb2EdlDRTk2+8
=P1iR
-----END PGP SIGNATURE-----

--=-c7qfXS6nXrZnAsh4l0uv--

