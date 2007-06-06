Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50585 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762074AbXFHHDN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 03:03:13 -0400
Subject: Re: [PATCH 2/3] mac80211: IEEE802.11e/WMM TS management and DLS  support
From: Johannes Berg <johannes@sipsolutions.net>
To: yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20070606082223.GA28658@mail.intel.com>
References: <20070606082223.GA28658@mail.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IYabnXpAqyx5UNzbj7bP"
Date: Wed, 06 Jun 2007 21:18:52 +0200
Message-Id: <1181157532.3398.20.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IYabnXpAqyx5UNzbj7bP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Some nitpicking below :)

> +		if (dls_link_status(local, skb->data) =3D=3D DLS_STATUS_OK){

missing space there, but maybe the line is too long with it?

> +					case WIFI_OUI_STYPE_WMM_TSPEC:
> +						if (elen !=3D 61) {
> +							printk(KERN_ERR "Wrong "
> +							       "TSPEC size.\n");
> +							break;

That printk should be rate limited.

> +					default:
> +						//printk(KERN_ERR "Unsupported "
> +						//       "WiFi OUI %d\n", pos[4]);
> +						break;

And maybe that should be there for the debug case (rate limited as
well)?

> +		case WLAN_EID_TSPEC:
> +			if (elen !=3D 55) {
> +				printk(KERN_ERR "Wrong TSPEC size.\n");
> +				break;

Ditto.

> +	if (ifsta->ts_data[tsid][index].status =3D=3D TS_STATUS_UNUSED) {
> +		printk(KERN_DEBUG "%s: Tring to delete an ACM disabled TS "

typo "Tring".
Can this be invoked by somebody requesting you to do it? If so it should
be rate limited as well. I haven't quite understood the code flow here
yet.

> +	if (ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems)
> +	    =3D=3D ParseFailed) {
> +		printk(KERN_DEBUG "%s: failed to parse TSPEC\n", dev->name);
> +		return;

Wants rate limiting too, afaict.

> +	printk(KERN_DEBUG "Receive DLS request from "
> +	       "%02X:%02X:%02X:%02X:%02X:%02X\n",
> +	       src[0], src[1], src[2], src[3], src[4], src[5]);

Again?

> +	if (ieee802_11_parse_elems(mgmt->u.action.u.dls_req.variable,
> +				   len - baselen, &elems) =3D=3D ParseFailed) {
> +		printk(KERN_ERR "DLS Parse support rates failed.\n");
> +		return;

and again?

> +	printk(KERN_DEBUG "Receive DLS response from "
> +	       "%02X:%02X:%02X:%02X:%02X:%02X\n",
> +	       src[0], src[1], src[2], src[3], src[4], src[5]);
> +
> +	if (mgmt->u.action.u.dls_resp.status_code) {
> +		printk(KERN_ERR "DLS setup refused by peer. Reason %d\n",
> +		       mgmt->u.action.u.dls_resp.status_code);
> +		return;
> +	}

I suppose these are ok since we're not going to request DLS a lot,
right?

> +	printk(KERN_DEBUG "DLS Teardown received from "
> +	       "%02X:%02X:%02X:%02X:%02X:%02X. Reason %d\n",
> +	       src[0], src[1], src[2], src[3], src[4], src[5],
> +	       mgmt->u.action.u.dls_teardown.reason_code);
> +
> +	dls =3D dls_info_get(local, src);
> +	if (dls)
> +		sta_info_free(dls, 0);

Do we really want to free the sta info here? Shouldn't we have a sta
info item for the DLS peer anyway, and then we can't free it here but
rather reset the DLS status?
=20
> +		if (len < 24 + 4) {
> +			printk(KERN_DEBUG "%s: too short (%zd) QoS category "
> +			       "frame received from " MAC_FMT " - ignored\n",
> +			       dev->name, len, MAC_ARG(mgmt->sa));

rate limit.

> +			printk(KERN_ERR "%s: unsupported QoS action code %d\n",
> +			       dev->name,
> +			       mgmt->u.action.u.wme_action.action_code);

rate limit.

> +			printk(KERN_DEBUG "%s: too short (%zd) DLS category "
> +			       "frame received from " MAC_FMT " - ignored\n",
> +			       dev->name, len, MAC_ARG(mgmt->sa));

ditto.

> +			printk(KERN_ERR "%s: unsupported DLS action code %d\n",
> +			       dev->name, mgmt->u.action.u.dls_req.action_code);

ditto.
=20
> +struct sta_info *dls_info_get(struct ieee80211_local *local, u8 *addr)

Ok, I don't understand the DLS info stuff. Basically it's a sta info,
but why not just do sta_info_get() on the regular one and then set the
dls peer bit?

> +			if (net_ratelimit())
> +				printk(KERN_DEBUG "QoS packet throttling\n");

Hey! :)

johannes

--=-IYabnXpAqyx5UNzbj7bP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGZwib/ETPhpq3jKURAq18AJ9dPt5Lh8g1dFCT9TCt1Mu0wSoX0ACeLVuW
qb8bUSPYwLJW5KUMPOP4L2E=
=k+8W
-----END PGP SIGNATURE-----

--=-IYabnXpAqyx5UNzbj7bP--

