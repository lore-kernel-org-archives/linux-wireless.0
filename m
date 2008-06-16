Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42645 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbYFPIm2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 04:42:28 -0400
Subject: Re: [PATCH 2/2] mac80211: 11h - Handling measurement request
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>
In-Reply-To: <1213543410-30890-2-git-send-email-tomas.winkler@intel.com>
References: <1213543410-30890-1-git-send-email-tomas.winkler@intel.com>
	 <1213543410-30890-2-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uERQLYlnFqFtzeIihhqu"
Date: Mon, 16 Jun 2008 10:41:13 +0200
Message-Id: <1213605673.3803.22.camel@johannes.berg> (sfid-20080616_104231_947309_202F1F95)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uERQLYlnFqFtzeIihhqu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> This patch handles the 11h measurement request information element.
> This is minimal requested implementation - refuse measurement.

I haven't really read 11h or the -2007 wrt. the added material, but this
seems a bit odd to me:

> +static void ieee80211_send_measurement_req(struct net_device *dev,
> +				struct ieee80211_msrment_ie *request_ie,
> +				const u8 *da, const u8 *bssid,
> +				u8 dialog_token)

> +	msr_report->u.action.u.measurement.element_id =3D WLAN_EID_MEASURE_REPO=
RT;

It's sending a report after all, not a request. Maybe it should just be
named "send_measurement_action"?

> +	msr_report->u.action.u.measurement.msr_elem.token =3D request_ie->token=
;
> +	msr_report->u.action.u.measurement.msr_elem.mode |=3D MSR_REPORT_REFUSE=
D;

Also, it seems to me that should be part of the arguments or you won't
be able to use this function for anything else but sending a 'refused'
report?


> +/* measurement report mode field - refuse to generate a report */
> +#define MSR_REPORT_REFUSED       BIT(2)

That seems completely misplaced in sta_info.h to me?

johannes

--=-uERQLYlnFqFtzeIihhqu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIViclAAoJEKVg1VMiehFYrl4P/1kvssUBfRYHqK6bQcDymVxU
ijTciMHvY7pk43d/2rUYiUsr+mX5qRM72EjMdW2wTYDzRi+Xy5vW/8yNnBO8f9Sb
d+wkalo03yMhON9vTGeidSwwXtMN0Rnr/x7mZd2jnmX1hp9WhZ5AlBAR3RpG7Arm
Wn7UFiJAOMW2MKyb3tNzxsqJujXXF/PR2XrUcrJxLMjlvyZBDNXhcEn+sUkJNmIj
BY4HA3a11VSNfv6ZdtNUtaiatDR2qAlG13UBjzcq77ON6J2MoOp6fuTA7ed8xNBP
WRgD6fthsa4V/CYYc42RfoN6UXOjM8SVlSNPGDj7trOx9bVv9NaqH5q8c+s4G70s
HploBdsE9McxPvd7P0wFaKjzgWr0FkrmC/B5FrlGExyKMKTmQJm/5nTdjAjMZ/3h
TFKSaRwhVObvJD74Y58O/QrWqW98VfG2CVMo3ZiX+wMyCK7Lr0OS+d7Tpzui46Vw
Iqioxkry1MKFckZhlV4aQ+pZ8/NlXZcB5OCj/YMc5MBGzmTpSp6OLhDdYUD27pi4
WkieVxlN4przNDSWjSNlEnPsKorc/7pZJevBuRjp2/WFUqyI/YXzHa1w/6vt4/C2
yc+1gemCvwvcYGkkqUCodkDbePDCDwHEuxr5RgWlaaZD5JaPNg+brNnTZFbqfFIn
bIKu2wPjtS+B6kwav7Nv
=uEPJ
-----END PGP SIGNATURE-----

--=-uERQLYlnFqFtzeIihhqu--

