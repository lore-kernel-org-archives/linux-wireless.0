Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41718 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbXL1Vus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2007 16:50:48 -0500
Received: from [91.5.69.40] (helo=[10.0.0.4])
	by sipsolutions.net with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.68)
	(envelope-from <johannes@sipsolutions.net>)
	id 1J8N6L-000262-JH
	for linux-wireless@vger.kernel.org; Fri, 28 Dec 2007 21:50:45 +0000
Subject: cfg80211 API for channels/bitrates, mac80211 and driver conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5/iDVZTHeS1s3V0isCBT"
Date: Fri, 28 Dec 2007 22:50:33 +0100
Message-Id: <1198878633.4172.19.camel@johannes.berg> (sfid-20071228_215055_809084_279B51F7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5/iDVZTHeS1s3V0isCBT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This patch creates new cfg80211 wiphy API for channel and bitrate
registration and converts mac80211 and drivers to the new API. The
old mac80211 API is completely ripped out.

Along with the regulatory code I've also ripped out the
IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED flag, I believe it to be
unnecessary if the hardware simply gives us whatever channels it wants
to support and we then enable/disable them as required, which is pretty
much required for travelling.

Additionally, the patch adds proper "basic" rate handling for STA
mode interface, AP mode interface will have to have new API added
to allow userspace to set the basic rate set, currently it'll be
empty... However, the basic rate handling will need to be moved to
the BSS conf stuff.

---
 drivers/net/wireless/adm8211.c               |   80 ++--
 drivers/net/wireless/adm8211.h               |   65 ---
 drivers/net/wireless/b43/b43.h               |    5=20
 drivers/net/wireless/b43/main.c              |  162 ++++-----
 drivers/net/wireless/b43/sysfs.c             |   89 -----
 drivers/net/wireless/b43/xmit.c              |   73 ++--
 drivers/net/wireless/b43legacy/b43legacy.h   |    4=20
 drivers/net/wireless/b43legacy/main.c        |  159 ++++-----
 drivers/net/wireless/b43legacy/xmit.c        |   64 +--=20
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c   |   79 ++--
 drivers/net/wireless/iwlwifi/iwl-3945.c      |   35 --
 drivers/net/wireless/iwlwifi/iwl-3945.h      |   13=20
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c   |   82 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c      |   35 --
 drivers/net/wireless/iwlwifi/iwl-4965.h      |   13=20
 drivers/net/wireless/iwlwifi/iwl3945-base.c  |  445 +++++++---------------=
-----
 drivers/net/wireless/iwlwifi/iwl4965-base.c  |  438 ++++++----------------=
----
 drivers/net/wireless/p54.h                   |    4=20
 drivers/net/wireless/p54common.c             |   74 ++--
 drivers/net/wireless/p54common.h             |   75 ----
 drivers/net/wireless/rt2x00/rt2400pci.c      |    2  =20
 drivers/net/wireless/rt2x00/rt2500pci.c      |    4  =20
 drivers/net/wireless/rt2x00/rt2500usb.c      |    4  =20
 drivers/net/wireless/rt2x00/rt2x00.h         |   11  =20
 drivers/net/wireless/rt2x00/rt2x00config.c   |   37 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c      |  151 +++------
 drivers/net/wireless/rt2x00/rt61pci.c        |   27 -
 drivers/net/wireless/rt2x00/rt73usb.c        |   27 -
 drivers/net/wireless/rtl8180.h               |    2 =20
 drivers/net/wireless/rtl8180_dev.c           |   93 +++--
 drivers/net/wireless/rtl8180_grf5101.c       |    3=20
 drivers/net/wireless/rtl8180_max2820.c       |    5=20
 drivers/net/wireless/rtl8180_rtl8225.c       |   15=20
 drivers/net/wireless/rtl8180_sa2400.c        |    5=20
 drivers/net/wireless/rtl8187.h               |    2=20
 drivers/net/wireless/rtl8187_dev.c           |   84 +++--
 drivers/net/wireless/rtl8187_rtl8225.c       |    8=20
 drivers/net/wireless/rtl818x.h               |   70 ----
 drivers/net/wireless/zd1211rw/zd_chip.c      |   15=20
 drivers/net/wireless/zd1211rw/zd_ieee80211.c |   11=20
 drivers/net/wireless/zd1211rw/zd_mac.c       |  168 ++++------
 drivers/net/wireless/zd1211rw/zd_mac.h       |    2=20
 include/net/mac80211.h                       |  197 ++---------
 include/net/wireless.h                       |  168 ++++++++++=20
 net/mac80211/Makefile                        |    1=20
 net/mac80211/cfg.c                           |   11=20
 net/mac80211/debugfs.c                       |   47 --
 net/mac80211/debugfs_sta.c                   |   18 -=20
 net/mac80211/ieee80211.c                     |  112 ++----
 net/mac80211/ieee80211_i.h                   |   65 ---  =20
 net/mac80211/ieee80211_iface.c               |    2      =20
 net/mac80211/ieee80211_ioctl.c               |  131 ++++---
 net/mac80211/ieee80211_rate.c                |   20 -
 net/mac80211/ieee80211_rate.h                |   28 -
 net/mac80211/ieee80211_sta.c                 |  380 ++++++++++++----------=
-
 net/mac80211/rc80211_pid_algo.c              |   70 ++--
 net/mac80211/rc80211_simple.c                |   62 +--=20
 net/mac80211/regdomain.c                     |  152 ---------
 net/mac80211/rx.c                            |   56 +--
 net/mac80211/sta_info.c                      |   24 - =20
 net/mac80211/sta_info.h                      |   10   =20
 net/mac80211/tx.c                            |  162 ++++++---
 net/mac80211/util.c                          |  142 +-------=20
 net/wireless/Makefile                        |    2=20
 net/wireless/core.c                          |   41 ++
 net/wireless/core.h                          |    3  =20
 net/wireless/reg.c                           |  153 +++++++++
 net/wireless/util.c                          |   98 +++++
 68 files changed, 2102 insertions(+), 2793 deletions(-) =20


patch too large, please see

http://johannes.sipsolutions.net/patches/kernel/all/2007-12-28-21%3a44/023-=
cfg80211-channel-and-bitrate-api.patch



--=-5/iDVZTHeS1s3V0isCBT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3VvqKVg1VMiehFYAQKj8w//SgLWaeq3Uxhzc9mzSCrcsoIAEG2dDoL8
7RkbHKXBar33p1osxwC6LIy0zfvq2frxXjtnUO9sZmQ+Nz054FhfU6t0C61cZuol
6jtyAa3kYMqhvk43abR8cbpSY/YGCRXf7HbmXuFhAS7GJEwxsfG7RgKKbQKSIsVu
lif/PGsy71ERZ6ArLYjW0UEHTRub/5Xtug/CJl9+dyfg656MyfzepZ+UtCzZBWhR
QneWRwOzHmJTwlFC9vJOlLixT3YYxPQ3KCyXp8DHNUr1DUtt9ZhqD3z6WPqE/5Ob
s3azrB4SN7oZ3Mnh2+g026gXmAx5xiszK51q4usekzGGrD9ebfGui9RQXkWQuWL5
/SMu4Bt2Js0CCYnDD8xjQHYUZ1giyo9vLSHzH1ek4SloTN+OzD8rhnSqM0Khwkrl
YW65yI96/AdH2xpR5T1ecy4o3xLz6EsPg5ZHTEV7vHB54NzbdmaeT2gmGLXFDd8P
62TX8zxaME+9w7w9sVFUdmM87CdLSPwB2Nm+kLZUF9uqAiPv65FwE+K2iAKe2oYj
UuO1P3W8QAXdgsDWO5XP686+7D8hRBk5nXR5TmLND6HIPrL6aT403zxMW5JpauC5
6Q9fiYYvWxrjqRzRfD47TAbsTYZQdJJLbEr9/5ZHIKNVDUkci91LAqOh8aZq+EjS
bW/L1jcKaXs=
=9onq
-----END PGP SIGNATURE-----

--=-5/iDVZTHeS1s3V0isCBT--

