Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60313 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643AbZAUNCk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 08:02:40 -0500
Subject: Re: [PATCH] mac80211: Add capability to enable/disable beaconing
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@Atheros.com
In-Reply-To: <1232538350.4358.5.camel@johannes.local> (sfid-20090121_134422_074044_459D7E1F)
References: <18805.33791.193195.755178@gargle.gargle.HOWL>
	 <1232448779.20158.4.camel@johannes.local>
	 <18805.62728.34610.424793@localhost.localdomain>
	 (sfid-20090120_170225_636861_F4C348AF)  <1232538350.4358.5.camel@johannes.local>
	 (sfid-20090121_134422_074044_459D7E1F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mrcdqHcrZUx2Q44iuqIc"
Date: Wed, 21 Jan 2009 14:02:38 +0100
Message-Id: <1232542958.6059.1.camel@johannes.local> (sfid-20090121_140259_880413_D5B0A3E4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mrcdqHcrZUx2Q44iuqIc
Content-Type: multipart/mixed; boundary="=-0HXUNlbNcAnUUlI6/tGO"


--=-0HXUNlbNcAnUUlI6/tGO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-21 at 12:45 +0100, Johannes Berg wrote:

> How about this? Untested still though.

That ran into a bug, here's a version that's hopefully better. (second
patch unchanged)

johannes

--=-0HXUNlbNcAnUUlI6/tGO
Content-Disposition: attachment; filename=015-mac80211-add-iflock.patch
Content-Type: message/rfc822; name=015-mac80211-add-iflock.patch

Subject: mac80211: add interface list lock
Content-Transfer-Encoding: quoted-printable
From: 
Date: Wed, 21 Jan 2009 14:02:35 +0100
Message-Id: <1232542955.6059.0.camel@johannes.local>
Mime-Version: 1.0

Using only the RTNL has a number of problems, most notably that
ieee80211_iterate_active_interfaces() and other interface list
traversals cannot be done from the internal workqueue because it
needs to be flushed under the RTNL.

This patch introduces a new mutex that protects the interface list
against modifications. A more detailed explanation is part of the
code change.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Need this for the scan stuff I'm doing next, but this has the side
effect of allowing you to call ieee80211_iterate_active_interfaces()
from mac80211's workqueue, which might be interesting.

 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/iface.c       |   31 +++++++++++++++++++++++++++++++
 net/mac80211/main.c        |    3 +++
 net/mac80211/util.c        |    4 ++--
 4 files changed, 38 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-01-21 12:48:12.00=
0000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-01-21 13:57:49.0000000=
00 +0100
@@ -643,7 +643,9 @@ struct ieee80211_local {
 	struct crypto_blkcipher *wep_rx_tfm;
 	u32 wep_iv;
=20
+	/* see iface.c */
 	struct list_head interfaces;
+	struct mutex iflist_mtx;
=20
 	/*
 	 * Key lock, protects sdata's key_list and sta_info's
--- wireless-testing.orig/net/mac80211/iface.c	2009-01-21 12:48:12.00000000=
0 +0100
+++ wireless-testing/net/mac80211/iface.c	2009-01-21 13:57:49.000000000 +01=
00
@@ -21,6 +21,23 @@
 #include "mesh.h"
 #include "led.h"
=20
+/**
+ * DOC: Interface list locking
+ *
+ * The interface list in each struct ieee80211_local is protected
+ * three-fold:
+ *
+ * (1) modifications may only be done under the RTNL
+ * (2) modifications and readers are protected against each other by
+ *     the iflist_mtx.
+ * (3) modifications are done in an RCU manner so atomic readers
+ *     can traverse the list in RCU-safe blocks.
+ *
+ * As a consequence, reads (traversals) of the list can be protected
+ * by either the RTNL, the iflist_mtx or RCU.
+ */
+
+
 static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
 {
 	int meshhdrlen;
@@ -800,7 +817,9 @@ int ieee80211_if_add(struct ieee80211_lo
 					    params->mesh_id_len,
 					    params->mesh_id);
=20
+	mutex_lock(&local->iflist_mtx);
 	list_add_tail_rcu(&sdata->list, &local->interfaces);
+	mutex_unlock(&local->iflist_mtx);
=20
 	if (new_dev)
 		*new_dev =3D ndev;
@@ -816,7 +835,10 @@ void ieee80211_if_remove(struct ieee8021
 {
 	ASSERT_RTNL();
=20
+	mutex_lock(&sdata->local->iflist_mtx);
 	list_del_rcu(&sdata->list);
+	mutex_unlock(&sdata->local->iflist_mtx);
+
 	synchronize_rcu();
 	unregister_netdevice(sdata->dev);
 }
@@ -832,7 +854,16 @@ void ieee80211_remove_interfaces(struct=20
 	ASSERT_RTNL();
=20
 	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
+		/*
+		 * we cannot hold the iflist_mtx across unregister_netdevice,
+		 * but we only need to hold it for list modifications to lock
+		 * out readers since we're under the RTNL here as all other
+		 * writers.
+		 */
+		mutex_lock(&local->iflist_mtx);
 		list_del(&sdata->list);
+		mutex_unlock(&local->iflist_mtx);
+
 		unregister_netdevice(sdata->dev);
 	}
 }
--- wireless-testing.orig/net/mac80211/main.c	2009-01-21 12:48:21.000000000=
 +0100
+++ wireless-testing/net/mac80211/main.c	2009-01-21 13:57:50.000000000 +010=
0
@@ -718,6 +718,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	local->hw.conf.radio_enabled =3D true;
=20
 	INIT_LIST_HEAD(&local->interfaces);
+	mutex_init(&local->iflist_mtx);
=20
 	spin_lock_init(&local->key_lock);
=20
@@ -968,6 +969,8 @@ void ieee80211_free_hw(struct ieee80211_
 {
 	struct ieee80211_local *local =3D hw_to_local(hw);
=20
+	mutex_destroy(&local->iflist_mtx);
+
 	wiphy_free(local->hw.wiphy);
 }
 EXPORT_SYMBOL(ieee80211_free_hw);
--- wireless-testing.orig/net/mac80211/util.c	2009-01-21 12:48:12.000000000=
 +0100
+++ wireless-testing/net/mac80211/util.c	2009-01-21 12:48:21.000000000 +010=
0
@@ -459,7 +459,7 @@ void ieee80211_iterate_active_interfaces
 	struct ieee80211_local *local =3D hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
=20
-	rtnl_lock();
+	mutex_lock(&local->iflist_mtx);
=20
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		switch (sdata->vif.type) {
@@ -480,7 +480,7 @@ void ieee80211_iterate_active_interfaces
 				 &sdata->vif);
 	}
=20
-	rtnl_unlock();
+	mutex_unlock(&local->iflist_mtx);
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);
=20

--=-0HXUNlbNcAnUUlI6/tGO--

--=-mrcdqHcrZUx2Q44iuqIc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJdxzrAAoJEKVg1VMiehFY9skP/RJ4xi7rKIaxY51NjmC/OlKm
3K+XeotO33j5AYa3XrC/Mw9C4Klp9HNLjJI3IdvQ5L6IyzAGpN7x5RWzVX88dlGc
uOo+5Mq44elSG3i0zwZOgO9eRAWJkudlF8DBskvsF+kogIF2TgSpGWgHHsSbd2cw
xM7U7U885qWy+lNM8UoEjbdtpZlqGxL6/3CXhaGraJUYZ2+bxGNGqolCbaesoxd5
V6A2PL+KiC928RSq3YaSxxsjMhmxEODBLyIuqT1V6o8Jp9tHqEeTlNVh4sLM7kk7
2kTA1lFkrlgC45hmETPQqOlQYYt2IAB3EeYhLKGWdR9bAgNszR5UV0/j2G0HxsiU
Wrk/2+OS18jTTWXxxwE7+j3FLmCZRkpbxbWQs9P2nyixgffYS8EEe+7GdE6VbD52
YP2hmSSUUD/fpHQoWHfzYEZokndWpOCuDupRll2XkF4jzeH+4p6z9wwio75GXQhE
qiuF3pVz3AA02Xu5pb0uX0bezO4w80CKVRZPQQLeToxGi9hl9yoc6WN6oNdUTMHz
Vnfl6BQ/z38HEkowDnsi3VEDyt8f0iCvJsyLz+FB3v1phJTEBMIEv9Ybh8ODzuOv
C1t4xZ7q19LHOuqF268atPcMayGkNj3ilsWs2PNfYurNKZWekVIBDA3NQvkBPIme
NVhuMdk8jp6YVgL30dTV
=EWdh
-----END PGP SIGNATURE-----

--=-mrcdqHcrZUx2Q44iuqIc--

