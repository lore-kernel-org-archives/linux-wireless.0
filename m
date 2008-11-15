Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx71.mail.ru ([194.67.23.4]:56652 "EHLO mx71.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbYKOPbf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2008 10:31:35 -0500
Received: from [91.77.236.124] (port=20651 helo=cooker.net)
	by mx71.mail.ru with asmtp
	id 1L1N7V-0000UI-00
	for linux-wireless@vger.kernel.org; Sat, 15 Nov 2008 18:31:33 +0300
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] wireless: sysfs was displaying different values for level and noise than procfs
Date: Sat, 15 Nov 2008 18:31:25 +0300
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1244390.OTpEg25ux4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200811151831.26403.arvidjaar@mail.ru> (sfid-20081115_163216_301880_ADFD4584)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1244390.OTpEg25ux4
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Subject: [PATCH] wireless: sysfs was displaying different values for level =
and noise than procfs
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

/proc/net/wireless asjusts display of signal and noise level depending on
whether units are percentage or dBm. Use the same format in sysfs. This
makes it easy to know unit - below zero is dBm, above zero is percent.

Before:
{pts/1}% cat /sys/class/net/eth1/wireless/level
203
{pts/1}% cat /sys/class/net/eth1/wireless/noise
166

After:
{pts/1}% cat /sys/class/net/eth1/wireless/level
=2D48
{pts/1}% cat /sys/class/net/eth1/wireless/noise
=2D91

for the following iwconfig output:
eth1      IEEE 802.11b  ESSID:"Home, sweet home"  Nickname:"cooker"
	[...]
          Link Quality=3D54/92  Signal level=3D-48 dBm  Noise level=3D-91 d=
Bm

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

 net/core/net-sysfs.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)


diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 92d6b94..24c67bc 100644
=2D-- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -389,10 +389,23 @@ static ssize_t show_iw_##name(struct device *d,				\
 }									\
 static DEVICE_ATTR(name, S_IRUGO, show_iw_##name, NULL)
=20
+#define WIRELESS_SHOW_LEVEL(name, field, format_string)			\
+static ssize_t format_iw_##name(const struct iw_statistics *iw, char *buf)=
 \
+{									\
+	return sprintf(buf, format_string, (__s32)iw->field -		\
+			((iw->qual.updated & IW_QUAL_DBM) ? 0x100 : 0)); \
+}									\
+static ssize_t show_iw_##name(struct device *d,				\
+			      struct device_attribute *attr, char *buf)	\
+{									\
+	return wireless_show(d, buf, format_iw_##name);			\
+}									\
+static DEVICE_ATTR(name, S_IRUGO, show_iw_##name, NULL)
+
 WIRELESS_SHOW(status, status, fmt_hex);
 WIRELESS_SHOW(link, qual.qual, fmt_dec);
=2DWIRELESS_SHOW(level, qual.level, fmt_dec);
=2DWIRELESS_SHOW(noise, qual.noise, fmt_dec);
+WIRELESS_SHOW_LEVEL(level, qual.level, fmt_dec);
+WIRELESS_SHOW_LEVEL(noise, qual.noise, fmt_dec);
 WIRELESS_SHOW(nwid, discard.nwid, fmt_dec);
 WIRELESS_SHOW(crypt, discard.code, fmt_dec);
 WIRELESS_SHOW(fragment, discard.fragment, fmt_dec);

--nextPart1244390.OTpEg25ux4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkke604ACgkQR6LMutpd94wPAwCg0wh5fyT0XxUpA33tndedL9Hp
uVwAniyFX4B00XV/D6e24R5LV9Z4Oi38
=iVOt
-----END PGP SIGNATURE-----

--nextPart1244390.OTpEg25ux4--
