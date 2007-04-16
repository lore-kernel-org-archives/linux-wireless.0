Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:38904 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754112AbXDPARf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2007 20:17:35 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: [PATCH] mac80211: remove ieee80211_netif_oper from mac80211.h
Date: Sun, 15 Apr 2007 20:14:24 -0400
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1286675.NvqlDIlJQ0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704152014.29691.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1286675.NvqlDIlJQ0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

mac80211: remove ieee80211_netif_oper from mac80211.h

=46rom: Michael Wu <flamingice@sourmilk.net>

rt2x00 was the last user of ieee80211_netif_oper outside of mac80211.
ieee80211_netif_oper can now be removed from mac80211.h

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 include/net/mac80211.h     |   11 -----------
 net/mac80211/ieee80211.c   |    1 -
 net/mac80211/ieee80211_i.h |    6 ++++++
 3 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2ec1d04..0c7e088 100644
=2D-- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -975,17 +975,6 @@ int ieee80211_get_hdrlen_from_skb(const struct sk_buff=
 *skb);
 /* Like ieee80211_get_hdrlen_from_skb() but takes a FC in CPU order. */
 int ieee80211_get_hdrlen(u16 fc);
=20
=2D/* Function for net interface operation. IEEE 802.11 may use multiple ke=
rnel
=2D * netdevices for each hardware device. The low-level driver does not "s=
ee"
=2D * these interfaces, so it should use this function to perform netif
=2D * operations on all interface. */
=2D/* This function is deprecated. */
=2Dtypedef enum {
=2D	NETIF_ATTACH, NETIF_DETACH, NETIF_START, NETIF_STOP, NETIF_WAKE,
=2D	NETIF_IS_STOPPED, NETIF_UPDATE_TX_START
=2D} Netif_Oper;
=2Dint ieee80211_netif_oper(struct ieee80211_hw *hw, Netif_Oper op);
=2D
 /**
  * ieee80211_wake_queue - wake specific queue
  * @hw: pointer as obtained from ieee80211_alloc_hw().
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 439246a..fae3666 100644
=2D-- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -5069,7 +5069,6 @@ int ieee80211_netif_oper(struct ieee80211_hw *hw, Net=
if_Oper op)
=20
 	return 0;
 }
=2DEXPORT_SYMBOL(ieee80211_netif_oper);
=20
 void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
 {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3205bfe..2bf26cf 100644
=2D-- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -761,6 +761,12 @@ void ieee80211_if_mgmt_setup(struct net_device *dev);
 int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
 				 const char *name);
 struct net_device_stats *ieee80211_dev_stats(struct net_device *dev);
+/* This function is deprecated. */
+typedef enum {
+	NETIF_ATTACH, NETIF_DETACH, NETIF_START, NETIF_STOP, NETIF_WAKE,
+	NETIF_IS_STOPPED, NETIF_UPDATE_TX_START
+} Netif_Oper;
+int ieee80211_netif_oper(struct ieee80211_hw *hw, Netif_Oper op);
=20
 /* ieee80211_ioctl.c */
 int ieee80211_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);

--nextPart1286675.NvqlDIlJQ0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGIr/lT3Oqt9AH4aERAvl2AJ0a+klgvDUzEJbVBveirDHPdOSVFgCfSUZR
vXrq3/wC3js5lkqFS0PUixI=
=cME4
-----END PGP SIGNATURE-----

--nextPart1286675.NvqlDIlJQ0--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
