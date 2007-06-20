Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50514 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbXFTLR6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 07:17:58 -0400
Received: from [131.234.77.145]
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1I0yCD-00072B-Md
	for linux-wireless@vger.kernel.org; Wed, 20 Jun 2007 12:17:57 +0100
Subject: notifications in nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dsb+OaEwrJSElpFGUVsY"
Date: Wed, 20 Jun 2007 11:19:47 +0200
Message-Id: <1182331187.3714.28.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dsb+OaEwrJSElpFGUVsY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

After the previous two mails it seems that of the notifications we
currently send out, only these are left to implement in nl80211:

 * ieee80211_msg_wep_frame_unknown_key
   low priority, makes sense but isn't used in hostapd/wpasupplicant
 * ieee80211_msg_key_threshold_notification
   low priority, makes sense but isn't used in hostapd/wpasupplicant
 * ieee80211_msg_michael_mic_failure

so really there's only one. All the others we can just delete (well, see
the other two mails), and these
 * ieee80211_msg_normal
 * ieee80211_msg_tx_callback_ack
 * ieee80211_msg_tx_callback_fail
 * ieee80211_msg_sta_not_assoc
 * ieee80211_msg_passive_scan [completely unused]

are not useful when we mirror back packets to monitor mode interfaces on
tx status callback. That should actually be fairly easy to accomplish,
and then we can drop management interfaces completely.

johannes

--=-dsb+OaEwrJSElpFGUVsY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGePEz/ETPhpq3jKURAjDVAJ9Q1ZtUxON8uh72jxGQWFnUSVNWwQCeIu1Q
mH2tRtKuDz1L3xYnNBTH5wA=
=ixF/
-----END PGP SIGNATURE-----

--=-dsb+OaEwrJSElpFGUVsY--

