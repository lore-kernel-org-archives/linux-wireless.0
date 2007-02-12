Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:25411 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932943AbXBLDMz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 22:12:55 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] adm8211, p54, zd1211rw-d80211: Update to new statistics reporting API
Date: Sun, 11 Feb 2007 22:12:27 -0500
Cc: Jiri Benc <jbenc@suse.cz>
MIME-Version: 1.0
Message-Id: <200702112212.27326.flamingice@sourmilk.net>
Content-Type: multipart/signed;
  boundary="nextPart7669733.lR7V6j5uSm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart7669733.lR7V6j5uSm
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

adm8211, p54, zd1211rw-d80211: Update to new statistics reporting API

This patch updates adm8211, p54, and zd1211rw-d80211 to the new statistics
reporting API in d80211.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 drivers/net/wireless/d80211/adm8211/adm8211.c   |   10 +---------
 drivers/net/wireless/d80211/p54/prism54common.c |    2 +-
 drivers/net/wireless/d80211/zd1211rw/zd_mac.c   |    3 ++-
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/d80211/adm8211/adm8211.c=20
b/drivers/net/wireless/d80211/adm8211/adm8211.c
index 3bdcec3..ee8939b 100644
=2D-- a/drivers/net/wireless/d80211/adm8211/adm8211.c
+++ b/drivers/net/wireless/d80211/adm8211/adm8211.c
@@ -564,14 +564,6 @@ static void adm8211_interrupt_rci(struct
 			if (dev->flags & IFF_PROMISC)
 				skb_trim(skb, skb->len - FCS_LEN);
=20
=2D
=2D/* FIXME: The following set of assignments supply additional data for=20
wireless statistics. The
=2D	  necessary quantities are (1) the "noise" value in dBm, and (2)=20
the "signal" value in dBm.
=2D	  The present code supplies dummy values for these quantities. */
=2D
=2D			rx_status.noise =3D -85;   /* FIXME */
=2D			rx_status.signal =3D rx_status.ssi - ADM8211_RX_MAX_SSI; /* FIXME */
=2D
 			ieee80211_rx_irqsafe(dev, skb, &rx_status);
 		}
=20
@@ -2033,7 +2025,7 @@ static int __devinit adm8211_probe(struc
 	// however, IEEE80211_HW_RX_INCLUDES_FCS in promisc mode
=20
 	dev->channel_change_time =3D 1000;
=2D	dev->maxssi =3D ADM8211_RX_MAX_SSI;// FIXME - This is an approximation
+	dev->max_rssi =3D ADM8211_RX_MAX_SSI;// FIXME - This is an approximation
=20
 	priv->modes[0].mode =3D MODE_IEEE80211B;
 	/* channel info filled in by adm8211_read_eeprom */
diff --git a/drivers/net/wireless/d80211/p54/prism54common.c=20
b/drivers/net/wireless/d80211/p54/prism54common.c
index fd4ea5d..848e450 100644
=2D-- a/drivers/net/wireless/d80211/p54/prism54common.c
+++ b/drivers/net/wireless/d80211/p54/prism54common.c
@@ -773,7 +773,7 @@ struct ieee80211_hw *p54_init_common(siz
 		    IEEE80211_HW_DATA_NULLFUNC_ACK; /* TODO: check */
 		    /* IEEE80211_HW_MONITOR_DURING_OPER FIXME: check */
 	dev->channel_change_time =3D 1000;	/* TODO: find actual value */
=2D	dev->maxssi =3D 100; // just to avoid dividing by zero
+	dev->max_rssi =3D 100;
=20
 	dev->queues =3D 1;
 	dev->extra_tx_headroom =3D sizeof(struct p54_control_hdr) + 4 +
diff --git a/drivers/net/wireless/d80211/zd1211rw/zd_mac.c=20
b/drivers/net/wireless/d80211/zd1211rw/zd_mac.c
index c3144d5..cd7d135 100644
=2D-- a/drivers/net/wireless/d80211/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/d80211/zd1211rw/zd_mac.c
@@ -607,7 +607,8 @@ struct ieee80211_hw *zd_mac_alloc(struct
=20
 	dev->flags =3D IEEE80211_HW_RX_INCLUDES_FCS |
 		     IEEE80211_HW_WEP_INCLUDE_IV;
=2D	dev->maxssi =3D 100;
+	dev->max_rssi =3D 100;
+	dev->max_signal =3D 100;
=20
 	dev->queues =3D 1;
 	dev->extra_tx_headroom =3D sizeof(struct zd_ctrlset);

--nextPart7669733.lR7V6j5uSm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFz9sbT3Oqt9AH4aERAjsDAJ9TqFTStFrd/Gu2e2pjHZNwFG4ShQCfeFVQ
bdVKYU8Y1+3ZrvvrF7VUe9U=
=tOR7
-----END PGP SIGNATURE-----

--nextPart7669733.lR7V6j5uSm--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
