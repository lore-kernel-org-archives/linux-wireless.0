Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59969 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbXFPTtB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2007 15:49:01 -0400
Received: from [84.135.217.188] (helo=[10.0.0.4])
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1HzeGa-0008EO-03
	for linux-wireless@vger.kernel.org; Sat, 16 Jun 2007 20:49:00 +0100
Subject: nl/cfg80211 scan result/event handling
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Aziz8q1bWG25CcWw94FU"
Date: Sat, 16 Jun 2007 21:49:32 +0200
Message-Id: <1182023372.9058.68.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Aziz8q1bWG25CcWw94FU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hey,

Just a few notes as I'm thinking about these things. I probably won't be
implementing this quickly so I'm telling you, but who knows, maybe I'll
get around to it and then... Here's hoping for some feedback :)

Right now I'm thinking along the lines of:
void cfg80211_key_threshold_notify(struct wireless_dev *wdev,
				   int txrx_count,
				   u8 *mac);

or
void cfg80211_radar_notify(struct wireless_dev *wdev,
			   phymode, channel, ...)

and then cfg80211 is responsible for sending the appropriate nl80211
messages or doing whatever else to notify userspace.

As for scan results, we want those broadcast as well. I was thinking
that we have basically these choices:
 1) drivers (stack) aggregate data
 2) drivers (stack) call a function for each result
 3) hybrid

I tend towards 3 because it allows both, in a fashion like this:

cfg80211_add_scan_result(struct wireless_dev *wdev,
			 int n_results,
			 struct scan_result **sr);
cfg80211_scan_finished(struct wireless_dev *wdev);

and for the add_scan_result calls cfg80211 simply starts creating the
nl80211 message and then multicasts it to those who want it
(NL80211_GROUP_SCAN or such) on _scan_finished()

Thoughts?

johannes

--=-Aziz8q1bWG25CcWw94FU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGdD7M/ETPhpq3jKURApGfAKCPkgdubzR/iLnk8MBsh4WDiPp/hgCcCaAF
knjejbRIEEWuj+7Dv/LxY2g=
=ChP0
-----END PGP SIGNATURE-----

--=-Aziz8q1bWG25CcWw94FU--

