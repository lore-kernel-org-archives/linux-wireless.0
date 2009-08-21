Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40500 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbZHUIVj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 04:21:39 -0400
Subject: Re: [PATCH] iwlwifi: Make injection of non-broadcast frames work
 again
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Zhu Yi <yi.zhu@intel.com>, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Rafael Laufer <rlaufer@cs.ucla.edu>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A8DC955.9060100@gmail.com>
References: <4A8DC955.9060100@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-F2oOTndymUuRTqkWxsK9"
Date: Fri, 21 Aug 2009 10:21:29 +0200
Message-Id: <1250842889.13872.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-F2oOTndymUuRTqkWxsK9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-21 at 00:08 +0200, G=C3=A1bor Stefanik wrote:

>  	/* If this frame is broadcast or management, use broadcast station id *=
/
> -	if (!ieee80211_is_data(fc) ||  is_multicast_ether_addr(hdr->addr1))
> +	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1) ||
> +	    iwl_is_monitor_mode(priv)) /* Injected frames need broadcast too */
>  		return priv->hw_params.bcast_sta_id;

Now you still can't transmit frames to another AP when connected to one,
which will, for example, be required for 11r. IMHO that code should, in
STATION mode, be checking the RA against the BSSID, and if they match
use the AP ID, otherwise the bcast ID. And remove the warning in the
default case, since that's what happens if in pure monitor mode afaict.

johannes

--=-F2oOTndymUuRTqkWxsK9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKjlkGAAoJEODzc/N7+Qmai2oP/iCJfWQrcija4Hyfd1naw0lx
sCRCJ/Riuixp8PkeDKnTkhwJm/oF6xyOVKnaTZjpwXH+X+2a5ES9EZJfkV16B3Yu
6Qn7d27+UQnJ5Bqzh/3jbeOTGt5FCeXPtXOyET6az6Wr8adExMjZ6+mWzUZCJ83J
onyKrM3WbknuIQ+JWibujoxk6Vr0luC3kqpJWARIBNpeggS7MfhTSYobaAVqkWHD
VFUVM9bIYmG6RozajANZhG1L0X0MUVrmAFCYlRd+34XNBmVJU/e9aqzR74a5TS/d
j0HlFxg3AnJYhsG3hFjcAVniyExFKY8iYMFv0vOy2P/0dXkyZZFXXpA/r0MqLDjf
Vk7MZUMu9sbiInju/LtynScCSbzhCZlEdRg74A98p6xir76TFfGslM3q68/vLv89
qBhmPiF1On+uvV5vsYeezZaXuovNXDXC7u8nd9Afckna0EcMKLHixKpgoyIpZFbW
dVhZKkfQW6DwQIXo2Ku1Jaq5WDCjhxQcKbRRdsdKkitxTu8TA7BDWkenZtaVrOnn
5SzT02EBeBo5ZfRFfFFj+ir9KVuJukqrCseasSvmTOq9i2NSNB0ddmTJRUhHeRZN
t0qK8UeAt9ohjXcu0fCCG1IaqPykQUlKxQmQGOVd/EFPy4AzurCQyBCSJf3TPs0E
RL3pFV9/L8znGPjjCCE+
=CxZX
-----END PGP SIGNATURE-----

--=-F2oOTndymUuRTqkWxsK9--

