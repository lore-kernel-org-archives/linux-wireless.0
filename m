Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59860 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbYKTG4n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 01:56:43 -0500
Subject: Re: [PATCH 7/7] iwlwifi: prevent double key removal
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <1227137548-28718-8-git-send-email-reinette.chatre@intel.com> (sfid-20081120_003216_235323_380F5650)
References: <> <1227137548-28718-1-git-send-email-reinette.chatre@intel.com>
	 <1227137548-28718-2-git-send-email-reinette.chatre@intel.com>
	 <1227137548-28718-3-git-send-email-reinette.chatre@intel.com>
	 <1227137548-28718-4-git-send-email-reinette.chatre@intel.com>
	 <1227137548-28718-5-git-send-email-reinette.chatre@intel.com>
	 <1227137548-28718-6-git-send-email-reinette.chatre@intel.com>
	 <1227137548-28718-7-git-send-email-reinette.chatre@intel.com>
	 <1227137548-28718-8-git-send-email-reinette.chatre@intel.com>
	 (sfid-20081120_003216_235323_380F5650)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-po/x47rnRJ4/MeFwuN3T"
Date: Thu, 20 Nov 2008 07:56:04 +0100
Message-Id: <1227164164.17336.18.camel@johannes.berg> (sfid-20081120_075646_740764_012BCFF4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-po/x47rnRJ4/MeFwuN3T
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-19 at 15:32 -0800, Reinette Chatre wrote:


> When the key is removed a second time the offset is set to 255 - this ind=
ex
> is not valid for the ucode_key_table and corrupts the eeprom pointer (whi=
ch
> is 255 bits from ucode_key_table).

> +	if (WARN(priv->stations[sta_id].sta.key.key_offset =3D=3D WEP_INVALID_O=
FFSET,
> +		 "Removing wrong key %d 0x%x\n", keyconf->keyidx, key_flags)) {
> +		spin_unlock_irqrestore(&priv->sta_lock, flags);
> +		return 0;
> +	}

So, since _this_ patch has been tested to fix the problem, the WARN_ON
must be triggering.

What are you doing to address the actual bug that causes it to trigger?

johannes

--=-po/x47rnRJ4/MeFwuN3T
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJQoAAAoJEKVg1VMiehFY/3IP/j13eopYercbBLL4HXqT84yf
wLGzNyzQ/8pB1tZsU4AzcYf4GWqYZ0ZIE6uHnetsNNQSoUuIXwHu8jilEBpzX2WQ
YwHATAeOhCH3l5nX7xx+TlzrQcnOzOv5uee37KEjZmq3hOSot1OSCu/ChHld4fat
o7ObaqebdD/Ybi9GjAH1o0HrL6SBWR7NYKucU8YYAXiRFoV/5kg37gVUXuk28Agg
W9ik8Ri+t4o3E+cEtHhhn5DF5kAjVsH64kyUpirG5XA0X6e4kfb2Fk+/AsehzNDU
oIerizBhNkBrAahrE0+ljrfx5tbpfs2C8tKmz23FbRJQlxnIcVBs62Wx8jajDLKN
vrH+06OH3ArRgrBZ8kGM2n+bu+LwJTA3315r7qhHHd0lwl6yFNfV9O1web0M1z1y
1N//qLnqD2ICGlOPIZmPyktEbRszTG69JckR4TMxOXgQNqFYI5oKd3eOGoxxQqe9
15zEmxH0rlVg/0l2acQ2fDOfSRRc2heucBGIvnSWUOl6W/l5KsCP0kXjmM3nTrxs
mGgFCcKHfMCysRhLZEDIM/kcLIPUNfhhHM2aFicBUR+vZJEdc99v7nM8wnPc9QvD
QIZUI6jmyX8hYuLoGjNsVUR0MmFoFLGE+58jcpJBuBFghTCcVJs7cEhf1ituzuWT
SUMSeq1uHolm8yfN0aM0
=UppJ
-----END PGP SIGNATURE-----

--=-po/x47rnRJ4/MeFwuN3T--

