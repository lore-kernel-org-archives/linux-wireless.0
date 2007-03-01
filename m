Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:54514 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932435AbXCACOu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 21:14:50 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] d80211: Remove tx_timeout callback
Date: Wed, 28 Feb 2007 21:14:21 -0500
Cc: Jiri Benc <jbenc@suse.cz>
References: <20070228203943.11473.95222.stgit@magic.sourmilk.net> <20070228203943.11473.91707.stgit@magic.sourmilk.net>
In-Reply-To: <20070228203943.11473.91707.stgit@magic.sourmilk.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5146967.yqtsucbxxm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702282114.26385.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart5146967.yqtsucbxxm
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 28 February 2007 15:39, Michael Wu wrote:
> This prevents drivers from crashing if there is a TX timeout and the reset
> callback isn't implemented.
>
Actually, I don't think we should bother setting the TX timeout callback at=
=20
all.

=2D-

d80211: Remove tx_timeout callback

=46rom: Michael Wu <flamingice@sourmilk.net>

This never worked in the first place and we can't use the network watchdog
anyway since that checks if the queue is stopped, but wireless devices can
have many queues. TX timeouts on virtual interfaces don't really make sense
either since they can't stall.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 net/mac80211/ieee80211.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index bbdf928..cdc8df4 100644
=2D-- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -2078,19 +2078,6 @@ static int ieee80211_change_mtu_apdev(st
 }
=20
=20
=2Dstatic void ieee80211_tx_timeout(struct net_device *dev)
=2D{
=2D	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
=2D
=2D	printk(KERN_WARNING "%s: resetting interface.\n", dev->name);
=2D
=2D	if (local->ops->reset(local_to_hw(local)))
=2D		printk(KERN_ERR "%s: failed to reset interface.\n", dev->name);
=2D	else
=2D		netif_wake_queue(dev);
=2D}
=2D
=2D
 static int ieee80211_set_mac_address(struct net_device *dev, void *addr)
 {
 	struct sockaddr *a =3D addr;
@@ -4425,7 +4412,6 @@ void ieee80211_if_setup(struct net_devic
 	dev->set_mac_address =3D ieee80211_set_mac_address;
 	dev->set_multicast_list =3D ieee80211_set_multicast_list;
 	dev->change_mtu =3D ieee80211_change_mtu;
=2D	dev->tx_timeout =3D ieee80211_tx_timeout;
 	dev->get_stats =3D ieee80211_get_stats;
 	dev->open =3D ieee80211_open;
 	dev->stop =3D ieee80211_stop;
@@ -4593,7 +4579,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	mdev->wireless_handlers =3D &ieee80211_iw_master_handler_def;
 	mdev->do_ioctl =3D ieee80211_ioctl;
 	mdev->change_mtu =3D ieee80211_change_mtu;
=2D	mdev->tx_timeout =3D ieee80211_tx_timeout;
 	mdev->get_stats =3D ieee80211_get_stats;
 	mdev->open =3D ieee80211_master_open;
 	mdev->stop =3D ieee80211_master_stop;

--nextPart5146967.yqtsucbxxm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF5jcCT3Oqt9AH4aERAonPAKC4wL3Y8zXhLUKY27whBi4lBRR6mwCbBwEF
TJeVoaUcFjjyz/j8hF1iwB8=
=yDrm
-----END PGP SIGNATURE-----

--nextPart5146967.yqtsucbxxm--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
