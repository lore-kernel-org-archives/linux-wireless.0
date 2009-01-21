Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41185 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364AbZAUMoQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 07:44:16 -0500
Subject: Re: [PATCH] mac80211: Add capability to enable/disable beaconing
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@Atheros.com
In-Reply-To: <18805.62728.34610.424793@localhost.localdomain> (sfid-20090120_170225_636861_F4C348AF)
References: <18805.33791.193195.755178@gargle.gargle.HOWL>
	 <1232448779.20158.4.camel@johannes.local>
	 <18805.62728.34610.424793@localhost.localdomain>
	 (sfid-20090120_170225_636861_F4C348AF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DzEb9vrV5OhN6vRrutwG"
Date: Wed, 21 Jan 2009 12:45:50 +0100
Message-Id: <1232538350.4358.5.camel@johannes.local> (sfid-20090121_134422_074044_459D7E1F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DzEb9vrV5OhN6vRrutwG
Content-Type: multipart/mixed; boundary="=-KfWZllsBGcNqhKXlV8B/"


--=-KfWZllsBGcNqhKXlV8B/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-20 at 21:30 +0530, Sujith wrote:
> Johannes Berg wrote:
> > cOn Tue, 2009-01-20 at 13:27 +0530, Sujith wrote:
> > > This patch adds a flag to notify drivers to start and
> > > stop beaconing when needed, for example, during a scan run.
> >=20
> >=20
> > > +	if ((changed & IEEE80211_IFCC_BEACON) &&
> > > +	    (sdata->vif.type =3D=3D NL80211_IFTYPE_AP ||
> > > +	     sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC ||
> > > +	     sdata->vif.type =3D=3D NL80211_IFTYPE_MESH_POINT)) {
> > > +		if (local->sw_scanning || local->hw_scanning)
> > > +			conf.enable_beacon =3D false;
> > > +		else
> > > +			conf.enable_beacon =3D true;
> > > +	}
> > > +
> >=20
> > You really just want to do the minimal thing, right? :)
>=20
> Oh, absolutely :)

:)

> > That won't work when userspace disables the beacon by removing it, for
> > instance, right now drivers won't know when hostapd removed the beacon
> > except that ieee80211_beacon_get will start returning 0... Also, I thin=
k
> > a separate change flag would be appropriate, sometimes we might just
> > re-enable the beacon without having changed it, after scanning?
>=20
> Ok, how about this ?

How about this? Untested still though.

johannes

--=-KfWZllsBGcNqhKXlV8B/
Content-Disposition: attachment; filename=015-mac80211-add-iflock.patch
Content-Type: message/rfc822; name=015-mac80211-add-iflock.patch

Subject: mac80211: add interface list lock
Content-Transfer-Encoding: quoted-printable
From: 
Date: Wed, 21 Jan 2009 12:45:47 +0100
Message-Id: <1232538347.4358.3.camel@johannes.local>
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
 net/mac80211/iface.c       |   24 ++++++++++++++++++++++++
 net/mac80211/main.c        |    3 +++
 net/mac80211/util.c        |    4 ++--
 4 files changed, 31 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-01-21 12:19:47.00=
0000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-01-21 12:22:02.0000000=
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
--- wireless-testing.orig/net/mac80211/iface.c	2009-01-21 12:20:40.00000000=
0 +0100
+++ wireless-testing/net/mac80211/iface.c	2009-01-21 12:28:15.000000000 +01=
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
@@ -831,8 +853,10 @@ void ieee80211_remove_interfaces(struct=20
=20
 	ASSERT_RTNL();
=20
+	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
 		list_del(&sdata->list);
 		unregister_netdevice(sdata->dev);
 	}
+	mutex_unlock(&local->iflist_mtx);
 }
--- wireless-testing.orig/net/mac80211/main.c	2009-01-21 12:26:36.000000000=
 +0100
+++ wireless-testing/net/mac80211/main.c	2009-01-21 12:27:19.000000000 +010=
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
--- wireless-testing.orig/net/mac80211/util.c	2009-01-21 12:28:36.000000000=
 +0100
+++ wireless-testing/net/mac80211/util.c	2009-01-21 12:29:01.000000000 +010=
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

--=-KfWZllsBGcNqhKXlV8B/
Content-Disposition: attachment; filename=016-mac80211-beacon-endis.patch
Content-Type: message/rfc822; name=016-mac80211-beacon-endis.patch

Subject: mac80211: Add capability to enable/disable beaconing
Content-Transfer-Encoding: quoted-printable
From: 
Date: Wed, 21 Jan 2009 12:45:47 +0100
Message-Id: <1232538347.4358.4.camel@johannes.local>
Mime-Version: 1.0

