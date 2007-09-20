Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59950 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbXITNuV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 09:50:21 -0400
Subject: mac80211 and QoS support
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Tomas Winkler <tomasw@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UXQKZI6B8I966uPMQGoA"
Date: Thu, 20 Sep 2007 11:57:53 +0200
Message-Id: <1190282273.18521.31.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UXQKZI6B8I966uPMQGoA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hey,

After looking again into why we were sending frames with invalid QoS
control fields under certain circumstances it occurred to me that this
would only happen when CONFIG_NET_SCHED was not set.

That, however, seems wrong: when CONFIG_NET_SCHED is unset we really are
behaving as a non-QoS STA. However, even if it is set we never announce
our QoS capability, hostapd will never set the QoS capability field in a
beacon and neither will we set in our capability information in
(re)association requests.

On the other hand, in both cases we will start sending QoS frames if the
other side has announced support for it in their capability information.
It seems to me that this violates the mandated behaviour if we're an AP
in that we force a QoS-capable STA to behave as a QoS STA although it is
associated to a non-QoS BSS and thus should expect to work as a non-QoS
STA.

It seems to me that we should introduce a new per-interface (where VLAN
interfaces use the AP setting) "QoS enabled" setting that wpa_supplicant
(when acting as MLME) or hostapd set. For the in-kernel-MLME, I would
suggest to force it to be off. Enabling QoS would be disallowed when
CONFIG_NET_SCHED is unset or when we have only one hardware queue. It
should then behave like the 802.11 option "dot11QosOptionImplemented",
but consistency wouldn't be enforced (i.e. hostapd sets this option so
it is also required to set the QoS capability flag and insert the EDCA
parameter set or QOS capability IE)

johannes

--=-UXQKZI6B8I966uPMQGoA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG8kQh/ETPhpq3jKURApmpAJ0dXNrd1EzmtsSuN695KFHIoTv7sgCeM6f2
Pmyy+LUASRaMiHPZF4zn+NA=
=OnGT
-----END PGP SIGNATURE-----

--=-UXQKZI6B8I966uPMQGoA--

