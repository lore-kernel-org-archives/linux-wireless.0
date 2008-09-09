Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40980 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbYIIGaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 02:30:21 -0400
Subject: Re: [PATCH 5/3] mac80211: fix typo in action frame handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240809081358h45b63b89xa02e17bd017b2dbc@mail.gmail.com> (sfid-20080908_225840_582731_C75C34EB)
References: <20080908090507.641740000@sipsolutions.net>
	 <1220884308.31304.62.camel@johannes.berg>
	 <1ba2fa240809081358h45b63b89xa02e17bd017b2dbc@mail.gmail.com>
	 (sfid-20080908_225840_582731_C75C34EB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ng4z67jTaKThkie4+2vA"
Date: Tue, 09 Sep 2008 08:30:16 +0200
Message-Id: <1220941816.31304.96.camel@johannes.berg> (sfid-20080909_083024_992385_99C58278)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ng4z67jTaKThkie4+2vA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-08 at 23:58 +0300, Tomas Winkler wrote:

> It doesn't really matter on which action code you doing the switch.

Oh, I know, but I think it's confusing.

> The full code looks like that
>=20
> switch (mgmt->u.action.u.chan_switch.action_code) {
> 		case WLAN_ACTION_SPCT_MSR_REQ:
> 			if (len < (IEEE80211_MIN_ACTION_SIZE +
> 				   sizeof(mgmt->u.action.u.msrment_req)))
> 				break;
> 			ieee80211_sta_process_measurement_req(dev, mgmt);
> 			break;
> 		case WLAN_ACTION_SPCT_CHL_SWITCH:
> 			if (len < (IEEE80211_MIN_ACTION_SIZE +
> 				   sizeof(mgmt->u.action.u.chan_switch)))
> 				break;
> 			ieee80211_sta_process_channel_switch(dev, ifsta,
> 				&mgmt->u.action.u.chan_switch.sw_elem);
> 			break;
> 		case WLAN_ACTION_SPCT_TPC_REQ:
> 			ieee80211_sta_process_tpc_req(dev, mgmt, rx_status);
> 			break;
> 		default:
> 			break;

Does channel switch and measurement have the same category? Can't we
better reflect that in the structure? I thought the union in the struct
had one sub-structure per category.

johannes

--=-Ng4z67jTaKThkie4+2vA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxhf0AAoJEKVg1VMiehFYEUEQAKom5GvvwLk6JUOWs91hL0c2
K970gKifA4UEn6rWqjwWrjsn6GL2zA5sdrwoMstLLd7js6ke1LfLNT95iRVk2OAG
38tPJKZyTgL5KY1KiO2tp+nHOw/RZGrbJW4RCDV9QXM4V+Djhg11Rb/Dvo0gBf/x
nIKW13yiYVqz2cyQBL987mMEdIlD+wdRJ3YVE7uUs31890JS0AiBtGSY6uN5cyo3
zBLplJ5z7gw/mbdY/jmDc4X/YEQPAJabU86YjkH9QxOlb3v8pDwYaH9I91uhE3uj
eQhx76OoCttvjisBqvngLmF2YDzNEt3tIx7/rYhI9s+Qn+XMMlIFOTnUqKyxAIGO
sxLsVMpNZMr85QCUhRuh7WP8cj45M2gIzaSFGuIGtvMLddtE2VDFXvpJeuw25tdV
pjhTDW2cGQrlGhkswhUe46RcaVM8EEZw6oyJ5l4ru4+O+N8FwUN9t/c/etPwcg3+
qCFYjfgJ0qDT5NlCaWso9TzbOg0vvmm/6umKjfaXUrUBWD4CO9kpvYcba6as2W0W
php48PLEO6XL8YaSpiKo/4BiCJruQ5QH15WmR5JoQT53uNWbzvBApsoY6ayjyR2B
P+zIHif6/gHa4COKxGFYf6BI4LAr/3L8vCJOAEqwtvkBoHFCkAFXDJXRgYHQwNsd
FpYvaexQHZKkr9awbd2N
=+U/+
-----END PGP SIGNATURE-----

--=-Ng4z67jTaKThkie4+2vA--

