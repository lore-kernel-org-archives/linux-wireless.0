Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53055 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764172AbYDQQ6s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 12:58:48 -0400
Subject: Re: [PATCH] mac80211: Fix n-band association problem
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>
In-Reply-To: <1208379724-13568-1-git-send-email-reinette.chatre@intel.com> (sfid-20080416_220312_598962_80DA4049)
References: <1208379724-13568-1-git-send-email-reinette.chatre@intel.com>
	 (sfid-20080416_220312_598962_80DA4049)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kCMgdGTOB240zIpl519Z"
Date: Thu, 17 Apr 2008 18:58:40 +0200
Message-Id: <1208451520.4066.25.camel@johannes.berg> (sfid-20080417_175853_684685_496B6A29)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kCMgdGTOB240zIpl519Z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-04-16 at 14:02 -0700, Reinette Chatre wrote:
> From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
>=20
> There are two structures named wmm_info and wmm_param, they are used whil=
e
> parsing the beacon frame. (Check the function ieee802_11_parse_elems).
> Certain APs like D-link does not set the fifth bit in WMM IE.
> While sending the association request to n-only ap it checks for wmm_ie.
> If it is set then only ieee80211_ht_cap is sent during association reques=
t.
> So n-only association fails.
> And this patch fixes this problem by copying the wmm_info to wmm_ie,
> which enables the "wmm" flag in iee80211_send_assoc.
>=20
> Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> Acked-by: Ron Rindjunsky <ron.rindjunsky@intel.com>

Ack, thanks for the update.

> ---
>=20
> This problem is also present in 2.6.25. This patch does apply to
> 2.6.25-rc9 after changing the filename to be patched to ieee80211_sta.c

Do we want this for -stable then?

johannes

--=-kCMgdGTOB240zIpl519Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAeBv6Vg1VMiehFYAQJ8IA//coPoouMApNrIRqaOFMFYJxo+a2+bk2F7
PUyJAR0lTtPrIEMVd8nsd5chvGVRpw0dJrWpAPsmFIPhK9fbQThYATZVtNbwoXH3
YUczgZXaH5bFNfAXf4o2WK9BDcf8JXn1GmDegXEDhWBpv5vDdrZqFlXXyq3BZbnn
pXnZ8ASPtVu5sBTqkv4SWL9qL5+7RezUiOgDjU7DIY6LEwrh/NDl6oUje/WAD7UV
S1ZRssvhSOqDNvcTxsy06+XFwdKVVWreYmBkNRfm8od4hDjeuzdpAA8+Hn/UMxhu
FJ+zGnIVO+gXHXrIK5HgnHrqx8mun6PNRgMSFSp+KwnChQhrJ9jRK3iUTpqSXf58
ixgmdIHd2JlV5YlICOHDyVbiU/s4D3LrWME6Wim0Bk/oSHgw/jldqJQaXYkN26Qp
tzRN9hkGtZ5VtfkvtOToSOseadhHdLcJ3k2VQjwis6AYAHTYsnAslMzJxNRu+4tC
x/7RJAWLZTn6WFmgiJjn+VIPFBX6MT+uhh1B5JOVGkJ0bYr512uNhMeYdQ4Li7l2
K74EXhNmekDypCyuBFFTLaC2P4Oj24fpKWVDp2Yn4Yk9TF2tWpoykvr3zYDz3urZ
AaNOgmIGfaiWFpYYuNa23DUZ8r+MaLqmSXOdZssEJwD3ScKRUybBXmq3/2FRetS2
HiXTRAyxN3g=
=vWgn
-----END PGP SIGNATURE-----

--=-kCMgdGTOB240zIpl519Z--

