Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51449 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbYBYUte (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 15:49:34 -0500
Subject: Re: [PATCH 07/13 v2] o11s: changes to ieee80211_sta
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1203972580.6929.74.camel@localhost> (sfid-20080225_204804_927071_F77C43A6)
References: <47be773d.22b38c0a.2fbf.ffffb131@mx.google.com>
	 (sfid-20080222_074745_247391_EDD9C862)  <1203697317.7082.68.camel@johannes.berg>
	 <1203972580.6929.74.camel@localhost> (sfid-20080225_204804_927071_F77C43A6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ok9C95OLLFqmIAzpHeGW"
Date: Mon, 25 Feb 2008 21:49:23 +0100
Message-Id: <1203972564.13162.165.camel@johannes.berg> (sfid-20080225_204938_027283_FB9983D0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ok9C95OLLFqmIAzpHeGW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-02-25 at 12:49 -0800, Luis Carlos Cobo wrote:
> On Fri, 2008-02-22 at 17:21 +0100, Johannes Berg wrote:
> > > +	atomic_inc(&bss->users);
> > > +	atomic_inc(&bss->users);
> >=20
> > ?
> > That was just allocated, shouldn't it just be atomic_set() then? And wh=
y
> > two anyway?
>=20
> I was following the behavior in ieee80211_rx_bss_add(), where the same
> thing is done. It is needed to to avoid the bss being freed on the next
> ieee80211_rx_bss_put(), works as a reference count. Agree that
> atomic_set() would be better.

Ok, I didn't realise that it was the same in rx_bss_add(), I'm not too
familiar with the code.

> > > +			memset(&iwe, 0, sizeof(iwe));
> > > +			iwe.cmd =3D IWEVCUSTOM;
> > > +			sprintf(buf, "Mesh network (version %d)\n"
> > > +			"\t\t\tPath Selection Protocol ID: 0x%02X%02X%02X%02X\n"
> > > +			"\t\t\tPath Selection Metric ID: 0x%02X%02X%02X%02X\n"
> > > +			"\t\t\tCongestion Control Mode ID: 0x%02X%02X%02X%02X\n"
> > > +			"\t\t\tChannel Precedence: 0x%02X%02X%02X%02X",
> >=20
> > Maybe we should add separate items for this to make it easier to parse
> > them?
>=20
> Ok, will include that too.

Can you do things as follow-up patches that apply after the sta_info
stuff I sent out today? I'd prefer to not respin the 11s and the
sta_info patches.

johannes

--=-Ok9C95OLLFqmIAzpHeGW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8Mp06Vg1VMiehFYAQLEdg/+JTbmU7PD7JV8JtkB0N+qxv6rIG2UTsgO
joP+peIzaQhNKlzvybLRGvWRWRCU+AdaoGe0VHr+ZBtiY4/2scMZrD1i8BWYCaYF
MLTqDl4RcKA+Jdnsth2rhsVcL15y5ZidK7PYasjE7YeFNCrjObpnXzde6oukF5po
xskF6ODKhSXZ782wLs2jmi9ogxCIlQqjvXSfCIW5ymxf92q+qob3XNuT9GR+qVlx
a9pOnZ5I+VZFDKYI9Fmv3PSUKHVFjrKeywBvrCFS/Bt/1kEJLN2nBrzbIijaxclB
+af2tojfbkd4wb3S//Unp5uo/grybmoZ70+wAURnDuHGikcqykljvKV2IeEGPUQa
HgGhfAMo0i0oCxENMKXVRkGJt9Z0I1zVa0JusBnF6if8myffsol/2xtnytMOsh9w
dVNHw0BTTbAzyy4djrrRXnJK/EBh+pEeEtAc2GAiV6uoadw2ba7q4/QoMn9R4Ivc
nO4tb7wjg4f3TRvmNnOafcc1uwFUshKB74UW5JH9lcHxOiE5VbQb6UJIujPVFZuj
kvpOLYFWq6E5Qgdzf6EOkX+zuBXhuWAsRGWFCPT4ZPaA4VeGHGd71C/FUj/8BPP6
ODZ6BS/yo+zMtSOpOsXXUgK5RArLk/80cjFFQ+nACamiYuw+l3Go1/SODsm50Q+N
cQe7iItKTHQ=
=vtlr
-----END PGP SIGNATURE-----

--=-Ok9C95OLLFqmIAzpHeGW--

