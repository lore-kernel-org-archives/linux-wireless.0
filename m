Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:18013 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751640AbXF2GOV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2007 02:14:21 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211/bcm43xx deadlock
Date: Thu, 28 Jun 2007 23:14:35 -0700
Cc: linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>
References: <1182848382.3830.5.camel@johannes.berg> <1182852849.3830.9.camel@johannes.berg>
In-Reply-To: <1182852849.3830.9.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1220430.4h6rXG7Tug";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706282314.41862.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1220430.4h6rXG7Tug
Content-Type: multipart/mixed;
  boundary="Boundary-01=_LNKhG0aTlh/a85P"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_LNKhG0aTlh/a85P
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 26 June 2007 03:14, Johannes Berg wrote:
> Got it. ieee80211_sta_config_auth is running off the workqueue and doing
> rtnl_lock while ieee80211_if_shutdown is trying to flush the workqueue
> with the rtnl lock held. Nice one, anybody have ideas how to fix? Why
> does ieee80211_sta_config_auth need to take the rtnl anyway?
>
There is potential for racing with userspace without that lock, but it's no=
t=20
very likely or dangerous, and deadlocking is a whole lot worse. Patch=20
attached to remove that locking for now until a better solution is found.

Thanks,
=2DMichael Wu

--Boundary-01=_LNKhG0aTlh/a85P
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="01-kill-rtnl-locking.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="01-kill-rtnl-locking.diff"

mac80211: remove rtnl locking in ieee80211_sta.c

=46rom: Michael Wu <flamingice@sourmilk.net>

The rtnl is held in ieee80211_sta.c to prevent some potential races with
userspace. Unfortunately, it also has the potential for deadlocks on
interface down. This patch removes the rtnl locking to eliminate the
deadlocks.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 net/mac80211/ieee80211_sta.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 91b545c..4862797 100644
=2D-- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -25,7 +25,6 @@
 #include <linux/wireless.h>
 #include <linux/random.h>
 #include <linux/etherdevice.h>
=2D#include <linux/rtnetlink.h>
 #include <net/iw_handler.h>
 #include <asm/types.h>
=20
@@ -2073,12 +2072,9 @@ static int ieee80211_sta_config_auth(struct net_devi=
ce *dev,
 	struct ieee80211_sta_bss *bss, *selected =3D NULL;
 	int top_rssi =3D 0, freq;
=20
=2D	rtnl_lock();
=2D
 	if (!ifsta->auto_channel_sel && !ifsta->auto_bssid_sel &&
 	    !ifsta->auto_ssid_sel) {
 		ifsta->state =3D IEEE80211_AUTHENTICATE;
=2D		rtnl_unlock();
 		ieee80211_sta_reset_auth(dev, ifsta);
 		return 0;
 	}
@@ -2121,7 +2117,6 @@ static int ieee80211_sta_config_auth(struct net_devic=
e *dev,
 		ieee80211_sta_set_bssid(dev, selected->bssid);
 		ieee80211_rx_bss_put(dev, selected);
 		ifsta->state =3D IEEE80211_AUTHENTICATE;
=2D		rtnl_unlock();
 		ieee80211_sta_reset_auth(dev, ifsta);
 		return 0;
 	} else {
@@ -2132,7 +2127,6 @@ static int ieee80211_sta_config_auth(struct net_devic=
e *dev,
 		} else
 			ifsta->state =3D IEEE80211_DISABLED;
 	}
=2D	rtnl_unlock();
 	return -1;
 }
=20

--Boundary-01=_LNKhG0aTlh/a85P--

--nextPart1220430.4h6rXG7Tug
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGhKNRT3Oqt9AH4aERAuyAAJwPBO84ZrJw0jL8JzPaxNpDGN+OCACgyOvF
0Z7P4AiMHwwezoCmLudzlAg=
=Pfi9
-----END PGP SIGNATURE-----

--nextPart1220430.4h6rXG7Tug--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