This patch adds a flag to notify drivers to start and
stop beaconing when needed, for example, during a scan run.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    9 +++++++--
 net/mac80211/cfg.c     |    5 +++--
 net/mac80211/main.c    |   42 +++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/mesh.c    |    3 ++-
 net/mac80211/mlme.c    |    3 ++-
 net/mac80211/scan.c    |   18 +++++++++++-------
 6 files changed, 66 insertions(+), 14 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-01-21 12:44:02.000000=
000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-01-21 12:44:16.000000000 +=
0100
@@ -626,10 +626,12 @@ struct ieee80211_if_init_conf {
  * @IEEE80211_IFCC_BSSID: The BSSID changed.
  * @IEEE80211_IFCC_BEACON: The beacon for this interface changed
  *	(currently AP and MESH only), use ieee80211_beacon_get().
+ * @IEEE80211_IFCC_BEACON_ENABLED: The enable_beacon value changed.
  */
 enum ieee80211_if_conf_change {
-	IEEE80211_IFCC_BSSID	=3D BIT(0),
-	IEEE80211_IFCC_BEACON	=3D BIT(1),
+	IEEE80211_IFCC_BSSID		=3D BIT(0),
+	IEEE80211_IFCC_BEACON		=3D BIT(1),
+	IEEE80211_IFCC_BEACON_ENABLED	=3D BIT(2),
 };
=20
 /**
@@ -637,6 +639,8 @@ enum ieee80211_if_conf_change {
  *
  * @changed: parameters that have changed, see &enum ieee80211_if_conf_cha=
nge.
  * @bssid: BSSID of the network we are associated to/creating.
+ * @enable_beacon: Indicates whether beacons can be sent.
+ *	This is valid only for AP/IBSS/MESH modes.
  *
  * This structure is passed to the config_interface() callback of
  * &struct ieee80211_hw.
@@ -644,6 +648,7 @@ enum ieee80211_if_conf_change {
 struct ieee80211_if_conf {
 	u32 changed;
 	const u8 *bssid;
+	bool enable_beacon;
 };
=20
 /**
--- wireless-testing.orig/net/mac80211/main.c	2009-01-21 12:44:04.000000000=
 +0100
+++ wireless-testing/net/mac80211/main.c	2009-01-21 12:44:16.000000000 +010=
0
@@ -168,7 +168,6 @@ int ieee80211_if_config(struct ieee80211
 		return 0;
=20
 	memset(&conf, 0, sizeof(conf));
-	conf.changed =3D changed;
=20
 	if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION ||
 	    sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC)
@@ -183,9 +182,50 @@ int ieee80211_if_config(struct ieee80211
 		return -EINVAL;
 	}
=20
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
+		break;
+	default:
+		/* do not warn to simplify caller in scan.c */
+		changed &=3D ~IEEE80211_IFCC_BEACON_ENABLED;
+		if (WARN_ON(changed & IEEE80211_IFCC_BEACON))
+			return -EINVAL;
+		changed &=3D ~IEEE80211_IFCC_BEACON;
+		break;
+	}
+
+	if (changed & IEEE80211_IFCC_BEACON_ENABLED) {
+		if (local->sw_scanning) {
+			conf.enable_beacon =3D false;
+		} else {
+			/*
+			 * Beacon should be enabled, but AP mode must
+			 * check whether there is a beacon configured.
+			 */
+			switch (sdata->vif.type) {
+			case NL80211_IFTYPE_AP:
+				conf.enable_beacon =3D
+					!!rcu_dereference(sdata->u.ap.beacon);
+				break;
+			case NL80211_IFTYPE_ADHOC:
+			case NL80211_IFTYPE_MESH_POINT:
+				conf.enable_beacon =3D true;
+				break;
+			default:
+				/* not reached */
+				WARN_ON(1);
+				break;
+			}
+		}
+	}
+
 	if (WARN_ON(!conf.bssid && (changed & IEEE80211_IFCC_BSSID)))
 		return -EINVAL;
=20
+	conf.changed =3D changed;
+
 	return local->ops->config_interface(local_to_hw(local),
 					    &sdata->vif, &conf);
 }
--- wireless-testing.orig/net/mac80211/scan.c	2009-01-21 12:43:32.000000000=
 +0100
+++ wireless-testing/net/mac80211/scan.c	2009-01-21 12:44:16.000000000 +010=
0
@@ -20,6 +20,7 @@
=20
 #include <linux/wireless.h>
 #include <linux/if_arp.h>
+#include <linux/rtnetlink.h>
 #include <net/mac80211.h>
 #include <net/iw_handler.h>
=20
@@ -472,8 +473,8 @@ void ieee80211_scan_completed(struct iee
 	netif_addr_unlock(local->mdev);
 	netif_tx_unlock_bh(local->mdev);
=20
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
 		/* Tell AP we're back */
 		if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION) {
 			if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
@@ -482,8 +483,10 @@ void ieee80211_scan_completed(struct iee
 			}
 		} else
 			netif_tx_wake_all_queues(sdata->dev);
+
+		ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON_ENABLED);
 	}
