Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52638 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaBCLWt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 06:22:49 -0500
Received: from [192.168.1.100] ([93.196.93.204]) by mail.gmx.com (mrgmx101)
 with ESMTPSA (Nemesis) id 0MVZuV-1Vk20V212F-00YzCg for
 <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:22:32 +0100
Message-ID: <52EF7BEB.5080605@rempel-privat.de> (sfid-20140203_122255_685768_B47F62B2)
Date: Mon, 03 Feb 2014 12:22:19 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 05/13] ath9k_htc: add rx header converter to make it usable
 by ath9k
References: <1391022315-20946-1-git-send-email-linux@rempel-privat.de>	<1391022424-21087-1-git-send-email-linux@rempel-privat.de>	<1391022424-21087-4-git-send-email-linux@rempel-privat.de> <21230.64089.741.909535@gargle.gargle.HOWL>
In-Reply-To: <21230.64089.741.909535@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="vSXEuX96LN70dvfw4PATcmuh94GqBMUpT"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vSXEuX96LN70dvfw4PATcmuh94GqBMUpT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 03.02.2014 03:09, schrieb Sujith Manoharan:
> Oleksij Rempel wrote:
>> +	rx_stats =3D kzalloc(sizeof(struct ath_rx_status), GFP_KERNEL);
>> +	if (unlikely(rx_stats =3D=3D NULL)) {
>> +		ath_err(common, "rx_stats allocation filed!\n");
>> +		goto err_nofree;
>> +	}
>> +	rx_status_htc_to_ath(rx_stats, &rxbuf->rxstatus);
>> +

> This seems a little expensive, since this would happen for every packet=
,
> and a memcpy is already done earlier, for storing the RX status in
> rxbuf->rxstatus. Instead of using 'struct ath_htc_rx_status' in
> 'struct ath9k_htc_rxbuf', why can't 'struct ath_rx_status' be used ?
> The values can be converted and stored directly, avoiding this alloc.

Do you mean kzalloc or converter?
then memcpy is removed by patch 12/13. Converter is not effective but it
should prevent from confusions. At least until FW use same flags and
struct ath_rx_status do.
But i'm open for other ideas too.

--=20
Regards,
Oleksij


--vSXEuX96LN70dvfw4PATcmuh94GqBMUpT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLve/IACgkQHwImuRkmbWl8ZwD/UHCz8WTXSc0Jq2f6vvbZPUcJ
Kxz3YTCBaBkuXP6IwKkA/1yInKyaInhtz7Ijh7OtPbn9IRTRdLZALQ33cFl/kXNF
=a9sB
-----END PGP SIGNATURE-----

--vSXEuX96LN70dvfw4PATcmuh94GqBMUpT--
