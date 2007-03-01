Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:27371 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752245AbXCAFnf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2007 00:43:35 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH 4/5] d80211: Stop virtual interfaces during scan
Date: Thu, 1 Mar 2007 00:40:09 -0500
Cc: linux-wireless@vger.kernel.org
References: <20070228203943.11473.95222.stgit@magic.sourmilk.net> <20070228203943.11473.81749.stgit@magic.sourmilk.net>
In-Reply-To: <20070228203943.11473.81749.stgit@magic.sourmilk.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3002782.u2AsKEci4Z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703010040.14598.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3002782.u2AsKEci4Z
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 28 February 2007 15:39, Michael Wu wrote:
> From: Michael Wu <flamingice@sourmilk.net>
>
> This prevents data frames from being queued on the master device if it is
> in the midst of a scan. It also makes both master and virtual interfaces
> properly set trans_start when frames are sent so the network watchdog does
> not try to reset the interfaces. tx_queue_len is left as the default on
> virtual interfaces to allow frames to be queued while the device is
> scanning.
>
And now that all STA interfaces are woken up after a scan, we also can remo=
ve=20
the scan_dev check.

=2D-

d80211: Stop virtual interfaces during scan

=46rom: Michael Wu <flamingice@sourmilk.net>

This prevents data frames from being queued on the master device if it is
in the midst of a scan. It also makes both master and virtual interfaces
properly set trans_start when frames are sent. tx_queue_len is left as the=
=20
default on virtual interfaces to allow frames to be queued while the device=
=20
is scanning.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 net/mac80211/ieee80211.c     |    5 +++--
 net/mac80211/ieee80211_sta.c |   28 +++++++++++++++++++---------
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 4d08266..52d0e1e 100644
=2D-- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -1148,6 +1148,7 @@ static int __ieee80211_tx(struct ieee802
 		ret =3D local->ops->tx(local_to_hw(local), skb, control);
 		if (ret)
 			return IEEE80211_TX_AGAIN;
+		local->mdev->trans_start =3D jiffies;
 		ieee80211_led_tx(local, 1);
 	}
 	if (tx->u.tx.extra_frag) {
@@ -1178,6 +1179,7 @@ static int __ieee80211_tx(struct ieee802
 					    control);
 			if (ret)
 				return IEEE80211_TX_FRAG_AGAIN;
+			local->mdev->trans_start =3D jiffies;
 			ieee80211_led_tx(local, 1);
 			tx->u.tx.extra_frag[i] =3D NULL;
 		}
@@ -1588,6 +1590,7 @@ static int ieee80211_subif_start_xmit(st
 	skb->nh.raw =3D skb->data + nh_pos;
 	skb->h.raw =3D skb->data + h_pos;
=20
+	dev->trans_start =3D jiffies;
 	dev_queue_xmit(skb);
=20
 	return 0;
@@ -4419,7 +4422,6 @@ void ieee80211_if_setup(struct net_devic
 	dev->get_stats =3D ieee80211_get_stats;
 	dev->open =3D ieee80211_open;
 	dev->stop =3D ieee80211_stop;
=2D	dev->tx_queue_len =3D 0;
 	dev->uninit =3D ieee80211_if_reinit;
 	dev->destructor =3D ieee80211_if_free;
 }
@@ -4434,7 +4436,6 @@ void ieee80211_if_mgmt_setup(struct net_
 	dev->stop =3D ieee80211_mgmt_stop;
 	dev->type =3D ARPHRD_IEEE80211_PRISM;
 	dev->hard_header_parse =3D header_parse_80211;
=2D	dev->tx_queue_len =3D 0;
 	dev->uninit =3D ieee80211_if_reinit;
 	dev->destructor =3D ieee80211_if_free;
 }
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 9d08a37..ce7dc28 100644
=2D-- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1918,10 +1918,7 @@ void ieee80211_sta_work(struct work_stru
 	if (!netif_running(dev))
 		return;
=20
=2D	/* TODO: scan_dev check should be removed once scan_completed wakes
=2D	 * every STA interface */
=2D	if (local->sta_scanning &&
=2D	    local->scan_dev =3D=3D dev)
+	if (local->sta_scanning)
 		return;
=20
 	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
@@ -2527,7 +2524,7 @@ void ieee80211_scan_completed(struct iee
 {
 	struct ieee80211_local *local =3D hw_to_local(hw);
 	struct net_device *dev =3D local->scan_dev;
=2D	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_sub_if_data *sdata;
 	union iwreq_data wrqu;
=20
 	printk(KERN_DEBUG "%s: scan completed\n", dev->name);
@@ -2542,15 +2539,23 @@ void ieee80211_scan_completed(struct iee
 	memset(&wrqu, 0, sizeof(wrqu));
 	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
=20
+	spin_lock_bh(&local->sub_if_lock);
+	list_for_each_entry(sdata, &local->sub_if_list, list) {
+		netif_wake_queue(sdata->dev);
+
+		if (sdata->type =3D=3D IEEE80211_IF_TYPE_STA)
+			ieee80211_sta_timer((unsigned long)&sdata->u.sta);
+	}
+	spin_unlock_bh(&local->sub_if_lock);
+
+	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->type =3D=3D IEEE80211_IF_TYPE_IBSS) {
 		struct ieee80211_if_sta *ifsta =3D &sdata->u.sta;
 		if (!ifsta->bssid_set ||
 		    (!ifsta->state =3D=3D IEEE80211_IBSS_JOINED &&
 		    !ieee80211_sta_active_ibss(dev)))
 			ieee80211_sta_find_ibss(dev, ifsta);
=2D	/* TODO: need to wake every sta interface */
=2D	} else if (sdata->type =3D=3D IEEE80211_IF_TYPE_STA)
=2D		ieee80211_sta_timer((unsigned long)&sdata->u.sta);
+	}
 }
 EXPORT_SYMBOL(ieee80211_scan_completed);
=20
@@ -2637,6 +2642,7 @@ static int ieee80211_sta_start_scan(stru
 				    u8 *ssid, size_t ssid_len)
 {
 	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata;
=20
 	if (ssid_len > IEEE80211_MAX_SSID_LEN)
 		return -EINVAL;
@@ -2680,7 +2686,11 @@ static int ieee80211_sta_start_scan(stru
 	}
=20
 	local->sta_scanning =3D 1;
=2D	/* TODO: stop TX queue? */
+
+	spin_lock_bh(&local->sub_if_lock);
+	list_for_each_entry(sdata, &local->sub_if_list, list)
+		netif_stop_queue(sdata->dev);
+	spin_unlock_bh(&local->sub_if_lock);
=20
 	if (ssid) {
 		local->scan_ssid_len =3D ssid_len;

--nextPart3002782.u2AsKEci4Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF5mc+T3Oqt9AH4aERAnBcAJ4sG5VZGczmI9nCZmoCHW/TJpntFgCfWahG
T5f0VWp9HacgZI7v3xfWve8=
=BXvF
-----END PGP SIGNATURE-----

--nextPart3002782.u2AsKEci4Z--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
