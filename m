Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:61934 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030311AbXBRFcD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Feb 2007 00:32:03 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: [PATCH] d80211: Allow drivers to configure default regulatory domain
Date: Sun, 18 Feb 2007 00:31:33 -0500
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6777790.CFYePYjXNe";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702180031.38710.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart6777790.CFYePYjXNe
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

d80211: Allow drivers to configure default regulatory domain

This patch allows drivers to configure the default set of channels if the
device reports its default regulatory domain.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 include/net/d80211.h   |    7 ++++++-
 net/d80211/ieee80211.c |    5 +++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/net/d80211.h b/include/net/d80211.h
index 25a4dca..e0180ec 100644
=2D-- a/include/net/d80211.h
+++ b/include/net/d80211.h
@@ -54,7 +54,9 @@
  * freq, and val fields. Other fields will be filled in by 80211.o based on
  * hostapd information and low-level driver does not need to use them. The
  * limits for each channel will be provided in 'struct ieee80211_conf' when
=2D * configuring the low-level driver with hw->config callback. */
+ * configuring the low-level driver with hw->config callback. If a device =
has
+ * a default regulatory domain, IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED=
=20
can
+ * be set to let the driver configure all fields. */
 struct ieee80211_channel {
 	short chan; /* channel number (IEEE 802.11) */
 	short freq; /* frequency in MHz */
@@ -532,6 +534,9 @@ struct ieee80211_hw {
 	/* Do TKIP phase1 and phase2 key mixing in stack and send the generated
 	 * per-packet RC4 key with each TX frame when doing hwcrypto */
 #define IEEE80211_HW_TKIP_REQ_PHASE2_KEY (1<<14)
+	/* Channels are already configured to the default regulatory domain
+	 * specified in the device's EEPROM */
+#define IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED (1<<15)
=20
 	u32 flags;			/* hardware flags defined above */
=20
diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
index 0e5f23f..5af42aa 100644
=2D-- a/net/d80211/ieee80211.c
+++ b/net/d80211/ieee80211.c
@@ -4652,6 +4652,9 @@ int ieee80211_register_hw(struct ieee802
 	memcpy(local->mdev->dev_addr, local->hw.perm_addr, ETH_ALEN);
 	SET_NETDEV_DEV(local->mdev, local->hw.dev);
=20
+	if (!(hw->flags & IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED))
+		ieee80211_init_client(local->mdev);
+
 	result =3D register_netdevice(local->mdev);
 	if (result < 0) {
 		rtnl_unlock();
@@ -4746,8 +4749,6 @@ int ieee80211_register_hwmode(struct iee
 		ieee80211_prepare_rates(local);
 	}
=20
=2D	ieee80211_init_client(local->mdev);
=2D
 	return 0;
 }
 EXPORT_SYMBOL(ieee80211_register_hwmode);

--nextPart6777790.CFYePYjXNe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF1+S6T3Oqt9AH4aERAlOHAKCxKTptQxFPMQSOsZgSZctyEClalwCgvRBb
X0Km41ICsSxfvmpGTAKUeao=
=cjA5
-----END PGP SIGNATURE-----

--nextPart6777790.CFYePYjXNe--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
