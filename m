Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41383 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967446AbXFHJfF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 05:35:05 -0400
Subject: userspace MLME
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>,
	Zhu Yi <yi.zhu@intel.com>, Jiri Benc <jbenc@suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KTwqEZodNporkIfB5nnP"
Date: Fri, 08 Jun 2007 11:35:19 +0200
Message-Id: <1181295319.6533.50.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KTwqEZodNporkIfB5nnP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Here's a repost of my thoughts I just posted deep in that other thread.
If you read it, please reply here, otherwise it's good that I'm
reposting, right? :) Sorry for sending it twice, but some more thoughts
might follow so I'd rather split it off from the other thread

IMHO, in order to get the userspace MLME idea to take off, somebody
really needs to

 1) repost/integrate the injection patches
 2) implement a nl80211 API for the userspace MLME
 3) fix the userspace MLME implementation stuff in mac80211 to work with
    the injection patches and the new nl80211 API
 4) publish an adapted userspace MLME that uses this (or patches to wpa
    supplicant)
 5) write some documentation
 6) put that userspace MLME into git, publish the tree on kernel.org and
    maintain it
 7) decree that wpa supplicant is on-topic for linux-wireless


Some of these have sub-points:
 2a) in mac80211, rip out all the userspace MLME stuff and analyse what
     is required
 2b) add the commands to nl80211 (make sure that only one userspace MLME
     can drive a single interface)
 2c) add the commands to cfg80211
 2d) re-implement the commands in mac80211 based on cfg80211
 2e) since we want to be able to configure the userspace MLME through
     the kernel, implement nl80211 command forwarding to the userspace
     MLME [1]

[1] Actually, I'd think that *all* commands should be forwarded to the
userspace MLME except for commands *from* the userspace MLME. That way,
the userspace MLME can act as a filter for commands which should make a
whole bunch of things easier.

johannes

--=-KTwqEZodNporkIfB5nnP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGaSLW/ETPhpq3jKURAgnEAJ9JsB8/xmFVE0393Z/oeAOmIaFxowCglabG
dtWUgP393LbrMRwVd8I3xlo=
=4Zvf
-----END PGP SIGNATURE-----

--=-KTwqEZodNporkIfB5nnP--

