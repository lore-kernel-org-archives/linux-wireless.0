Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38481 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbcETOk4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2016 10:40:56 -0400
Received: by mail-wm0-f41.google.com with SMTP id n129so85900596wmn.1
        for <linux-wireless@vger.kernel.org>; Fri, 20 May 2016 07:40:56 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@open-mesh.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] ath10k: Add support for QCA9887
Date: Fri, 20 May 2016 16:40:46 +0200
Message-ID: <1568876.Six5hABE57@bentobox> (sfid-20160520_164101_054925_49C68E8E)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2051463.9KyNamfX2f"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2051463.9KyNamfX2f
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

the QCA9887 chip is similar to the QCA988x chips. But it requires a special
firmware and uses a different calibration data source. Unfortunately, no
working firmware currently exists. But it is possible to create a semi working
one by binary patching the current version.

    # download new fw + set ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX+ATH10K_FW_FEATURE_NO_P2P
    curl -o firmware-5.bin https://raw.githubusercontent.com/kvalo/ath10k-firmware/master/QCA9887/firmware-5.bin_10.2.3.31.7-1
    echo -en '\x0c'|dd conv=notrunc bs=1 seek=231112 of=firmware-5.bin
    mkdir -p /lib/firmware/ath10k/QCA9887/hw1.0/
    mv firmware-5.bin /lib/firmware/ath10k/QCA9887/hw1.0/firmware-5.bin

I am also guessing that ATH10K_FW_FEATURE_SUPPORTS_SKIP_CLOCK_INIT should
also be set but this would require a ie_len of 2.


The QCA9887 support should be considered really experimental because we don't
have any information how the interface to firmware actually looks like. The
workarounds mentioned above were just implemented because we saw the firmware
crashing and then guessed the most plausible reason for it.

We are also guessing that there is no HTT_10X_T2H_MSG_TYPE_MGMT_TX_COMPL_IND in
this firmware and WMI_10X_VDEV_PARAM_RTS_FIXED_RATE maybe is also not existing
(which would reduce the value of every entry in wmi_10x_vdev_param after that
by one). But this is just a wild guess and we don't have any real information
about that.

Kind regards,
	Sven
--nextPart2051463.9KyNamfX2f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXPyHuAAoJEF2HCgfBJntGuHkP/3nLEOD6QqS/MVry6HOasLmN
fSinlkboFK0dVbMPhxmt2ZHlSfHVQynVAyhqh+XFIvabUxqmKrId+LBgPYd8BqT9
1JFhFoYWkD9YAs6SkNht7ENpyTEBaOuKLnIfXpz7uC3t8RBg8dmeKW2XlbgbbhVK
IvleKM98n2WsfINviEVrFoOeYwNi5l8Rmw9AVkVlGmTBBM7spIx2GykIansXWqCK
vHKaIkWWocfD2h6xO0jXPeVa6L8ieBgK+PfegHdGrOlyFGeOH23H/VHvcZxzqelH
2SGJ5cBIs/cQ29eyaKBXO0F17o8lOXGwl0nQRLR8dh9R9Jt0BJWi6iXEmIa6jqAD
EQuZ+ay/aF1EhmSoxXwVj1NJtyfox9ba53C+jfoN5lSyuLE1EDGZ1DsrJPLwE/CM
k8pt+9cm4Vfc3WdWuTjI2PB02sQzs86VKLKUV6KsIPG5D4BhxdUp89+bCcB1n5jN
KJcLGkjvqKONUNVV62saTHa8nssuYI39gSlZRZ5cL7tHMG/eiY/PjMy7WGmWh2hs
CaQ9mMrJ3tCfdYOFYG1e/qbM0/0mMlBbkJktRn4nWzdEGzvloWHJT89MC+TwkQhZ
dK/Vit03Tr9nDUVsPjWasvi6qbd1Lx9zfvt6k9HsjK7RiAqPg9qb8yv7zQyJ/Ydg
hkUrY4bpRkRWtmIi6AsW
=9d9O
-----END PGP SIGNATURE-----

--nextPart2051463.9KyNamfX2f--

