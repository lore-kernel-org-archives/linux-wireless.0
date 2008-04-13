Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47258 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbYDMIoE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2008 04:44:04 -0400
Subject: [PATCH] mac80211: fix key todo list order
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ehud Gavron <gavron@Wetwork.Net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-D9GWGcXhuWrqqr4wtmhh"
Date: Sun, 13 Apr 2008 10:43:50 +0200
Message-Id: <1208076230.4111.29.camel@johannes.berg> (sfid-20080413_094412_939874_1A6AD63A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-D9GWGcXhuWrqqr4wtmhh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

When we add multiple todo entries, we rely on them being executed
mostly in the right order, especially when a key is being replaced.
But when a default key is replaced, the todo list order will differ
from the order when the key being replaced is not a default key, so
problems will happen. Hence, just move each todo item to the end of
the list when it is added so we can in the other code ensure that
hw accel for a key will be disabled before it is enabled for the
replacement.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This is rather subtle. The patch should completely fix the problem seen
by Ehud, though in his case the other patch I mentioned in the thread
will already have fixed it since his WEP key is a default key.

 net/mac80211/key.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- everything.orig/net/mac80211/key.c	2008-04-13 10:36:43.000000000 +0200
+++ everything/net/mac80211/key.c	2008-04-13 10:40:47.000000000 +0200
@@ -74,9 +74,12 @@ static void add_todo(struct ieee80211_ke
=20
 	spin_lock(&todo_lock);
 	key->flags |=3D flag;
-	/* only add if not already added */
-	if (list_empty(&key->todo))
-		list_add(&key->todo, &todo_list);
+	/*
+	 * Remove again if already on the list so that we move it to the end.
+	 */
+	if (!list_empty(&key->todo))
+		list_del(&key->todo);
+	list_add_tail(&key->todo, &todo_list);
 	schedule_work(&todo_work);
 	spin_unlock(&todo_lock);
 }


--=-D9GWGcXhuWrqqr4wtmhh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAHHxaVg1VMiehFYAQKORw//X0NNoZ6ve2ln0Um6jOOphyY7tOtfKjwa
r90+O3tMDjsimbjNifo21VVJOVsE1rluIwfw9Mvdu8RqkCwESyXQFlvoGaWEMqRS
M8egl/IW4FEoKg7JRFTgBQA7zC7+NYFCqgup1b5iIH4k4WW35AnwNlggbrJ7ajON
d5Duoka9AcBs4N3opuqUfD/ml8rpk38YWF3hs8SD01NKddw4DeyUa+FJPHBFWFfn
7abuOveSDODR4V+rYfUmNAbcuiK6hQrP4BErJBDcRQSCaunQpR8OD4EVj37nMWon
MC4/jyKRKxZ69E9TRofo0w2c9FhUDJGfKUiyGe9xvuOkz7fgdJh3/ufz+S9ze3NA
LTRl2eHyKK8IOmlJRqgnSNCxteV9KoCIQAV2fN7PRp9a3HBv1rm3qrFxIsqZ2mSc
8I6s9RgsQcjbhR3M8QFzbgbMps3iWhyirWY0I9kaYL/xiENcLXrmlVlXSGpMM16Q
E+5mL8Fa4Jip3CyDMV6CEqRV6eVuRED/T7Ab2n6lTLpY7UicC6Bmt+Pd7HKb9iOD
znYrWTl0QS11PVMQbPyzvKTZMqnxZMLwsV+CnACvNbrdCWWyBJbQZ2meWNv3TOag
s1TeMoZJdzRt/280XIbJ1ovObonVf0vDbSCVSbW/qYRej5wuVRiaQ0PM8Xiq74FG
dvYAqM2grKg=
=DgqV
-----END PGP SIGNATURE-----

--=-D9GWGcXhuWrqqr4wtmhh--

