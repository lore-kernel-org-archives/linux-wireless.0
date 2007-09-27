Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44312 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635AbXI0Qpf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 12:45:35 -0400
Subject: hostapd: passing sta info struct to drivers?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+R6HLiPV8BL1rml1se62"
Date: Thu, 27 Sep 2007 18:46:39 +0200
Message-Id: <1190911599.5021.4.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+R6HLiPV8BL1rml1se62
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

During porting the STA management to nl80211 it turned out that it would
be much nicer in the kernel if we would always set all the flags on a
STA that the kernel needs to get from hostapd.

To implement that, it would be good to simply pass the sta_info
structure, e.g. we currently have this code:

        if (sta->flags & WLAN_STA_WME)
                hostapd_sta_set_flags(hapd, sta->addr, WLAN_STA_WME, ~0);
        else
                hostapd_sta_set_flags(hapd, sta->addr, 0, ~WLAN_STA_WME);

and that would become

	hostapd_sta_set_flags(hapd, sta, WLAN_STA_WME);
or
	hostapd_sta_set_flags(hapd, sta->flags, WLAN_STA_WME);

where the third parameter indicates which flag may have changed and the
nl80211 driver would simply use only the flags.

Do you see any issues with that? Are there sometimes flag changes that
we do not want to commit to the kernel?

johannes

--=-+R6HLiPV8BL1rml1se62
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG+95u/ETPhpq3jKURAhFiAJ4uZ0Lv6ltFlo0sZUbdcl8fUj+iWgCdF4uM
ovxLZe7cJMGVBb37KVfXCU4=
=zTPC
-----END PGP SIGNATURE-----

--=-+R6HLiPV8BL1rml1se62--

