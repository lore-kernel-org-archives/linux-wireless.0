Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43742 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbYC0NHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 09:07:03 -0400
Subject: Re: [PATCH 1/1] mac80211: A-MPDU MLME use dynamic allocation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1206556563-17390-1-git-send-email-tomas.winkler@intel.com>
References: <1206556563-17390-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-viAJYTnHYXhNUfXUXUwU"
Date: Thu, 27 Mar 2008 14:06:58 +0100
Message-Id: <1206623218.22530.42.camel@johannes.berg> (sfid-20080327_130723_019189_91F8341D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-viAJYTnHYXhNUfXUXUwU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> This patch alters the A-MPDU MLME in sta_info to use dynamic allocation,
> thus drastically improving memory usage - from a constant ~2 Kbyte in
> the previous (static) allocation to a lower limit of ~200 Byte and an upp=
er
> limit of ~2 Kbyte.

Cool. This will definitely clash with the locking rework and struct
reordering I did, but I can redo those after comments and after this
patch.

>  	spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
> -	state =3D sta->ampdu_mlme.tid_tx[tid].state;
> +	state =3D sta->ampdu_mlme.tid_state_tx[tid];
>  	spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);

In fact, I forgot those locks anyway so the patch I posted won't work.

johannes

--=-viAJYTnHYXhNUfXUXUwU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+ub8aVg1VMiehFYAQIKUg/9FdmBnxj3hCqpro2x5yt4iNvJtOFmnnuE
gGWSfJX8DOda91wmN+mVMJ6QIR9vsC6V0Qbwu6ujo80dWXz+wK038JSQQZhfZ9y2
rGr9tt93wuG5J0Gi89JCa9Ld000s6xfYX7/zU/SILNhoEMnQVgYO/5KGD/UoXeKh
9l8MDYGBAS8aaM8y5FILdN2Y0fZZ8WzJWOuEcfwNIC15CcuEGEne/1eSFFR0HOjw
bA+hL1xjzDcGUJKVUex+06rsapsp0fM3P9aljlcqt+Zs9aVPt17+Bx177pbAobTZ
q/oP6iMUG1RCa+4ARpJ507pzz0yvYoLAWfG0qc26kWkBsmVdp4deBGjX2oPzQZC2
TDelQeLTJsyRR6zlEBpA3ZiBANLrNYcGJgPGfFJTa6jzsBXbXDVjavp+wWICNVr8
wrUC0eXKc524LRwlXcVnqP6Du8ZiMF1fvgN9+jnt6oGIHGwt5wONepo8aOWyXXJh
JsgHEp8oNRMTCULx79Oic/ADuzSQQqGFqh5ZN75ccfBjoY3rb29lx4zjvb6GcZ/e
bFiKkPte1Hvok2hE12m8l8wsH5AorTZn+ycmx7T0K44JRPJ8Ld0isCjQGdgexDLU
jMTcQt8zy63PCQ9MaEiW/qFJhB3IwJGspfoLFDdA1OmzSc0VpAW8kDrraAPQVBPD
OKRzYmX6sqw=
=HU2T
-----END PGP SIGNATURE-----

--=-viAJYTnHYXhNUfXUXUwU--

