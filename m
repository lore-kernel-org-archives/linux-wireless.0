Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34437 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbXLEKSZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 05:18:25 -0500
Subject: Re: [PATCH] mac80211: don't use interface indizes
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Zhu Yi <yi.zhu@intel.com>, Daniel Drake <dsd@gentoo.org>,
	Yanbo Li <dreamfly281@gmail.com>
In-Reply-To: <200712050057.19819.flamingice@sourmilk.net>
References: <1196782831.10274.12.camel@johannes.berg>
	 <200712050057.19819.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HZdzyhv9gfJWosUbRLPe"
Date: Wed, 05 Dec 2007 11:18:20 +0100
Message-Id: <1196849900.4121.4.camel@johannes.berg> (sfid-20071205_101838_959371_6E84D3F8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HZdzyhv9gfJWosUbRLPe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> That's a pretty terrible name. mac80211 is not a valid prefix to be used =
in=20
> the codebase, at least not for structures and functions. Everything else =
uses=20
> ieee80211 so use of mac80211 is not acceptable, especially for driver fac=
ing=20
> API. (the use of that prefix in event.c isn't right either.. need to fix=20
> that)

Heh. True, I'll s/mac80211_vif/ieee80211_vif/

> Leaving it to the driver to allocate the private space isn't too great ei=
ther.=20
> Something like a char subif_priv[] at the end of ieee80211_sub_if_data an=
d a=20
> way to specify the length of the private area will be more useful to driv=
ers=20
> which wish to use the per-subif private space by avoiding extra allocatio=
n=20
> and allocation failure handling and also for drivers which don't, by=20
> eliminating the overhead of storing an unused pointer. It is also more=20
> consistent with the other apis that allocate ieee80211_hw and net_device.

Most drivers won't ever need private space, so leaving it to them to
allocate is more efficient.

johannes

--=-HZdzyhv9gfJWosUbRLPe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR1Z666Vg1VMiehFYAQI7MQ/8CQcNimKnzaOvlZGk9vJI/mxDmfWfSpBB
X2U5IWUI0o1oIPxTarr9C0boDLcNk5RJkFy3/RpXXrUkOeo5aTNkkdfkIR7wx0L6
X/AUzzQ2BSHvmeei8KO5z8rxMtBCx4D9sw7N1AaaDjCR0EFTww7EEmG1DRc7EjG3
MUDSVNwXLURvk24L9/FM+N1iQaS84Gwtv45Cked1rX5HeBm0SY4hh48avifUL4rt
LfCjVXSHZ1vo7cAlMkoDmUtV9PP0yjGOAh4nHVQlg6ff+eAc35tBqwHkYvMkMkG5
AE77kfUlXBXPC9bVvl7BISzqqWYrENoECUO3bY4ZEUynPlHvRLsv2ImI7CZx1dZx
oQBi8Rfv86qT4YsK9G7y8v1lZs4+dRm5EbERJ/a1xR72YvrYEKSAucPHbxBmvXS3
PRItMZDuX2rQXV50vEhKrQNvYfAJ96AOhAlPafSDfxheyUNBg+fd6u8sRpOjIuvo
kv9BSLOa+GVQjKtleqUAj/GDeDh86hAa4MrBtm5dyMIcSRGNrqRwQz+OAakxKemm
k/2ygorXlKEB/TbnMs0UNUqr6R/zwDdLGjmxaTDMJJMhbmY6sSvCQp2VInNpQgLM
Drmqu/yCjNU+m8kKqpurltM1PMosuZssiP7Y9lUgKEG5DHfQQlE0/XxLLTDtIUVk
wCO3qCOYWHU=
=uuzm
-----END PGP SIGNATURE-----

--=-HZdzyhv9gfJWosUbRLPe--

