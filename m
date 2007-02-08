Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:30991 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751947AbXBHXOA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Feb 2007 18:14:00 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: [PATCH] d80211: trivial cleanups in ieee80211_i.h
Date: Thu, 8 Feb 2007 18:13:24 -0500
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart390330504.9EHNbcd7CI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702081813.31301.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart390330504.9EHNbcd7CI
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

d80211: trivial cleanups in ieee80211_i.h

This removes some unused things and fixes a typo.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 net/d80211/ieee80211.c   |    1 -
 net/d80211/ieee80211_i.h |    5 +----
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
index 82daeb8..bbcefa9 100644
=2D-- a/net/d80211/ieee80211.c
+++ b/net/d80211/ieee80211.c
@@ -4559,7 +4559,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	spin_lock_init(&local->sub_if_lock);
 	INIT_LIST_HEAD(&local->sub_if_list);
=20
=2D        spin_lock_init(&local->generic_lock);
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_sta_scan_work);
 	init_timer(&local->stat_timer);
 	local->stat_timer.function =3D ieee80211_stat_refresh;
diff --git a/net/d80211/ieee80211_i.h b/net/d80211/ieee80211_i.h
index 5ab9eb5..bb8fc83 100644
=2D-- a/net/d80211/ieee80211_i.h
+++ b/net/d80211/ieee80211_i.h
@@ -350,7 +350,7 @@ struct ieee80211_local {
 	struct class_device class_dev;
=20
 	enum {
=2D		IEEE80211_DEV_UNITIALIZED =3D 0,
+		IEEE80211_DEV_UNINITIALIZED =3D 0,
 		IEEE80211_DEV_REGISTERED,
 		IEEE80211_DEV_UNREGISTERED,
 	} reg_state;
@@ -368,7 +368,6 @@ struct ieee80211_local {
 		ieee80211_tx_status_msg =3D 2
 	} ieee80211_msg_enum;
=20
=2D        spinlock_t generic_lock;
 	/* Station data structures */
 	struct kset sta_kset;
 	spinlock_t sta_lock; /* mutex for STA data structures */
@@ -479,8 +478,6 @@ struct ieee80211_local {
         u32 stat_time;
         struct timer_list stat_timer;
=20
=2D        struct proc_dir_entry *proc, *proc_sta, *proc_iface;
=2D
 	struct work_struct sta_proc_add;
=20
 	enum {

--nextPart390330504.9EHNbcd7CI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFy66bT3Oqt9AH4aERAuhvAKDPdIfpjQbL0vhuFVvv+OAMiENnzwCg03r/
xG/wP0AZgAa6lkSrkH7BuQo=
=jL/f
-----END PGP SIGNATURE-----

--nextPart390330504.9EHNbcd7CI--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
