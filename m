Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:49376 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932436AbXBFPeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Feb 2007 10:34:18 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: d80211: Fix TKIP key type
Date: Tue, 6 Feb 2007 10:33:41 -0500
Cc: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <200702031832.48505.mb@bu3sch.de> <20070205221957.3c9003b5@griffin.suse.cz>
In-Reply-To: <20070205221957.3c9003b5@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1460165.MepRMx00HK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702061033.50134.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1460165.MepRMx00HK
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

d80211: Fix TKIP key type

Avoid the messy typecasting and let drivers handle byteordering.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>

diff --git a/include/net/d80211.h b/include/net/d80211.h
index 65a5d36..0bd6b15 100644
=2D-- a/include/net/d80211.h
+++ b/include/net/d80211.h
@@ -202,7 +202,10 @@ struct ieee80211_tx_control {
 				 * hw->set_key() */
 	u8 icv_len;		/* length of the ICV/MIC field in octets */
 	u8 iv_len;		/* length of the IV field in octets */
=2D	u8 tkip_key[16];	/* generated phase2/phase1 key for hw TKIP */
+	union {
+		u16 phase1[5];
+		u8 phase2[16];
+	} tkip;			/* generated phase2/phase1 key for hw TKIP */
 	u8 queue;		/* hardware queue to use for this frame;
 				 * 0 =3D highest, hw->queues-1 =3D lowest */
 	u8 sw_retry_attempt;	/* number of times hw has tried to
diff --git a/net/d80211/ieee80211_i.h b/net/d80211/ieee80211_i.h
diff --git a/net/d80211/ieee80211_ioctl.c b/net/d80211/ieee80211_ioctl.c
diff --git a/net/d80211/ieee80211_sta.c b/net/d80211/ieee80211_sta.c
diff --git a/net/d80211/wpa.c b/net/d80211/wpa.c
index 7b64abf..d5ef61a 100644
=2D-- a/net/d80211/wpa.c
+++ b/net/d80211/wpa.c
@@ -344,12 +344,12 @@ skip_iv_inc:
=20
 		if (flags & IEEE80211_HW_TKIP_REQ_PHASE2_KEY)
 			ieee80211_tkip_gen_rc4key(key, hdr->addr2,
=2D						  tx->u.tx.control->tkip_key);
+						  tx->u.tx.control->tkip.phase2);
 		else if (flags & IEEE80211_HW_TKIP_REQ_PHASE1_KEY) {
 			if (key->u.tkip.iv16 =3D=3D 0 ||
 			    !key->u.tkip.tx_initialized) {
 				ieee80211_tkip_gen_phase1key(key, hdr->addr2,
=2D					    (u16 *)tx->u.tx.control->tkip_key);
+					    tx->u.tx.control->tkip.phase1);
 				key->u.tkip.tx_initialized =3D 1;
 				tx->u.tx.control->flags |=3D
 					    IEEE80211_TXCTL_TKIP_NEW_PHASE1_KEY;

--nextPart1460165.MepRMx00HK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFyJ/eT3Oqt9AH4aERAhn1AJ4vYihz8ZnCWGp2sGMCEtA5631rFACfUDFs
nhmxbKtrq2xD3l1ZczPOmS0=
=Kd4r
-----END PGP SIGNATURE-----

--nextPart1460165.MepRMx00HK--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
