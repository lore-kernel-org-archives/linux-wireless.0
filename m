Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:47900 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751486AbXBJRzs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Feb 2007 12:55:48 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: [PATCH] d80211: Make common function for frequency/channel selection
Date: Sat, 10 Feb 2007 12:55:17 -0500
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3653307.lR9xvcaeld";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702101255.21479.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3653307.lR9xvcaeld
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

d80211: Make common function for frequency/channel selection

This patch creates ieee80211_set_channel and moves the channel selection
and setting code in ieee80211_ioctl_siwfreq to this function. This allows
IBSS code in ieee80211_sta.c to set the channel without using the wireless
extensions interface.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 net/d80211/ieee80211_i.h     |    1 +
 net/d80211/ieee80211_ioctl.c |   47 ++++++++++++++++++++++----------------=
=2D---
 net/d80211/ieee80211_sta.c   |   10 +--------
 3 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/net/d80211/ieee80211_i.h b/net/d80211/ieee80211_i.h
index 60d0a22..fa42fb5 100644
=2D-- a/net/d80211/ieee80211_i.h
+++ b/net/d80211/ieee80211_i.h
@@ -660,6 +660,7 @@ void ieee80211_stop_scan(struct ieee8021
 int ieee80211_set_compression(struct ieee80211_local *local,
 			      struct net_device *dev, struct sta_info *sta);
 int ieee80211_init_client(struct net_device *dev);
+int ieee80211_set_channel(struct ieee80211_local *local, int channel, int =
freq);
 /* ieee80211_sta.c */
 void ieee80211_sta_timer(unsigned long data);
 void ieee80211_sta_work(struct work_struct *work);
diff --git a/net/d80211/ieee80211_ioctl.c b/net/d80211/ieee80211_ioctl.c
index c7300cb..0a1a5eb 100644
=2D-- a/net/d80211/ieee80211_ioctl.c
+++ b/net/d80211/ieee80211_ioctl.c
@@ -1794,35 +1794,18 @@ static int ieee80211_ioctl_giwmode(struc
 	return 0;
 }
=20
=2D
=2Dint ieee80211_ioctl_siwfreq(struct net_device *dev,
=2D			    struct iw_request_info *info,
=2D			    struct iw_freq *freq, char *extra)
+int ieee80211_set_channel(struct ieee80211_local *local, int channel, int =
freq)
 {
=2D	struct ieee80211_local *local =3D dev->ieee80211_ptr;
 	struct ieee80211_hw_mode *mode;
=2D	int c, nfreq, set =3D 0;
=2D
=2D	/* freq->e =3D=3D 0: freq->m =3D channel; otherwise freq =3D m * 10^e */
=2D	if (freq->e =3D=3D 0)
=2D		nfreq =3D -1;
=2D	else {
=2D		int i, div =3D 1000000;
=2D		for (i =3D 0; i < freq->e; i++)
=2D			div /=3D 10;
=2D		if (div > 0)
=2D			nfreq =3D freq->m / div;
=2D		else
=2D			return -EINVAL;
=2D	}
+	int c, set =3D 0;
=20
 	list_for_each_entry(mode, &local->modes_list, list) {
+		if (!(local->enabled_modes & (1 << mode->mode)))
+			continue;
 		for (c =3D 0; c < mode->num_channels; c++) {
 			struct ieee80211_channel *chan =3D &mode->channels[c];
 			if (chan->flag & IEEE80211_CHAN_W_SCAN &&
=2D			    ((freq->e =3D=3D 0 && chan->chan =3D=3D freq->m) ||
=2D			     (freq->e > 0 && nfreq =3D=3D chan->freq)) &&
=2D			    (local->enabled_modes & (1 << mode->mode))) {
+			    ((chan->chan =3D=3D channel) || (chan->freq =3D=3D freq))) {
 				/* Use next_mode as the mode preference to
 				 * resolve non-unique channel numbers. */
 				if (set && mode->mode !=3D local->next_mode)
@@ -1845,6 +1828,26 @@ int ieee80211_ioctl_siwfreq(struct net_d
 	return -EINVAL;
 }
=20
+static int ieee80211_ioctl_siwfreq(struct net_device *dev,
+				   struct iw_request_info *info,
+				   struct iw_freq *freq, char *extra)
+{
+	struct ieee80211_local *local =3D dev->ieee80211_ptr;
+
+	/* freq->e =3D=3D 0: freq->m =3D channel; otherwise freq =3D m * 10^e */
+	if (freq->e =3D=3D 0)
+		return ieee80211_set_channel(local, freq->m, -1);
+	else {
+		int i, div =3D 1000000;
+		for (i =3D 0; i < freq->e; i++)
+			div /=3D 10;
+		if (div > 0)
+			return ieee80211_set_channel(local, -1, freq->m / div);
+		else
+			return -EINVAL;
+	}
+}
+
=20
 static int ieee80211_ioctl_giwfreq(struct net_device *dev,
 				   struct iw_request_info *info,
diff --git a/net/d80211/ieee80211_sta.c b/net/d80211/ieee80211_sta.c
index a883384..0b56135 100644
=2D-- a/net/d80211/ieee80211_sta.c
+++ b/net/d80211/ieee80211_sta.c
@@ -2004,16 +2004,11 @@ static void ieee80211_sta_new_auth(struc
 }
=20
=20
=2Dextern int ieee80211_ioctl_siwfreq(struct net_device *dev,
=2D				   struct iw_request_info *info,
=2D				   struct iw_freq *freq, char *extra);
=2D
 static int ieee80211_sta_join_ibss(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta,
 				   struct ieee80211_sta_bss *bss)
 {
 	struct ieee80211_local *local =3D dev->ieee80211_ptr;
=2D	struct iw_freq rq;
 	int res, rates, i, j;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
@@ -2041,10 +2036,7 @@ static int ieee80211_sta_join_ibss(struc
 	sdata->drop_unencrypted =3D bss->capability &
 		WLAN_CAPABILITY_PRIVACY ? 1 : 0;
=20
=2D	memset(&rq, 0, sizeof(rq));
=2D	rq.m =3D bss->freq * 100000;
=2D	rq.e =3D 1;
=2D	res =3D ieee80211_ioctl_siwfreq(dev, NULL, &rq, NULL);
+	res =3D ieee80211_set_channel(local, -1, bss->freq);
=20
 	if (!(local->oper_channel->flag & IEEE80211_CHAN_W_IBSS)) {
 		printk(KERN_DEBUG "%s: IBSS not allowed on channel %d "

--nextPart3653307.lR9xvcaeld
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFzgcJT3Oqt9AH4aERAg6bAJ9WLVaIKtw/gOkmHgbX1ZSGg+mE0wCgoLXA
g2H3j0FoxRDmZ38xdfOx+Jw=
=YbkL
-----END PGP SIGNATURE-----

--nextPart3653307.lR9xvcaeld--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
