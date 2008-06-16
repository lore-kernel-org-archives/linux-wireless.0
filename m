Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43277 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbYFPJLm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 05:11:42 -0400
Subject: Re: [PATCH 2/2] mac80211: 11h - Handling measurement request
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>
In-Reply-To: <1ba2fa240806160208l2926eeefh7f9eaf4f54d6c25c@mail.gmail.com> (sfid-20080616_110838_161665_FD438195)
References: <1213543410-30890-1-git-send-email-tomas.winkler@intel.com>
	 <1213543410-30890-2-git-send-email-tomas.winkler@intel.com>
	 <1213605673.3803.22.camel@johannes.berg>
	 <1ba2fa240806160208l2926eeefh7f9eaf4f54d6c25c@mail.gmail.com>
	 (sfid-20080616_110838_161665_FD438195)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4X64mo+yxt9zCLG8Lf2Q"
Date: Mon, 16 Jun 2008 11:11:03 +0200
Message-Id: <1213607463.3803.27.camel@johannes.berg> (sfid-20080616_111145_839419_B2928D33)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4X64mo+yxt9zCLG8Lf2Q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >> +     msr_report->u.action.u.measurement.msr_elem.token =3D request_ie=
->token;
> >> +     msr_report->u.action.u.measurement.msr_elem.mode |=3D MSR_REPORT=
_REFUSED;
> >
> > Also, it seems to me that should be part of the arguments or you won't
> > be able to use this function for anything else but sending a 'refused'
> > report?
>=20
> Don't mind to put it into arguments, just the argument list have to be al=
ter
> anyway if real measurement is performed and results need to be sent out.

Yeah, true. Or you can just call the function
_refuse_measurement_request() instead.

> >> +/* measurement report mode field - refuse to generate a report */
> >> +#define MSR_REPORT_REFUSED       BIT(2)
> >
> > That seems completely misplaced in sta_info.h to me?
>=20
> Yep will move it to
> include/linux/ieee80211.h ?

Sounds appropriate, though it should probably be renamed then to have a
proper IEEE80211 prefix. Are there other items in that field you might
want to collect into an enum? Doesn't matter much to me though, one can
always look it up in the spec.

johannes

--=-4X64mo+yxt9zCLG8Lf2Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIVi4jAAoJEKVg1VMiehFYlKAQAI/vQLB/rS2heOjbp/lB4gT7
Pv/KI3XGjIspXLnnbJD8PeyITzs6u+WrS3NR3bi8Z9Og9iSFnWtETteoZNU5NJhD
Z3BgzJR7ncuRljZ03oU5lergM+TP19sKcqsO8oast3ZzoRJ/UmlddvQNDdTOsWbI
usLg2+CI7Va0HhfNVy42N+qjyvzqmWvQuFqirsncXLdLTm/6tDPOWZMMaklN4sWZ
IjBSudrlQ+dv4JLsvt1YK2rHhG4CBpH7dYa1Rlt2n5OxPWkT73k2wm9BVnb9Lskc
qRbpEpd67NhiVilVdCJe6/IJK1GaCtQAIMBTf2F1/DsPhyfOZQVXhsbuWnMP0/wJ
kXnyV1xPVXD5998zR0YtF9+GMiyG9RinXdrNGvV/Fi/mxQoBD0sZSbSNyD+WCsvx
H9NE58n1vdc90xhjnPnnXRsB9Ll+S8s9cQvmLIvvIn7+R/EkkGuZgshB2WcwcWAD
EaH4UVhdNt8Ma2Y3EDu+Nz9qZpBZA2opNDLBwCz7K9zdQK+hUpXp1xWBDxhUwr6A
eI9BY824VMdGeWqqlOFFkcujodFosFzgW1x0HXKDuOy06xk0NMCg6Yeh6EnYEs0p
9xUobWYjwDF6dSWW0oaUcpjPWujiVghCgVQ8csX92meh3eH8UDwiM15qyRXhY7Vd
A1gO5waHGQOYhxMdqbbr
=yxuD
-----END PGP SIGNATURE-----

--=-4X64mo+yxt9zCLG8Lf2Q--

