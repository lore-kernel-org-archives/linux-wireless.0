Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:55162 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757174AbXD0TyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 15:54:16 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH 10/13] mac80211: set bssid to broadcast before scan
Date: Fri, 27 Apr 2007 15:49:57 -0400
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <1177431851.3528.36.camel@johannes.berg> <20070427194015.602759a1@griffin.suse.cz>
In-Reply-To: <20070427194015.602759a1@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2148680.KI2KMkRjyB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704271550.01153.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2148680.KI2KMkRjyB
Content-Type: multipart/mixed;
  boundary="Boundary-01=_lPlMG8mkSAHQmT8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_lPlMG8mkSAHQmT8
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 27 April 2007 13:40, Jiri Benc wrote:
> I agree.
>
> And I'd like to see some way to disable this feature for sane cards.
>
Here you go.

Thanks,
-Michael Wu

--Boundary-01=_lPlMG8mkSAHQmT8
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="11-reset-bssid-before-scan.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="11-reset-bssid-before-scan.diff"

mac80211: set bssid to broadcast before scan

=46rom: Michael Wu <flamingice@sourmilk.net>

This patch sets the BSSID to broadcast before scanning to ensure that the
hardware filter does not filter probe responses.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 include/net/mac80211.h       |    4 ++++
 net/mac80211/ieee80211.c     |    7 ++++++-
 net/mac80211/ieee80211_sta.c |   11 +++++++++++
 3 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cade956..2da0d31 100644
=2D-- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -524,6 +524,10 @@ struct ieee80211_hw {
 	 * normal operation. */
 #define IEEE80211_HW_MONITOR_DURING_OPER (1<<9)
=20
+	/* Device does not need BSSID filter set to broadcast in order to
+	 * receive all probe responses while scanning */
+#define IEEE80211_HW_NO_PROBE_FILTERING (1<<10)
+
 	/* please fill this gap when adding new flags */
=20
 	/* calculate Michael MIC for an MSDU when doing hwcrypto */
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index f6a71ce..4976493 100644
=2D-- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -2015,6 +2015,7 @@ static int __ieee80211_if_config(struct net_device *d=
ev,
 	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_if_conf conf;
+	static const u8 scan_bssid[] =3D { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
=20
 	if (!local->ops->config_interface || !netif_running(dev))
 		return 0;
@@ -2023,7 +2024,11 @@ static int __ieee80211_if_config(struct net_device *=
dev,
 	conf.type =3D sdata->type;
 	if (sdata->type =3D=3D IEEE80211_IF_TYPE_STA ||
 	    sdata->type =3D=3D IEEE80211_IF_TYPE_IBSS) {
=2D		conf.bssid =3D sdata->u.sta.bssid;
+		if (local->sta_scanning &&
+		    local->scan_dev =3D=3D dev)
+			conf.bssid =3D scan_bssid;
+		else
+			conf.bssid =3D sdata->u.sta.bssid;
 		conf.ssid =3D sdata->u.sta.ssid;
 		conf.ssid_len =3D sdata->u.sta.ssid_len;
 		conf.generic_elem =3D sdata->u.sta.extra_ie;
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 7cb2dd3..d996412 100644
=2D-- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2577,6 +2577,11 @@ void ieee80211_scan_completed(struct ieee80211_hw *h=
w)
 		printk(KERN_DEBUG "%s: failed to restore operational"
 		       "channel after scan\n", dev->name);
=20
+	if (local->hw.flags & IEEE80211_HW_NO_PROBE_FILTERING ||
+	    ieee80211_if_config(dev))
+		printk(KERN_DEBUG "%s: failed to restore operational"
+		       "BSSID after scan\n", dev->name);
+
 	memset(&wrqu, 0, sizeof(wrqu));
 	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
=20
@@ -2736,6 +2741,12 @@ static int ieee80211_sta_start_scan(struct net_devic=
e *dev,
 					 list);
 	local->scan_channel_idx =3D 0;
 	local->scan_dev =3D dev;
+
+	if (local->hw.flags & IEEE80211_HW_NO_PROBE_FILTERING ||
+	    ieee80211_if_config(dev))
+		printk(KERN_DEBUG "%s: failed to set BSSID for scan\n",
+		       dev->name);
+
 	/* TODO: start scan as soon as all nullfunc frames are ACKed */
 	queue_delayed_work(local->hw.workqueue, &local->scan_work,
 			   IEEE80211_CHANNEL_TIME);

--Boundary-01=_lPlMG8mkSAHQmT8--

--nextPart2148680.KI2KMkRjyB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGMlPpT3Oqt9AH4aERAoA8AJ0f9Rc1kssbmVXl9UEho9mQC/r4ngCeJ/N8
waG0qIygYdTwjgs01DT/dE8=
=WLQB
-----END PGP SIGNATURE-----

--nextPart2148680.KI2KMkRjyB--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
