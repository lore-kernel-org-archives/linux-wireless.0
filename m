Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:22790 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbXIUVHk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 17:07:40 -0400
Received: by an-out-0708.google.com with SMTP id d31so151206and
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2007 14:07:39 -0700 (PDT)
Date: Fri, 21 Sep 2007 17:08:34 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Daniel Drake <dsd@gentoo.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 5/5] Wireless: add wireless configfs module
Message-ID: <20070921210834.GI31768@pogo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PpAOPzA3dXsRhoo+"
In-Reply-To: <20070921204606.GD31768@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--PpAOPzA3dXsRhoo+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This patch adds a wireless configfs module. Currently we only add
support for changing the central regulatory domain. The idea is not to
replace nl80211 interface but to supplement it and also to give home
for a place for configuring wireless kobjects. We can move add_interface /
remove_interface from sysfs to configfs, for example.

Example usage of using wireles configfs:

mkdir /config/

modprobe configfs_wireless
mount -t configfs none /config
echo US > /config/wireless/country
dmesg -c

You will see:

Userspace changed regulatory domain
ieee80211_regdomains: regulatory domain FCC1A created
Regulatory Domain:      FCC1A   Regulatory Domain ID:   0x10
        IEEE 802.11g    2GHz    ISM subband
        max_ir_ptmp:    30 dBm  max_ir_ptp:     30 dBm
        max_eirp_ptmp:  36 dBm  max_eirp_ptp:   255 dBm
        max_antenna_gain:       6 dBi
        Environment capability: Indoor & Outdoor
                Channel Freq (MHz)
                1       2412
                2       2417
                3       2422
                4       2427
                5       2432
                6       2437
                7       2442
                8       2447
                9       2452
                10      2457
                11      2462
---
 net/wireless/Kconfig  |   11 +++++++++++
 net/wireless/Makefile |    1 +
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 0505347..59e47ce 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -15,6 +15,17 @@ config NL80211
=20
          If unsure, say Y.
=20
+config CONFIGFS_WIRELESS
+	depends CFG80211 && IEEE80211_REGDOMAINS
+	tristate "Configfs interface for configuring central wireless settings"
+	---help---
+	 You can configure central wireless settings through this subsystem.
+	 It currently only has an ISO3166-1 alpha2 country regulatory domain
+	 settings used to define frequency and power regulatory restrictions
+	 for all wireless cards.
+	=20
+	 If unsure, you can safely say Y.
+
 config IEEE80211_REGDOMAINS
 	tristate "Central IEEE 802.11 regulatory domain agent"
 	select ISO3166_1
diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index 74c1059..b3f5daa 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_WIRELESS_EXT) +=3D wext.o
 obj-$(CONFIG_CFG80211) +=3D cfg80211.o
+obj-$(CONFIG_CONFIGFS_WIRELESS) +=3D configfs_wireless.o
=20
 cfg80211-y +=3D core.o sysfs.o radiotap.o
 cfg80211-$(CONFIG_NL80211) +=3D nl80211.o
--=20
1.5.2.4


--PpAOPzA3dXsRhoo+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG9DLSat1JN+IKUl4RAuOQAJ42QU7OW1CQfHtUAPVQAQY6v6krwgCgjdxV
qkdo3E/DKU1FxA2K73AGvLI=
=51Ia
-----END PGP SIGNATURE-----

--PpAOPzA3dXsRhoo+--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