-	rcu_read_unlock();
+	mutex_unlock(&local->iflist_mtx);
=20
  done:
 	ieee80211_mlme_notify_scan_completed(local);
@@ -491,7 +494,6 @@ void ieee80211_scan_completed(struct iee
 }
 EXPORT_SYMBOL(ieee80211_scan_completed);
=20
-
 void ieee80211_scan_work(struct work_struct *work)
 {
 	struct ieee80211_local *local =3D
@@ -633,8 +635,10 @@ int ieee80211_start_scan(struct ieee8021
=20
 	local->sw_scanning =3D true;
=20
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON_ENABLED);
+
 		if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION) {
 			if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
 				netif_tx_stop_all_queues(sdata->dev);
@@ -643,7 +647,7 @@ int ieee80211_start_scan(struct ieee8021
 		} else
 			netif_tx_stop_all_queues(sdata->dev);
 	}
-	rcu_read_unlock();
+	mutex_unlock(&local->iflist_mtx);
=20
 	if (ssid) {
 		local->scan_ssid_len =3D ssid_len;
--- wireless-testing.orig/net/mac80211/mesh.c	2009-01-21 12:43:32.000000000=
 +0100
+++ wireless-testing/net/mac80211/mesh.c	2009-01-21 12:44:16.000000000 +010=
0
@@ -442,7 +442,8 @@ void ieee80211_start_mesh(struct ieee802
=20
 	ifmsh->housekeeping =3D true;
 	queue_work(local->hw.workqueue, &ifmsh->work);
-	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
+	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON |
+				   IEEE80211_IFCC_BEACON_ENABLED);
 }
=20
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
--- wireless-testing.orig/net/mac80211/mlme.c	2009-01-21 12:43:32.000000000=
 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-01-21 12:44:16.000000000 +010=
0
@@ -1598,7 +1598,8 @@ static int ieee80211_sta_join_ibss(struc
=20
 	ifsta->probe_resp =3D skb;
=20
-	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
+	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON |
+				   IEEE80211_IFCC_BEACON_ENABLED);
=20
=20
 	rates =3D 0;
--- wireless-testing.orig/net/mac80211/cfg.c	2009-01-21 12:43:32.000000000 =
+0100
+++ wireless-testing/net/mac80211/cfg.c	2009-01-21 12:44:16.000000000 +0100
@@ -523,7 +523,8 @@ static int ieee80211_config_beacon(struc
=20
 	kfree(old);
=20
-	return ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
+	return ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON |
+					  IEEE80211_IFCC_BEACON_ENABLED);
 }
=20
 static int ieee80211_add_beacon(struct wiphy *wiphy, struct net_device *de=
v,
@@ -583,7 +584,7 @@ static int ieee80211_del_beacon(struct w
 	synchronize_rcu();
 	kfree(old);
=20
-	return ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
+	return ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON_ENABLED);
 }
=20
 /* Layer 2 Update frame (802.2 Type 1 LLC XID Update response) */

--=-KfWZllsBGcNqhKXlV8B/--

--=-DzEb9vrV5OhN6vRrutwG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJdwrrAAoJEKVg1VMiehFYugIP/2iGUfncATfOzXAOc+xsM8qZ
056G6e4VHW+YUS0RRcMuw64Gp4RMeW21765HUwJ5Tzdw3fbw7MlkLv/v8xu1eHT0
iosmlWwrE5amUOR77miIqk57eu4sEnGoQwQ0cvWRybm0JTCngC5jKTJo53IxXZT3
Hit2/7EEp8caPeWgl85jZlJTu+m5Qq/3xN2uIxBm3znkUVxM6oAYcDAzVWZYCIJB
t+yfx4hRJw5idX0/dtZLw1wHca7be9CUzii75VJMLcr9tvDo6zvW6o/qi890Ba6O
6XUXMlIrecJyxHX9yeiV/mxBgYnThxGjgW0cKXJA1yijg6OGev0JLbawlOAIro6g
uTG0nb5og6Z+KvVVglB7ZMkkDPiQ5oc2fp2wmE3JAeOxOrBGCo7AxGvXwnSsgB3w
oN/oqxqC1eDetYQm+eYoE62vuS6zuM3KGate4a4PKnpVcaqw/gCxy6QzE/p/ZUAA
VNUcfAsfVq3pd/9fkUvFtiA1Syhhb3Sf+Nf8zoLcRrnFJK6m9064hHjkdAbTv/x7
esokjVIoChwEYxE7qshnO4d3Lfok5d5+ypXZLf1GST3fzTnfZe+jUtQYXYQSH16B
VN+/71n1ZyHVmRchns0igL5cUYS74j+vEg6yh77GZ00q2pS375ZrcAIgDO/ljdxE
iCT/sdmZP+f4PEPgXRdR
=Q6aO
-----END PGP SIGNATURE-----

--=-DzEb9vrV5OhN6vRrutwG--

