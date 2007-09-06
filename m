Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37938 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965240AbXIGNYk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 09:24:40 -0400
Subject: COMMON symbol warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
	Tomas Winkler <tomasw@gmail.com>, Zhu Yi <yi.zhu@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QNBweKiZ8Tb+0pHyi27o"
Date: Thu, 06 Sep 2007 19:38:34 +0200
Message-Id: <1189100314.28781.112.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QNBweKiZ8Tb+0pHyi27o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

After my compile run with __CHECK_ENDIAN__ the modules were built and I
got:

WARNING: "iwl_param_debug" [drivers/net/wireless/iwl3945] is COMMON symbol
WARNING: "iwl_param_disable_hw_scan" [drivers/net/wireless/iwl3945] is COMM=
ON symbol
WARNING: "iwl_param_hwcrypto" [drivers/net/wireless/iwl3945] is COMMON symb=
ol
WARNING: "iwl_param_antenna" [drivers/net/wireless/iwl3945] is COMMON symbo=
l
WARNING: "iwl_param_disable" [drivers/net/wireless/iwl3945] is COMMON symbo=
l
WARNING: "iwl_param_debug" [drivers/net/wireless/iwl4965] is COMMON symbol
WARNING: "iwl_param_disable_hw_scan" [drivers/net/wireless/iwl4965] is COMM=
ON symbol
WARNING: "iwl_param_hwcrypto" [drivers/net/wireless/iwl4965] is COMMON symb=
ol
WARNING: "iwl_param_antenna" [drivers/net/wireless/iwl4965] is COMMON symbo=
l
WARNING: "iwl_param_disable" [drivers/net/wireless/iwl4965] is COMMON symbo=
l
WARNING: "zd_workqueue" [drivers/net/wireless/zd1211rw-mac80211/zd1211rw-ma=
c80211] is COMMON symbol
WARNING: "zd_workqueue" [drivers/net/wireless/zd1211rw/zd1211rw] is COMMON =
symbol

any idea what that means? It's from scripts/mod/modpost.c:
        switch (sym->st_shndx) {
        case SHN_COMMON:
                warn("\"%s\" [%s] is COMMON symbol\n", symname, mod->name);
                break;

johannes

--=-QNBweKiZ8Tb+0pHyi27o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4Dsa/ETPhpq3jKURAkCtAJ4yGatfNwn287f+sl0tJTPH+5DmEwCfQzbT
wsukU/PqVBqFeAx96wemAsU=
=oQye
-----END PGP SIGNATURE-----

--=-QNBweKiZ8Tb+0pHyi27o--

