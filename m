Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:40401 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab2GFNOz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 09:14:55 -0400
Date: Fri, 6 Jul 2012 14:50:43 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: ath9k-devel@lists.ath9k.org
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Adrian Chadd <adrian@freebsd.org>,
	Sven Eckelmann <sven@narfation.org>,
	Marek Lindner <lindner_marek@yahoo.de>,
	linux-wireless@vger.kernel.org
Subject: ath9k: Problems with diversity on AR9330
Message-ID: <20120706125043.GA23189@pandem0nium> (sfid-20120706_151500_748465_6015F7AC)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hey,

we have trouble with an AR9330 (Hornet) based AP. This device has 2 antennas, and is supposed to support diversity (2 RX, 1 TX). However, diversity is not really enabled because the "alternative" antenna is not considered as "good", because not enough frames are received. It seems that at 99% of the time, alt_rssi (read from rs->rs_rssi_ctl1) is invalid (set to ATH9K_RSSI_BAD, -128), while main_rssi (read from rs->rs_rssi_ctl0) usually has sane values.

We test by sending from a 1m distance (Laptop), and both antennas are connected, so the alternative antenna should usually get some sane frames too.

We have also tried to swap the antenna configuration of main and alt (LNA1 and LNA2), but only the alt_rssi will be invalid, and we then receive via the alternative antenna. We therefore think that the antenna wiring is not the problem.

We have also checked EEPROM values, which seem to be correct as well. FYI, register set after reading the EEPROM are:
AR_PHY_MC_GAIN_CTRL = 13EF0200
AR_PHY_CCK_DETECT = 803E6788

Any ideas/pointers/suggestions?

Thanks!
	Simon

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk/23yMACgkQrzg/fFk7axZ86wCg8A5QQH+H+8H8lMiqBeCpYIyN
fhEAnjs+pcyM462tbkre2M342k8DEX0C
=i53p
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
